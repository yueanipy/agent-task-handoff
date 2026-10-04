[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')]
    [string]$ThreadId,
    [string]$ExpectedModel,
    [string]$ExpectedEffort,
    [System.DateTimeOffset]$NotBeforeUtc = [System.DateTimeOffset]::MinValue,
    [ValidatePattern('^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')]
    [string]$ExpectedTurnId
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-Field($Object, [string]$Name) {
    if ($null -eq $Object) { return $null }
    $property = $Object.PSObject.Properties[$Name]
    if ($null -ne $property) { return $property.Value }
}

function ConvertTo-Utc($Value) {
    if ($Value -is [DateTimeOffset]) { return $Value.ToUniversalTime() }
    if ($Value -is [DateTime]) {
        if ($Value.Kind -eq [DateTimeKind]::Unspecified) {
            throw 'Timestamp has lost its timezone; recorded identity is unverifiable.'
        }
        return ([DateTimeOffset]$Value).ToUniversalTime()
    }
    if ([string]::IsNullOrWhiteSpace([string]$Value)) { throw 'Missing rollout timestamp.' }
    return [DateTimeOffset]::Parse(
        [string]$Value, [Globalization.CultureInfo]::InvariantCulture,
        [Globalization.DateTimeStyles]::AssumeUniversal
    ).ToUniversalTime()
}

# Preserve offsets/fractions on new PowerShell; never stringify DateTime on older hosts.
$jsonOptions = @{ ErrorAction = 'Stop' }
if ((Get-Command ConvertFrom-Json).Parameters.ContainsKey('DateKind')) {
    $jsonOptions.DateKind = 'String'
}

$codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path ([Environment]::GetFolderPath('UserProfile')) '.codex' }
$sessions = Join-Path $codexHome 'sessions'
if (-not (Test-Path -LiteralPath $sessions -PathType Container)) {
    throw 'Codex sessions directory is unavailable.'
}

# Segment suffixes identify storage chunks, not necessarily their actual turn IDs.
$suffix = '-' + [regex]::Escape($ThreadId) + '(?:_[0-9a-fA-F-]{36})?\.jsonl$'
$files = @(Get-ChildItem -LiteralPath $sessions -Recurse -File -Filter "*-$ThreadId*.jsonl" |
    Where-Object { $_.Name -match $suffix })
if ($files.Count -eq 0) { throw "No rollout for $ThreadId." }

$latest = $null
$newestStart = [DateTimeOffset]::MinValue
foreach ($file in $files) {
    $stream = [IO.File]::Open($file.FullName, [IO.FileMode]::Open,
        [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    $reader = [IO.StreamReader]::new($stream, [Text.Encoding]::UTF8)
    try {
        $meta = $reader.ReadLine() | ConvertFrom-Json @jsonOptions
        $metaPayload = Get-Field $meta 'payload'
        if ((Get-Field $meta 'type') -ne 'session_meta' -or
            -not [string]::Equals([string](Get-Field $metaPayload 'id'), $ThreadId,
                [StringComparison]::OrdinalIgnoreCase)) {
            throw "Rollout metadata does not confirm thread $ThreadId in $($file.Name)."
        }
        $start = ConvertTo-Utc (Get-Field $meta 'timestamp')
        if ($start -gt $newestStart) { $newestStart = $start }
        $unparsedContext = $false
        while (-not $reader.EndOfStream) {
            $line = $reader.ReadLine()
            if ($line -notmatch '"type"\s*:\s*"turn_context"') { continue }
            try { $record = $line | ConvertFrom-Json @jsonOptions }
            catch { $unparsedContext = $true; continue }
            if ((Get-Field $record 'type') -ne 'turn_context') { continue }
            $unparsedContext = $false
            $time = ConvertTo-Utc (Get-Field $record 'timestamp')
            $payload = Get-Field $record 'payload'
            $candidate = [pscustomobject]@{
                timestamp = $time
                model = [string](Get-Field $payload 'model')
                effort = [string](Get-Field $payload 'effort')
                turnId = [string](Get-Field $payload 'turn_id')
                rollout = $file.FullName
            }
            if ($null -eq $latest -or $time -gt $latest.timestamp) { $latest = $candidate }
            elseif ($time -eq $latest.timestamp -and
                ($candidate.model -ne $latest.model -or $candidate.effort -ne $latest.effort -or
                 $candidate.turnId -ne $latest.turnId)) {
                throw 'Conflicting turn identities at the same recorded timestamp.'
            }
        }
        if ($unparsedContext) {
            throw "Trailing unreadable turn_context in $($file.Name); do not reuse stale identity."
        }
    } finally { $reader.Dispose() }
}
if ($null -eq $latest -or $latest.timestamp -lt $newestStart) {
    throw "No current turn_context for the newest rollout of $ThreadId."
}
if (-not $latest.model -or -not $latest.effort) {
    throw 'Current turn_context lacks model/effort; identity is unverifiable.'
}

# Select latest recorded identity first, never an older context matching expectations.
$matchesTurn = -not $ExpectedTurnId -or
    [string]::Equals($latest.turnId, $ExpectedTurnId, [StringComparison]::OrdinalIgnoreCase)
$fresh = $latest.timestamp -ge $NotBeforeUtc.ToUniversalTime()
$matchesModel = -not $ExpectedModel -or
    [string]::Equals($latest.model, $ExpectedModel, [StringComparison]::OrdinalIgnoreCase)
$matchesEffort = -not $ExpectedEffort -or
    [string]::Equals($latest.effort, $ExpectedEffort, [StringComparison]::OrdinalIgnoreCase)

[pscustomobject]@{
    threadId = $ThreadId
    model = $latest.model
    effort = $latest.effort
    turnId = $latest.turnId
    turnContextUtc = $latest.timestamp.ToString('o')
    rollout = $latest.rollout
    fresh = $fresh
    matchesTurn = $matchesTurn
    matchesExpected = ($matchesModel -and $matchesEffort -and $matchesTurn)
} | ConvertTo-Json -Compress

if (-not $matchesTurn) { exit 4 }
if (-not $fresh) { exit 3 }
if (-not ($matchesModel -and $matchesEffort)) { exit 2 }
exit 0

[CmdletBinding()]
param([string]$Root = (Join-Path $PSScriptRoot '../..'))

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Root = (Resolve-Path -LiteralPath $Root).Path
$PluginRoot = Join-Path $Root 'plugins/agent-task-handoff'
$manifest = Get-Content -LiteralPath (Join-Path $PluginRoot 'plugin.json') -Raw | ConvertFrom-Json
if ($manifest.name -ne 'agent-task-handoff' -or $manifest.version -notmatch '^\d+\.\d+\.\d+$') {
    throw 'Invalid plugin identity/version.'
}
if ($manifest.extensions.'com.openai'.author.name -ne 'yueanipy') {
    throw 'The package must have its single declared author.'
}
$marketplace = Get-Content -LiteralPath (Join-Path $Root '.agents/plugins/marketplace.json') -Raw | ConvertFrom-Json
if ($marketplace.name -ne 'codex-agent-task-handoff' -or @($marketplace.plugins).Count -ne 1) {
    throw 'Expected a single-plugin marketplace.'
}
if ($marketplace.plugins[0].name -ne $manifest.name -or
    $marketplace.plugins[0].source.source -ne 'local' -or
    $marketplace.plugins[0].source.path -ne './plugins/agent-task-handoff') {
    throw 'Marketplace entry does not point at the isolated plugin directory.'
}
$expectedSkills = @('architect-implementer', 'independent-review', 'sol-luna-mechanical')
$actualSkills = @(Get-ChildItem -LiteralPath (Join-Path $PluginRoot 'skills') -Directory | ForEach-Object Name)
if (@(Compare-Object $expectedSkills $actualSkills).Count) { throw 'Unexpected skill set.' }
$runtime = @(Get-Item -LiteralPath (Join-Path $PluginRoot 'plugin.json')) +
    @(Get-ChildItem -LiteralPath (Join-Path $PluginRoot 'skills') -Recurse -File)
$links = 0
foreach ($file in $runtime) {
    $text = Get-Content -LiteralPath $file.FullName -Raw
    if ($text -match '[\u3400-\u4DBF\u4E00-\u9FFF]') {
        throw "Non-English runtime text: $($file.FullName)"
    }
    if ($text -match '(?i)(\b[A-Z]:[\\/]|DESKTOP-[A-Z0-9]+|Co-authored-by:)') {
        throw "Machine-specific path/name or additional attribution: $($file.FullName)"
    }
    if ($file.Extension -ne '.md') { continue }
    foreach ($match in [regex]::Matches($text, '\[[^\]]+\]\(([^)]+)\)')) {
        $target = $match.Groups[1].Value
        if ($target -match '^(https?://|#)') { continue }
        $target = ($target -split '#', 2)[0]
        $resolved = [IO.Path]::GetFullPath((Join-Path $file.DirectoryName $target))
        if (-not $resolved.StartsWith($PluginRoot + [IO.Path]::DirectorySeparatorChar,
            [StringComparison]::OrdinalIgnoreCase) -or -not (Test-Path -LiteralPath $resolved)) {
            throw "Invalid package reference: $($file.Name) -> $target"
        }
        $links++
    }
}
foreach ($name in $expectedSkills) {
    $skill = Get-Content -LiteralPath (Join-Path $PluginRoot "skills/$name/SKILL.md") -Raw
    if ($skill -notmatch '(?s)^---\r?\n.*?\r?\n---\r?\n' -or
        $skill -notmatch "(?m)^name: $([regex]::Escape($name))\s*$" -or
        $skill -notmatch '(?m)^description: \S.+$') { throw "Invalid skill metadata: $name" }
    $yaml = Get-Content -LiteralPath (Join-Path $PluginRoot "skills/$name/agents/openai.yaml") -Raw
    $policy = if ($name -eq 'sol-luna-mechanical') { 'false' } else { 'true' }
    if ($yaml -notmatch "allow_implicit_invocation: $policy" -or
        -not $yaml.Contains('$agent-task-handoff:' + $name)) { throw "Invalid invocation policy: $name" }
}
foreach ($pair in @(@('README.md', 'README.zh-CN.md'), @('README.zh-CN.md', 'README.md'))) {
    $readme = Get-Content -LiteralPath (Join-Path $Root $pair[0]) -Raw
    if (-not $readme.Contains('](' + $pair[1] + ')')) { throw 'Missing README language switch.' }
}
foreach ($file in Get-ChildItem -LiteralPath $Root -Recurse -Filter '*.ps1' -File) {
    $tokens = $null; $errors = $null
    [Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$errors) | Out-Null
    if (@($errors).Count) { throw "Invalid PowerShell syntax: $($file.FullName)" }
}
[pscustomobject]@{
    result = 'PASS'
    version = $manifest.version
    author = $manifest.extensions.'com.openai'.author.name
    skills = $actualSkills
    runtimeFiles = $runtime.Count
    internalReferences = $links
    modelTurnsStarted = 0
} | ConvertTo-Json

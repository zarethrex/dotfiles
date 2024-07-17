$NvimDestination = "$env:LOCALAPPDATA/nvim/"
$AlacrittyDestination = "$env:APPDATA/alacritty"
robocopy /s $PSScriptRoot/nvim/ $NvimDestination/
New-Item -ItemType Directory -Force -Path $AlacrittyDestination
robocopy $PSScriptRoot/alacritty/ $AlacrittyDestination/

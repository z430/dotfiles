# terminal setting directory
terminal_path="$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# install c and c++ compiler
winget install Microsoft.VisualStudio.2022.BuildTools

winget install Microsoft.VisualStudio.2022.Community

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
scoop bucket add extras
scoop install extras/obsidian
scoop install curl sudo jq neovim gcc
winget install -e --id Git.Git

Install-Module posh-git -Scope CurrentUser -Force
scoop install https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh.json
Install-Module -Name Terminal-Icons -Repository PSGallery -Force
Install-Module -Name z -Force
Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck
scoop install main/fzf
Install-Module -Name PSFzf -Scope CurrentUSer -Force
Install-Module -Name PowerColorLS -Repository PSGallery

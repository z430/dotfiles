# Attempt to set the execution policy to RemoteSigned for the current user
# This allows locally created scripts to run, and scripts from the internet to run if they are signed by a trusted publisher
try {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -ErrorAction Stop
    Write-Output "Execution policy set to RemoteSigned."
}
catch {
    Write-Output "Could not set execution policy. You might need to run this script as an Administrator or check your system's policies if you're in a restricted environment."
}

# install Chocolatey if not installed
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Ensure Chocolatey is up to date
choco upgrade chocolatey -y

# Install development tools
choco install mingw -y # C and C++ Compiler (GCC)
choco install golang -y # Golang
choco install nodejs -y # NodeJS and npm
choco install rust -y # Rust
choco install miniconda3 -y # Miniconda3

# Install terminal tools
choco install neovim -y # Neovim
choco install git -y # Git
choco install fzf -y # Fuzzy Finder
choco install curl -y # Curl
choco install sudo -y # Sudo
choco install jq -y # jq
choco install oh-my-posh -y # Oh My Posh
choco install poshgit -y # Posh-Git

Install-Module -Name Terminal-Icons -Repository PSGallery
Install-Module -Name z
Install-Module -Name PSReadLine -AllowPrerelease
Install-Module -Name PowerColorLS


# Install productivity tools
choco install docker-desktop -y # Docker Desktop for Windows
choco install vscode -y # Visual Studio Code
choco install wezterm -y # WezTerm
choco install obsidian -y # Obsidian

# Install utilities
choco install 7zip -y # 7-Zip
choco install vlc -y # VLC Media Player
choco install notepadplusplus -y # Notepad++
choco install windirstat -y # WinDirStat
choco install powertoys -y # PowerToys

# copy the configuration files to $HOME/.config
mkdir -Force $env:USERPROFILE\.config
Copy-Item powershell\user_profile.ps1 $env:USERPROFILE\.config\user_profile.ps1
Copy-Item  powershell\powerline.omp.json $env:USERPROFILE\.config\powerline.omp.json


# check if $PROFILE exists
if (!(Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force
}

# add content to $PROFILE
Add-Content -Path $PROFILE -Value ". `"$env:USERPROFILE\.config\powershell\user_profile.ps1`""

# copy wezterm configuration
Copy-Item wezterm\wezterm.lua $env:USERPROFILE\.wezterm.lua

# install scoop
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# install nerd fonts
scoop bucket add nerd-fonts
scoop install FiraCode-NF-Mono
scoop install Hack-NF
scoop install JetBrainsMono-NF
sudo apt update
sudo apt upgrade
sudo apt install -y python3 python3-pip python3-venv unzip build-essential \
	zsh fd-find pipx tmux curl bat zsh

curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash -
sudo apt-get install -y nodejs aptitude
sudo aptitude install -y npm

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install tree-sitter-cli

# install golang
curl -OL https://go.dev/dl/go1.21.6.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz

# install oh-my-zsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install fuse
sudo apt-get -y install fuse libfuse2 lazygit

# install neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim

# install miniconda
# wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
# bash Miniconda3-latest-Linux-x86_64.sh

# config oh-my-zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/fdellwing/zsh-bat.git $ZSH_CUSTOM/plugins/zsh-bat

# cp wezterm/.wezterm.lua /mnt/c/Users/$(whoami)/.wezterm.lua
cp c-zsh/.zshrc ~/.zshrc

# copy zellij config
mkdir -p ~/.config/zellij
cp -r c-zellij/ ~/.config/zellij

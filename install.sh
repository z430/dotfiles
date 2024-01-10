sudo apt update
sudo apt install -y python3 python3-pip python3-venv unzip build-essential nodejs npm \
	zsh fd-find pipx

sudo apt install -y zsh
# install zsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install fuse
sudo apt-get -y install fuse libfuse2

# download neovim
wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage

# create bin dir
mkdir -p $HOME/.local/bin

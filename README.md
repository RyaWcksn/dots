# Dotfile

## Usage

### Prepare required depedency

```sh
sudo apt-get install stow
```

```sh
git clone git@github.com:RyaWcksn/dots.git
```

```sh
git clone https://github.com/RyaWcksn/dots
```

```sh
sudo apt install curl
sh <(curl -L https://nixos.org/nix/install) --daemon
nix flake update
nix run home-manager -- switch --flake .#arya
nix-channel --add https://github.com/nix-community/nixGL/archive/main.tar.gz nixgl && nix-channel --update
nix-env -iA nixgl.auto.nixGLDefault
```

Additional dependency

- Docker
- Kubernetes
- Golang 

### Symlink the configs

```sh
stow .
```

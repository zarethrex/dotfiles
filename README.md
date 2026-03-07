# Dot Files

This is my collection of dotfiles used to setup my Linux/Windows development environments.

## Requirements

- [Terminal Environment](#terminal-environment)
- [Command Line Apps](#command-line-apps)

### Terminal Environment

#### [`wezterm`](https://wezterm.org/)

##### Debian

```sh
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
sudo apt update
sudo apt install wezterm
```

##### RHEL

```sh
sudo dnf install -y https://github.com/wezterm/wezterm/releases/download/20240203-110809-5046fc22/wezterm-20240203_110809_5046fc22-1.fedora39.x86_64.rpm
```

#### `zsh`

##### Debian

```sh
sudo apt install -y zsh
```

##### RHEL

```sh
sudo dnf install -y zsh
```

#### [`oh-my-zsh`](https://github.com/ohmyzsh/ohmyzsh)

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

#### [`starship`](https://starship.rs/)

```sh
curl -sS https://starship.rs/install.sh | sh
```

### Command Line Apps

#### [`uv`](https://docs.astral.sh/uv/)

Used for creating Python environments, I also use it to make a user wide Python install.

```sh
curl -LsSf https://astral.sh/uv/install.sh | sh
uv venv --python=<python-version> $HOME/.venv
```

#### [`fzf`](https://github.com/junegunn/fzf)

##### Debian

```sh
sudo apt install -y fzf
```

##### RHEL

```sh
sudo dnf install -y fzf
```

#### [`icdiff`](https://github.com/jeffkaufman/icdiff)

```sh
uv tool install icdiff
```

#### Ansible

```sh
uv tool install ansible --with-executable molecule,ansible-lint,ansible-navigator,boto3,requests,jsonschema
```

#### [`gping`](https://github.com/orf/gping)

##### Debian

```sh
echo 'deb [signed-by=/usr/share/keyrings/azlux.gpg] https://packages.azlux.fr/debian/ bookworm main' | sudo tee /etc/apt/sources.list.d/azlux.list
sudo apt install gpg
curl -s https://azlux.fr/repo.gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/azlux.gpg > /dev/null
sudo apt update
sudo apt install gping
```

##### RHEL

```sh
sudo dnf install -y gping
```

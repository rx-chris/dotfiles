## README

```bash
# enter dotfiles directory after cloning repository
cd ~/dotfiles
```

Copy the example .env file and update GIT_USERNAME and GIT_EMAIL

```bash
cp .env.example .env
```

Bootstrap `git` and `zsh`

```bash
# copy the generated public key and upload to github
# restart the terminal to use zsh as default shell
./bootstrap.sh git zsh
```

Bootstrap remaining packages

```bash
./bootstrap.sh nvim tmux nvm
```

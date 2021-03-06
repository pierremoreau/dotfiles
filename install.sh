#!/bin/bash

override=false
verbose=false

if [[ "${1}" = '-f' || "${2}" = '-f' ]];
then
  override=true
fi
if [[ "${1}" = '-v' || "${2}" = '-v' ]];
then
  verbose=true
fi

[[ -z "${XDG_CONFIG_HOME}" ]] &&
  CONFIG_HOME="${HOME}/.config" ||
  CONFIG_HOME="${XDG_CONFIG_HOME}"
[[ -z "${XDG_DATA_HOME}" ]] &&
  DATA_HOME="${HOME}/.local" ||
  DATA_HOME="${XDG_DATA_HOME}"

function link_xdg()
{
  [[ "${verbose}" = true ]] && verbose_ln='-v' || verbose_ln=''
  if [[ -d "${CONFIG_HOME}/${1}" && "${override}" = false ]]
  then
    echo "Failed to link '${1}': already existing ('-f' for overwrite)"
  else
    [[ "${verbose}" = true ]] && echo "Linking '${1}'"
    ln -s -f ${verbose_ln} -t "${CONFIG_HOME}" "${PWD}/${1}"
  fi
}

function link_xdg_data()
{
  [[ "${verbose}" = true ]] && verbose_ln='-v' || verbose_ln=''
  if [[ -d "${DATA_HOME}/${1}" && "${override}" = false ]]
  then
    echo "Failed to link '${1}': already existing ('-f' for overwrite)"
  else
    [[ "${verbose}" = true ]] && echo "Linking '${1}'"
    ln -s -f ${verbose_ln} -t "${DATA_HOME}" "${PWD}/${1}"
  fi
}

function link_dot()
{
  [[ "${verbose}" = true ]] && verbose_ln='-v' || verbose_ln=''
  if [[ -f "${HOME}/.${1}" && "${override}" = false ]]
  then
    echo "Failed to link '${1}': already existing ('-f' for overwrite)"
  else
    [[ "${verbose}" = true ]] && echo "Linking '${1}'"
    ln -s -f ${verbose_ln} "${PWD}/${2}/${1}" "${HOME}/.${1}"
  fi
}

# Setup Git
link_xdg "git"

# Setup Neovim
link_xdg "nvim"
curl -sS -fLo ${DATA_HOME}/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "Neovim has been set up, but you will need to manually call" \
  "\`:PlugInstall()\` to install the plug-ins"

# Setup Vim
link_xdg "vim"
curl -sS -fLo ${DATA_HOME}/vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo ":set runtimepath+=${XDG_CONFIG_HOME}/vim,${XDG_CONFIG_HOME}/vim/after
:set packpath+=${XDG_DATA_HOME}/vim/pack
source ${XDG_CONFIG_HOME}/vim/vimrc" > ${HOME}/.vimrc
echo "Vim has been set up, but you will need to manually call" \
  "\`:PlugInstall()\` to install the plug-ins"

# Setup Weechat
link_xdg "weechat"
# cd ~/.weechat/python/autoload; wget https://raw.githubusercontent.com/kattrali/weemoji/master/weemoji.py

# Setup XDG
link_xdg "user-dirs.dirs"

# Setup Zsh
link_dot "zshrc" "zsh"

# Add scripts for emails
link_xdg_data "mailpop.py"

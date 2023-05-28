#!/usr/bin/env bash

if [ -f ${HOME}/.terraformrc ] ; then 
  if cmp -s ${HOME}/.terraformrc ./yandex_provider.example ; then
    echo $'\n'Yandex provider configuration good!
    echo --------------------------------------------------------------$'\n'
  else
  echo Type your sudo password:' '
  read -s $passwd
  echo $passwd | mv ${HOME}/.terraformrc ${HOME}/.terraformrc.old 
  echo $passwd | cp ./yandex_provider.example ${HOME}/.terraformrc
  fi
fi
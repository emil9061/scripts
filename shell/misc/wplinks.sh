#!/bin/bash

# Bind wallpaper to lockscreen and browser background
wallp=`cat $HOME/.config/nitrogen/bg-saved.cfg | grep file | cut -c 6-`
sudo ln -s --force $wallp /usr/share/slim/themes/default/background.jpg
ln -s --force $wallp $HOME/.config/vivaldi/wallpaper/background.jpg


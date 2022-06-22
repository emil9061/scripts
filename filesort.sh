#!/bin/bash

DIR="$HOME/downloads"

sort_file(){
    file=$(echo $1 | awk '{print $3}')

    # sort by file type
    case ${file##*.} in

        "png" | "jp"*"g"  )
            [[ $file = "wallhaven"* ]] && mv $DIR/$file $HOME/pictures/wallpaper \
            || mv $DIR/$file $HOME/pictures ;;

        "flac" | "mp3" | "wav" )
            mv $DIR/$file $HOME/music ;;

        "pdf" | "epub" | "doc"* | "ppt"* | "xls"* )
            mv $DIR/$file $HOME/documents ;;

        "mp4" | "webm" | "gif" )
            mv $DIR/$file $HOME/videos ;;

    esac
}

inotifywait -e create,moved_to -m -r $DIR | \
( while read; do sort_file "$REPLY"; done )

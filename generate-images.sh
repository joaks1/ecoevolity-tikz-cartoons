#! /usr/bin/env bash

for texfile in model-cartoons*.tex
do
    for graphicline in $(grep "beginpgfgraphicnamed" "$texfile")
    do
        jobname="${graphicline#*\{}"
        jobname="${jobname%*\}}"
        echo $jobname
        pdfpath="${jobname}.pdf"
        svgpath="${jobname}.svg"
        pngpath="${jobname}.png"
        logpath="${jobname}.log"
        dir="$(dirname $jobname)"
        if [ -n "$dir" ]
        then
            if [ ! -e "$dir" ]
            then
                mkdir -p "$dir"
            fi
        fi

        pdflatex "--jobname=$jobname" "$texfile"
        pdfcrop "$pdfpath" "$pdfpath"
        pdf2svg "$pdfpath" "$svgpath"
        if [ -n "$(echo "$jobname" | grep "island")" ]
        then
            convert -density 300 "$pdfpath" -flatten -strip -resize 1024 "$pngpath"
        fi
        rm "$logpath"
    done
done

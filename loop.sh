#!/bin/bash


## try to open viewer on another display by default (on my windows pc)
if [ $HOSTNAME == "hades53" ]; then export DISPLAY=depc361:0.0 ; fi



# the name of your main .tex-file that shall be compiled by pdflatex
maintexfile="./slides.tex"
#viewer="xreader"
viewer="xdg-open"
latextimeout=15

# pdf file is called like main tex file ... but .pdf
mainpdffile=$(echo $maintexfile | sed 's/.tex$/.pdf/')



if [ -e "$mainpdffile" ]; then
  $viewer $mainpdffile&
else
  pdflatex $maintexfile
  $viewer $mainpdffile&
fi


# files for "short-time-memory", watching changes
new="./loop.new"
old="./loop.old"


# the eternal watch/compile loop
while [ 1 -eq 1 ]
do





cat $new > $old

> $new
for i in $( find -L . -type f \( -iname "*" ! -path "*Link to*" ! -path "*.git*" \) | egrep '\.tex$|\.jpeg$|\.jpg$|\.png$|\.svg$|\.prn$|\.odg')
do
ls -l --time-style=+%Y%M%D%H%M%S $i >> $new
done

if [ "$(diff $old $new)" != "" ]; then


## convert new/changed svgs to pdf
for j in $(diff $old $new | egrep '^> '| egrep '\.svg$' | perl -pi -e 's/.*\s(?=\S+$)//g')
do
inkscape $j --export-pdf=$(echo $j | sed 's/.svg//g')'.pdf' -D
done


## convert new/changed LTspice schematic plots to pdf
for j in $(diff $old $new | egrep '^> '| egrep '\.prn$' | perl -pi -e 's/.*\s(?=\S+$)//g')
do
in=$j
out=$(echo $j | sed 's/.prn//g')'.pdf'
ps2pdf $in $out
#remove bottom line
pdfcrop --margins "0 0 0 -20"  $out $out
pdfcrop  $out $out
done


# ## open office illustrator auto convert to pdf ... who needs that, comment out
# for j in $(diff $old $new | egrep '^> '| egrep '\.odg$' | perl -pi -e 's/.*\s(?=\S+$)//g')
# do
# soffice "-env:UserInstallation=file:///tmp/LibO_Conversion" --headless --convert-to pdf:draw_pdf_Export $j 
# pdf_file=$(echo $j | sed 's/.odg//g')'.pdf'
# pdfcrop $pdf_file $pdf_file
# done


#pdflatex $maintexfile && pdflatex $maintexfile ## run twice for update of table of contents
pdflatex $maintexfile
fi 



## if installed, use inotifywait to watch folder for changes, save CPU power
if [ -n "$(which inotifywait)" ]; then
  ## blocks execution unless a file changes
  inotifywait -r -q -e modify,delete,create .
#  echo "#####################################################"
#  echo "      source files have changed, recompile!"
#  echo "#####################################################"
  sleep 1
else
## if not installed, re-scan folder every 2 seconds
  echo "#####################################################"
  echo "please consider installing inotify-tools"
  echo "for efficient watching of modifications"
  echo "#####################################################"
  sleep 2
fi



done

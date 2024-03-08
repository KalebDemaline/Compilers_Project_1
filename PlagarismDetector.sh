#!/bin/bash
# Jansen Craft & Kaleb Demaline

FILES=./"$1"/*
dirEntered="$1"
len=${#dirEntered}
len=$(($len+3))
rm tokens.txt
for f in $FILES
do
  echo "Tokenizing ${f:len} file..."
  # take action on each file. $f store current file name
	touch scanner_out.txt tokens.txt
	./scanner < $f > scanner_out.txt
	echo -ne "${f:len}">>tokens.txt
	echo -ne " ">>tokens.txt
	cat scanner_out.txt >> tokens.txt
	echo "">>tokens.txt
done
echo "Detecting Plagarism, this may take a few minutes."
./cmos < tokens.txt > PlagarismReport.txt
echo "Done. Results stored in PlagarismReport.txt"
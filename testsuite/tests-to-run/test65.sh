#!/bin/bash

# -L1 will join lines ending in ' '
cat <<'EOF' | sed -e s/\$SERVER1/$SERVER1/\;s/\$SERVER2/$SERVER2/ | parallel -j10 -k -L1
EOF

echo "### Test memory consumption stays (almost) the same for 30 and 300 jobs";
out30=$( stdout memusg parallel -j2 true :::: <(perl -e '$a="x"x100000;for(1..30){print $a,"\n"}') );
out300=$( stdout memusg parallel -j2 true :::: <(perl -e '$a="x"x100000;for(1..300){print $a,"\n"}') );
mem30=$(echo $out30 | tr -cd 0-9);
mem300=$(echo $out300 | tr -cd 0-9);
echo "Test if memory consumption(300 jobs) < memory consumption(30 jobs) * 150% ";
echo $(($mem300*100 < $mem30 * 150))

echo "### Test --header with -N";
(echo h1; echo h2; echo 1a;echo 1b; echo 2a;echo 2b; echo 3a)| parallel -j1 --pipe -N2 -k --header '\n.*\n' echo Start\;cat \; echo Stop

echo "### Test --header with --block 1k";
(echo h1; echo h2; perl -e '$a="x"x110;for(1..22){print $_,$a,"\n"'})| parallel -j1 --pipe -k --block 1k --header '\n.*\n' echo Start\;cat \; echo Stop

echo "### Test --header with multiple :::"
parallel --header : echo {a} {b} {1} {2} ::: b b1 ::: a a2

echo '### Test --shellquote'
cat <<'_EOF' | parallel --shellquote  
awk -v FS="\",\"" '{print $1, $3, $4, $5, $9, $14}' | grep -v "#" | sed -e '1d' -e 's/\"//g' -e 's/\/\/\//\t/g' | cut -f1-6,11 | sed -e 's/\/\//\t/g' -e 's/ /\t/g
_EOF
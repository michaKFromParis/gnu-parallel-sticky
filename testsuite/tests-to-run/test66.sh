#!/bin/bash

echo "### Test : as delimiter. This can be confusing for uptime ie. --load";
parallel -k --load 100% -d : echo ::: a:b:c

export PARALLEL="--load 100%"
echo PARALLEL=$PARALLEL

for i in $(seq 2 10); do
  i2=$[i*i]
  seq $i2 | parallel -j0 --load 100% -kX echo {} |wc
  seq 1 ${i2}0000 | nice parallel -kj20 --recend "\n" --spreadstdin gzip -9 | zcat | sort -n | md5sum
done

echo "### Test if --load blocks. Bug.";
seq 1 1000 | parallel -kj2 --load 100% --recend "\n" --spreadstdin gzip -9 | zcat | sort -n | md5sum
seq 1 1000 | parallel -kj0 --load 100% --recend "\n" --spreadstdin gzip -9 | zcat | sort -n | md5sum

seq 1 1000000 | parallel -kj0 --recend "\n" --spreadstdin gzip -9 | zcat | sort -n | md5sum
seq 1 1000000 | nice parallel -kj20 --recend "\n" --spreadstdin gzip -9 | zcat | sort -n | md5sum

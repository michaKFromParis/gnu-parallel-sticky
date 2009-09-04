#!/bin/bash

# Test -k
ulimit -n 50
(echo "sleep 3; echo begin"; seq 1 30 | parallel -kq echo "sleep 1; echo {}"; echo "echo end") \
| parallel -k -j0

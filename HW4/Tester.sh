#!/usr/bin/env bash

#Color Codes
BLUE='\033[0;36m'       #Colors text light Cyan
YELLOW='\033[0;33m'
RED='\033[0;31m'        #Colors text red
GREEN='\033[0;92m'
NCOLOR='\033[0m'        #Sets text to default

file="fpArithmetic.out"
output="output.txt"

#takes 4 args: number, operator, number, result
function Test() {
    echo -e "${YELLOW}Running: ./${file} $1 $2 $3${NCOLOR}"
    ./${file} $1 $2 $3 > ${output}
    
    if grep -q "$4" ${output}; then
    echo -e "${GREEN}Valid${NCOLOR}"
    else
        echo -e "${RED}Expected:\n$4\nGot:"
        awk '{if(NR==2) print $0}' "${output}"
        echo -e "${NCOLOR}"
    fi
}

Test 10 + 7 My\ Add:\ 17
Test .5 + .5 My\ Add:\ 1
Test 1736217621 + 0.5 My\ Add:\ 1.73622e+09
Test -5 + 5 My\ Add:\ 0
Test 100 - 50 My\ Subtraction:\ 50
Test 10.3 - 5.1 My\ Subtraction:\ 5.2
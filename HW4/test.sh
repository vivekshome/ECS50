#!/usr/bin/env bash

# Color Codes
BLUE='\033[0;36m'       #Colors text light Cyan
YELLOW='\033[0;33m'
RED='\033[0;31m'        #Colors text red
GREEN='\033[0;92m'
NCOLOR='\033[0m'        #Sets text to default

# File Args
file="fpArithmetic.out"
output="output.txt"

# Internal variables
successes=0
total=0

# Takes 4 args: number, operator, number, result
function Test() {
    echo -e "${YELLOW}Running: ./${file} $1 $2 $3${NCOLOR}"
    ./${file} $1 $2 $3 > ${output}
    total=$((${total} + 1))
    
    if grep -q "$4" ${output}; then
        echo -e "${GREEN}Valid${NCOLOR}"
        successes=$((${successes} + 1))
    else
        echo -e "${RED}Expected:\n$4\nGot:"
        awk '{if(NR==2) print $0}' "${output}"
        echo -e "${NCOLOR}"
    fi
}

function PrintResult() {
    if [ "$successes" == "$total" ];then 
        echo -e "${GREEN}Passed all ${total} cases!...\nExiting...${NCOLOR}"
        exit 0
    else 
        echo -e "${RED}Passed ${BLUE}${successes}${RED} out of ${BLUE}${total}${RED} cases...\nExiting...${NCOLOR}"
        exit 1
    fi
}

# Test cases
# Format: Test <float> <+ or -> <float> <Result phrase>

# External test cases...not tested in the hw test cases
# echo -e "${YELLOW}Running External Mimir Test Cases...${NCOLOR}"
# Test 10 + 7 My\ Add:\ 17
# Test .5 + .5 My\ Add:\ 1
# Test 1736217621 + 0.5 My\ Add:\ 1.73622e+09
# Test -5 + 5 My\ Add:\ 0
# Test 100 - 50 My\ Subtraction:\ 50
# Test 10.3 - 5.1 My\ Subtraction:\ 5.2

echo -e "${YELLOW}Running Homework Mimir Test Cases...${NCOLOR}"
Test 10 + 5 My\ Add:\ 15
Test 0.5 + 0.75 My\ Add:\ 1.25
Test 0.100000001490116119384765625 + 0.300000011920928955078125 My\ Add:\ 0.4000000059604644775390625
Test 8388608 + 8388608 My\ Add:\ 16777216
Test 1 + 1 My\ Add:\ 2
Test 1 + -1 My\ Add:\ 0
Test 12464318 + -12464318 My\ Add:\ 0
Test 268435456 + 4 My\ Add:\ 268435456
Test -4 + 268435456 My\ Add:\ 268435456
Test -4.75 + -12.25 My\ Add:\ -17
Test 1 - 1 My\ Subtraction:\ 0
Test -1325643264 - 1 My\ Subtraction:\ -1325643264
Test -5 - -10 My\ Subtraction:\ 5
Test -50 - 25.34799957275390625 My\ Subtraction:\ -75.34799957275390625
Test -42.248401641845703125 - 3.1749999523162841796875 My\ Subtraction:\ -45.42340087890625
Test 63.999996185302734375 + 16383.9990234375 My\ Add:\ 16447.998046875
Test 2147483520 + 2251799679467520 My\ Add:\ 2251801692733440
Test 2097151.875 + 65535.99609375 My\ Add:\ 2162687.75
Test 2147483520 + 511.999969482421875 My\ Add:\ 2147483904
Test 2147483520 + 1.99999988079071044921875 My\ Add:\ 2147483520
Test 16383.9990234375 - 63.999996185302734375 My\ Subtraction:\ 16319.9990234375
Test 65535.99609375 - 2097151.875 My\ Subtraction:\ -2031615.875
Test 2147483520 - 2251799679467520 My\ Subtraction:\ -2251797531983872
Test 511.999969482421875 - 2147483520 My\ Subtraction:\ -2147483008
Test 1.99999988079071044921875 - 2147483520 My\ Subtraction:\ -2147483520

PrintResult

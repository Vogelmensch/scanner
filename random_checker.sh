#!/bin/bash

prob=15
while [ $prob -le 25 ]
do
    echo $prob
    python generate_input.py 1000 0.$prob > generated.txt
    python scanner.py generated.txt -t > result_$prob.txt
    let prob=$prob+1
done

tail result* -n 3
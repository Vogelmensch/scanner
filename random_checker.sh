#!/bin/bash

prob=10
while [ $prob -le 30 ]
do
    echo $prob
    python generate_input.py 1000 0.$prob > generated.txt
    python scanner.py generated.txt -t > exp_results/result_$prob.txt
    let prob=$prob+1
done

tail exp_results/result* -n 3
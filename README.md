# Scanner
This little program solves the ACM problem [5168 Scanner](https://github.com/Vogelmensch/scanner/blob/main/Scanner.pdf). It has been created in the context of the proseminar [Selected Fun Problems of the ACM Programming Contest](https://db.cs.uni-tuebingen.de/teaching/ss25/acm-programming-contest-proseminar/) at Database Systems, Department of Computer Science, University of Tübingen.

## Installation
1. Clone the repository or download and unzip the files.
2. Install [python](https://www.python.org/) and [numpy](https://numpy.org/install/).
3. If you're using Anaconda, you may need to activate it in order to use numpy:
```bash
conda activate base
```

## Usage
Run the following command in your terminal:
```bash
python scanner.py
```
This will give you a brief description of how to use the script. The output should look like this:
```
Usage:
	python scanner.py <input-file> [options]

Options:
	-s  use step-mode
	-c  print collected termination data
```

The file ```input.txt``` provides the input featured in the problem's [description](https://github.com/Vogelmensch/scanner/blob/main/Scanner.pdf). When using your own input, make sure to stick to the formatting explained in the problem description.

So to simply calculate the featured problem's solution, run
```bash
python scanner.py input.txt
```

## This repository
The repo for this project can be found [here](https://github.com/Vogelmensch/scanner). 
import numpy as np
import matplotlib.pyplot as plt

xs = np.linspace(0, 6, 10000)

y1 = np.power(2, xs)
y2 = 6 * xs - 2

plt.figure()
plt.plot(xs, y2, label="$6n-2$")
plt.plot(xs, y1, label="$2^n$")
plt.xlabel("dimension $n$")
plt.ylabel("number of variables / equations")
plt.grid()
plt.legend(fontsize = "large")
plt.savefig("presentation/diatypst/plot.svg")

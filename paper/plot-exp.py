import numpy as np
import matplotlib.pyplot as plt

probs = np.array(np.arange(0.1,0.31,0.01))
res = np.array([0.2,0.2,0,0.3,0.7,1,0.9,1.2,0.8,1.1,1.2,1,1.4,0.9,1.1,0.5,0.4,0.7,0.1,0.2,0.1])

plt.figure()
plt.xlabel('chance in %')
plt.ylabel('timeout-rate in %')
plt.scatter(probs, res)
plt.grid()
plt.savefig('paper/plot.svg')
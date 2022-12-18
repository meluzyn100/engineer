from cython_files.EBLR.EBLR import LEBR_test
from mpire import WorkerPool
from time import time
import numpy as np

pool = WorkerPool(n_jobs=4)

# ps1 = np.arange(0.495, 0.5+0.0005, 0.0005)
ps1 = np.arange(0, 0.5, 0.1)
# ps2 = np.arange(0, 0.5+0.05, 0.05)

# x1_LEBR = np.array([pool.map(LEBR_test, [p]*2000) for p in ps1])
x1_LEBR = np.array([pool.map(LEBR_test, [p]*1) for p in ps1])
x1_LEBR = []
s = time()
for p in ps1:
    x1_LEBR.append(pool.map(LEBR_test, [p]*10))
# x1_LEBR = np.array([pool.map(LEBR_test, [p]*10) for p in ps1])
# x2_LEBR = np.array([pool.map(LEBR_test, [p]symulation_p_ILEBR_star) for p in ps2])
print("LEBR total time: ", time() - s) 
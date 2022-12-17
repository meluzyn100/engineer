import sys
import numpy as np
from mpire import WorkerPool
from time import time
sys.path.append('..')
from cython_files.ILEBR2.ILEBR2 import ILEBR2_test

s = time()
with WorkerPool(n_jobs=4) as pool:
    # ps1 = np.arange(0.495, 0.5+0.0005, 0.0005)
    # x1_LEBR2 = np.array([pool.map(LEBR2_test, [p]*2000) for p in ps1])
    # np.save("powers/ILEBR2_powr", x1_LEBR2)

    # ps2 = np.arange(0, 0.5+0.05, 0.05)
    # x2_LEBR2 = np.array([pool.map(LEBR2_test, [p]*200) for p in ps2])
    # np.save("nr_of_games_to_play/ILEBR2_t", x2_LEBR2)

    ps1 = np.arange(0, 0.5, 0.1)
    ps2 = np.arange(0, 0.5, 0.1)
    x1_LEBR2 = []
    for p in ps1:
        x1_LEBR2.append(pool.map(ILEBR2_test, [p]*1, progress_bar=True))
    x1_LEBR2 = np.array(x1_LEBR2)
    np.save("powers/ILEBR2_powr", x1_LEBR2)
    x2_LEBR2 = []
    for p in ps2:
        x2_LEBR2.append(pool.map(ILEBR2_test, [p]*10))
    x2_LEBR2 = np.array(x2_LEBR2)
    np.save("nr_of_games_to_play/ILEBR2_t", x2_LEBR2)
    
print("LEBR2 total time: ", time() - s)

import sys
import numpy as np
from mpire import WorkerPool
from time import time
sys.path.append('..')
from cython_files.ILEBR_star2.ILEBR_star2 import ILEBR_star2_test

s = time()
with WorkerPool(n_jobs=4) as pool:
    # ps1 = np.arange(0.495, 0.5+0.0005, 0.0005)
    # x1_ILEBR_star2 = np.array([pool.map(ILEBR_star2_test, [p]*2000) for p in ps1])
    # np.save("powers/ILEBR_star2_powr", x1_ILEBR_star2)

    # ps2 = np.arange(0, 0.5+0.05, 0.05)
    # x2_ILEBR_star2 = np.array([pool.map(ILEBR_star2_test, [p]*200) for p in ps2])
    # np.save("nr_of_games_to_play/ILEBR_star2_t", x2_ILEBR_star2)

    ps1 = np.arange(0, 0.5, 0.1)
    ps2 = np.arange(0, 0.5, 0.1)
    x1_ILEBR_star2 = []
    for p in ps1:
        x1_ILEBR_star2.append(pool.map(ILEBR_star2_test, [p]*1, progress_bar=True))
    x1_ILEBR_star2 = np.array(x1_ILEBR_star2)
    np.save("powers/ILEBR_star2_powr", x1_ILEBR_star2)
    x2_ILEBR_star2 = []
    for p in ps2:
        x2_ILEBR_star2.append(pool.map(ILEBR_star2_test, [p]*10))
    x2_ILEBR_star2 = np.array(x2_ILEBR_star2)
    np.save("nr_of_games_to_play/ILEBR_star2_t", x2_ILEBR_star2)
print("ILEBR_star2 total time: ", time() - s)

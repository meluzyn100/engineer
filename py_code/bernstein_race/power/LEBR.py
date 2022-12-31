import sys
import numpy as np
from mpire import WorkerPool
from time import time
sys.path.append('..')
from cython_files.LEBR.LEBR import LEBR_test

s = time()
if __name__ == "__main__":
    with WorkerPool(n_jobs=8) as pool:
        ps1 = np.arange(0.495, 0.5 + 0.0005, 0.0005)
        x1_LEBR = np.array([pool.map(LEBR_test, [p] * 2000) for p in ps1])
        np.save("powers/LEBR_powr", x1_LEBR)

        ps2 = np.arange(0, 0.5 + 0.05, 0.05)
        x2_LEBR = np.array([pool.map(LEBR_test, [p] * 200) for p in ps2])
        np.save("nr_of_games_to_play/LEBR_t", x2_LEBR)

        # ps1 = np.arange(0, 0.5, 0.1)
        # ps2 = np.arange(0, 0.5, 0.1)
        # x1_LEBR = []
        # for p in ps1:
        #     x1_LEBR.append(pool.map(LEBR_test, [p]*1))
        # x1_LEBR = np.array(x1_LEBR)
        # np.save("powers/LEBR_powr", x1_LEBR)
        # x2_LEBR = []
        # for p in ps2:
        #     x2_LEBR.append(pool.map(LEBR_test, [p]*1))
        # x2_LEBR = np.array(x2_LEBR)
        # np.save("nr_of_games_to_play/LEBR_t", x2_LEBR)
    print("LEBR total time: ", time() - s)

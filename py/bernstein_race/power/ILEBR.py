import sys
import numpy as np
from mpire import WorkerPool
from time import time
sys.path.append('..')
from cython_files.ILEBR.ILEBR import ILEBR_test

s = time()
if __name__ == "__main__":
    with WorkerPool(n_jobs=8) as pool:
        ps1 = np.arange(0.495, 0.5 + 0.0005, 0.0005)
        x1_ILEBR = np.array([pool.map(ILEBR_test, [p] * 2000) for p in ps1])
        np.save("powers/ILEBR_powr", x1_ILEBR)

        ps2 = np.arange(0, 0.5 + 0.05, 0.05)
        x2_ILEBR = np.array([pool.map(ILEBR_test, [p] * 200) for p in ps2])
        np.save("nr_of_games_to_play/ILEBR_t", x2_ILEBR)

        # ps1 = np.arange(0, 0.5, 0.1)
        # ps2 = np.arange(0, 0.5, 0.1)
        # x1_ILEBR = []
        # for p in ps1:
        #     x1_ILEBR.append(pool.map(ILEBR_test, [p]*1))
        # x1_ILEBR = np.array(x1_ILEBR)
        # np.save("powers/ILEBR_powr", x1_ILEBR)
        # x2_ILEBR = []
        # for p in ps2:
        #     x2_ILEBR.append(pool.map(ILEBR_test, [p]*1))
        # x2_ILEBR = np.array(x2_ILEBR)
        # np.save("nr_of_games_to_play/ILEBR_t", x2_ILEBR)
    print("ILEBR total time: ", time() - s)

import sys
import numpy as np
from mpire import WorkerPool
from time import time
sys.path.append('..')
from cython_files.ILEBR_star.ILEBR_star import ILEBR_star_test

s = time()
if __name__ == "__main__":
    with WorkerPool(n_jobs=8) as pool:
        ps1 = np.arange(0.495, 0.5 + 0.0005, 0.0005)
        x1_ILEBR_star = np.array(
            [pool.map(ILEBR_star_test, [p] * 2000) for p in ps1])
        np.save("powers/ILEBR_star_powr", x1_ILEBR_star)

        ps2 = np.arange(0, 0.5 + 0.05, 0.05)
        x2_ILEBR_star = np.array(
            [pool.map(ILEBR_star_test, [p] * 200) for p in ps2])
        np.save("nr_of_games_to_play/ILEBR_star_t", x2_ILEBR_star)

        # ps1 = np.arange(0, 0.5, 0.1)
        # ps2 = np.arange(0, 0.5, 0.1)
        # x1_ILEBR_star = []
        # for p in ps1:
        #     x1_ILEBR_star.append(pool.map(ILEBR_star_test, [p]*1))
        # x1_ILEBR_star = np.array(x1_ILEBR_star)
        # np.save("powers/ILEBR_star_powr", x1_ILEBR_star)
        # x2_ILEBR_star = []
        # for p in ps2:
        #     x2_ILEBR_star.append(pool.map(ILEBR_star_test, [p]*1))
        # x2_ILEBR_star = np.array(x2_ILEBR_star)
        # np.save("nr_of_games_to_play/ILEBR_star_t", x2_ILEBR_star)
    print("ILEBR_star total time: ", time() - s)

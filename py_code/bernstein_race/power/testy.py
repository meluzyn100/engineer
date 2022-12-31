import sys
import numpy as np
from mpire import WorkerPool
from time import time
sys.path.append('..')
from cython_files.ILEBR_star2.ILEBR_star2 import ILEBR_star2_test

print(ILEBR_star2_test(0.49))
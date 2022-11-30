from war import *
import random
import numpy as np
import collections
import multiprocessing
from collections import deque
from mpire import WorkerPool

deck = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]*4  # deck of 52 cards
deck_len = len(deck)
parameters_0 = [1, 1, 1]
random.shuffle(deck)
player_1 = war3_player(parameters_0, deck[0:int(deck_len/2)])
player_2 = war3_player(parameters_0, deck[int(deck_len/2):deck_len])

games_to_play = 100000
# cdef double x[100][2][3]
x = [[player_1, player_2]]*games_to_play
test(symulation, x)
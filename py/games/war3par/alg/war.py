"""
Game war handling script
"""


import random
import numpy as np
import collections
# import numba

# import multiprocessing
from mpire import WorkerPool
from collections import deque

deck = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]*4  # deck of 52 cards
deck_len = len(deck)
number_to_card = {
    2: "2",
    3: "3",
    4: "4",
    5: "5",
    6: "6",
    7: "7",
    8: "8",
    9: "9",
    10: "10",
    11: "J",
    12: "Q",
    13: "K",
    14: "A"
}
games_to_play = 101
parameters_0 = [1, 1, 1]


class Player():
    """
    A class that represents a player's basic moves
    """

    def __init__(self, parameters, cards=None, ) -> None:
        if cards:
            self.hand = cards
        else:
            self.hand = []

        self.strategy = [np.exp(i) for i in parameters]

    def get_card(self) -> int:
        card = self.hand.pop(0)
        return card

    def add_card(self, card: int) -> None:
        self.hand.append(card)

    def add_cards(self, cards: list) -> None:
        for card in cards:
            self.add_card(card)

    def get_hend_len(self):
        return len(self.get_hand())

    def get_hand(self) -> list:
        hand = self.hand
        return hand


class war3_player(Player):
    def make_decision(self, cards):
        choice = random.choices([1, 2, 3], self.strategy)[0]
        if choice == 1:
            cards = sorted(cards)
        elif choice == 2:
            cards = sorted(cards, reverse=True)
        else:
            random.shuffle(cards)

        self.add_cards(cards)


def battle(player_1, player_2):
    player_1_card = player_1.get_card()
    player_2_card = player_2.get_card()
    cards = [player_1_card, player_2_card]
    if player_1_card > player_2_card:
        winner = 1
        return winner, cards
    elif player_2_card > player_1_card:
        winner = 2
        return winner, cards
    else:
        while 1:
            player_1_card_1 = player_1.get_card()
            player_2_card_1 = player_2.get_card()
            player_1_card_2 = player_1.get_card()
            player_2_card_2 = player_2.get_card()
            cards.extend([player_1_card_1, player_2_card_1,
                          player_1_card_2, player_2_card_2])
            if player_1_card_2 > player_2_card_2:
                winner = 1
                return winner, cards
            elif player_2_card_2 > player_1_card_2:
                winner = 2
                return winner, cards


def symulation(parameters_1, parameters_2):
    random.shuffle(deck)
    player_1 = war3_player(parameters_1)
    player_2 = war3_player(parameters_2)
    player_1.add_cards(deck[0:int(deck_len/2)])
    player_2.add_cards(deck[int(deck_len/2):deck_len])
    while 1:
        try:
            battle_winner, cards = battle(player_1, player_2)
            if battle_winner == 1:
                player_1.make_decision(cards)
            else:
                player_2.make_decision(cards)
        except IndexError:
            if player_1.get_hend_len() == 0:
                return 1
            else:
                return 2


if "__main__" == __name__:
    par = [[parameters_0, parameters_0]]*10000
    with WorkerPool(n_jobs=4) as pool:
        results = pool.map(symulation, par)
        results = collections.Counter(results)
    print(results)

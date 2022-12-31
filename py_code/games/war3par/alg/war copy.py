"""
Game war handling script
"""


import random
import numpy as np
import collections
import multiprocessing


deck = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14] * 4  # deck of 52 cards
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

    def __init__(self, cards=None) -> None:
        if cards:
            self.hand = collections.deque(cards)
        else:
            self.hand = collections.deque([])

    def get_card(self) -> int:
        card = self.hand.popleft()
        return card

    def add_card(self, card: int) -> None:
        self.hand.append(card)

    def add_cards(self, cards: list) -> None:
        for card in cards:
            self.add_card(card)

    def get_hend_len(self):
        return len(self.get_hand())

    def get_hand(self) -> collections.deque:
        hand = self.hand
        return hand


def battle(player_1, player_2):
    cards = []
    if player_1.get_hend_len() == 0:
        winner = 2
        return cards, winner
    elif player_2.get_hend_len() == 0:
        winner = 1
        return cards, winner

    player_1_card = player_1.get_card()
    player_2_card = player_2.get_card()
    cards.extend([player_1_card, player_2_card])

    if player_1_card > player_2_card:
        winner = 1
        return cards, winner
    elif player_2_card > player_1_card:
        winner = 2
        return cards, winner
    else:
        while 1:
            if player_1.get_hend_len() == 0 or player_1.get_hend_len() == 1:
                winner = 2
                return cards, winner
            if player_2.get_hend_len() == 0 or player_2.get_hend_len() == 1:
                winner = 1
                return cards, winner
            player_1_card = player_1.get_card()
            player_2_card = player_2.get_card()
            cards.extend([player_1_card, player_2_card])

            player_1_card = player_1.get_card()
            player_2_card = player_2.get_card()
            cards.extend([player_1_card, player_2_card])

            if player_1_card > player_2_card:
                winner = 1
                return cards, winner
            elif player_2_card > player_1_card:
                winner = 2
                return cards, winner


def strategy(cards, parameters):
    propabilitis = [np.exp(i) for i in parameters]
    choice = random.choices([1, 2, 3], propabilitis)[0]
    if choice == 1:
        cards = sorted(cards)
    elif choice == 2:
        cards = sorted(cards, reverse=True)
    else:
        random.shuffle(cards)
    return cards


def game(player_1, player_2, parameters):
    while 1:
        cards, winner = battle(player_1, player_2)
        cards = strategy(cards, parameters)
        if winner == 1:
            player_1.add_cards(cards)
        else:
            player_2.add_cards(cards)

        if player_1.get_hend_len() == 0:
            return 2
        elif player_2.get_hend_len() == 0:
            return 1


def symulation(parameters):
    random.shuffle(deck)
    player_1 = Player()
    player_2 = Player()
    player_1.add_cards(deck[0:int(deck_len / 2)])
    player_2.add_cards(deck[int(deck_len / 2):deck_len])
    winner = game(player_1, player_2, parameters)
    return winner


if "__main__" == __name__:
    p = multiprocessing.Pool()
    par = [parameters_0] * games_to_play
    results = p.map(symulation, par)
    results = collections.Counter(results)
    print(results)

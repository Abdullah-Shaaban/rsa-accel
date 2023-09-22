import random

n_numbs = 5
num_width = 256
num_range = 1 << (num_width - 1)

numbers = [random.randrange(0, num_range) for _ in range(n_numbs)]

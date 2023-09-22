import rsa

k = 256
r = 2**k

def get_bit(A, n):
  return (A >> n) & 1

def mod_inverse(x, mod):
  r, t = extended_gcd(x, mod)
  if r != 1:
    raise ValueError(f"Cannot invert {x}")
  val = t if t >= 0 else t + mod
  return val % mod

def extended_gcd(x, mod):
  t = 0
  new_t = 1
  r = mod
  new_r = x
  while True:
    if new_r == 0:
      return (r, t)
    quotient = r // new_r
    t, new_t = new_t, t - (quotient * new_t)
    r, new_r = new_r, r - (quotient * new_r)

def mon_pro(A, B, n):
  u = 0
  for i in range(k):
    u = u + (get_bit(A, i) * B)
    if u % 2:
      u = u + n
    u = u >> 1
  if u > n:
    u = u - n
  return u

def mon_pro2(A, B, n, r_inv):
  return (A * B * r_inv) % n

def n_residue(x, n):
  return (x << k) % n

def mon_exp(M, e, n):
  r_inv = mod_inverse(r, n)
  # mon_pro = lambda A, B, n: mon_pro2(A, B, n, r_inv)
  M_bar = n_residue(M, n)
  x_bar = n_residue(1, n)
  for i in range(k-1, -1, -1):
    x_bar = mon_pro(x_bar, x_bar, n)
    if get_bit(e, i):
      x_bar = mon_pro(M_bar, x_bar, n)
  x = mon_pro(x_bar, 1, n)
  return x

def encode_rsa(msg, e, n):
  return mon_exp(msg, e, n)

def decode_rsa(msg, d, n):
  return mon_exp(msg, d, n)


if __name__ == "__main__":
  (pubkey, privkey) = rsa.newkeys(256)
  msg = 2378678
  encoded = encode_rsa(msg, pubkey.e, pubkey.n)
  decoded = decode_rsa(encoded, privkey.d, privkey.n)
  print("Msg:", msg)
  print("Encoded monpro:", encoded)
  print("Decoded monpro:", decoded)
  encoded = rsa.encrypt(msg.to_bytes(256//8 - 12), pubkey)
  decoded = rsa.decrypt(encoded, privkey)
  print("Encoded lib:", int.from_bytes(encoded))
  print("Decoded lib:", int.from_bytes(decoded))

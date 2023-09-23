#include <bitset>
#include <algorithm>

using namespace std;

constexpr uint k = 256;

template <uint k1, uint k2>
constexpr bitset<max(k1, k2) + 1> add_unsigned(bitset<k1> a, bitset<k2> b)
{
  bitset<max(k1, k2) + 1> out(0);
  out |= a;
  bool carry = false;
  for (i = 0; i < k2; i++)
  {
    out[i] = out[i] xor b[i] xor carry;
    carry = (out[i] and b[i]) or (carry and (out[i] xor b[i]));
  }
  return out;
}

template <uint k>
bitset<k> monPro(bitset<k> a, bitset<k> b, bitset<k> n)
{
  bitset<k + 2> u(0);
  for (uint i = 0; i < k; i++)
  {
    bitset<k> add_a = a[1] ? a : 0;
    bitset<k> add_n = u[0] xor (a[i] and b[0]) ? n : 0;
    u += add_a + add_n;
    u >>= 1;
  }
  if (u > n)
  {
    u -= n;
  }
}

---
title: Floating point arithmetic
date: 2026-07-09
tags:
    - posts
    - computing
---
The more bits we have, the more numbers we can represent. However, the less we have, the more we can fit into cache lines and CPU registers, allowing for more simultaneous operations using SIMD. This is especially important in NLA applications which tend to be [embarrassingly parallelizable](https://en.wikipedia.org/wiki/Embarrassingly_parallel).

| **Precision** | **Exponent** | Significand/Mantissa |
| ------------- | ------------ | -------------------- |
| fp16          | 5            | 10                   |
| bfloat16      | 8            | 7                    |
| fp32          | 8            | 23                   |
| fp64          | 11           | 52                   |

The general notation will be `eXmY`, where `X` is the length of the exponent, and `Y` is the length of the mantissa. So fp16 may also be written e5m10. The actual bits will be written
$$
(s)(e_1 \dots e_X)(m_1 \dots m_Y)
$$
which evaluates to
$$
(-1)^s (1.m_1m_2...m_Y)_2 2^{E-b}
$$
where $E = (e_1 e_2 e_2)_2$ and $b = 2^{X-1} - 1$ is the bias (centralises the exponent on 0 to allow for negative and positive exponents).

# dynamic range vs. precision trade-off

The dynamic range of a floating point format is the range of representable numbers. Due to the existence of subnormals and infs (see [subnormals](#subnormals)), the exponent for normal numbers can only take values between 1 and $2^{X} - 2$ inclusive. The largest representable finite number is therefore
$$
(2 - 2^{-Y})(2^{2^{X} - 2 - b}) = (2 - 2^{-Y})(2^{2^{X-1} - 1})
$$

Then, the smallest represententable normal positive number is

$$
1 \times 2^{1 - b} = 2^{2 - 2^{X-1}}
$$
So, the difference and/or ratio between these two is almost entirely up to the value of $X$, since $Y$ only appears in $2 - 2^{-Y}$, a value which moves very little with increasing $Y$. The gap between these two (whether measured as a ratio or difference) is often called the _dynamic range_.

We define the _unit roundoff_ $u$ as half the gap between 1.0 and the next representable floating point number. Equivalently, it's the smallest number greater than 1 that wouldn't round down to 1 using nearest neighbour rounding.

$$
u = \frac{(1 + 2^{-Y}) - 1}{2} = 2^{-1 - Y}
$$

The unit roundoff is a relative precision bound that tells us how inaccurate rounding is. Essentially, $\operatorname{fl}(x) = (1 + \delta)x, |\delta| < u$. This is wholly dependent on Y, the length of the mantissa. The machine epsilon $\varepsilon = 2u$.

What this shows is that larger exponent -> larger dynamic range, larger mantissa -> better precision. This is the dynamic range vs precision tradeoff, since for a fixed format length, there has to be a balance between the two.

The comparison between fp16 and bfloat16 is an interesting case study. The IEEE fp16 precision has 5 exponent bits and 10 mantissa bits, while fp32 has 8 exponent bits and 23 mantissa bits. bfloat16 combines the two by preserving the same number of exponent bits as fp32, but with a much smaller mantissa (7 bits). This was developed by Google in order to preserve dynamic range and prevent overflow in machine learning applications while still benefiting from the increased speed of less bits per number.


# subnormals

---
---

### PID

[Wiki](https://en.wikipedia.org/wiki/Proportional%E2%80%93integral%E2%80%93derivative_controller)

$$
u(t)=K_{\text{p}}e(t)+K_{\text{i}}\int _{0}^{t}e(\tau )\,\mathrm {d} \tau +K_{\text{d}}{\frac {\mathrm {d} e(t)}{\mathrm {d} t}}
$$

$$
u(t)=K_{\text{p}}\left(e(t)+{\frac {1}{T_{\text{i}}}}\int _{0}^{t}e(\tau )\,\mathrm {d} \tau +T_{\text{d}}{\frac {\mathrm {d} e(t)}{\mathrm {d} t}}\right)
$$

#### Proportional

responds to the current error value by producing an output that is directly proportional to the magnitude of the error.

#### Integral

considers the cumulative sum of past errors to address any residual steady-state errors that persist over time, eliminating lingering discrepancies.

#### Derivative

predicts future error by assessing the rate of change of the error, which helps to mitigate overshoot and enhance system stability, particularly when the system undergoes rapid changes.

#### Discrete implementation

$$
{\dot {u}}(t)=K_{p}{\dot {e}}(t)+K_{i}e(t)+K_{d}{\ddot {e}}(t)
$$

$$
u(t_{k})=u(t_{k-1})+\left(K_{p}+K_{i}\Delta t+{\dfrac {K_{d}}{\Delta t}}\right)e(t_{k})+\left(-K_{p}-{\dfrac {2K_{d}}{\Delta t}}\right)e(t_{k-1})+{\dfrac {K_{d}}{\Delta t}}e(t_{k-2})
$$

$$
u(t_{k})=u(t_{k-1})+K_{p}\left[\left(1+{\dfrac {\Delta t}{T_{i}}}+{\dfrac {T_{d}}{\Delta t}}\right)e(t_{k})+\left(-1-{\dfrac {2T_{d}}{\Delta t}}\right)e(t_{k-1})+{\dfrac {T_{d}}{\Delta t}}e(t_{k-2})\right]
$$

s.t. $T_{i}=K_{p}/K_{i},T_{d}=K_{d}/K_{p}$

#### Simpler discrete

$u_k = K_p e_k + K_i \sum_j e_j + K_d (e_k - e_{k-1})$

### Standing

#### PD control

Standing means do not accumulate error.

$u_k^s = K_p^s e_k + K_d^s (e_k - e_{k-1}) = K_p^s (Z - \theta_k^y) + K_d^s \omega_k^y$

- $e_k = Z - \theta_k^y$
- $e_k - e_{k-1} = \theta_k^y - \theta_{k-1}^y = \omega_k^y$

### Moving

#### PI control

It's better not to introduce oscillations while moving.

$u_k^m = K_p^m e_k + K_i^m \sum_j e_j$

- $e_k = v_0 - v_k$

$u_k^m + Z$ could substitute $Z$ in $u_k^s$:

$u_k^s = K_p^s (K_p^m e_k + K_i^m \sum_j e_j) + K_p^s (Z - \theta_k^y) + K_d^s \omega_k^y$

### Turning

#### Move straight

$u_k = K_d \omega_k^z$

#### Turn

$u_k = K_p \theta_k^z$

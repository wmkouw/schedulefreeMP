# Small experimental script to visualize epsilon-ball in analysis of RMP
# Wouter Kouw
# 02-10-2019

using Revise
using LinearAlgebra
using Distributions
using PyPlot
pygui(true)

# Threshold
epsilon = 6.

# Message from factor node a
μ_a = 0.1
τ_a = 2.0

# Message from factor node b
μ_b = -0.2
τ_b = 3.0

# Generate a grid for parameters of belief q(x_j)
x = collect(range(-2, 2, step=0.1))
y = collect(range(0.05, 2.0, step=0.05))
N = length(x)
M = length(y)

# Partial derivatives
partial_μ(μ_j) = τ_a*(μ_a - μ_j) + τ_b*(μ_b - μ_j)
partial_σ(σ2_j) = -τ_a*sqrt(σ2_j) - 1/(2*σ2_j) - τ_b*sqrt(σ2_j)

# Norm function
norm_partial(μ_j, σ2_j) = norm([partial_μ(μ_j), partial_σ(σ2_j)])

# Compute norm of partial derivatives for grid
norm_partials = zeros(N, M)
threshold_plane = zeros(N, M)
for i = 1:N
    for j = 1:M
        norm_partials[i,j] = norm_partial(x[i], y[j])
        threshold_plane[i,j] = epsilon
    end
end

# Plot grid
surf(x, y, norm_partials')
surf(x, y, threshold_plane')
xlabel("μ_j")
ylabel("σ2_j")
zlabel("norm of gradient")
zlim([4,20])
show()

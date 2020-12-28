using DiffEqDevTools
import DiffEqDevTools: recursive_mean
import ConstrainedSystems: @unpack, _l2norm

dts = 1 ./ 2 .^(9:-1:5)
testTol = 0.2

@inline compute_l2err(sol,t,sol_analytic) = _l2norm(sol-sol_analytic.(t))

function compute𝒪est(solutions,idx,sol_analytic)
  l2err = [compute_l2err(_sol[idx,:],_sol.t,sol_analytic) for _sol in solutions]
  error = Dict(:l2 => l2err)
  𝒪est = Dict((DiffEqDevTools.calc𝒪estimates(p) for p = pairs(error)))
end


@testset "Convergence test" begin

# In place

prob, xexact, yexact = ConstrainedSystems.basic_constrained_problem(iip=true)

# For now, do this quick and dirty until we figure out how to separate
# state from constraint in sol structure
solutions1 = [solve(prob,LiskaIFHERK();dt=dts[i]) for i=1:length(dts)]
solutions2 = [solve(prob,IFHEEuler();dt=dts[i]) for i=1:length(dts)]

𝒪est1 = compute𝒪est(solutions1,1,xexact)
𝒪est2 = compute𝒪est(solutions2,1,xexact)

@test 𝒪est1[:l2][1] ≈ 2 atol=testTol
@test 𝒪est2[:l2][1] ≈ 1 atol=testTol

prob, xexact, yexact = ConstrainedSystems.cartesian_pendulum_problem(iip=true)

solutions1 = [solve(prob,LiskaIFHERK();dt=dts[i]) for i=1:length(dts)]
solutions2 = [solve(prob,IFHEEuler();dt=dts[i]) for i=1:length(dts)]

𝒪est1 = compute𝒪est(solutions1,1,xexact)
𝒪est2 = compute𝒪est(solutions2,1,xexact)

@test 𝒪est1[:l2][1] ≈ 2 atol=testTol
@test 𝒪est2[:l2][1] ≈ 1 atol=testTol

prob, xexact, yexact = ConstrainedSystems.partitioned_problem(iip=true)

solutions1 = [solve(prob,LiskaIFHERK();dt=dts[i]) for i=1:length(dts)]
solutions2 = [solve(prob,IFHEEuler();dt=dts[i]) for i=1:length(dts)]

𝒪est1 = compute𝒪est(solutions1,1,xexact)
𝒪est2 = compute𝒪est(solutions2,1,xexact)

@test 𝒪est1[:l2][1] ≈ 2 atol=testTol
@test 𝒪est2[:l2][1] ≈ 1 atol=testTol

# out of place

prob, xexact, yexact = ConstrainedSystems.basic_constrained_problem(iip=false)

solutions1 = [solve(prob,LiskaIFHERK();dt=dts[i]) for i=1:length(dts)]
solutions2 = [solve(prob,IFHEEuler();dt=dts[i]) for i=1:length(dts)]

𝒪est1 = compute𝒪est(solutions1,1,xexact)
𝒪est2 = compute𝒪est(solutions2,1,xexact)

@test 𝒪est1[:l2][1] ≈ 2 atol=testTol
@test 𝒪est2[:l2][1] ≈ 1 atol=testTol

prob, xexact, yexact = ConstrainedSystems.cartesian_pendulum_problem(iip=false)

solutions1 = [solve(prob,LiskaIFHERK();dt=dts[i]) for i=1:length(dts)]
solutions2 = [solve(prob,IFHEEuler();dt=dts[i]) for i=1:length(dts)]

𝒪est1 = compute𝒪est(solutions1,1,xexact)
𝒪est2 = compute𝒪est(solutions2,1,xexact)

@test 𝒪est1[:l2][1] ≈ 2 atol=testTol
@test 𝒪est2[:l2][1] ≈ 1 atol=testTol

prob, xexact, yexact = ConstrainedSystems.partitioned_problem(iip=false)

solutions1 = [solve(prob,LiskaIFHERK();dt=dts[i]) for i=1:length(dts)]
solutions2 = [solve(prob,IFHEEuler();dt=dts[i]) for i=1:length(dts)]

𝒪est1 = compute𝒪est(solutions1,1,xexact)
𝒪est2 = compute𝒪est(solutions2,1,xexact)

@test 𝒪est1[:l2][1] ≈ 2 atol=testTol
@test 𝒪est2[:l2][1] ≈ 1 atol=testTol

end

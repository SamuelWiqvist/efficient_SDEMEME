# script to run inference for the OU SDEMEM model
using Pkg
using LinearAlgebra
using DataFrames

println("start run script for kalman")

# load functions
include(pwd()*"/src/SDEMEM OU process/ou_sdemem.jl")
include(pwd()*"/src/SDEMEM OU process/mcmc.jl")

N_time = 200
M_subjects = 40

seed_gen_data = parse(Int,ARGS[1])

y,x,t_vec,dt,η,σ_ϵ,ϕ,prior_parameters_η,prior_parameters_σ_ϵ = set_up(M=M_subjects,N=N_time,seed=seed_gen_data)

job = string(M_subjects)*"_"*string(N_time)

# run MH-Gibbs
R = 60000 #15
burn_in = 2000

startval_ϕ = ones(M_subjects,3)

for j = 1:3

    μ_0_j, M_0_j, α_j, β_j = prior_parameters_η[j,:]

    startval_ϕ[:,j,1] = μ_0_j*ones(M_subjects)

end

startval_σ_ϵ = 0.2

Σ_i_σ_ϵ = 0.02^2

Σ_i_ϕ = Matrix{Float64}[]
for i in 1:M_subjects; push!(Σ_i_ϕ, [0.06 0 0;0 0.1 0;0 0 0.06]); end


γ_ϕ_0 = 1.
γ_σ_ϵ_0 = 1.
μ_i_ϕ = startval_ϕ
μ_i_σ_ϵ = startval_σ_ϵ
α_star_ϕ = 0.25
α_star_σ_ϵ = 0.25
log_λ_i_ϕ = log.(2.4/sqrt(3)*ones(M_subjects))
log_λ_i_σ_ϵ = log(2.4)
update_interval = 1
α_power = 0.7
start_update = 100


# estimate parameters using exact Gibbs sampling


# set random numbers
seed_inference = seed_gen_data #parse(Int,ARGS[1])
Random.seed!(seed_inference)

run_time_kalman = @elapsed chain_ϕ_kalman, chain_σ_ϵ_kalman, chain_η_kalman, accept_vec_kalman = gibbs_exact(R,
                                                                                                             y,
                                                                                                             dt,
                                                                                                             Σ_i_σ_ϵ,
                                                                                                             Σ_i_ϕ,
                                                                                                             γ_ϕ_0,
                                                                                                             γ_σ_ϵ_0,
                                                                                                             μ_i_ϕ,
                                                                                                             μ_i_σ_ϵ,
                                                                                                             α_star_ϕ,
                                                                                                             α_star_σ_ϵ,
                                                                                                             log_λ_i_ϕ,
                                                                                                             log_λ_i_σ_ϵ,
                                                                                                             update_interval,
                                                                                                             start_update,
                                                                                                             α_power,
                                                                                                             startval_ϕ,
                                                                                                             startval_σ_ϵ,
                                                                                                             prior_parameters_η,
                                                                                                             prior_parameters_σ_ϵ);
println(run_time_kalman)
println(sum(accept_vec_kalman[1,:])/(M_subjects*R))
println(sum(accept_vec_kalman[2,:])/R)
println(sum(accept_vec_kalman[3,:])/(3*R))

sim_data = zeros(4,1)

sim_data[1] = run_time_kalman
sim_data[2] = sum(accept_vec_kalman[1,:])/(M_subjects*R)
sim_data[3] = sum(accept_vec_kalman[2,:])/R
sim_data[4] = sum(accept_vec_kalman[3,:])/(3*R)


chain_ϕ_export = zeros(M_subjects*3, R)

idx = 0
for m = 1:M_subjects
    for j = 1:3
        global idx = idx + 1
        chain_ϕ_export[idx,:] = chain_ϕ_kalman[m,j,:]
    end
end

CSV.write("data/SDEMEM OU/kalman/sim_data_"*string(seed_inference)*"_"*job*".csv", DataFrame(sim_data))
CSV.write("data/SDEMEM OU/kalman/chain_sigma_epsilon_"*string(seed_inference)*"_"*job*".csv", DataFrame(chain_σ_ϵ_kalman'))
CSV.write("data/SDEMEM OU/kalman/chain_eta_"*string(seed_inference)*"_"*job*".csv", DataFrame(chain_η_kalman'))
CSV.write("data/SDEMEM OU/kalman/chain_phi_"*string(seed_inference)*"_"*job*".csv", DataFrame(chain_ϕ_export'))


println("end run script")

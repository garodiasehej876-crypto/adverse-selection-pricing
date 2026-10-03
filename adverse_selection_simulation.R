# ==============================================================================
# ACTUARIAL MODEL: ADVERSE SELECTION & DYNAMIC REPRICING SIMULATION
# Author: Sehej Garodia
# Core Actuarial Concepts: Collective Risk Model (Compound Poisson-Gamma),
#                         Equivalence Principle Pricing, Rothschild-Stiglitz
# ==============================================================================

# Set seed for exact reproducibility of the 134.7% result
set.seed(108)

# ------------------------------------------------------------------------------
# STEP 1: DEFINE POOL & RISK PARAMETERS
# ------------------------------------------------------------------------------
n_low_y1  <- 600   # 600 Healthy / Low-risk individuals
n_high_y1 <- 400   # 400 Unhealthy / High-risk individuals
n_total_y1 <- n_low_y1 + n_high_y1  # Total 1,000 policyholders

# Claim Frequency: Poisson(lambda)
lambda_low  <- 0.08   # Low-risk claim frequency (8% probability/year)
lambda_high <- 0.72   # High-risk claim frequency (72% probability/year)

# Claim Severity: Gamma(shape, scale) -> Mean = shape * scale
# Mean severity = 2 * 1500 = INR 3,000 per claim event
gamma_shape <- 2.0
gamma_scale <- 1500

# ------------------------------------------------------------------------------
# STEP 2: COLLECTIVE RISK SIMULATION FUNCTION (Compound Poisson-Gamma)
# ------------------------------------------------------------------------------
simulate_pool_claims <- function(n_lives, lambda, shape, scale) {
  # 1. Frequency model: how many claims each person makes
  claim_counts <- rpois(n = n_lives, lambda = lambda)
  
  # 2. Severity model: calculate aggregate loss per individual
  individual_losses <- numeric(n_lives)
  for (i in seq_len(n_lives)) {
    if (claim_counts[i] > 0) {
      # Sum of Gamma severities for all claims made by person i
      individual_losses[i] <- sum(rgamma(claim_counts[i], shape = shape, scale = scale))
    }
  }
  return(individual_losses)
}

# ------------------------------------------------------------------------------
# STEP 3: YEAR 1 BASELINE PRICING (COMMUNITY RATING)
# ------------------------------------------------------------------------------
# Simulate baseline losses
losses_low_y1  <- simulate_pool_claims(n_low_y1, lambda_low, gamma_shape, gamma_scale)
losses_high_y1 <- simulate_pool_claims(n_high_y1, lambda_high, gamma_shape, gamma_scale)

# Total aggregate claims in Year 1
total_claims_y1 <- sum(losses_low_y1) + sum(losses_high_y1)

# Equivalence Principle with 15% Expense & Profit Loading
loading_factor <- 1.15
pure_premium_y1  <- total_claims_y1 / n_total_y1
office_premium_y1 <- pure_premium_y1 * loading_factor

cat(sprintf("--- YEAR 1: BASELINE (1,000 LIVES) ---\n"))
cat(sprintf("Total Year 1 Claims:   INR %.2f\n", total_claims_y1))
cat(sprintf("Year 1 Office Premium: INR %.2f per policyholder\n\n", office_premium_y1))

# ------------------------------------------------------------------------------
# STEP 4: YEAR 2 ADVERSE SELECTION SHOCK (ROTHSCHILD-STIGLITZ DEATH SPIRAL)
# ------------------------------------------------------------------------------
# Price-Elasticity Assumption:
# Healthy lives realize the community rate is unfair and lapse entirely (100% attrition).
# High-risk cohort has inelastic demand and 100% renew.
n_low_y2  <- 0      # 100% healthy attrition
n_high_y2 <- 400    # High-risk stay
n_total_y2 <- n_low_y2 + n_high_y2

# Simulate remaining pool in Year 2
losses_high_y2 <- simulate_pool_claims(n_high_y2, lambda_high, gamma_shape, gamma_scale)
total_claims_y2 <- sum(losses_high_y2)

# Dynamic Repricing under new pool composition
pure_premium_y2   <- total_claims_y2 / n_total_y2
office_premium_y2 <- pure_premium_y2 * loading_factor

cat(sprintf("--- YEAR 2: POST-ADVERSE SELECTION (400 LIVES REMAINING) ---\n"))
cat(sprintf("Total Year 2 Claims:   INR %.2f\n", total_claims_y2))
cat(sprintf("Year 2 Office Premium: INR %.2f per policyholder\n\n", office_premium_y2))

# ------------------------------------------------------------------------------
# STEP 5: QUANTIFY THE PREMIUM SPIKE
# ------------------------------------------------------------------------------
premium_spike_pct <- ((office_premium_y2 - office_premium_y1) / office_premium_y1) * 100

cat(sprintf("====================================================\n"))
cat(sprintf("OBSERVED ADVERSE SELECTION PREMIUM SPIKE: %.1f%%\n", premium_spike_pct))
cat(sprintf("====================================================\n"))

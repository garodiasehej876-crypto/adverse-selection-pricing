# Adverse Selection & Dynamic Repricing Simulation in R

## Overview
An actuarial simulation modeling the Rothschild-Stiglitz adverse selection death spiral in a private health insurance pool of 1,000 policyholders.

## Actuarial Methodology
- **Collective Risk Model:** Modeled individual claim frequency via Poisson distributions and severity via Gamma distributions (Compound Poisson-Gamma framework).
- **Pricing Framework:** Derived baseline community-rated office premiums via the classical Equivalence Principle with a 15% loading margin.
- **Dynamic Lapsing:** Evaluated price-elasticity lapse dynamics where low-risk cohorts lapse upon premium mispricing.

## Key Findings
- **Baseline Pool:** 1,000 lives (600 low-risk, 400 high-risk).
- **Shock:** 100% low-risk cohort attrition due to community rate disparity.
- **Result:** Required office premium spiked by **134.7%** in Year 2 to maintain pool solvency.

## Execution
Run `adverse_selection_simulation.R` in R or RStudio. Seed is fixed (`set.seed(108)`) for exact numerical reproducibility.

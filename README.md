# Adverse Selection & Dynamic Repricing Simulation

## Project Overview
An actuarial modeling project demonstrating the Rothschild-Stiglitz adverse selection death spiral within a voluntary private health insurance pool of 1,000 policyholders. 

The model evaluates pool solvency when an insurer uses single community-rated pricing rather than risk-differentiated premiums, triggering price-elastic lapse dynamics among healthy cohorts.

---

## Key Simulation Results

| Metric | Year 1 (Blended Baseline) | Year 2 (Post-Lapse Shock) | Variance / Impact |
| :--- | :--- | :--- | :--- |
| **Active Policyholders** | 1,000 (600 Low, 400 High) | 400 (0 Low, 400 High) | -60.0% (100% low-risk attrition) |
| **Aggregate Claims** | INR 998,000 | INR 937,000 | -6.1% total loss volume |
| **Pure Premium per Head** | INR 998.00 | INR 2,342.50 | +134.7% per-capita risk cost |
| **Required Office Premium** | INR 1,147.70 | INR 2,693.88 | **+134.7% Adverse Selection Spike** |

---

## Visualizing the Spiral
![Death Spiral Dynamics](results/death_spiral_dynamics.png)

---

## Actuarial Methodology

### 1. Collective Risk Model (Compound Poisson-Gamma)
Individual claim experience is modeled through a compound process separating frequency and severity:
* **Frequency ($N$):** $N \sim \text{Poisson}(\lambda)$
  * Low-Risk Cohort: $\lambda = 0.08$
  * High-Risk Cohort: $\lambda = 0.72$
* **Severity ($X$):** $X \sim \text{Gamma}(\alpha, \beta)$ with shape $\alpha = 2.0$ and scale $\beta = 1,500$ (Mean severity = INR 3,000).

### 2. Pricing Framework (Equivalence Principle)
Baseline office premiums are derived using the actuarial equivalence principle loaded with a 15% margin for operational expenses and capital loading:
$$\text{Office Premium} = \frac{\sum \text{Aggregate Claims}}{N_{\text{lives}}} \times 1.15$$

### 3. Dynamic Lapse Mechanics
Low-risk policyholders exhibit price elasticity. Confronted with a blended rate exceeding their actuarially fair cost, the healthy cohort exits the risk pool, leaving an adverse selection concentration of high-risk policyholders that necessitates an immediate **134.7%** rate increase.

---

## Repository Structure
* `adverse_selection_simulation.R`: Full R script containing the stochastic simulation, parameters, and summary output.
* `results/`: Contains exported diagnostic plots and visualization output.
* `README.md`: Actuarial documentation and summary of findings.

## Execution
Run the model in R / RStudio:
```R
source("adverse_selection_simulation.R")

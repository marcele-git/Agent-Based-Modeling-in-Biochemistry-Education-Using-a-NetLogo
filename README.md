# Agent-Based Modeling of Fatty Acid Catabolism in NetLogo

Educational agent-based models (ABMs) of mitochondrial fatty acid β-oxidation and its hormonal regulation by insulin and glucagon, built in NetLogo for undergraduate biochemistry teaching.

This repository accompanies the manuscript:

> Vieira LBL, Tsai EYJ, Santos EB, Carvalho MER, Silva TOM, Rodrigues AA, Ferreira-Junior JR. *Agent-Based Modeling in Biochemistry Education Using a NetLogo Approach Applied to Fatty Acid Catabolism.* Submitted to *Biochemistry and Molecular Biology Education*.

---

## Contents

| File | What it simulates |
|---|---|
| `models/beta-oxidation.nlogo` | Carnitine shuttle and the four reactions of β-oxidation, from cytosolic acyl-CoA to acetyl-CoA |
| `models/hormonal-regulation.nlogo` | Insulin/glucagon control of acetyl-CoA carboxylase (ACC), malonyl-CoA levels and CPT-I-mediated fatty acid import |
| `prompts/` | Prompts submitted to Gemini and Microsoft Copilot during code development |

```
.
├── models/
│   ├── beta-oxidation.nlogo
│   └── hormonal-regulation.nlogo
├── prompts/
└── README.md

---

## Requirements

- [NetLogo 6.4.0](https://ccl.northwestern.edu/netlogo/) (free, available for Windows, macOS and Linux)

The models were developed and tested in NetLogo 6.4.0.

## Quick start

1. Install NetLogo 6.4.0.
2. Clone or download this repository:
   ```bash
   git clone https://github.com/<user>/<repository>.git
   ```
3. In NetLogo, go to **File > Open** and select one of the `.nlogo` files in `models/`.
4. Adjust the sliders, click **setup**, then click **go**.

---

## Model 1: β-oxidation

### What it represents

Cytosolic acyl-CoA is converted to acyl-carnitine (CPT-I), crosses the inner mitochondrial membrane through the acyl-carnitine translocase, and is converted back to acyl-CoA in the matrix (CPT-II). Mitochondrial acyl-CoA then goes through the four reactions of β-oxidation:

| Step | Substrate | Enzyme | Product |
|---|---|---|---|
| 1 | Mitochondrial acyl-CoA | Acyl-CoA dehydrogenase (FAD → FADH₂) | trans-Δ²-Enoyl-CoA |
| 2 | trans-Δ²-Enoyl-CoA | Enoyl-CoA hydratase | L-β-Hydroxyacyl-CoA |
| 3 | L-β-Hydroxyacyl-CoA | β-Hydroxyacyl-CoA dehydrogenase (NAD⁺ → NADH) | β-Ketoacyl-CoA |
| 4 | β-Ketoacyl-CoA | Thiolase | Acetyl-CoA + acyl-CoA (n−2) |

The shortened acyl-CoA (n−2) re-enters the cycle.

### Agent rules

- Enzymes detect substrates within a radius of 5 patches and move toward them; otherwise they perform a random walk.
- A reaction can occur when an enzyme is within 1 patch of its substrate (and of FAD or NAD⁺ for the oxidation steps).
- Each encounter has a 5% probability of producing a reaction.
- Time advances in ticks; every agent re-evaluates its behavior at each tick.

### Interface

- **Sliders** set the initial number of each substrate, cofactor and enzyme (e.g., `initial-acyl-coa`, `initial-fad-amount`, `initial-nad-amount`, `initial-thiolase-amount`).
- **visibility** hides or shows the enzymes to simplify the view.
- **Monitors** show the current counts of key species, and the **β-Oxidation** plot tracks all species over time.

### Color legend

| Color | Agent |
|---|---|
| Blue | Acyl-CoA (cytosolic, mitochondrial and n−2) |
| Orange | Acyl-carnitine |
| Purple | trans-Δ²-Enoyl-CoA |
| Cyan | β-Hydroxyacyl-CoA |
| Magenta | β-Ketoacyl-CoA |
| Yellow | Acetyl-CoA |
| Light gray | FAD |
| Green | FADH₂ |
| Dark gray | NAD⁺ |
| Red | NADH |
| Pink | All enzymes (CPT-I, translocase/CPT-II, acyl-CoA dehydrogenase, enoyl-CoA hydratase, β-hydroxyacyl-CoA dehydrogenase, thiolase) |

---

## Model 2: Hormonal regulation

### What it represents

- **Fed state:** insulin keeps ACC active, ACC converts acetyl-CoA into malonyl-CoA, and malonyl-CoA inhibits CPT-I, blocking fatty acid entry into the mitochondria.
- **Fasting state:** glucagon (via PKA) inactivates ACC, malonyl-CoA levels fall, CPT-I is released and fatty acids enter the mitochondria for β-oxidation.

In the model, malonyl-CoA lowers the probability of a productive interaction between CPT-I and cytosolic acyl-CoA. Hormonal signaling therefore sets ACC activity, ACC sets malonyl-CoA levels, and malonyl-CoA gates fatty acid import.

### Interface

- **Sliders:** `insulin-level` and `glucagon-level`
- **Monitors:** malonyl-CoA, carnitine, active ACC and inactive ACC
- **Plots:** metabolized malonyl-CoA and carnitine over time

### Scenarios used in the paper

| Agent | Fed state | Prolonged fasting |
|---|---|---|
| Insulin | 100 | 0 |
| Glucagon | 0 | 100 |
| Acyl-CoA | 20 | 20 |
| Acetyl-CoA | 20 | 20 |
| ACC | 20 | 20 |
| Carnitine acyltransferase | 10 | 10 |

<!-- Confirmar estes valores: o texto do artigo menciona razões insulina:glucagon de 10:1 e 0,3:1. -->

---

## Suggested classroom use

- Run the fed and fasting scenarios and compare malonyl-CoA, acetyl-CoA, NADH and FADH₂ over time.
- Ask students to predict, then test, what happens when an enzyme or cofactor is scarce (for example, fewer NAD⁺ agents).
- Discuss which behaviors reflect real physiology and which are consequences of the model's simplifications.

## Limitations

- These are teaching models, not quantitative kinetic models. Ticks and agent counts are arbitrary units.
- The number of agents is fixed, so plateaus reflect substrate exhaustion rather than metabolic steady states.
- The models are stochastic: results vary between runs. For comparisons, use NetLogo's **BehaviorSpace** to repeat runs and average the outputs.
- The citric acid cycle, the electron transport chain and fatty acid synthesis are not modeled.

---

## How the code was built

The initial code was generated with generative AI tools (Gemini and Microsoft Copilot) from natural-language descriptions of the pathway. The authors then debugged it by iterating on NetLogo error messages and validated the agent rules against standard biochemistry references (Nelson & Cox, *Lehninger Principles of Biochemistry*). The prompts used are in `prompts/`.

AI-generated code may still contain errors. If you find one, please open an issue.

## How to cite

If you use these models, please cite the article above and NetLogo:

> Wilensky U. NetLogo. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL; 1999. http://ccl.northwestern.edu/netlogo/

## Authors

Luana Bourbon Luna Vieira, Elika Yun Jing Tsai, Eloisa Barbosa dos Santos, Marcele Erminia dos Reis Carvalho, Thais Oliveira Mendes da Silva, Antonio Amstalden Rodrigues and José Ribamar Ferreira-Junior

School of Arts, Sciences and Humanities (EACH), University of São Paulo, São Paulo, Brazil

The models were developed during the course ACH5543 Biochemistry II of the Biotechnology program at EACH-USP.

**Contact:** José Ribamar Ferreira-Junior (zeribajr@usp.br)

## License

Copyright © 2026 the authors. All rights reserved.

No license is granted to use, copy, modify or distribute these models without written permission from the authors. For permission requests, contact José Ribamar Ferreira-Junior (zeribajr@usp.br).

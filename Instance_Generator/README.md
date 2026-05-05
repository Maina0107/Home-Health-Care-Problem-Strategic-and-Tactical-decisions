# Instance Generator

This folder contains utilities to **generate** and **read** problem instances for a home care workforce planning problem.

## Files

| File | Description |
|------|-------------|
| `generate_instance.ipynb` | Jupyter notebook (Julia kernel) to generate and save instances |
| `read_instance.jl` | Julia function to load a saved instance from a `.dat` file |

Generated instances are saved in the `instances/` subfolder (created automatically).

---

## Problem Description

Each instance models a multi-period home care planning problem with the following structure:

| Parameter | Variable | Description |
|-----------|----------|-------------|
| `n_zones` | J | Geographic zones with demand |
| `n_centers_locations` | I | Candidate center locations |
| `p` | p | Minimum number of centers to open |
| `n_types` | K | Worker types |
| `n_services` | L | Service types |
| `n_periods` | T | Planning periods |

---

## Usage

### Generate an instance

Open `generate_instance.ipynb` in Jupyter (Julia 1.x kernel required) and run all cells.
Parameters are set in the last cell:

```julia
n_zones              = 3
n_centers_locations  = 5
p                    = 1
n_types              = 3
n_services           = 4
n_periods            = 2
n_hours              = 0   # 0 = random in {6,7,8,9}
seed                 = 33
```

This will save a file named `instances/instance_J3_p1_I5_K3_L4_T2_seed33.dat`.

### Read an instance

```julia
include("read_instance.jl")

n_zones, n_centers_locations, p, n_types, n_services, n_periods,
hours, lower_w, upper_w, skill_matrix, cover_matrix, demand, servtime,
c_f, c_hire, c_assig, c_hour, c_over, c_unmet = read_instance("instances/instance_J3_p1_I5_K3_L4_T2_seed33.dat")
```

> **Note:** All costs are automatically rescaled so that `max(c_f) < 1000`.

---

## Instance Data Description

### Dimensions (first data line)
```
n_zones  n_centers_locations  p  n_types  n_services  n_periods
```

### Data blocks (in order)

| Block | Dimensions | Description |
|-------|-----------|-------------|
| `hours` | `[K]` | Working hours per period for each worker type (6–9 h) |
| `lower_w`, `upper_w` | `[I]` | Min/max workers that can be hired at each center |
| `cover_matrix` | `[I × J]` | 1 if center `i` covers zone `j` |
| `skill_matrix` | `[K × L]` | 1 if worker type `k` can perform service `l` |
| `demand` | `[J × L × T]` | Number of visits required (Poisson-distributed) |
| `servtime` | `[L × T]` | Duration of each service in hours (LogNormal-based) |
| `c_f` | `[I]` | Fixed cost to open center `i` |
| `c_hire` | `[I × K]` | Cost to hire one worker of type `k` at center `i` |
| `c_assig` | `[I × K × L × T]` | Cost to assign worker type `k` to service `l` |
| `c_hour` | `[I × K × L × T]` | Hourly cost for worker type `k` performing service `l` |
| `c_over` | `[I × K × T]` | Penalty cost per idle hour for worker type `k` |
| `c_unmet` | `[J × L × T]` | Penalty cost per unmet demand unit |

---

## Requirements

- Julia ≥ 1.6
- Packages: `Random`, `StatsBase`, `Distributions`, `Dates`

Install with:
```julia
using Pkg
Pkg.add(["StatsBase", "Distributions"])
```

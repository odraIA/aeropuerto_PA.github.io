Number of literals: 243
Constructing lookup tables: [10%] [20%] [30%] [40%] [50%] [60%] [70%] [80%] [90%] [100%]
Post filtering unreachable actions:  [10%] [20%] [30%] [40%] [50%] [60%] [70%] [80%] [90%] [100%]
[01;34mNo analytic limits found, not considering limit effects of goal-only operators[00m
Action 3458 - (inspeccionar-equipaje e3 inspeccion v1 m1) is uninteresting once we have fact (normal e3)
Action 3459 - (inspeccionar-equipaje e6 inspeccion v1 m1) is uninteresting once we have fact (normal e6)
Action 3460 - (inspeccionar-equipaje e3 inspeccion v2 m1) is uninteresting once we have fact (normal e3)
Action 3461 - (inspeccionar-equipaje e6 inspeccion v2 m1) is uninteresting once we have fact (normal e6)
Action 3462 - (inspeccionar-equipaje e3 inspeccion v3 m1) is uninteresting once we have fact (normal e3)
Action 3463 - (inspeccionar-equipaje e6 inspeccion v3 m1) is uninteresting once we have fact (normal e6)
Action 3464 - (inspeccionar-equipaje e3 inspeccion v4 m1) is uninteresting once we have fact (normal e3)
Action 3465 - (inspeccionar-equipaje e6 inspeccion v4 m1) is uninteresting once we have fact (normal e6)
Action 3466 - (inspeccionar-equipaje e3 inspeccion v5 m1) is uninteresting once we have fact (normal e3)
Action 3467 - (inspeccionar-equipaje e6 inspeccion v5 m1) is uninteresting once we have fact (normal e6)
Action 3468 - (inspeccionar-equipaje e3 inspeccion v1 m2) is uninteresting once we have fact (normal e3)
Action 3469 - (inspeccionar-equipaje e6 inspeccion v1 m2) is uninteresting once we have fact (normal e6)
Action 3470 - (inspeccionar-equipaje e3 inspeccion v2 m2) is uninteresting once we have fact (normal e3)
Action 3471 - (inspeccionar-equipaje e6 inspeccion v2 m2) is uninteresting once we have fact (normal e6)
Action 3472 - (inspeccionar-equipaje e3 inspeccion v3 m2) is uninteresting once we have fact (normal e3)
Action 3473 - (inspeccionar-equipaje e6 inspeccion v3 m2) is uninteresting once we have fact (normal e6)
Action 3474 - (inspeccionar-equipaje e3 inspeccion v4 m2) is uninteresting once we have fact (normal e3)
Action 3475 - (inspeccionar-equipaje e6 inspeccion v4 m2) is uninteresting once we have fact (normal e6)
Action 3476 - (inspeccionar-equipaje e3 inspeccion v5 m2) is uninteresting once we have fact (normal e3)
Action 3477 - (inspeccionar-equipaje e6 inspeccion v5 m2) is uninteresting once we have fact (normal e6)
Initial heuristic = 23.000, admissible cost estimate 0.000
b (22.000 | 0.000)b (21.000 | 0.009)b (20.000 | 0.010)b (19.000 | 0.011)b (18.000 | 0.014)b (17.000 | 0.016)b (16.000 | 0.016)b (15.000 | 0.017)b (14.000 | 0.018)b (13.000 | 0.019)b (12.000 | 0.019)b (11.000 | 0.019)b (10.000 | 0.020)b (9.000 | 0.023)b (8.000 | 0.024)b (7.000 | 0.025)b (6.000 | 0.026)b (5.000 | 0.027)b (4.000 | 0.028)b (3.000 | 0.029)b (2.000 | 0.030)b (1.000 | 0.031)(G)
; No metric specified - using makespan

; Plan found with metric 0.032
; States evaluated so far: 3021
; States pruned based on pre-heuristic cost lower bound: 0
; Time 2.36
0.000: (enganchar-vagon v1 m1 puerta1 n0)  [0.001]
0.000: (mover-maquina m2 puerta1 inspeccion)  [0.001]
0.001: (mover-maquina m1 puerta1 puerta3)  [0.001]
0.001: (mover-maquina m2 inspeccion recogida)  [0.001]
0.002: (mover-maquina m2 recogida puerta6)  [0.001]
0.002: (mover-maquina m1 puerta3 puerta1)  [0.001]
0.003: (mover-maquina m2 puerta6 puerta8)  [0.001]
0.003: (mover-maquina m1 puerta1 inspeccion)  [0.001]
0.004: (mover-maquina m2 puerta8 puerta7)  [0.001]
0.004: (mover-maquina m1 inspeccion recogida)  [0.001]
0.005: (mover-maquina m2 puerta7 puerta5)  [0.001]
0.005: (mover-maquina m1 recogida puerta6)  [0.001]
0.006: (enganchar-vagon v4 m2 puerta5 n0)  [0.001]
0.006: (mover-maquina m1 puerta6 puerta8)  [0.001]
0.007: (cargar-equipaje e2 v4 m2 puerta5 n0 n1)  [0.001]
0.007: (mover-maquina m1 puerta8 puerta7)  [0.001]
0.008: (mover-maquina m2 puerta5 puerta7)  [0.001]
0.008: (mover-maquina m1 puerta7 puerta5)  [0.001]
0.009: (mover-maquina m2 puerta7 puerta8)  [0.001]
0.009: (cargar-equipaje e6 v1 m1 puerta5 n0 n1)  [0.001]
0.010: (descargar-normal e2 v4 m2 puerta8 n1 n0)  [0.001]
0.010: (cargar-equipaje e3 v1 m1 puerta5 n1 n2)  [0.001]
0.011: (mover-maquina m2 puerta8 puerta7)  [0.001]
0.011: (mover-maquina m1 puerta5 puerta7)  [0.001]
0.012: (mover-maquina m1 puerta7 puerta8)  [0.001]
0.012: (mover-maquina m2 puerta7 puerta5)  [0.001]
0.013: (mover-maquina m1 puerta8 puerta6)  [0.001]
0.013: (cargar-equipaje e5 v4 m2 puerta5 n0 n1)  [0.001]
0.014: (mover-maquina m1 puerta6 recogida)  [0.001]
0.014: (cargar-equipaje e4 v4 m2 puerta5 n1 n2)  [0.001]
0.015: (mover-maquina m1 recogida inspeccion)  [0.001]
0.015: (mover-maquina m2 puerta5 puerta7)  [0.001]
0.016: (inspeccionar-equipaje e6 inspeccion v1 m1)  [0.001]
0.016: (inspeccionar-equipaje e3 inspeccion v1 m1)  [0.001]
0.016: (mover-maquina m2 puerta7 puerta8)  [0.001]
0.017: (mover-maquina m1 inspeccion recogida)  [0.001]
0.017: (mover-maquina m2 puerta8 puerta6)  [0.001]
0.018: (descargar-normal e6 v1 m1 recogida n2 n1)  [0.001]
0.018: (mover-maquina m2 puerta6 recogida)  [0.001]
0.019: (descargar-normal e3 v1 m1 recogida n1 n0)  [0.001]
0.019: (descargar-normal e5 v4 m2 recogida n2 n1)  [0.001]
0.020: (descargar-normal e4 v4 m2 recogida n1 n0)  [0.001]
0.020: (mover-maquina m1 recogida puerta6)  [0.001]
0.021: (mover-maquina m2 recogida puerta6)  [0.001]
0.021: (mover-maquina m1 puerta6 puerta8)  [0.001]
0.022: (mover-maquina m2 puerta6 puerta8)  [0.001]
0.022: (mover-maquina m1 puerta8 puerta7)  [0.001]
0.023: (mover-maquina m2 puerta8 puerta7)  [0.001]
0.023: (mover-maquina m1 puerta7 puerta5)  [0.001]
0.024: (cargar-equipaje e1 v1 m1 puerta5 n0 n1)  [0.001]
0.024: (mover-maquina m2 puerta7 puerta5)  [0.001]
0.025: (mover-maquina m1 puerta5 puerta7)  [0.001]
0.026: (mover-maquina m1 puerta7 puerta8)  [0.001]
0.027: (mover-maquina m1 puerta8 puerta6)  [0.001]
0.028: (mover-maquina m1 puerta6 recogida)  [0.001]
0.029: (mover-maquina m1 recogida facturacion)  [0.001]
0.030: (mover-maquina m1 facturacion puerta2)  [0.001]
0.031: (mover-maquina m1 puerta2 puerta4)  [0.001]
0.032: (descargar-normal e1 v1 m1 puerta4 n1 n0)  [0.001]

 * All goal deadlines now no later than 0.032

Resorting to best-first search
Running WA* with W = 5.000, not restarting with goal states
b (22.000 | 0.000)b (21.000 | 0.009)b (20.000 | 0.010)b (19.000 | 0.011)b (18.000 | 0.018)b (17.000 | 0.018)b (16.000 | 0.020)b (16.000 | 0.018)b (15.000 | 0.021)b (15.000 | 0.019)b (14.000 | 0.019)b (13.000 | 0.021)b (13.000 | 0.020)b (12.000 | 0.024)b (11.000 | 0.024)b (10.000 | 0.025)b (9.000 | 0.026)b (8.000 | 0.027)b (7.000 | 0.029)b (6.000 | 0.030)b (5.000 | 0.031)b (4.000 | 0.032)
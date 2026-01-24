Number of literals: 243
Constructing lookup tables: [10%] [20%] [30%] [40%] [50%] [60%] [70%] [80%] [90%] [100%]
Post filtering unreachable actions:  [10%] [20%] [30%] [40%] [50%] [60%] [70%] [80%] [90%] [100%]
Seeing if metric is defined in terms of task vars or a minimal value of makespan
- Yes it is
Recognised a monotonic-change-induced limit on -1.000*<special>
- Must be >=  the metric
[01;34mFor limits: literal goal index 0, fact (esta-en e1 puerta4), is static or a precondition[00m
[01;34mFor limits: literal goal index 1, fact (esta-en e2 puerta8), is static or a precondition[00m
[01;34mFor limits: literal goal index 2, fact (esta-en e3 recogida), is static or a precondition[00m
[01;34mFor limits: literal goal index 3, fact (esta-en e4 recogida), is static or a precondition[00m
[01;34mFor limits: literal goal index 4, fact (esta-en e5 recogida), is static or a precondition[00m
[01;34mFor limits: literal goal index 5, fact (esta-en e6 recogida), is static or a precondition[00m
Action 3462 - (inspeccionar-equipaje e3 inspeccion v1 m1) is uninteresting once we have fact (normal e3)
Action 3463 - (inspeccionar-equipaje e6 inspeccion v1 m1) is uninteresting once we have fact (normal e6)
Action 3464 - (inspeccionar-equipaje e3 inspeccion v2 m1) is uninteresting once we have fact (normal e3)
Action 3465 - (inspeccionar-equipaje e6 inspeccion v2 m1) is uninteresting once we have fact (normal e6)
Action 3466 - (inspeccionar-equipaje e3 inspeccion v3 m1) is uninteresting once we have fact (normal e3)
Action 3467 - (inspeccionar-equipaje e6 inspeccion v3 m1) is uninteresting once we have fact (normal e6)
Action 3468 - (inspeccionar-equipaje e3 inspeccion v4 m1) is uninteresting once we have fact (normal e3)
Action 3469 - (inspeccionar-equipaje e6 inspeccion v4 m1) is uninteresting once we have fact (normal e6)
Action 3470 - (inspeccionar-equipaje e3 inspeccion v5 m1) is uninteresting once we have fact (normal e3)
Action 3471 - (inspeccionar-equipaje e6 inspeccion v5 m1) is uninteresting once we have fact (normal e6)
Action 3472 - (inspeccionar-equipaje e3 inspeccion v1 m2) is uninteresting once we have fact (normal e3)
Action 3473 - (inspeccionar-equipaje e6 inspeccion v1 m2) is uninteresting once we have fact (normal e6)
Action 3474 - (inspeccionar-equipaje e3 inspeccion v2 m2) is uninteresting once we have fact (normal e3)
Action 3475 - (inspeccionar-equipaje e6 inspeccion v2 m2) is uninteresting once we have fact (normal e6)
Action 3476 - (inspeccionar-equipaje e3 inspeccion v3 m2) is uninteresting once we have fact (normal e3)
Action 3477 - (inspeccionar-equipaje e6 inspeccion v3 m2) is uninteresting once we have fact (normal e6)
Action 3478 - (inspeccionar-equipaje e3 inspeccion v4 m2) is uninteresting once we have fact (normal e3)
Action 3479 - (inspeccionar-equipaje e6 inspeccion v4 m2) is uninteresting once we have fact (normal e6)
Action 3480 - (inspeccionar-equipaje e3 inspeccion v5 m2) is uninteresting once we have fact (normal e3)
Action 3481 - (inspeccionar-equipaje e6 inspeccion v5 m2) is uninteresting once we have fact (normal e6)
Initial heuristic = 22.000, admissible cost estimate 0.006
b (21.000 | 0.004)b (20.000 | 0.008)b (19.000 | 0.009)b (18.000 | 0.013)b (17.000 | 0.015)b (16.000 | 0.016)b (15.000 | 0.019)b (14.000 | 0.020)b (13.000 | 0.021)b (12.000 | 0.021)b (11.000 | 0.023)b (10.000 | 0.025)b (9.000 | 0.025)b (8.000 | 0.026)b (7.000 | 0.027)b (6.000 | 0.028)b (5.000 | 0.028)b (4.000 | 0.028)b (3.000 | 0.028)b (2.000 | 0.028)b (1.000 | 0.028)(G)
; LP calculated the cost

; Plan found with metric 0.029
; Theoretical reachable cost 0.030
; States evaluated so far: 1354
; States pruned based on pre-heuristic cost lower bound: 0
; Time 1.51
0.000: (mover-maquina m1 recogida facturacion)  [0.001]
0.000: (mover-maquina m2 recogida inspeccion)  [0.001]
0.001: (mover-maquina m1 facturacion puerta2)  [0.001]
0.001: (mover-maquina m2 inspeccion puerta1)  [0.001]
0.002: (enganchar-vagon v1 m2 puerta1 n0)  [0.001]
0.002: (mover-maquina m1 puerta2 puerta4)  [0.001]
0.003: (mover-maquina m2 puerta1 inspeccion)  [0.001]
0.003: (mover-maquina m1 puerta4 puerta3)  [0.001]
0.004: (desenganchar-vagon v1 m2 inspeccion n0)  [0.001]
0.004: (mover-maquina m1 puerta3 puerta1)  [0.001]
0.005: (mover-maquina m2 inspeccion puerta5)  [0.001]
0.005: (enganchar-vagon v2 m1 puerta1 n0)  [0.001]
0.006: (mover-maquina m1 puerta1 inspeccion)  [0.001]
0.006: (mover-maquina m2 puerta5 puerta7)  [0.001]
0.007: (mover-maquina m1 inspeccion facturacion)  [0.001]
0.007: (mover-maquina m2 puerta7 puerta8)  [0.001]
0.008: (cargar-equipaje e2 v2 m1 facturacion n0 n1)  [0.001]
0.008: (mover-maquina m2 puerta8 puerta6)  [0.001]
0.009: (cargar-equipaje e1 v2 m1 facturacion n1 n2)  [0.001]
0.009: (mover-maquina m2 puerta6 recogida)  [0.001]
0.010: (mover-maquina m1 facturacion puerta2)  [0.001]
0.010: (mover-maquina m2 recogida inspeccion)  [0.001]
0.011: (descargar-normal e2 v2 m1 puerta2 n2 n1)  [0.001]
0.011: (enganchar-vagon v1 m2 inspeccion n0)  [0.001]
0.012: (mover-maquina m1 puerta2 puerta4)  [0.001]
0.012: (mover-maquina m2 inspeccion facturacion)  [0.001]
0.013: (descargar-normal e1 v2 m1 puerta4 n1 n0)  [0.001]
0.013: (mover-maquina m2 facturacion puerta2)  [0.001]
0.014: (mover-maquina m1 puerta4 puerta2)  [0.001]
0.014: (cargar-equipaje e6 v1 m2 puerta2 n0 n1)  [0.001]
0.015: (mover-maquina m1 puerta2 facturacion)  [0.001]
0.015: (mover-maquina m2 puerta2 facturacion)  [0.001]
0.016: (mover-maquina m1 facturacion puerta2)  [0.001]
0.016: (mover-maquina m2 facturacion recogida)  [0.001]
0.017: (cargar-equipaje e5 v2 m1 puerta2 n0 n1)  [0.001]
0.017: (mover-maquina m2 recogida puerta6)  [0.001]
0.018: (mover-maquina m1 puerta2 facturacion)  [0.001]
0.018: (cargar-equipaje e4 v1 m2 puerta6 n1 n2)  [0.001]
0.019: (mover-maquina m1 facturacion recogida)  [0.001]
0.019: (mover-maquina m2 puerta6 recogida)  [0.001]
0.020: (descargar-normal e5 v2 m1 recogida n1 n0)  [0.001]
0.020: (descargar-normal e4 v1 m2 recogida n2 n1)  [0.001]
0.021: (mover-maquina m1 recogida inspeccion)  [0.001]
0.021: (mover-maquina m2 recogida puerta6)  [0.001]
0.022: (cargar-equipaje e3 v1 m2 puerta6 n1 n2)  [0.001]
0.022: (mover-maquina m1 inspeccion facturacion)  [0.001]
0.023: (mover-maquina m2 puerta6 recogida)  [0.001]
0.023: (mover-maquina m1 facturacion puerta2)  [0.001]
0.024: (mover-maquina m2 recogida inspeccion)  [0.001]
0.024: (cargar-equipaje e2 v2 m1 puerta2 n0 n1)  [0.001]
0.025: (inspeccionar-equipaje e6 inspeccion v1 m2)  [0.001]
0.025: (inspeccionar-equipaje e3 inspeccion v1 m2)  [0.001]
0.025: (mover-maquina m1 puerta2 facturacion)  [0.001]
0.026: (mover-maquina m2 inspeccion recogida)  [0.001]
0.026: (mover-maquina m1 facturacion recogida)  [0.001]
0.027: (descargar-normal e6 v1 m2 recogida n2 n1)  [0.001]
0.027: (mover-maquina m1 recogida puerta6)  [0.001]
0.028: (mover-maquina m1 puerta6 puerta8)  [0.001]
0.029: (descargar-normal e2 v2 m1 puerta8 n1 n0)  [0.001]
0.029: (descargar-normal e3 v1 m2 recogida n1 n0)  [0.001]

 * All goal deadlines now no later than 0.029

Resorting to best-first search
Running WA* with W = 5.000, not restarting with goal states
b (21.000 | 0.004)b (20.000 | 0.007)b (19.000 | 0.008)b (17.000 | 0.011)b (16.000 | 0.012)b (15.000 | 0.014)b (14.000 | 0.015)b (13.000 | 0.016)b (12.000 | 0.019)b (11.000 | 0.020)b (10.000 | 0.023)b (9.000 | 0.026)b (8.000 | 0.027)b (7.000 | 0.028)b (7.000 | 0.025)b (6.000 | 0.026)b (5.000 | 0.027)b (4.000 | 0.027)b (3.000 | 0.027)b (2.000 | 0.027)b (1.000 | 0.027)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)(G)
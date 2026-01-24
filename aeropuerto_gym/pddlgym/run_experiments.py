import os
import csv
import time
import random
import numpy as np
import pddlgym


# =========================
# CONFIG EXPERIMENTOS
# =========================
ENV_NAME = "PDDLEnvAeropuerto-v0"

# Problemas (según tu comprobación)
PROBLEMS = {
    0: "S_pfile1",
    1: "M_pfile2",
    2: "L_pfile3",
    3: "IMP_pfile4",
}

# Grid pequeño y defendible (12 configs)
ALPHAS = [0.1, 0.2, 0.5]
GAMMAS = [0.90, 0.99]

EPS_STRATEGIES = [
    # (name, epsilon_start, epsilon_min, epsilon_decay)
    ("eps_decay_fast", 1.0, 0.05, 0.995),
    ("eps_decay_slow", 1.0, 0.05, 0.999),
]

SEEDS = [0, 1, 2]  # mínimo 3

TOTAL_EPISODES = 1000
MAX_STEPS = 2000

# Para evitar bucles infinitos al "planificar" (política greedy)
MAX_PLAN_STEPS = 500

OUTDIR = "results_aeropuerto"


# =========================
# UTILIDADES
# =========================
def ensure_dir(path: str):
    os.makedirs(path, exist_ok=True)

def moving_average(x, w=50):
    if len(x) < w:
        return []
    return np.convolve(np.array(x, dtype=float), np.ones(w)/w, mode="valid").tolist()

def state_key(state):
    """
    Clave hashable y estable para indexar estados.
    pddlgym State suele ser hashable, pero esta forma siempre funciona.
    """
    return str(sorted([str(l) for l in state.literals]))


# =========================
# EJECUCIÓN 1 EXPERIMENTO
# =========================
def run_one(problem_index: int, alpha: float, gamma: float,
            eps_name: str, eps_start: float, eps_min: float, eps_decay: float,
            seed: int):

    random.seed(seed)
    np.random.seed(seed)

    env = pddlgym.make(ENV_NAME)
    env.fix_problem_index(problem_index)

    # Reset inicial para definir espacio de acciones
    state, debug_info = env.reset()
    env.action_space.all_ground_literals(state)  # activa _all_ground_literals

    acciones = list(env.action_space._all_ground_literals)
    acciones.sort(key=str)
    num_acciones = len(acciones)
    idx_accion = {a: i for i, a in enumerate(acciones)}

    # Q-table incremental por estados visitados
    vistos = []
    idx_estado = {}  # state_key -> fila
    Q_table = np.zeros((0, num_acciones), dtype=float)

    def ensure_state_in_table(s):
        k = state_key(s)
        if k not in idx_estado:
            idx_estado[k] = len(vistos)
            vistos.append(s)
            return True
        return False

    # Asegura estado inicial
    ensure_state_in_table(state)
    Q_table = np.vstack([Q_table, np.zeros((1, num_acciones), dtype=float)])

    epsilon = eps_start

    # Logging por episodio
    ep_done = []
    ep_steps = []
    ep_return = []
    ep_epsilon = []
    ep_num_states = []

    start_time = time.time()

    # ========= TRAIN =========
    for episode in range(TOTAL_EPISODES):
        state, _ = env.reset()
        if ensure_state_in_table(state):
            Q_table = np.vstack([Q_table, np.zeros((1, num_acciones), dtype=float)])

        total_reward = 0.0
        done_flag = 0
        steps_used = 0

        for step in range(MAX_STEPS):
            aplicables = env.action_space.all_ground_literals(state)

            # ε-greedy
            if random.uniform(0, 1) > epsilon:
                # explotación: mejor acción aplicable
                fila = idx_estado[state_key(state)]
                best_a = None
                best_q = -float("inf")
                for a in aplicables:
                    j = idx_accion[a]
                    q = Q_table[fila, j]
                    if q > best_q:
                        best_q = q
                        best_a = a
                action = best_a
            else:
                # exploración
                action = env.action_space.sample(state)

            new_state, reward, done, truncated, info = env.step(action)
            total_reward += float(reward)
            steps_used = step + 1

            if ensure_state_in_table(new_state):
                Q_table = np.vstack([Q_table, np.zeros((1, num_acciones), dtype=float)])

            # Actualización Q
            fila_s = idx_estado[state_key(state)]
            fila_ns = idx_estado[state_key(new_state)]
            col_a = idx_accion[action]

            if done:
                max_next = 0.0
            else:
                aplicables_ns = env.action_space.all_ground_literals(new_state)
                max_next = -float("inf")
                for a2 in aplicables_ns:
                    j2 = idx_accion[a2]
                    max_next = max(max_next, Q_table[fila_ns, j2])
                if max_next == -float("inf"):
                    max_next = 0.0

            Q_table[fila_s, col_a] = Q_table[fila_s, col_a] + alpha * (
                reward + gamma * max_next - Q_table[fila_s, col_a]
            )

            state = new_state
            if done:
                done_flag = 1
                break

        # Log episodio
        ep_done.append(done_flag)
        ep_steps.append(steps_used)
        ep_return.append(total_reward)
        ep_epsilon.append(epsilon)
        ep_num_states.append(len(vistos))

        # Decaimiento epsilon
        epsilon = max(eps_min, epsilon * eps_decay)

    train_time = time.time() - start_time

    # ========= EVAL (plan greedy) =========
    state, _ = env.reset()
    plan = []
    plan_done = 0

    for _ in range(MAX_PLAN_STEPS):
        if ensure_state_in_table(state):
            Q_table = np.vstack([Q_table, np.zeros((1, num_acciones), dtype=float)])

        aplicables = env.action_space.all_ground_literals(state)
        fila = idx_estado[state_key(state)]

        best_a = None
        best_q = -float("inf")
        for a in aplicables:
            j = idx_accion[a]
            q = Q_table[fila, j]
            if q > best_q:
                best_q = q
                best_a = a

        if best_a is None:
            break

        plan.append(str(best_a))
        state, reward, done, truncated, info = env.step(best_a)
        if done:
            plan_done = 1
            break

    result = {
        "debug_info": debug_info,
        "num_actions": num_acciones,
        "num_states": len(vistos),
        "train_time_sec": train_time,
        "plan_done": plan_done,
        "plan_len": len(plan),
        "plan": plan,
        "ep_done": ep_done,
        "ep_steps": ep_steps,
        "ep_return": ep_return,
        "ep_epsilon": ep_epsilon,
        "ep_num_states": ep_num_states,
    }
    return result


# =========================
# MAIN: corre todo y guarda CSVs
# =========================
def main():
    ensure_dir(OUTDIR)

    summary_path = os.path.join(OUTDIR, "summary.csv")
    with open(summary_path, "w", newline="") as fsum:
        sum_writer = csv.writer(fsum)
        sum_writer.writerow([
            "problem_index", "problem_name",
            "alpha", "gamma", "eps_name", "eps_start", "eps_min", "eps_decay",
            "seed",
            "num_actions", "num_states", "train_time_sec",
            "success_rate_last100", "avg_steps_success_last100",
            "plan_done", "plan_len"
        ])

        for pidx, pname in PROBLEMS.items():
            for alpha in ALPHAS:
                for gamma in GAMMAS:
                    for (eps_name, eps_start, eps_min, eps_decay) in EPS_STRATEGIES:
                        for seed in SEEDS:

                            print(f"\nRUN -> {pname} (idx={pidx}) | alpha={alpha} gamma={gamma} {eps_name} | seed={seed}")
                            res = run_one(pidx, alpha, gamma, eps_name, eps_start, eps_min, eps_decay, seed)

                            # Guardar episodios a CSV
                            run_id = f"{pname}_a{alpha}_g{gamma}_{eps_name}_seed{seed}"
                            ep_path = os.path.join(OUTDIR, f"{run_id}_episodes.csv")
                            with open(ep_path, "w", newline="") as fep:
                                ep_writer = csv.writer(fep)
                                ep_writer.writerow(["episode", "done", "steps", "return", "epsilon", "num_states"])
                                for i in range(TOTAL_EPISODES):
                                    ep_writer.writerow([
                                        i,
                                        res["ep_done"][i],
                                        res["ep_steps"][i],
                                        res["ep_return"][i],
                                        res["ep_epsilon"][i],
                                        res["ep_num_states"][i]
                                    ])

                            # Métricas de resumen (últimos 100 episodios)
                            last = 100
                            done_last = res["ep_done"][-last:]
                            steps_last = res["ep_steps"][-last:]
                            success_rate = sum(done_last) / float(last)

                            # Pasos medios SOLO en episodios exitosos (últimos 100)
                            steps_success = [steps_last[i] for i in range(last) if done_last[i] == 1]
                            avg_steps_success = (sum(steps_success) / len(steps_success)) if steps_success else -1

                            # Guardar summary
                            sum_writer.writerow([
                                pidx, pname,
                                alpha, gamma, eps_name, eps_start, eps_min, eps_decay,
                                seed,
                                res["num_actions"], res["num_states"], f"{res['train_time_sec']:.3f}",
                                f"{success_rate:.3f}", f"{avg_steps_success:.3f}",
                                res["plan_done"], res["plan_len"]
                            ])

                            # Guardar plan greedy
                            plan_path = os.path.join(OUTDIR, f"{run_id}_plan.txt")
                            with open(plan_path, "w") as fp:
                                fp.write("\n".join(res["plan"]))

    print("\nLISTO. Resultados en:", OUTDIR)
    print("Resumen:", summary_path)


if __name__ == "__main__":
    main()

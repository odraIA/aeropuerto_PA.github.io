import pddlgym

env = pddlgym.make("PDDLEnvAeropuerto-v0")

# Como tú sabes que tienes 4 problemas: pfile1..pfile4
for i in range(4):
    env.fix_problem_index(i)
    state, debug = env.reset()

    print("\n==============================")
    print("problem_index =", i)
    print("debug_info =", debug)  # suele incluir info útil del problema

    # Para distinguirlos, imprime algunas cosas del estado inicial
    lits = sorted([str(l) for l in state.literals])
    print("Num literales:", len(lits))
    print("Primeros 15 literales:")
    for l in lits[:15]:
        print(" ", l)

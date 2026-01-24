import pddlgym
# Creo entorno pddlgym con el dominio
env = pddlgym.make("PDDLEnvAeropuerto-v0")
# Fijo el problema al primero alfab´eticamente (por si hay varios)
env.fix_problem_index(0)
# Con la funci´on reset() empiezo un episodio devolviendo al agente
# al estado inicial.
state, debug_info = env.reset()
# Tambi´en podemos ver las acciones aplicables en el estado
print(env.action_space.all_ground_literals(state))
done = False
while not done:
# Escojo una accion aleatoria en el espacio de acciones
# del estado a aplicar
    action = env.action_space.sample(state)
# La muestro por pantalla
    print(action)
# La aplico y genero un nuevo estado
    state, reward, done, truncated, info = env.step(action)

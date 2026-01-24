import numpy as np
import pddlgym
import random
'''
INICIALIZACIÓN DE PARÁMETROS
'''
# Crear entorno de PDDLGym a partir de nuestro dominio
env = pddlgym.make("PDDLEnvAeropuerto-v0")
# Fijar el problema del entorno
env.fix_problem_index(0)
# Iniciar el entorno con el agente para que esté en el lugar inicial
state, debug_info = env.reset()
# Definición de la Q-table
####################################################################
#                                                                  #
#               RELLENAR: DEFINICIÓN DE Q-TABLE                     #
#                                                                  #
####################################################################

# 1) Activar el atributo interno _all_ground_literals (requisito PDDLGym)
env.action_space.all_ground_literals(state)

# 2) Definir el espacio COMPLETO de acciones (columnas fijas)
acciones = list(env.action_space._all_ground_literals)
acciones.sort(key=str)  # orden estable
num_acciones = len(acciones)

# 3) Estados vistos (filas incrementales)
vistos = [state]

# 4) Q-table inicial: 1 fila (estado inicial) x num_acciones columnas
Q_table = np.zeros((1, num_acciones), dtype=float)

# 5) Diccionario para mapear acciones a columnas (más rápido que .index)
idx_accion = {a: i for i, a in enumerate(acciones)}

'''
DEFINICIÓN DE HIPERPARÁMETROS DEL Q-LEARNING
'''
total_episodes = 1000
learning_rate = 0.2 # Alpha in Q-learning algorithm
max_steps = 2000
gamma = 0.99 # Discount factor
####################################################################
#                                                                  #
#              RELLENAR: PARÁMETROS DE EXPLORACIÓN                  #
#                                                                  #
####################################################################
# Ejemplo (ε-greedy con decaimiento)
epsilon = 1.0
epsilon_min = 0.05
epsilon_decay = 0.995

'''
ALGORITMO Q-LEARNING
'''
# Entrenamos hasta un número máximo de episodios (reinicios)
for episode in range(total_episodes):
    state, debug = env.reset()

    # Si el estado inicial del episodio no estaba, lo añadimos
    if state not in vistos:
        vistos.append(state)
        Q_table = np.vstack([Q_table, np.zeros((1, num_acciones), dtype=float)])

    # El agente irá tomando decisiones hasta un número máximo de pasos
    for step in range(max_steps):
        '''
        EXPLORACIÓN-EXPLOTACIÓN
        '''
        # Aseguramos que se conocen las acciones aplicables (y actualiza internamente)
        aplicables = env.action_space.all_ground_literals(state)

        # Ejemplo ε-greedy
        if random.uniform(0,1) > epsilon:
            # EXPLOTACIÓN: mejor acción aplicable según Q_table
            fila = vistos.index(state)
            mejor_accion = None
            mejor_q = -float("inf")
            for a in aplicables:
                j = idx_accion[a]
                q = Q_table[fila, j]
                if q > mejor_q:
                    mejor_q = q
                    mejor_accion = a
            action = mejor_accion
        else:
            # EXPLORACIÓN SEGÚN ALGORITMO
            action = env.action_space.sample(state)

        new_state, reward, done, truncated, info = env.step(action)

        # Añadir nuevo estado si no existía
        if new_state not in vistos:
            vistos.append(new_state)
            Q_table = np.vstack([Q_table, np.zeros((1, num_acciones), dtype=float)])

        ####################################################################
        #                                                                  #
        #                 RELLENAR: ACTUALIZAR TABLA                        #
        #                                                                  #
        ####################################################################

        fila_s = vistos.index(state)
        fila_ns = vistos.index(new_state)
        col_a = idx_accion[action]

        # max_a' Q(s',a') SOLO sobre acciones aplicables en s'
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

        # Regla Q-learning:
        # Q(s,a) <- Q(s,a) + alpha * (r + gamma*maxQ(s') - Q(s,a))
        Q_table[fila_s, col_a] = Q_table[fila_s, col_a] + learning_rate * (
            reward + gamma * max_next - Q_table[fila_s, col_a]
        )

        state = new_state
        if done:
            break

    # Decaimiento de epsilon al final de cada episodio
    epsilon = max(epsilon_min, epsilon * epsilon_decay)

'''
APLICACIÓN DE LA Q-TABLE PARA SACAR UN PLAN CON LA POLÍTICA
'''
state, debug = env.reset()
while True:
    # Valor numérico del estado para sacar la fila de la tabla
    if state not in vistos:
        vistos.append(state)
        Q_table = np.vstack([Q_table, np.zeros((1, num_acciones), dtype=float)])
    index = vistos.index(state)

    ####################################################################
    #                                                                  #
    #                       RELLENAR: PLANIFICAR                        #
    #                                                                  #
    ####################################################################

    aplicables = env.action_space.all_ground_literals(state)

    # Elegir mejor acción aplicable según Q_table (greedy)
    mejor_accion = None
    mejor_q = -float("inf")
    for a in aplicables:
        j = idx_accion[a]
        q = Q_table[index, j]
        if q > mejor_q:
            mejor_q = q
            mejor_accion = a

    accion_a_aplicar = mejor_accion
    print(accion_a_aplicar)

    state, reward, done, truncated, info = env.step(accion_a_aplicar)
    # Acabo cuando llego al objetivo
    if done:
        break

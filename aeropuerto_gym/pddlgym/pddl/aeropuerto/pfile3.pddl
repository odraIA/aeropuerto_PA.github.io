(define (problem aeropuerto-pfile3)
  (:domain aeropuerto)

  (:objects
    facturacion recogida inspeccion pasillo1 pasillo2 pasillo3 pasillo4
    puerta1 puerta2 puerta3 puerta4 puerta5 puerta6 puerta7 puerta8 - ubicacion

    m1 - maquina
    v1 v2 - vagon
    e1 - equipaje

    n0 n1 - nivel
  )

  (:init
    ; Grafo grande con rutas alternativas
    (siguiente recogida pasillo1)
    (siguiente pasillo1 recogida)

    (siguiente pasillo1 facturacion)
    (siguiente facturacion pasillo1)

    (siguiente facturacion pasillo2)
    (siguiente pasillo2 facturacion)

    (siguiente pasillo2 inspeccion)
    (siguiente inspeccion pasillo2)

    (siguiente inspeccion pasillo3)
    (siguiente pasillo3 inspeccion)

    (siguiente pasillo2 pasillo4)
    (siguiente pasillo4 pasillo2)

    ; Alternativa extra (más ciclos)
    (siguiente pasillo1 pasillo3)
    (siguiente pasillo3 pasillo1)

    ; Conexiones a puertas (más branching)
    (siguiente pasillo3 puerta1)
    (siguiente puerta1 pasillo3)

    (siguiente facturacion puerta2)
    (siguiente puerta2 facturacion)

    (siguiente pasillo4 puerta3)
    (siguiente puerta3 pasillo4)

    (siguiente facturacion puerta4)
    (siguiente puerta4 facturacion)

    (siguiente pasillo3 puerta5)
    (siguiente puerta5 pasillo3)

    (siguiente recogida puerta6)
    (siguiente puerta6 recogida)

    (siguiente pasillo3 puerta7)
    (siguiente puerta7 pasillo3)

    (siguiente recogida puerta8)
    (siguiente puerta8 recogida)

    ; Oficina de inspección
    (es-oficina-inspeccion inspeccion)

    ; Máquina
    (maquina-en m1 recogida)
    (maquina-libre m1)

    ; Dos vagones (aumenta el espacio de acciones)
    (vagon-en v1 puerta1)
    (vagon-suelto v1)

    (vagon-en v2 puerta8)
    (vagon-suelto v2)

    ; Capacidad 1 con niveles (para ambos vagones)
    (nivel-cero n0)

    (en-nivel v1 n0)
    (en-nivel v2 n0)

    (siguiente-nivel n0 n1)

    ; Equipaje (sospechoso) en una puerta lejana
    (equipaje-en e1 puerta7)
    (sospechoso e1)
  )

  (:goal (and
    (equipaje-en e1 recogida)
  ))
)

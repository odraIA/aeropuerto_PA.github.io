(define (problem aeropuerto-pfile2)
  (:domain aeropuerto)

  (:objects
    facturacion recogida inspeccion pasillo1 pasillo2
    puerta1 puerta2 puerta3 puerta4 puerta5 puerta6 - ubicacion

    m1 - maquina
    v1 - vagon
    e1 - equipaje

    n0 n1 - nivel
  )

  (:init
    ; Grafo (más grande que S)
    (siguiente recogida pasillo1)
    (siguiente pasillo1 recogida)

    (siguiente pasillo1 facturacion)
    (siguiente facturacion pasillo1)

    (siguiente facturacion pasillo2)
    (siguiente pasillo2 facturacion)

    (siguiente pasillo2 inspeccion)
    (siguiente inspeccion pasillo2)

    (siguiente inspeccion puerta1)
    (siguiente puerta1 inspeccion)

    (siguiente facturacion puerta2)
    (siguiente puerta2 facturacion)

    (siguiente pasillo2 puerta3)
    (siguiente puerta3 pasillo2)

    (siguiente puerta3 puerta4)
    (siguiente puerta4 puerta3)

    (siguiente inspeccion puerta5)
    (siguiente puerta5 inspeccion)

    (siguiente recogida puerta6)
    (siguiente puerta6 recogida)

    ; Oficina de inspección
    (es-oficina-inspeccion inspeccion)

    ; Máquina y vagón
    (maquina-en m1 recogida)
    (maquina-libre m1)

    (vagon-en v1 puerta1)
    (vagon-suelto v1)

    ; Capacidad 1 con niveles
    (nivel-cero n0)
    (en-nivel v1 n0)
    (siguiente-nivel n0 n1)

    ; Equipaje inicial (sospechoso y más lejos)
    (equipaje-en e1 puerta4)
    (sospechoso e1)
  )

  (:goal (and
    (equipaje-en e1 recogida)
  ))
)

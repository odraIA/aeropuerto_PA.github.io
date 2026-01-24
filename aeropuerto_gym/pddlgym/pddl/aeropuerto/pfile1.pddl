(define (problem aeropuerto-pfile1)
  (:domain aeropuerto)

  ((:objects
  facturacion recogida inspeccion puerta1 puerta2 puerta5 puerta6 - ubicacion
  m1 - maquina
  v1 - vagon
  e1 - equipaje
  n0 n1 - nivel
)


  (:init
    ; Terminal reducida (sin puertas 3,4,7,8)
    (siguiente facturacion recogida)
    (siguiente recogida facturacion)

    (siguiente facturacion inspeccion)
    (siguiente inspeccion facturacion)

    (siguiente inspeccion puerta1)
    (siguiente puerta1 inspeccion)

    (siguiente facturacion puerta2)
    (siguiente puerta2 facturacion)

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

    ; Capacidad 1 con niveles (solo n0->n1)
    (nivel-cero n0)
    (en-nivel v1 n0)
    (siguiente-nivel n0 n1)

    ; Equipaje inicial (sospechoso)
    (equipaje-en e1 puerta2)
    (sospechoso e1)

    ; NOTA:
    ; No hace falta (vagon-libre v1) al inicio para este problema,
    ; porque el primer enganche será v1 a una máquina y eso usa (maquina-libre).
    ; Si algún día quieres enganchar un vagón detrás de v1, entonces v1 deberá ser (vagon-libre).
  )

  (:goal (and
    (equipaje-en e1 recogida)
  ))
)

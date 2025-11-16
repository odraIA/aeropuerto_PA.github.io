(define (problem aeropuerto-p1)
  (:domain aeropuerto)

  (:objects
    ;; ubicaciones
    facturacion recogida inspeccion
    puerta1 puerta2 puerta3 puerta4
    puerta5 puerta6 puerta7 puerta8 - ubicacion

    ;; maquinas
    m1 m2 - maquina

    ;; vagones
    v1 v2 v3 v4 v5 - vagon

    ;; equipajes
    e1 e2 e3 e4 e5 e6 - equipaje
  )

  (:init
    ;; ---------- Estructura de la terminal ----------
    ;; zona común
    (siguiente facturacion recogida)
    (siguiente recogida facturacion)

    (siguiente facturacion inspeccion)
    (siguiente inspeccion facturacion)

    (siguiente recogida inspeccion)
    (siguiente inspeccion recogida)

    ;; conexiones con puertas
    (siguiente facturacion puerta2)
    (siguiente puerta2 facturacion)

    (siguiente recogida puerta6)
    (siguiente puerta6 recogida)

    (siguiente inspeccion puerta1)
    (siguiente puerta1 inspeccion)

    (siguiente inspeccion puerta5)
    (siguiente puerta5 inspeccion)

    ;; pasillo izquierdo: puertas contiguas 2–4–3–1
    (siguiente puerta2 puerta4)
    (siguiente puerta4 puerta2)

    (siguiente puerta4 puerta3)
    (siguiente puerta3 puerta4)

    (siguiente puerta3 puerta1)
    (siguiente puerta1 puerta3)

    ;; pasillo derecho: puertas contiguas 6–8–7–5
    (siguiente puerta6 puerta8)
    (siguiente puerta8 puerta6)

    (siguiente puerta8 puerta7)
    (siguiente puerta7 puerta8)

    (siguiente puerta7 puerta5)
    (siguiente puerta5 puerta7)

    ;; ---------- Oficina de inspección ----------
    (es-oficina-inspeccion inspeccion)

    ;; ---------- Vehículos ----------
    ;; tres vagones sueltos en puerta1
    (en-vagon v1 puerta1)
    (en-vagon v2 puerta1)
    (en-vagon v3 puerta1)

    ;; dos vagones sueltos en puerta5
    (en-vagon v4 puerta5)
    (en-vagon v5 puerta5)

    ;; todos los vagones empiezan libres y vacíos (n0)
    (vagon-libre v1)
    (vagon-libre v2)
    (vagon-libre v3)
    (vagon-libre v4)
    (vagon-libre v5)

    (n0 v1)
    (n0 v2)
    (n0 v3)
    (n0 v4)
    (n0 v5)

    ;; dos máquinas en la zona de recogida
    (en-maquina m1 recogida)
    (en-maquina m2 recogida)

    ;; ---------- Equipajes ----------
    ;; 1) no sospechoso facturado → puerta4
    (equipaje-en e1 facturacion)
    (normal e1)

    ;; 2) no sospechoso facturado → puerta8
    (equipaje-en e2 facturacion)
    (normal e2)

    ;; 3) sospechoso llega a puerta6 → recogida (pasando por inspección)
    (equipaje-en e3 puerta6)
    (sospechoso e3)

    ;; 4) no sospechoso llega a puerta6 → recogida
    (equipaje-en e4 puerta6)
    (normal e4)

    ;; 5) no sospechoso llega a puerta2 → recogida
    (equipaje-en e5 puerta2)
    (normal e5)

    ;; 6) sospechoso llega a puerta2 → recogida (pasando por inspección)
    (equipaje-en e6 puerta2)
    (sospechoso e6)
    )

  (:goal
    (and
      ;; destinos finales
      (equipaje-en e1 puerta4)
      (equipaje-en e2 puerta8)

      (equipaje-en e3 recogida)
      (equipaje-en e4 recogida)
      (equipaje-en e5 recogida)
      (equipaje-en e6 recogida)

      ;; los sospechosos han tenido que ser inspeccionados
      (normal e3)
      (normal e6)
    )
  )
)


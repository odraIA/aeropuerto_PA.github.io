(define (domain aeropuerto)
  (:requirements :strips :typing)

  (:types
    ubicacion
    maquina
    vagon
    equipaje
    nivel
  )

  (:predicates
    ; Grafo de la terminal
    (siguiente ?desde - ubicacion ?hasta - ubicacion)

    ; Posición
    (maquina-en ?m - maquina ?u - ubicacion)
    (vagon-en ?v - vagon ?u - ubicacion)
    (equipaje-en ?e - equipaje ?u - ubicacion)

    ; Enganches
    (enganchado-a-maquina ?v - vagon ?m - maquina)
    (enganchado-a-vagon ?v - vagon ?w - vagon)

    ; Estado de vagones, significa que no esta enganchado a nada y puede ser enganchado
    (vagon-suelto ?v - vagon)

    ; Si estan libres, no tienen nada enganchado detras, puede otro vagón engancharse
    (maquina-libre ?m - maquina)
    (vagon-libre ?w - vagon)

    ; Equipajes
    (equipaje-en-vagon ?e - equipaje ?v - vagon)

    ; Contador de capacidad del vagón (usando niveles)
    (en-nivel ?v - vagon ?n - nivel)
    (siguiente-nivel ?n1 - nivel ?n2 - nivel)
    (nivel-cero ?n - nivel)

    ; Tipo de equipaje
    (normal ?e - equipaje)
    (sospechoso ?e - equipaje)

    ; Oficina inspección
    (es-oficina-inspeccion ?u - ubicacion)
  )

  ; Mover la máquina por el grafo
  (:action mover-maquina
    :parameters (?m - maquina ?desde - ubicacion ?hasta - ubicacion)
    :precondition (and
      (maquina-en ?m ?desde)
      (siguiente ?desde ?hasta)
    )
    :effect (and
      (maquina-en ?m ?hasta)
      (not (maquina-en ?m ?desde))
    )
  )

  ; Enganchar vagón a MÁQUINA
  (:action enganchar-vagon-a-maquina
    :parameters (?v - vagon ?m - maquina ?u - ubicacion ?n - nivel)
    :precondition (and
      (vagon-suelto ?v)
      (en-nivel ?v ?n)
      (nivel-cero ?n)
      (vagon-en ?v ?u)
      (maquina-en ?m ?u)
      (maquina-libre ?m)
    )
    :effect (and
      (enganchado-a-maquina ?v ?m)
      (not (vagon-suelto ?v))
      (not (vagon-en ?v ?u))
      (not (maquina-libre ?m))
      (vagon-libre ?v)
    )
  )

  ; Enganchar vagón a VAGÓN
  (:action enganchar-vagon-a-vagon
    :parameters (?v - vagon ?w - vagon ?u - ubicacion ?n - nivel)
    :precondition (and
      (vagon-suelto ?v)
      (en-nivel ?v ?n)
      (nivel-cero ?n)
      (vagon-en ?v ?u)
      (vagon-en ?w ?u)
      (vagon-libre ?w)
    )
    :effect (and
      (enganchado-a-vagon ?v ?w)
      (not (vagon-suelto ?v))
      (not (vagon-en ?v ?u))
      (not (vagon-libre ?w))
      (vagon-libre ?v)
    )
  )

  ; Desenganchar vagón de MÁQUINA
  (:action desenganchar-vagon-de-maquina
    :parameters (?v - vagon ?m - maquina ?u - ubicacion ?n - nivel)
    :precondition (and
      (enganchado-a-maquina ?v ?m)
      (en-nivel ?v ?n)
      (nivel-cero ?n)
      (maquina-en ?m ?u)
    )
    :effect (and
      (vagon-suelto ?v)
      (not (vagon-libre ?v))
      (vagon-en ?v ?u)
      (not (enganchado-a-maquina ?v ?m))
      (maquina-libre ?m)
    )
  )

  ; Desenganchar vagón de VAGÓN
  (:action desenganchar-vagon-de-vagon
    :parameters (?v - vagon ?w - vagon ?u - ubicacion ?n - nivel)
    :precondition (and
      (enganchado-a-vagon ?v ?w)
      (en-nivel ?v ?n)
      (nivel-cero ?n)
      (vagon-en ?w ?u)
    )
    :effect (and
      (vagon-suelto ?v)
      (not (vagon-libre ?v))
      (vagon-en ?v ?u)
      (not (enganchado-a-vagon ?v ?w))
      (vagon-libre ?w)
    )
  )

  ; Cargar equipaje (aumenta nivel)
  (:action cargar-equipaje
    :parameters (?e - equipaje ?v - vagon ?m - maquina ?u - ubicacion ?n1 - nivel ?n2 - nivel)
    :precondition (and
      (maquina-en ?m ?u)
      (enganchado-a-maquina ?v ?m)
      (equipaje-en ?e ?u)
      (en-nivel ?v ?n1)
      (siguiente-nivel ?n1 ?n2)
    )
    :effect (and
      (equipaje-en-vagon ?e ?v)
      (not (equipaje-en ?e ?u))
      (en-nivel ?v ?n2)
      (not (en-nivel ?v ?n1))
    )
  )

  ; Descargar equipaje normal (baja nivel)
  (:action descargar-normal
    :parameters (?e - equipaje ?v - vagon ?m - maquina ?u - ubicacion ?n1 - nivel ?n2 - nivel)
    :precondition (and
      (normal ?e)
      (equipaje-en-vagon ?e ?v)
      (enganchado-a-maquina ?v ?m)
      (maquina-en ?m ?u)
      (en-nivel ?v ?n1)
      (siguiente-nivel ?n2 ?n1)
    )
    :effect (and
      (equipaje-en ?e ?u)
      (not (equipaje-en-vagon ?e ?v))
      (en-nivel ?v ?n2)
      (not (en-nivel ?v ?n1))
    )
  )

  ; Inspeccionar equipaje sospechoso en oficina
  (:action inspeccionar-equipaje
    :parameters (?e - equipaje ?u - ubicacion ?v - vagon ?m - maquina)
    :precondition (and
      (sospechoso ?e)
      (equipaje-en-vagon ?e ?v)
      (enganchado-a-maquina ?v ?m)
      (maquina-en ?m ?u)
      (es-oficina-inspeccion ?u)
    )
    :effect (and
      (normal ?e)
      (not (sospechoso ?e))
    )
  )
)

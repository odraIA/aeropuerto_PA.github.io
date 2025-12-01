; LO QUE DIJERON EN CLASE
; para contar lo que debemos hacer es crear predicados que sean
;      n0, n1, n2, ..., nk y poner a true sólo el numero que llevamos
; cuidado al enganchar, no se pueden desenganchar vagones con paquetes
; no se puede enganchar un vagón al medio
; No hace falta desenganchar un vagón para dejar un paquete
; No se puede dejar un paquete sospechoso
; El método para inspeccionar da igual (dejar paquete, vagón o tren entero) pero debemos dejarlo explicado
; ESTÁ PROHIBIDO USAR PRECONDICIONES NEGATIVAS PORQUE EL PLANIFICADOR OPTIC NO LAS SOPORTA

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
    (siguiente ?desde - ubicacion ?hasta - ubicacion) ; Se puede ir desde, hasta según el mapa

    ; Global
    (esta-en ?m - (either maquina equipaje vagon) ?u - ubicacion)   ; la máquina m está en la ubicación u
    
    ; Vehículos
    (enganchado ?v - vagon ?m - (either maquina vagon)) ; el vagón v está enganchado a la máquina m
    (vagon-suelto ?v - vagon)                  ; v está suelto (no enganchado a ninguna máquina)
    (libre ?m - (either maquina vagon))

    ; Equipajes
    (equipaje-en-vagon ?e - equipaje ?v - vagon)    ; e está dentro del vagón v

    ; Contador de capacidad del vagón (capacidad = 2)
    (en-nivel ?v - vagon ?n - nivel)                ; el vagón v esta en el nivel n
    (siguiente-nivel ?n1 - nivel ?n2 - nivel)
    (nivel-cero ?n - nivel)

    ; Tipo de equipaje
    (normal ?e - equipaje)
    (sospechoso ?e - equipaje)

    ; Marcar oficina de inspección
    (es-oficina-inspeccion ?u - ubicacion)
  )

  ; Mover la máquina por el grafo

  (:action mover-maquina
    :parameters (?m - maquina ?desde ?hasta - ubicacion)
    :precondition (and
      (esta-en ?m ?desde)
      (siguiente ?desde ?hasta)
    )
    :effect (and
      (esta-en ?m ?hasta)
      (not (esta-en ?m ?desde))
    )
  )

  ;   Enganchar / desenganchar vagones 

  (:action enganchar-vagon
    :parameters (?v - vagon ?m - (either maquina vagon) ?u - ubicacion ?n nivel)
    :precondition (and
      (vagon-suelto ?v)
      (nivel-cero ?n)
      (esta-en ?v ?u)
      (esta-en ?m ?u)
      (libre ?m)
    )
    :effect (and
      (enganchado ?v ?m)
      (not (vagon-suelto ?v))
      (not (esta-en ?v ?u))
      (not (libre ?m))
      (libre ?v)
    )
  )

  (:action desenganchar-vagon
    :parameters (?v - vagon ?m - (either maquina vagon) ?u - ubicacion ?n nivel)
    :precondition (and
      (enganchado ?v ?m)
      (en-nivel ?v ?n)
      (nivel-cero ?n)
      (esta-en ?m ?u)
    )
    :effect (and
      (vagon-suelto ?v)
      (not (libre ?v))
      (esta-en ?v ?u)
      (not (enganchado ?v ?m))
      (libre ?m)
    )
  )

  ;   Cargar equipajes en vagones
  ; El vagón debe estar enganchado a la máquina en la misma ubicación.

  (:action cargar-equipaje
    :parameters (?e - equipaje ?v - vagon ?m - maquina ?u - ubicacion  ?n1 ?n2 -nivel)
    :precondition (and
      (esta-en ?m ?u)
      (enganchado ?v ?m)
      (esta-en ?e ?u)
      (en-nivel ?v ?n1)
      (siguiente-nivel ?n1 ?n2)
    )
    :effect (and
      (equipaje-en-vagon ?e ?v)
      (not (esta-en ?e ?u))
      (en-nivel ?v ?n2)
      (not (en´-nivel ?v ?n1)
    )
  )


  ;   Descargar equipajes normales

  ; No hace falta desenganchar el vagón.
  ; Se descarga donde esté la máquina.

  (:action descargar-normal
    :parameters (?e - equipaje ?v - vagon ?m - maquina ?u - ubicacion ?n1 ?n2 - nivel)
    :precondition (and
      (normal ?e)
      (equipaje-en-vagon ?e ?v)
      (enganchado ?v ?m)
      (esta-en ?m ?u)
      (en-nivel ?v ?n1)
      (siguiente-nivel ?n2 ?n1)
    )
    :effect (and
      (esta-en ?e ?u)
      (not (equipaje-en-vagon ?e ?v))
      (en-nivel ?v ?n2)
      (not (en-nivel ?v ?n1))
    )
  )

  ;   Inspeccionar Equipajes
  
  ; Una vez en la oficina de inspección, el equipaje deja de ser sospechoso

  (:action inspeccionar-equipaje
    :parameters (?e - equipaje ?u - ubicacion ?v - vagon ?m - maquina)
    :precondition (and
      (sospechoso ?e)
      (equipaje-en-vagon ?e ?v)
      (enganchado ?v ?m)
      (esta-en ?m ?u)
      (es-oficina-inspeccion ?u)
    )
    :effect (and
      (normal ?e)
      (not (sospechoso ?e))
    )
  )

)



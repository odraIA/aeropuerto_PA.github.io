; teresa puta
; ricardo cabron
; LO QUE DIJERON EN CLASE
; para contar lo que debemos hacer es crear predicados que sean
;      n0, n1, n2, ..., nk y poner a true sólo el numero que llevamos
; cuidado al enganchar, no se pueden desenganchar vagones con paquetes
; no se puede enganchar un vagón al medio
; No hace falta desenganchar un vagón para dejar un paquete
; No se puede dejar un paquete sospechoso
; El método para inspeccionar da igual (dejar paquete, vagón o tren entero) pero debemos dejarlo explicado
; ESTÁ PROHIBIDO USAR PRECONDICIONES NEGATIVAS PORQUE EL PLANIFICADOR OPTIC NO LAS SOPORTA

;Header and description

(define (domain aeropuerto)
    (:requirements :strips :typing)
    (:types
      ubicacion
      maquina
      vagon
      equipaje
    )

     (:predicates
    ; Grafo de la terminal
    (siguiente ?desde - ubicacion ?hasta - ubicacion) ; Se puede ir desde, hasta según el mapa

    ; Vehículos
    (en-maquina ?m - maquina ?u - ubicacion)   ; la máquina m está en la ubicación u
    (en-vagon ?v - vagon ?u - ubicacion)      ; el vagón v está suelto en la ubicación u
    (enganchado ?v - vagon ?m - maquina)      ; el vagón v está enganchado a la máquina m
    (vagon-libre ?v - vagon)                  ; v está suelto (no enganchado a ninguna máquina)

    ; Equipajes
    (equipaje-en ?e - equipaje ?u - ubicacion)      ; e está en la ubicacion u
    (equipaje-en-vagon ?e - equipaje ?v - vagon)    ; e está dentro del vagón v

    ; Contador de capacidad del vagón (capacidad = 2)
    (n0 ?v - vagon)   ; 0 equipajes
    (n1 ?v - vagon)   ; 1 equipaje
    (n2 ?v - vagon)   ; 2 equipajes (vagón lleno)

    ; Tipo de equipaje
    (normal ?e - equipaje)       ; equipaje no sospechoso
    (sospechoso ?e - equipaje)   ; equipaje sospechoso

    ; Marca qué ubicación es la oficina de inspección
    (es-oficina-inspeccion ?u - ubicacion)
  )

  ;   Mover la máquina por el grafo

  (:action mover-maquina
    :parameters (?m - maquina ?desde ?hasta - ubicacion)
    :precondition (and
      (en-maquina ?m ?desde)
      (siguiente ?desde ?hasta)
    )
    :effect (and
      (en-maquina ?m ?hasta)
      (not (en-maquina ?m ?desde))
    )
  )

  ;   Enganchar / desenganchar vagones

  ; Solo se puede enganchar/desenganchar si el vagón está vacío (n0).

  (:action enganchar-vagon
    :parameters (?v - vagon ?m - maquina ?u - ubicacion)
    :precondition (and
      (vagon-libre ?v)
      (n0 ?v)
      (en-vagon ?v ?u)
      (en-maquina ?m ?u)
    )
    :effect (and
      (enganchado ?v ?m)
      (not (vagon-libre ?v))
      (not (en-vagon ?v ?u))
    )
  )

  (:action desenganchar-vagon
    :parameters (?v - vagon ?m - maquina ?u - ubicacion)
    :precondition (and
      (enganchado ?v ?m)
      (n0 ?v)
      (en-maquina ?m ?u)
    )
    :effect (and
      (vagon-libre ?v)
      (en-vagon ?v ?u)
      (not (enganchado ?v ?m))
    )
  )

  ;   Cargar equipajes en vagones

  ; Dos acciones: 0→1 y 1→2 (contador n0/n1/n2).
  ; El vagón debe estar enganchado a la máquina en la misma ubicación.

  (:action cargar-equipaje-0-1
    :parameters (?e - equipaje ?v - vagon ?m - maquina ?u - ubicacion)
    :precondition (and
      (en-maquina ?m ?u)
      (enganchado ?v ?m)
      (equipaje-en ?e ?u)
      (n0 ?v)
    )
    :effect (and
      (equipaje-en-vagon ?e ?v)
      (not (equipaje-en ?e ?u))
      (n1 ?v)
      (not (n0 ?v))
    )
  )

  (:action cargar-equipaje-1-2
    :parameters (?e - equipaje ?v - vagon ?m - maquina ?u - ubicacion)
    :precondition (and
      (en-maquina ?m ?u)
      (enganchado ?v ?m)
      (equipaje-en ?e ?u)
      (n1 ?v)
    )
    :effect (and
      (equipaje-en-vagon ?e ?v)
      (not (equipaje-en ?e ?u))
      (n2 ?v)
      (not (n1 ?v))
    )
  )

  ;   Descargar equipajes normales

  ; No hace falta desenganchar el vagón.
  ; Se descarga donde esté la máquina.

  (:action descargar-normal-1-0
    :parameters (?e - equipaje ?v - vagon ?m - maquina ?u - ubicacion)
    :precondition (and
      (normal ?e)
      (equipaje-en-vagon ?e ?v)
      (enganchado ?v ?m)
      (en-maquina ?m ?u)
      (n1 ?v)
    )
    :effect (and
      (equipaje-en ?e ?u)
      (not (equipaje-en-vagon ?e ?v))
      (n0 ?v)
      (not (n1 ?v))
    )
  )

  (:action descargar-normal-2-1
    :parameters (?e - equipaje ?v - vagon ?m - maquina ?u - ubicacion)
    :precondition (and
      (normal ?e)
      (equipaje-en-vagon ?e ?v)
      (enganchado ?v ?m)
      (en-maquina ?m ?u)
      (n2 ?v)
    )
    :effect (and
      (equipaje-en ?e ?u)
      (not (equipaje-en-vagon ?e ?v))
      (n1 ?v)
      (not (n2 ?v))
    )
  )

  ;   Descargar equipajes sospechosos

  ; SOLO se pueden dejar en la oficina de inspección.
  ; Para eso usamos el predicado es-oficina-inspeccion.

  (:action descargar-sospechoso-inspeccion-1-0
    :parameters (?e - equipaje ?v - vagon ?m - maquina ?u - ubicacion)
    :precondition (and
      (sospechoso ?e)
      (equipaje-en-vagon ?e ?v)
      (enganchado ?v ?m)
      (en-maquina ?m ?u)
      (es-oficina-inspeccion ?u)
      (n1 ?v)
    )
    :effect (and
      (equipaje-en ?e ?u)
      (not (equipaje-en-vagon ?e ?v))
      (n0 ?v)
      (not (n1 ?v))
    )
  )

  (:action descargar-sospechoso-inspeccion-2-1
    :parameters (?e - equipaje ?v - vagon ?m - maquina ?u - ubicacion)
    :precondition (and
      (sospechoso ?e)
      (equipaje-en-vagon ?e ?v)
      (enganchado ?v ?m)
      (en-maquina ?m ?u)
      (es-oficina-inspeccion ?u)
      (n2 ?v)
    )
    :effect (and
      (equipaje-en ?e ?u)
      (not (equipaje-en-vagon ?e ?v))
      (n1 ?v)
      (not (n2 ?v))
    )
  )

  ;   Inspeccionar Equipajes

  ; Una vez en la oficina de inspección, el equipaje deja de ser sospechoso
  ; y pasa a ser normal.

  (:action inspeccionar-equipaje
    :parameters (?e - equipaje ?u - ubicacion)
    :precondition (and
      (sospechoso ?e)
      (equipaje-en ?e ?u)
      (es-oficina-inspeccion ?u)
    )
    :effect (and
      (normal ?e)
      (not (sospechoso ?e))
    )
  )

)



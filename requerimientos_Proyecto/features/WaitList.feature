# language: en
Feature: Lista de Espera Automática para Eventos Agotados (HU-VTA-015)

  Background:
    Given el Usuario Asistente ha iniciado sesión en TicketGate
    And existe un evento llamado "Concierto Central Perk"

  # --- AC-01: Transición de UI ---

  Scenario: The One Where It Sells Out Instantly
    Given el inventario general del evento es 0 en la base de datos
    When el usuario carga la página del evento
    Then el botón principal "Comprar Boletos" no debe renderizarse
    And debe aparecer el componente "WaitlistButton" habilitado

  Scenario: The One With The Available Seats
    Given el inventario general del evento es mayor a 0
    When el usuario carga la página del evento
    Then el botón "Comprar Boletos" debe permanecer visible y funcional
    And el botón de "Unirse a Lista de Espera" debe estar oculto

  Scenario: The One With The Live Update
    Given el usuario está viendo la página y el inventario es 2
    When el WebSocket emite el evento "inventory_update: 0"
    Then el botón cambia automáticamente de "Comprar" a "Unirse a Lista de Espera" sin recargar la página

  Scenario: The One With The Glitch
    Given el sistema de inventario devuelve un valor negativo por error
    When el usuario carga la página del evento
    Then la interfaz interpreta el estado como agotado
    And muestra el botón de "Unirse a Lista de Espera" por seguridad

  # --- AC-02 & AC-03: Inscripción y Duplicados ---

  Scenario: The One Where Joey Joins The Line
    Given el usuario no se encuentra registrado en la tabla "waitlist" para este evento
    When hace clic en el botón "Unirse a Lista de Espera"
    Then el sistema guarda un nuevo registro con estatus "WAITING" y la fecha actual
    And la UI muestra un mensaje de éxito: "Estás en la fila"
    And el botón cambia de estado a "En Espera"

  Scenario: The One With The Timestamp
    Given varios usuarios se inscriben simultáneamente
    When el sistema procesa las solicitudes
    Then debe registrar los milisegundos exactos de cada uno para garantizar el orden FIFO

  Scenario: The One Where Monica Panics
    Given el usuario ya tiene un registro activo con estatus "WAITING"
    When intenta hacer clic en "Unirse" nuevamente desde el mismo navegador
    Then el Backend retorna un conflicto
    And la UI muestra la alerta: "Ya estás registrado en la lista"
    But NO se crea un nuevo registro en la base de datos

  Scenario: The One With The Double Device
    Given el usuario se inscribió previamente desde su celular
    When inicia sesión en su computadora e intenta unirse al mismo evento
    Then el sistema detecta el registro previo por "user_id"
    And bloquea la nueva inscripción mostrando "Ya registrado"

  Scenario: The One Where The User Forgot
    Given el usuario ya recibió notificación y tiene estatus "NOTIFIED"
    When intenta unirse de nuevo a la lista antes de comprar
    Then el sistema le recuerda que revise su correo
    And no altera su turno ni crea un registro nuevo

  # --- AC-04: Asignación FIFO ---

  Scenario: The One Where Ross Was First
    Given la lista de espera tiene el orden: Ross primero, Rachel después
    And se libera 1 boleto por cancelación
    When el Worker de asignación se ejecuta
    Then selecciona estrictamente a "Ross" por ser el registro más antiguo
    And cambia su estatus a "NOTIFIED"

  Scenario: The One With The Hidden Ticket
    Given el sistema ha asignado un boleto liberado al usuario "Ross"
    When cualquier otro usuario consulta el inventario público del evento
    Then el inventario sigue marcando 0 boletos disponibles
    And el boleto permanece bloqueado exclusivamente para "Ross"

  Scenario: The One Where Rachel Waits
    Given la lista tiene 100 personas y se libera 1 boleto
    When el Worker asigna el boleto al usuario #1
    Then los usuarios del #2 al #100 permanecen en estatus "WAITING" sin cambios

  Scenario: The One With The Empty Queue
    Given se libera 1 boleto pero la lista de espera está vacía
    When el Worker de asignación verifica la tabla "waitlist"
    Then el sistema cambia el estatus del evento a "Disponible"
    And permite la venta general al público inmediatamente

  Scenario: The One Where The User Is Banned
    Given el usuario #1 en la lista tiene su cuenta suspendida o inactiva
    When el Worker intenta asignar el boleto
    Then el sistema salta automáticamente al usuario #1
    And asigna el boleto al usuario #2 en la fila

  # --- AC-05: Token Seguro ---

  Scenario: The One With The Golden Link
    Given el usuario ha sido seleccionado por el Worker
    When el sistema genera la notificación
    Then crea una URL única que incluye un token firmado
    And el token tiene una configuración de expiración de 15 minutos
    And envía el correo electrónico al usuario

  Scenario: The One With The Stolen Identity
    Given el usuario "Ross" recibió el enlace pero se lo envió a "Gunther"
    When "Gunther" intenta abrir el enlace con su propia sesión iniciada
    Then el sistema rechaza el acceso al checkout
    And muestra un error de "Token inválido para este usuario"

  # --- AC-06: Expiración ---

  Scenario: The One Where Chandler Oversleeps
    Given el usuario "Chandler" tiene estatus "NOTIFIED"
    But han pasado 16 minutos desde que se le envió el correo
    When el Cron Job de limpieza se ejecuta
    Then cambia el estatus de "Chandler" a "EXPIRED"
    And retira el bloqueo del boleto reservado

  Scenario: The One With The Second Chance
    Given el sistema acaba de marcar a un usuario como "EXPIRED"
    When el proceso de limpieza finaliza
    Then dispara inmediatamente el proceso de asignación
    And el boleto se ofrece al siguiente usuario en la fila ("Joey")

  Scenario: The One Where It Is Too Late
    Given el usuario intenta acceder al enlace de compra en el minuto 16
    When carga la página
    Then el sistema valida la fecha del token
    And muestra una página de error indicando que el turno ha caducado

  Scenario: The One Where He Tries Again
    Given el usuario tiene estatus "EXPIRED" en este evento
    When hace clic nuevamente en "Unirse a Lista de Espera"
    Then el sistema permite crear un NUEVO registro
    And el usuario se forma al final de la cola con una nueva fecha
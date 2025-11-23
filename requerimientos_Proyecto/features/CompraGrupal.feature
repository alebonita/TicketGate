Feature: Compra Grupal con Validación de Límites y Asignación (HU-COM-005)

  Background:
    Given el Usuario Comprador ha iniciado sesión en TicketGate
    And se encuentra en la página de detalle del evento "Concierto Central Perk"
    And el límite de compra configurado por el organizador es de 8 boletos

  Scenario: Compra limpia dentro del límite
    Given el usuario tiene 0 boletos comprados previamente en su historial
    When selecciona 8 boletos en el selector de cantidad
    Then el sistema permite la selección
    And habilita el botón para continuar a la asignación de datos

  Scenario:Intento de exceder límite con historial
    Given el usuario ya tiene 6 boletos comprados previamente en su historial
    When intenta seleccionar 3 boletos nuevos (Total 9)
    Then el sistema impide el incremento en el selector
    And muestra el mensaje de error: "Solo puedes comprar 2 boletos más"

  Scenario: Límite ya alcanzado previamente
    Given el usuario ya tiene 8 boletos comprados previamente en su historial
    When intenta interactuar con el selector de cantidad
    Then el selector debe aparecer deshabilitado o bloqueado en 0
    And debe mostrar un mensaje informativo: "Has alcanzado el límite de compra para este evento"

  Scenario: Renderizado de múltiples formularios
    Given el usuario ha seleccionado 3 boletos y avanzado a la siguiente pantalla
    When carga el formulario de "Datos de Asistentes"
    Then el sistema muestra 3 tarjetas de formulario
    And la tarjeta #1 contiene los datos del comprador y es de solo lectura
    And la tarjeta #2 está vacía y es editable
    And la tarjeta #3 está vacía y es editable

  Scenario: Teléfono inválido
    Given el usuario está llenando los datos del Beneficiario #2
    When ingresa el teléfono "12345" (5 dígitos)
    And intenta cambiar el foco a otro campo
    Then el sistema resalta el campo en rojo
    And muestra el mensaje de error: "Mínimo 10 dígitos numéricos"
    And deshabilita el botón de "Finalizar Compra"

  Scenario: Email sin formato
    Given el usuario está llenando los datos del Beneficiario #2
    When ingresa el correo "joey@tribbiani" sin el carácter "@"
    Then el sistema marca el campo como inválido
    And muestra el mensaje de error: "Formato de correo inválido"

  Scenario: Intento de pagar con campos vacíos
    Given el usuario ha dejado el campo "Nombre" del Beneficiario #2 vacío
    When hace clic en el botón "Finalizar Compra"
    Then el sistema impide el envío del formulario
    And realiza un scroll automático hasta el campo vacío
    And muestra el mensaje de error: "Campo Requerido"

  Scenario: Flujo Exitoso
    Given el usuario seleccionó 4 boletos de $100 cada uno
    And todos los datos de los beneficiarios son válidos
    When ingresa una tarjeta Visa válida y confirma el pago
    Then el sistema genera un único cargo de $400
    And envía 1 correo de resumen al Comprador
    And envía 3 correos individuales a los emails de los beneficiarios registrados

  Scenario: Fallo en Pasarela
    Given el usuario intenta pagar el total de la orden
    But la pasarela de pagos rechaza la tarjeta por "Fondos Insuficientes"
    And el temporizador de reserva aún tiene "05:00" minutos restantes
    When el sistema recibe el error de la pasarela
    Then muestra el mensaje "Transacción rechazada por el banco"
    But NO borra los datos ingresados en los formularios
    And permite al usuario intentar pagar nuevamente con otra tarjeta

  Scenario: Expiración del tiempo
    Given el usuario se encuentra llenando los formularios
    When el temporizador de 10 minutos llega a "00:00"
    Then el sistema muestra un modal con el mensaje "Tiempo Agotado"
    And vacía el carrito de compras
    And redirige al usuario a la página de inicio del evento

  Scenario: Edición de datos en tiempo real
    Given el usuario escribió "Jorje" en el nombre del Beneficiario #2
    When borra el texto y escribe "Jorge"
    Then el sistema actualiza el estado del formulario
    And valida nuevamente que el campo no esté vacío
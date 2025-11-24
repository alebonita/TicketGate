Feature: Notiificación de proximidad de evento

    Como un usuario asistente, quiero recibir notificaciones autómaticas que me recuerden
    la cercanía de la fecha de mi evento y los días que faltan, para no  
    olvidar los detalles importantes y prepararme a tiempo
    
    Scenario: El sistema envía una notificación cuando el evento está a 7 días
        Given que la fecha actual es {string}
        And que el Evento X está programado para ocurrir en 7 días
        And que el Asistente tiene un boleto activo para el Evento X
        When el cron job de notificaciones se ejecuta
        Then el Asistente debe recibir una Push Notification
        And la notificación debe indicar que el Evento X es en 7 días
    Scenario: La notificación muestra el nombre del evento y la cuenta regresiva precisa
        Given que la fecha actual es {string}
        And que el Evento B está programado para ocurrir en menos de 24 horas \\(ej. {int} horas\\)
        And que el Asistente tiene un boleto activo para el Evento B
        When el cron job de notificaciones se ejecuta
        Then la Push Notification recibida debe contener el nombre del Evento B
        And la notificación debe mostrar la cuenta regresiva precisa \\(ej. "{string}" o "{string}"\\)
    Scenario: El sistema evita el envío duplicado de la misma notificación por evento y usuario
        Given que el Asistente ya recibió la notificación de T-7 días para el Evento X
        And que la fecha actual es el día siguiente a la notificación inicial \\(Evento X a {int} días\\)
        And que el Asistente tiene un boleto activo para el Evento X
        When el cron job de notificaciones se ejecuta
        Then la notificación de T-7 días para el Evento X no se vuelve a enviar al Asistente
    Scenario Outline: El sistema no envía notificaciones si el boleto está <EstadoBoleto>
        Given que el Asistente tiene un boleto para el Evento Y que está <EstadoBoleto>
        And que el Evento Y cumple la regla de proximidad de fecha \\(ej. {int} días\\)
        When el cron job de notificaciones se ejecuta
        Then el Asistente no debe recibir ninguna Push Notification para el Evento Y

        Examples:
            | EstadoBoleto |
            | "CANCELADO"  |
            | "UTILIZADO"  |
    Scenario Outline: Al hacer clic en la notificación, el usuario es redirigido a la página del evento
        Given que el Asistente recibe una Push Notification de proximidad para el <NombreEvento>
        And que la sesión del Asistente en la App está <EstadoSesion>
        When el Asistente hace clic en la notificación
        Then la App TickerGate debe abrirse
        And el Asistente debe ser redirigido <DestinoRedireccion>
  
        Examples:
            | NombreEvento   | EstadoSesion | DestinoRedireccion             |
            | "Concierto Pop" | "activa"     | "directamente a la página del boleto o detalle del evento" |
            | "Obra de Teatro" | "expirada"   | "primero a la pantalla de Login, y luego a la página del boleto" |
    Scenario: La notificación incluye el nombre correcto y actual del evento
        Given que el Evento A tiene el nombre "Gran Festival de Jazz"
        And que el Asistente tiene un boleto activo para el Evento A
        And que el Evento A cumple una regla de proximidad de notificación
        When el cron job de notificaciones se ejecuta
        Then la Push Notification debe contener el título "Gran Festival de Jazz"
        And la notificación debe mostrar la cuenta regresiva correcta
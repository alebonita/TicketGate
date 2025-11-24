Feature: Como un usuario organizador de eventos, quiero poder enviar notificaciones de cambios críticos de forma inmediata que garantice que los asistentes sean informados de alguna emergencia.
    Permite al Organizador enviar un mensaje urgente e ineludible (ej. cambio de sede, emergencia, cancelación) a los Asistentes con boletos activos y válidos para un evento, garantizando la entrega por canales paralelos y registrando la acción para auditoría.

# Mandar a usuarios correctos la notificación
    # Esenario 1:
    Example: En el que el evento sea cancelado y se envíe una notificación a todos los usuarios asistentes.
        Given el Organizador "O-101" ha iniciado sesión con doble confirmación
        And el Evento "Festival Tech 2026" está activo
        And existen 500 Asistentes con boletos activos para el evento
        And el Organizador redacta una notificación de "Cambio de Ubicación"
        When el Organizador selecciona enviar la notificación a "Todos los Asistentes Activos"
        Then el Sistema debe registrar la notificación con doble confirmación
        And la Notificación debe ser entregada por "Notificación Push" y "Correo Electrónico" a los 500 Asistentes
        And el contenido debe publicarse en el "Portal de Estado del Evento"
    
    # Escenario 2:
    Example: En el que el organizador envíe un recordatorio del evento a los usuarios
        Given el Evento "Seminario de Marketing" está programado para mañana
        And el Organizador redacta un mensaje de "Recordatorio" con indicaciones de acceso y hora
        And el Organizador selecciona enviar la notificación a "Todos los Usuarios Asistentes"
        When el Organizador confirma el envío del recordatorio
        Then el Sistema debe enviar el recordatorio a todos los asistentes
        And el Sistema debe registrar la acción como "Comunicación Logística" en el log de auditoría

    #Escenario 3:
    Example: En el que se envíe una notificación de cambio de ubicación
        Given el Evento "Maratón Anual" tiene un cambio confirmado de punto de partida
        And el Organizador redacta un mensaje urgente detallando la nueva ubicación
        When el Organizador selecciona el evento y envía la "Notificación de Cambio Crítico"
        Then el Sistema debe notificar a todos los asistentes por ambos canales (Push y Correo)
        And la información del evento en la App/Web debe reflejar la nueva ubicación tras el envío.

# Segmentación de usuarios
    # Esenario 4:
    Example: En el que se envíe una notificación solo a los usuarios de un evento en especifico
        Given el Organizador gestiona el Evento "Gala Benéfica" con 100 Asistentes
        And existe un Evento "Torneo Deportivo" con 200 Asistentes gestionado por el mismo Organizador
        When el Organizador envía una notificación de "Cambio de Hora" seleccionando solo el Evento "Gala Benéfica"
        Then los 100 Asistentes de la "Gala Benéfica" deben recibir la notificación
        And los 200 Asistentes del "Torneo Deportivo" deben ser excluidos del envío y no deben recibir la notificación
    
    # Escenario 5:
    Example: En el que no se logra enviar la notificación a ciertos usuarios y nadie los recibe
        Given existen 50 Asistentes activos en el evento "Conferencia Anual"
        And la infraestructura de correo electrónico no logra enviar la notificación al Asistente "A-005" (ej. buzón lleno)
        When el Organizador envía una notificación de "Alerta de Ingreso" a todos los asistentes
        Then la notificación debe ser enviada y entregada exitosamente a 49 Asistentes (los usuarios que sí reciben)
        And el Asistente "A-005" no debe recibir el mensaje por el canal fallido
        And el Sistema debe registrar el estado "Fallo de Envío" para el Asistente "A-005" en el log de auditoría
        And el Organizador debe recibir un reporte indicando el porcentaje de fallos en la entrega

    # Escenario 6:
    Example: En el que se manda la notificación a usuarios incorrectos
        Given el Evento "Demo Producto" tiene 50 boletos vendidos
        And existen 10 usuarios registrados en TicketGate que NUNCA compraron un boleto para ese evento
        When el Organizador envía la notificación de "Instrucciones de Acceso" a los Asistentes del evento
        Then la notificación debe ser recibida solo por los 50 usuarios con "Boletos Activos"
        And los 10 usuarios registrados sin boleto activo **NO** deben recibir el mensaje

# Diseñar la notificación
    # Escenario 7:
    Example: En el que la notificación llegue como una pantalla emergente al usuario
        Given el Asistente "A-007" tiene la App Móvil de TicketGate instalada y las notificaciones activas
        And el Organizador envía una notificación de "Emergencia de Seguridad" al Asistente "A-007"
        When el Asistente está usando activamente su dispositivo móvil
        Then la notificación debe aparecer como una **pantalla emergente (Push Notification)** en el sistema operativo del móvil del Asistente
        And el título de la alerta debe incluir la etiqueta de "CRÍTICO" o "URGENTE"
    
    # Escenario 8:
    Example: En el que la notificación llegue por correo.
        Given el Organizador envía una notificación de "Cancelación por Lluvia"
        And el Asistente "A-008" ha verificado su dirección de correo electrónico
        When el Sistema completa el envío multicanal
        Then el Asistente "A-008" debe recibir un correo electrónico en su bandeja de entrada
        And el cuerpo del correo debe incluir el **enlace de verificación al Portal de Estado** de TicketGate
        And el correo debe provenir de una dirección de remitente oficial de TicketGate
    
    # Escenario 9:
    Example: En el que la notificación llegue como nota al la aplicación del evento
        Given el Asistente "A-009" abre la App Móvil de TicketGate y navega a la sección de su boleto activo
        And el Organizador ha enviado previamente una notificación de "Cambio de Horario"
        When el Asistente accede a la página de detalles del evento o al boleto
        Then el mensaje debe mostrarse como una **nota destacada, banner o alerta persistente** dentro de la interfaz de la aplicación de TicketGate
        And el Asistente debe poder acceder al historial completo de las notificaciones críticas recientes del evento.

# Guardar correctamente la información que el organizador necesita mandar
    # Escenario 10:
    Example: En el que la información no se mande correctamente a los usuarios y no se entienda
        Given el Organizador ha redactado un mensaje de "Recordatorio de Acceso"
        And el Organizador selecciona la opción "Programar Envío"
        When el Organizador establece la fecha y hora de envío para "Mañana a las 09:00 AM" y confirma la acción
        Then el Sistema debe guardar la notificación en estado **"Pendiente Crítico"**
        And la notificación **no debe ser enviada** inmediatamente
        And a las 09:00 AM del día siguiente, el Sistema debe ejecutar el envío automático.
    
    # Escenario 11:
    Example: En el que el organizador programe el recordatorio
        Given el Organizador ha completado la doble confirmación para el envío
        And el campo de "Asunto" contiene texto, pero el campo "Mensaje" está **completamente vacío**
        When el Organizador hace clic en el botón "Enviar Notificación Crítica"
        Then el Sistema debe **bloquear el envío**
        And el Sistema debe mostrar un mensaje de error de validación: "El campo de mensaje no puede estar vacío."
    
    # Escenario 12:
    Example: En el que la notificación se envíe vacía
        Given el Organizador intenta enviar un mensaje que contiene una **secuencia excesiva de caracteres no ASCII** o símbolos no estándar
        When el Organizador intenta confirmar el envío
        Then el Sistema debe **advertir** al Organizador sobre caracteres ilegibles o excesivos que puedan causar ininteligibilidad
        And el Sistema debe garantizar que los caracteres enviados (si son aceptados) se rendericen correctamente en el **correo electrónico** y en la **notificación Push** del Asistente.

# Crear los campos que el organizador complete para mandar la notificación 
    # Escenario 13:
    Example: En el que el organizador no complete los campos para crear la notificación
        Given el Organizador ha completado todos los campos obligatorios para la notificación ("Asunto" y "Mensaje")
        And la audiencia de destino está correctamente segmentada
        When el Organizador confirma el envío con la doble confirmación
        Then el Sistema debe iniciar el proceso de envío multicanal sin errores
        And el Organizador debe recibir un mensaje de **"Envío Masivo Exitoso"**
        And el registro de auditoría debe contener el mensaje completo y la hora exacta de la acción.
    
    # Escenario 14:
    Example: En el que el organizador complete la información y sea enviada correctamente
        Given el campo "Mensaje" contiene el texto completo de la alerta
        And el Organizador ha dejado el campo **"Asunto"** sin completar
        When el Organizador intenta confirmar el envío
        Then el Sistema debe **bloquear la acción**
        And el Sistema debe mostrar un mensaje de error que indique: "Falta completar el campo: Asunto"
    
    #Escenario 15:
    Example: En el que el organizador mande una notificación con información errónea
        Given el Organizador redacta un mensaje de "Cambio de Precio de Boletos" (información errónea o engañosa)
        And el sistema no tiene un filtro de contenido semántico para bloquear este tipo de mensaje
        When el Organizador confirma el envío con la doble confirmación
        Then el Sistema debe **permitir el envío**, ya que los campos obligatorios están llenos
        And el registro de auditoría debe registrar el **contenido exacto** de la información engañosa enviada
        And la responsabilidad del contenido debe recaer en el Organizador (Validación de Contenido, fuera del alcance del sistema, pero registrada).
   
# Limitar la frecuencia de envíos críticos por organizador para evitar spam
    # Escenario 16 :
    Example:  el que el organizador necesite mandar más de 3 notificaciones en un lapso corto de tiempo
        Given el límite de notificaciones por hora está configurado en 3
        And el Organizador "O-VIP" ha enviado 3 Notificaciones Críticas en los últimos 55 minutos
        When el Organizador "O-VIP" intenta enviar la cuarta Notificación Crítica
        Then el Sistema debe **bloquear la acción**
        And el Sistema debe mostrar un mensaje de error claro: "Ha excedido el límite de envíos críticos. Intente nuevamente en [X] minutos."
        And el registro de auditoría debe incluir el intento de envío fallido y la razón del bloqueo (Rate Limit).

    # Escenario 17:
    Example: En el que el organizador no mande ninguna notificación
        Given el Evento tiene un límite de 2 notificaciones de tipo "Urgencia (Crítica)" y un límite total de 5
        And el Organizador ha enviado 2 notificaciones de tipo "Urgencia (Crítica)"
        When el Organizador intenta enviar una tercera notificación de tipo "Urgencia (Crítica)"
        Then el Sistema debe **denegar la acción** por haber alcanzado el límite de categoría
        And el Organizador aún debe poder enviar un mensaje de tipo "Recordatorio" hasta alcanzar el límite total.
    
    # Escenario 18:
    Example: 
        Given la función de "Notificación de Cambio Crítico" está activa para el evento
        And el Organizador decide no enviar ninguna notificación
        When el Organizador no realiza ninguna acción en el módulo de comunicación
        Then el estado del sistema y la base de datos de notificaciones deben permanecer inalterados
        And la funcionalidad debe seguir disponible para un futuro uso.

# Soporte de Multilingüe dependiendo del idioma preferido
    #Escenario 19: 
    Example: En el que el sistema traduce correctamente la información que el organizador envió en el idioma del usuario
        Given el Organizador redacta la notificación en "Español"
        And el Asistente "A-401" tiene su preferencia de idioma configurada como "Portugués"
        When el Organizador envía la notificación crítica
        Then el Sistema debe usar el módulo de traducción
        And el Asistente "A-401" debe recibir el mensaje con el texto traducido con precisión al "Portugués"
        And la etiqueta de la notificación (ej. "URGENTE") debe también ser traducida al "Portugués".
    
    # Escerio 20:
    Example: En el que no se traduzca correctamente la información
        Given el Organizador redacta la notificación en "Inglés"
        And el Asistente "A-402" tiene su preferencia de idioma configurada como "Islandés"
        And el servicio de traducción reporta un **fallo o un idioma no soportado** para el Islandés
        When el Organizador envía la notificación crítica
        Then el Sistema debe detectar el fallo de traducción
        And el Asistente "A-402" debe recibir el mensaje en el **idioma original del Organizador (Inglés)**
        And el log de auditoría debe registrar el evento como "Fallo de Traducción, enviado en Idioma Original".
    
    # Esceario 21:
    Example: En el que algunas notificaciones se traduzcan y otras no
        Given el Organizador redacta la notificación en "Francés"
        And el Asistente "A-403" tiene su preferencia de idioma configurada como "Alemán"
        And el Asistente "A-404" tiene su preferencia de idioma configurada como "Francés"
        When el Organizador envía la notificación crítica a ambos asistentes
        Then el Asistente "A-403" (Alemán) debe recibir la notificación con el texto **traducido**
        And el Asistente "A-404" (Francés) debe recibir la notificación **sin traducción** (en el idioma original)

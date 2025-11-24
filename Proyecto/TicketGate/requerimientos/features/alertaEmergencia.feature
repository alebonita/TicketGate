Feature: Función de alerta de emergencia
  Como Organizador de Eventos, Quiero enviar una alerta de emergencia de alta prioridad que ignore el modo No molestar de los asistentes,
  Para garantizar la comunicación vital en situaciones de riesgo o evacuación.

  Scenario: El Organizador se re-autentica y envía una alerta con éxito
    Given el Organizador ha iniciado sesión y ha redactado una Alerta de Emergencia para el Evento X
    And el pop-up de re-autenticación solicita la contraseña
    When el Organizador ingresa su contraseña correctamente
    And el Organizador confirma el envío de la alerta
    Then el envío de la alerta inicia inmediatamente
    And el pop-up de re-autenticación se cierra
    And el Organizador recibe una confirmación de envío con el recuento total de asistentes notificados
    And el sistema registra la acción de envío en el log de auditoría como un Evento Crítico
  Scenario: El envío de alerta es bloqueado por fallo en la re-autenticación
    Given el Organizador ha iniciado sesión y ha redactado una Alerta de Emergencia para el Evento X
    And el pop-up de re-autenticación solicita la contraseña
    When el Organizador ingresa una contraseña incorrecta varias veces (ej. 2 veces)
    And el Organizador intenta confirmar el envío de la alerta
    Then el envío de la alerta es bloqueado
    And el sistema muestra un mensaje de "Error de Autenticación"
    And la alerta no se dispara a ningún asistente
  Scenario: La alerta de emergencia anula el modo 'No Molestar' y emite sonido
    Given el Asistente B tiene la App instalada y su teléfono está en modo 'No Molestar' activo
    And la alerta de emergencia ha sido enviada exitosamente para el evento del Asistente B
    When el dispositivo del Asistente B recibe la Push Notification de emergencia
    Then el sonido de alerta se reproduce forzadamente en el dispositivo
    And el dispositivo emite una vibración
    And la configuración de 'No Molestar' es anulada para esta notificación
  Scenario: La alerta de emergencia anula el modo silencio y emite vibración forzada
    Given el Asistente C tiene la App instalada y su teléfono está en modo 'Silencio/Vibración' activo
    And la alerta de emergencia ha sido enviada exitosamente para el evento del Asistente C
    When el dispositivo del Asistente C recibe la Push Notification de emergencia
    Then el dispositivo emite una vibración intensa con un patrón de emergencia
    And el sonido de alerta se reproduce (si es posible en modo vibración)
    And la configuración de 'Silencio/Vibración' es anulada para esta notificación
  Scenario: El sistema registra la alerta de emergencia en el log de auditoría
    Given el Organizador ha enviado una Alerta de Emergencia con el contenido "Incendio en la Zona VIP" para el Evento X
    And el envío de la alerta finalizó exitosamente
    When se consulta la base de datos de logs de auditoría
    Then debe existir un registro con el timestamp del envío
    And el registro debe contener el contenido completo de la alerta ("Incendio en la Zona VIP")
    And el registro debe incluir el ID del Organizador responsable
    And el registro debe estar marcado como "Evento Crítico"
  Scenario: El Organizador recibe confirmación con el recuento de asistentes
    Given el sistema ha identificado 5000 asistentes activos para el Evento X
    And el envío de la Alerta de Emergencia para el Evento X ha finalizado exitosamente
    When el Organizador visualiza el panel de gestión del Evento X
    Then el Organizador debe recibir un mensaje de confirmación
    And el mensaje debe indicar "Alerta Enviada Exitosamente a 5,000 Asistentes"
  Scenario: La alerta se segmenta correctamente a los asistentes de un evento específico
    Given una Alerta de Emergencia ha sido enviada y segmentada al Evento X
    And el Asistente A tiene un boleto activo solo para el Evento X
    And el Asistente Y tiene un boleto activo solo para el Evento Z (diferente al Evento X)
    When los dispositivos de los asistentes reciben las Push Notifications
    Then el Asistente A debe recibir la alerta de emergencia
    And el Asistente Y no debe recibir la alerta de emergencia
  Scenario: La alerta no llega a asistentes de eventos no seleccionados
    Given una Alerta de Emergencia ha sido enviada y segmentada específicamente al Evento X
    And el Asistente Y tiene un boleto activo para el Evento Z, pero no para el Evento X
    When se verifica el dispositivo del Asistente Y
    Then el Asistente Y no debe haber recibido la alerta de emergencia para el Evento X
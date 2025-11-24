Feature: Función de Conexión a redes sociales para promoción de eventos

  Como Organizador y Asistente,
  Quiero poder conectar eventos a mis redes sociales,
  Para facilitar la promoción y el seguimiento de las ventas desde esas plataformas externas.

  Scenario: El Organizador conecta TicketGate a una red social con éxito
    Given que el Organizador ha iniciado sesión en TicketGate
    When el Organizador autoriza los permisos en la "Red Social X"
    And la "Red Social X" devuelve un token de acceso a TicketGate
    Then el token de acceso se almacena cifrado en TicketGate
    And el Dashboard del Organizador muestra el estado "Conectado" con la "Red Social X"
  Scenario: El Organizador deniega la autorización y la conexión no se establece
    Given que el Organizador ha iniciado sesión en TicketGate
    When el Organizador cancela la autorización en la página de la "Red Social X"
    Then TicketGate regresa al Dashboard del Organizador
    And el Dashboard muestra el estado "Conexión Rechazada"
  Scenario: El Organizador ingresa y activa correctamente un código de seguimiento (Pixel ID)
    Given que la conexión con la "Red Social X" está "Activa" en TicketGate
    And que el Organizador ha accedido a la configuración del evento
    When el Organizador ingresa su Pixel ID en la configuración
    And el código del Pixel se carga
    Then el código del Pixel se activa correctamente en el código fuente de la página de venta
  Scenario: El Asistente puede compartir un evento generando un enlace rastreable
    Given que un Asistente está visualizando la página de un evento en la App TicketGate
    When el Asistente hace clic en el botón "Compartir"
    And el Asistente selecciona la "Red Social Y" (ej. WhatsApp)
    Then se genera un enlace único y rastreable para el evento
    And el enlace es pre-cargado en el mensaje de la aplicación externa
  Scenario: El sistema detecta la revocación externa de permisos y actualiza el estado
    Given que la conexión con la "Red Social X" está "Activa"
    When el Organizador revoca manualmente los permisos desde la App de la configuración de la "Red Social X"
    Then TicketGate actualiza el estado a "Expirado/Revocado"
  Scenario: El sistema detecta y notifica la expiración automática del token por inactividad
    Given que el Organizador no usa la función por 60 días (el límite del token)
    When el Organizador intenta publicar un anuncio
    Then el sistema muestra "Token Expirado. Vuelva a conectar"
  Scenario: Un nuevo organizador puede conectar la misma red social sin afectar la conexión original
    Given que el "Organizador A" está conectado
    When el "Organizador B" intenta conectar a la misma cuenta de la "Red Social Z"
    And el "Organizador B" completa exitosamente el flujo OAuth
    Then el sistema permite la conexión (si la Red Social lo permite)
    And el sistema almacena un nuevo token para B sin afectar la conexión de A
  Scenario: El sistema rechaza un ID de seguimiento con formato inválido
    Given que el Organizador ingresa un ID de Pixel que no cumple con el formato requerido (ej. letras)
    When intenta guardar el ID de seguimiento
    Then el sistema muestra un mensaje de error de "Formato de ID Inválido"
    And el ID no es guardado ni guarda el código
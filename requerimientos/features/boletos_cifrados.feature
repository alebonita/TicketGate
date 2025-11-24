Feature: Boletos cifrados y tokenizados
  Como un usuario de la app
  quiero que mis boletos estén cifrados y tokenizados
  para evitar fraudes y garantizar su validez.

  # AC1. Cada boleto debe generar un token único no predecible.

  Scenario: The One Where The TicketsGetUniqueTokens
    Given que existe una compra con 3 boletos
    When el sistema genera los tokens para los boletos
    Then cada boleto tiene un token único

  Scenario: The One Where TheTicketIsReissuedWithNewToken
    Given que existe un boleto previamente emitido con un token antiguo
    When el sistema reemite el boleto
    Then el boleto obtiene un nuevo token
    And el token antiguo queda invalidado

  # AC2. El QR no debe incluir datos sensibles en texto plano.

  Scenario: The One Where TheQRContainsOnlyTheToken
    Given que se genera un código QR para un boleto
    When se revisa el contenido del QR
    Then el QR solo contiene el token cifrado y no datos sensibles

  Scenario: The One Where TheAuditorChecksTheQR
    Given que un auditor escanea el QR de un boleto
    When el auditor inspecciona la información contenida
    Then el auditor no encuentra datos personales en texto plano

  # AC3. La validación debe verificar token, estado del boleto y uso previo.

  Scenario: The One Where TheFirstScanGrantsAccess
    Given que existe un boleto con token válido en estado "VENDIDO" y sin uso previo
    When el lector valida el código QR del boleto
    Then el sistema permite el acceso
    And el boleto queda marcado como "UTILIZADO"

  Scenario: The One Where TheSecondScanIsRejected
    Given que existe un boleto con token válido en estado "UTILIZADO"
    When el lector valida nuevamente el código QR del boleto
    Then el sistema rechaza el acceso por boleto ya utilizado

  # AC4. Tokens inválidos, alterados o repetidos deben ser rechazados.

  Scenario: The One Where TheTamperedTokenIsInvalid
    Given que el lector recibe un token alterado manualmente
    When el sistema intenta buscar un boleto con ese token
    Then el sistema rechaza el acceso por boleto inválido

  Scenario: The One Where TheScreenshotTokenHasExpired
    Given que un asistente presenta una captura de pantalla de un QR antiguo
    When el lector valida el QR
    Then el sistema rechaza el acceso por token caducado

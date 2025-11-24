Feature: Bloqueo temporal de cuentas
  Como un usuario de la app
  quiero que mi cuenta se bloquee temporalmente si se detecta actividad sospechosa
  para proteger mi seguridad.

  # AC1. La cuenta debe bloquearse temporalmente al detectar actividad sospechosa.

  Scenario: The One Where TooManyFailedLoginsBlockTheAccount
    Given que existe un usuario con estado de cuenta "ACTIVA"
    And que el usuario ha realizado 5 intentos fallidos de inicio de sesión
    When el sistema evalúa la actividad de inicio de sesión
    Then la cuenta del usuario queda en estado "BLOQUEADA_TEMPORAL"

  Scenario: The One Where SuspiciousLocationBlocksTheAccount
    Given que existe un usuario con estado de cuenta "ACTIVA"
    And que se detecta un intento de acceso desde una ubicación inusual
    When el sistema evalúa la actividad de inicio de sesión
    Then la cuenta del usuario queda en estado "BLOQUEADA_TEMPORAL"

  # AC2. El sistema debe notificar al usuario sobre el bloqueo y su motivo general.

  Scenario: The One Where TheUserGetsAnEmailAboutTheBlock
    Given que la cuenta del usuario está en estado "BLOQUEADA_TEMPORAL"
    When el sistema genera la notificación de bloqueo
    Then el usuario recibe un correo indicando que su cuenta fue bloqueada temporalmente

  Scenario: The One Where TheUserGetsAPushAboutTheBlock
    Given que la cuenta del usuario está en estado "BLOQUEADA_TEMPORAL"
    And que el usuario tiene notificaciones push activas
    When el sistema genera la notificación de bloqueo
    Then el usuario recibe una notificación push indicando el bloqueo por seguridad

  # AC3. El usuario debe poder desbloquear su cuenta mediante un proceso de verificación.

  Scenario: The One Where TheUserUnlocksWithOTP
    Given que la cuenta del usuario está en estado "BLOQUEADA_TEMPORAL"
    And que el usuario recibe un código OTP válido
    When el usuario ingresa el código OTP correcto
    Then el sistema valida la identidad del usuario
    And la cuenta del usuario puede volver a estado "ACTIVA"

  Scenario: The One Where TheUserRequestsANewUnlockLink
    Given que la cuenta del usuario está en estado "BLOQUEADA_TEMPORAL"
    And que el enlace de desbloqueo anterior ha expirado
    When el usuario solicita un nuevo enlace de desbloqueo
    Then el sistema envía un nuevo enlace válido al usuario

  # AC4. La cuenta solo vuelve a estado ACTIVA tras verificación exitosa o fin del periodo de bloqueo.

  Scenario: The One Where TheUserCompletesVerification
    Given que la cuenta del usuario está en estado "BLOQUEADA_TEMPORAL"
    And que el usuario ha pasado satisfactoriamente el proceso de verificación
    When el sistema actualiza el estado de la cuenta
    Then la cuenta del usuario queda en estado "ACTIVA"

  Scenario: The One Where TheLockExpiresAndUserIsChallenged
    Given que la cuenta del usuario estuvo en estado "BLOQUEADA_TEMPORAL"
    And que ha transcurrido el periodo de bloqueo configurado
    When el usuario intenta iniciar sesión nuevamente
    Then el sistema solicita autenticación reforzada
    And si la autenticación reforzada es correcta la cuenta queda en estado "ACTIVA"

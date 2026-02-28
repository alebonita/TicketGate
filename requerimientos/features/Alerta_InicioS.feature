Feature: Generar Alerta y Bloqueo por Intentos Fallidos de Login
  Como un usuario registrado
  Quiero que mi cuenta se bloquee y recibir una alerta por correo
  Después de 3 intentos fallidos de inicio de sesión dentro de 15 minutos
  Para proteger mi cuenta ante accesos no autorizados.

Background: Configuración de seguridad
  Given existe un usuario "usuario.valido@ticketgate.com" con contraseña "Password123" y su cuenta está "activa"
  And el sistema está configurado con:
    | umbral_intentos_fallidos | 3        |
    | ventana_tiempo_minutos   | 15       |
    | duracion_bloqueo_minutos | 30       |

Scenario: Bloqueo de cuenta exitoso tras 3 intentos fallidos (Happy Path)
  # Este es el "Happy Path" de tu mapa
  Given el usuario "usuario.valido@ticketgate.com" no tiene intentos fallidos recientes
  When el usuario intenta iniciar sesión con email "usuario.valido@ticketgate.com" y contraseña "error1" desde la IP "189.1.1.1"
  And el usuario intenta iniciar sesión con email "usuario.valido@ticketgate.com" y contraseña "error2" desde la IP "189.1.1.1"
  And el usuario intenta iniciar sesión con email "usuario.valido@ticketgate.com" y contraseña "error3" desde la IP "189.1.1.1"
  Then la cuenta de "usuario.valido@ticketgate.com" debe cambiar su estado a "bloqueada"
  And el sistema debe enviar un correo de alerta de bloqueo a "usuario.valido@ticketgate.com"
  And el correo debe contener la ubicación aproximada de la IP "189.1.1.1" y un enlace de desbloqueo
  And el sistema debe registrar un evento de "bloqueo de cuenta" en la auditoría para "usuario.valido@ticketgate.com"

Scenario: El contador de intentos se reinicia al iniciar sesión correctamente (Flujo A1)
  # Este es el Flujo Alternativo A1
  Given el usuario "usuario.valido@ticketgate.com" no tiene intentos fallidos recientes
  When el usuario intenta iniciar sesión con email "usuario.valido@ticketgate.com" y contraseña "error1"
  And el usuario intenta iniciar sesión con email "usuario.valido@ticketgate.com" y contraseña "error2"
  And el usuario intenta iniciar sesión con email "usuario.valido@ticketgate.com" y contraseña "Password123"
  Then el usuario debe iniciar sesión exitosamente
  And la cuenta de "usuario.valido@ticketgate.com" debe permanecer "activa"
  And el contador de intentos fallidos para "usuario.valido@ticketgate.com" debe ser 0

Scenario: Desbloqueo exitoso de cuenta mediante enlace de correo (Flujo A2)
  # Este es el Flujo Alternativo A2
  Given la cuenta de "usuario.valido@ticketgate.com" está "bloqueada"
  And el sistema ha generado un token de desbloqueo válido para "usuario.valido@ticketgate.com"
  When el usuario visita la URL de desbloqueo con el token válido
  # 'confirma' podría ser hacer clic en un botón o pasar un CAPTCHA
  And el usuario confirma el desbloqueo en la página
  Then la cuenta de "usuario.valido@ticketgate.com" debe cambiar su estado a "activa"
  And el token de desbloqueo debe ser invalidado (marcado como usado)
  And el usuario debe ver un mensaje de "Cuenta desbloqueada exitosamente"

Scenario: Los intentos fallidos expiran después de la ventana de tiempo (No se bloquea)
  # Prueba que la "ventana de tiempo" de 15 min funciona
  Given el usuario "usuario.valido@ticketgate.com" no tiene intentos fallidos recientes
  When el usuario intenta iniciar sesión con email "usuario.valido@ticketgate.com" y contraseña "error1"
  And han pasado 16 minutos
  And el usuario intenta iniciar sesión con email "usuario.valido@ticketgate.com" y contraseña "error2"
  And el usuario intenta iniciar sesión con email "usuario.valido@ticketgate.com" y contraseña "error3"
  Then la cuenta de "usuario.valido@ticketgate.com" debe permanecer "activa"
  # El contador se reseteó después del min 16, así que solo cuenta los últimos 2
  And el contador de intentos fallidos para "usuario.valido@ticketgate.com" debe ser 2

Scenario: El bloqueo de cuenta se mantiene aunque falle el servicio de correo (Excepción E1)
  Given el servicio de correo electrónico está "caído"
  And el usuario "usuario.valido@ticketgate.com" no tiene intentos fallidos recientes
  When el usuario intenta iniciar sesión con email "usuario.valido@ticketgate.com" y contraseña "error1"
  And el usuario intenta iniciar sesión con email "usuario.valido@ticketgate.com" y contraseña "error2"
  And el usuario intenta iniciar sesión con email "usuario.valido@ticketgate.com" y contraseña "error3"
  Then la cuenta de "usuario.valido@ticketgate.com" debe cambiar su estado a "bloqueada"
  And el sistema debe registrar un error de "envío de correo fallido" en la auditoría
  And el sistema NO debe enviar un correo a "usuario.valido@ticketgate.com"

Scenario: El correo de alerta se envía con ubicación "Desconocida" (Excepción E2)
  Given el servicio de geolocalización está "caído"
  And el usuario "usuario.valido@ticketgate.com" no tiene intentos fallidos recientes
  When el usuario intenta iniciar sesión con email "usuario.valido@ticketgate.com" y contraseña "error1" desde la IP "10.0.0.1"
  And el usuario intenta iniciar sesión con email "usuario.valido@ticketgate.com" y contraseña "error2" desde la IP "10.0.0.1"
  And el usuario intenta iniciar sesión con email "usuario.valido@ticketgate.com" y contraseña "error3" desde la IP "10.0.0.1"
  Then la cuenta de "usuario.valido@ticketgate.com" debe estar "bloqueada"
  And el sistema debe enviar un correo de alerta a "usuario.valido@ticketgate.com" que incluya una ubicación "Desconocida"

Scenario: El enlace de desbloqueo es de un solo uso
  Given la cuenta de "usuario.valido@ticketgate.com" está "bloqueada"
  And el sistema ha generado un token de desbloqueo válido para "usuario.valido@ticketgate.com"
  When el usuario visita la URL de desbloqueo con el token válido
  And el usuario confirma el desbloqueo en la página
  And la cuenta de "usuario.valido@ticketgate.com" cambia su estado a "activa"
  # Segundo intento
  When el usuario intenta visitar la MISMA URL de desbloqueo con el MISMO token por segunda vez
  Then el usuario debe ver un mensaje de error "Este enlace ya ha sido utilizado"
  And la cuenta de "usuario.valido@ticketgate.com" debe permanecer "activa"
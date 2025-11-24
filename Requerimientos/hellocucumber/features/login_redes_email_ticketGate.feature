Feature: Como usuario asistente u organizador quiero poder iniciar sesión utilizando mi correo electrónico/contraseña tradicional o de redes sociales para acceder a la plataforma o de manera rápida
    Implementar un sistema de autenticación flexible que soporte métodos tradicionales (email/contraseña) e inicio de sesión por terceros (Google, Facebook), mejorando la tasa de conversión y la conveniencia de acceso.

#El usuario debe poder iniciar sesión usando credenciales nativas o de una cuenta de red social.
    #Example 1:
    Example: En el que el usuario ya registrado ingresa su email y contraseña sin problema
        Given existe un Usuario "Asistente_Nat" con email "asistente@mail.com" y contraseña válida
        When el Usuario ingresa su email y contraseña
        And hace clic en "Iniciar Sesión"
        Then el Sistema debe generar una sesión válida
        And el Usuario es redirigido a la "Página Principal (/home)"
    
    #Example 2:
    Example: En el que el usuario da clic en continuar con google y tras autorización es logrado correctamente
        Given el Usuario "Existente_Social" tiene una cuenta TicketGate vinculada a Google
        When el Usuario hace clic en "Continuar con Google" y autoriza el acceso
        Then el Sistema debe validar el token de Google
        And el Usuario es logueado en la cuenta "Existente_Social"
    
    #Example 3:
    Example: En el que el usuario con login nativo intenta iniciar sesión al día siguiente con google y el sistema continua
        Given existe una cuenta nativa con email "nativo@mail.com"
        And el Usuario intenta hacer Login con Google usando el mismo email "nativo@mail.com"
        When el Sistema detecta que el email ya existe en la base de datos nativa
        Then el Sistema debe pausar el Login y mostrar un mensaje: "¿Desea vincular esta cuenta de Google a su perfil nativo?"

#Un usuario nuevo debe poder crear su cuenta con un solo clic usando una red social, sin completar formularios adicionales.
    #Example 1:
    Example: En el que el usuario completamente nuevo hace clic en continuar con apple y se crea el perfil
        Given existe un correo "nuevo_user@apple.com" que NO está registrado en TicketGate
        When el Usuario hace clic en "Continuar con Apple" y autoriza el acceso con ese correo
        Then el Sistema debe crear un nuevo perfil de usuario
        And el campo "social_provider" debe ser "Apple" para el nuevo perfil
    
    #Example 2:
    Example: En el que el sistema toma el nombre y apellido de google y los mapea automáticamente a los campos del nuevo perfil
        Given un Usuario nuevo se registra usando Google
        And el perfil de Google devuelve Nombre: "Juan" y Apellido: "Pérez"
        When el Sistema crea el perfil de TicketGate
        Then el perfil de TicketGate debe tener los campos Nombre: "Juan" y Apellido: "Pérez" automáticamente

# Si un usuario existente inicia sesión con una red social que usa el mismo correo electrónico que su cuenta nativa, el sistema debe vincular ambas identidades.
    #Example 1:
    Example: En el que el usuario con cuenta nativa hace clic en continuar con google con el mismo email y el sistema pregunta si desea vincular la cuenta
        Given existe una cuenta nativa con email "nativo@mail.com"
        And el Usuario intenta hacer Login con Google usando el mismo email "nativo@mail.com"
        When el Sistema detecta que el email ya existe en la base de datos nativa
        Then el Sistema debe pausar el Login y mostrar un mensaje: "¿Desea vincular esta cuenta de Google a su perfil nativo?"

    #Example 2:
    Example: En el que el usuario confirma la vinculación y guarda la información para futuros accesos
        Given el Usuario confirmó la vinculación de su cuenta nativa con Google
        When el Usuario intenta iniciar sesión al día siguiente solo haciendo clic en "Continuar con Google"
        Then el Sistema debe otorgar el acceso sin requerir la contraseña nativa
        And la información del ID social debe permanecer guardada en el perfil

    #Example 3:
    Example: En el que el usuario inicia sesión con una email vinculado en otra cuenta, el sistema lo bloquea por motivos de seguridad
        Given existe la Cuenta "Cuenta_A" (email A) vinculada a Google
        And el Usuario intenta vincular la Cuenta "Cuenta_B" (email B) usando el mismo perfil de Google
        When el Sistema detecta que el ID de Google ya está asignado a "Cuenta_A"
        Then el Sistema debe **bloquear la acción de vinculación**
        And el Sistema debe mostrar un mensaje de error de seguridad: "Este método de acceso ya está vinculado a otro perfil."

#Tras una autenticación exitosa por red social, el usuario debe ser redirigido automáticamente a la página principal
    #Example 1:
    Example: En el que un usuario complementa la autenticación a través de google y se redirige automáticamente a home
        Given el Usuario "Asistente_Social" completa la autenticación con Google
        When el Sistema recibe el token de autenticación
        Then el Sistema debe generar la sesión
        And el Usuario es redirigido automáticamente a la "Página Principal (/home)"

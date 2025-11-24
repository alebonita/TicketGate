Feature: Como un usuario asistente nuevo, quiero un tutorial interactivo y guías visuales claras para entender cómo buscar eventos, comprar boletos y navegar por mis entradas, para poder completar mi primera compra de forma rápida.
    Proporcionar al usuario nuevo o invitado un flujo de navegación interactivo al primer acceso a la plataforma, guiándolo en el uso de las funciones principales para facilitar la conversión a una primera compra.

#El tutorial se activa para usuarios que se loggean por primera vez
    #Escenario 1:
    Example: En el que un usuario recién registrado inicia sesión por primera vez y es recibido inmediatamente con el tutorial.
        Given el estado del tutorial para "NuevoAsistente" es "PENDIENTE"
        When el Usuario "NuevoAsistente" inicia sesión por primera vez
        Then el Sistema debe mostrar la pantalla de bienvenida del Tutorial
        And el estado del tutorial para "NuevoAsistente" debe seguir siendo "PENDIENTE"
    
    #Escenario 2:
    Example: En el que un usuario inicie y cierre sesión y el tutorial no se active automáticamente.
        Given el estado del tutorial para "UsuarioExistente" es "COMPLETADO"
        When el Usuario "UsuarioExistente" inicia y cierra sesión varias veces
        Then el Sistema NO debe mostrar la pantalla de bienvenida del Tutorial
        And el Usuario es dirigido a la página de inicio estándar
    
    #Escenario 3:
    Example: En el que el usuario inicie sesión y no se active el tutorial.
        Given el estado del tutorial para "UsuarioExistente" es "COMPLETADO"
        When el Usuario "UsuarioExistente" inicia y cierra sesión varias veces
        Then el Sistema NO debe mostrar la pantalla de bienvenida del Tutorial
        And el Usuario es dirigido a la página de inicio estándar

#El tutorial incluye la guía paso a paso por la aplicación
    #Escenario 1:
    Example: En el que el tutorial se siga compleménte de inicio a fin.
        Given el Tutorial está activo y se encuentra en el "PASO 1: Búsqueda de Eventos"
        When el Usuario sigue y completa todos los pasos del tutorial secuencialmente
        Then el Sistema debe desactivar el flag "is_first_login" para el Usuario
        And el estado del tutorial para el Usuario debe ser "COMPLETADO"
        And el Usuario es dirigido a la navegación estándar
    
    #Escenario 2:
    Example: En el que el usuario omita el tutorial en algún paso.
        Given el Usuario está en la pantalla de bienvenida del Tutorial
        When el Usuario hace clic en la opción "Omitir Tour"
        Then el Sistema debe cerrar la pantalla de bienvenida inmediatamente
        And el flag "is_first_login" debe ser desactivado
        And el estado del tutorial para el Usuario debe ser "OMITIDO"
    
# El usuario tiene que tener la opción de “Omitir” para evitar el tutorial si así lo prefiere
    #Escenario 1:
    Example: En el que el usuario haga clic en omitir sin iniciar el tutorial
        Given el Usuario está en la pantalla de bienvenida del Tutorial
        When el Usuario hace clic en la opción "Omitir Tour"
        Then el Sistema debe cerrar la pantalla de bienvenida inmediatamente
        And el flag "is_first_login" debe ser desactivado
        And el estado del tutorial para el Usuario debe ser "OMITIDO"
    
    #Escenario 2:
    Example:  En el que el usuario presione omitir en algún punto del tutorial
        Given el Tutorial está activo y se encuentra en el "PASO 3: Agregar al Carrito"
        When el Usuario hace clic en la opción "Omitir Tour"
        Then el Sistema debe cerrar la guía visual
        And el estado del tutorial para el Usuario debe ser "OMITIDO"
    
    #Escenario 3:
    Example: En el que el usuario omite el tutorial, vuelva a iniciar sesión y no vuelva a aparecer.
        Given el estado del tutorial para "AsistenteOmitido" es "OMITIDO"
        When el Usuario "AsistenteOmitido" cierra y vuelve a iniciar sesión
        Then el Sistema NO debe mostrar la pantalla de bienvenida del Tutorial

# El usuario puede reiniciar el tutorial
    #Escenario 1:
    Example: En el que un usuario ya completo el tutorial y lo quiere repetir
        Given el estado del tutorial para "AsistenteCompleto" es "COMPLETADO"
        And el Usuario "AsistenteCompleto" navega a la sección de "Configuración de Perfil"
        When el Usuario selecciona la opción "Reiniciar Guía de Uso"
        Then el Sistema debe actualizar el estado del tutorial a "PENDIENTE"
    
    #Escenario 2:
    Example: En el que el usuario reinicia la guía, vaya a la página de inicio y se reinicie el tutorial
        Given el estado del tutorial para "AsistenteReiniciado" es "PENDIENTE"
        When el Usuario "AsistenteReiniciado" navega a la página de inicio
        Then el Sistema debe activar y mostrar el Tutorial desde el "PASO 1: Búsqueda
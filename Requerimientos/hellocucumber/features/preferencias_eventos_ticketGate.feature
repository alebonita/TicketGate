Feature: Como un usuario asistente quiero poder configurar mis categorías de eventos favoritas, artistas y ubicaciones de interés en mi perfil, para recibir recomendaciones y notificaciones altamente personalizadas, que me ayudan a descubrir eventos relevantes.
    Permite al Usuario Asistente seleccionar y almacenar sus intereses (categorías, artistas, ubicaciones, etc.) para personalizar su experiencia en la plataforma y alimentar los algoritmos de recomendación y segmentación de marketing.

# El usuario debe poder seleccionar y guardar múltiples categorías de eventos, artistas y ubicaciones de forma simultanea
    #Example 1:
    Example: En el que el usuario selecciona 3 categorías de evento y se guardan correctamente
        Given existe un Usuario "Asistente_Fiel" loggeado en la sección "Mi Perfil"
        When el Usuario selecciona las categorías "Rock", "Pop" y "Deportes"
        And hace clic en "Guardar Preferencias"
        Then el Sistema debe confirmar "Preferencias guardadas con éxito"
        And las preferencias del Usuario deben incluir exactamente 3 categorías
    
    #Example 2:
    Example: En el que el usuario selecciona una ubicación y dos artistas no se sobreescriben
        Given el Usuario no tiene preferencias previas
        When el Usuario selecciona la Ubicación "CDMX" y los Artistas "Artista_A" y "Artista_B"
        And hace clic en "Guardar Preferencias"
        Then el Sistema debe guardar 1 Ubicación y 2 Artistas
        And la lista de preferencias no debe mostrar valores sobreescritos
    
    #Example 3:
    Example: En el que el usuario guarde 15 categorías superando el límite y el sistema bloquea y notifica que excedió el límite
        Given el Usuario ha seleccionado previamente 10 categorías
        When el Usuario intenta seleccionar la 11ª categoría (superando el límite de 10)
        Then el Sistema debe bloquear la selección de categorías adicionales
        And el Sistema debe mostrar una notificación: "Ha excedido el límite máximo de preferencias (10)."
    
# El usuario debe poder editar, agregar o eliminar preferencias existentes en cualquier momento desde su perfil.
    #Example 1:
    Example: En el que el usuario elimina una categoría
        Given el Usuario tiene guardadas las categorías "Deportes" y "Música"
        When el Usuario deselecciona la categoría "Deportes"
        And hace clic en "Guardar Preferencias"
        Then la categoría "Deportes" debe ser eliminada del perfil del Usuario
        And el perfil del Usuario solo debe mostrar la preferencia "Música"
    
    #Example 2:
    Example: En el que el usuario agrega más categorías
        Given el Usuario tiene guardada solo la categoría "Música Pop"
        When el Usuario selecciona dos nuevas categorías: "Fútbol" y "Cine"
        And hace clic en "Guardar Preferencias"
        Then el perfil del Usuario debe mostrar un total de 3 categorías guardadas
    
# Las preferencias guardadas deben generar recomendaciones visibles de eventos en la página principal y en el Dashboard de búsqueda.
    #Example 1:
    Example: En el que el usuario selecciona una categoría y la inicio muestra dos eventos de esa categoría
        Given el Usuario tiene guardada la categoría "Tecnología"
        And existen al menos 2 eventos de "Tecnología" activos
        When el Usuario navega a la página de "Recomendados para ti"
        Then el Sistema debe mostrar al menos 2 eventos de la categoría "Tecnología"
    
    #Example 2:
    Example: En el que el usuario elimina todas las preferencias y su algoritmo cambia
        Given el Usuario tenía guardada la preferencia "Arte"
        When el Usuario elimina **todas** sus preferencias
        And navega a la página de "Recomendados para ti"
        Then el Sistema debe cambiar el algoritmo de recomendación a "Popularidad" o "General"
        And la sección de recomendados NO debe mostrar eventos basados en "Arte"

# La configuración de preferencias debe ser completamente opcional y no debe bloquear el registro o la compra de boletos.
    #Example 1:
    Example: En el que un usuario omita la selección de preferencias
        Given el Usuario está en la página de "Preferencias de Eventos"
        When el Usuario navega a otra sección del perfil sin guardar ninguna selección
        Then el Sistema debe permitir la navegación sin errores
        And el perfil del Usuario debe mantener el estado "Sin Preferencias"
    
    #Example 2:
    Example: En el que el sistema muestre opción de configurar las preferencias como una alerta
        Given el Usuario selecciona la categoría "Música Rock"
        And la preferencia es guardada exitosamente (CA1 cumplida)
        When un Organizador de un Evento de Rock accede a la herramienta de "Segmentación de Audiencia"
        Then el Sistema debe incluir el $ID$ del Usuario en la lista de la segmentación "Interesados en Música Rock"
    
# El perfil de preferencias debe sincronizarse automáticamente con las listas de segmentación que utilizan los organizadores para campañas.
    #Example 1: 
    Example: En el que el usuario selecciona una categoría y un organizador puede ver sus preferencias
        Given existe un Usuario "Asistente_Interesado" loggeado
        And el Usuario "Asistente_Interesado" ha guardado la preferencia "Deportes" en su perfil
        And el Organizador "Promotora_Deportiva" tiene permisos para acceder a las herramientas de marketing
        When el Organizador "Promotora_Deportiva" accede al módulo de Segmentación de Audiencia
        Then el Sistema debe mostrar el conteo de usuarios interesados en la categoría "Deportes"
        And el Organizador debe poder seleccionar el segmento "Interesados en Deportes" para una campaña
        And la lista de ese segmento debe incluir al Usuario "Asistente_Interesado"

    #Example 2:
    Example: En el que el usuario elimina una preferencia y el sistema elimina el usuario de los organizadores de esa categoría
        Given el Usuario está actualmente incluido en la lista de segmentación "Deportes Extremos"
        When el Usuario elimina la preferencia "Deportes Extremos" de su perfil
        Then el Sistema debe remover inmediatamente el $ID$ del Usuario de la lista de segmentación "Deportes Extremos"
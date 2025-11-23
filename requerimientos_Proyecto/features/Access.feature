Feature: Interfaz Inclusiva y Accesible (HU-UX-001)
  Como Usuario con discapacidad visual o motora, quiero una interfaz compatible 
  con lectores de pantalla y navegación por teclado, para explorar la cartelera 
  y comprar boletos de forma autónoma.

  Background:
    Given el usuario ha ingresado a la plataforma TicketGate
    And las herramientas de accesibilidad (lector de pantalla/teclado) están activas

  # --- Regla: Lectura de Imágenes (Alt Text) ---

  Scenario: The One With The Band Poster
    Given el usuario navega con el lector de pantalla sobre el póster principal
    When el foco se posa sobre la imagen
    Then el sistema lee en voz alta "Fotografía de la banda tocando en vivo con luces rojas"
    And no lee simplemente el nombre del archivo

  Scenario: The One With The Invisible Decoration
    Given el lector de pantalla encuentra una imagen de fondo con ondas abstractas
    When el sistema procesa el elemento decorativo
    Then lo ignora completamente (silencio) porque el atributo alt está vacío

  Scenario: The One With The Gallery
    Given el usuario navega por una galería de fotos del recinto
    When el foco llega a una miniatura
    Then el sistema lee una descripción breve como "Vista desde Grada Norte" o "Entrada Principal Accesible"

  Scenario: The One Where The Image Breaks
    Given la imagen del evento no carga por un error de red
    When el usuario visualiza el espacio de la imagen
    Then el sistema muestra el texto alternativo visualmente en su lugar
    And permite que todos sepan de qué se trataba la imagen

  Scenario: The One With The Complex Map
    Given el usuario se encuentra con un ícono SVG complejo (ej. gráfico de asientos)
    When el lector de pantalla interpreta el gráfico
    Then lee una descripción simplificada "Mapa de asientos: Disponibilidad alta en zona General"

  # --- Regla: Indicador Visual de Foco (Focus Ring) ---

  Scenario: The One With The Blue Outline
    Given el usuario presiona la tecla Tab para llegar al botón "Comprar"
    When el elemento recibe el foco
    Then el botón muestra un borde grueso y de alto contraste (outline)
    And indica claramente que está seleccionado

  Scenario: The One That Goes In Order
    Given el usuario navega por un formulario largo
    When presiona la tecla Tab repetidamente
    Then el foco se mueve de manera lógica de arriba hacia abajo y de izquierda a derecha
    And no salta campos aleatoriamente

  Scenario: The One With The Modal Trap
    Given el usuario abre una ventana modal de "Confirmación"
    When sigue presionando Tab dentro de la ventana
    Then el foco cicla infinitamente dentro del ventana modal
    And no se escapa a los elementos del fondo (Focus Trap)

  Scenario: The One With The Return Ticket
    Given el usuario cierra la ventana modal
    When la ventana desaparece
    Then el foco regresa automáticamente al botón que abrió esa ventana originalmente
    And el usuario no pierde la posición en la página

  Scenario: The One With The Arrow Keys
    Given el usuario llega a una lista desplegable de "Selección de Cantidad"
    When utiliza las flechas del teclado (Arriba/Abajo)
    Then puede navegar dentro de las opciones tal como lo haría en una aplicación nativa

  # --- Regla: Enlace de Salto (Skip Link) ---

  Scenario: The One With The Secret Shortcut
    Given el usuario carga la página
    When presiona Tab por primera vez
    Then aparece visualmente un botón que estaba oculto con el texto "Saltar al contenido principal"

  Scenario: The One Where We Skip The Menu
    Given el botón de salto es visible
    When el usuario activa el botón con Enter
    Then el foco se mueve inmediatamente al título H1 del evento
    And salta los 15 enlaces del menú de navegación repetitivo

  Scenario: The One Who Takes The Long Way
    Given el botón de salto es visible
    When el usuario decide no activarlo y presiona Tab de nuevo
    Then el foco continúa normalmente hacia el logo y el menú de navegación

  # --- Regla: Etiquetas ARIA en Íconos ---

  Scenario: The One Where The Icon Speaks
    Given existe un botón con ícono de lupa sin texto visible
    When el lector de pantalla selecciona el botón
    Then el sistema anuncia "Buscar Evento" gracias a la etiqueta ARIA

  Scenario: The One With The Close Button
    Given el usuario interactúa con el botón "X" en una ventana emergente
    When el lector de pantalla lee el elemento
    Then anuncia claramente "Cerrar Ventana" en lugar de decir "botón" o "x"

  Scenario: The One With The Social Media
    Given el usuario navega por los íconos de redes sociales en el pie de página
    When el foco llega a los íconos
    Then el lector anuncia "Síguenos en Facebook", "Síguenos en Twitter", etc.

  Scenario: The One With The Spinner
    Given el sistema presenta un indicador de carga (Spinner) animado
    When el lector de pantalla detecta el elemento
    Then anuncia "Cargando contenido, por favor espere" en lugar de ignorar la animación

  # --- Regla: Notificaciones de Estado (Toast) ---

  Scenario: The One With The Success Message
    Given el usuario agrega un boleto al carrito correctamente
    When aparece una notificación visual en pantalla
    Then el lector de pantalla la lee automáticamente: "Éxito: Boleto agregado al carrito"

  Scenario: The One With The Form Error
    Given el usuario intenta pagar pero olvida un campo obligatorio
    When aparece un mensaje de error visual
    Then el lector lo anuncia inmediatamente: "Alerta: El campo de correo es obligatorio"

  Scenario: The One Where Time Runs Out
    Given el temporizador de compra de 10 minutos llega a su fin
    When el sistema detecta el timeout
    Then el lector de pantalla interrumpe al usuario para anunciar: "Aviso importante: El tiempo de reserva ha expirado"

  Scenario: The One With No Results
    Given el usuario realiza una búsqueda que no arroja resultados
    When el sistema muestra el mensaje en pantalla
    Then el lector anuncia: "Información: No se encontraron eventos con ese nombre"
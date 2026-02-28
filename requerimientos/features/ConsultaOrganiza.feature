Feature: Consulta y Exportación de Reportes
  Como Usuario Organizador
  Quiero poder consultar y exportar reportes históricos de ventas, asistencia y alertas
  Para analizar el rendimiento, tomar decisiones estratégicas y realizar auditorías.

Background: Usuario en el módulo de reportes
  Given el usuario "Organizador-A" ha iniciado sesión
  And el usuario accede a la sección "Reportes"
  And el sistema muestra un modal con las categorías: "Ventas", "Asistencia", "Alertas del Sistema"

Scenario: Generación y exportación exitosa de un reporte de Ventas (Happy Path)
  When el usuario selecciona la categoría "Ventas"
  And el usuario filtra por "Evento: Concierto X"
  And el usuario hace clic en "Generar"
  Then el sistema debe mostrar el reporte de "Ventas" para "Evento: Concierto X"
  When el usuario selecciona la opción de exportar en "PDF"
  Then el sistema debe descargar un archivo "reporte_ventas.pdf"

Scenario: Consulta de Alertas del Sistema
  # Cubre el Criterio de Aceptación 3
  When el usuario selecciona la categoría "Alertas del Sistema"
  And el usuario hace clic en "Generar"
  Then el sistema debe mostrar las alertas de los últimos "6" meses

Scenario: Falla en la exportación del reporte (Excepción)
  # Cubre el Criterio de Aceptación 5 y los ejemplos de error
  Given el usuario ha generado un reporte de "Ventas"
  When el usuario selecciona la opción de exportar en "PDF"
  And el sistema de exportación falla con un "Error de I/O"
  Then el sistema debe mostrar el mensaje de error "No se pudo generar el archivo. Intente de nuevo."

Scenario: Segregación de datos entre Organizadores (Criterio de Aceptación 6)
  Given el "Organizador-A" es dueño del "Evento Concierto X"
  And el "Organizador-B" es dueño del "Evento Teatro Y"
  When el usuario selecciona la categoría "Ventas"
  And el usuario hace clic en "Generar"
  Then el reporte generado debe incluir datos del "Evento Concierto X"
  And el reporte generado no debe incluir datos del "Evento Teatro Y"

Scenario: Intento de generación sin seleccionar categoría
  # Basado en los ejemplos de "El usuario no selecciona nada"
  When el usuario no selecciona ninguna categoría
  And el usuario hace clic en "Generar"
  Then no se debe mostrar ningún reporte
  And el sistema debe mostrar un mensaje "Por favor, seleccione una categoría para generar."
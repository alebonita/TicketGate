Feature: Descarga de Reportes de Ventas
  Como Organizador de Eventos, quiero poder descargar reportes de ventas, asistencia y comunicación con filtros personalizados, para realizar análisis financieros y logísticos detallados.

  Scenario: Usuario Loggeado y Creador del Evento
    Given el Usuario Organizador está autenticado y tiene permisos de gestión para el evento seleccionado
    When intenta descargar el reporte
    Then el sistema le permite seguir con la descarga
    And se despliega un menú que permite seleccionar el formato de descarga entre CSV y Excel (.xlsx)

  Scenario: Usuario Loggeado sin Permisos
    Given un usuario está loggeado
    But no es administrador del evento
    When intenta acceder a la parte de los reportes
    Then el sistema le impide seguir con la descarga

  Scenario: Selección de Formato y Validación de Seguridad
    Given el usuario ha presionado el botón de "Descargar"
    And selecciona explícitamente el formato de descarga (CSV o Excel)
    When una vez confirmado el formato, el sistema solicita y valida la contraseña del Organizador antes de procesar la descarga
    Then un modal debe salir donde se pide re-ingresar la contraseña de la cuenta para validar
    And el sistema debe permitir la selección explícita del formato de descarga entre CSV y Excel (.xlsx)

  Scenario: Contraseña de Validación Incorrecta
    Given el usuario ha confirmado el formato de descarga
    When el usuario ingresa la contraseña de forma incorrecta
    Then el sistema no valida la información
    And la descarga del reporte no procede

  Scenario: Definición y Guardado de Filtros Personalizados
    Given el Organizador puede definir filtros personalizados para segmentar los datos del reporte (ej. "Sólo ventas de la Zona VIP")
    When el administrador del evento configura estos filtros
    Then debe existir la posibilidad de guardar una plantilla con filtros de formato para su siguiente evento
    But el sistema no tiene la posibilidad de guardar la preferencia de formato del archivo

  Scenario: Inclusión de Datos Financieros y Logísticos Clave
    When se descarga el reporte de ventas
    Then el reporte debe incluir datos de Venta (monto, impuestos, tasas) y Asistencia (hora de entrada/salida)
    And incluye columnas etiquetadas para el Monto Base, el Impuesto (IVA) aplicado y cualquier Tasa por Servicio separadamente
    But el formato se presenta de forma desorganizada
    And no se logra diferenciar entre cada uno de los aspectos clave para el reporte

  Scenario: Generación de Reporte de Notificaciones Críticas
    Given debe existir una opción para generar un reporte
    When el Organizador selecciona esta opción
    Then el reporte debe incluir el historial de Notificaciones Críticas enviadas
    And el reporte debe incluir métricas de entrega y apertura

  Scenario: Complemento de Reporte para Análisis Detallado
    Given existe un primer reporte de ventas base
    When el Organizador requiere más información para complementar el análisis
    Then debería existir la opción para poder complementar el primer reporte con la inclusión de las alertas enviadas, impuestos, etc.
    But una vez creado el complemento, el archivo con los demás aspectos clave no se logra guardar o solo se imprime un formato base

  Scenario: Descarga Segura y Correcta del Archivo
    Given el archivo de reporte debe descargarse de forma segura
    When la descarga finaliza
    Then el archivo se descarga automáticamente en la carpeta de descargas predeterminada del sistema operativo o navegador
    And el archivo debe apreciarse correctamente en el apartado de descargas del dispositivo del usuario
    But el archivo se descarga con un nombre genérico e incomprensible
Feature: Recomendaciones
  Como Usuario Asistente, quiero ver una sección de eventos Recomendados para ti en la pantalla principal, para descubrir nuevos eventos que coincidan con mis gustos y mi historial de compras.

  Scenario: Usuario No Autenticado Ve Fallback e Inicia Sesión
    Given el usuario no ha iniciado sesión
    When el usuario accede a la pantalla principal (Home)
    Then una sección debe aparecer con el encabezado genérico "Eventos Populares"
    When el usuario inicia sesión y navega a Home
    Then el título de la sección debe cambiar a "Recomendado para ti"
    And una sección horizontal debe mostrarse

  Scenario: Mostrar Número Mínimo de Eventos Recomendados
    Given el usuario ha iniciado sesión exitosamente
    And hay suficientes eventos recomendados disponibles
    When el usuario accede a la sección "Recomendado para ti"
    Then la sección debe mostrar exactamente 5 eventos (o más) que cumplen con los criterios de recomendación

  Scenario: Exclusión Explícita de Eventos Comprados Previamente
    Given el usuario ha comprado boletos para el "Concierto Rock 2024"
    When el sistema genera recomendaciones para este usuario
    Then el evento "Concierto Rock 2024" debe ser excluido explícitamente de la lista
    And cualquier otro evento comprado previamente también debe ser excluido

  Scenario: Recomendaciones Basadas en Compras de Género Específico
    Given el usuario solo ha comprado boletos para eventos de género "Comedia"
    When el usuario ve la sección "Recomendado para ti"
    Then las recomendaciones mostradas deben estar clasificadas como "Stand-up", "Monólogos", o "Show de Improvisación"
    And los eventos recomendados deben ser congruentes con los géneros comprados previamente

  Scenario: El Sistema Basa las Recomendaciones Solamente en la Última Compra
    Given el usuario tiene un historial de compras complejo
    When el sistema genera recomendaciones
    Then el sistema debe recomendar eventos basados solo en el último evento comprado
    And el sistema debe ignorar todo el historial de compras previo

  Scenario: Usuario Nuevo con Historial Vacío Ve la Lógica de Fallback
    Given el usuario no tiene historial de compras
    When el usuario ve la sección "Recomendado para ti"
    Then la sección debe mostrar el Fallback de Eventos Populares o Tendencia en la zona geográfica del usuario
    And la sección no debe estar completamente vacía

  Scenario: Manejo de Eventos Recomendados Cancelados o Agotados
    Given un evento recomendado ha sido cancelado por el organizador o está agotado
    When el usuario accede a la sección
    Then el sistema debe eliminar los eventos cancelados o agotados de la lista de recomendaciones
    And si el evento permanece en la lista, el sistema debe mostrar claramente el estado "Cancelado" en la tarjeta
    When el usuario hace clic en una tarjeta de evento cancelado
    Then el usuario debe ser redirigido a una página con la información de la cancelación

  Scenario: Falla de Consistencia entre la App Móvil y la Web
    Given el usuario accede a la plataforma
    When se compara la sección de recomendaciones en la App Móvil y la Web
    Then la funcionalidad debería estar disponible y ser coherente en la App Móvil y la Web (Paso Esperado)
    But la página principal de la Web no incluye la funcionalidad de recomendaciones (Falla Actual)
    And el nombre y el formato de presentación no deben ser diferentes entre plataformas

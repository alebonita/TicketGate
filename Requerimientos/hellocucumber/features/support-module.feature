Feature: Support Module Access and Usage
  As an event organizer
  I want to access FAQs and tutorials inside my panel
  So that I can solve my doubts without contacting support.

  Scenario: The one where the organizer finds how to create an event
    Given the organizer enters the support module
    When they search for "crear evento"
    Then the system should show a step-by-step tutorial

  Scenario: The one where the organizer is authenticated
    Given the organizer is logged in
    When they click the "Soporte / Ayuda" section
    Then the system should show FAQs and tutorials

  Scenario: The one with the perfect video tutorial
    Given the organizer opens a video tutorial
    When the video loads
    Then the tutorial should play correctly

  Scenario: The one where they filter by category
    Given the organizer selects the category "Pagos"
    When the support content loads
    Then only payment-related FAQs and tutorials should appear

  Scenario: The one with zero search results
    Given the organizer searches for "impuestos avanzados"
    When no tutorial matches the term
    Then the system should show "No se encontraron resultados."

  Scenario: The one with an empty category
    Given the organizer selects an empty category
    When the system loads the page
    Then it should show "No hay información disponible en esta categoría."

  Scenario: The one where the user tries to access without login
    Given the organizer is not authenticated
    When they try to open the support module
    Then the system should redirect them to the login page

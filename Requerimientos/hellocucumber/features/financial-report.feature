Feature: Financial Report Generation
  As an event organizer
  I want to generate a detailed financial report
  So that I can understand my income, taxes and fees clearly.

  Scenario: The one where the event has no sales
    Given the organizer selects an event with zero sales
    When they try to generate the financial report
    Then the system should show the message "Este evento aún no tiene ventas registradas."

  Scenario: The one where everything was calculated perfectly
    Given the organizer selects an event with confirmed sales
    When they generate the financial report
    Then the report should show correct price base, IVA and fees

  Scenario: The one with the pretty graph
    Given the organizer opens the financial report
    When the system renders the visual chart
    Then the incomes per ticket category should be displayed clearly

  Scenario: The one where they filter by date
    Given the organizer selects a date range
    When the report is generated
    Then only the sales from that period should appear

  Scenario: The one with different ticket types
    Given the event includes VIP, General and Early Bird tickets
    When the organizer generates the report
    Then the totals per category should be displayed

  Scenario: The one where the PDF download worked
    Given the organizer generated the financial report
    When they click "Descargar PDF"
    Then the PDF should be generated successfully

  Scenario: The one where the PDF export failed
    Given the organizer generated the financial report
    When the PDF generation fails
    Then the system should show "Hubo un problema al exportar el reporte. Intenta nuevamente."

Feature: Financial Report Generation
  As an event organizer
  I want to generate a detailed financial report
  So that I can understand my income, taxes and fees clearly.

  # 1
  Scenario: The one where the event has no sales
    Given the organizer selects an event with zero sales
    When they try to generate the financial report
    Then the system should show the message "Este evento aún no tiene ventas registradas."

  # 2
  Scenario: The one where everything was calculated perfectly
    Given the organizer selects an event with confirmed sales
    When they generate the financial report
    Then the report should show correct price base, IVA and fees

  # 3
  Scenario: The one with the pretty graph
    Given the organizer opens the financial report
    When the system renders the visual chart
    Then the incomes per ticket category should be displayed clearly

  # 4
  Scenario: The one where they filter by date
    Given the organizer selects a date range
    When the report is generated
    Then only the sales from that period should appear
    And sales outside the selected range must not be included

  # 5
  Scenario: The one with different ticket types
    Given the event includes VIP, General and Early Bird tickets
    When the organizer generates the report
    Then the totals per category should be displayed
    And each category must show its own subtotal

  # 6
  Scenario: The one where the PDF download worked
    Given the organizer generated the financial report
    When they click "Descargar PDF"
    Then the PDF should be generated successfully
    And the file must contain complete event financial data

  # 7
  Scenario: The one where the PDF export failed
    Given the organizer generated the financial report
    When the PDF generation fails
    Then the system should show "Hubo un problema al exportar el reporte. Intenta nuevamente."

  # 8 (NEW)
  Scenario: The one where the CSV export worked
    Given the organizer generated the financial report
    When they click "Exportar CSV"
    Then the system should generate a CSV file
    And the CSV must include all rows without formatting errors

  # 9 (NEW)
  Scenario: The one where the net revenue was calculated correctly
    Given the event has sales with base price, IVA and service fee
    When the organizer generates the financial report
    Then the system must calculate the net revenue correctly
      And net revenue must equal total income minus IVA and fees

  # 10 (NEW)
  Scenario: The one where duplicated sales were prevented
    Given the event has 300 valid tickets sold
    And 5 duplicated records exist in the raw transactions
    When the organizer generates the financial report
    Then the system must ignore duplicated sales
    And the final total must consider only the 300 unique valid tickets

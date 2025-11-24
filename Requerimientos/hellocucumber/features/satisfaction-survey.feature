Feature: Satisfaction Survey Delivery and Response
  As an event attendee
  I want to receive and answer a satisfaction survey
  So that I can share my experience and help improve future events.


  # 1. The attendee receives the survey correctly
  Scenario: The one where the attendee receives the survey correctly
    Given the attendee's QR was validated at the event
    When the event finishes
    Then the system should send the satisfaction survey to the attendee


  # 2. The attendee tries to answer twice
  Scenario: The one where the user tries to answer twice
    Given the attendee has already submitted the survey
    When they try to open the survey link again
    Then the system should show "Ya has respondido esta encuesta."


  # 3. The attendee leaves a long comment
  Scenario: The one where the attendee leaves a long comment
    Given the attendee opens the satisfaction survey
    When they submit ratings and a long comment
    Then the system should store the comment successfully


  # 4. The user did not attend the event
  Scenario: The one where the user did not attend
    Given the user did not validate their QR
    When the system attempts to send the survey
    Then the survey should not be sent


  # 5. A required question is missing
  Scenario: The one where a required question is missing
    Given the attendee opens the survey
    When they try to submit without answering all required questions
    Then the system should show "Debes completar las preguntas obligatorias."


  # 6. The attendee opens the survey on mobile
  Scenario: The one where the user sees the survey on mobile
    Given the attendee opens the survey on a mobile device
    When the survey is displayed
    Then the interface should adapt responsively


  # 7. The survey email fails temporarily
  Scenario: The one where the survey email fails
    Given the system attempts to send the survey email
    When an email error occurs
    Then the system should retry or log the delivery failure


  # 8. The attendee did not attend but tries to answer (MISSING IN YOUR FILE)
  Scenario: The one where the attendee did not attend but tries to answer
    Given the user bought a ticket but did not attend the event
    When they try to access the satisfaction survey
    Then the system should block access
    And the system should show "No puedes responder esta encuesta."


  # 9. The survey arrived late due to email issues (MISSING IN YOUR FILE)
  Scenario: The one where the survey arrived late
    Given the system attempted to send the survey automatically
    When an email error occurs and the system retries later
    Then the attendee should receive the survey once the error is resolved
    And the system should log the delayed delivery


  # 10. The attendee wants to delete their response (MISSING IN YOUR FILE)
  Scenario: The one where the attendee wants to delete their answer
    Given the attendee has already submitted the survey
    When they attempt to modify or delete their response
    Then the system should show "No es posible editar una encuesta enviada."

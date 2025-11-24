Feature: Satisfaction Survey Delivery and Response
  As an event attendee
  I want to receive and answer a satisfaction survey
  So that I can share my experience and help improve future events.

  Scenario: The one where the attendee receives the survey correctly
    Given the attendee's QR was validated at the event
    When the event finishes
    Then the system should send the satisfaction survey to the attendee

  Scenario: The one where the user tries to answer twice
    Given the attendee has already submitted the survey
    When they try to open the survey link again
    Then the system should show "Ya has respondido esta encuesta."

  Scenario: The one where the attendee leaves a long comment
    Given the attendee opens the satisfaction survey
    When they submit ratings and a long comment
    Then the system should store the comment successfully

  Scenario: The one where the user did not attend
    Given the user did not validate their QR
    When the system attempts to send the survey
    Then the survey should not be sent

  Scenario: The one where a required question is missing
    Given the attendee opens the survey
    When they try to submit without answering all required questions
    Then the system should show "Debes completar las preguntas obligatorias."

  Scenario: The one where the user sees the survey on mobile
    Given the attendee opens the survey on a mobile device
    When the survey is displayed
    Then the interface should adapt responsively

  Scenario: The one where the survey email fails
    Given the system attempts to send the survey email
    When an email error occurs
    Then the system should retry or log the delivery failure

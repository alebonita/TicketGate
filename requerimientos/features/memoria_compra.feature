Feature: Temporary exit and re-entry with the same ticket
  As an attendee
  I want to exit the venue temporarily and re-enter securely with the same ticket
  So that I can respect organizer policies while maintaining access integrity

  Background:
    Given an event "Main Event" is active
    And a valid ticket "T-123" belongs to attendee "Alice"
    And the ticket is currently IN_VENUE
    And the allowed re-entry window is 30 minutes
    And the maximum re-entries allowed is 2
    And there are access readers "Entry Gate", "Exit Gate", "VIP Gate", and "General Gate"

  # ---------- Exit registration ----------
  Scenario: Register exit and set state to OUT_OF_VENUE
    When the attendee scans ticket "T-123" at "Exit Gate"
    Then the system shows "Exit registered"
    And the ticket state becomes OUT_OF_VENUE
    And the exact exit timestamp is recorded in access_events for auditing

  # ---------- Valid re-entry within window ----------
  Scenario: Successful re-entry within the allowed window
    Given the ticket "T-123" is OUT_OF_VENUE
    And 20 minutes have passed since exit
    When the attendee scans ticket "T-123" at "Entry Gate"
    Then the system validates the QR
    And the system shows "Re-entry successful"
    And the ticket state becomes IN_VENUE
    And the re-entry is recorded in access_events

  # ---------- Re-entry without exit ----------
  Scenario: Reject re-entry when no exit was recorded
    Given the ticket "T-123" is IN_VENUE
    When the attendee scans ticket "T-123" at "Entry Gate"
    Then access is denied with reason "Ticket already inside the venue"
    And the attempt is recorded in access_events

  # ---------- Re-entry window enforcement ----------
  Scenario: Reject re-entry outside the allowed window
    Given the ticket "T-123" is OUT_OF_VENUE
    And 45 minutes have passed since exit
    When the attendee scans ticket "T-123" at "Entry Gate"
    Then access is denied with reason "Re-entry window exceeded"
    And the attempt is recorded in access_events

  # ---------- Re-entry count limit ----------
  Scenario: Reject when maximum re-entries is reached

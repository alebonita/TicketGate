Feature: Temporary ticket cart
  As an app user
  I want to select tickets from one or multiple events and add them to a temporary cart
  So that I can later verify or purchase after accepting Terms & Conditions

  Background:
    Given events "Event A" and "Event B" have available tickets
    And the user is on the "Events" screen
    And there is no active cart for the user

  # -------- Cart creation --------
  Scenario: Create a cart automatically when selecting the first ticket
    When the user selects 1 ticket for "Event A"
    Then a temporary cart is created for the user
    And the event summary and ticket price are shown
    And sign-in is not required

  Scenario: Keep the cart after registering
    Given the guest user has added 2 tickets for "Event A" to the cart
    When the user signs up or signs in
    Then the cart is associated to the new account without losing tickets

  # -------- Temporary reservation --------
  Scenario: Start a 10-minute timer when multiple tickets are added
    When the user adds 3 tickets for "Event A" to the cart
    Then a 10 minute timer is shown for those tickets
    And when the time expires the tickets are released automatically from inventory and the cart

  Scenario: Independent reservations per event with subtotals
    When the user adds 1 ticket for "Event A" and 2 tickets for "Event B" to the cart
    Then the cart groups tickets by event
    And subtotals per event are shown
    And each event group has its own reservation timer

  # -------- Real-time inventory updates --------
  Scenario: Prevent adding a ticket that just became unavailable
    Given another user has just taken the last ticket for "Event A"
    When the user tries to add that same ticket to the cart
    Then the system shows the message "Ticket unavailable"
    And the event inventory is updated in real time for the user

  # -------- Per-event delivery preferences --------
  Scenario Outline: Save delivery method per event
    Given the user has at least 1 ticket for "<event>" in the cart
    When the user selects the delivery method "<method>"
    Then the cart saves the delivery preference "<method>" for "<event>"

    Examples:
      | event   | method                 |
      | Event A | Digital QR             |
      | Event B | Box office pickup      |

  # -------- Terms & Conditions validation --------
  Scenario: Do not allow verify without accepting Terms & Conditions
    Given the user has tickets in the cart
    And the user has not accepted the Terms and Conditions
    Then the "Review cart" button is disabled

  Scenario: Allow verify or payment after accepting Terms & Conditions
    Given the user has tickets in the cart
    When the user checks the Terms and Conditions acceptance box
    Then the "Review cart" button is enabled
    And the system allows sending the cart for verification or payment
    And a summary of tickets and their status is shown

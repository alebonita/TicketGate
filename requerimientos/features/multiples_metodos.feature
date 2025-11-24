Feature: Múltiples métodos de pago
  Como un usuario de la app
  quiero poder pagar con múltiples métodos de pago
  para completar mi compra de forma segura.

  # AC1. El usuario debe estar autenticado y tener boletos en el carrito para acceder a la pantalla de pago.

  Scenario: The One Where The Authenticated User Reaches Checkout
    Given que el usuario está "autenticado" y tiene 2 boletos en el carrito
    When el usuario intenta acceder a la pantalla de pago
    Then el sistema le permite ver la pantalla de pago

  Scenario: The One Where The Unauthenticated User Gets Redirected
    Given que el usuario está "no autenticado" y tiene 2 boletos en el carrito
    When el usuario intenta acceder a la pantalla de pago
    Then el sistema lo redirige a la pantalla de inicio de sesión

  # AC2. La pantalla de pago solo muestra métodos habilitados según país, evento y moneda.

  Scenario: The One Where The Mexican User Sees CardSpeiAndWallet
    Given que el usuario está "autenticado" y tiene 2 boletos en el carrito
    And que el país del usuario es "MX"
    And que la moneda seleccionada es "MXN"
    When el usuario entra a la pantalla de pago
    Then el sistema muestra los métodos de pago disponibles:
      | tarjeta   |
      | spei      |
      | billetera |

  Scenario: The One Where The USUser SeesCardAndPayPalOnly
    Given que el usuario está "autenticado" y tiene 2 boletos en el carrito
    And que el país del usuario es "US"
    And que la moneda seleccionada es "USD"
    When el usuario entra a la pantalla de pago
    Then el sistema muestra los métodos de pago disponibles:
      | tarjeta |
      | paypal  |

  # AC3. Si la pasarela aprueba el pago, la compra pasa a PAGADA y se generan boletos.

  Scenario: The One Where The CardPaymentSucceeds
    Given que el usuario está "autenticado" y tiene 2 boletos en el carrito
    And que el usuario elige el método de pago "tarjeta"
    And que la pasarela está configurada para responder "aprobado"
    When el usuario confirma el pago
    Then la compra queda en estado "PAGADA"
    And los boletos son generados y asociados al usuario

  Scenario: The One Where The WalletPaymentSucceeds
    Given que el usuario está "autenticado" y tiene 2 boletos en el carrito
    And que el usuario elige el método de pago "billetera"
    And que la pasarela está configurada para responder "aprobado"
    When el usuario confirma el pago
    Then la compra queda en estado "PAGADA"
    And los boletos son generados y asociados al usuario

  # AC4. Si la pasarela rechaza o falla, la compra NO pasa a PAGADA y el usuario puede reintentar.

  Scenario: The One Where The CardPaymentIsDeclined
    Given que el usuario está "autenticado" y tiene 2 boletos en el carrito
    And que el usuario elige el método de pago "tarjeta"
    And que la pasarela está configurada para responder "rechazado"
    When el usuario confirma el pago
    Then la compra queda en estado "PENDIENTE"
    And no se generan boletos
    And el usuario puede elegir otro método de pago

  Scenario: The One Where The GatewayTimesOut
    Given que el usuario está "autenticado" y tiene 2 boletos en el carrito
    And que el usuario elige el método de pago "tarjeta"
    And que la pasarela está configurada para responder "timeout"
    When el usuario confirma el pago
    Then la compra queda en estado "PENDIENTE"
    And no se generan boletos
    And el usuario puede reintentar el pago más tarde

const { Given, When, Then } = require('@cucumber/cucumber');
const assert = require('assert');

Given('que el usuario está {string} y tiene {int} boletos en el carrito', function (estado, boletos) {
    this.usuario = {
        autenticado: estado === 'autenticado',
        boletosEnCarrito: boletos,
    };
});

Given('que el país del usuario es {string}', function (pais) {
    this.pais = pais;
});

Given('que la moneda seleccionada es {string}', function (moneda) {
    this.moneda = moneda;
});

When('el usuario intenta acceder a la pantalla de pago', function () {
    this.puedeVerPantallaPago =
        this.usuario.autenticado && this.usuario.boletosEnCarrito > 0;
});

Then('el sistema le permite ver la pantalla de pago', function () {
    assert.strictEqual(this.puedeVerPantallaPago, true);
});

Then('el sistema lo redirige a la pantalla de inicio de sesión', function () {
    assert.strictEqual(this.puedeVerPantallaPago, false);
});

When('el usuario entra a la pantalla de pago', function () {
    // Lógica dummy basada en país/moneda
    const combos = {
        'MX-MXN': ['tarjeta', 'spei', 'billetera'],
        'US-USD': ['tarjeta', 'paypal'],
    };
    const key = `${this.pais}-${this.moneda}`;
    this.metodosDisponibles = combos[key] || ['tarjeta'];
});

Then('el sistema muestra los métodos de pago disponibles:', function (dataTable) {
    const expected = dataTable.raw().map((r) => r[0]);
    assert.deepStrictEqual(this.metodosDisponibles.sort(), expected.sort());
});

Given('que el usuario elige el método de pago {string}', function (metodo) {
    this.metodoPago = metodo;
});

Given('que la pasarela está configurada para responder {string}', function (respuesta) {
    this.respuestaPasarela = respuesta; // 'aprobado', 'rechazado', 'timeout'
});

When('el usuario confirma el pago', function () {
    if (this.respuestaPasarela === 'aprobado') {
        this.estadoCompra = 'PAGADA';
        this.boletosGenerados = true;
    } else {
        this.estadoCompra = 'PENDIENTE';
        this.boletosGenerados = false;
    }
});

Then('la compra queda en estado {string}', function (estadoEsperado) {
    assert.strictEqual(this.estadoCompra, estadoEsperado);
});

Then('los boletos son generados y asociados al usuario', function () {
    assert.strictEqual(this.boletosGenerados, true);
});

Then('no se generan boletos', function () {
    assert.strictEqual(this.boletosGenerados, false);
});

Then('el usuario puede elegir otro método de pago', function () {
    // Solo validamos que la compra siga pendiente
    assert.strictEqual(this.estadoCompra, 'PENDIENTE');
});

Then('el usuario puede reintentar el pago más tarde', function () {
    assert.strictEqual(this.estadoCompra, 'PENDIENTE');
});
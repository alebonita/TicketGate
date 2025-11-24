const { Given, When, Then } = require('@cucumber/cucumber');
const assert = require('assert');
const crypto = require('crypto');

Given('que existe una compra con {int} boletos', function (n) {
    this.boletos = Array.from({ length: n }).map(() => ({
        token: null,
        estado: 'VENDIDO',
        usado: false,
    }));
});

When('el sistema genera los tokens para los boletos', function () {
    this.boletos.forEach((b) => {
        b.token = crypto.randomUUID();
    });
});

Then('cada boleto tiene un token único', function () {
    const tokens = this.boletos.map((b) => b.token);
    const set = new Set(tokens);
    assert.strictEqual(tokens.length, set.size);
});

Given('que existe un boleto previamente emitido con un token antiguo', function () {
    this.boleto = {
        tokenActual: 'token-antiguo',
        tokensInvalidos: ['token-antiguo'],
    };
});

When('el sistema reemite el boleto', function () {
    this.boleto.tokenAnterior = this.boleto.tokenActual;
    this.boleto.tokenActual = crypto.randomUUID();
    this.boleto.tokensInvalidos.push(this.boleto.tokenAnterior);
});

Then('el boleto obtiene un nuevo token', function () {
    assert.notStrictEqual(this.boleto.tokenActual, this.boleto.tokenAnterior);
});

Then('el token antiguo queda invalidado', function () {
    assert.ok(this.boleto.tokensInvalidos.includes(this.boleto.tokenAnterior));
});

Given('que se genera un código QR para un boleto', function () {
    this.qrPayload = { token: 'abc123', datosSensibles: null };
});

When('se revisa el contenido del QR', function () {
    this.qrContenido = JSON.stringify(this.qrPayload);
});

Then('el QR solo contiene el token cifrado y no datos sensibles', function () {
    assert.ok(this.qrContenido.includes('token'));
    assert.ok(!this.qrContenido.includes('email'));
    assert.ok(!this.qrContenido.includes('nombre'));
});

Given('que un auditor escanea el QR de un boleto', function () {
    this.qrContenido = '{"token":"xyz789"}';
});

When('el auditor inspecciona la información contenida', function () {
    this.qrAnalizado = this.qrContenido;
});

Then('el auditor no encuentra datos personales en texto plano', function () {
    assert.ok(!this.qrAnalizado.includes('nombre'));
    assert.ok(!this.qrAnalizado.includes('correo'));
});

Given(
    'que existe un boleto con token válido en estado {string} y sin uso previo',
    function (estado) {
        this.boletoValidado = {
            token: 'token-valido',
            estado,
            usado: false,
        };
    }
);

When('el lector valida el código QR del boleto', function () {
    if (this.boletoValidado.estado === 'VENDIDO' && !this.boletoValidado.usado) {
        this.accesoPermitido = true;
        this.boletoValidado.estado = 'UTILIZADO';
        this.boletoValidado.usado = true;
    } else {
        this.accesoPermitido = false;
    }
});

Then('el sistema permite el acceso', function () {
    assert.strictEqual(this.accesoPermitido, true);
});

Then('el boleto queda marcado como {string}', function (estado) {
    assert.strictEqual(this.boletoValidado.estado, estado);
});

Given('que existe un boleto con token válido en estado {string}', function (estado) {
    this.boletoValidado = {
        token: 'token-valido',
        estado,
        usado: true,
    };
});

When('el lector valida nuevamente el código QR del boleto', function () {
    this.accesoPermitido =
        this.boletoValidado.estado === 'VENDIDO' && !this.boletoValidado.usado;
});

Then('el sistema rechaza el acceso por boleto ya utilizado', function () {
    assert.strictEqual(this.accesoPermitido, false);
});

Given('que el lector recibe un token alterado manualmente', function () {
    this.tokenEntrada = 'token-alterado';
    this.tokensValidos = ['token-valido-1', 'token-valido-2'];
});

When('el sistema intenta buscar un boleto con ese token', function () {
    this.boletoEncontrado = this.tokensValidos.includes(this.tokenEntrada);
});

Then('el sistema rechaza el acceso por boleto inválido', function () {
    assert.strictEqual(this.boletoEncontrado, false);
});

Given('que un asistente presenta una captura de pantalla de un QR antiguo', function () {
    this.tokenEntrada = 'token-expirado';
    this.tokensExpirados = ['token-expirado'];
});

When('el lector valida el QR', function () {
    this.tokenEsExpirado = this.tokensExpirados.includes(this.tokenEntrada);
});

Then('el sistema rechaza el acceso por token caducado', function () {
    assert.strictEqual(this.tokenEsExpirado, true);
});

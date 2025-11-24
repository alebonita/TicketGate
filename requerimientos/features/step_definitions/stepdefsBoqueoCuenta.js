const { Given, When, Then } = require('@cucumber/cucumber');
const assert = require('assert');

Given('que existe un usuario con estado de cuenta {string}', function (estado) {
    this.usuario = {
        estadoCuenta: estado,
        intentosFallidos: 0,
        notificacionesPush: false,
    };
});

Given('que el usuario ha realizado {int} intentos fallidos de inicio de sesión', function (intentos) {
    this.usuario.intentosFallidos = intentos;
});

Given('que se detecta un intento de acceso desde una ubicación inusual', function () {
    this.accesoDesdeUbicacionInusual = true;
});

When('el sistema evalúa la actividad de inicio de sesión', function () {
    if (this.usuario.intentosFallidos >= 5 || this.accesoDesdeUbicacionInusual) {
        this.usuario.estadoCuenta = 'BLOQUEADA_TEMPORAL';
    }
});

Then('la cuenta del usuario queda en estado {string}', function (estadoEsperado) {
    assert.strictEqual(this.usuario.estadoCuenta, estadoEsperado);
});

Given('que la cuenta del usuario está en estado {string}', function (estado) {
    this.usuario = this.usuario || {};
    this.usuario.estadoCuenta = estado;
});

When('el sistema genera la notificación de bloqueo', function () {
    this.notificacionCorreo = true;
    if (this.usuario.notificacionesPush) {
        this.notificacionPush = true;
    }
});

Then('el usuario recibe un correo indicando que su cuenta fue bloqueada temporalmente', function () {
    assert.strictEqual(this.notificacionCorreo, true);
});

Given('que el usuario tiene notificaciones push activas', function () {
    this.usuario.notificacionesPush = true;
});

Then('el usuario recibe una notificación push indicando el bloqueo por seguridad', function () {
    assert.strictEqual(this.notificacionPush, true);
});

Given('que el usuario recibe un código OTP válido', function () {
    this.otpValido = '123456';
});

When('el usuario ingresa el código OTP correcto', function () {
    this.otpIngresado = '123456';
});

Then('el sistema valida la identidad del usuario', function () {
    assert.strictEqual(this.otpIngresado, this.otpValido);
    this.usuario.verificado = true;
});

Then('la cuenta del usuario puede volver a estado {string}', function (estadoEsperado) {
    if (this.usuario.verificado) {
        this.usuario.estadoCuenta = estadoEsperado;
    }
    assert.strictEqual(this.usuario.estadoCuenta, estadoEsperado);
});

Given('que el enlace de desbloqueo anterior ha expirado', function () {
    this.linkExpirado = true;
});

When('el usuario solicita un nuevo enlace de desbloqueo', function () {
    if (this.linkExpirado) {
        this.nuevoLinkEnviado = true;
    }
});

Then('el sistema envía un nuevo enlace válido al usuario', function () {
    assert.strictEqual(this.nuevoLinkEnviado, true);
});

Given('que el usuario ha pasado satisfactoriamente el proceso de verificación', function () {
    this.usuario.verificado = true;
});

When('el sistema actualiza el estado de la cuenta', function () {
    if (this.usuario.verificado) {
        this.usuario.estadoCuenta = 'ACTIVA';
    }
});

Given('que la cuenta del usuario estuvo en estado {string}', function (estado) {
    this.usuario = this.usuario || {};
    this.usuario.estadoCuenta = estado;
});

Given('que ha transcurrido el periodo de bloqueo configurado', function () {
    this.bloqueoExpirado = true;
});

When('el usuario intenta iniciar sesión nuevamente', function () {
    this.requiereAutenticacionReforzada = this.bloqueoExpirado;
});

Then('el sistema solicita autenticación reforzada', function () {
    assert.strictEqual(this.requiereAutenticacionReforzada, true);
});

Then('si la autenticación reforzada es correcta la cuenta queda en estado {string}', function (estadoEsperado) {
    this.usuario.estadoCuenta = estadoEsperado;
    assert.strictEqual(this.usuario.estadoCuenta, estadoEsperado);
});
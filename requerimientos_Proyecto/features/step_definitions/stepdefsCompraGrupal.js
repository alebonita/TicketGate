const { Given, When, Then } = require('@cucumber/cucumber');

// --- Background ---

Given('el Usuario Comprador ha iniciado sesión en TicketGate', function () {
  return 'pending';
});

Given('se encuentra en la página de detalle del evento string', function (nombreEvento) {
  return 'pending';
});

Given('el límite de compra configurado por el organizador es de {int} boletos', function (limite) {
  return 'pending';
});

// --- Scenarios ---

Given('el usuario tiene {int} boletos comprados previamente en su historial', function (cantidad) {
  return 'pending';
});

When('selecciona {int} boletos en el selector de cantidad', function (cantidad) {
  return 'pending';
});

Then('el sistema permite la selección', function () {
  return 'pending';
});

Then('habilita el botón para continuar a la asignación de datos', function () {
  return 'pending';
});

Given('el usuario ya tiene {int} boletos comprados previamente en su historial', function (cantidad) {
  return 'pending';
});

// Regex para capturar los números dentro de los paréntesis
When(/^intenta seleccionar (\d+) boletos nuevos \(Total (\d+)\)$/, function (nuevos, total) {
  return 'pending';
});

Then('el sistema impide el incremento en el selector', function () {
  return 'pending';
});

Then('muestra el mensaje de error: {string}', function (mensaje) {
  return 'pending';
});

When('intenta interactuar con el selector de cantidad', function () {
  return 'pending';
});

Then('el selector debe aparecer deshabilitado o bloqueado en {int}', function (valor) {
  return 'pending';
});

Then('debe mostrar un mensaje informativo: {string}', function (mensaje) {
  return 'pending';
});

Given('el usuario ha seleccionado {int} boletos y avanzado a la siguiente pantalla', function (cantidad) {
  return 'pending';
});

When('carga el formulario de {string}', function (nombreForm) {
  return 'pending';
});

Then('el sistema muestra {int} tarjetas de formulario', function (cantidad) {
  return 'pending';
});

Then('la tarjeta #{int} contiene los datos del comprador y es de solo lectura', function (num) {
  return 'pending';
});

Then('la tarjeta #{int} está vacía y es editable', function (num) {
  return 'pending';
});

Given('el usuario está llenando los datos del Beneficiario #{int}', function (num) {
  return 'pending';
});

// Regex para teléfono con paréntesis literal
When(/^ingresa el teléfono "([^"]*)" \((\d+) dígitos\)$/, function (telefono, digitos) {
  return 'pending';
});

When('intenta cambiar el foco a otro campo', function () {
  return 'pending';
});

Then('el sistema resalta el campo en rojo', function () {
  return 'pending';
});

Then('deshabilita el botón de {string}', function (btn) {
  return 'pending';
});

When('ingresa el correo {string} sin el carácter {string}', function (correo, char) {
  return 'pending';
});

Then('el sistema marca el campo como inválido', function () {
  return 'pending';
});

Given('el usuario ha dejado el campo {string} del Beneficiario #{int} vacío', function (campo, num) {
  return 'pending';
});

When('hace clic en el botón {string}', function (btn) {
  return 'pending';
});

Then('el sistema impide el envío del formulario', function () {
  return 'pending';
});

Then('realiza un scroll automático hasta el campo vacío', function () {
  return 'pending';
});

Given('el usuario seleccionó {int} boletos de ${int} cada uno', function (cant, precio) {
  return 'pending';
});

Given('todos los datos de los beneficiarios son válidos', function () {
  return 'pending';
});

When('ingresa una tarjeta Visa válida y confirma el pago', function () {
  return 'pending';
});

Then('el sistema genera un único cargo de ${int}', function (monto) {
  return 'pending';
});

Then('envía {int} correo de resumen al Comprador', function (cant) {
  return 'pending';
});

Then('envía {int} correos individuales a los emails de los beneficiarios registrados', function (cant) {
  return 'pending';
});

Given('el usuario intenta pagar el total de la orden', function () {
  return 'pending';
});

Given('la pasarela de pagos rechaza la tarjeta por {string}', function (razon) {
  return 'pending';
});

Given('el temporizador de reserva aún tiene {string} minutos restantes', function (tiempo) {
  return 'pending';
});

When('el sistema recibe el error de la pasarela', function () {
  return 'pending';
});

Then('muestra el mensaje {string}', function (mensaje) {
  return 'pending';
});

Then('NO borra los datos ingresados en los formularios', function () {
  return 'pending';
});

Then('permite al usuario intentar pagar nuevamente con otra tarjeta', function () {
  return 'pending';
});

Given('el usuario se encuentra llenando los formularios', function () {
  return 'pending';
});

When('el temporizador de {int} minutos llega a {string}', function (min, tiempo) {
  return 'pending';
});

Then('el sistema muestra un modal con el mensaje {string}', function (mensaje) {
  return 'pending';
});

Then('vacía el carrito de compras', function () {
  return 'pending';
});

Then('redirige al usuario a la página de inicio del evento', function () {
  return 'pending';
});

Given('el usuario escribió {string} en el nombre del Beneficiario #{int}', function (nombre, num) {
  return 'pending';
});

When('borra el texto y escribe {string}', function (nuevoNombre) {
  return 'pending';
});

Then('el sistema actualiza el estado del formulario', function () {
  return 'pending';
});

Then('valida nuevamente que el campo no esté vacío', function () {
  return 'pending';
});
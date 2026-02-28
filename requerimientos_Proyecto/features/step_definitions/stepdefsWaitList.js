const { Given, When, Then } = require('@cucumber/cucumber');

// --- Background ---

Given('el Usuario Asistente ha iniciado sesión en TicketGate', function () {
  return 'pending';
});

Given('existe un evento llamado {string}', function (nombreEvento) {
  return 'pending';
});

// --- Scenarios ---

Given('el inventario general del evento es {int} en la base de datos', function (cantidad) {
  return 'pending';
});

When('el usuario carga la página del evento', function () {
  return 'pending';
});

Then('el botón principal {string} no debe renderizarse', function (btn) {
  return 'pending';
});

Then('debe aparecer el componente {string} habilitado', function (comp) {
  return 'pending';
});

Given('el inventario general del evento es mayor a {int}', function (cantidad) {
  return 'pending';
});

Then('el botón {string} debe permanecer visible y funcional', function (btn) {
  return 'pending';
});

Then('el botón de {string} debe estar oculto', function (btn) {
  return 'pending';
});

Given('el usuario está viendo la página y el inventario es {int}', function (cantidad) {
  return 'pending';
});

When('el WebSocket emite el evento {string}', function (evt) {
  return 'pending';
});

Then('el botón cambia automáticamente de {string} a {string} sin recargar la página', function (b1, b2) {
  return 'pending';
});

Given('el sistema de inventario devuelve un valor negativo por error', function () {
  return 'pending';
});

Then('la interfaz interpreta el estado como agotado', function () {
  return 'pending';
});

Then('muestra el botón de {string} por seguridad', function (btn) {
  return 'pending';
});

Given('el usuario no se encuentra registrado en la tabla {string} para este evento', function (tabla) {
  return 'pending';
});

// NOTA: Se eliminó "hace clic en el botón {string}" de aquí para evitar
// la ambigüedad. Cucumber usará la definición que está en stepdefsCompraGrupal.js

Then('el sistema guarda un nuevo registro con estatus {string} y la fecha actual', function (status) {
  return 'pending';
});

Then('la UI muestra un mensaje de éxito: {string}', function (msg) {
  return 'pending';
});

Then('el botón cambia de estado a {string}', function (estado) {
  return 'pending';
});

Given('varios usuarios se inscriben simultáneamente', function () {
  return 'pending';
});

When('el sistema procesa las solicitudes', function () {
  return 'pending';
});

Then('debe registrar los milisegundos exactos de cada uno para garantizar el orden FIFO', function () {
  return 'pending';
});

Given('el usuario ya tiene un registro activo con estatus {string}', function (status) {
  return 'pending';
});

When('intenta hacer clic en {string} nuevamente desde el mismo navegador', function (btn) {
  return 'pending';
});

Then('el Backend retorna un conflicto', function () {
  return 'pending';
});

Then('la UI muestra la alerta: {string}', function (msg) {
  return 'pending';
});

Then('NO se crea un nuevo registro en la base de datos', function () {
  return 'pending';
});

Given('el usuario se inscribió previamente desde su celular', function () {
  return 'pending';
});

When('inicia sesión en su computadora e intenta unirse al mismo evento', function () {
  return 'pending';
});

Then('el sistema detecta el registro previo por {string}', function (campo) {
  return 'pending';
});

Then('bloquea la nueva inscripción mostrando {string}', function (msg) {
  return 'pending';
});

Given('el usuario ya recibió notificación y tiene estatus {string}', function (status) {
  return 'pending';
});

When('intenta unirse de nuevo a la lista antes de comprar', function () {
  return 'pending';
});

Then('el sistema le recuerda que revise su correo', function () {
  return 'pending';
});

Then('no altera su turno ni crea un registro nuevo', function () {
  return 'pending';
});

// CORRECCIÓN: Usamos Regex aquí para ser exactos y evitar errores de "Undefined"
Given(/^la lista de espera tiene el orden: Ross primero, Rachel después$/, function () {
  return 'pending';
});

Given('se libera {int} boleto por cancelación', function (cant) {
  return 'pending';
});

When('el Worker de asignación se ejecuta', function () {
  return 'pending';
});

Then('selecciona estrictamente a {string} por ser el registro más antiguo', function (user) {
  return 'pending';
});

Then('cambia su estatus a {string}', function (status) {
  return 'pending';
});

Given('el sistema ha asignado un boleto liberado al usuario {string}', function (user) {
  return 'pending';
});

When('cualquier otro usuario consulta el inventario público del evento', function () {
  return 'pending';
});

Then('el inventario sigue marcando {int} boletos disponibles', function (cant) {
  return 'pending';
});

Then('el boleto permanece bloqueado exclusivamente para {string}', function (user) {
  return 'pending';
});

Given('la lista tiene {int} personas y se libera {int} boleto', function (p, b) {
  return 'pending';
});

When('el Worker asigna el boleto al usuario #{int}', function (num) {
  return 'pending';
});

Then('los usuarios del #{int} al #{int} permanecen en estatus {string} sin cambios', function (n1, n2, status) {
  return 'pending';
});

Given('se libera {int} boleto pero la lista de espera está vacía', function (cant) {
  return 'pending';
});

When('el Worker de asignación verifica la tabla {string}', function (tabla) {
  return 'pending';
});

Then('el sistema cambia el estatus del evento a {string}', function (status) {
  return 'pending';
});

Then('permite la venta general al público inmediatamente', function () {
  return 'pending';
});

Given('el usuario #{int} en la lista tiene su cuenta suspendida o inactiva', function (num) {
  return 'pending';
});

When('el Worker intenta asignar el boleto', function () {
  return 'pending';
});

Then('el sistema salta automáticamente al usuario #{int}', function (num) {
  return 'pending';
});

Then('asigna el boleto al usuario #{int} en la fila', function (num) {
  return 'pending';
});

Given('el usuario ha sido seleccionado por el Worker', function () {
  return 'pending';
});

When('el sistema genera la notificación', function () {
  return 'pending';
});

Then('crea una URL única que incluye un token firmado', function () {
  return 'pending';
});

Then('el token tiene una configuración de expiración de {int} minutos', function (min) {
  return 'pending';
});

Then('envía el correo electrónico al usuario', function () {
  return 'pending';
});

Given('el usuario {string} recibió el enlace pero se lo envió a {string}', function (u1, u2) {
  return 'pending';
});

When('{string} intenta abrir el enlace con su propia sesión iniciada', function (user) {
  return 'pending';
});

Then('el sistema rechaza el acceso al checkout', function () {
  return 'pending';
});

Then('muestra un error de {string}', function (err) {
  return 'pending';
});

Given('el usuario {string} tiene estatus {string}', function (user, status) {
  return 'pending';
});

Given('han pasado {int} minutos desde que se le envió el correo', function (min) {
  return 'pending';
});

When('el Cron Job de limpieza se ejecuta', function () {
  return 'pending';
});

Then('cambia el estatus de {string} a {string}', function (user, status) {
  return 'pending';
});

Then('retira el bloqueo del boleto reservado', function () {
  return 'pending';
});

Given('el sistema acaba de marcar a un usuario como {string}', function (status) {
  return 'pending';
});

When('el proceso de limpieza finaliza', function () {
  return 'pending';
});

Then('dispara inmediatamente el proceso de asignación', function () {
  return 'pending';
});

Then(/^el boleto se ofrece al siguiente usuario en la fila \("([^"]*)"\)$/, function (user) {
  return 'pending';
});

Given('el usuario intenta acceder al enlace de compra en el minuto {int}', function (min) {
  return 'pending';
});

When('carga la página', function () {
  return 'pending';
});

Then('el sistema valida la fecha del token', function () {
  return 'pending';
});

Then('muestra una página de error indicando que el turno ha caducado', function () {
  return 'pending';
});

Given('el usuario tiene estatus {string} en este evento', function (status) {
  return 'pending';
});

When('hace clic nuevamente en {string}', function (btn) {
  return 'pending';
});

Then('el sistema permite crear un NUEVO registro', function () {
  return 'pending';
});

Then('el usuario se forma al final de la cola con una nueva fecha', function () {
  return 'pending';
});
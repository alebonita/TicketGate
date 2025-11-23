const { Given, When, Then } = require('@cucumber/cucumber');


Given('que la fecha actual es {string}', function (fecha) {
  return 'pending';
});

Given('que el Evento {string} está programado para ocurrir en {int} días', function (nombreEvento, dias) {
  return 'pending';
});

Given('que el Asistente tiene un boleto activo para el Evento {string}', function (nombreEvento) {
  return 'pending';
});

Given('que el Evento {string} está programado para ocurrir en menos de 24 horas \\(ej. {int} horas\\)', function (nombreEvento, horas) {
  return 'pending';
});

Given('que el Asistente ya recibió la notificación de T-7 días para el Evento {string}', function (nombreEvento) {
  return 'pending';
});

Given('que la fecha actual es el día siguiente a la notificación inicial \\(Evento {string} a {int} días\\)', function (nombreEvento, dias) {
  return 'pending';
});

Given('que el Asistente tiene un boleto para el Evento {string} que está {string}', function (nombreEvento, estadoBoleto) {
  return 'pending';
});

Given('que el Evento {string} cumple la regla de proximidad de fecha \\(ej. {int} días\\)', function (nombreEvento, dias) {
  return 'pending';
});

Given('que el Asistente recibe una Push Notification de proximidad para el {string}', function (nombreEvento) {
  return 'pending';
});

Given('que la sesión del Asistente en la App está {string}', function (estadoSesion) {
  return 'pending';
});

Given('que el Evento {string} tiene el nombre {string}', function (idEvento, nombreRealEvento) {
  return 'pending';
});

Given('que el Evento {string} cumple una regla de proximidad de notificación', function (idEvento) {
  return 'pending';
});


When('el cron job de notificaciones se ejecuta', function () {
  return 'pending';
});

When('el Asistente hace clic en la notificación', function () {
  return 'pending';
});


Then('el Asistente debe recibir una Push Notification', function () {
  return 'pending';
});

Then('la notificación debe indicar que el Evento {string} es en {int} días', function (nombreEvento, dias) {
  return 'pending';
});

Then('la Push Notification recibida debe contener el nombre del Evento {string}', function (nombreEvento) {
  return 'pending';
});

Then('la notificación debe mostrar la cuenta regresiva precisa \\(ej. "{string}" o "{string}"\\)', function (texto1, texto2) {
  return 'pending';
});

Then('la notificación de T-7 días para el Evento {string} no se vuelve a enviar al Asistente', function (nombreEvento) {
  return 'pending';
});

Then('el Asistente no debe recibir ninguna Push Notification para el Evento {string}', function (nombreEvento) {
  return 'pending';
});

Then('la App TickerGate debe abrirse', function () {
  return 'pending';
});

Then('el Asistente debe ser redirigido {string}', function (destinoRedireccion) {
  return 'pending';
});

Then('la Push Notification debe contener el título {string}', function (tituloEsperado) {
  return 'pending';
});

Then('la notificación debe mostrar la cuenta regresiva correcta', function () {
  return 'pending';
});
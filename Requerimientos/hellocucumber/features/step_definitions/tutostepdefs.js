const assert = require('assert');
const { Given, When, Then } = require('@cucumber/cucumber');

// --- Contexto de Datos Simulado (Base de Datos y Estados) ---
let DB_USERS = {
    "NuevoAsistente": { id: 101, tutorial_status: "PENDIENTE", is_first_login: true },
    "UsuarioExistente": { id: 102, tutorial_status: "COMPLETADO", is_first_login: false },
    "AsistenteOmitido": { id: 103, tutorial_status: "OMITIDO", is_first_login: false },
    "AsistenteCompleto": { id: 104, tutorial_status: "COMPLETADO", is_first_login: false },
    "AsistenteReiniciado": { id: 105, tutorial_status: "PENDIENTE", is_first_login: false } // Nota: 'PENDIENTE' simula estado tras reinicio
};

let currentContext = {
    currentUser: null,
    tutorialIsActive: false,
    UI_location: "Login",
    pasoActual: null,
    message: null
};

// --- Funciones Lógicas de Simulación ---

/**
 * Simula el proceso de inicio de sesión y la lógica de activación del tutorial.
 */
function simularLogin(usuario) {
    const user = DB_USERS[usuario];
    currentContext.currentUser = usuario;

    // Lógica de activación: Solo si el estado es PENDIENTE (o si fuera el primer login REAL)
    if (user.tutorial_status === "PENDIENTE") {
        currentContext.tutorialIsActive = true;
        currentContext.UI_location = "Tutorial Screen";
        currentContext.pasoActual = "PASO 1: Búsqueda de Eventos";
    } else {
        currentContext.tutorialIsActive = false;
        currentContext.UI_location = "Página de Inicio Estándar";
    }
}

/**
 * Simula la acción de completar o saltar el tutorial.
 */
function finalizarTutorial(usuario, status) {
    const user = DB_USERS[usuario];
    user.tutorial_status = status;
    user.is_first_login = false; // Desactivar flag una vez que se muestra/omite
    currentContext.tutorialIsActive = false;
    currentContext.UI_location = "Página de Inicio Estándar";
}

Given('el estado del tutorial para {string} es {string}', function (usuario, estado) {
    DB_USERS[usuario].tutorial_status = estado;
    currentContext.currentUser = usuario;
});

Given('el Tutorial está activo y se encuentra en el {string}', function (paso) {
    currentContext.tutorialIsActive = true;
    currentContext.UI_location = "Tutorial Screen";
    currentContext.pasoActual = paso;
});

Given('el Usuario está en la pantalla de bienvenida del Tutorial', function () {
    currentContext.tutorialIsActive = true;
    currentContext.UI_location = "Tutorial Screen";
    currentContext.pasoActual = "Bienvenida";
});

Given('el Usuario {string} navega a la sección de "Configuración de Perfil"', function (usuario) {
    // Simulación de navegación a la sección donde está la opción de reinicio
    currentContext.UI_location = "Configuración de Perfil";
});


When('el Usuario {string} inicia sesión por primera vez', function (usuario) {
    simularLogin(usuario);
});

When('el Usuario {string} inicia y cierra sesión varias veces', function (usuario) {
    simularLogin(usuario); // 1er intento (debe fallar)
    finalizarTutorial(usuario, DB_USERS[usuario].tutorial_status); // Cierra sesión (mantiene el estado)
    simularLogin(usuario); // 2do intento (debe fallar otra vez)
});

When('el Usuario sigue y completa todos los pasos del tutorial secuencialmente', function (usuario) {
    finalizarTutorial(usuario, "COMPLETADO");
});

When('el Usuario hace clic en la opción "Omitir Tour"', function (usuario) {
    finalizarTutorial(usuario, "OMITIDO");
});

When('el Usuario presione omitir en algún punto del tutorial', function (usuario) {
    finalizarTutorial(usuario, "OMITIDO");
});

When('el Usuario {string} cierra y vuelve a iniciar sesión', function (usuario) {
    simularLogin(usuario);
});

When('el Usuario selecciona la opción "Reiniciar Guía de Uso"', function (usuario) {
    const user = DB_USERS[usuario];
    user.tutorial_status = "PENDIENTE";
    currentContext.message = "Guía Reiniciada";
});

When('el Usuario {string} navega a la página de inicio', function (usuario) {
    simularLogin(usuario);
});


Then('el Sistema debe mostrar la pantalla de bienvenida del Tutorial', function () {
    assert.ok(currentContext.tutorialIsActive, "El tutorial NO se activó.");
    assert.equal(currentContext.UI_location, "Tutorial Screen", "La UI no está en la pantalla del tutorial.");
});

Then('el estado del tutorial para {string} debe seguir siendo {string}', function (usuario, estado) {
    assert.equal(DB_USERS[usuario].tutorial_status, estado, `El estado del tutorial para ${usuario} debería ser ${estado}.`);
});

Then('el Sistema NO debe mostrar la pantalla de bienvenida del Tutorial', function () {
    assert.ok(!currentContext.tutorialIsActive, "El tutorial se activó inesperadamente.");
});

Then('el Usuario es dirigido a la página de inicio estándar', function () {
    assert.equal(currentContext.UI_location, "Página de Inicio Estándar", "El usuario no fue dirigido a la navegación estándar.");
});

Then('el Sistema debe desactivar el flag "is_first_login" para el Usuario', function (usuario) {
    assert.equal(DB_USERS[usuario].is_first_login, false, "El flag 'is_first_login' no se desactivó.");
});

Then('And el estado del tutorial para el Usuario debe ser {string}', function (estado) {
    assert.equal(DB_USERS[currentContext.currentUser].tutorial_status, estado, `El estado final debería ser ${estado}.`);
});

Then('el Sistema debe cerrar la pantalla de bienvenida inmediatamente', function () {
    assert.ok(!currentContext.tutorialIsActive, "La pantalla no se cerró inmediatamente.");
});

Then('el Sistema debe cerrar la guía visual', function () {
    assert.ok(!currentContext.tutorialIsActive, "La guía visual no se cerró al presionar Omitir.");
});

Then('el Sistema debe actualizar el estado del tutorial a {string}', function (estado) {
    assert.equal(DB_USERS[currentContext.currentUser].tutorial_status, estado, `El estado no se actualizó a ${estado}.`);
});

Then('el Sistema debe activar y mostrar el Tutorial desde el {string}', function (paso) {
    assert.ok(currentContext.tutorialIsActive, "El tutorial no se activó tras el reinicio.");
    assert.equal(currentContext.pasoActual, "PASO 1: Búsqueda de Eventos", "El tutorial no se reinició en el paso correcto.");
});
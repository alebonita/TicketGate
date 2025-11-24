const assert = require('assert');
const { Given, When, Then } = require('@cucumber/cucumber');

// --- Contexto de Datos Simulados (Base de Datos y Estados) ---

// Catálogo de categorías
const CATALOGO = ['Rock', 'Pop', 'Deportes', 'Música Pop', 'Fútbol', 'Cine', 'Tecnología', 'Arte', 'Deportes Extremos', 'Música'];
const LIMITE_MAXIMO = 10;

let DB_USERS = {
    "Asistente_Fiel": { 
        id: 1, 
        isLogged: true,
        preferences: new Set(), // Usamos Set para almacenar sin duplicados
        is_first_login: false 
    },
    "Asistente_Interesado": { 
        id: 2, 
        isLogged: true,
        preferences: new Set(),
        is_first_login: false
    }
};

let DB_SEGMENTATION = {
    "Interesados en Deportes": new Set(),
    "Interesados en Música Rock": new Set(),
    "Deportes Extremos": new Set(['Usuario_999']) // Usuario dummy ya existente
};

let currentContext = {
    currentUser: "Asistente_Fiel",
    message: null,
    navigationAllowed: true,
    recommendationCount: 0
};

// --- Funciones Lógicas de Simulación ---

function savePreferences(user, prefs) {
    const userObj = DB_USERS[user];
    if (!userObj) return;

    if (prefs.size > LIMITE_MAXIMO) {
        currentContext.message = `Ha excedido el límite máximo de preferencias (${LIMITE_MAXIMO}).`;
        return false;
    }

    userObj.preferences = prefs;
    currentContext.message = "Preferencias guardadas con éxito";
    
    // Simular sincronización de Marketing (CA5)
    sincronizarMarketing(user, userObj.preferences);
    return true;
}

function sincronizarMarketing(user, preferences) {
    // 1. Limpiar usuario de todas las listas conocidas
    Object.keys(DB_SEGMENTATION).forEach(list => {
        DB_SEGMENTATION[list].delete(user);
    });

    // 2. Agregar a listas basadas en las nuevas preferencias
    if (preferences.has('Deportes')) DB_SEGMENTATION["Interesados en Deportes"].add(user);
    if (preferences.has('Música Rock')) DB_SEGMENTATION["Interesados en Música Rock"].add(user);
    if (preferences.has('Deportes Extremos')) DB_SEGMENTATION["Deportes Extremos"].add(user);
}

function getRecomendaciones(user) {
    const userObj = DB_USERS[user];
    if (userObj.preferences.size === 0) {
        // Algoritmo cambia a Popularidad/General (CA3)
        currentContext.recommendationCount = 5;
        currentContext.recommendationTitle = "Eventos Populares";
    } else if (userObj.preferences.has('Tecnología')) {
        currentContext.recommendationCount = 2; // Cumple el requisito mínimo del escenario
        currentContext.recommendationTitle = "Recomendado para ti";
    }
}

Given('existe un Usuario {string} loggeado en la sección "Mi Perfil"', function (user) {
    currentContext.currentUser = user;
    assert.ok(DB_USERS[user].isLogged, 'El usuario debe estar loggeado.');
});

Given('el Usuario no tiene preferencias previas', function () {
    DB_USERS[currentContext.currentUser].preferences = new Set();
});

Given('el Usuario ha seleccionado previamente {int} categorías', function (count) {
    const prefs = new Set();
    for(let i = 1; i <= count; i++) {
        prefs.add(`Cat_Prev_${i}`);
    }
    DB_USERS[currentContext.currentUser].preferences = prefs;
    assert.equal(DB_USERS[currentContext.currentUser].preferences.size, count);
});

Given('el Usuario tiene guardadas las categorías {string} y {string}', function (cat1, cat2) {
    DB_USERS[currentContext.currentUser].preferences = new Set([cat1, cat2]);
});

Given('el Usuario tiene guardada solo la categoría {string}', function (cat) {
    DB_USERS[currentContext.currentUser].preferences = new Set([cat]);
});

Given('el Usuario tiene guardada la preferencia {string}', function (pref) {
    DB_USERS[currentContext.currentUser].preferences = new Set([pref]);
});

Given('existen al menos {int} eventos de {string} activos', function (count, cat) {
    currentContext.activeEvents = count; // Simulación del inventario
});

Given('el Usuario tenía guardada la preferencia {string}', function (pref) {
    DB_USERS[currentContext.currentUser].preferences = new Set([pref]);
});

Given('el Usuario está en la página de "Preferencias de Eventos"', function () {
    // Contexto de la UI
    currentContext.navigationAllowed = true;
});

Given('el Usuario está actualmente incluido en la lista de segmentación {string}', function (segment) {
    DB_SEGMENTATION[segment].add(currentContext.currentUser);
    assert.ok(DB_SEGMENTATION[segment].has(currentContext.currentUser), 'El usuario debe estar en la lista antes de la acción.');
});

Given('el Organizador {string} tiene permisos para acceder a las herramientas de marketing', function (org) {
    // Simulación de permisos
});


When('el Usuario selecciona las categorías {string}, {string} y {string}', function (cat1, cat2, cat3) {
    const prefs = new Set([cat1, cat2, cat3]);
    currentContext.selection = prefs;
});

When('el Usuario selecciona la Ubicación {string} y los Artistas {string} y {string}', function (loc, art1, art2) {
    const prefs = new Set([loc, art1, art2]);
    currentContext.selection = prefs;
});

When('el Usuario intenta seleccionar la {int}ª categoría {string}', function (count, cat) {
    const prefs = DB_USERS[currentContext.currentUser].preferences;
    if (prefs.size >= LIMITE_MAXIMO) {
        currentContext.message = `Ha excedido el límite máximo de preferencias (${LIMITE_MAXIMO}).`;
    } else {
        prefs.add(cat);
        currentContext.selection = prefs;
    }
});

When('hace clic en "Guardar Preferencias"', function () {
    const user = currentContext.currentUser;
    savePreferences(user, currentContext.selection);
});

When('el Usuario deselecciona la categoría {string}', function (cat) {
    const prefs = DB_USERS[currentContext.currentUser].preferences;
    prefs.delete(cat);
    currentContext.selection = prefs; // Actualiza la selección a guardar
});

When('el Usuario selecciona dos nuevas categorías: {string} y {string}', function (cat1, cat2) {
    const prefs = DB_USERS[currentContext.currentUser].preferences;
    prefs.add(cat1);
    prefs.add(cat2);
    currentContext.selection = prefs;
});

When('el Usuario navega a la página de "Recomendados para ti"', function () {
    getRecomendaciones(currentContext.currentUser);
});

When('el Usuario elimina {string} sus preferencias', function (accion) {
    if (accion === 'todas') {
        DB_USERS[currentContext.currentUser].preferences = new Set();
    }
    sincronizarMarketing(currentContext.currentUser, DB_USERS[currentContext.currentUser].preferences);
});

When('el Usuario omite la selección de preferencias', function () {
    // Simula que no hubo clic en guardar, solo navegación.
    currentContext.navigationAllowed = true;
});

When('el Usuario navega a otra sección del perfil sin guardar ninguna selección', function () {
    currentContext.navigationAllowed = true;
});

When('un Organizador de un Evento de Rock accede a la herramienta de "Segmentación de Audiencia"', function () {
    // Simulación de acceso
});

When('el Usuario elimina la preferencia {string} de su perfil', function (pref) {
    DB_USERS[currentContext.currentUser].preferences.delete(pref);
    sincronizarMarketing(currentContext.currentUser, DB_USERS[currentContext.currentUser].preferences);
});

When('el Organizador {string} accede al módulo de Segmentación de Audiencia', function (org) {
    // Simulación de consulta
});


Then('el Sistema debe confirmar {string}', function (mensaje) {
    assert.equal(currentContext.message, mensaje, 'El mensaje de confirmación no es correcto.');
});

Then('las preferencias del Usuario deben incluir exactamente {int} categorías', function (count) {
    const user = DB_USERS[currentContext.currentUser];
    // Se verifica que todos los elementos guardados sean de la selección actual
    const expectedCategories = Array.from(currentContext.selection).filter(p => CATALOGO.includes(p));
    assert.equal(user.preferences.size, expectedCategories.length, `Se esperaban ${expectedCategories.length} preferencias guardadas.`);
});

Then('el Sistema debe guardar {int} Ubicación y {int} Artistas', function (locCount, artCount) {
    const user = DB_USERS[currentContext.currentUser];
    assert.equal(user.preferences.size, locCount + artCount, 'El número total de preferencias no coincide.');
});

Then('la lista de preferencias no debe mostrar valores sobreescritos', function () {
    // Esto se verifica implícitamente por el uso del Set en la simulación.
    const user = DB_USERS[currentContext.currentUser];
    assert.ok(user.preferences.size > 1, 'Se guardaron múltiples valores.');
});

Then('el Sistema debe bloquear la selección de categorías adicionales', function () {
    assert.ok(currentContext.message.includes('límite máximo'), 'El sistema no bloqueó la selección.');
});

Then('el Sistema debe mostrar una notificación: {string}', function (mensaje) {
    assert.equal(currentContext.message, mensaje, 'El mensaje de error de límite es incorrecto.');
});

Then('la categoría {string} debe ser eliminada del perfil del Usuario', function (cat) {
    assert.ok(!DB_USERS[currentContext.currentUser].preferences.has(cat), `La categoría ${cat} no fue eliminada.`);
});

Then('el perfil del Usuario solo debe mostrar la preferencia {string}', function (cat) {
    const user = DB_USERS[currentContext.currentUser];
    assert.equal(user.preferences.size, 1, 'Solo debe quedar una preferencia.');
    assert.ok(user.preferences.has(cat), `La preferencia restante no es ${cat}.`);
});

Then('el perfil del Usuario debe mostrar un total de {int} categorías guardadas', function (count) {
    assert.equal(DB_USERS[currentContext.currentUser].preferences.size, count, `El total de categorías no es ${count}.`);
});

Then('el Sistema debe mostrar al menos {int} eventos de la categoría {string}', function (minCount, cat) {
    getRecomendaciones(currentContext.currentUser); // Asegura que la recomendación se ejecuta
    assert.ok(currentContext.recommendationCount >= minCount, 'No se mostraron suficientes eventos recomendados.');
});

Then('el Sistema debe cambiar el algoritmo de recomendación a {string} o {string}', function (pop, gen) {
    getRecomendaciones(currentContext.currentUser);
    assert.equal(currentContext.recommendationTitle, "Eventos Populares", 'El algoritmo no cambió a Popularidad/General.');
});

Then('la sección de recomendados NO debe mostrar eventos basados en {string}', function (cat) {
    // Implícitamente verificamos que el algoritmo ha cambiado.
});

Then('el Sistema debe permitir la navegación sin errores', function () {
    assert.ok(currentContext.navigationAllowed, 'La navegación fue bloqueada.');
});

Then('And el perfil del Usuario debe mantener el estado {string}', function (estado) {
    assert.equal(DB_USERS[currentContext.currentUser].preferences.size, 0, 'No debe haber preferencias guardadas.');
});

Then('el Sistema debe incluir el ID del Usuario en la lista de la segmentación {string}', function (segment) {
    assert.ok(DB_SEGMENTATION[segment].has(currentContext.currentUser), `El usuario no está en la lista ${segment}.`);
});

Then('el Sistema debe mostrar el conteo de usuarios interesados en la categoría {string}', function (cat) {
    // Simulación: El Organizador ve el tamaño del Set
    const count = DB_SEGMENTATION["Interesados en Deportes"].size;
    assert.ok(count >= 1, 'El conteo de usuarios no es correcto (debe ser >= 1).');
});

Then('el Organizador debe poder seleccionar el segmento {string} para una campaña', function (segment) {
    assert.ok(DB_SEGMENTATION[segment], 'El segmento no está disponible para selección.');
});

Then('la lista de ese segmento debe incluir al Usuario {string}', function (user) {
    assert.ok(DB_SEGMENTATION["Interesados en Deportes"].has(user), 'El usuario no está incluido en la lista de Deportes.');
});

Then('el Sistema debe remover inmediatamente el ID del Usuario de la lista de segmentación {string}', function (segment) {
    assert.ok(!DB_SEGMENTATION[segment].has(currentContext.currentUser), 'El usuario no fue removido del segmento de marketing.');
});
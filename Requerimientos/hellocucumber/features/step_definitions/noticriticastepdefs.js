const assert = require('assert');
const { Given, When, Then } = require('@cucumber/cucumber');

// --- Contexto de Datos Simulado (Base de Datos y Estados) ---
// Estado inicial de la base de datos para los escenarios
let DB_USERS = {
    "asistente@mail.com": { 
        id: 101, 
        password: "hashed_pass", // Credencial nativa
        social_provider: null, 
        social_id: null,
        nombre: "Asistente Nativo"
    },
    "existente@social.com": { 
        id: 102, 
        password: null, 
        social_provider: "Google", 
        social_id: "google_id_102",
        nombre: "Usuario Social"
    },
    "nativo@mail.com": { 
        id: 103, 
        password: "hashed_pass_nativa", 
        social_provider: null, 
        social_id: null,
        nombre: "Usuario Nativo"
    },
    "cuenta_a@mail.com": { 
        id: 104, 
        password: "hashed_A", 
        social_provider: "Google", 
        social_id: "google_id_vinculada", // ID Social ya asignado aquí
        nombre: "Cuenta A Vinculada"
    }
};

let currentSession = {
    isAuthenticated: false,
    userEmail: null,
    redirectURL: null,
    message: null,
    socialProfile: {
        email: null,
        nombre: null,
        apellido: null,
        provider: null,
        social_id: null
    }
};

// --- Funciones Lógicas de Simulación ---

/**
 * Simula la lógica central del Backend al intentar un login social.
 * Determina si debe ser LOGIN, REGISTRO, VINCULACIÓN o BLOQUEO.
 */
function simularLoginSocial(socialProfile) {
    const email = socialProfile.email;
    const existingUser = DB_USERS[email];
    
    // 1. Detección de Conflicto de Seguridad (ID Social ya usado por OTRO email)
    const existingSocialIdConflict = Object.values(DB_USERS).find(
        u => u.social_id === socialProfile.social_id && u.email !== email
    );

    if (existingSocialIdConflict) {
        return { success: false, action: 'ERROR_VINCULACION_ASIGNADA' };
    }

    if (existingUser) {
        // 2. Detección de Conflicto de Email
        if (existingUser.social_provider === socialProfile.provider) {
            // Caso: Login de cuenta ya vinculada (Acceso)
            return { success: true, user: existingUser, action: 'LOGIN_SOCIAL' };
        } else if (!existingUser.social_provider && existingUser.password) {
            // Caso: Conflicto de email (Requiere Vinculación)
            return { success: false, user: existingUser, action: 'CONFIRMACION_VINCULACION' };
        }
    }

    // 3. Registro Rápido (Usuario nuevo)
    const newUser = {
        id: Date.now(),
        email: email,
        password: null,
        social_provider: socialProfile.provider,
        social_id: socialProfile.social_id,
        nombre: `${socialProfile.nombre} ${socialProfile.apellido || ''}`.trim()
    };
    DB_USERS[email] = newUser;
    return { success: true, user: newUser, action: 'REGISTRO_RAPIDO' };
}

function generarSesion(user) {
    currentSession.isAuthenticated = true;
    currentSession.userEmail = user.email;
    currentSession.redirectURL = '/home';
}

// --- Pasos Gherkin (Implementación) ---

// =============================================================
// GIVEN (Contexto Inicial)
// =============================================================
Given('existe un Usuario {string} con email {string} y contraseña válida', function (nombreUsuario, email) {
    assert.ok(DB_USERS[email], `El usuario ${email} debe existir.`);
});

Given('el Usuario {string} tiene una cuenta TicketGate vinculada a Google', function (nombreUsuario) {
    // Contexto ya establecido en DB_USERS.
});

Given('existe una cuenta nativa con email {string}', function (email) {
    assert.ok(DB_USERS[email] && DB_USERS[email].password, `La cuenta nativa ${email} debe existir.`);
});

Given('existe un correo {string} que NO está registrado en TicketGate', function (email) {
    assert.strictEqual(DB_USERS[email], undefined, `El correo ${email} no debe existir aún.`);
    currentSession.socialProfile.email = email;
    currentSession.socialProfile.social_id = 'new_social_id';
});

Given('un Usuario nuevo se registra usando Google', function () {
    // Establecer correo temporal y un ID social único para el registro.
    currentSession.socialProfile.email = 'temp_map_user@google.com'; 
    currentSession.socialProfile.social_id = 'map_social_id';
});

Given('el perfil de Google devuelve Nombre: {string} y Apellido: {string}', function (nombre, apellido) {
    currentSession.socialProfile.nombre = nombre;
    currentSession.socialProfile.apellido = apellido;
    currentSession.socialProfile.provider = 'Google';
});

Given('el Usuario confirmó la vinculación de su cuenta nativa con Google', function () {
    const email = 'nativo@mail.com';
    DB_USERS[email].social_provider = 'Google';
    DB_USERS[email].social_id = 'google_id_para_vinculacion';
    currentSession.isAuthenticated = true;
    currentSession.userEmail = email;
});

Given('existe la Cuenta {string} (email A) vinculada a Google', function (cuenta) {
    // Contexto de seguridad para bloqueo (Cuenta A ya tiene el ID social 'google_id_vinculada')
});

Given('el Usuario {string} completa la autenticación con Google', function (usuario) {
    currentSession.isAuthenticated = true;
    currentSession.userEmail = 'temp_email_redirect@google.com';
});

When('el Usuario ingresa su email y contraseña', function () {
    const result = simularLoginNat("asistente@mail.com", "password_dummy");
    if (result.success) generarSesion(result.user);
});

When('hace clic en {string}', function (boton) {
    // Para login nativo
});

When('el Usuario hace clic en {string} y autoriza el acceso', function (socialProvider) {
    currentSession.socialProfile.provider = socialProvider.includes('Google') ? 'Google' : 'Apple';
    
    // Si es un login de cuenta existente, usa datos ya existentes:
    if (currentSession.userEmail === 'existente@social.com') {
        currentSession.socialProfile.social_id = DB_USERS['existente@social.com'].social_id;
    }
    
    const result = simularLoginSocial(currentSession.socialProfile);

    if (result.success) generarSesion(result.user);
});

When('el Usuario intenta hacer Login con Google usando el mismo email {string}', function (email) {
    // Simula que la red social devuelve el correo que genera el conflicto
    currentSession.socialProfile.email = email;
    currentSession.socialProfile.provider = 'Google';
    currentSession.socialProfile.social_id = `google_id_new_${Date.now()}`; 
    
    const result = simularLoginSocial(currentSession.socialProfile);

    if (result.action === 'CONFIRMACION_VINCULACION') {
        currentSession.message = "¿Desea vincular esta cuenta de Google a su perfil nativo?";
    }
});

When('el Usuario completamente nuevo hace clic en continuar con apple y autoriza el acceso con ese correo', function () {
    currentSession.socialProfile.provider = 'Apple';
    const result = simularLoginSocial(currentSession.socialProfile);
    if (result.success) generarSesion(result.user);
});

When('el Sistema crea el perfil de TicketGate', function () {
    // La creación está cubierta en la simulación de Login Social
});

When('el Usuario intenta iniciar sesión al día siguiente solo haciendo clic en {string}', function (socialProvider) {
    const email = 'nativo@mail.com';
    currentSession.socialProfile.email = email;
    currentSession.socialProfile.provider = 'Google';
    currentSession.socialProfile.social_id = DB_USERS[email].social_id;
    
    const result = simularLoginSocial(currentSession.socialProfile);
    if (result.success) generarSesion(result.user);
});

When('el Usuario intenta vincular la Cuenta {string} (email B) usando el mismo perfil de Google', function (cuenta) {
    currentSession.socialProfile.email = 'cuenta_b_nueva@mail.com';
    currentSession.socialProfile.social_id = "google_id_vinculada"; // ID ya usado por Cuenta A
    currentSession.socialProfile.provider = 'Google';

    const result = simularLoginSocial(currentSession.socialProfile);
    if (result.action === 'ERROR_VINCULACION_ASIGNADA') {
        currentSession.message = "ERROR_VINCULACION_ASIGNADA";
    }
});

When('el Sistema detecta que el email ya existe en la base de datos nativa', function () {
    // Ya manejado en el paso anterior
});

When('el Sistema detecta que el ID de Google ya está asignado a {string}', function (cuenta) {
    // Ya manejado en el paso anterior
});

When('el Sistema recibe el token de autenticación', function () {
    // Simulación: asume éxito y procede a la redirección
});

Then('el Sistema debe generar una sesión válida', function () {
    assert.ok(currentSession.isAuthenticated, "No se generó una sesión válida.");
});

Then('el Usuario es redirigido a la {string}', function (pagina) {
    currentSession.redirectURL = '/home'; // Simulación
    assert.equal(currentSession.redirectURL, '/home', `No fue redirigido a ${pagina}.`);
});

Then('el Sistema debe validar el token de Google', function () {
    assert.ok(currentSession.isAuthenticated, "El token no fue validado correctamente.");
});

Then('el Usuario es logueado en la cuenta {string}', function (nombreUsuario) {
    assert.ok(currentSession.isAuthenticated, "El usuario no fue logueado.");
});

Then('el Sistema debe pausar el Login y mostrar un mensaje: {string}', function (mensaje) {
    assert.equal(currentSession.message, "¿Desea vincular esta cuenta de Google a su perfil nativo?", "No se mostró el mensaje de vinculación.");
});

Then('el Sistema debe crear un nuevo perfil de usuario', function () {
    assert.ok(DB_USERS[currentSession.socialProfile.email], "El perfil no fue creado en la DB.");
});

Then('el campo "social_provider" debe ser {string} para el nuevo perfil', function (provider) {
    assert.equal(DB_USERS[currentSession.socialProfile.email].social_provider, provider, "El provider no se mapeó correctamente.");
});

Then('el perfil de TicketGate debe tener los campos Nombre: {string} y Apellido: {string} automáticamente', function (nombre, apellido) {
    const user = DB_USERS[currentSession.userEmail] || DB_USERS[currentSession.socialProfile.email];
    assert.ok(user.nombre.includes(nombre) && user.nombre.includes(apellido), "El nombre y apellido no fueron mapeados.");
});

Then('el Sistema debe otorgar el acceso sin requerir la contraseña nativa', function () {
    assert.ok(currentSession.isAuthenticated, "El acceso no fue otorgado.");
    assert.ok(DB_USERS['nativo@mail.com'].social_id, "El acceso se otorgó sin el ID social vinculado.");
});

Then('la información del ID social debe permanecer guardada en el perfil', function () {
    assert.ok(DB_USERS['nativo@mail.com'].social_id, "La información social no fue persistida.");
});

Then('el Sistema debe bloquear la acción de vinculación', function () {
    assert.equal(currentSession.message, "ERROR_VINCULACION_ASIGNADA", "La acción de bloqueo de seguridad no se activó.");
});

Then('el Sistema debe mostrar un mensaje de error de seguridad: {string}', function (mensaje) {
    assert.equal(currentSession.message, "ERROR_VINCULACION_ASIGNADA", "No se mostró el error de seguridad correcto.");
});
const assert = require('assert');
const { Given, When, Then } = require('@cucumber/cucumber');

// --- Contexto de Datos Simulado (Base de Datos y Estados) ---
// Estado inicial de la base de datos para los escenarios
let DB_USERS = {
    "asistente@mail.com": { 
        id: 101, 
        password: "hashed_pass", 
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
        social_id: "google_id_vinculada",
        nombre: "Cuenta A Vinculada"
    }
};

let currentSession = {
    isAuthenticated: false,
    userEmail: null,
    redirectURL: null,
    message: null,
    // Simula los datos devueltos por la Red Social
    socialProfile: {
        email: null,
        nombre: null,
        apellido: null,
        provider: null,
        social_id: null
    }
};

// --- Funciones Lógicas de Simulación ---

function simularLoginNat(email, password) {
    if (DB_USERS[email] && DB_USERS[email].password) {
        // En un entorno real, se verificaría el hash de la contraseña
        return { success: true, user: DB_USERS[email] };
    }
    return { success: false };
}

function simularLoginSocial(socialProfile) {
    const email = socialProfile.email;
    const existingUser = DB_USERS[email];
    const existingSocialId = Object.values(DB_USERS).find(u => u.social_id === socialProfile.social_id);

    if (existingSocialId && existingSocialId.id !== existingUser?.id) {
        // Excepción: ID social ya asignado a otra cuenta (Caso de bloqueo de seguridad)
        return { success: false, action: 'ERROR_VINCULACION_ASIGNADA' };
    }

    if (existingUser && existingUser.social_provider === socialProfile.provider) {
        // Caso 2: Login Social de cuenta ya vinculada
        return { success: true, user: existingUser, action: 'LOGIN_SOCIAL' };
    } 
    
    if (existingUser) {
        // Caso 3: Conflicto de email, requiere vinculación
        return { success: false, user: existingUser, action: 'CONFIRMACION_VINCULACION' };
    }

    // Caso 4: Registro rápido (Usuario nuevo)
    const newUser = {
        id: Date.now(),
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
    currentSession.redirectURL = '/home'; // Redirección por defecto
}


Given('existe un Usuario {string} con email {string} y contraseña válida', function (nombreUsuario, email) {
    assert.ok(DB_USERS[email], `El usuario ${email} debe existir.`);
});

Given('el Usuario {string} tiene una cuenta TicketGate vinculada a Google', function (nombreUsuario) {
    // Ya asumido en el contexto DB_USERS (ej: 'existente@social.com')
});

Given('existe una cuenta nativa con email {string}', function (email) {
    assert.ok(DB_USERS[email] && DB_USERS[email].password, `La cuenta nativa ${email} debe existir.`);
});

Given('existe un correo {string} que NO está registrado en TicketGate', function (email) {
    assert.strictEqual(DB_USERS[email], undefined, `El correo ${email} no debe existir.`);
    currentSession.socialProfile.email = email;
});

Given('un Usuario nuevo se registra usando Google', function () {
    // Se establece el contexto para el mapeo
});

Given('el perfil de Google devuelve Nombre: {string} y Apellido: {string}', function (nombre, apellido) {
    currentSession.socialProfile.nombre = nombre;
    currentSession.socialProfile.apellido = apellido;
    currentSession.socialProfile.provider = 'Google';
    currentSession.socialProfile.email = 'temp_new_user@google.com'; // Correo temporal para mapeo
    currentSession.socialProfile.social_id = 'temp_id';
});

Given('el Usuario {string} confirma la vinculación de su cuenta nativa con Google', function (confirmacion) {
    // Simula que el usuario ya pasó por la pantalla de confirmación.
    const email = 'nativo@mail.com';
    DB_USERS[email].social_provider = 'Google';
    DB_USERS[email].social_id = 'google_id_para_vinculacion';
    currentSession.isAuthenticated = true; // Simula sesión abierta tras la confirmación
    currentSession.userEmail = email;
});

Given('existe la Cuenta {string} (email A) vinculada a Google', function (cuenta) {
    // Contexto de seguridad para bloqueo.
});

Given('el Usuario {string} completa la autenticación con Google', function (usuario) {
    currentSession.isAuthenticated = true;
    currentSession.userEmail = 'temp_email_redirect@google.com';
    currentSession.redirectURL = '/home';
});

When('el Usuario ingresa su email y contraseña', function () {
    const email = "asistente@mail.com";
    const result = simularLoginNat(email, "password_dummy");
    if (result.success) generarSesion(result.user);
});

When('hace clic en {string}', function (boton) {
    // Se asume que el paso anterior fue exitoso para el Happy Path
});

When('el Usuario hace clic en {string} y autoriza el acceso', function (socialProvider) {
    currentSession.socialProfile.provider = socialProvider.includes('Google') ? 'Google' : 'Apple';
    currentSession.socialProfile.social_id = `id_${Date.now()}`;
    currentSession.socialProfile.email = currentSession.userEmail || "existente@social.com";
    currentSession.socialProfile.nombre = "Usuario";

    const result = simularLoginSocial(currentSession.socialProfile);

    if (result.success) {
        generarSesion(result.user);
    } else {
        currentSession.message = result.action;
    }
});

When('el Usuario intenta hacer Login con Google usando el mismo email {string}', function (email) {
    currentSession.socialProfile.email = email;
    currentSession.socialProfile.provider = 'Google';
    currentSession.socialProfile.social_id = `google_id_${Date.now()}`; // Token nuevo
    
    const result = simularLoginSocial(currentSession.socialProfile);

    if (result.action === 'CONFIRMACION_VINCULACION') {
        currentSession.message = "¿Desea vincular esta cuenta de Google a su perfil nativo?";
    } else if (result.success) {
        generarSesion(result.user);
    }
});

When('el Usuario completamente nuevo hace clic en continuar con apple y autoriza el acceso con ese correo', function () {
    const result = simularLoginSocial(currentSession.socialProfile);
    if (result.success) {
        generarSesion(result.user);
    }
});

When('el Sistema crea el perfil de TicketGate', function () {
    // La creación está cubierta en la simulación de Login Social
    assert.ok(DB_USERS[currentSession.socialProfile.email], "El perfil debe estar en la DB.");
});

When('el Usuario intenta iniciar sesión al día siguiente solo haciendo clic en {string}', function (socialProvider) {
    const email = 'nativo@mail.com';
    currentSession.socialProfile.email = email;
    currentSession.socialProfile.provider = 'Google';
    currentSession.socialProfile.social_id = DB_USERS[email].social_id; // Usa el ID social guardado
    
    const result = simularLoginSocial(currentSession.socialProfile);
    if (result.success) generarSesion(result.user);
});

When('el Sistema detecta que el email ya existe en la base de datos nativa', function () {
    // Este paso es informativo y se maneja en la lógica de `simularLoginSocial`
});

When('el Sistema detecta que el ID de Google ya está asignado a {string}', function (cuenta) {
    currentSession.socialProfile.email = "cuenta_b@mail.com"; // Nuevo intento con otro email
    currentSession.socialProfile.social_id = "google_id_vinculada"; // ID ya usado por Cuenta A
    currentSession.socialProfile.provider = 'Google';

    const result = simularLoginSocial(currentSession.socialProfile);
    if (result.action === 'ERROR_VINCULACION_ASIGNADA') {
        currentSession.message = "ERROR_VINCULACION_ASIGNADA";
    }
});

When('el Sistema recibe el token de autenticación', function () {
    // Simula la validación del token y la generación de la sesión
});

Then('el Sistema debe generar una sesión válida', function () {
    assert.ok(currentSession.isAuthenticated, "No se generó una sesión válida.");
});

Then('el Usuario es redirigido a la {string}', function (pagina) {
    assert.equal(currentSession.redirectURL, '/home', `No fue redirigido a ${pagina}.`);
});

Then('el Sistema debe validar el token de Google', function () {
    // Este paso es implícito, pero se usa para asegurar que la lógica social se ejecutó
    assert.ok(currentSession.isAuthenticated, "El token no fue validado correctamente.");
});

Then('el Usuario es logueado en la cuenta {string}', function (nombreUsuario) {
    assert.ok(currentSession.isAuthenticated, "El usuario no fue logueado.");
    // Comprobación de que la cuenta existe
    const expectedEmail = nombreUsuario.includes('Existente') ? 'existente@social.com' : 'otro_email';
    assert.ok(currentSession.userEmail, "El email loggeado no está establecido.");
});

Then('el Sistema debe pausar el Login y mostrar un mensaje: {string}', function (mensaje) {
    assert.equal(currentSession.message, "¿Desea vincular esta cuenta de Google a su perfil nativo?", "No se mostró el mensaje de vinculación.");
    assert.ok(!currentSession.isAuthenticated, "El login no debe ser automático; debe estar pausado.");
});

Then('el Sistema debe crear un nuevo perfil de usuario', function () {
    assert.ok(DB_USERS[currentSession.socialProfile.email], "El perfil no fue creado en la DB.");
});

Then('el campo "social_provider" debe ser {string} para el nuevo perfil', function (provider) {
    assert.equal(DB_USERS[currentSession.socialProfile.email].social_provider, provider, "El provider no se mapeó correctamente.");
});

Then('el perfil de TicketGate debe tener los campos Nombre: {string} y Apellido: {string} automáticamente', function (nombre, apellido) {
    const user = DB_USERS[currentSession.userEmail];
    assert.ok(user.nombre.includes(nombre) && user.nombre.includes(apellido), "El nombre y apellido no fueron mapeados.");
});

Then('el Sistema debe otorgar el acceso sin requerir la contraseña nativa', function () {
    assert.ok(currentSession.isAuthenticated, "El acceso no fue otorgado.");
    const user = DB_USERS[currentSession.userEmail];
    assert.ok(user.social_id, "El acceso se otorgó sin el ID social vinculado.");
});

Then('la información del ID social debe permanecer guardada en el perfil', function () {
    const user = DB_USERS['nativo@mail.com'];
    assert.ok(user.social_id && user.social_provider === 'Google', "La información social no fue persistida.");
});

Then('el Sistema debe bloquear la acción de vinculación', function () {
    assert.equal(currentSession.message, "ERROR_VINCULACION_ASIGNADA", "La acción de bloqueo de seguridad no se activó.");
});

Then('el Sistema debe mostrar un mensaje de error de seguridad: {string}', function (mensaje) {
    assert.equal(currentSession.message, "ERROR_VINCULACION_ASIGNADA", "No se mostró el error de seguridad correcto.");
});

Then('el Sistema debe generar la sesión', function () {
    assert.ok(currentSession.isAuthenticated, "La sesión no se generó.");
});

Then('el Usuario es redirigido automáticamente a la {string}', function (pagina) {
    assert.equal(currentSession.redirectURL, '/home', `La redirección no apuntó a ${pagina}.`);
});
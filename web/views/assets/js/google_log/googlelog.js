/* --- CONFIG --- */
    const GOOGLE_CLIENT_ID = "TU_GOOGLE_CLIENT_ID.apps.googleusercontent.com";

    /* Variable para saber si el usuario hizo click en register o login */
    let lastAction = null;

    /* Inicializamos Google una sola vez */
    function initGoogleIdentity() {
      google.accounts.id.initialize({
        client_id: GOOGLE_CLIENT_ID,
        callback: handleCredentialResponse,
        // optional: cancel_on_tap_outside: true
      });

      // Renderizamos botones sólo si existen sus contenedores
      const reg = document.getElementById('google-register');
      const log = document.getElementById('google-login');

      if (reg) {
        // marcamos la acción cuando se hace click en el contenedor
        reg.addEventListener('pointerdown', () => { lastAction = 'register'; });
        google.accounts.id.renderButton(reg, {
          theme: "outline",
          size: "large",
          width: "100%"
        });
      }

      if (log) {
        log.addEventListener('pointerdown', () => { lastAction = 'login'; });
        google.accounts.id.renderButton(log, {
          theme: "outline",
          size: "large",
          width: "100%"
        });
      }

      // Evitar selección automática de cuenta
      google.accounts.id.disableAutoSelect();
    }

    /* Callback que recibe Google (id_token en response.credential) */
    function handleCredentialResponse(response) {
      if (!response || !response.credential) {
        console.error("No id_token recibido de Google", response);
        alert("Error al iniciar con Google.");
        return;
      }

      const id_token = response.credential;
      // Determinar redirect según la última acción
      const action = lastAction || 'login';
      const container = (action === 'register') ? document.getElementById('google-register') : document.getElementById('google-login');
      const redirect = (container && container.dataset && container.dataset.redirect) ? container.dataset.redirect : '/';

      // Envío por AJAX al endpoint (usa fetch - funciona sin jQuery)
      fetch('<?php echo $path ?>ajax/google.ajax.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id_token, action, redirect })
      })
      .then(res => res.json())
      .then(json => {
        if (json.success) {
          // guarda token en localStorage y redirige
          if (json.user && json.user.token_user) {
            localStorage.setItem("token-user", json.user.token_user);
          }
          window.location = json.redirect || redirect;
        } else {
          console.error("Google login error:", json);
          // muestra mensaje (usa tus funciones de UI)
          alert(json.error || "Error al autenticarse con Google");
        }
      })
      .catch(err => {
        console.error(err);
        alert("Error en la petición al servidor.");
      })
      .finally(() => {
        // reset
        lastAction = null;
      });
    }

    /* Inicializar cuando el script esté cargado */
    window.addEventListener('load', initGoogleIdentity);

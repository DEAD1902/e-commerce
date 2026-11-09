<?php

/*=============================================
Carga de variables de entorno desde el archivo .env
(ubicado en la raiz del proyecto y excluido de Git)
=============================================*/

if (!function_exists('app_env')) {

	function app_env($key, $default = null) {

		static $vars = null;

		if ($vars === null) {

			$vars = array();
			$file = dirname(__DIR__) . '/.env';

			/* is_file() en lugar de is_readable(): en Windows is_readable() puede dar falsos negativos */
			$lines = is_file($file) ? @file($file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES) : false;

			if ($lines !== false) {

				foreach ($lines as $line) {

					$line = trim($line);

					if ($line === '' || $line[0] === '#' || strpos($line, '=') === false) {
						continue;
					}

					list($name, $value) = explode('=', $line, 2);
					$name  = trim($name);
					$value = trim($value);

					if (strlen($value) > 1 && ($value[0] === '"' || $value[0] === "'") && substr($value, -1) === $value[0]) {
						$value = substr($value, 1, -1);
					}

					$vars[$name] = $value;
				}
			}
		}

		/* Las variables reales del servidor tienen prioridad sobre el archivo .env */
		$value = getenv($key);

		if ($value !== false && $value !== '') {
			return $value;
		}

		return array_key_exists($key, $vars) ? $vars[$key] : $default;
	}
}

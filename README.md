# Guía Experta: Creación de Archivos Ejecutables

## 📋 Tabla de Contenidos
- [Conceptos Fundamentales](#conceptos-fundamentales)
- [Shebangs y Interpretadores](#shebangs-y-interpretadores)
- [Permisos de Ejecución](#permisos-de-ejecución)
- [PATH y Accesibilidad Global](#path-y-accesibilidad-global)
- [Mejores Prácticas](#mejores-prácticas)
- [Casos de Uso Avanzados](#casos-de-uso-avanzados)
- [Troubleshooting](#troubleshooting)

## 🎯 Conceptos Fundamentales

### ¿Qué hace ejecutable a un archivo?

Un archivo es ejecutable cuando cumple **dos condiciones**:
1. **Permisos de ejecución** (`chmod +x`)
2. **Shebang válido** (`#!/path/to/interpreter`)

```bash
# Verificar permisos
ls -la mi_script
# -rwxr-xr-x  1 user group  123 fecha mi_script
#  ^^^
#  Permisos de ejecución para owner, group, others
```

## 🔧 Shebangs y Interpretadores

### Shebangs Comunes

| Lenguaje | Shebang | Uso |
|----------|---------|-----|
| **Bash** | `#!/bin/bash` | Scripts de sistema, automatización |
| **Python** | `#!/usr/bin/env python3` | Scripts Python portables |
| **Node.js** | `#!/usr/bin/env node` | Scripts JavaScript |
| **Ruby** | `#!/usr/bin/env ruby` | Scripts Ruby |
| **Perl** | `#!/usr/bin/env perl` | Scripts Perl |

### ¿Por qué usar `/usr/bin/env`?

```bash
# ❌ Ruta fija - puede fallar en diferentes sistemas
#!/usr/bin/python3

# ✅ Busca en PATH - más portable
#!/usr/bin/env python3
```

**Ventajas de `env`:**
- Busca el intérprete en `$PATH`
- Compatible con virtualenvs
- Funciona en diferentes distribuciones

## 🔐 Permisos de Ejecución

### Sintaxis Octal vs Simbólica

```bash
# Método simbólico (recomendado)
chmod +x script.sh              # Añade ejecución para todos
chmod u+x script.sh             # Solo para el propietario
chmod ug+x script.sh            # Propietario y grupo

# Método octal (preciso)
chmod 755 script.sh             # rwxr-xr-x
chmod 750 script.sh             # rwxr-x---
chmod 700 script.sh             # rwx------
```

### Permisos Recomendados por Tipo

| Tipo de Script | Permisos | Justificación |
|----------------|----------|---------------|
| **Personal** | `700` | Solo tú puedes ejecutar |
| **Equipo** | `750` | Tu grupo puede ejecutar |
| **Sistema** | `755` | Todos pueden ejecutar |
| **Sensible** | `700` | Máxima seguridad |

## 🛣️ PATH y Accesibilidad Global

### Estructura de Directorios

```
$HOME/bin/                    # Scripts personales
├── utils/                    # Utilidades generales
│   ├── timer
│   ├── hello
│   └── open-lab
├── Docker/                   # Scripts específicos de Docker
│   ├── WhatNets
│   ├── WhoConnected
│   └── WhatPorts
└── README.md
```

### Configuración del PATH

```bash
# En ~/.bashrc
export PATH="$HOME/bin/utils:$HOME/bin:$PATH"

# Verificar PATH
echo $PATH | tr ':' '\n' | nl
```

### Función Personalizada para Namespaces

```bash
# En ~/.bashrc - Permite Docker/comando globalmente
Docker() {
    if [[ $# -eq 0 ]]; then
        echo "Available commands:"
        ls "$HOME/bin/Docker/" 2>/dev/null | sed 's/^/  /'
        return 1
    fi
    
    local cmd="$1"
    shift
    
    if [[ -x "$HOME/bin/Docker/$cmd" ]]; then
        "$HOME/bin/Docker/$cmd" "$@"
    else
        echo "Docker command '$cmd' not found"
        return 1
    fi
}
```

## 🏆 Mejores Prácticas

### 1. Estructura del Script

```bash
#!/bin/bash
set -euo pipefail  # Modo estricto

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Función de ayuda
show_usage() {
    echo "Usage: $(basename "$0") [options] <args>"
    echo "Options:"
    echo "  -h, --help    Show this help"
    echo "  -v, --verbose Enable verbose mode"
}

# Validación de argumentos
if [[ $# -eq 0 ]]; then
    show_usage
    exit 1
fi

# Lógica principal
main() {
    # Tu código aquí
    echo -e "${GREEN}Success!${NC}"
}

# Ejecutar solo si es llamado directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

### 2. Manejo de Errores

```bash
# Verificar dependencias
check_dependencies() {
    local deps=("docker" "jq" "curl")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "${RED}Error: $dep not found${NC}" >&2
            exit 1
        fi
    done
}

# Cleanup en exit
cleanup() {
    echo "Cleaning up..."
    # Limpiar archivos temporales, etc.
}
trap cleanup EXIT
```

### 3. Configuración y Variables de Entorno

```bash
# Cargar configuración
if [[ -f "$HOME/.config/myapp/config" ]]; then
    source "$HOME/.config/myapp/config"
fi

# Variables con defaults
TIMEOUT=${TIMEOUT:-30}
LOG_LEVEL=${LOG_LEVEL:-INFO}
```

## 🚀 Casos de Uso Avanzados

### Script con Autocompletado

```bash
# En el script
_my_script_complete() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local opts="start stop restart status"
    COMPREPLY=($(compgen -W "$opts" -- "$cur"))
}

# En ~/.bashrc
complete -F _my_script_complete my_script
```

### Script con Logging

```bash
# Función de logging
log() {
    local level="$1"
    shift
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [$level] $*" >&2
}

log "INFO" "Starting process..."
log "ERROR" "Something went wrong"
```

### Script con Configuración JSON

```bash
# Leer configuración JSON
CONFIG_FILE="$HOME/.config/myapp/config.json"

if [[ -f "$CONFIG_FILE" ]]; then
    API_KEY=$(jq -r '.api_key' "$CONFIG_FILE")
    ENDPOINT=$(jq -r '.endpoint' "$CONFIG_FILE")
fi
```

## 🔍 Troubleshooting

### Problemas Comunes

| Error | Causa | Solución |
|-------|-------|----------|
| `Permission denied` | Sin permisos de ejecución | `chmod +x script` |
| `No such file or directory` | Shebang incorrecto | Verificar ruta del intérprete |
| `Command not found` | No está en PATH | Agregar directorio al PATH |
| `Syntax error` | Error en el código | Usar `bash -n script` para verificar |

### Herramientas de Debugging

```bash
# Verificar sintaxis sin ejecutar
bash -n mi_script.sh

# Ejecutar en modo debug
bash -x mi_script.sh

# Verificar shebang
head -1 mi_script.sh

# Verificar permisos
ls -la mi_script.sh

# Verificar PATH
which mi_script
```

### Validación con ShellCheck

```bash
# Instalar ShellCheck
sudo apt install shellcheck  # Ubuntu/Debian
brew install shellcheck      # macOS

# Analizar script
shellcheck mi_script.sh
```

## 📚 Recursos Adicionales

- [Bash Manual](https://www.gnu.org/software/bash/manual/)
- [ShellCheck](https://www.shellcheck.net/)
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)

---

**💡 Tip Pro:** Usa `type -a comando` para ver todas las versiones de un comando en tu PATH y entender qué se ejecutará realmente.
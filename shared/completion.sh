#!/bin/bash
# Shared completion functions

# Generic completion function for command managers
# Usage: setup_cmd_completion <command_name> <subdirectory>
setup_cmd_completion() {
    local cmd_name="$1"
    local subdir="$2"
    local completion_func="_${cmd_name,,}_complete"  # Lowercase function name
    
    # Create dynamic completion function
    eval "${completion_func}() {
        local cur=\"\${COMP_WORDS[COMP_CWORD]}\"
        local cmd_dir=\"\$HOME/bin/$subdir\"
        
        if [[ \${COMP_CWORD} -eq 1 ]]; then
            if [[ -d \"\$cmd_dir\" ]]; then
                local commands
                commands=\$(find \"\$cmd_dir\" -maxdepth 1 -type f -executable -printf \"%f\\n\")
                COMPREPLY=(\$(compgen -W \"\$commands\" -- \"\$cur\"))
            fi
        fi
    }"
    
    # Register completion
    complete -F "$completion_func" "$cmd_name"
}

# Setup completions for existing commands
setup_cmd_completion "DockerCmd" "Docker"
setup_cmd_completion "Docker" "Docker"      # For alias
setup_cmd_completion "DrupalCms" "Drupal7"  # For your Drupal command
#!/usr/bin/env bats

# Simple test to verify basic functionality

@test "kb show command exists and is executable" {
    run test -x "$HOME/bin/Cheat-sheet/show"
    [ "$status" -eq 0 ]
}

@test "kb alias command exists and is executable" {
    run test -x "$HOME/bin/Cheat-sheet/alias"
    [ "$status" -eq 0 ]
}

@test "kb section command exists and is executable" {
    run test -x "$HOME/bin/Cheat-sheet/section"
    [ "$status" -eq 0 ]
}

@test "kb show shows usage when no arguments" {
    run $HOME/bin/Cheat-sheet/show
    [ "$status" -eq 1 ]
    [[ "$output" == *"Uso:"* ]]
}

@test "kb alias shows usage when no arguments" {
    run $HOME/bin/Cheat-sheet/alias
    [ "$status" -eq 1 ]
    [[ "$output" == *"Uso:"* ]]
}

@test "kb section shows usage when no arguments" {
    run $HOME/bin/Cheat-sheet/section
    [ "$status" -eq 1 ]
    [[ "$output" == *"Uso:"* ]]
}
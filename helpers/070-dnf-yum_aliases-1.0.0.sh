#!/bin/sh

# Aliases for dnf / yum commands

alias_dnf() {
    
    alias dnfin='sudo dnf install "$@"'
    alias dnfse='sudo dnf search "$@"'
    alias dnfrm='sudo dnf remove "$@"'
    alias dnfud='sudo dnf update '
    alias dnfqi='sudo dnf info "$@"'
    alias dnfug='sudo dnf upgrade '
    
}

alias_dnf


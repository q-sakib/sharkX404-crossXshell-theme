if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config "$HOME/.poshthemes/paradox.omp.json" | Invoke-Expression
}

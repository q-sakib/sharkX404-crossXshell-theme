function bench {
    param([scriptblock]$script)
    Measure-Command $script
}

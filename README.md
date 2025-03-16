# CorrPlots

## Installation

```julia
using CorrPlots, CairoMakie, Random, Statistics
Random.seed!(134)
r = cor(rand(15, 15))
begin
    f, ax, p = corrplot(r)
    ax.aspect = DataAspect()
    hidedecorations!(ax)
    f
end
```

## References
See [corrplot](https://github.com/taiyun/corrplot)
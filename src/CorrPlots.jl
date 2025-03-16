module CorrPlots

using CairoMakie

"""
    corrplot(r::AbstractMatrix)

Correlation plot of matrix `r`.

# Keyword arguments
```
circle          draws cicles instead of rectangles; default true
diagonal        visualizes diagonal elements; default false
colormap        colormap of values; default :RdBu_10
colorrange      start and end points of colormap; default (-1, 1)
```
"""
@recipe(Corrplot, r) do scene
    Attributes(
        circle      = true,
        diagonal    = false,
        colormap    = :RdBu_10,
        colorrange  = (-1, 1),
        )
end

function Makie.plot!(plot::Corrplot{<:Tuple{<:AbstractMatrix}})
    r           = plot[:r][]
    circle      = plot[:circle][]
    diagonal    = plot[:diagonal][]
    colormap    = plot[:colormap][]
    colorrange  = plot[:colorrange][]
    n = size(r, 1)
    if circle
        circle◺ = Vector{Circle}(undef, binomial(n, 2))
        circle◹ = Vector{Circle}(undef, binomial(n, 2))
        color◺  = Vector{Float32}(undef, binomial(n, 2))
        color◹  = Vector{Float32}(undef, binomial(n, 2))
        counter = 1
        for i in 1:n
            for j in (i + 1):n
                circle◺[counter] = Circle(Point2f(j - 0.5, 0.5 - i), r[i, j] * 0.45)
                circle◹[counter] = Circle(Point2f(i - 0.5, 0.5 - j), r[j, i] * 0.45)
                color◺[counter]  = r[i, j]
                color◹[counter]  = r[j, i]
                counter += 1
            end
        end
        if diagonal
            circled = Vector{Circle}(undef, n)
            colord  = Vector{Float32}(undef, n)
            for i in 1:n
                circled[i] = Circle(Point2f(i - 0.5, 0.5 - i), r[i, i] * 0.45)
                colord[i]  = r[i, i]
            end
        end
    else
        circle◺ = Vector{Rect}(undef, binomial(n, 2))
        circle◹ = Vector{Rect}(undef, binomial(n, 2))
        color◺  = Vector{Float32}(undef, binomial(n, 2))
        color◹  = Vector{Float32}(undef, binomial(n, 2))
        counter = 1
        for i in 1:n
            for j in (i + 1):n
                width◺ = r[i, j] * 0.95
                width◹ = r[j, i] * 0.95
                circle◺[counter] = Rect(j - 1 + (1 - width◺) / 2, 1 - i - (1 - width◺) / 2, width◺, -width◺)
                circle◹[counter] = Rect(i - 1 + (1 - width◹) / 2, 1 - j - (1 - width◹) / 2, width◹, -width◹)
                color◺[counter] = r[i, j]
                color◹[counter] = r[j, i]
                counter += 1
            end
        end
        if diagonal
            circled = Vector{Rect}(undef, n)
            colord  = Vector{Float32}(undef, n)
            for i in 1:n
                widthd = r[i, i] * 0.95
                circled[i] = Rect(i - 1 + (1 - widthd) / 2, 1 - i - (1 - widthd) / 2, widthd, -widthd)
                colord[i] = r[i, i]
            end
        end
    end
    hlines!(plot, -n:0; color = "#C3C3C3", linewidth = 1)
    vlines!(plot, 0:n; color = "#C3C3C3", linewidth = 1)
    poly!(plot, circle◺, color = color◺, colorrange = colorrange, colormap = colormap)
    poly!(plot, circle◹, color = color◹, colorrange = colorrange, colormap = colormap)
    if diagonal
        poly!(plot, circled, color = colord, colorrange = colorrange, colormap = colormap)
    end
    xlims!(0, n)
    ylims!(-n, 0)
end

end

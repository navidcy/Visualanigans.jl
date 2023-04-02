# # Visualize fields on a latitude-longitude grid.

# ### Install dependencies
#
# First let's make sure we have all required packages installed.

# ```julia
# using Pkg
# pkg"add Oceananigans, CairoMakie, Imaginocean, GeoMakie"
# ```

# ### Construct a test-bed field

# Let's plot a field that lives on a latitude-longitude grid.

using Oceananigans

# First create a latitude-longitude grid

Nx, Ny, Nz = 180, 120, 2

grid = LatitudeLongitudeGrid(size = (Nx, Ny, Nz),
                             latitude = (-60, 60),
                             longitude = (-155, 25),
                             z = (-1, 0),
                             topology = (Periodic, Bounded, Bounded))
# Let's create a field. We choose here a field that lives on the ``y``-faces of the cells
# but any field would do.
#
# We set the field value to ``\sin(3λ)^2 \sin(3φ)`` and see how that looks.

field = Field{Face, Face, Center}(grid)

set!(field, (λ, φ, z) -> sind(3λ)^2 * sind(3φ))

# ### 2D visualization

# We can visualize this field in 2D using a heatmap. Imaginocean.jl adds a method
# to `heatmap!` so that it works with Oceananigans.jl fields.

using CairoMakie, Imaginocean

kwargs = (colorrange = (-1, 1), colormap = :balance)

fig = Figure()
ax = Axis(fig[1, 1],
          xlabel = "longitude [ᵒ]",
          ylabel = "latitude [ᵒ]",
          limits = ((-180, 180), (-90, 90)))

heatmap!(ax, field, 1; kwargs...)

current_figure() # hide
fig

# We can do the same but with a `GeoAxis` provided by the GeoMakie.jl package
# that allows us to add coastlines easy or use various projections.

using GeoMakie

fig = Figure()
ax = GeoAxis(fig[1, 1],
             coastlines = true,
             lonlims = automatic)

heatmap!(ax, field, 1; kwargs...)

current_figure() # hide
fig

# ### 3D visualization on the sphere

# To make a 3D visualization on the sphere we first create a 3D axis and then
# use `heatsphere!` method from Imaginocean.jl.

fig = Figure()
ax = Axis3(fig[1, 1],
           aspect = (1, 1, 1),
           limits = ((-1, 1), (-1, 1), (-1, 1)))

heatsphere!(ax, field; kwargs...)
hidedecorations!(ax) # hides the axes labels

current_figure() # hide
fig

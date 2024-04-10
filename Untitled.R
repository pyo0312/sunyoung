https://plotly.com/r/choropleth-maps/

library(plotly)

fig <- plot_ly()

fig <- fig %>% add_trace(
  type="choropleth",
  geom_sf(data = grid_seoul , aes(geometry = geometry)),
  z=grid_seoul$total_birth_rate,
  colorscale="Viridis",
  zmin=0,
  zmax=12,
  marker=list(line=list(width=0))
)

fig <- fig %>% colorbar(title = "Birth Rate")
fig <- fig %>% layout(title = "2022 Seoul Birth Rate by Municipality")

fig



p2<-ggplot(grid_seoul) +
  geom_sf(data = grid_seoul, aes(geometry = geometry, fill=total_birth_rate, text=TEXT), size=0.01) +
  scale_fill_gradient(low="white", high="blue") 

ggplotly(p2, tooltip = "TEXT") %>% 
  style(hoverlabel = list(bgcolor = "white"), hoveron = "fill")


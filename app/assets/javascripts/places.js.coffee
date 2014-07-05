# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@initPlacesMap = () ->
  map = L.mapbox.map("map", "examples.map-20v6611k")

  featureLayer = L.mapbox.featureLayer().loadURL("/places/index.json").addTo(map)
  featureLayer.on "ready", ->
    map.fitBounds featureLayer.getBounds()
    featureLayer.on "click", (e) ->
      # do something
      return
  return

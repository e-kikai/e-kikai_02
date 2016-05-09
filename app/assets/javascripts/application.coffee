# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https:#github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery.lazyload
#= require jquery_ujs
# require turbolinks
#= require google-analytics-turbolinks
#= require bootstrap-sass-official
#= require jquery_nested_form
#= require ahoy
#= require_tree .

ready = ->
  # ahoy.trackView()
  $("img.lazy").lazyload({ effect : "fadeIn" })

  machine_ids = $ ".machine-link a"
    .map ->
      return $(@).data("id")
    .get()

  console.log(machine_ids)

  ahoy.track("view", {path: location.pathname, title: document.title, machine_ids: machine_ids})


$(document).ready(ready)
# $(document).on('page:load', ready)

# $(window).on("load", ->
#   start = new Date;
# )
#
# $(window).on("beforeunload", ->
#     var time = (new Date - start) / 1000;
#
#     ahoy.track("view", {path: location.pathname, title: document.title, time: time});
# )

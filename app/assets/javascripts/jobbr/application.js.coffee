#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require bootstrap

#= require_self

autoRefreshInterval = 3000
timeout = undefined

scrollToBottom = ($container) ->
  if $container.length > 0
    $container.scrollTop($container[0].scrollHeight)

toggleRefreshButton = ->
  $('#auto-refresh').toggleClass('active')
  $('#auto-refresh i').toggleClass('fa-spin')
  $('#auto-refresh').hasClass('active')

enableAutoRefresh = (force = false) ->
  if force || (getURLParameter('refresh') == '1')
    if toggleRefreshButton()
      timeout = setTimeout(->
        Turbolinks.visit("#{document.location.pathname}?refresh=1")
      , autoRefreshInterval)
    else
      clearTimeout(timeout)
      Turbolinks.visit(document.location.pathname)

init = ->
  scrollToBottom($('.logs'))
  enableAutoRefresh()
  $('#auto-refresh').on 'click', -> enableAutoRefresh(true)

$(document).ready ->

  init()
  $(document).on 'page:load', init

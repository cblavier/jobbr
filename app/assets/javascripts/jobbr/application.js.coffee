#= require jquery
#= require jquery_ujs
#= require jobbr/jquery-pjax
#= require jobbr/bootstrap
#= require_self

scrollToBottom = ($container) ->
  if $container.length > 0
    $container.scrollTop($container[0].scrollHeight)

$(document).ready ->
  $mainContainer = $('#main.container')

  scrollToBottom($('.logs'))
  $('a').pjax container: $mainContainer

  $(document).on 'pjax:complete', ->
    scrollToBottom($('.logs'))

  interval = undefined
  autoRefreshInterval = 5000

  $('#auto-refresh').on 'click', ->
    active = !$(this).hasClass('active')
    $('i', $(this)).toggleClass('icon-spin', active)
    if active
      interval = setInterval(->
        $.pjax({url: document.location, container: $mainContainer})
      , autoRefreshInterval)
    else
      clearInterval(interval)




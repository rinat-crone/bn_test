$ ->
  currentPage = 1

  $('.area-groups input[type=checkbox]').on 'change',  -> $("form input[data-area-group=#{$(@).val()}]").prop 'checked', $(@).is(':checked')
  $('.house-groups input[type=checkbox]').on 'change', -> $("form input[data-house-group=#{$(@).data('house-group')}]").prop 'checked', $(@).is(':checked')
  $('.wc-groups input[type=checkbox]').on 'change',    -> $("form input[data-wc-group=#{$(@).data('wc-group')}]").prop 'checked', $(@).is(':checked')

  loadSearchResults = (page = 1) ->
    $('input[type=submit]').prop 'disabled', true
    data = $('form').serializeArray()
    data.push
      name: 'start'
      value: (page - 1) * 50

    $.get '/search', data, (d) ->
      currentPage = page
      $('#results').html d
      $(".pager .previous").addClass "disabled" if page is 1
      $(".pager").removeClass "hide"
      $('input[type=submit]').prop 'disabled', false
      $('html, body').animate
        scrollTop: $("#results").offset().top
      , 1000
      $(".pager .previous a").on "click", ->
        loadSearchResults(currentPage - 1) if currentPage isnt 1
        false
      $(".pager .next a").on "click", ->
        loadSearchResults(currentPage + 1) if currentPage isnt 20
        false

  $('form').on 'submit', ->
    loadSearchResults()
    false

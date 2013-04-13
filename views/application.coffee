$ ->
  $(".area-groups input[type=checkbox]").on "change",  -> $("form input[data-area-group=#{$(@).val()}]").prop "checked", $(@).is(':checked')
  $(".house-groups input[type=checkbox]").on "change", -> $("form input[data-house-group=#{$(@).data('house-group')}]").prop "checked", $(@).is(':checked')
  $(".wc-groups input[type=checkbox]").on "change",    -> $("form input[data-wc-group=#{$(@).data('wc-group')}]").prop "checked", $(@).is(':checked')
  $("form").on "submit", ->
    false

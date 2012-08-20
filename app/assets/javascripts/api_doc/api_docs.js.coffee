$ ->
  prettyPrint()

  # Select the first panel 
  $('ul.main-tabs li:first').removeClass('active') # wheir hack
  $('ul.main-tabs a:first').tab('show')

  # Select the first sub-panel of each tab
  $('ul.sub-tabs').each ->
    $(this).find('a:first').tab('show')

  # Select a tab based on the URL
  selectPanel window.location.hash

    
  # --- Clicking on a tab link ---
  $('ul.main-tabs li a, ul.sub-tabs li a').click (event) -> 
    window.location.hash = $(this).attr('href')
    

  # --- Submitting the form ---
  $('.tab-pane form').live 'submit', (event) ->
    url = $(this).data('url')
    ids = url.match(/\/(:\w*)/g)
    for id in ids
      input_field = $(this).find('input[name=' + id.substring(2) + ']')
      url = url.replace(id, '/' + input_field.attr('value'))
    $(this).attr('action', url)


selectPanel = (url)->
  if url != ''
    url_parts = window.location.hash.substring(1).split('-')
    $('ul.main-tabs a[href="#' + url_parts[0] + '"]').tab('show')

    if url_parts.length > 1
      $('ul.sub-tabs a[href="' + url + '"]').tab('show')    

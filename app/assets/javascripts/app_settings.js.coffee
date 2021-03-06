class window.AlertNotification
  @notify: (_type, title, msg) ->
    $icon = ""
    switch _type
      when "danger"
        $icon = "glyphicon-warning-sign"
      when "success"
        $icon = "glyphicon-ok"

    $.notify {
        icon: 'glyphicon ' + $icon
        title: "<strong>#{title} </strong>"
        message: "#{msg}"
      }, {
        type: _type,
        allow_dismiss: true,
        z_index: 10000
      }

  @startLoaderIn: (elem = "", size = "fa-3x") ->
    loader = "<i id=\"spinner\" class=\"fa fa-spinner fa-spin #{size}\"></i>"
    if elem.length > 0
      text = $(elem).html(loader)
    else
      text = loader

    return text

window.pluralize = (obj_array, text) ->
  if obj_array.length > 1
    "#{text}s"
  else
    "#{text}"
    
currentAppActiveLink = (elem) ->
	elem.find("a[href=\"#{@location.pathname}\"]").parent().addClass "app-active-li"

window.activeTabs = (elem) ->
  setTimeout ->
    $("ul.nav").find("li").each ->
      if $(this).hasClass("active")
        $(this).css("font-weight", "bold")
        $(this).find("a").css("border-left", "4px solid #CF9451")
      else
        $(this).css("font-weight", "normal")
        $(this).find("a").css("border-left", "0px")
  , 10

$.urlParam = (name) ->
  results = new RegExp('[?&]' + name + '=([^&#]*)').exec(window.location.href)
  if results == null
    null
  else
    results[1] or 0

# find the account whose resource is teacher
window.account = ->
  resource_name = window.location["hostname"].split(".")[0]
  resource_type = window.location["hostname"].split(".")[1]
  subdomain = ""
  subdomain = "#{resource_name}.#{resource_type}" if resource_type == "teacher"

  return subdomain

window.resource_account = account()

window.alertDismiss = (name, value, expires_min, domain) ->
  expire_date = new Date
  expire_date.setMinutes expire_date.getMinutes() + expires_min

  $.cookie('current_account', domain, { expires: 1, path: domain })
  $.cookie(name, value, { expires: expire_date, path: domain })

$(document).on 'page:change', ->
#  Instantiating Plugins and Function
  activeTabs()

  currentAppActiveLink $('.navbar-nav')
  
  window.setTimeout (->
    $('.alert-timeout').fadeTo(500, 0).slideUp 500, ->
      $(this).hide()
  ), 5000

  $('.best_in_place').best_in_place()
  $('.best_in_place').bind().on 'ajax:error', ->
    $('.purr').prepend '<span class=\'glyphicon glyphicon-exclamation-sign\'></span> '
    return

  $("span.best_in_place").closest("a").attr("href", "javascript:void(0)")

  # Default Date Settings (Basically for Best in Place)
  $.datepicker.setDefaults 
  	dateFormat: 'yy-mm-dd'
  	changeMonth: 'true'
  	changeYear: "true"

  $('[data-toggle="tooltip"]').tooltip()

  $('[data-toggle="popover"]').popover()


  

  


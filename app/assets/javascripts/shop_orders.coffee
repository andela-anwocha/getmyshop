$ ->
  $('a.update-btn').click ->
    json_object = {}
    $('tr').each ->
      id = $(this).attr('id')
      status = $(this).find('select').val()
      json_object["#{id}"] = { status: status } if status?

    orders_status = { orders: json_object }
    updateOrderStatus(orders_status)

window.setOrderStatus = (status, element) ->
  json_object = {}
  $('tr').each ->
    id = $(this).attr('id')
    json_object["#{id}"] = { status: status } if $(this).find("input[type='checkbox']").is(':checked')

  orders_status = { orders: json_object }
  updateOrderStatus(orders_status)


updateOrderStatus = (status) ->
  $.ajax
    type: "PUT"
    url: "/orders"
    beforeSend: (xhr) ->
      xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr 'content'
    contentType: "application/json"
    data: JSON.stringify(status)
    success: (data) ->
      window.location.reload(true)
    error: (data) ->
      Materialize.toast "Update Failed, Please Try again later", 4000

$(document).ready ->
  bindDatatable()


bindDatatable = ->
  $(".results-table").dataTable
    aaSorting: [
      [0, "asc"]
    ]
    sDom: "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>"
    sFilterInput: "form-control input-sm form-control 3784057"
    sPaginationType: "bootstrap"
    bRetrieve: true
    oLanguage:
      sLengthMenu: "_MENU_ records per page"
      sSearch: ""
      sLengthMenu: "_MENU_ <div class='length-text'>records per page</div>"
    fnPreDrawCallback: ->
      $(".dataTables_filter input").addClass "form-control input-sm"
      $(".dataTables_filter input").css "width", "200px"
      $(".dataTables_length select").addClass "form-control input-sm"
      $(".dataTables_length select").css "width", "75px"
      $('.dataTables_filter input').attr('placeholder', 'Search');
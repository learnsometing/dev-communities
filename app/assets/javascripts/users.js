$(document).on('turbolinks:load', function () {
  $('#user_search').autocomplete({
    appendTo: $('.user-search-field'),
    autoFocus: true,
    source: $('#user_search').data('autocomplete-source'),
    focus: function (event, ui) {
      $(".ui-helper-hidden-accessible").hide();
      event.preventDefault();
    }
  }).autocomplete("instance")._renderItem = function (ul, item) {
    let link = document.createElement('a')
    link.href = `/users/${item.id}`
    link.innerText = item.name
    return $("<li>").append(link).appendTo(ul);
  };
});
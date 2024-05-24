$(document).ready(function() {
  // ページ読み込み時とセレクトボックスの値が変わったときに処理を実行
  $(document).on('change', '#model', function() {
    if ($(this).val() === 'post') {
      $('#search-form').show();
    } else {
      $('#tag-search-form').hide();
    }
  });
});
$(document).on('turbolinks:load', function() {

  const buildFileField = (index)=> {
    const html = `<div data-index="${index}" class="js-file_group">
                    <input class="js-file" type="file"
                    name="post[photos_attributes][${index}][image]"
                    id="post_photos_attributes_${index}_image"><br>
                    <span class="js-remove">削除</span>
                  </div>`;
    return html;
  }

  let fileIndex = [1,2,3,4,5,6,7,8,9,10];
  lastIndex = $('.js-file_group:last').data('index');
  fileIndex.splice(0, lastIndex);
  $('.hidden-destroy').hide();

  $('#image-box').on('change', '.js-file', function(e) {
    const targetIndex = $(this).parent().data('index');
    const file = e.target.files[0];
    const blobUrl = window.URL.createObjectURL(file);

    if (img = $(`img[data-index="${targetIndex}"]`)[0]) {
      img.setAttribute('src', blobUrl);
    } else {

      if ($('.js-file').length < 10) {
        $('#image-box').append(buildFileField(fileIndex[0]));
          fileIndex.shift();
      　　fileIndex.push(fileIndex[fileIndex.length - 1] + 1);
      }
     } //編集時11枚目追加防止アラート
       $(document).ready(function() {
        if ($('.js-file').length > 10) {
          alert("上限枚数は10枚です");
          return;
       }
    });
  });

  $('#image-box').on('click', '.js-remove', function() {
    const targetIndex = $(this).parent().data('index');
    const hiddenCheck = $(`input[data-index="${targetIndex}"].hidden-destroy`);
　　// 画像データが存在する場合のフォーム削除処理
    if (hiddenCheck) hiddenCheck.prop('checked', true);
    $(this).parent().remove();
    $(`img[data-index="${targetIndex}"]`).remove();


    if ($('.js-file').length == 0) $('#image-box').append(buildFileField(fileIndex[0]));
  });
});
<template>
  <vue-dropzone ref="myVueDropzone" id="dropzone" :options="dropzoneOptions"></vue-dropzone>
</template>

<script>
  import vue2Dropzone from 'vue2-dropzone'
  import 'vue2-dropzone/dist/vue2Dropzone.min.css'
  export default {
    name: 'app',
    components: {
      vueDropzone: vue2Dropzone
    },
    data: function () {
      return {
        dropzoneOptions: {
            url: '/items',
            thumbnailWidth: 150,
            paramName: "image",
            params: {
              "board_id": '079364c4-bb4b-4d5b-bc8d-e6d1a643bbba',
            },
            headers: {
              "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            }
        }
      }
    }
  }
</script>

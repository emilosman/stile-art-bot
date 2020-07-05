<template>
  <vue-dropzone
    id="dropzone"
    ref="dropzone"
    :options="dropzoneOptions"
    @vdropzone-success="uploadComplete"
    >
  </vue-dropzone>
</template>

<script>
  import vue2Dropzone from 'vue2-dropzone'
  export default {
    name: 'app',
    components: {
      vueDropzone: vue2Dropzone
    },
    props: {
      items: Array
    },
    data: function () {
      return {
        dropzoneOptions: {
          url: '/items',
          thumbnailWidth: 150,
          paramName: "image",
          params: {
            "board_id": document.querySelector('meta[name="board-id"]').getAttribute('content')
          },
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          }
        }
      }
    },
    methods: {
      uploadComplete: function(file, response) {
        this.items.push(response)
        this.$refs.dropzone.removeAllFiles()
      }
    }
  }
</script>

<template>
  <div>
    <dropzone :items="items" class="mb-4"></dropzone>
    <packery :items="items" :editing="editing"></packery>
  </div>
</template>

<script>
  import dropzone from './dropzone'
  import packery from './packery'
  import axios from 'axios'

  axios.defaults.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  export default {
    data() {
      return {
        items: [],
        editing: true
      }
    },
    mounted () {
      let boardId = document.querySelector('meta[name="board-id"]').getAttribute('content');
      axios.get(`/boards/${boardId}/items`).then((response)=> {
          this.items = response.data.items
      })
    },
    components: {
      dropzone,
      packery
    }
  }
</script>

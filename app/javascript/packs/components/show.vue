<template>
  <div>
    <packery :items="items" :editing="editing"></packery>
  </div>
</template>

<script>
  import packery from './packery'
  import axios from 'axios'

  axios.defaults.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  export default {
    data() {
      return {
        items: [],
        editing: false
      }
    },
    mounted () {
      let boardId = document.querySelector('meta[name="board-id"]').getAttribute('content');
      axios.get(`/boards/${boardId}/items`).then((response)=> {
          this.items = response.data.items
      })
    },
    components: {
      packery
    }
  }
</script>

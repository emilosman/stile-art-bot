<template>
    <div
      class="dashboard"
      v-packery="{
        itemSelector: '.dashboard-item',
        percentPosition: true,
        columnWidth: '.grid-sizer',
        gutter: '.gutter-sizer',
        stagger: 30,
      }"
      @layoutComplete="doStuff()"
    >
      <div
        class="dashboard-item"
        v-for='item in items'
        v-packery-item
        v-draggabilly
        :key="item.order"
        @dragEnd="doStuff()"
        :data-packery="{
          columns: 1,
          rows: 2
        }"
      >
        <div class="grid-sizer"></div>
        <div class="gutter-sizer"></div>
        <img v-if="item.image_url" :src="item.image_url"/>
      </div>
    </div>
</template>


<script>
  import { packeryEvents } from "vue-packery-plugin";
  import axios from 'axios'

  axios.defaults.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  export default {
    ready: function() {},
    data() {
      return {
        items: []
      }
    },
    mounted () {
      let boardId = document.querySelector('meta[name="board-id"]').getAttribute('content');
      axios.get(`/boards/${boardId}/items`).then((response)=> {
          this.items = response.data.items
          console.log(this.items)
      })
    },
    methods: {
      doStuff: function() {
        packeryEvents.$emit("layout", this.$el);
        console.log("Packery!");
        console.log([this.$el]);
      },
      reLayout: function() {
        console.log(this.$refs.dashboard);
      },
    }
  };
</script>

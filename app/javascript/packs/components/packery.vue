<template>
  <div
    class="dashboard"
    v-packery="{
      itemSelector: '.dashboard-item',
      columnWidth: '.grid-sizer',
      gutter: '.gutter-sizer',
      stagger: 30,
    }"
    @layoutComplete="layoutComplete()"
    @dragItemPositioned="updateOrder()"
  >
    <div
      class="dashboard-item"
      v-for='item in items'
      v-packery-item
      v-draggabilly
      :key="item.position"
      :data-packery="{
        columns: 1,
        rows: 2
      }"
      :data-id="item.id"
    >
      <div class="grid-sizer"></div>
      <div class="gutter-sizer"></div>

      <div v-if="editing">
        <img v-if="item.image_url" :src="item.image_url"/>
        <textarea type="text" v-model="item.text" @change="updateItem(item)" class="image-comment" placeholder="Optional comment here">
        </textarea>
      </div>
      <div v-else class="show-image">
        <a :href="item.image_url">
          <div class="comment-overlay" v-if="item.text">
            {{item.text}}
          </div>
          <img v-if="item.image_url" :src="item.image_url"/>
        </a>
      </div>
    </div>
  </div>
</template>


<script>
  import { packeryEvents } from "vue-packery-plugin";
  import axios from 'axios'

  axios.defaults.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  export default {
    ready: function() {},
    props: {
      items: Array,
      editing: Boolean
    },
    methods: {
      layoutComplete: function() {
        packeryEvents.$emit("layout", this.$el);
      },
      updateOrder: function() {
        let boardId = document.querySelector('meta[name="board-id"]').getAttribute('content');

        packeryEvents.$emit("layout", this.$el);

        let itemElements = this.$el.packery.getItemElements()

        let orderedItems = itemElements.map(function(item, index){
          return({item_id: item.dataset.id, position: index})
        })

        axios.patch(`/boards/${boardId}`, {
          orderedItems: orderedItems
        })
      },
      updateItem: function(item) {
        axios.patch(`/items/${item.id}`, {
          text: item.text
        })
      }
    }
  };
</script>

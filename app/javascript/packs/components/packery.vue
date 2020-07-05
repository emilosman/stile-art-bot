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
    <div v-if="showEmptyMessage">
      This board is empty.
    </div>

    <div
      class="dashboard-item"
      v-if="editing"
      v-for='item in orderedItems'
      v-packery-item
      v-draggabilly
      :key="item.position"
      :data-packery="{
        columns: 1,
        rows: 2
      }"
      :data-id="item.id"
    >
      <item :item="item" :editing="editing"></item>
    </div>

    <div
      class="dashboard-item"
      v-if="!editing"
      v-for='item in orderedItems'
      v-packery-item
      :key="item.position"
      :data-packery="{
        columns: 1,
        rows: 2
      }"
      :data-id="item.id"
    >
      <item :item="item" :editing="editing"></item>
    </div>
  </div>
</template>


<script>
  import { packeryEvents } from "vue-packery-plugin";
  import axios from 'axios'
  import item from './item'

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
      },
      deleteItem: function(item) {
        if (confirm("Are you sure you want to delete this item?")) {
          let indexOfItem = this.items.indexOf(item);
          this.items = this.items.splice(indexOfItem, 1)
          axios.delete(`/items/${item.id}`)
        }
      },
    },
    computed: {
      orderedItems: function () {
        return this.items.sort((a, b) => parseFloat(a.position) - parseFloat(b.position));
      },
      showEmptyMessage: function() {
        return this.items.length == 0 && !this.editing
      }
    },
    components: {
      item
    }
  };
</script>

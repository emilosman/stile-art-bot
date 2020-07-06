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

    <div v-if="editing">
      <div
        class="dashboard-item"
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
        <board-item :item="item" :items="orderedItems" :editing="editing"></board-item>
      </div>
    </div>

    <div v-if="!editing">
      <div
        class="dashboard-item"
        v-for='item in orderedItems'
        v-packery-item
        :key="item.position"
        :data-packery="{
          columns: 1,
          rows: 2
        }"
        :data-id="item.id"
      >
        <board-item :item="item" :editing="editing"></board-item>
      </div>
    </div>
  </div>
</template>


<script>
  import { packeryEvents } from "vue-packery-plugin";
  import axios from 'axios'
  import boardItem from './board-item'

  axios.defaults.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  export default {
    name: 'boardPackery',
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
      }
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
      boardItem
    }
  };
</script>

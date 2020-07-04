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
      <div class="grid-sizer"></div>
      <div class="gutter-sizer"></div>

      <div v-if="editing" class="show-image">
        <a @click="deleteItem(item)" class="item-delete">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 511.99 511.99"><g fill="#000"><circle cx="255.992" cy="255.999" r="236.278"/><path d="M255.995 511.979c-65.587 0-131.174-24.957-181.108-74.872-99.849-99.849-99.849-262.348 0-362.217 99.849-99.829 262.368-99.849 362.217 0 99.849 99.869 99.849 262.348 0 362.217-49.935 49.915-115.542 74.872-181.109 74.872zM102.939 102.942c-84.374 84.394-84.374 221.719 0 306.113 84.414 84.374 221.738 84.394 306.113 0s84.374-221.719 0-306.113c-84.415-84.374-221.719-84.374-306.113 0z"/></g><g fill="#fff"><path d="M187.115 344.678a19.783 19.783 0 01-14.026-5.813c-7.757-7.757-7.757-20.295 0-28.052l140.26-140.26c7.757-7.757 20.295-7.757 28.052 0 7.757 7.757 7.757 20.295 0 28.052l-140.26 140.26c-3.889 3.869-8.948 5.813-14.026 5.813z"/><path d="M327.355 344.678a19.783 19.783 0 01-14.026-5.813l-140.26-140.26c-7.757-7.757-7.757-20.295 0-28.052s20.295-7.757 28.052 0l140.26 140.26c7.757 7.757 7.757 20.295 0 28.052a19.781 19.781 0 01-14.026 5.813z"/></g></svg>
        </a>
        <img v-if="item.image_url" :src="item.image_url"/>
        <textarea type="text" v-model="item.text" @change="updateItem(item)" class="image-comment" placeholder="Optional comment here">
        </textarea>
      </div>
      <div v-else class="show-image">
        <a :href="item.image_url" target="_blank">
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
    }
  };
</script>

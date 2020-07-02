<template>  
  <div v-packery='{itemSelector: ".packery-item", percentPosition: true}'>
    <div>
      <div v-packery-item v-draggabilly class='packery-item'
        <img src="http://placehold.it/300x300"/>
      </div>
      <div v-packery-item v-draggabilly class="packery-item">
        <img src="http://placehold.it/300x300"/>
      </div>
    </div>
  </div>
</template>

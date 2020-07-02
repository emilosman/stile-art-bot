/* eslint no-console: 0 */

import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import VuePackeryPlugin from 'vue-packery-plugin'
import VueDraggabillyPlugin from 'vue-packery-draggabilly-plugin'


import editor from './components/editor'
import show from './components/show'

Vue.use(TurbolinksAdapter)
Vue.use(VuePackeryPlugin)
Vue.use(VueDraggabillyPlugin)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#app',
    components: {
      editor,
      show
    }
  })
})

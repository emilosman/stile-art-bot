/* eslint no-console: 0 */

import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import axios from 'axios'
import VuePackeryPlugin from 'vue-packery-plugin'
import VueDraggabillyPlugin from 'vue-packery-draggabilly-plugin'

import dropzone from './components/dropzone'
import packery from './components/packery'

Vue.use(TurbolinksAdapter)
Vue.use(VuePackeryPlugin)
Vue.use(VueDraggabillyPlugin)

document.addEventListener('turbolinks:load', () => {
  axios.defaults.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  const app = new Vue({
    el: '#app',
    components: {
      dropzone,
      packery
    }
  })
})

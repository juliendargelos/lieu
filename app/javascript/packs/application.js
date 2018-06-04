import Vue from 'vue/dist/vue.esm'

import AvatarView from './views/Avatar.vue'
import ReadingView from './views/Reading.vue'

document.addEventListener('DOMContentLoaded', () => {
  [
    AvatarView,
    ReadingView
  ].find(view => {
    var name = view.toString().slice(0, -4)
    var application = document.querySelector(`[data-vue="${name}"]`)

    if(application) {
      return new Vue({
        el: application,
        template: `<${name}/>`,
        components: {
          [name]: view
        }
      })
    }
  })
})

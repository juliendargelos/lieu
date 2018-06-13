import Vue from 'vue/dist/vue.esm'

import VueResourcePlugin from 'vue-resource/src'
import VueDraggablePlugin from 'vue-draggable'

Vue.use(VueResourcePlugin)
Vue.use(VueDraggablePlugin)

import TogglerMixin from './mixins/toggler'
import AuthenticityTokenMixin from './mixins/authenticity-token'

Vue.mixin(TogglerMixin)
Vue.mixin(AuthenticityTokenMixin)

import DraggableDirective from './directives/draggable'

Vue.directive('draggable', DraggableDirective)

import VRuntimeTemplate from 'v-runtime-template'

Vue.component('v-runtime-template', VRuntimeTemplate)

import AvatarView from './views/Avatar.vue'
import ReadingView from './views/Reading.vue'

window.addEventListener('load', () => {
  var data = document.getElementById('vue-data')

  if(data) {
    data = JSON.parse(data.textContent)

    Vue.mixin({
      data: function() {
        return data
      }
    })
  }

  var views = {
    Avatar: AvatarView,
    Reading: ReadingView
  }

  for(var view in views) {
    var application = document.querySelector(`[data-vue="${view}"]`)

    if(application) {
      return new Vue({
        el: application,
        template: `<${view}/>`,
        components: {
          [view]: views[view]
        }
      })
    }
  }
})

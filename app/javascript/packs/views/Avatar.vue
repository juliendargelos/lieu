<template>
  <main class="avatars-form">
    <transition name="translate-up">
      <p :key="property.title" class="avatars-form__title">{{property.title}}</p>
    </transition>
    <nav class="avatars-form__nav">
      <a
        v-for="(p, key, index) in properties"
        :class="`avatars-form__property ${property === p ? 'avatars-form__property--selected' : ''}`"
        @click.prevent="property = p"
        href="#"
      >{{index + 1}}. {{p.name}}</a>
    </nav>
    <div class="avatars-form__editor">
      <section class="avatars-form__section avatars-form__selector">
        <div class="avatars-form__selector-wrapper">
          <ul class="avatars-form__values">
            <li
              v-for="(value, key) in property.values"
              :class="[
                'avatars-form__value',
                `${avatar[property.key] === key ? 'avatars-form__value--selected' : ''}`
              ]"
              @click="avatar[property.key] = key"
            >
              <div class="avatar">
                <div
                  v-if="property.key !== 'face'"
                  :class="[
                    `avatar__${property.element}`,
                    `avatar__${property.element}--${value.modifier}`,
                    `avatars-form__${property.element}`,
                    `avatars-form__${property.element}--${value.modifier}`,
                  ]"
                ></div>
                  <v-runtime-template
                    v-if="['face', 'haircut'].includes(property.key)"
                    :template="faceTemplate({template: property.key === 'face' ? value.html : null, blank: true})"
                  ></v-runtime-template>
                </slot>
                <div
                  v-if="property.key === 'haircut'"
                  :class="[
                    `avatar__${property.element}-bangs`,
                    `avatar__${property.element}-bangs--${value.modifier}`,
                    `avatars-form__${property.element}-bangs`,
                    `avatars-form__${property.element}-bangs--${value.modifier}`,
                  ]"
                ></div>
              </div>
            </li>
          </ul>
        </div>
      </section>
      <section class="avatars-form__section avatars-form__preview">
        <div class="avatar avatars-form__avatar-preview">
          <div :class="`avatar__haircut avatar__haircut--${this.modifiers.haircut}`"></div>
          <v-runtime-template :template="faceTemplate()"></v-runtime-template>
          <div :class="`avatar__eyes avatar__eyes--${this.modifiers.eyes}`"></div>
          <div :class="`avatar__mouth avatar__mouth--${this.modifiers.mouth}`"></div>
          <div :class="`avatar__haircut bangs avatar__haircut-bangs--${this.modifiers.haircut}`"></div>
          <div :class="`avatar__accessory avatar__accessory--${this.modifiers.accessory}`"></div>
        </div>

        <form action="/avatar" method="post">
          <input name="authenticity_token" type="hidden" :value="authenticityToken">
          <input name="_method" type="hidden" :value="method">
          <input
            v-for="(property, key) in properties"
            :name="`avatar[${key}]`"
            :value="avatar[key]"
            type="hidden"
          >

          <transition name="fade-scale" mode="out-in">
            <input
              v-if="finished"
              type="submit"
              value="J'ai terminé !"
              class="button button--orange avatars-form__button"
            >
            <span
              v-else-if="avatar[property.key] && (this.choseAccessory || property.key !== 'accessory')"
              class="button button--orange avatars-form__button"
              @click="property = next"
            >Choisi {{next.name.toLowerCase()}}</span>
          </transition>
        </form>
      </section>
    </div>
  </main>
</template>

<script>
  export default {
    data: function () {
      return {
        choseAccessory: false,
        property: {}
      }
    },

    mounted: function() {
      this.property = this.properties[Object.keys(this.properties)[0]]
    },

    computed: {
      finished: function() {
        return !this.next
      },

      modifiers: function() {
        var modifiers = {}

        for(var key in this.properties) {
          modifiers[key] = (this.properties[key].values[this.avatar[key]] || {}).modifier || ''
        }

        return modifiers
      },

      next: function() {
        for(var key in this.properties) {
          if(!this.avatar[key] || (key === 'accessory' && !this.choseAccessory)) return this.properties[key]
        }

        return null
      }
    },

    watch: {
      property: function(property) {
        if(property.key === 'accessory' && !this.choseAccessory) {
          setTimeout(() => { this.choseAccessory = true }, 500)
        }
      }
    },

    methods: {
      faceTemplate: function({blank = false, template = null} = {}) {
        if(!template) template = (this.properties.face.values[this.avatar.face] || Object.values(this.properties.face.values)[0]).html
        if(blank) template = template.replace(/:class="`([^$]+)\$\{[^\}]+\}(.*)`"/g, 'class="$1$2"')

        return template
      }
    }
  }
</script>

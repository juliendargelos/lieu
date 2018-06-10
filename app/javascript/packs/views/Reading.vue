<template>
  <main class="container container--full-screen wrapper wrapper--small-padding wrapper--padding--both readings-show__container">
    <section class="readings-show__section readings-show__draw" :class="{'readings-show__draw--hidden': !chapter.instruction}">
      <transition name="fade-up">
        <div
          v-if="visible('challenge--small')"
          class="readings-show__challenge readings-show__challenge--small"
          :class="{'readings-show__challenge--bounce': bouncing}"
        >
          <p class="readings-show__challenge-instruction">{{chapter.instruction}}</p>
        </div>
      </transition>

      <transition name="fade-up-center">
        <div
          v-if="visible('challenge--big')"
          class="readings-show__challenge readings-show__challenge--big"
          :class="{'readings-show__challenge--bounce': bouncing}"
        >
          <p class="readings-show__challenge-instruction">{{chapter.instruction}}</p>
          <span
            class="button button--orange"
            @click="hide('challenge--big').show('challenge--small').sketch.enable()"
            @touchstart="hide('challenge--big').show('challenge--small').sketch.enable()"
          >
            Je suis prêt
          </span>
        </div>
      </transition>

      <span v-if="false" class="button button--orange" @click="next()" @touchstart="next()">TADAAAA&nbsp;!</span>

      <div class="dreamy-sketch">
        <canvas class="dreamy-sketch__canvas"></canvas>
      </div>
    </section>

    <section class="readings-show__section readings-show__chapter">
      <transition name="page" mode="out-in">
        <div class="readings-show__chapter-page readings-show__corner" :key="chapter.id">
          <div class="readings-show__chapter-container">
            <div class="readings-show__chapter-title">{{chapter.title}}</div>
            <p class="readings-show__chapter-content">{{chapter.content}}</p>
          </div>
          <p class="readings-show__chapter-next" @click="next()" @touchstart="next()"></p>
        </div>
      </transition>
    </section>
  </main>
</template>

<script>
  export default {
    mounted: function() {
      this.index = 0
      this.sketch = new Application.DreamySketch(document.querySelector('.dreamy-sketch'))
    },
    data: function() {
      return {
        bouncing: false,
        sketch: null,
        chapter: {},
      }
    },
    updated: function() {
      setTimeout(() => this.sketch.canvas.resize(), this.chapter.instruction ? 900 : 300)
    },
    watch: {
      chapter: function(chapter, previousChapter) {
        this.hide('challenge--big', 'challenge--small')
        this.sketch.disable()

        if(previousChapter.instruction && !this.sketch.blank) {
          this.$http.post('/draws', {
            authenticity_token: document.querySelector('meta[name="csrf-token"]').content,
            draw: {
              chapter_id: previousChapter.id,
              image: this.sketch.canvas.url
            }
          })
        }

        if(chapter.brush) this.sketch.brush = new Application.DreamySketch.Brush[this.chapter.brush]()
        if(chapter.instruction) this.show('challenge--big')

        setTimeout(() => {
          this.sketch.canvas.clear()
          if(chapter.draw.mine) this.hide('challenge--big').show('challenge--small')
        }, 600)

        if(chapter.draw.mine) setTimeout(() => {
          this.sketch.canvas.hide()
          this.sketch.canvas.load(chapter.draw.mine, () => this.sketch.canvas.show(300))
        }, 1000)
      }
    },
    computed: {
      index: {
        get: function() {
          return this.chapters.indexOf(this.chapter)
        },
        set: function(v) {
          this.chapter = this.chapters[v%this.chapters.length]
        }
      }
    },
    methods: {
      next: function() {
        if(!this.chapter.instruction || !this.sketch.canvas.blank) this.index++
        else this.bounce()
      },

      bounce: function() {
        this.bouncing = true
        setTimeout(() => { this.bouncing = false }, 400)
      }
    }
  }
</script>

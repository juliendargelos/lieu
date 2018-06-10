<template>
  <main class="container container--full-screen wrapper wrapper--small-padding wrapper--padding--both readings-show__wrapper">
    <div class="readings-show__container">
      <transition name="enter-right">
        <section
          v-if="chapter.draw.connected"
          class="readings-show__section readings-show__draw readings-show__draw--connected"
          :class="{
            'readings-show__draw--hidden': !showConnectedDraw,
            'readings-show__section--hidden': !showConnectedDraw
          }"
          :style="{backgroundImage: 'url(' + chapter.draw.connected + ')'}"
        >
          <p class="readings-show__draw-title">
            {{connected_user.pseudo}} t'a dessiné sa vision&nbsp;!
          </p>
          <div class="readings-show__draw-fold" @click="showConnectedDraw = !showConnectedDraw"></div>
        </section>
      </transition>

      <section
        class="readings-show__section readings-show__draw"
        :class="{
          'readings-show__draw--hidden': !chapter.instruction,
          'readings-show__section--hidden': !chapter.instruction
        }"
      >
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
            >
              Je suis prêt
            </span>
          </div>
        </transition>

        <span v-if="false" class="button button--orange" @click="next()">TADAAAA&nbsp;!</span>

        <div
          class="dreamy-sketch"
          :class="{'dreamy-sketch-hidden': hidden('dreamy-sketch')}"
          :style="{backgroundImage: drawImage ? 'url(' + drawImage + ')' : 'none'}"
        >
          <canvas class="dreamy-sketch__canvas"></canvas>
        </div>
      </section>

      <section
        class="readings-show__section readings-show__chapter"
        :class="{
          'readings-show__chapter--hidden': showConnectedDraw,
          'readings-show__section--hidden': showConnectedDraw
        }">
        <transition name="page" mode="out-in">
          <div class="readings-show__chapter-page readings-show__corner" :key="chapter.id">
            <div class="readings-show__chapter-wrapper">
              <div class="readings-show__chapter-container">
                <div class="readings-show__chapter-title">{{chapter.title}}</div>
                <p class="readings-show__chapter-content">{{chapter.content}}</p>
              </div>
            </div>
            <p class="readings-show__chapter-next" @click="next()"></p>
          </div>
        </transition>
      </section>
    </div>
    <div class="readings-show__timeline timeline">
      <div class="timeline__chapters">
        <div v-for="chapter in chapters" class="timeline__chapter"></div>
      </div>
    </div>
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
        showConnectedDraw: false,
        bouncing: false,
        sketch: null,
        lastChapterId: null,
        drawImage: null,
        chapter: {draw: {}},
      }
    },
    updated: function() {
      if(this.chapter.id !== this.lastChapterId) {
        this.lastChapterId = this.chapter.id

        if(this.chapter.instruction) {
          if(this.chapter.draw.mine) {
            var image = new Image()
            var src = this.chapter.draw.mine
            this.hide('dreamy-sketch')

            image.onload = () => {
              if(this.chapter.draw.mine === src) {
                this.drawImage = src
                this.show('dreamy-sketch')
              }
            };

            image.src = src
          }
          else {
            this.drawImage = null
            this.show('dreamy-sketch')
          }
        }

        setTimeout(() => this.sketch.canvas.resize(), this.chapter.instruction ? 800 : 300)
      }
    },
    watch: {
      chapter: function(chapter, previousChapter) {
        this.hide('challenge--big', 'challenge--small')
        this.sketch.disable()
        this.showConnectedDraw = false

        if(previousChapter.instruction && !this.chapter.draw.mine && !this.sketch.canvas.blank) {
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

<template>
  <main class="container container--full-screen wrapper wrapper--small-padding wrapper--padding--both readings-show__wrapper">
    <div class="readings-show__container">
      <transition name="enter-right">
        <section
          v-if="reading.connected_reading && chapter.draw.connected"
          class="readings-show__section readings-show__draw readings-show__draw--connected"
          :class="{
            'readings-show__draw--hidden': this.hidden('draw--connected'),
            'readings-show__section--hidden': this.hidden('draw--connected')
          }"
          :style="{backgroundImage: 'url(' + chapter.draw.connected + ')'}"
        >
          <p class="readings-show__draw-title">
            {{reading.connected_reading.user.pseudo}} t'a dessiné sa vision&nbsp;!
          </p>
          <div class="readings-show__draw-fold" @click="toggleConnectedDraw()"></div>
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
            :class="{'readings-show__challenge--bounce': this.bouncing('challenge')}"
          >
            <p class="readings-show__challenge-instruction">{{chapter.instruction}}</p>
          </div>
        </transition>

        <transition name="fade-up-center">
          <div
            v-if="visible('challenge--big')"
            class="readings-show__challenge readings-show__challenge--big"
            :class="{'readings-show__challenge--bounce': this.bouncing('challenge')}"
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

        <transition name="fade">
          <span
            v-if="!blank && !chapter.draw.mine"
            class="readings-show__draw-submit button button--orange"
            @click="submitDraw()"
            :class="{'readings-show__draw-submit--bounce': this.bouncing('draw-submit')}"
          >TADAAAA&nbsp;!</span>
        </transition>

        <div
          class="dreamy-sketch"
          :class="{'dreamy-sketch-hidden': hidden('dreamy-sketch')}"
          :style="{backgroundImage: 'url(' + (drawImage || 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAEElEQVR42gEFAPr/AAAAAAAABQABepInTwAAAABJRU5ErkJggg==') + ')'}"
        >
          <canvas class="dreamy-sketch__canvas"></canvas>
        </div>
      </section>

      <section
        class="readings-show__section readings-show__chapter"
        :class="{
          'readings-show__chapter--hidden': this.visible('draw--connected'),
          'readings-show__section--hidden': this.visible('draw--connected')
        }">
        <transition name="page" mode="out-in">
          <div class="readings-show__chapter-page readings-show__corner" :key="chapter.id">
            <div class="readings-show__chapter-wrapper">
              <div
                class="readings-show__chapter-container"
                @scroll="updateFinished()"
              >
                <div class="readings-show__chapter-title">{{chapter.title}}</div>
                <p class="readings-show__chapter-content">{{chapter.content}}</p>
              </div>
            </div>
            <div class="readings-show__chapter-next" @click="next()"></div>
            <transition name="fade-delay">
              <a
                v-if="index >= reading.chapters.length - 1 && finished"
                class="button button--orange readings-show__chapter-end"
                href="/books"
              >J'ai fini de lire&nbsp;!</a>
            </transition>
          </div>
        </transition>
      </section>
    </div>
    <div class="readings-show__timeline timeline">
      <div
        v-if="reading.connected_reading"
        :class="[
          'timeline__cursor',
          `timeline__cursor--${reading.connected_reading.user.avatar.sweater}`
        ]"
        :style="{left: connectedCursorPosition}"
        @click="goTo(connectedChapter)"
      >
        {{reading.connected_reading.user.initial}}
      </div>
      <div
        :class="[
          'timeline__cursor',
          `timeline__cursor--${reading.user.avatar.sweater}`
        ]"
        :style="{left: cursorPosition}"
      >
        {{reading.user.initial}}
      </div>
      <div class="timeline__chapters">
        <div
          v-for="chapter in reading.chapters"
          class="timeline__chapter"
          @click="goTo(chapter)"
          :class="{'timeline__chapter--disabled': chapter.position > current.position}"
        >
          <div
            v-if="chapter.instruction"
            class="timeline__draws"
            :class="{'timeline__draws--filled': chapter.draw.mine || chapter.draw.connected}"
          >
            <div
              class="timeline__draw"
              :class="{'timeline__draw--filled': chapter.draw.mine}"
            ></div>
            <div
              class="timeline__draw"
              :class="{'timeline__draw--filled': chapter.draw.connected}"
            ></div>
          </div>
        </div>
      </div>
    </div>
  </main>
</template>

<script>
  export default {
    mounted: function() {
      this.current = this.reading.chapters.find(chapter => chapter.id == this.reading.chapter_id)

      if(this.reading.connected_reading) {
        this.connectedChapter = this.reading.chapters.find(chapter => chapter.id == this.reading.connected_reading.chapter_id)
      }
      this.index = this.reading.finished ? 0 : this.reading.chapters.indexOf(this.current)
      this.sketch = new Application.DreamySketch(document.querySelector('.dreamy-sketch'))
      this.finished = this.reading.finished
    },
    data: function() {
      return {
        finished: false,
        sketch: null,
        lastChapterId: null,
        drawImage: null,
        connectedChapter: {draw: {}},
        chapter: {draw: {}},
        current: {draw: {}}
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

        setTimeout(() => this.sketch.canvas.resize(), 800)
      }
    },
    watch: {
      chapter: function(chapter) {
        this.hide('challenge--big', 'challenge--small')
        this.sketch.disable()
        this.hide('draw--connected')
        var finished = this.reading.chapters.indexOf(chapter) >= this.reading.chapters.length - 1 && !this.instruction

        if(chapter.position > this.current.position) {
          this.$http.patch('/readings/' + this.reading.id, {
            authenticity_token: this.authenticityToken,
            reading: {
              chapter_id: chapter.id,
              finished: finished
            }
          })

          this.current = chapter
        }

        if(chapter.instruction) {
          this.sketch.brush = new Application.DreamySketch.Brush[chapter.brush]()
          if(chapter.draw.mine) setTimeout(() => this.show('challenge--small'), 100)
          else this.show('challenge--big')
        }

        setTimeout(() => {
          this.sketch.canvas.clear()
          if(finished) this.updateFinished()
        }, 600)
      },
      blank: function(blank, previousBlank) {
        console.log(blank, previousBlank)
        this.updateFinished()
        if(!blank && previousBlank) setTimeout(() => this.bounce('draw-submit'), 1000)
      }
    },
    computed: {
      authenticityToken: function() {
        return document.querySelector('meta[name="csrf-token"]').content
      },

      index: {
        get: function() {
          return this.reading.chapters.indexOf(this.chapter)
        },
        set: function(v) {
          this.chapter = this.reading.chapters[Math.max(Math.min(this.reading.chapters.length - 1, v), 0)]
        }
      },

      blank: function() {
        return this.sketch ? this.sketch.canvas.blank : true
      },

      connectedIndex: function() {
        return this.reading.chapters.indexOf(this.connectedChapter)
      },

      cursorPosition: function() {
        var offset = 0
        if(this.chapter.instruction) offset = -28
        else if(this.chapter === this.connectedChapter) offset = -10
        return this.cursorPositionFor(this.index, offset)
      },

      connectedCursorPosition: function() {
        var offset = 0
        if(this.connectedChapter.instruction) offset = 28
        else if(this.chapter === this.connectedChapter) offset = 10
        return this.cursorPositionFor(this.connectedIndex, offset)
      }
    },
    methods: {
      next: function() {
        if(this.chapter.instruction && !this.chapter.draw.mine) this.bounce(this.blank ? 'challenge' : 'draw-submit')
        else this.index++
      },

      bounce: function(selector) {
        this.hide(selector + ':bouncing')
        setTimeout(() => { this.show(selector + ':bouncing') }, 400)
      },

      bouncing: function(selector) {
        return this.hidden(selector + ':bouncing')
      },

      goTo(chapter) {
        if(chapter.id !== this.chapter.id && chapter.position <= this.current.position) this.chapter = chapter
      },

      cursorPositionFor: function(index, offset = 0) {
        var length = this.reading.chapters.length
        var progress = index/length

        return `calc(${(progress + 0.5/length)*100}% + ${offset + 5*(progress - 0.5)}px)`
      },

      updateFinished: function() {
        var element = document.querySelector('.readings-show__chapter-container')

        if(
          !this.finished &&
          this.reading.chapters.indexOf(this.chapter) === this.reading.chapters.length - 1 &&
          (element.scrollHeight - element.offsetHeight <= 0 || element.scrollTop > 0) &&
          (!this.chapter.instruction || this.chapter.draw.mine)
        ) {
          this.finished = true
        }
      },

      submitDraw: function() {
        if(!this.blank) {
          var url = this.sketch.canvas.url
          this.chapter.draw.mine = url

          this.$http.post('/draws', {
            authenticity_token: this.authenticityToken,
            draw: {
              chapter_id: this.chapter.id,
              image: url
            }
          })

          if(this.index >= this.reading.chapters.length - 1) {
            this.finished = true
            this.$http.patch('/readings/' + this.reading.id, {
              authenticity_token: this.authenticityToken,
              reading: {finished: true}
            })
          }

          if(this.chapter.draw.connected) this.toggleConnectedDraw()
          else this.next()
        }
        else this.bounce('challenge')
      },

      toggleConnectedDraw: function() {
        if(this.chapter.draw.mine) this.toggle('draw--connected')
        else this.bounce(this.blank ? 'challenge' : 'draw-submit')
      }
    }
  }
</script>

export default {
  data: function() {
    return {
      hiddenSelectors: []
    }
  },

  methods: {
    hidden: function(...selectors) {
      return !!selectors.find(selector => this.hiddenSelectors.includes(selector))
    },

    visible: function(...selectors) {
      return !!selectors.find(selector => !this.hiddenSelectors.includes(selector))
    },

    hide: function(...selectors) {
      selectors.forEach(selector => {
        selector = '' + selector
        if(selector && !this.hiddenSelectors.includes(selector)) this.hiddenSelectors.push(selector)
      })

      return this
    },

    show: function(...selectors) {
      selectors.forEach(selector => {
        var index = this.hiddenSelectors.indexOf('' + selector)
        if(index !== -1) this.hiddenSelectors.splice(index, 1)
      })

      return this
    },

    toggle: function(...selectors) {
      if(this.hidden(...selectors)) this.show(...selectors)
      else this.hide(...selectors)

      return this
    }
  }
}

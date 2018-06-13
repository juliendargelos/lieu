export default {
  computed: {
    authenticityToken: function() {
      return document.querySelector('meta[name="csrf-token"]').content
    }
  }
}

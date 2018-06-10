Application.DreamySketch.Canvas = class Canvas extends Component {
  constructor(element) {
    super();

    this.element = element;
    this.context = this.element.getContext('2d');
    this.resizing = false;
    this.needsAResize = false;
    this.resizeListener = () => this.resize();
    this.autoResize = true;
    this.changed = false;
    this.blank = true;
  }

  get parent() {
    return this.element.parentNode;
  }

  get width() {
    return this.element.width;
  }

  set width(v) {
    this.element.width = v;
  }

  get height() {
    return this.element.height;
  }

  set height(v) {
    this.element.height = v;
  }

  get ratio() {
    return this.width/this.height
  }

  get autoResize() {
    return this._autoResize || false;
  }

  set autoResize(v) {
    v = !!v;

    if(v !== this.autoResize) {
      if(v) {
        window.addEventListener('resize', this.resizeListener, {passive: true});
        this.resize();
      }
      else window.removeEventListener('resize', this.resizeListener, {passive: true});
    }
  }

  get url() {
    if(!this._url || this.changed) {
      this._url = this.element.toDataURL();
      this.changed = false
    }

    return this._url
  }

  draw(image, changed) {
    var ratio = image.width/image.height
    var width, height, top, left

    if(this.ratio > ratio) {
      height = this.height
      width = ratio*height
      top = 0
      left = (this.width - width)/2
    }
    else {
      width = this.width
      height = width/ratio
      top = (this.height - height)/2
      left = 0
    }

    this.clear(changed)
    this.context.drawImage(image, left, top, width, height)
    this.blank = false
    if(changed !== false) this.changed = true
  }

  clear(changed) {
    this.context.clearRect(0, 0, this.width, this.height);
    if(changed !== false) {
      this.blank = true
      this.changed = false
      this._url = null
    }
  }

  load(url, callback) {
    var image = new Image()
    image.onload = () => {
      this.draw(image)
      if(typeof callback === 'function') callback.call(this)
    }
    image.src = url
  }

  transition(duration, callback) {
    this.element.style.transition = (duration/1000) + 's'
    setTimeout(() => callback.call(this), 1)
    setTimeout(() => this.element.style.transition = null, duration + 1)
  }

  show(duration = 0) {
    if(duration === 0) this.element.style.opacity = null
    else this.transition(duration, () => this.element.style.opacity = null)
  }

  hide(duration = 0) {
    if(duration === 0) this.element.style.opacity = 0
    else this.transition(duration, () => this.element.style.opacity = 0)
  }

  resize() {
    if(this.parent) {
      if(this.resizing) {
        this.needsAResize = true
        return false
      }

      this.resizing = true;

      if(this.url) {
        var image = new Image();
        image.onerror = () => {
          this.resizing = false;

          if(this.needsAResize) {
            this.needsAResize = false
            this.resize()
          }
        };

        image.onload = () => {
          if(!this.needsAResize) this.draw(image, false);
          image.onerror()
        };

        this.width = this.parent.offsetWidth;
        this.height = this.parent.offsetHeight;
        image.src = this.url;
      }
      else {
        this.width = this.parent.offsetWidth;
        this.height = this.parent.offsetHeight;
        this.resizing = false;
      }

      return true
    }

    return false
  }
}

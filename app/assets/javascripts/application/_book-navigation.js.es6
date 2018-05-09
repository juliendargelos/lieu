Application.BookNavigation = class BookNavigation extends Component {
  constructor(element) {
    super();

    this.element = element

  }

  static init() {
    super.init()
    return new this(document.querySelector('.book__next-chapter'))
  }
}

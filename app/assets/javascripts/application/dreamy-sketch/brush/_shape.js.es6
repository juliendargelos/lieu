Application.DreamySketch.Brush.Shape = class Shape extends Component {
  constructor() {
    super();

    this.color = new Application.DreamySketch.Color();
    this.filled = true;
    this.stroked = false;
    this.width = 1;
  }

  draw(canvas) {
    canvas.blank = false
    canvas.changed = true

    canvas.context.beginPath();
    this.path(canvas.context);
    canvas.context.closePath();

    if(this.stroked) this.stroke(canvas.context);
    if(this.filled) this.fill(canvas.context);
  }

  path(context) {

  }

  fill(context) {
    context.fillStyle = this.color.string;
    context.fill();
  }

  stroke(context) {
    context.strokeStyle = this.color.string;
    context.stroke();
  }
}

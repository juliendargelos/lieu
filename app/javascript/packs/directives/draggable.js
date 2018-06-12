export default {
  bind: function(el, binding) {
    var init = {x: 0, y: 0, center: {x: 0, y: 0}}
    var placeholder = binding.value.placeholder
    if(placeholder && typeof placeholder !== 'object') placeholder = {}
    var mousedown, mousemove, mouseup, touchstart, touchmove, touchend, movedEl

    var bounds = callback => callback(el.getBoundingClientRect())

    var compute = position => {
      var position = {
        x: position.x - init.x,
        y: position.y - init.y
      }

      position.center = {
        x: position.x + init.center.x,
        y: position.y + init.center.y
      }

      return position
    }

    var positionFromMouse = event => { return {x: event.clientX, y: event.clientY} }
    var positionFromTouch = event => { return {x: event.changedTouches[0].clientX, y: event.changedTouches[0].clientY} }

    var updatePosition = position => {
      movedEl.style.left = position.x + 'px'
      movedEl.style.top = position.y + 'px'
    }

    var dragstart = position => {
      var width, height

      bounds(bounds => {
        width = bounds.width
        height = bounds.height

        init.x = position.x - bounds.x
        init.y = position.y - bounds.y
        init.center.x = width/2
        init.center.y = height/2
      })

      position = compute(position)

      if(el.dispatchEvent(new CustomEvent('dragstart', {cancelable: true, detail: {position: position, element: movedEl}}))) {
        if(placeholder) {
          movedEl = el.cloneNode(true)
          movedEl.style.zIndex = 1000
          movedEl.style.width = width + 'px'
          movedEl.style.height = height + 'px'
          if(placeholder.className) movedEl.className = placeholder.className
          movedEl.removeEventListener('mousedown', mousedown)
          movedEl.removeEventListener('touchstart', touchstart)
        }
        else movedEl = el

        updatePosition(position)
        movedEl.style.transition = 'none'
        movedEl.style.position = 'fixed'
        if(placeholder) document.body.appendChild(movedEl)

        window.addEventListener('mousemove', mousemove)
        window.addEventListener('mouseup', mouseup)
        window.addEventListener('touchmove', touchmove)
        window.addEventListener('touchend', touchend)

        return true
      }

      return false
    }

    var dragmove = position => {
      position = compute(position)

      if(el.dispatchEvent(new CustomEvent('dragmove', {cancelable: true, detail: {position: position, element: movedEl}}))) updatePosition(position)
    }

    var dragend = position => {
      position = compute(position)

      if(el.dispatchEvent(new CustomEvent('dragend', {cancelable: true, detail: {position: position, element: movedEl}}))) {
        if(placeholder) {
          movedEl = el
          updatePosition(position)
          movedEl.style.position = 'fixed'
          movedEl.parentNode.removeChild(movedEl)
        }
        else updatePosition(position)
      }
      else {
        if(placeholder) movedEl.parentNode.removeChild(movedEl)
        else movedEl.style.transition = movedEl.style.position = movedEl.style.left = movedEl.style.right = null
      }

      window.removeEventListener('mousemove', mousemove)
      window.removeEventListener('mouseup', mouseup)
      window.removeEventListener('touchmove', touchmove)
      window.removeEventListener('touchend', touchend)
    }

    var mousedown = e => { if(dragstart(positionFromMouse(e))) e.preventDefault() }
    var mousemove = e => { if(dragmove(positionFromMouse(e))) e.preventDefault() }
    var mouseup = e => dragend(positionFromMouse(e))
    var touchstart = e => dragstart(positionFromTouch(e))
    var touchmove = e => dragmove(positionFromTouch(e))
    var touchend = e => dragend(positionFromTouch(e))

    el.addEventListener('mousedown', mousedown)
    el.addEventListener('touchstart', touchstart)
  }
}

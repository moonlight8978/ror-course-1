$(document).ready(() => {
  function setActiveOnEnter() {
    this.classList.add('active')
  }

  function removeActiveOnLeave() {
    this.classList.remove('active')
  }

  $('.post-list-item .vote')
    .mouseenter(setActiveOnEnter)
    .mouseleave(removeActiveOnLeave)
})

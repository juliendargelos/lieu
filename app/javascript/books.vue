<template>
  <main class="wrapper books-index__wrapper">
    {{message}}
    <div class="books-index__top">
      <h1 class="books-index__title">Choisis ton livre</h1>
    </div>
    <div class="books-index__content">
      <ul class="books-index__list">
        <% @books.each do |book| %>
        <li class="books-index__item book">
          <%= image_tag book.icon.url, class: :book__icon if book.icon.exists? %>
          <div class="book__header">
            <h2 class="book__title"><%= book.title %></h2>
            <p class="book__author"><%= book.author %></p>
          </div>
          <p class="book__summary"><%= book.summary %> chap.</p>
          <div class="book__chapters">
            <p>
              <span class="book__chapters__nb"><%= book.number_of_chapters %></span>
              <br>chap.
            </p>
          </div>
        </li>
        <% end %>
      </ul>
    </div>
  </main>
</template>

<script>
export default {
  data: function () {
    return {
      message: "Hello Books!"
    }
  }
}
</script>

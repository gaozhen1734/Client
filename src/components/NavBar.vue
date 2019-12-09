<template>
  <header class="header">
    <router-link to="/">Simple Blog</router-link>
    <div style="clear: both"/>
  </header>
</template>

<script>
export default {
  name: 'navbar'
}
</script>

<style scope>
.header {
  margin: 50px auto;
  text-align: center;
}

.header a {
  text-decoration: none;
  font-size: 20px;
  letter-spacing: 3px;
  text-transform: uppercase;
  color: #555;
}

.header .btn {
  float: right;
}

.btn a {
  font-size: 14px;
}
</style>

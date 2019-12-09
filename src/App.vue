<template>
  <div id="app">
    <navbar/>
    <router-view></router-view>
  </div>
</template>

<script>
import navbar from './components/NavBar.vue'

export default {
  name: 'app',
  components: {
    navbar
  }
}
</script>

<style>
  body {
    font-family: "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", Arial, sans-serif;
    font-size: 14px;
    line-height: 2;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    -webkit-text-size-adjust: none;

    position: relative;
    max-width: 700px;
    margin: 0 auto;
    padding: 0;
    background: #fff;
    color: #555;
  }

  h1, h2, h3, h4, h5, h6 {
    font-weight: 400;
    margin-top: 20px;
  }

  a {
    text-decoration: none;
    color: #08c;
    overflow-wrap: break-word;
    word-break: break-all;
  }
</style>


<template>
  <div>
    <section class="post-view">
    <div v-if="!content">Loading..</div>
    <h1>{{ title }}</h1>
    <article
      v-if="content"
      v-html="htmlFromMarkdown"/>
    </section>
    <comment v-bind:id="id"/>
    <div class="footer"></div>
  </div>
</template>

<script>
import marked from 'marked'
import Prism from 'prismjs'
import fm from 'front-matter'

import { GetArticleById } from '../vue-api-client.js'

import comment from './Comment.vue'

const renderer = new marked.Renderer()

renderer.heading = (text, level) => {
  const slug = text.replace(/<(?:.|\n)*?>/gm, '').toLowerCase().replace(/[\s\n\t]+/g, '-')
  return `<h${level} id="${slug}">${text}</h${level}>`
}

renderer.code = (code, lang) => {
  if (lang === 'c' || lang === 'cpp') lang = 'clike'
  const highlight = Prism.highlight(code, Prism.languages[lang] || Prism.languages.javascript)
  return `<pre class="code-block"><code class="lang-${escape(lang, true)}">${highlight}</code></pre>`
}

marked.setOptions({
  renderer,
  breaks: true,
  gfm: true
})

export default {
  name: 'PostPage',
  props: ['id'],
  components: { comment },
  data () {
    return {
      title: '',
      content: ''
    }
  },

  computed: {
    htmlFromMarkdown () {
      return marked(this.content)
    }
  },

  created () {
    this.loadPost()
  },

  methods: {
    loadPost () {
      let me = this      
      GetArticleById({
        id: me.id
      })
      .then(function (res) {
        console.log(res.data);
        me.title = res.data.name
        me.content = res.data.content
        
        // let article = res.data.content
        // const content = fm(article.content)
        // console.log(content);
        // me.content = content.body
        // me.title = content.attributes.title
      })
      .catch(function (error) {
        if (error.response) {
          me.content = error.response.data.error
        }
      })
    }
  }
}
</script>

<style>
@import "../assets/prism.css";

.code-block {
  background-color: #f5f2f0;
  padding: 10px;
}

.footer {
  height: 40px;
}
</style>

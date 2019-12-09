<template>
  <div>
    <hr>
    <h2>Comments</h2>
    <div class="comment-list">
      <section class="list-view">
        <div
          v-if="loading"
          class="loading">loading...</div>
        <div
          v-else-if="commentsList.length === 0"
          class="no-content">nothing...</div>
        <ol
          v-else
          class="list">
          <li
            v-for="{ content, author, id } in commentsList"
            :key="id"
            class="list-item">
            <p class="content">{{ content }}</p>
            <p class="author">{{ author }}</p>
          </li>
        </ol>
      </section>
    </div>
    <b-form class="comment-form" @submit="onSubmit" @reset="onReset" v-if="show">
      <b-form-textarea v-model="text"
                       placeholder="Say something..."
                       :rows="3"
                       :max-rows="6">
      </b-form-textarea>
      <div class="btns">
        <b-button type="reset" variant="outline-danger">Reset</b-button>
        <b-button type="submit" variant="outline-primary">Submit</b-button>
      </div>   
    </b-form>
    <div class="signin-tip" v-else>
      If you want to say something, please
      <router-link to="/signin">sign in</router-link>
      first!
    </div>
  </div>
</template>

<script>
import { GetCommentsOfArticle, CreateComment } from '../vue-api-client.js'

function getCookie (cname) {
  let name = cname + '='
  let ca = document.cookie.split(';')
  for (let i = 0; i < ca.length; i++) {
    let c = ca[i]
    while (c.charAt(0) === ' ') c = c.substring(1)
    if (c.indexOf(name) != -1) return c.substring(name.length, c.length)
  }
  return ""
}

export default {
  name: 'comment',
  props: ['id'],
  data () {
    return {
      loading: false,
      show: false,
      text: '',
      commentsList: []
    }
  },
  created () {
    this.loadCommentsList()
    /* show comment form if user has token */
    if (getCookie('token') !== '') this.show = true
  },
  methods: {
    loadCommentsList () {
      let me = this
      GetCommentsOfArticle({
        id: me.id
      })
      .then(function (res) {
        if (res.data.content === null) {
          me.commentsList = []
          return
        }
        me.commentsList = res.data.content
      })
      .catch(function (error) {
        if (error.response) {
          me.content = error.response.data.error
        }
      })
    },
    onSubmit (evt) {
      evt.preventDefault()
      let me = this
      let username = getCookie('username')
      let token = getCookie('token')
      
      /* Submit comment */
      CreateComment({
        $config: {
          headers: {
            'Authorization': token
          }
        },
        id: me.id,
        body: {
          content: me.text,
          author: username
        }
      })
      .then(function (res) {
        me.loadCommentsList()
        me.text = ''
      })
      .catch(function (err) {
        console.log(err);
        
      })
    },
    onReset (evt) {
      evt.preventDefault()
      this.text = ''
    }
  }
}
</script>

<style scoped>
.list-view ol, ul {
  padding: 0;
  list-style: none;
}

.list-item {
  position: relative;
  margin-bottom: 10px;
  border-bottom: 1px solid #ddd;
}

.content {
  font-size: 16px;
  font-weight: 600;
}

.author {
  text-align: right;
}

.btns {
  margin-top: 10px;
  text-align: right;
}

.signin-tip {
  font-size: 16px;
  text-align: right;
}

.comment-form {
  font-size: 14px;
  margin-top: 10px;
}
</style>

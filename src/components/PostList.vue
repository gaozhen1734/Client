<template>
  <div class="post-list">
    <section class="list-view">
      <div
        v-if="loading"
        class="loading">loading...</div>
      <div
        v-else-if="postsList.length === 0"
        class="no-content">nothing...</div>
      <ol
        v-else
        class="list">
        <li
          v-for="{ name, id } in postsList"
          :key="id"
          class="list-item">
          <router-link 
            :to="'/post/' + id"
            class="item-title">
            {{ name }}
          </router-link>
        </li>
      </ol>
    </section>
    <!--<b-pagination align="center" :total-rows="100" v-model="currentPage" :per-page="10">
    </b-pagination>-->
    <nav aria-label="Page navigation example">
      <ul class="pagination justify-content-center">
        <li class="page-item">
          <a class="page-link" href="#" aria-label="Previous" @click="switchToPage(1)">
            <span aria-hidden="true">First Page</span>
            <span class="sr-only">Previous</span>
          </a>
        </li>

        <li class="page-item">
          <a class="page-link" href="#" aria-label="Previous" @click="switchToPage(currentPage - 1)">
            <span aria-hidden="true">&laquo;</span>
            <span class="sr-only">Previous</span>
          </a>
        </li>

        <li class="page-item" v-for="n in totalPages" v-if='n >= clowLimit && n <= chiLimit' :class="{active:n==currentPage}" :key="n">
          <a v-if='n == clowLimit && n > 1' href="#" class="page-link">...</a>
          <a v-else-if='n == chiLimit && n < totalPages' href="#" class="page-link">...</a>
          <a v-else href="#" @click="switchToPage(n)" class="page-link">{{n}}</a>
        </li>

        <li class="page-item">
          <a class="page-link" href="#" aria-label="Next" @click="switchToPage(currentPage + 1)">
            <span aria-hidden="true">&raquo;</span>
            <span class="sr-only">Next</span>
          </a>
        </li>

        <li class="page-item">
          <a class="page-link" href="#" aria-label="Previous" @click="switchToPage(totalPages)">
            <span aria-hidden="true">Last Page</span>
            <span class="sr-only">Previous</span>
          </a>
        </li>
      </ul>
    </nav>
  </div>
  
</template>

<script>
import {GetArticles} from '../vue-api-client.js'

export default {
  name: 'PostList',
  data() {
    return {
      currentPage: 1,
      lowLimit: 1,
      hiLimit: 8,
      listSize: 4,
      totalArticles: 100,
      totalPages: 0,
      postsList: [],
      loading: false
    }
  },
  methods:{
    switchToPage:function(pageNo) {
      if (pageNo <= 0 || pageNo > this.totalPages){
        return;
      }
      this.currentPage = pageNo
      let me = this
      GetArticles({
        page: me.currentPage
      })
      .then(function(res){
        me.postsList = res.data.articles
      })
      .catch(function(err) {
        me.postsList = []
      })
    }
  },
  computed: {
    clowLimit: function() {
      if(this.currentPage < this.lowLimit) {
        this.lowLimit = this.currentPage;
      }
      else if(this.currentPage - this.lowLimit > 7) {
        this.lowLimit = this.currentPage - 7;
      }
      else if(this.currentPage == this.lowLimit && this.lowLimit > 1) {
        this.lowLimit = this.currentPage - 1;
        this.hiLimit = this.hiLimit - 1;
      }
      return this.lowLimit;
    },
    chiLimit: function() {
      if(this.currentPage > this.hiLimit) {
        this.hiLimit = this.currentPage;
      }
      else if(this.hiLimit - this.currentPage > 7) {
        this.hiLimit = this.currentPage + 7;
      }
      else if(this.currentPage == this.hiLimit && this.hiLimit < this.totalPages) {
        this.hiLimit = this.currentPage + 1;
        this.lowLimit = this.lowLimit + 1;
      }
      return this.hiLimit;
    }
  },
  created: function() {
    this.totalPages = Math.ceil(this.totalArticles / this.listSize)
    let me = this
    GetArticles({
      page: 1
    })
    .then(function(res){
      me.postsList = res.data.articles
    })
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
  margin-bottom: 50px;
  border-bottom: 1px solid #ddd;
}

.item-title {
  display: inline-block;
  margin-bottom: 10px;
  font-size: 16px;
  color: #555;
}

.item-title:hover {
  color: #08c;
}

</style>



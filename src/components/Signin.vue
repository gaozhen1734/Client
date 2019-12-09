<template>
  <div>
    <b-alert :show="dismissCountDown"
             dismissible
             variant="success"
             @dismiss-count-down="countDownChanged">
      <h4 class="alert-heading">Sign in successfully!</h4>
      <hr>
      Auto jump to home page in {{ dismissCountDown }} seconds...
    </b-alert>
    <b-alert variant="danger"
             dismissible
             :show="showErrorAlert"
             @dismissed="showErrorAlert=false">
      {{ errorMessage }}
    </b-alert>
    <b-form @submit="onSubmit" @reset="onReset">
      <b-form-group id="usernameGroup"
                    label="Your Name:"
                    label-for="username">
        <b-form-input id="username"
                      type="text"
                      v-model="form.name"
                      required
                      placeholder="Enter name">
        </b-form-input>
      </b-form-group>
      <b-form-group id="passwordGroup"
                    label="Your Password:"
                    label-for="password">
        <b-form-input id="password"
                      type="password"
                      v-model="form.password"
                      required
                      placeholder="Enter password">
        </b-form-input>
      </b-form-group>
      <div class="signup-tip">
        You have not registered yet?
        <router-link to="/signup">
          Sign up
        </router-link>
        now.
      </div>
      <b-button-group class="my-btn-group">
        <b-button class="my-btn" type="reset" variant="outline-danger">Reset</b-button>
        <b-button class="my-btn" type="submit" variant="outline-primary">Signin</b-button> 
      </b-button-group>      
    </b-form>
  </div>
</template>

<script>
import { SignIn } from '../vue-api-client.js'
import axios from 'axios'

export default {
  name: 'signin',
  data () {
    return {
      form: {
        name: '',
        password: ''
      },
      errorMessage: '',
      showErrorAlert: false,
      dismissSecs: 3,
      dismissCountDown: 0
    }
  },
  methods: {
    onSubmit (evt) {
      evt.preventDefault()
      let me = this
      // axios({
      //   method: 'post',
      //   url: '/auth/signin',
      //   baseURL: 'http://localhost:8080/v3/',
      //   data: {
      //     body: {
      //       username: me.form.name,
      //       password: me.form.password
      //     }
      //   }
      // })
      SignIn({
        body: {
          username: me.form.name,
          password: me.form.password
        }
      })
      .then(function (res) {
        document.cookie = 'username=' + me.form.name
        document.cookie = 'token=' + res.data.token
        me.showErrorAlert = false
        me.dismissCountDown = me.dismissSecs
      })
      .catch(function (error) {
        if (error.response) {
          me.errorMessage = error.response.data.error
          me.showErrorAlert = true
        }
        console.log(error);
        
      })
    },
    onReset (evt) {
      evt.preventDefault()
      this.form.name = ''
      this.form.password = ''
      /* Trick to reset/clear native browser form validation state */
      this.show = false
      this.$nextTick(() => { this.show = true })
    },
    countDownChanged (dismissCountDown) {
      this.dismissCountDown = dismissCountDown
      if (this.dismissCountDown === 0) {
        this.$router.push('/')
      }
    }
  }
}
</script>

<style>
.signup-tip {
  text-align: right;
}

.my-btn-group {
  margin-top: 10px;
  width: 100%;
}

.my-btn {
  width: 50%;
}
</style>

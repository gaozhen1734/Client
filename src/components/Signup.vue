<template>
  <div>
    <b-alert :show="dismissCountDown"
             dismissible
             variant="success"
             @dismiss-count-down="countDownChanged">
      <h4 class="alert-heading">Sign up successfully!</h4>
      <hr>
      Auto jump to signin page in {{ dismissCountDown }} seconds...
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
      <div class="signin-tip">
        You have got an account?
        <router-link to="/signin">
          Sign in
        </router-link>
        now.
      </div>
      <b-button-group class="my-btn-group">
        <b-button class="my-btn" type="reset" variant="outline-danger">Reset</b-button>
        <b-button class="my-btn" type="submit" variant="outline-primary">Signup</b-button> 
      </b-button-group>
    </b-form>
    
  </div>
</template>

<script>
import { SignUp } from '../vue-api-client.js'

export default {
  name: 'signup',
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
      SignUp({
        body: {
          username: me.form.name,
          password: me.form.password
        }
      })
      .then(function (res) {
        me.showErrorAlert = false
        me.dismissCountDown = me.dismissSecs
      })
      .catch(function (error) {
        if (error.response) {
          me.errorMessage = error.response.data.error
          me.showErrorAlert = true
        }
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
        this.$router.push('/signin')
      }
    }
  }
}
</script>

<style>
.signin-tip {
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

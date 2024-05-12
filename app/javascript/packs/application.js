// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//= require turbolinks
//= require jquery
//= require jquery_ujs
//= require_tree .

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "jquery"
import "popper.js";
import "bootstrap";
import "../stylesheets/application";
import Swiper from 'swiper/swiper-bundle.js';
import 'swiper/swiper-bundle.css';
import 'swiper.js'
import 'posts.js'

Rails.start()
Turbolinks.start()
ActiveStorage.start()

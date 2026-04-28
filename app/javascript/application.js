import "./jquery"
import "@nathanvda/cocoon"

import Rails from "@rails/ujs"
import "@hotwired/turbo-rails"
import * as ActiveStorage from "@rails/activestorage"
import "./channels"

Rails.start()
ActiveStorage.start()

import "@popperjs/core"
import "bootstrap"
import { Tooltip, Popover } from "bootstrap"

document.addEventListener("turbo:load", () => {
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    tooltipTriggerList.map(function(tooltipTriggerEl) {
        return new Tooltip(tooltipTriggerEl)
    })

    var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'))
    popoverTriggerList.map(function(popoverTriggerEl) {
        return new Popover(popoverTriggerEl)
    })
})

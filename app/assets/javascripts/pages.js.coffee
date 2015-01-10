# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
	$('#filter-post-play').click ->
		$('.option.filter').attr('id','filter-post-play')
		$('.option.filter > .text').text("PLAY")
	$('#filter-post-work').click ->
		$('.option.filter').attr('id','filter-post-work')
		$('.option.filter > .text').text("WORK")
	$('#filter-post-facility').click ->
		$('.option.filter').attr('id','filter-post-facility')
		$('.option.filter > .text').text("FACILITY")
	$('#filter-post-doit').click ->
		$('.option.filter').attr('id','filter-post-doit')
		$('.option.filter > .text').text("DOIT")

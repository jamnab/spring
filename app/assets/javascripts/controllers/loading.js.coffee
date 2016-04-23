$ ->
	loading = "<div class='loading-wrapper'><div class='loading-container'><div class='loading'></div><div id='loading-text'>Loading</div></div></div>"
	$("#new_comment").submit ->
		target = ".modal-content"
		$(target).append(loading)
	$(".post-loading").click ->
		id = $(this).attr("id")
		# target = ".post.".concat(id);
		target = "body"
		$(target).append(loading)
	$(".comment-loading").click ->
		id = $(this).attr("id")
		target = ".modal-content.".concat(id);
		$(target).append(loading)
	$("#new_post").submit ->
		target = "body"
		$(target).append(loading)
	$(".body-loading").click ->
		target = "body"
		$(target).append(loading)

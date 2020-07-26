

#' Selectize mod with default placeholder value 
#'
#' @param id 
#' @param title 
#' @param choices 
#' @param placeholder 
#'
#' @return
#' @export
#'
#' @examples
selectize_mod <- function(id, title, choices, placeholder) {
  selectizeInput(id, title,
                 choices = choices,
                 options = list(
                   placeholder = placeholder,
                   onInitialize = I('function() { this.setValue(""); }')
                 )
                )
}

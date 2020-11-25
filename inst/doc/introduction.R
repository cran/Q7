## ---- include =FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  errors = TRUE
)

## ----setup, include=FALSE-----------------------------------------------------
library(Q7)

## -----------------------------------------------------------------------------
TypeOne <- type(function(arg1, arg2){
  var1 <- 3
  add <- function(){
    arg1 + arg2 + var1
  }
})

## -----------------------------------------------------------------------------
type_one <- TypeOne(1, 2)
ls(type_one)
# There's no `arg1` or `arg2` seen
type_one$add()
# yet `add()` can see both arguments

## -----------------------------------------------------------------------------
type_one %>% implement({
  substract <- function(){
    arg1 - arg2
  }
})

## -----------------------------------------------------------------------------
TypeTwo <- type(function(){
  n <- 10
})

## -----------------------------------------------------------------------------
hasFeatureOne <- feature({
  x <- 1
  x_plus_n <- function(){
    x + n
  }
})

## -----------------------------------------------------------------------------
hasFeatureTwo <- feature({
  n <- 100 # Overwrites n from TypeTwo
  x <- 10 # Overwrites x from hasFeatureOne
  private[x_plus_n.old] <- x_plus_n 
    # Rename to preserve the old x_plus_n()
    # Mark private, because it is only going to be used by the new x_plus_n()
  x_plus_n <- function(){
    cat(sprintf("adding x (%i) to n (%i)...\n", x, n)) # do some extra thing
    x_plus_n.old() # call the old function
  }
})

## -----------------------------------------------------------------------------
type_two_with_features <- TypeTwo() %>% 
  hasFeatureOne() %>% 
  hasFeatureTwo()

type_two_with_features$x_plus_n()

## -----------------------------------------------------------------------------
Counter <- type(function(){
  private[count] <- 0
  
  add_one <- function(){
    count <<- count + 1 
    # Your IDE's syntax checker may alert you that 
    # `count` is not found in scope. 
    # You can safely ignore this.
  }
  
  get_count <- function(){
    count
  }
})

## -----------------------------------------------------------------------------
counter <- Counter()
ls(counter) # `count` can't be seen from the out side

counter$get_count() # but count can be read by domestic function
counter$add_one() # ... and be written to
counter$add_one()
counter$get_count() # when we read it again the number changes

## -----------------------------------------------------------------------------
exposePrivate <- feature({
  .my$pvt_env <- .private$.private  # `.private` contains a reference of itself with the same name, assigns it to `.my`
  #pvt_env <- .private # also works
})

counter %>% exposePrivate()
# .private reference appears in the object
ls(counter, all.names = TRUE)
counter$.private
counter$pvt_env$count # It is now possible to directly access any variable in the private environment


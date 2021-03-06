% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{list2inst}
\alias{list2inst}
\title{Build a Q7 Object Instance from a List}
\usage{
list2inst(x, s3 = "default", parent = parent.frame(), ...)
}
\arguments{
\item{x}{list}

\item{s3}{S3 class name of the instance}

\item{parent}{parent environment of the instance}

\item{...}{dot-dot-dot}
}
\value{
Q7 object instance
}
\description{
Build a Q7 Object Instance from a List
}
\examples{
my_data <- list(a = 1,
                add_to_a = function(value){
                  .my$a <- a + value
                })

myDataObject <- list2inst(my_data)

myDataObject$a
myDataObject$add_to_a(20)
myDataObject$a

}

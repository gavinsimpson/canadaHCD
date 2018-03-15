##' @importFrom rappdirs user_cache_dir
##' @importFrom storr storr_rds
hcd_cache <- function(op = c("check", "get", "set"), key, data) {
  st <- storr_rds(user_cache_dir("canadaHCD"))
  op <- match.arg(op)
  switch(op,
         check = st$exists(key),
         get = st$get(key),
         set = st$set(key, data))
}

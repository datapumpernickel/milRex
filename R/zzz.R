
.onLoad <- function(libname, pkgname) {
  max_size_env <- Sys.getenv("MILREX_CACHE_MAX_SIZE")
  max_age_env <- Sys.getenv("MILREX_CACHE_MAX_AGE")
  max_n_env <- Sys.getenv("MILREX_CACHE_MAX_N")

  max_size <- ifelse(nzchar(max_size_env), eval(parse(text = max_size_env)),
                     1024 * 1024^2)
  max_age <- ifelse(nzchar(max_age_env), eval(parse(text = max_age_env)), Inf)
  max_n <- ifelse(nzchar(max_n_env), eval(parse(text = max_n_env)), Inf)

  cache <- cachem::cache_disk(dir = tools::R_user_dir('milRex',
                                                      which = 'cache'),
                              max_size = max_size,
                              max_age = max_age,
                              max_n = max_n)

  sipri_perform_request_cached <- memoise::memoise(sipri_perform_request,
                                               cache = cache)

  assign(x = "sipri_perform_request_cached",
         value = sipri_perform_request_cached,
         envir = rlang::ns_env("milRex"))

  sipri_process_response_cached <- memoise::memoise(sipri_process_response,
                                                cache = cache)

  assign(x = "sipri_process_response_cached",
         value = sipri_process_response_cached,
         envir = rlang::ns_env("milRex"))

  assign(x = "cache",
         value = cache,
         envir = rlang::ns_env("milRex"))
}

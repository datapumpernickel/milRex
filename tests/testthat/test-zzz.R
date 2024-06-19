if(length(list.files(tools::R_user_dir('milRex', which = 'cache')))==0){
  fs::dir_delete(tools::R_user_dir('milRex', which = 'cache'))
}

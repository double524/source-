

rule(/#{PROJECT_TEST_DEPENDENCIES_PATH}\/#{'.+\\'+EXTENSION_DEPENDENCIES}$/ => [
    proc do |task_name|
      @ceedling[:file_finder].find_compilation_input_file(task_name)
    end  
  ]) do |dep|
  @ceedling[:generator].generate_dependencies_file(
  	TOOLS_TEST_DEPENDENCIES_GENERATOR,
    TEST_CONTEXT,
  	dep.source,
  	@ceedling[:file_path_utils].form_test_build_object_filepath(dep.source),
  	dep.name)
end


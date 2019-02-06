find_program(VSTS NAMES vsts.bat)

set(UNIVERSAL_PACKAGE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/packages")

function(universal_package_parse_json str version_variable)
  string(REGEX REPLACE ".*\"Version\"[ ]*:[ ]*\"(.*)\".*" "\\1" version ${str})
  set(${version_variable} ${version} PARENT_SCOPE)
endfunction()

function(download_universal_package url feed name version)
  set(cache_file "${UNIVERSAL_PACKAGE_DIR}/${name}.json")
  set(target_dir "${UNIVERSAL_PACKAGE_DIR}/${name}")
  if(EXISTS ${cache_file})
    file(READ ${cache_file} c)
    universal_package_parse_json(${c} cached_version)
    if(cached_version)
      message(STATUS "Universal Package: ${name} ${cached_version} found.")
      if (${version} VERSION_EQUAL ${cached_version})
        message(STATUS "Universal Package: Skip downloading.")
        return()
      endif()
    endif()
  endif()

  if(EXISTS ${target_dir})
    message(STATUS "Universal Package: remove ${target_dir}")
    file(REMOVE_RECURSE ${target_dir})
  endif()
  message(STATUS "Universal Package: ${name} ${version} downloading.")

  execute_process(COMMAND "${VSTS}" package universal download
    --instance "${url}"
    --feed "${feed}"
    --name "${name}"
    --version "${version}"
    --path "${target_dir}"
    RESULT_VARIABLE rv
    OUTPUT_VARIABLE o
  )
  if(${rv})
    message(${rv})
    return()
  endif()
  universal_package_parse_json(${o} downloaded_version)
  message(STATUS "Universal Package: ${name} ${downloaded_version} downloaded.")
  file(WRITE ${cache_file} ${o})
endfunction()

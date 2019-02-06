find_program(VSTS NAMES vsts.bat)
set(UNIVERSAL_PACKAGE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/packages")
function(download_universal_package url feed name version)
  execute_process(COMMAND "${VSTS}" package universal download
    --instance "${url}"
    --feed "${feed}"
    --name "${name}"
    --version "${version}"
    --path "${UNIVERSAL_PACKAGE_DIR}/${name}"
    RESULT_VARIABLE rv
  )
endfunction()
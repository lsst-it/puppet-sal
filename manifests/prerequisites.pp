# Install and setup any prerequisites for ths SAL software
#
# @summary Install SAL prerequisites
#
# @example
#   include sal::prerequisites
class sal::prerequisites (
  Hash $pip_packages,
  Array[String[1], 1] $pkg_list,
) {

  ensure_packages( $pkg_list, {'ensure' => 'present'} )

  ensure_resources('package', $pip_packages, {'provider' => 'pip3', })

}

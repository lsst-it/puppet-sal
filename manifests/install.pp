# Install the LSST SAL software
#
# @summary Install the LSST SAL software
#
# @example
#   include sal::install
class sal::install (
  String              $environment_file,
  Array[String[1], 1] $csc_packages,
  String              $csc_version,
  Array[String[1], 1] $openslice_packages,
  String              $openslice_version,
  String              $yumrepo_baseurl,
) {

  ## SETUP SAL YUM REPO
  yumrepo { 'lsst-ts':
    ensure   => present,
    baseurl  => $yumrepo_baseurl,
    descr    => 'LSST Telescope and Site packages',
    enabled  => 1,
    gpgcheck => 0,
  }

  Package {
    require => [
      Yumrepo['lsst-ts'],
      Exec['uninstall old SAL packages'],
    ],
  }  

  ## IF CHANGING VERSION OF CURRENTLY INSTALLED WE NEED TO FIRST UNINSTALL
  exec { 'uninstall old SAL packages':
    onlyif  => "yum list installed | grep @lsst-ts",
    unless  => "yum list installed | grep @lsst-ts | grep '$openslice_version' && yum list installed | grep @lsst-ts | grep '$csc_version'",
    path    => '/bin/:/sbin/:/usr/bin/:/usr/sbin/',
    cwd     => '/',
    command => 'yum -y remove `yum list installed | grep @lsst-ts | awk \'{ print \$1 }\'`',
    require => [
      Yumrepo['lsst-ts'],
    ],
  }

  ## INSTALL OPENSPLICE PACKAGES
  ensure_packages( $openslice_packages, {'ensure' => $openslice_version} )

  ## INSTALL SAL CSC PACKAGES
  ensure_packages( $csc_packages, {'ensure' => $csc_version} )

  ## GET THE SAL ENVIRONMENT SETUP
  # Ensure parents of $environment_file exist, if needed (excluding / )
  $dirparts = reject( split( "${environment_file}", '/' ), '^$' )
  $numparts = size( $dirparts )
  if ( $numparts > 1 ) {
    each( Integer[2,$numparts] ) |$i| {
      ensure_resource(
        'file',
        reduce( Integer[2,$i], $environment_file) |$memo, $val| { dirname( $memo ) },
        { 'ensure' => 'directory' }
      )
    }
  }
  file { $environment_file:
    source => "puppet:///modules/${module_name}/opt/lsst/setup_SAL.env",
    mode => '644',
  }

}

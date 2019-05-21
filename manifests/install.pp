# Install the LSST SAL software
#
# @summary Install the LSST SAL software
#
# @example
#   include sal::install
class sal::install (
    String   $environment_baseurl,
    String   $environment_file,
    String   $package,
    String   $version,
    String   $yumrepo_baseurl,
) {

  ## SETUP SAL YUM REPO
  yumrepo { 'lsst-ts-sal':
    ensure   => present,
    baseurl  => $yumrepo_baseurl,
    descr    => 'LSST TS-SAL',
    enabled  => 1,
    gpgcheck => 0,
  }
  
  ## INSTALL SAL/OPENSPLICE PACKAGE
  package { $package:
    ensure => $version,
    require => [
      Yumrepo['lsst-ts-sal'],
    ],
  }

  ## GET THE SAL ENVIRONMENT SETUP
  # Ensure parents of $environment_file exist, if needed (excluding / )
  $dirparts = reject( split( "${environment_file}", '/' ), '^$' )
  $numparts = size( $dirparts )
  if ( $numparts > 1 ) {
    each( Integer[2,$numparts] ) |$i| {
      ensure_resource(
        'file',
        reduce( Integer[2,$i], $name ) |$memo, $val| { dirname( $memo ) },
        { 'ensure' => 'directory' }
      )
    }
  }
  file { $environment_file:
    source => $environment_baseurl,
  }

}

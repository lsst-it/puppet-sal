# Install and setup any prerequisites for ths SAL software
#
# @summary Install SAL prerequisites
#
# @example
#   include sal::prerequisites
class sal::prerequisites (
  Array[String[1], 1] $pkg_list,
  String              $fitsio_tar_url,
) {

  ensure_packages( $pkg_list, {'ensure' => 'present'} )

  $fits_tarball = basename($fitsio_tar_url)
  $fits_name = regsubst(basename($fitsio_tar_url, '.tar.gz'), '[A-Za-z]', '\\1')
  exec { "download_fitsio":
    path    => '/bin/:/sbin/:/usr/bin/:/usr/sbin/',
    creates => "/root/fitsio-$fits_name",
    cwd     => '/root',
    command => "wget -O $fits_tarball $fitsio_tar_url  &&  tar xfz $fits_tarball  &&  rm -f $fits_tarball",
    require => [
      Package['wget'],
    ],
    notify => [
      Exec['uninstall_old_fitsio'],
      Exec['install_fitsio'],
    ]
  }
  exec { "uninstall_old_fitsio":
    refreshonly => true,
    path    => '/bin/:/sbin/:/usr/bin/:/usr/sbin/',
    onlyif  => 'pip list | grep fitsio',
    command => 'pip uninstall -y fitsio',
    require => [
      Exec['download_fitsio'],
    ],
  }
  exec { "install_fitsio":
    refreshonly => true,
    path    => '/bin/:/sbin/:/usr/bin/:/usr/sbin/',
    cwd     => "/root/fitsio-$fits_name",
    command => 'python3 setup.py install --prefix=/usr',
    require => [
      Exec['download_fitsio'],
      Exec['uninstall_old_fitsio'],
    ],
  }

}

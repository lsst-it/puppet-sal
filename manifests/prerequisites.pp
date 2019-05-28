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
#    unless  => "find /root -type d | grep -i $fits_name",
    creates => "/root/fitsio-$fits_name",
    cwd     => '/root',
    command => "wget -O $fits_tarball $fitsio_tar_url  &&  tar xfz $fits_tarball  &&  rm -f $fits_tarball",
    require => [
      Package['wget'],
    ],
    notify => Exec['install_fitsio'],
  }
  exec { "install_fitsio":
    subscribe   => Exec['download_fitsio'],
    refreshonly => true,
    path    => '/bin/:/sbin/:/usr/bin/:/usr/sbin/',
#    unless  => 'find /usr/lib64/ -type d | grep fitsio',
#    creates => "/usr/lib64/python3.6/site-packages/fitsio-$fits_name-py3.6-linux-x86_64.egg",
    cwd     => "/root/fitsio-$fits_name",
    command => 'python3 setup.py install --prefix=/usr',
    require => [
      Exec['download_fitsio'],
    ],
  }

}

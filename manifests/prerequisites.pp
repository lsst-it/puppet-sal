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
  $fits_name = basename($fitsio_tar_url, 'tar.gz'
  exec { "download_fitsio_tar":
    path => '/bin/:/sbin/:/usr/bin/:/usr/sbin/',
    unless => "find /root -type d | grep -i $fits_name",
#    creates => "/root/$fits_name",
    cwd     => "/root",
    command => "wget -O $fits_tarball $fitsio_tar_url  &&  tar xfz $fits_tarball  &&  rm -f $fits_tarball",
    require => [
      Package['wget'],
    ],
  }

  exec { "install_fitsio":
    path    => '/bin/:/sbin/:/usr/bin/:/usr/sbin/',
    unless  => "find /usr/lib64/ -type d | grep $fits_name",
#    creates => "/usr/lib64/python3.6/site-packages/$fits_name-py3.6-linux-x86_64.egg",
    cwd     => "/root/$fits_name",
    command => "python3 setup.py install --prefix=/usr",
    require => [
      Exec['download_fitsio'],
    ],
  }

}

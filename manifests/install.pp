# Install the LSST SAL software
#
# @summary Install the LSST SAL software
#
# @example
#   include sal::install
class sal::install (
    String   $version,
) {

## WHY WOULDN'T WE GRAB DIRECTLY FROM GITHUB REPO?
# 1) CHECK TO SEE IF SPECIFIED $version OF SAL IS AT /opt/sal-$version AND /opt/sal-home LINKS TO IT
# 2) FETCH $version FROM https://github.com/lsst-ts/ts_sal/archive/v$version.tar.gz
# 3) cd /opt/sal-$version && tar xfz v$version.tar.gz
# 4) ADD source /opt/sal-$version/setup_SAL.env TO BASH LOGIN PROFILE
# 5) WHEN DONE, SYMLINK /opt/sal-home TO /opt/sal-$version

## OR WITH NCSA MAINTAINED TARBALL
# 1) CHECK IF /opt/sal-home EXISTS
# 2) CHECK IF /opt/sal-home IS $version
# 3) wget http://xxxxx/sal-home-v$version.tar
# 4) cd /opt && tar xvf sal-home-v3.8.41.tar
# 5) ADD source /opt/sal-home/setup_SAL.env TO BASH LOGIN PROFILE

}

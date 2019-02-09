# Set firewall rules for SAL
#
# @summary Set firewall rules for SAL
#
# @example
#   include sal::firewall
#
# ALLOW MULTICAST/UNICAST TRAFFIC
# SEE THE FOLLOWING:
#   https://gist.github.com/juliojsb/00e3bb086fd4e0472dbe
#   https://community.rti.com/content/forum-topic/statically-configure-firewall-let-omg-dds-traffic-through
#   https://github.com/lsst-ts/ts_sal/blob/develop/lsstsal/doc/SAL_User_Guide.pdf
#
class sal::firewall  (
  $multicast_cidr,
  $omgdds_ports,
  $omgdds_subnets,
  $opensplice_ports,
  $opensplice_subnets,
) {

  firewall { "003 allow multicast via ip input":
    chain  => 'INPUT',
    proto  => all,
    source => "$multicast_cidr",
    action => accept,
  }
  firewall { "003 allow multicast via ip forward":
    chain       => 'FORWARD',
    proto       => all,
    source      => "$multicast_cidr",
    destination => "$multicast_cidr",
    action      => accept,
  }
  firewall { "003 allow multicast via ip output":
    chain       => 'OUTPUT',
    proto       => all,
    destination => "$multicast_cidr",
    action      => accept,
  }

  $omgdds_subnets.each | $location, $source_cidr |
  {
    firewall { "003 allow OMG DDS multicast/unicast via ip input from $location":
      chain  => 'INPUT',
      proto  => udp,
      dport  => $omgdds_ports,
      source => $source_cidr,
      action => accept,
    }
  }

  $opensplice_subnets.each | $location, $source_cidr |
  {
    firewall { "003 allow SAL OpenSlice via ip input from $location":
      chain  => 'INPUT',
      proto  => udp,
      dport  => $opensplice_ports,
      source => "$source_cidr",
      action => accept,
    }
  }

}

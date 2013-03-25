# Allow run sudo commpands without password
default.authorization.sudo.passwordless = true

# All by default ssh connection
default.firewall.rules = [
  'ssh' => {}
]

# ohai sysctl pulls all these values in as strings,
# so we do them as strings here so they can match

# IP Spoofing protection
default.sysctl['net.ipv4.conf.all.rp_filter'] = '1'
default.sysctl['net.ipv4.conf.default.rp_filter'] = '1'

# Ignore ICMP broadcast requests
default['net.ipv4.icmp_echo_ignore_broadcasts'] = '1'

# Ignore ICMP broadcast requests
default['net.ipv4.icmp_echo_ignore_broadcasts'] = '1'

# Disable source packet routing
default['net.ipv4.conf.all.accept_source_route'] = '0'
default['net.ipv6.conf.all.accept_source_route'] = '0'
default['net.ipv4.conf.default.accept_source_route'] = '0'
default['net.ipv6.conf.default.accept_source_route'] = '0'

# Ignore send redirects
default['net.ipv4.conf.all.send_redirects'] = '0'
default['net.ipv4.conf.default.send_redirects'] = '0'

# Block SYN attacks
default['net.ipv4.tcp_syncookies'] = '1'
default['net.ipv4.tcp_max_syn_backlog'] = '2048'
default['net.ipv4.tcp_synack_retries'] = '2'
default['net.ipv4.tcp_syn_retries'] = '5'

# Log Martians
default['net.ipv4.conf.all.log_martians'] = '1'
default['net.ipv4.icmp_ignore_bogus_error_responses'] = '1'

# Ignore ICMP redirects
default['net.ipv4.conf.all.accept_redirects'] = '0'
default['net.ipv6.conf.all.accept_redirects'] = '0'
default['net.ipv4.conf.default.accept_redirects'] = '0'
default['net.ipv6.conf.default.accept_redirects'] = '0'

# Ignore Directed pings
default['net.ipv4.icmp_echo_ignore_all'] = '1'

# bump open files way way high.
default.sysctl['fs.file-max'] = '1000000'

# 256 KB default performs well experimentally, and is often recommended by ISVs.
default.sysctl['net.core.rmem_default'] = '262144'
default.sysctl['net.core.wmem_default'] = '262144'

# When opening a high-bandwidth connection while the receiving end is under
# memory pressure, disk I/O may be necessary to free memory for the socket,
# making disk latency the effective latency for the bandwidth-delay product
# initially.  For 10 Gb ethernet and SCSI, the BDP is about 5 MB.  Allow 8 MB
# to account for overhead, to ensure that new sockets can saturate the medium
# quickly.
default.sysctl['net.core.rmem_max'] = '8388608'
default.sysctl['net.core.wmem_max'] = '8388608'

# Allow a deep backlog for 10 Gb and bonded Gb ethernet connections
default.sysctl['net.core.netdev_max_backlog'] = '10000'

# Always have one page available, plus an extra for overhead, to ensure TCP NFS
# pageout doesn't stall under memory pressure.  Default to max unscaled window,
# plus overhead for rmem, since most LAN sockets won't need to scale.
default.sysctl['net.ipv4.tcp_rmem'] = '8192 87380 8388608'
default.sysctl['net.ipv4.tcp_wmem'] = '8192 87380 8388608'

# Always have enough memory available on a UDP socket for an 8k NFS request,
# plus overhead, to prevent NFS stalling under memory pressure.  16k is still
# low enough that memory fragmentation is unlikely to cause problems.
#if platform_version.to_i >= 5
  default.sysctl['net.ipv4.udp_rmem_min'] = '16384'
  default.sysctl['net.ipv4.udp_wmem_min'] = '16384'

  # Ensure there's enough memory to actually allocate those massive buffers to a
  # socket.
  default.sysctl['net.ipv4.tcp_mem'] = '8388608 12582912 16777216'
  default.sysctl['net.ipv4.udp_mem'] = '8388608 12582912 16777216'
#end

# Decrease the time default value for tcp_fin_timeout connection
default.sysctl['net.ipv4.tcp_fin_timeout'] = '30'

# Decrease the time default value for tcp_keepalive_time connection
default.sysctl['net.ipv4.tcp_keepalive_time'] = '1800'

# support large window scaling RFC 1323
default.sysctl['net.ipv4.tcp_window_scaling'] = 1

# Filesystem I/O is usually much more efficient than swapping, so try to keep
# swapping low.  It's usually safe to go even lower than this on systems with
# server-grade storage.
default.sysctl['vm.swappiness'] = '0'

# If a workload mostly uses anonymous memory and it hits this limit, the entire
# working set is buffered for I/O, and any more write buffering would require
# swapping, so it's time to throttle writes until I/O can catch up.  Workloads
# that mostly use file mappings may be able to use even higher values.
default.sysctl['vm.dirty_ratio'] = '50'


# Controls the System Request debugging functionality of the kernel
default.sysctl['kernel.sysrq'] = 1

# reboot on panic
default.sysctl['kernel.panic'] = 30

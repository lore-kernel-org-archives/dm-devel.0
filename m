From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: open-iscsi + multipath
Date: Mon, 20 Nov 2006 12:38:55 -0600
Message-ID: <4561F63F.2020900@cs.wisc.edu>
References: <1164025524.104073.215440@f16g2000cwb.googlegroups.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1164025524.104073.215440@f16g2000cwb.googlegroups.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: open-iscsi@googlegroups.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

ddonov wrote:
> Hi,
> 
> We are in the implementation phase of an project that includes iscsi
> access to FC storage
> (EMC CX3-20) via 2 MCData Eclipse 2640 storage routers (that make the
> FC to ISCSI conversion).  Various combinations were tested (NICs/HBAs,
> native multipath/powerpath, open-iscsi/linux-iscs) and only the
> HBAs/native multipath combination gives acceptable results.
> All other combinations work until a path fails, then either the host
> does not failover to other
> paths or does not restore the failed paths after they are available
> again.
> These are the configuration details and the syslog from the performed
> test on the
> open-iscsi/native multipath setup.
> If anyone has any previous experience with this or similar environment
> please share your
> ideas on how to make this thing work.
> Thank you
> 
> SLES 10,2xGB NICs,native Linux multipath, 1 LUN
> 
> SLES 10
> Linux backup 2.6.16.21-0.8-smp #1 SMP Mon Jul 3 18:25:39 UTC 2006
> x86_64 x86_64 x86_64 GNU/Linux
> multipath-tools-0.4.6-25.8
> open-iscsi-0.5.545-9.12

SLES uses a older but modified with some upstream patches version of
open-iscsi. I am not sure what is in there. We did some multipath
enhancements a while back and I am not sure if there are in there or
what bugs are still in that version. Could you retry your tests with the
current upstream kernel and the current upstream open-iscsi:

http://www.open-iscsi.org/bits/open-iscsi-2.0-730.tar.gz

Could you also build this with "make DEBUG_SCSI=1" and run iscsid with
"iscsid -d 7".

> 
> !!!! node.session.iscsi.ImmediateData = Yes
> if this setting is yes the initiator constantly
> drops and reconnects to the target

This should now be fixed in the upstream code. There was a bug with
ImmediateData and when padding was sent.


> /dev/mapper/mpath0-part1 mounted to /iscsi
> dd if=/dev/zero of=/iscsi/test.txt
> LUN tresspass
> 2 paths are lost and initiator doesn't recover
> other 2 paths are used
> second LUN tresspass
> all paths are in failed state the copy process
> stops (the dest file size doesnt change)
> portal 10.10.24.130 disabled
> portal 10.10.24.130 enabled
> 
> 


It looks like there may be a bug in dm-mpath.c where the pg is not
getting setup correctly and paths get failed incorrectly as a result. It
also looks like there is a bug in iscsi where the tresspass command is
timing out (unless you tried to cause a failover at that time). I am not
sure exactly since I do not know what SLES is doing. Lars or Hannes or
someone could you point me to your source?

Also could you tell me when you did whatever you did to test failover?
Was it around 16:11?

Also are you running multipathd?

And in general for the upstream code one comment, you may either want to
turn nops on since they will catch a transport problem pretty quickly
normally with most failures or you will want to increase the
replacement_timeout value. I think this may also apply to SLES, but I am
not sure. I do not remember off the top of my head.



> 
> /var/log/messages
> 
> Nov 16 15:40:56 backup syslog-ng[2186]: syslog-ng version 1.6.8 going
> down
> Nov 16 15:46:10 backup syslog-ng[2253]: syslog-ng version 1.6.8
> starting
> Nov 16 15:46:10 backup ifstatus:     lo
> Nov 16 15:46:10 backup ifstatus: lo is up
> Nov 16 15:46:10 backup ifstatus: 1: lo: <LOOPBACK,UP> mtu 16436 qdisc
> noqueue
> Nov 16 15:46:10 backup ifstatus:     link/loopback 00:00:00:00:00:00
> brd 00:00:00:00:00:00
> Nov 16 15:46:10 backup ifstatus:     inet 127.0.0.1/8 scope host lo
> Nov 16 15:46:10 backup ifstatus:               IP address: 127.0.0.1/8
> Nov 16 15:46:10 backup ifstatus-route: Configured routes for interface
> lo:
> Nov 16 15:46:10 backup ifstatus-route:   127/8 - - lo
> Nov 16 15:46:10 backup ifstatus-route: Active routes for interface lo:
> Nov 16 15:46:10 backup ifstatus-route:   127.0.0.0/8  scope link
> Nov 16 15:46:10 backup ifstatus-route: 1 of 1 configured routes for
> interface lo up
> Nov 16 15:46:10 backup ifup:     lo
> Nov 16 15:46:10 backup ifup:     lo
> Nov 16 15:46:10 backup ifup: IP address: 127.0.0.1/8
> Nov 16 15:46:10 backup ifup:
> Nov 16 15:46:11 backup ifup:     eth0      device: Broadcom Corporation
> NetXtreme BCM5704 Gigabit Ethernet (rev 10)
> Nov 16 15:46:11 backup ifup:     eth0      configuration:
> eth-id-00:17:08:5b:24:27
> Nov 16 15:46:11 backup ifup:     eth0
> Nov 16 15:46:11 backup ifup: IP address: 10.10.24.167/25
> Nov 16 15:46:11 backup ifup:
> Nov 16 15:46:11 backup syslog-ng[2253]: Changing permissions on special
> file /dev/xconsole
> Nov 16 15:46:11 backup syslog-ng[2253]: Changing permissions on special
> file /dev/tty10
> Nov 16 15:46:11 backup ifup-route: Warning: Could not set up default
> route via interface
> Nov 16 15:46:11 backup ifup-route:  Command ip route replace to default
> via 10.173.5.2 returned:
> Nov 16 15:46:11 backup ifup-route:  . RTNETLINK answers: Network is
> unreachable
> Nov 16 15:46:11 backup ifup-route:  Configuration line: default
> 10.173.5.2 - -
> Nov 16 15:46:11 backup ifup-route:  This needs NOT to be AN ERROR if
> you set up multiple interfaces.
> Nov 16 15:46:11 backup ifup-route:  See man 5 routes how to avoid this
> warning.
> Nov 16 15:46:11 backup ifup-route:
> Nov 16 15:46:12 backup ifup:     eth1      device: Broadcom Corporation
> NetXtreme BCM5704 Gigabit Ethernet (rev 10)
> Nov 16 15:46:12 backup ifup:     eth1      configuration:
> eth-id-00:17:08:5b:24:26
> Nov 16 15:46:12 backup ifup:     eth1
> Nov 16 15:46:12 backup ifup: IP address: 10.10.24.67/25
> Nov 16 15:46:12 backup ifup:
> Nov 16 15:46:12 backup ifup-route: Warning: Could not set up default
> route via interface
> Nov 16 15:46:12 backup ifup-route:  Command ip route replace to default
> via 10.173.5.2 returned:
> Nov 16 15:46:12 backup ifup-route:  . RTNETLINK answers: Network is
> unreachable
> Nov 16 15:46:12 backup ifup-route:  Configuration line: default
> 10.173.5.2 - -
> Nov 16 15:46:12 backup ifup-route:  This needs NOT to be AN ERROR if
> you set up multiple interfaces.
> Nov 16 15:46:12 backup ifup-route:  See man 5 routes how to avoid this
> warning.
> Nov 16 15:46:12 backup ifup-route:
> Nov 16 15:46:12 backup ifup:     eth2      device: Realtek
> Semiconductor Co., Ltd. RTL-8169 Gigabit Ethernet (rev 10)
> Nov 16 15:46:12 backup ifup:     eth2      configuration:
> eth-id-00:50:fc:ec:5c:49
> Nov 16 15:46:12 backup ifup:     eth2
> Nov 16 15:46:12 backup ifup: IP address: 10.173.5.222/24
> Nov 16 15:46:12 backup ifup:
> Nov 16 15:46:13 backup auditd[3882]: Init complete, auditd 1.1.3
> listening for events
> Nov 16 15:46:15 backup rcpowersaved: CPU frequency scaling is not
> supported by your processor.
> Nov 16 15:46:15 backup rcpowersaved: enter 'CPUFREQ_ENABLED=no' in
> /etc/powersave/cpufreq to avoid this warning.
> Nov 16 15:46:15 backup kernel: klogd 1.4.1, log source = /proc/kmsg
> started.
> Nov 16 15:46:15 backup kernel: AppArmor: AppArmor (version
> 2.0-19.43r6320) initialized
> Nov 16 15:46:15 backup kernel: audit(1163688367.946:2): AppArmor
> (version 2.0-19.43r6320) initialized
> Nov 16 15:46:15 backup kernel:
> Nov 16 15:46:15 backup kernel: ACPI: Power Button (FF) [PWRF]
> Nov 16 15:46:15 backup kernel: r8169: eth2: link up
> Nov 16 15:46:15 backup kernel: IA-32 Microcode Update Driver: v1.14
> <tigran@veritas.com>
> Nov 16 15:46:15 backup kernel: IA-32 Microcode Update Driver v1.14
> unregistered
> Nov 16 15:46:15 backup kernel: tg3: eth0: Link is up at 1000 Mbps, full
> duplex.
> Nov 16 15:46:15 backup kernel: tg3: eth0: Flow control is on for TX and
> on for RX.
> Nov 16 15:46:15 backup rcpowersaved: Cannot load cpufreq governors - No
> cpufreq driver available
> Nov 16 15:46:15 backup rcpowersaved: s2ram does not know your machine.
> See 's2ram -i' for details. (127)
> Nov 16 15:46:15 backup rcpowersaved: Use SUSPEND2RAM_FORCE=yes to
> override this detection.
> Nov 16 15:46:15 backup kernel: NET: Registered protocol family 10
> Nov 16 15:46:15 backup kernel: lo: Disabled Privacy Extensions
> Nov 16 15:46:15 backup kernel: ADDRCONF(NETDEV_UP): eth1: link is not
> ready
> Nov 16 15:46:15 backup kernel: IPv6 over IPv4 tunneling driver
> Nov 16 15:46:15 backup sshd[4140]: Server listening on :: port 22.
> Nov 16 15:46:15 backup ifup:     sit0
> Nov 16 15:46:15 backup ifup:               No configuration found for
> sit0
> Nov 16 15:46:15 backup [powersave-set_disk_settings][4197]: WARNING:
> could not retrieve list of disks from HAL:
> Nov 16 15:46:15 backup kernel: tg3: eth1: Link is up at 1000 Mbps, full
> duplex.
> Nov 16 15:46:15 backup kernel: tg3: eth1: Flow control is on for TX and
> on for RX.
> Nov 16 15:46:15 backup kernel: ADDRCONF(NETDEV_CHANGE): eth1: link
> becomes ready
> Nov 16 15:46:16 backup /usr/sbin/cron[4271]: (CRON) STARTUP (V5.0)
> Nov 16 15:46:16 backup zmd: NetworkManagerModule (WARN): Failed to
> connect to NetworkManager
> Nov 16 15:46:18 backup kernel: mtrr: type mismatch for fc000000,800000
> old: uncachable new: write-combining
> Nov 16 15:46:18 backup kernel: mtrr: type mismatch for fc000000,800000
> old: uncachable new: write-combining
> Nov 16 15:46:23 backup zmd: Daemon (WARN): Not starting remote web
> server
> Nov 16 15:46:23 backup sshd[4294]: Accepted keyboard-interactive/pam
> for root from 10.173.5.99 port 1755 ssh2
> Nov 16 15:46:26 backup kernel: eth2: no IPv6 routers present
> Nov 16 15:46:26 backup kernel: eth0: no IPv6 routers present
> Nov 16 15:46:26 backup kernel: eth1: no IPv6 routers present
> Nov 16 15:46:36 backup kernel: iscsi: registered transport (tcp)
> Nov 16 15:46:36 backup iscsid: iSCSI logger with pid=4471 started!
> Nov 16 15:46:37 backup iscsid: version 1.0-604
> Nov 16 15:46:37 backup iscsid: iSCSI sync pid=4473 started
> Nov 16 15:46:37 backup iscsid: iSCSI daemon with pid=4472 started!
> Nov 16 15:46:40 backup iscsid: connect failed (113)
> Nov 16 15:46:43 backup iscsid: connect failed (113)
> Nov 16 15:46:46 backup iscsid: connect failed (113)
> Nov 16 15:46:47 backup kernel: scsi2 : iSCSI Initiator over TCP/IP,
> v1.0-595
> Nov 16 15:46:48 backup kernel:   Vendor: DGC       Model: RAID 10
>     Rev: 0322
> Nov 16 15:46:48 backup kernel:   Type:   Direct-Access
>     ANSI SCSI revision: 04
> Nov 16 15:46:48 backup kernel: SCSI device sda: 209715200 512-byte hdwr
> sectors (107374 MB)
> Nov 16 15:46:48 backup kernel: sda: test WP failed, assume Write
> Enabled
> Nov 16 15:46:48 backup kernel: sda: asking for cache data failed
> Nov 16 15:46:48 backup kernel: sda: assuming drive cache: write through
> Nov 16 15:46:48 backup kernel: SCSI device sda: 209715200 512-byte hdwr
> sectors (107374 MB)
> Nov 16 15:46:48 backup kernel: sda: test WP failed, assume Write
> Enabled
> Nov 16 15:46:48 backup kernel: sda: asking for cache data failed
> Nov 16 15:46:48 backup kernel: sda: assuming drive cache: write through
> Nov 16 15:46:48 backup kernel:  sda:<6>sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: Buffer I/O error on device sda, logical
> block 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: Buffer I/O error on device sda, logical
> block 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: Buffer I/O error on device sda, logical
> block 0
> Nov 16 15:46:48 backup kernel:  unable to read partition table
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Attached scsi disk sda
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Attached scsi generic sg0
> type 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 209715072
> Nov 16 15:46:48 backup kernel: Buffer I/O error on device sda, logical
> block 26214384
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 209715072
> Nov 16 15:46:48 backup kernel: Buffer I/O error on device sda, logical
> block 26214384
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 209715192
> Nov 16 15:46:48 backup kernel: Buffer I/O error on device sda, logical
> block 26214399
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 209715192
> Nov 16 15:46:48 backup kernel: Buffer I/O error on device sda, logical
> block 26214399
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 209715192
> Nov 16 15:46:48 backup kernel: Buffer I/O error on device sda, logical
> block 26214399
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 209715192
> Nov 16 15:46:48 backup kernel: Buffer I/O error on device sda, logical
> block 26214399
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 209715192
> Nov 16 15:46:48 backup kernel: Buffer I/O error on device sda, logical
> block 26214399
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 209715192
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 209715136
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 209715136
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 209715184
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 209715184
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 16
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:48 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:48 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:49 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:49 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:49 backup kernel: sd 2:0:0:0: Device not ready.
> Nov 16 15:46:49 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:46:49 backup iscsid: connection0:0 is operational now


Must have logged out of that session and reinsmoded iscsi_tcp?


> Nov 16 15:47:41 backup kernel: iscsi: registered transport (tcp)
> Nov 16 15:47:41 backup iscsid: iSCSI logger with pid=4639 started!
> Nov 16 15:47:41 backup kernel: scsi3 : iSCSI Initiator over TCP/IP,
> v1.0-595
> Nov 16 15:47:42 backup iscsid: iSCSI daemon with pid=4640 started!
> Nov 16 15:47:42 backup iscsid: version 1.0-604
> Nov 16 15:47:42 backup iscsid: iSCSI sync pid=4641 started
> Nov 16 15:47:42 backup kernel:   Vendor: DGC       Model: RAID 10
>     Rev: 0322
> Nov 16 15:47:42 backup kernel:   Type:   Direct-Access
>     ANSI SCSI revision: 04
> Nov 16 15:47:42 backup kernel: SCSI device sda: 209715200 512-byte hdwr
> sectors (107374 MB)
> Nov 16 15:47:42 backup kernel: sda: test WP failed, assume Write
> Enabled
> Nov 16 15:47:42 backup kernel: sda: asking for cache data failed
> Nov 16 15:47:42 backup kernel: sda: assuming drive cache: write through
> Nov 16 15:47:42 backup kernel: SCSI device sda: 209715200 512-byte hdwr
> sectors (107374 MB)
> Nov 16 15:47:42 backup kernel: sda: test WP failed, assume Write
> Enabled
> Nov 16 15:47:42 backup kernel: sda: asking for cache data failed
> Nov 16 15:47:42 backup kernel: sda: assuming drive cache: write through
> Nov 16 15:47:42 backup kernel:  sda:<6>sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:42 backup kernel: printk: 65 messages suppressed.
> Nov 16 15:47:42 backup kernel: Buffer I/O error on device sda, logical
> block 0
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:42 backup kernel: Buffer I/O error on device sda, logical
> block 0
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:42 backup kernel: Buffer I/O error on device sda, logical
> block 0
> Nov 16 15:47:42 backup kernel:  unable to read partition table
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Attached scsi disk sda
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Attached scsi generic sg0
> type 0
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 209715072
> Nov 16 15:47:42 backup kernel: Buffer I/O error on device sda, logical
> block 26214384
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 209715072
> Nov 16 15:47:42 backup kernel: Buffer I/O error on device sda, logical
> block 26214384
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 209715192
> Nov 16 15:47:42 backup kernel: Buffer I/O error on device sda, logical
> block 26214399
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 209715192
> Nov 16 15:47:42 backup kernel: Buffer I/O error on device sda, logical
> block 26214399
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 209715192
> Nov 16 15:47:42 backup kernel: Buffer I/O error on device sda, logical
> block 26214399
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 209715192
> Nov 16 15:47:42 backup kernel: Buffer I/O error on device sda, logical
> block 26214399
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 209715192
> Nov 16 15:47:42 backup kernel: Buffer I/O error on device sda, logical
> block 26214399
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 209715192
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 209715136
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 209715136
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 209715184
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 209715184
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 16
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:42 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:42 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:43 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:43 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:43 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:43 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:43 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:43 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:43 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:43 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:43 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:43 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:43 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:43 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:43 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:43 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:43 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:43 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:43 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:43 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:43 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:43 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:43 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:43 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:43 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:43 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:43 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:43 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:43 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:43 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:43 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:43 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:43 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:43 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:43 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:43 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:43 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:43 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:43 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:47:43 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:47:43 backup kernel: scsi4 : iSCSI Initiator over TCP/IP,
> v1.0-595
> Nov 16 15:47:43 backup kernel:   Vendor: DGC       Model: RAID 10
>     Rev: 0322
> Nov 16 15:47:43 backup kernel:   Type:   Direct-Access
>     ANSI SCSI revision: 04
> Nov 16 15:47:43 backup kernel: SCSI device sdb: 209715200 512-byte hdwr
> sectors (107374 MB)
> Nov 16 15:47:43 backup kernel: sdb: Write Protect is off
> Nov 16 15:47:43 backup kernel: sdb: Mode Sense: 87 00 00 08
> Nov 16 15:47:43 backup kernel: SCSI device sdb: drive cache: write
> through
> Nov 16 15:47:43 backup kernel: SCSI device sdb: 209715200 512-byte hdwr
> sectors (107374 MB)
> Nov 16 15:47:43 backup kernel: sdb: Write Protect is off
> Nov 16 15:47:43 backup kernel: sdb: Mode Sense: 87 00 00 08
> Nov 16 15:47:43 backup kernel: SCSI device sdb: drive cache: write
> through
> Nov 16 15:47:43 backup kernel:  sdb: sdb1
> Nov 16 15:47:43 backup kernel: sd 4:0:0:0: Attached scsi disk sdb
> Nov 16 15:47:43 backup kernel: sd 4:0:0:0: Attached scsi generic sg1
> type 0
> Nov 16 15:47:43 backup iscsid: connection0:0 is operational now
> Nov 16 15:47:43 backup iscsid: connection1:0 is operational now
> Nov 16 15:47:43 backup kernel: scsi5 : iSCSI Initiator over TCP/IP,
> v1.0-595
> Nov 16 15:47:43 backup kernel:   Vendor: DGC       Model: RAID 10
>     Rev: 0322
> Nov 16 15:47:43 backup kernel:   Type:   Direct-Access
>     ANSI SCSI revision: 04
> Nov 16 15:47:43 backup kernel: SCSI device sdc: 209715200 512-byte hdwr
> sectors (107374 MB)
> Nov 16 15:47:43 backup kernel: sdc: Write Protect is off
> Nov 16 15:47:43 backup kernel: sdc: Mode Sense: 87 00 00 08
> Nov 16 15:47:43 backup kernel: SCSI device sdc: drive cache: write
> through
> Nov 16 15:47:43 backup kernel: SCSI device sdc: 209715200 512-byte hdwr
> sectors (107374 MB)
> Nov 16 15:47:43 backup kernel: sdc: Write Protect is off
> Nov 16 15:47:43 backup kernel: sdc: Mode Sense: 87 00 00 08
> Nov 16 15:47:43 backup kernel: SCSI device sdc: drive cache: write
> through
> Nov 16 15:47:43 backup kernel:  sdc: sdc1
> Nov 16 15:47:43 backup kernel: sd 5:0:0:0: Attached scsi disk sdc
> Nov 16 15:47:43 backup kernel: sd 5:0:0:0: Attached scsi generic sg2
> type 0
> Nov 16 15:47:44 backup kernel: scsi6 : iSCSI Initiator over TCP/IP,
> v1.0-595
> Nov 16 15:47:44 backup kernel:   Vendor: DGC       Model: RAID 10
>     Rev: 0322
> Nov 16 15:47:44 backup kernel:   Type:   Direct-Access
>     ANSI SCSI revision: 04
> Nov 16 15:47:44 backup kernel: SCSI device sdd: 209715200 512-byte hdwr
> sectors (107374 MB)
> Nov 16 15:47:44 backup kernel: sdd: test WP failed, assume Write
> Enabled
> Nov 16 15:47:44 backup kernel: sdd: asking for cache data failed
> Nov 16 15:47:44 backup kernel: sdd: assuming drive cache: write through
> Nov 16 15:47:44 backup kernel: SCSI device sdd: 209715200 512-byte hdwr
> sectors (107374 MB)
> Nov 16 15:47:44 backup kernel: sdd: test WP failed, assume Write
> Enabled
> Nov 16 15:47:44 backup kernel: sdd: asking for cache data failed
> Nov 16 15:47:44 backup kernel: sdd: assuming drive cache: write through
> Nov 16 15:47:44 backup kernel:  sdd:<6>sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel:  unable to read partition table
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Attached scsi disk sdd
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Attached scsi generic sg3
> type 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 209715072
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 209715072
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 209715192
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 209715192
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 209715192
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 209715192
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 209715192
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 209715192
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 209715136
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 209715136
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 209715184
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 209715184
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup iscsid: connection2:0 is operational now
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup iscsid: connection3:0 is operational now
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 16
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:47:44 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:47:44 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:49:16 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:49:16 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:49:16 backup kernel: printk: 140 messages suppressed.
> Nov 16 15:49:16 backup kernel: Buffer I/O error on device sda, logical
> block 0
> Nov 16 15:49:16 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:49:16 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:49:16 backup kernel: Buffer I/O error on device sda, logical
> block 0
> Nov 16 15:49:16 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:49:16 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:49:16 backup kernel: Buffer I/O error on device sda, logical
> block 0
> Nov 16 15:49:16 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 15:49:16 backup kernel: end_request: I/O error, dev sda, sector
> 0
> Nov 16 15:49:16 backup kernel: Buffer I/O error on device sda, logical
> block 0
> Nov 16 15:49:16 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:49:16 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:49:16 backup kernel: Buffer I/O error on device sdd, logical
> block 0
> Nov 16 15:49:16 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:49:16 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:49:16 backup kernel: Buffer I/O error on device sdd, logical
> block 0
> Nov 16 15:49:16 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:49:16 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:49:16 backup kernel: Buffer I/O error on device sdd, logical
> block 0
> Nov 16 15:49:16 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 15:49:16 backup kernel: end_request: I/O error, dev sdd, sector
> 0
> Nov 16 15:49:16 backup kernel: Buffer I/O error on device sdd, logical
> block 0
> Nov 16 15:49:23 backup kernel: device-mapper: dm-multipath version
> 1.0.4 loaded
> Nov 16 15:49:23 backup kernel: device-mapper: dm-emc version 0.0.3
> loaded
> Nov 16 15:49:23 backup kernel: device-mapper: dm-emc: long trespass
> command will be send
> Nov 16 15:49:23 backup kernel: device-mapper: dm-emc: honor reservation
> bit will not be set (default)
> Nov 16 15:49:23 backup kernel: device-mapper: dm-round-robin version
> 1.0.0 loaded
> Nov 16 15:49:23 backup kernel: device-mapper: dm-emc: emc_pg_init:
> sending switch-over command


dm sends tresspass and a minute later the connection bails out on us?
Looks like it timed out. If SUSE dm-emc is like upstream then it just
sent the req as failfast, it timed out, iscsi_tcp went into recovery,
reconnected, and because failfast was set the req was returned to
dm-emc.c which called:
dm_pg_init_complete(path, MP_FAIL_PATH);

It looks like in this trace though somehow dm-emc.c called
dm_pg_init_complete with success/0 because down below we start sending
IO to those paths, but we get Device not ready.


> Nov 16 15:50:23 backup kernel:  connection2:0: iscsi: detected conn
> error (1011)
> Nov 16 15:50:24 backup kernel: iscsi: host reset succeeded
> Nov 16 15:50:24 backup iscsid: detected iSCSI connection 2:0 error
> (1011) state (3)
> Nov 16 15:50:24 backup iscsid: connection2:0 is operational after
> recovery (1 attempts)
> Nov 16 15:50:53 backup kernel: ReiserFS: dm-1: found reiserfs format
> "3.6" with standard journal
> Nov 16 15:50:54 backup kernel: ReiserFS: dm-1: using ordered data mode
> Nov 16 15:50:54 backup kernel: reiserfs: using flush barriers
> Nov 16 15:50:54 backup kernel: ReiserFS: dm-1: journal params: device
> dm-1, size 8192, journal first block 18, max trans len 1024, max batch
> 900, max commit age 30, max trans age 30
> Nov 16 15:50:54 backup kernel: ReiserFS: dm-1: checking transaction log
> (dm-1)
> Nov 16 15:50:54 backup kernel: reiserfs: disabling flush barriers on
> dm-1
> Nov 16 15:50:54 backup kernel: ReiserFS: dm-1: Using r5 hash to sort
> names
> Nov 16 15:54:18 backup sshd[4963]: Accepted keyboard-interactive/pam
> for root from 10.173.5.99 port 1773 ssh2
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11155487

Maybe a bug in dm-mpath.c? The pg_init did not complete ok initially,
and now we are sending IO to those paths. It looks like those paths got
turned off and the the second pg with sda and sdd is now active. This is
only a guess becuase initially sdb and sdc was executing IO ok, but now
they are returning "Device not ready" like how sda and sdd were when
they were passive.

> Nov 16 16:05:21 backup kernel: device-mapper: dm-multipath: Failing
> path 8:32.
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11156511
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11157167
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11165439
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11165463
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11166487
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11167287
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11167695
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11168719
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11169743
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11170767
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11170775
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11157431
> Nov 16 16:05:21 backup kernel: device-mapper: dm-multipath: Failing
> path 8:16.
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11158455
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11159183
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11159791
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11160815
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11171799
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11172823
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11181455
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11182055
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11183079
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11183495
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11183543
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11184567
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11185591
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11161839
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11162863
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11162871
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11163895
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11164919
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11173447
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11173759
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11174783
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11175391
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11175623
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11176647
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11177671
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11186615
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11186623
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11187647
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11188671
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11197471
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11198495
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11198647
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11199671
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11199703
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11200727
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11200735
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11178695
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11178703
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11179727
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11180751
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11189463
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11190351
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11191375
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11191599
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11192623
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11192631
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11193655
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11194679
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11195231
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11196255
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11197279
> Nov 16 16:05:21 backup kernel: device-mapper: dm-emc: emc_pg_init:
> sending switch-over command
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11201759
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11202783
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11203287
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11204311
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11205335
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11213487
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11214511
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11215535
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11215911
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11216935
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11217959
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11218983
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11220007
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11221031
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11229503
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11230527
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11231551
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11232119
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11233143
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11234167
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11235191
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11236215
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11237239
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11245519
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11246543
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11247567
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11248591
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11205479
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11206503
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11206919
> Nov 16 16:05:21 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdb, sector
> 11207807
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11249615
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11250639
> Nov 16 16:05:21 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:21 backup kernel: end_request: I/O error, dev sdc, sector
> 11251663
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11252687
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11261519
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11262543
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11263567
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11264591
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11265615
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11266639
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11267663
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11268687
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11277559
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11278583
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11208831
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11209855
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11210879
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11211903
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11212927
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11221495
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11222519
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11223543
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11224015
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11225039
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11226063
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11227087
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11228111
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11229135
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11237511
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11238535
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11239559
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11240223
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11241247
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11242271
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11243295
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11244319
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11245343
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11253519
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11254543
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11255567
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11256591
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11257615
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11279607
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11280631
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11280751
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11281775
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11282799
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11283823
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11284847
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11293575
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11294599
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11295623
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11296647
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11296959
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11297983
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11299007
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11300031
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11301055
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11309591
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11310615
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11311639
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11312663
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11313167
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11314191
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11315215
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11316239
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11317263
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11325607
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11326631
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11327655
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11328679
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11329375
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11330399
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11331423
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11332447
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11333471
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11341623
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11342647
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11343671
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11344695
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11345583
> Nov 16 16:05:22 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdc, sector
> 11346607
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11258639
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11259663
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11260687
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11269519
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11270543
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11271567
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11272287
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11272647
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11273671
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11274695
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11275719
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11276743
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11285567
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11286591
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11287615
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11288639
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11288855
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11289879
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11290903
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11291927
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11292951
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11301583
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11302607
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11303631
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11304655
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11305063
> Nov 16 16:05:22 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:22 backup kernel: end_request: I/O error, dev sdb, sector
> 11306087
> Nov 16 16:05:23 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:23 backup kernel: end_request: I/O error, dev sdb, sector
> 11307111
> Nov 16 16:05:23 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:23 backup kernel: end_request: I/O error, dev sdb, sector
> 11308135
> Nov 16 16:05:23 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:23 backup kernel: end_request: I/O error, dev sdb, sector
> 11309159
> Nov 16 16:05:23 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:23 backup kernel: end_request: I/O error, dev sdb, sector
> 11317599
> Nov 16 16:05:23 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:23 backup kernel: end_request: I/O error, dev sdb, sector
> 11318623
> Nov 16 16:05:23 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:23 backup kernel: end_request: I/O error, dev sdb, sector
> 11319647
> Nov 16 16:05:23 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:23 backup kernel: end_request: I/O error, dev sdb, sector
> 11320671
> Nov 16 16:05:23 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:23 backup kernel: end_request: I/O error, dev sdb, sector
> 11321271
> Nov 16 16:05:23 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:23 backup kernel: end_request: I/O error, dev sdb, sector
> 11322295
> Nov 16 16:05:23 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:23 backup kernel: end_request: I/O error, dev sdb, sector
> 11323319
> Nov 16 16:05:23 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:23 backup kernel: end_request: I/O error, dev sdb, sector
> 11324343
> Nov 16 16:05:23 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:23 backup kernel: end_request: I/O error, dev sdb, sector
> 11325367
> Nov 16 16:05:23 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:23 backup kernel: end_request: I/O error, dev sdb, sector
> 11333615
> Nov 16 16:05:23 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:23 backup kernel: end_request: I/O error, dev sdb, sector
> 11334639
> Nov 16 16:05:23 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:23 backup kernel: end_request: I/O error, dev sdb, sector
> 11335663
> Nov 16 16:05:23 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:23 backup kernel: end_request: I/O error, dev sdb, sector
> 11336687
> Nov 16 16:05:23 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:23 backup kernel: end_request: I/O error, dev sdb, sector
> 11337479
> Nov 16 16:05:23 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:23 backup kernel: end_request: I/O error, dev sdb, sector
> 11338503
> Nov 16 16:05:23 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:23 backup kernel: end_request: I/O error, dev sdb, sector
> 11339527
> Nov 16 16:05:23 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:23 backup kernel: end_request: I/O error, dev sdb, sector
> 11340551
> Nov 16 16:05:23 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:05:23 backup kernel: end_request: I/O error, dev sdb, sector
> 11341575
> Nov 16 16:05:36 backup kernel:  connection3:0: iscsi: detected conn
> error (1011)
> Nov 16 16:05:37 backup iscsid: detected iSCSI connection 3:0 error
> (1011) state (3)
> Nov 16 16:05:37 backup iscsid: connection3:0 is operational after
> recovery (1 attempts)

Get a connection problem on sdd somehow. userspace and kernel error
messages are probably out of order and this message is a result of the
kernel problem below.

> Nov 16 16:06:43 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:06:43 backup kernel: end_request: I/O error, dev sdb, sector
> 0
> Nov 16 16:06:43 backup kernel: Buffer I/O error on device sdb, logical
> block 0
> Nov 16 16:06:43 backup kernel: sd 4:0:0:0: Device not ready.
> Nov 16 16:06:43 backup kernel: end_request: I/O error, dev sdb, sector
> 0
> Nov 16 16:06:43 backup kernel: Buffer I/O error on device sdb, logical
> block 0
> Nov 16 16:06:45 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:06:45 backup kernel: end_request: I/O error, dev sdc, sector
> 0
> Nov 16 16:06:45 backup kernel: Buffer I/O error on device sdc, logical
> block 0
> Nov 16 16:06:45 backup kernel: sd 5:0:0:0: Device not ready.
> Nov 16 16:06:45 backup kernel: end_request: I/O error, dev sdc, sector
> 0
> Nov 16 16:06:45 backup kernel: Buffer I/O error on device sdc, logical
> block 0
> Nov 16 16:09:00 backup kernel: sd 3:0:0:0: Device not ready.
> Nov 16 16:09:00 backup kernel: end_request: I/O error, dev sda, sector
> 277863
> Nov 16 16:09:00 backup kernel: device-mapper: dm-multipath: Failing
> path 8:0.
> Nov 16 16:09:00 backup kernel: sd 6:0:0:0: Device not ready.
> Nov 16 16:09:00 backup kernel: end_request: I/O error, dev sdd, sector
> 277863
> Nov 16 16:09:00 backup kernel: device-mapper: dm-multipath: Failing
> path 8:48.

Lots of connection problems now.


> Nov 16 16:11:27 backup kernel:  connection0:0: iscsi: detected conn
> error (1011)
> Nov 16 16:11:27 backup kernel:  connection2:0: iscsi: detected conn
> error (1011)
> Nov 16 16:11:28 backup iscsid: detected iSCSI connection 0:0 error
> (1011) state (3)
> Nov 16 16:11:29 backup iscsid: connect failed (111)

Connection refused

> Nov 16 16:11:29 backup iscsid: detected iSCSI connection 2:0 error
> (1011) state (3)
> Nov 16 16:11:29 backup iscsid: connect failed (111)
> Nov 16 16:11:56 backup kernel:  connection0:0: iscsi: detected conn
> error (1011)
> Nov 16 16:11:56 backup kernel:  connection2:0: iscsi: detected conn
> error (1011)
> Nov 16 16:11:57 backup iscsid: connect failed (113)

No route to host.

Is this where they pulled a cable to test the failover.


> Nov 16 16:11:57 backup iscsid: connect failed (113)
> Nov 16 16:11:57 backup iscsid: detected iSCSI connection 0:0 error
> (1011) state (2)
> Nov 16 16:11:57 backup iscsid: detected iSCSI connection 2:0 error
> (1011) state (2)
> Nov 16 16:12:00 backup iscsid: connect failed (113)
> Nov 16 16:12:00 backup iscsid: connect failed (113)
> Nov 16 16:12:09 backup iscsid: connect failed (113)
> Nov 16 16:12:09 backup iscsid: connect failed (113)
> Nov 16 16:12:17 backup iscsid: connect failed (113)
> Nov 16 16:12:17 backup iscsid: connect failed (113)
> Nov 16 16:12:25 backup iscsid: connect failed (113)
> Nov 16 16:12:25 backup iscsid: connect failed (113)
> Nov 16 16:12:34 backup iscsid: connect failed (113)
> Nov 16 16:12:34 backup iscsid: connect failed (113)
> Nov 16 16:12:42 backup iscsid: connect failed (113)
> Nov 16 16:12:42 backup iscsid: connect failed (113)
> Nov 16 16:12:51 backup iscsid: connect failed (113)
> Nov 16 16:12:51 backup iscsid: connect failed (113)
> Nov 16 16:12:59 backup iscsid: connect failed (113)
> Nov 16 16:12:59 backup iscsid: connect failed (113)
> Nov 16 16:13:08 backup iscsid: connect failed (113)
> Nov 16 16:13:08 backup iscsid: connect failed (113)
> Nov 16 16:13:16 backup iscsid: connect failed (113)
> Nov 16 16:13:16 backup iscsid: connect failed (113)
> Nov 16 16:13:24 backup iscsid: connect failed (113)
> Nov 16 16:13:24 backup iscsid: connect failed (113)
> Nov 16 16:13:27 backup kernel:  session0: iscsi: session recovery timed
> out after 120 secs
> Nov 16 16:13:27 backup kernel: iscsi: cmd 0x12 is not queued (7)


Inquiry not getting queued. Is this from the path tester or maybe they
are using Ed's newest code where dm-emc.c sends a inquiry.


> Nov 16 16:13:28 backup kernel:  session2: iscsi: session recovery timed
> out after 120 secs
> Nov 16 16:13:28 backup kernel: iscsi: cmd 0x12 is not queued (7)
> Nov 16 16:13:33 backup iscsid: connect failed (113)
> Nov 16 16:13:33 backup iscsid: connect failed (113)
> Nov 16 16:13:33 backup kernel: iscsi: cmd 0x12 is not queued (7)
> Nov 16 16:13:33 backup kernel: iscsi: cmd 0x12 is not queued (7)
> Nov 16 16:13:35 backup kernel: iscsi: cmd 0x12 is not queued (7)
> Nov 16 16:13:35 backup kernel: iscsi: cmd 0x12 is not queued (7)
> Nov 16 16:13:36 backup kernel: iscsi: cmd 0x12 is not queued (7)
> Nov 16 16:13:36 backup kernel: iscsi: cmd 0x12 is not queued (7)
> Nov 16 16:13:41 backup iscsid: connect failed (113)
> Nov 16 16:13:41 backup iscsid: connect failed (113)
> Nov 16 16:13:50 backup iscsid: connect failed (113)
> Nov 16 16:13:50 backup iscsid: connect failed (113)
> Nov 16 16:13:58 backup iscsid: connect failed (113)
> Nov 16 16:13:58 backup iscsid: connect failed (113)
> Nov 16 16:14:07 backup iscsid: connect failed (113)
> Nov 16 16:14:07 backup iscsid: connect failed (113)
> Nov 16 16:14:15 backup iscsid: connect failed (113)
> Nov 16 16:14:15 backup iscsid: connect failed (113)
> Nov 16 16:14:23 backup iscsid: connect failed (113)
> Nov 16 16:14:23 backup iscsid: connect failed (113)
> Nov 16 16:14:32 backup iscsid: connect failed (113)
> Nov 16 16:14:32 backup iscsid: connect failed (113)
> Nov 16 16:14:40 backup iscsid: connect failed (113)
> Nov 16 16:14:40 backup iscsid: connect failed (113)
> Nov 16 16:14:49 backup iscsid: connect failed (113)
> Nov 16 16:14:49 backup iscsid: connect failed (113)
> Nov 16 16:14:57 backup iscsid: connect failed (113)
> Nov 16 16:14:57 backup iscsid: connect failed (113)
> Nov 16 16:15:04 backup iscsid: connection0:0 is operational after
> recovery (26 attempts)
> Nov 16 16:15:04 backup iscsid: connection2:0 is operational after
> recovery (26 attempts)
> Nov 16 16:15:14 backup iscsid: session with corresponding record
> [b88517] found!
> 
> 
> --~--~---------~--~----~------------~-------~--~----~
>  You received this message because you are subscribed to the Google Groups "open-iscsi" group.
> To post to this group, send email to open-iscsi@googlegroups.com
> To unsubscribe from this group, send email to open-iscsi-unsubscribe@googlegroups.com
> For more options, visit this group at http://groups-beta.google.com/group/open-iscsi
> -~----------~----~----~----~------~----~------~--~---
> 

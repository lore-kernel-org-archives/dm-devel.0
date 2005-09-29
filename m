From: Brad Dameron <brad@seatab.com>
Subject: multipath tools 0.4.5 bug?
Date: Thu, 29 Sep 2005 16:08:29 -0700
Message-ID: <1128035309.16902.11.camel@dhcpc226.office.pivotlink.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Kernel: 2.6.13.2 on SuSe 9.3 with device-mapper 1.01.05 with multipath
0.4.5.

multipath.conf:

defaults {
        multipath_tool  "/sbin/multipath -v0"
        udev_dir        /dev
        polling_interval 10
#       default_selector        "round-robin 1"
        default_path_grouping_policy    multibus
        default_getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"
        default_prio_callout    "/bin/true"
        default_features        "0"
        rr_min_io               100
        rr_weight               priorities
}

blacklist {
        devnode "(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "hd[a-z][[0-9]*]"
        devnode "cciss!c[0-9]d[0-9]*[p[0-9]*]"
}



I can run multipath and see all the drives and it recognizes both paths
as follows:

linux:~ # multipath
create: 320000004cf8f2eda
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 0
 \_ 2:0:12:0 sdb 8:16  [ready]
 \_ 3:0:0:0  sdm 8:192 [ready]

create: 320000004cf72cf0e
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 0
 \_ 2:0:13:0 sdc 8:32  [ready]
 \_ 3:0:1:0  sdn 8:208 [ready]

create: 320000004cf72d14b
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 0
 \_ 2:0:14:0 sdd 8:48  [ready]
 \_ 3:0:2:0  sdo 8:224 [ready]

create: 32000002037cda4b7
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 0
 \_ 2:0:15:0 sde 8:64  [ready]
 \_ 3:0:3:0  sdp 8:240 [ready]

create: 32000002037cd9b96
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 0
 \_ 2:0:16:0 sdf 8:80  [ready]
 \_ 3:0:4:0  sdq 65:0  [ready]

create: 320000004cf72c7e5
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 0
 \_ 2:0:17:0 sdg 8:96  [ready]
 \_ 3:0:5:0  sdr 65:16 [ready]

create: 320000004cf27865a
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 0
 \_ 2:0:18:0 sdh 8:112 [ready]
 \_ 3:0:6:0  sds 65:32 [ready]

create: 320000004cf72d19a
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 0
 \_ 2:0:19:0 sdi 8:128 [ready]
 \_ 3:0:7:0  sdt 65:48 [ready]

create: 320000004cf72ca99
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 0
 \_ 2:0:20:0 sdj 8:144 [ready]
 \_ 3:0:8:0  sdu 65:64 [ready]

create: 32000002037cd9f05
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 0
 \_ 2:0:21:0 sdk 8:160 [ready]
 \_ 3:0:9:0  sdv 65:80 [ready]

create: 320000004cf72c818
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 0
 \_ 2:0:22:0 sdl 8:176 [ready]
 \_ 3:0:10:0 sdw 65:96 [ready]



But the second I uncomment the default_selector to set round-robin I get
these errors:


linux:~ # multipath
reload: 320000004cf8f2eda
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 1
 \_ 2:0:12:0 sdb 8:16  [active][ready]
 \_ 3:0:0:0  sdm 8:192 [active][ready]

device-mapper ioctl cmd 9 failed: Invalid argument
device-mapper ioctl cmd 14 failed: No such device or address
reload: 320000004cf72cf0e
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 1
 \_ 2:0:13:0 sdc 8:32  [active][ready]
 \_ 3:0:1:0  sdn 8:208 [active][ready]

device-mapper ioctl cmd 9 failed: Invalid argument
device-mapper ioctl cmd 14 failed: No such device or address
reload: 320000004cf72d14b
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 1
 \_ 2:0:14:0 sdd 8:48  [active][ready]
 \_ 3:0:2:0  sdo 8:224 [active][ready]

device-mapper ioctl cmd 9 failed: Invalid argument
device-mapper ioctl cmd 14 failed: No such device or address
reload: 32000002037cda4b7
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 1
 \_ 2:0:15:0 sde 8:64  [active][ready]
 \_ 3:0:3:0  sdp 8:240 [active][ready]

device-mapper ioctl cmd 9 failed: Invalid argument
device-mapper ioctl cmd 14 failed: No such device or address
reload: 32000002037cd9b96
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 1
 \_ 2:0:16:0 sdf 8:80  [active][ready]
 \_ 3:0:4:0  sdq 65:0  [active][ready]

device-mapper ioctl cmd 9 failed: Invalid argument
device-mapper ioctl cmd 14 failed: No such device or address
reload: 320000004cf72c7e5
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 1
 \_ 2:0:17:0 sdg 8:96  [active][ready]
 \_ 3:0:5:0  sdr 65:16 [active][ready]

device-mapper ioctl cmd 9 failed: Invalid argument
device-mapper ioctl cmd 14 failed: No such device or address
reload: 320000004cf27865a
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 1
 \_ 2:0:18:0 sdh 8:112 [active][ready]
 \_ 3:0:6:0  sds 65:32 [active][ready]

device-mapper ioctl cmd 9 failed: Invalid argument
device-mapper ioctl cmd 14 failed: No such device or address
reload: 320000004cf72d19a
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 1
 \_ 2:0:19:0 sdi 8:128 [active][ready]
 \_ 3:0:7:0  sdt 65:48 [active][ready]

device-mapper ioctl cmd 9 failed: Invalid argument
device-mapper ioctl cmd 14 failed: No such device or address
reload: 320000004cf72ca99
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 1
 \_ 2:0:20:0 sdj 8:144 [active][ready]
 \_ 3:0:8:0  sdu 65:64 [active][ready]

device-mapper ioctl cmd 9 failed: Invalid argument
device-mapper ioctl cmd 14 failed: No such device or address
reload: 32000002037cd9f05
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 1
 \_ 2:0:21:0 sdk 8:160 [active][ready]
 \_ 3:0:9:0  sdv 65:80 [active][ready]

device-mapper ioctl cmd 9 failed: Invalid argument
device-mapper ioctl cmd 14 failed: No such device or address
reload: 320000004cf72c818
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 1
 \_ 2:0:22:0 sdl 8:176 [active][ready]
 \_ 3:0:10:0 sdw 65:96 [active][ready]

device-mapper ioctl cmd 9 failed: Invalid argument
device-mapper ioctl cmd 14 failed: No such device or address


Am I doing something wrong for round-robin to work? This is a Qlogic
Dual Port 2300 card with both ports connected to a Sun A5200. Any help
appreciated.

Thank you,
Brad Dameron
SeaTab Software
www.seatab.com

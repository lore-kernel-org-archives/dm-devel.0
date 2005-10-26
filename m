From: "Phil Lowden (plowden)" <plowden@cisco.com>
Subject: Clariion CX600 automatic failback support
Date: Wed, 26 Oct 2005 15:37:50 -0400
Message-ID: <013350FE9CC8AC4EB602045723F47222B9A2BB@xmb-rtp-215.amer.cisco.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I'm using LVM2 with device-mapper-multipath 0.4.5 on GA RHEL 4 update 2=20
release, kernel version 2.6.9-22.ELsmp.  Storage is 4 Clariion CX600
LUNs,=20
2 with a primary path on SP A and 2 on SP B.  HBAs are QLA3240 with
firmware 3.03.15 IPX and the RedHat-distributed driver version
8.01.00b5-rh2.

When I disrupt one path by disabling a host or SP switch port,
failover works great but failback doesn't happen automatically
with the current config (below).  By this I mean
when the connection to e.g. SP B is restored, all
4 LUNs stay trespassed to SP A.  Is this by design?
Or is there support for automatic failback, i.e.
I/O is paused and a trespass is issued to restore
the 2 SP B LUNs to their primary paths?

Of course manual failback is possible, but without
quiescing I/O I found I was able to munge my LVM2
objects up quite nicely.  Manual failback with quiesced=20
I/O is fine.

Here's the /etc/multipath.conf:

defaults {
       multipath_tool  "/sbin/multipath -v0"
       udev_dir        /dev
       polling_interval 10
       default_selector        "round-robin 0"
       default_path_grouping_policy    multibus
       default_getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"
       default_prio_callout    "/bin/true"
       default_features        "0"
       rr_wmin_io              100
       failback                immediate
}
devices {
    device {
        vendor "DGC     "
        product "RAID 5        "
        #path_grouping_policy group_by_serial
        path_grouping_policy failover
        getuid_callout "/sbin/scsi_id -g -u -s /block/%n"
        path_checker    emc_clariion
        path_selector   "round-robin 0"
        features        "0"
        hardware_handler        "1 emc"
    }
}

Here's the multipath -l output (with both paths up)
and a few commands to help make sense of it:

[root@sandbox ~]# multipath -l
3600601604b600d00743e69d8862fda11
[size=3D1 GB][features=3D"0"][hwhandler=3D"1 emc"]
\_ round-robin 0 [active]
  \_ 1:0:0:3 sdd  8:48    [active]
\_ round-robin 0 [enabled]
  \_ 0:0:0:3 sdh  8:112   [active]

3600601604b600d00773e69d8862fda11
[size=3D4 GB][features=3D"0"][hwhandler=3D"1 emc"]
\_ round-robin 0 [active]
  \_ 1:0:0:0 sda  8:0     [active]
\_ round-robin 0 [enabled]
  \_ 0:0:0:0 sde  8:64    [active]

3600601604b600d00763e69d8862fda11
[size=3D3 GB][features=3D"0"][hwhandler=3D"1 emc"]
\_ round-robin 0 [active]
  \_ 1:0:0:1 sdb  8:16    [active]
\_ round-robin 0 [enabled]
  \_ 0:0:0:1 sdf  8:80    [active]

3600601604b600d00753e69d8862fda11
[size=3D2 GB][features=3D"0"][hwhandler=3D"1 emc"]
\_ round-robin 0 [active]
  \_ 1:0:0:2 sdc  8:32    [active]
\_ round-robin 0 [enabled]
  \_ 0:0:0:2 sdg  8:96    [active]

# ls -l /dev/mpath
total 0
lrwxrwxrwx  1 root root 7 Oct 21 12:56 3600601604b600d00743e69d8862fda11
-> ../dm-3
lrwxrwxrwx  1 root root 7 Oct 21 12:56 3600601604b600d00753e69d8862fda11
-> ../dm-2
lrwxrwxrwx  1 root root 7 Oct 21 12:56 3600601604b600d00763e69d8862fda11
-> ../dm-1
lrwxrwxrwx  1 root root 7 Oct 21 12:56 3600601604b600d00773e69d8862fda11
-> ../dm-0

# pvs
  PV         VG      Fmt  Attr PSize    PFree =20
  /dev/dm-0  vgtest2 lvm2 a-      4.00G   3.90G
  /dev/dm-1  vgtest2 lvm2 a-      3.00G   2.90G
  /dev/dm-2  vgtest2 lvm2 a-      2.00G   1.90G
  /dev/dm-3  vgtest2 lvm2 a-   1020.00M 920.00M

Thanks in advance,
Phil Lowden

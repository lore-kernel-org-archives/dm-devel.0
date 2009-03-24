From: "Ransegnola, Lori" <Lori.Ransegnola@hp.com>
Subject: RE: Problem with multipathd and a blacklisted device
Date: Tue, 24 Mar 2009 13:27:43 +0000
Message-ID: <5635940A0F6F36478CF4D01273B16CA32B9CE52C1E@GVW1096EXB.americas.hpqcorp.net>
References: <5635940A0F6F36478CF4D01273B16CA32B9C3EDDF8@GVW1096EXB.americas.hpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5635940A0F6F36478CF4D01273B16CA32B9C3EDDF8@GVW1096EXB.americas.hpqcorp.net>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Ransegnola, Lori" <Lori.Ransegnola@hp.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

I sent this question last week and have not heard a thing.  Do you have a=
 suggestion of a better mailing list that I should use for this question?

Thank you.

Lori

> -----Original Message-----
> From: Ransegnola, Lori
> Sent: Thursday, March 19, 2009 3:51 PM
> To: dm-devel@redhat.com
> Cc: Ransegnola, Lori
> Subject: Problem with multipathd and a blacklisted device
>
> Configuration:
> --------------
>
> I have a multipath configuration set up where 10 disks are
> multipathed and 2 disks are blacklisted and are not
> multipathed.  Here are the relevant parts of the multipath.conf file:
>
> defaults {
>         udev_dir                /dev
>         polling_interval        10
>         selector                "round-robin 0"
> #       path_grouping_policy    multibus
>         getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
>         prio_callout            /bin/true
> #       path_checker            readsector0
>         path_checker            tur
>         rr_min_io               100
>         rr_weight               priorities
>         failback                immediate
>         no_path_retry           fail
>         user_friendly_name      yes
> }
>
> blacklist {
> #       wwid 26353900f02796769
> #       devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
> #       devnode "^hd[a-z]"
>         wwid                    35000c5000a41f72b
>         wwid                    35000c5000a41f98b
>         devnode "^cciss!c[0-9]d[0-9]*"
> }
>
>
> The two disks that are not multipathed have udev rules and
> are part of a software RAID set.  The devices show up as
>
> /etc/udev/rules.d> ls -l /dev/hpdev
> total 0
> lrwxrwxrwx 1 root root 7 Mar 18 10:50 sda1 -> ../sda1
> lrwxrwxrwx 1 root root 7 Mar 18 03:32 sdb1 -> ../sdb1
>
> /dev/md0 is created with sda and sdb.  Here is the bottom of
> the 'mdadm --detail /dev/md0' output:
>
> /root> mdadm --detail /dev/md0
> /dev/md0:
>         Version
> ...
> Failed Devices : 0
>   Spare Devices : 0
>
>            UUID : 94813396:a3e341fc:c5d4b8ba:0617a019
>          Events : 0.84
>
>     Number   Major   Minor   RaidDevice State
>        0       8        1        0      active sync   /dev/sda1
>        1       8       17        1      active sync   /dev/sdb1
> /root>
>
> I am running on a Linux RHEL5 U2 system.
> /etc/udev/rules.d> uname -a
> Linux n0 2.6.18-53.el5 #1 SMP Wed Oct 10 16:34:19 EDT 2007
> x86_64 x86_64 x86_64 GNU/Linux /etc/udev/rules.d> multipath
> -v Missing option arguement multipath-tools v0.4.7 (03/12, 2006)
> ----------------------------
>
> Problem:
>
> This configuration works well until I do some failure testing
> with one of the 2 blacklisted devs in the software RAID set.
> I found that if I temporarily remove disk sda and put it back
> a minute later the disk path, /dev/hpdev/sda1, is removed,
> even though it is blacklisted.
>
> Here are some of the pertinent /var/log/messages lines:
>
> Mar 19 09:53:19 n0 mdadm: NewArray /dev/md0 Mar 19 10:05:12
> n0 kernel: mptbase: ioc0: LogInfo(0x31170000):
> Originator=3D{PL}, Code=3D{IO Device Missing Delay Retry},
> SubCode(0x0000) Mar 19 10:05:40 n0 last message repeated 5
> times Mar 19 10:05:42 n0 kernel: mptbase: ioc0:
> LogInfo(0x31130000): Originator=3D{PL}, Code=3D{IO Not Yet
> Executed}, SubCode(0x0000) Mar 19 10:05:42 n0 kernel: sd
> 0:0:28:0: SCSI error: return code =3D 0x00010000 Mar 19
> 10:05:42 n0 kernel: end_request: I/O error, dev sda, sector
> 256119 Mar 19 10:05:42 n0 kernel: Buffer I/O error on device
> sda1, logical block 256056 Mar 19 10:05:42 n0 kernel: Buffer
> I/O error on device sda1, logical block 256057 Mar 19
> 10:05:42 n0 kernel: Buffer I/O error on device sda1, logical
> block 256058 Mar 19 10:05:42 n0 kernel: Buffer I/O error on
> device sda1, logical block 256059 Mar 19 10:05:42 n0 kernel:
> Buffer I/O error on device sda1, logical block 256060 Mar 19
> 10:05:42 n0 kernel: Buffer I/O error on device sda1, logical
> block 256061 Mar 19 10:05:42 n0 kernel: mptbase: ioc0:
> LogInfo(0x31130000): Originator=3D{PL}, Code=3D{IO Not Yet
> Executed}, SubCode(0x0000) Mar 19 10:05:42 n0 kernel: Buffer
> I/O error on device sda1, logical block 256062 Mar 19
> 10:05:42 n0 kernel: Buffer I/O error on device sda1, logical
> block 256063 Mar 19 10:05:42 n0 kernel: sd 0:0:28:0: SCSI
> error: return code =3D 0x00010000 Mar 19 10:05:42 n0
> multipathd: sda: remove path (uevent) Mar 19 10:05:42 n0
> kernel: end_request: I/O error, dev sda, sector 585922495 Mar
> 19 10:05:42 n0 kernel: Buffer I/O error on device sda1,
> logical block 585922432 Mar 19 10:05:42 n0 xinetd[13096]:
> START: hacl-cfgudp pid=3D6034 from=3D127.0.0.1 Mar 19 10:05:42 n0
> multipathd: uevent trigger error Mar 19 10:05:42 n0 kernel:
> Buffer I/O error on device sda1, logical block 585922433
>
>
> The sda path is gone:
>
> /root> ls -l /dev/hpdev
> total 0
> lrwxrwxrwx 1 root root 7 Mar 18 03:32 sdb1 -> ../sdb1 /root>
>
> And I cannot reassemble the software raid set.  While the
> mdstat looks 'normal' the software raid becomes degraded.
>
> /etc/udev/rules.d> cat /proc/mdstat
> Personalities : [raid1]
> md0 : active raid1 sda1[2](F) sdb1[1]
>       292961216 blocks [2/1] [_U]
>
> unused devices: <none>
> /etc/udev/rules.d> mdadm --detail /dev/md0
> /dev/md0:
>         Version : 00.90.03
>   Creation Time : Wed Feb 18 14:15:03 2009
>      Raid Level : raid1
>      Array Size : 292961216 (279.39 GiB 299.99 GB)
>     Device Size : 292961216 (279.39 GiB 299.99 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 0
>     Persistence : Superblock is persistent
>
>     Update Time : Thu Mar 19 10:28:45 2009
>           State : clean, degraded
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 1
>   Spare Devices : 0
>
>            UUID : 94813396:a3e341fc:c5d4b8ba:0617a019
>          Events : 0.86
>
>     Number   Major   Minor   RaidDevice State
>        0       0        0        0      removed
>        1       8       17        1      active sync   /dev/sdb1
>
>        2       8        1        -      faulty spare
> /etc/udev/rules.d>
>
> The disk is fine and is back in and ready to go.
>
> So, 1) why does multipathd remove the path for a blacklisted
> device?  If it is blacklisted, shouldn't multipathd just
> leave it alone??
> And 2) what can I do to keep this from happening??
>
> Lori Ransegnola
>

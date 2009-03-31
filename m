From: "Ransegnola, Lori" <Lori.Ransegnola@hp.com>
Subject: RE: RE: Problem with multipathd and a blacklisted device
Date: Tue, 31 Mar 2009 15:27:28 +0000
Message-ID: <5635940A0F6F36478CF4D01273B16CA32B9D0E8F73@GVW1096EXB.americas.hpqcorp.net>
References: <5635940A0F6F36478CF4D01273B16CA32B9C3EDDF8@GVW1096EXB.americas.hpqcorp.net>
	<5635940A0F6F36478CF4D01273B16CA32B9CE52C1E@GVW1096EXB.americas.hpqcorp.net>
	<20090324134209.GA12464@us.ibm.com>
	<5635940A0F6F36478CF4D01273B16CA32B9CE5310F@GVW1096EXB.americas.hpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5635940A0F6F36478CF4D01273B16CA32B9CE5310F@GVW1096EXB.americas.hpqcorp.net>
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
To: "Ransegnola, Lori" <Lori.Ransegnola@hp.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

One last try.... Anybody have any input on why this is happening, and if =
there is something that I can do about it??

Thanks.

Lori

> -----Original Message-----
> From: Ransegnola, Lori
> Sent: Tuesday, March 24, 2009 5:13 PM
> To: device-mapper development
> Cc: Ransegnola, Lori
> Subject: RE: [dm-devel] RE: Problem with multipathd and a
> blacklisted device
>
> Here is the 'multipath -ll' output before disk was pulled:
>
>  /root> ls -l /dev/hpdev
> total 0
> lrwxrwxrwx 1 root root 7 Mar 24 11:53 sda1 -> ../sdm1
> lrwxrwxrwx 1 root root 7 Mar 24 11:53 sdb1 -> ../sdn1
> /root> multipath -ll
> multisde (35000c5000a41e633) dm-2 HP,DF300BB6C3
> [size=3D279G][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 0:0:5:0  sde 8:64   [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 0:0:19:0 sdq 65:0   [active][ready]
> 35000c5000a41e44bdm-5 HP,DF300BB6C3
> [size=3D279G][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 0:0:8:0  sdh 8:112  [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 0:0:22:0 sdt 65:48  [active][ready]
> multisdc (35000c5000a41f38f) dm-0 HP,DF300BB6C3
> [size=3D279G][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 0:0:3:0  sdc 8:32   [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 0:0:17:0 sdo 8:224  [active][ready]
> 35000c5000a41e9bbdm-7 HP,DF300BB6C3
> [size=3D279G][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 0:0:10:0 sdj 8:144  [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 0:0:24:0 sdv 65:80  [active][ready]
> 35000c50004acb2cfdm-1 HP,DF0300B8053
> [size=3D279G][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 0:0:4:0  sdd 8:48   [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 0:0:18:0 sdp 8:240  [active][ready]
> 35000c5000a41f1b3dm-4 HP,DF300BB6C3
> [size=3D279G][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 0:0:7:0  sdg 8:96   [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 0:0:21:0 sds 65:32  [active][ready]
> 35000c5000a41f997dm-9 HP,DF300BB6C3
> [size=3D279G][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 0:0:12:0 sdl 8:176  [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 0:0:26:0 sdx 65:112 [active][ready]
> 35000c5000a41f37fdm-6 HP,DF300BB6C3
> [size=3D279G][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 0:0:9:0  sdi 8:128  [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 0:0:23:0 sdu 65:64  [active][ready]
> 35000c5000a41e0efdm-8 HP,DF300BB6C3
> [size=3D279G][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 0:0:11:0 sdk 8:160  [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 0:0:25:0 sdw 65:96  [active][ready]
> multisdf (35000c5000a41f007) dm-3 HP,DF300BB6C3
> [size=3D279G][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 0:0:6:0  sdf 8:80   [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 0:0:20:0 sdr 65:16  [active][ready]
> /root>
>
> Now once the disk has been pulled and the path to the device is lost:
>
> /root> ls -l /dev/hpdev
> total 0
> lrwxrwxrwx 1 root root 7 Mar 24 11:53 sdb1 -> ../sdn1
> /root> multipath -ll
> multisde (35000c5000a41e633) dm-2 HP,DF300BB6C3
> [size=3D279G][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 0:0:5:0  sde 8:64   [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 0:0:19:0 sdq 65:0   [active][ready]
> 35000c5000a41e44bdm-5 HP,DF300BB6C3
> [size=3D279G][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 0:0:8:0  sdh 8:112  [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 0:0:22:0 sdt 65:48  [active][ready]
> multisdc (35000c5000a41f38f) dm-0 HP,DF300BB6C3
> [size=3D279G][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 0:0:3:0  sdc 8:32   [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 0:0:17:0 sdo 8:224  [active][ready]
> 35000c5000a41e9bbdm-7 HP,DF300BB6C3
> [size=3D279G][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 0:0:10:0 sdj 8:144  [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 0:0:24:0 sdv 65:80  [active][ready]
> 35000c50004acb2cfdm-1 HP,DF0300B8053
> [size=3D279G][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 0:0:4:0  sdd 8:48   [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 0:0:18:0 sdp 8:240  [active][ready]
> 35000c5000a41f1b3dm-4 HP,DF300BB6C3
> [size=3D279G][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 0:0:7:0  sdg 8:96   [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 0:0:21:0 sds 65:32  [active][ready]
> 35000c5000a41f997dm-9 HP,DF300BB6C3
> [size=3D279G][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 0:0:12:0 sdl 8:176  [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 0:0:26:0 sdx 65:112 [active][ready]
> 35000c5000a41f37fdm-6 HP,DF300BB6C3
> [size=3D279G][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 0:0:9:0  sdi 8:128  [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 0:0:23:0 sdu 65:64  [active][ready]
> 35000c5000a41e0efdm-8 HP,DF300BB6C3
> [size=3D279G][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 0:0:11:0 sdk 8:160  [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 0:0:25:0 sdw 65:96  [active][ready]
> multisdf (35000c5000a41f007) dm-3 HP,DF300BB6C3
> [size=3D279G][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 0:0:6:0  sdf 8:80   [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 0:0:20:0 sdr 65:16  [active][ready]
> /root>
>
> Please let me know if there is any other information that you
> require from the node.  Thank you.
>
> Lori
>
> > -----Original Message-----
> > From: dm-devel-bounces@redhat.com
> > [mailto:dm-devel-bounces@redhat.com] On Behalf Of malahal@us.ibm.com
> > Sent: Tuesday, March 24, 2009 9:42 AM
> > To: dm-devel@redhat.com
> > Subject: Re: [dm-devel] RE: Problem with multipathd and a
> > blacklisted device
> >
> > Ransegnola, Lori [Lori.Ransegnola@hp.com] wrote:
> > > I sent this question last week and have not heard a thing.
> > Do you have a suggestion of a better mailing list that I
> > should use for this question?
> > >
> > > Thank you.
> > >
> > > Lori
> > >
> > > > -----Original Message-----
> > > > From: Ransegnola, Lori
> > > > Sent: Thursday, March 19, 2009 3:51 PM
> > > > To: dm-devel@redhat.com
> > > > Cc: Ransegnola, Lori
> > > > Subject: Problem with multipathd and a blacklisted device
> > > >
> > > > Configuration:
> > > > --------------
> > > >
> > > > I have a multipath configuration set up where 10 disks are
> > > > multipathed and 2 disks are blacklisted and are not
> multipathed.
> > > > Here are the relevant parts of the multipath.conf file:
> > > >
> > > > defaults {
> > > >         udev_dir                /dev
> > > >         polling_interval        10
> > > >         selector                "round-robin 0"
> > > > #       path_grouping_policy    multibus
> > > >         getuid_callout          "/sbin/scsi_id -g -u -s
> /block/%n"
> > > >         prio_callout            /bin/true
> > > > #       path_checker            readsector0
> > > >         path_checker            tur
> > > >         rr_min_io               100
> > > >         rr_weight               priorities
> > > >         failback                immediate
> > > >         no_path_retry           fail
> > > >         user_friendly_name      yes
> > > > }
> > > >
> > > > blacklist {
> > > > #       wwid 26353900f02796769
> > > > #       devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
> > > > #       devnode "^hd[a-z]"
> > > >         wwid                    35000c5000a41f72b
> > > >         wwid                    35000c5000a41f98b
> > > >         devnode "^cciss!c[0-9]d[0-9]*"
> > > > }
> > > >
> > > >
> > > > The two disks that are not multipathed have udev rules
> > and are part
> > > > of a software RAID set.  The devices show up as
> > > >
> > > > /etc/udev/rules.d> ls -l /dev/hpdev
> > > > total 0
> > > > lrwxrwxrwx 1 root root 7 Mar 18 10:50 sda1 -> ../sda1
> > lrwxrwxrwx 1
> > > > root root 7 Mar 18 03:32 sdb1 -> ../sdb1
> > > >
> > > > /dev/md0 is created with sda and sdb.  Here is the
> bottom of the
> > > > 'mdadm --detail /dev/md0' output:
> > > >
> > > > /root> mdadm --detail /dev/md0
> > > > /dev/md0:
> > > >         Version
> > > > ...
> > > > Failed Devices : 0
> > > >   Spare Devices : 0
> > > >
> > > >            UUID : 94813396:a3e341fc:c5d4b8ba:0617a019
> > > >          Events : 0.84
> > > >
> > > >     Number   Major   Minor   RaidDevice State
> > > >        0       8        1        0      active sync   /dev/sda1
> > > >        1       8       17        1      active sync   /dev/sdb1
> > > > /root>
> > > >
> > > > I am running on a Linux RHEL5 U2 system.
> > > > /etc/udev/rules.d> uname -a
> > > > Linux n0 2.6.18-53.el5 #1 SMP Wed Oct 10 16:34:19 EDT 2007
> > > > x86_64 x86_64 x86_64 GNU/Linux /etc/udev/rules.d> multipath -v
> > > > Missing option arguement multipath-tools v0.4.7 (03/12, 2006)
> > > > ----------------------------
> > > >
> > > > Problem:
> > > >
> > > > This configuration works well until I do some failure
> > testing with
> > > > one of the 2 blacklisted devs in the software RAID set.
> > > > I found that if I temporarily remove disk sda and put it back a
> > > > minute later the disk path, /dev/hpdev/sda1, is removed,
> > even though
> > > > it is blacklisted.
> >
> > What is 'multipath -ll' output before you remove the
> > blacklisted device?
> > What is 'multipath -ll' output after you put the device back
> > a minute later?
> >
> > Thanks, Malahal.
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> >
>

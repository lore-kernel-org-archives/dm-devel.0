From: "Romanowski, John (OFT)" <John.Romanowski@oft.state.ny.us>
Subject: RE: Bug? Determining the holders of partitions shadowed
	by	dm-multipath.
Date: Tue, 10 Feb 2009 09:49:58 -0500
Message-ID: <16F7C86087BE0247B20562A9E6B07DC75BB5DAA6@excnysm95bagp.nysemail.nyenet>
References: <20090210004951.GA4341@mail.oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090210004951.GA4341@mail.oracle.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

my sles10sp2 at 2.6.16.60-0.29-default doesn't have the /sys/block/.../ho=
lders but
I've used major:minor device numbers from commands
dmsetup ls
and
dmsetup deps
to resolve such device relationships.

A 'dmsetup ls' device number that isn't listed in 'dmsetup deps' device n=
umbers is a top-level device. Example below: mproot-part1 (dev 253:3, a p=
artition of mp device 253:2) isn't listed as a dependency of any device. =
Likewise each listed LVM volume isn't listed as a dependency of any devic=
e; example- rootvg-tmp 253:10

pz3vf129:~ # dmsetup ls
rootvg-tmp      (253, 10)
mpboot  (253, 0)
rootvg-usr      (253, 11)
rootvg-var      (253, 12)
rootvg-opt.tivoli       (253, 7)
mproot  (253, 2)
rootvg-opt.tivoli.tsm   (253, 8)
rootvg-home     (253, 5)
mpboot-part1    (253, 1)
rootvg-opt      (253, 6)
mproot-part2    (253, 4)
rootvg-swap1    (253, 9)
mproot-part1    (253, 3)

pz3vf129:~ # dmsetup deps
rootvg-tmp: 1 dependencies      : (253, 4)
mpboot: 8 dependencies  : (8, 16) (8, 80) (8, 144) (8, 208) (8, 48) (8, 1=
12) (8, 176) (8, 240)
rootvg-usr: 1 dependencies      : (253, 4)
rootvg-var: 1 dependencies      : (253, 4)
rootvg-opt.tivoli: 1 dependencies       : (253, 4)
mproot: 8 dependencies  : (8, 32) (8, 96) (8, 160) (8, 224) (8, 0) (8, 64=
) (8, 128) (8, 192)
rootvg-opt.tivoli.tsm: 1 dependencies   : (253, 4)
rootvg-home: 1 dependencies     : (253, 4)
mpboot-part1: 1 dependencies    : (253, 0)
rootvg-opt: 1 dependencies      : (253, 4)
mproot-part2: 1 dependencies    : (253, 2)
rootvg-swap1: 1 dependencies    : (253, 4)
mproot-part1: 1 dependencies    : (253, 2)



> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Joel Becker
> Sent: Monday, February 09, 2009 7:50 PM
> To: dm-devel@redhat.com
> Cc: Sunil Mushran
> Subject: [dm-devel] Bug? Determining the holders of partitions shadowed
> by dm-multipath.
>
> Folks,
>       I think this is a bug.
> I     I have a device with two paths, sda and sdb.  The device is
> partitioned into two partitions (sda1, sdb1) and (sda2, sdb2).  The
> multipath software will create me the devices mpath1, mpath1p1, and
> mpath1p2.  So far so good.
>       Now, I need to detect disks used by my software.  There is a
> signature on disks used by my software, so the basic algorithm is "for
> each disk, check for the signature".  But, as you know, multipath makes
> this fun.  You don't want to detect sda1 or sdb1, you want to detect
> mpath1.  This is true no matter how the devices are arranged (LVM
> devices, kpartx of loopbacks, whatever it is).  I'll use the term
> "toplevel device" to describe a device that is not being used as part
> of some other device.
>       So, how to determine toplevel devices?  Well,
> /sys/block/.../holders works for that, so I tried it.  Sure enough,
> /sys/block/sda/holders and /sys/block/sdb/holders point to mpath1.  So
> my software can reliably ignore sda and sdb.  But when I look at
> /sys/block/sda1/holders, it is empty.
>       The disk encompassing sda1 is held by another device.  By
> extension, sda1 is held.  So I think it is a bug that
> /sys/block/sda1/holders is empty.
>       Bug or not, what is the recommended way to determine that
> /dev/sda1 should not be used, because you should be using
> /dev/mpath/mpath1p1 (or whatever udev name it appears as)?
>
> Joel
>
> --
>
> Life's Little Instruction Book #510
>
>       "Count your blessings."
>
> Joel Becker
> Principal Software Developer
> Oracle
> E-mail: joel.becker@oracle.com
> Phone: (650) 506-8127
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


This e-mail, including any attachments, may be confidential, privileged o=
r otherwise legally protected. It is intended only for the addressee. If =
you received this e-mail in error or from someone who was not authorized =
to send it to you, do not disseminate, copy or otherwise use this e-mail =
or its attachments.  Please notify the sender immediately by reply e-mail=
 and delete the e-mail from your system.

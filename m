From: Lee Rocky <rocky366@gmail.com>
Subject: Re: Dmsetup snapshot create/remove procedure and latest
	status with 2.6.x kernel series
Date: Mon, 26 Sep 2005 00:03:30 +0800
Message-ID: <5398073005092509034ac4fb14@mail.gmail.com>
References: <4333B7CD.8010106@poczta.fm>
Reply-To: Lee Rocky <rocky366@gmail.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4333B7CD.8010106@poczta.fm>
Content-Disposition: inline
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

I got this problem too,

it look like file system has not be unloked after copied data. (but
single snapshot seems has no this problem)
so new process will get into deep-sleep status and waiting the file
system be unlocked,

can anyone tell me.
what we can do to help speed up this fix?
Can I get any device mapper design documet here?

Have a nice day
rocky

2005/9/23, Hubert <hubgor@poczta.fm>:
>
> Hello,
>
> I noticed that lvm2 create/remove snapshot of logical volume feature
> with 2.6.x kernel series is still very bad and at last randomly causes
> that any access (read/write) to that lv is impossible or even ocures
> system hung up.
>
> In detail especially create/remove many snapshots of XFS logical volume
> is big problem and causes randomly hung up xfs_io or dmsetup
> suspend/resume calls in memory.
>
> Please if somebody could help and give me some exemple(s) of proper use
> dmsetup tool (suspend/resume) or maybe xfs_freeze -f/u command under
> creating/removing snapshot and copying data at the same time ?
>
> Should i use any of above dmsetup or xfs_freeze commands ?
>
> My configuration :
> - Debian GNU/Linux 3.0 stable
> - tested kernels: 2.6.12.3, 2.6.13.2, 2.6.14rc1, 2.6.14rc2
> - libdevmapper and lvm2 1.05 - both from cvs
> - 512MB DDR RAM
> - 3ware 3xxx SATA Raid controller
> - 8x 250GB SATA HDD (Raid0 sda =3D 1.36T)
> - 1x vg, 1x xfs lv =3D 698GB, 2x snapshot =3D 349GB each
>
> I randomly creating / removing snashots under copying data from remote
> host to smb share or to iSCSI target on my server.
>
> I noticed that best results give me xfs_freeze -f/u usage but it
> sometimes couses that xfs_io hung up and then any i/o calls to XFS
> logical volume are inpossible.
>
> Even if i add more RAM (1/2GB) it not help.
>
> What dm-devel patches should be applied (patches 8 and 9 for snapshots
> don't make any diffrence) ?
>
>
> Thanks for any help.
> Best regards
>
> Hubert
>
>
> ----------------------------------------------------------------------
> Sa niesamowite, zobaczysz... ;-) >>> link http://link.interia.pl/f18b9
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

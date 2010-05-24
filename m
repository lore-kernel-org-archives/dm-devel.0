From: Rodrigo Nascimento <nascimento.rp@gmail.com>
Subject: Re: missing /sys/block/dm-*/queue
Date: Sun, 23 May 2010 22:54:22 -0300
Message-ID: <AANLkTil2UW719rMJyI4WopdpobcKaoAb5MZkfnywKyR2@mail.gmail.com>
References: <Pine.LNX.4.62.1005141234190.24031@gate.nmr.mgh.harvard.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.62.1005141234190.24031@gate.nmr.mgh.harvard.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hi Paul,

I have the same problem, I need to tune my disks to better
performance. What protocol are you using?
If you have it solve, please let me know.

Thanks

Nasc
NetApp - Enjoy it!

On Fri, May 14, 2010 at 1:43 PM, Paul Raines <raines@nmr.mgh.harvard.edu> w=
rote:
>
> Sorry if this is the wrong contact to ask this
>
> I am running RHEL 5.5 w/ device-mapper-multipath-0.4.7-34.el5
>
> I am trying to tune my disks for better performance with the settings
>
> =A0echo 2048 > /sys/block/$bdev/queue/read_ahead_kb
> =A0echo 64 > /sys/block/$bdev/queue/nr_requests
> =A0echo deadline > /sys/block/$bdev/queue/scheduler
> =A0echo 8192 > /sys/block/$bdev/queue/max_sectors_kb
>
> On the individual disk when I do this I get a big jump in read performance
> of nearly 2x
>
> # dd if=3D/dev/sdig bs=3D1024k of=3D/dev/null skip=3D3000 count=3D3000
> 3000+0 records in
> 3000+0 records out
> 3145728000 bytes (3.1 GB) copied, 13.8672 seconds, 227 MB/s
>
> # dd if=3D/dev/sdig bs=3D1024k of=3D/dev/null skip=3D9000 count=3D3000
> 3000+0 records in
> 3000+0 records out
> 3145728000 bytes (3.1 GB) copied, 7.70806 seconds, 408 MB/s
>
> So /dev/sdig is part of a multipath
>
> # ls -l /sys/block/dm-119/slaves/
> total 0
> lrwxrwxrwx 1 root root 0 May 14 12:14 sdez -> ../../../block/sdez
> lrwxrwxrwx 1 root root 0 May 14 12:14 sdif -> ../../../block/sdif
>
> I apply the tuning to both sdez and sdif, however, when I do the
> dd read test on the dm device, it is still slow
>
> # dd if=3D/dev/dm-119 bs=3D1024k of=3D/dev/null skip=3D18000 count=3D3000
> 3000+0 records in
> 3000+0 records out
> 3145728000 bytes (3.1 GB) copied, 15.1546 seconds, 208 MB/s
>
> Fine, I need to apply the tuning to the dm-119 device itself. =A0But there
> is no queue sub dir in /sys/block/dm-119
>
> # ls /sys/block/dm-119
> dev =A0holders =A0range =A0removable =A0size =A0slaves =A0stat =A0subsyst=
em =A0uevent
>
>
> So how do I tune the multipath device itself?
>
> --
> ---------------------------------------------------------------
> Paul Raines =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0email: raines at nmr.mgh.harva=
rd.edu
> MGH/MIT/HMS Athinoula A. Martinos Center for Biomedical Imaging
> 149 (2301) 13th Street =A0 =A0 Charlestown, MA 02129 =A0 =A0 =A0 =A0 =A0 =
=A0USA
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] sched: call blk_schedule_flush_plug from io_schedule
Date: Tue, 10 Feb 2015 13:51:45 +1100
Message-ID: <20150210135145.47ce4830@notabene.brown>
References: <alpine.LRH.2.02.1502091256430.28192@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/8IkTFLgZ82huYbfVMTdHg58"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1502091256430.28192@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Jens Axboe <jaxboe@fusionio.com>, Zdenek Kabelac <zkabelac@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

--Sig_/8IkTFLgZ82huYbfVMTdHg58
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Feb 2015 13:10:04 -0500 (EST) Mikulas Patocka <mpatocka@redhat.co=
m>
wrote:

> The function raid10_unplug tests the "from_schedule" variable. If the
> variable is true, it offloads queued bios to a thread. If the variable is
> false, it submits queued bios directly.
>=20
> The function io_schedule calls blk_flush_plug, that calls
> blk_flush_plug_list with "from_schedule" set to false. Consequently,
> raid10_unplug tries to submit the bios directly when being called from
> io_schedule, and that results in this warning.
>=20
> Fix the bug by calling blk_schedule_flush_plug instead of blk_flush_plug
> from io_schedule.
>=20
> WARNING: CPU: 0 PID: 2876 at kernel/sched/core.c:7326
> __might_sleep+0xae/0xc0()
> md: using maximum available idle IO bandwidth (but not more than 200000
> KB/sec) for resync.
> do not call blocking ops when !TASK_RUNNING; state=3D2 set at
> [<ffffffff81232b10>] do_blockdev_direct_IO+0x11a0/0x2e50
> Modules linked in: loop dm_raid raid456 async_raid6_recov async_memcpy
> async_pq async_xor async_tx raid1 raid10 xor raid6_pq nfsv4 nfs nfsd
> auth_rpcgss oid_registry nfs_acl lockd grace sunrpc autofs4 fuse dm_crypt
> md_mod uhci_hcd ehci_hcd usbcore i2c_piix4 serio_raw i2c_core virtio_net
> usb_common floppy pvpanic evdev sym53c8xx dm_mirror dm_region_hash dm_log
> dm_mod
> md: using 128k window, over a total of 1024k.
> CPU: 0 PID: 2876 Comm: lvm Not tainted 3.19.0-rc7-00195-gd4cecd5 #7
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>  ffffffff819e4eba ffff88003c493818 ffffffff8163975d 0000000000000007
>  ffff88003c493868 ffff88003c493858 ffffffff810587ba 00000000001d4280
>  ffffffffa013b2b4 00000000000002e9 0000000000000000 ffff88003a8be010
> Call Trace:
>  [<ffffffff8163975d>] dump_stack+0x4f/0x7b
>  [<ffffffff810587ba>] warn_slowpath_common+0x8a/0xc0
>  [<ffffffff81058836>] warn_slowpath_fmt+0x46/0x50
>  [<ffffffff810af221>] ? __lock_acquire+0x411/0x1d10
>  [<ffffffff81232b10>] ? do_blockdev_direct_IO+0x11a0/0x2e50
>  [<ffffffff81232b10>] ? do_blockdev_direct_IO+0x11a0/0x2e50
>  [<ffffffff810842ae>] __might_sleep+0xae/0xc0
>  [<ffffffffa0131816>] md_super_wait+0x26/0x90 [md_mod]
>  [<ffffffffa0138903>] bitmap_unplug+0x193/0x1a0 [md_mod]
>  [<ffffffff8112ce33>] ? __delayacct_blkio_start+0x23/0x30
>  [<ffffffffa00ee940>] raid10_unplug+0xe0/0x160 [raid10]
>  [<ffffffff8136d01a>] blk_flush_plug_list+0xaa/0x250
>  [<ffffffff810aeafd>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff8163b602>] io_schedule+0x82/0x150
>  [<ffffffff81232b3a>] do_blockdev_direct_IO+0x11ca/0x2e50
>  [<ffffffff810914a5>] ? sched_clock_local+0x25/0x90
>  [<ffffffff8122ed00>] ? I_BDEV+0x10/0x10
>  [<ffffffff8123480c>] __blockdev_direct_IO+0x4c/0x50
>  [<ffffffff8122ed00>] ? I_BDEV+0x10/0x10
>  [<ffffffff8122f4ce>] blkdev_direct_IO+0x4e/0x50
>  [<ffffffff8122ed00>] ? I_BDEV+0x10/0x10
>  [<ffffffff8117a095>] generic_file_direct_write+0xb5/0x190
>  [<ffffffff8117a455>] __generic_file_write_iter+0x2e5/0x390
>  [<ffffffff8122f7ff>] blkdev_write_iter+0x2f/0xa0
>  [<ffffffff811ece11>] new_sync_write+0x81/0xb0
>  [<ffffffff811ed61a>] vfs_write+0xba/0x1f0
>  [<ffffffff811ee269>] SyS_write+0x49/0xb0
>  [<ffffffff81645063>] sysenter_dispatch+0x7/0x1f
>  [<ffffffff813a24db>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> ---[ end trace 28ea2673fb871796 ]---
>=20
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
> Cc: stable@vger.kernel.org	# 2.6.39+
>=20
> ---
>  kernel/sched/core.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> Index: linux-2.6/kernel/sched/core.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/kernel/sched/core.c	2015-02-09 11:35:35.169156491 +0100
> +++ linux-2.6/kernel/sched/core.c	2015-02-09 12:11:35.140557980 +0100
> @@ -4397,7 +4397,7 @@ void __sched io_schedule(void)
> =20
>  	delayacct_blkio_start();
>  	atomic_inc(&rq->nr_iowait);
> -	blk_flush_plug(current);
> +	blk_schedule_flush_plug(current);
>  	current->in_iowait =3D 1;
>  	schedule();
>  	current->in_iowait =3D 0;
> @@ -4413,7 +4413,7 @@ long __sched io_schedule_timeout(long ti
> =20
>  	delayacct_blkio_start();
>  	atomic_inc(&rq->nr_iowait);
> -	blk_flush_plug(current);
> +	blk_schedule_flush_plug(current);
>  	current->in_iowait =3D 1;
>  	ret =3D schedule_timeout(timeout);
>  	current->in_iowait =3D 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


Hi,
 I think the current code is correct, but that the warning is wrong.
I believe it should be fixed by adding sched_annotate_sleep() to
blk_flush_plug().
See the separate thread with subject=20
    RAID1 might_sleep() warning on 3.19-rc7

on linux-raid and lkml.

Thanks,
NeilBrown

--Sig_/8IkTFLgZ82huYbfVMTdHg58
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVNlyQTnsnt1WYoG5AQIr+BAAknSc5TA9OFXVDsHnloqx5xnXAuGnjkep
QIehfEowJBt//+lhGYd/CvssfPHcHIjeu3SapzlSJuCE6PDU33r6TYjSljNDBXnL
rym7bGJxdlsnmnI4SsoQMmVse7cUHiAo9YYl2xhUzLsZv4giIa8CZN1PSAStj74t
Pwx50cUMiT1l3vcdvmxbCnlYX/F1C7KZwGaT1J6h+LJwV2GeZ0rqMWogzxLyglFC
dDo0iE56YLTxvMB1w+pOXHLfqNztbmEZbeB246Tg1mI97lLp4V7MxMSD/PpfNzLn
MC+8Hu+XrKYtyfYhI3jBzrXb8kF96QmMAvKv6dkVAe8vVwu1ks4UPkTIs6QQuaj2
kDnJpIXvVsAKKawFybuPbNUabEwJF9PiAcX212phpABw8llZLfonGXnJ+8CnTJ3u
JwjbPbee3JXJVAR+evjSV8CHrflG5Yi72HFvnaRF0Jn3H3HcmgbzunjakUOceSVC
hVs5wdVFTJZb986/BmkEqyLlBhHWefSH7pVthENheeYF3QuqJwHznHaROE8Z9ZMq
Pvn9SmqeH10wlmONz7F/Ppr2t2/bbHPZn4D1MWa18xstmoe9i8r+P4CkeSOiZ8sY
XxurVLf6oXJ2Zeg6paogQDT8nMkQ7mgXti3E3teqiGa+eAjLKKDegdWusm3Evk9o
nRK7cy2p8Kc=
=U266
-----END PGP SIGNATURE-----

--Sig_/8IkTFLgZ82huYbfVMTdHg58--

From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@sysophe.eu>
Subject: Re: [Regression, Bisected] dm-crypt IO failures with active
 slub_debug in 4.12 and later
Date: Mon, 6 Nov 2017 23:29:18 +0100
Message-ID: <20171106232918.25c0ae1a@uranus>
References: <20171102213903.1baa4a10@uranus>
        <20171106161808.GC25073@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171106161808.GC25073@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Milan Broz <gmazyland@gmail.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Mon, 6 Nov 2017 11:18:09 Mike Snitzer wrote:
> On Thu, Nov 02 2017 at  4:39pm -0400, Bruno Pr=C3=A9mont wrote:
> > Hi,
> >=20
> > Between 4.11 and 4.12 I stopped being able to boot my system with root
> > partition encrypted with dm-crypt (issue still present in 4.14-rc7).
> > The system was able to open the dm-crypt device and read-only mount the
> > XFS root partition on it.
> > Later read-write remounting though caused XFS to shutdown the filesystem
> > on IO error.
> >=20
> > Some reports found online indicated a possible coincidence with stack
> > protection or the like as well as use of slub_debug, the latter causing
> > the IO errors to surface for me (I have slub_debug=3DZP on my kernel
> > cmdline).
> >=20
> > I finally got time to go and bisect in order to find the triggering
> > patch. Bisect log:
> >=20
> > # good: [a351e9b9fc24e982ec2f0e76379a49826036da12] Linux 4.11
> > git bisect good a351e9b9fc24e982ec2f0e76379a49826036da12
> > # bad: [6f7da290413ba713f0cdd9ff1a2a9bb129ef4f6c] Linux 4.12
> > git bisect bad 6f7da290413ba713f0cdd9ff1a2a9bb129ef4f6c
> > # bad: [2bd80401743568ced7d303b008ae5298ce77e695] Merge tag 'gpio-v4.12=
-1' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio
> > git bisect bad 2bd80401743568ced7d303b008ae5298ce77e695
> > # good: [8d65b08debc7e62b2c6032d7fe7389d895b92cbc] Merge git://git.kern=
el.org/pub/scm/linux/kernel/git/davem/net-next
> > git bisect good 8d65b08debc7e62b2c6032d7fe7389d895b92cbc
> > # good: [8b03d1ed2c43a2ba5ef3381322ee4515b97381bf] Merge branch 'linux-=
4.12' of git://github.com/skeggsb/linux into drm-next
> > git bisect good 8b03d1ed2c43a2ba5ef3381322ee4515b97381bf
> > # bad: [e897f267c51812bfecec45771a2d835c1a2bdacf] Merge tag 'backlight-=
next-4.12' of git://git.kernel.org/pub/scm/linux/kernel/git/lee/backlight
> > git bisect bad e897f267c51812bfecec45771a2d835c1a2bdacf
> > # good: [46f0537b1ecf672052007c97f102a7e6bf0791e4] Merge branch 'stable=
-4.12' of git://git.infradead.org/users/pcmoore/audit
> > git bisect good 46f0537b1ecf672052007c97f102a7e6bf0791e4
> > # good: [20d5c84bef067b7e804a163e2abca16c47125bad] Merge remote-trackin=
g branches 'asoc/topic/wm8960', 'asoc/topic/wm8978' and 'asoc/topic/zte-tdm=
' into asoc-next
> > git bisect good 20d5c84bef067b7e804a163e2abca16c47125bad
> > # bad: [7b66f13207e60e7c550af730986e77e38a0c69a3] Merge tag 'for-4.12/d=
m-post-merge-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/devi=
ce-mapper/linux-dm
> > git bisect bad 7b66f13207e60e7c550af730986e77e38a0c69a3
> > # good: [dd7a8f5dee81ffb1794df1103f07c63fd4f1d766] md/raid5: make chunk=
_aligned_read() split bios more cleanly.
> > git bisect good dd7a8f5dee81ffb1794df1103f07c63fd4f1d766
> > # bad: [6625d903253eb6f003849823e22d7b8de5bfb5b2] dm integrity: use hex=
2bin instead of open-coded variant
> > git bisect bad 6625d903253eb6f003849823e22d7b8de5bfb5b2
> > # bad: [449b668ce0b9069fcaafa6344c7f10fa2ba9632e] dm cache: set/clear t=
he cache core's dirty_bitset when loading mappings
> > git bisect bad 449b668ce0b9069fcaafa6344c7f10fa2ba9632e
> > # good: [33d2f09fcb357fd1861c4959d1d3505492bf91f8] dm crypt: introduce =
new format of cipher with "capi:" prefix
> > git bisect good 33d2f09fcb357fd1861c4959d1d3505492bf91f8
> > # bad: [ff3af92b4461be773337111daea80bb91b2cd545] dm crypt: use shifts =
instead of sector_div
> > git bisect bad ff3af92b4461be773337111daea80bb91b2cd545
> > # bad: [1aa0efd4210df1c57764b77040a6615bc9b3ac0f] dm integrity: factor =
out create_journal() from dm_integrity_ctr()
> > git bisect bad 1aa0efd4210df1c57764b77040a6615bc9b3ac0f
> > # bad: [8f0009a225171cc1b76a6b443de5137b26e1374b] dm crypt: optionally =
support larger encryption sector size
> > git bisect bad 8f0009a225171cc1b76a6b443de5137b26e1374b
> > # first bad commit: [8f0009a225171cc1b76a6b443de5137b26e1374b] dm crypt=
: optionally support larger encryption sector size
> >=20
> > In order to test on 4.12 I had to revert the following commits,
> > the first two having been applied on top of bad commit:
> >   583fe7474c05ee5523e14ef791ea59604cd846dc (dm crypt: fix large block i=
ntegrity support)
> >   ff3af92b4461be773337111daea80bb91b2cd545 (dm crypt: use shifts instea=
d of sector_div)
> >   8f0009a225171cc1b76a6b443de5137b26e1374b (dm crypt: optionally suppor=
t larger encryption sector size)
> >=20
> > From looking at 8f0009a225171cc1b76a6b443de5137b26e1374b I can't spot
> > direct cause though I assume there might be a mismatch in memory
> > allocation versus access sizes as a consequence of support for larger
> > encryption sector size (someplace 512 byte versus page size access
> > tripping on memory poison?). =20
>=20
> Thanks for bisecting this.
>=20
> Can you apply the following debug patch to see if either of these newer
> -EIO returns (introduced by commit 8f0009a225) are causing you problems
> for some reason?
>=20
> Thanks
>=20
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 05acc42..daefe37 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1056,7 +1056,7 @@ static int crypt_convert_block_aead(struct crypt_co=
nfig *cc,
>  	BUG_ON(cc->integrity_iv_size && cc->integrity_iv_size !=3D cc->iv_size);
> =20
>  	/* Reject unexpected unaligned bio. */
> -	if (unlikely(bv_in.bv_offset & (cc->sector_size - 1)))
> +	if (WARN_ON_ONCE(unlikely(bv_in.bv_offset & (cc->sector_size - 1)))))
>  		return -EIO;
> =20
>  	dmreq =3D dmreq_of_req(cc, req);
> @@ -1149,7 +1149,7 @@ static int crypt_convert_block_skcipher(struct cryp=
t_config *cc,
>  	int r =3D 0;
> =20
>  	/* Reject unexpected unaligned bio. */
> -	if (unlikely(bv_in.bv_offset & (cc->sector_size - 1)))
> +	if (WARN_ON_ONCE(unlikely(bv_in.bv_offset & (cc->sector_size - 1))))
>  		return -EIO;
> =20
>  	dmreq =3D dmreq_of_req(cc, req);

This second one triggers:
[  143.238220] ------------[ cut here ]------------
[  143.238228] WARNING: CPU: 1 PID: 379 at /usr/src/linux-git/drivers/md/dm=
-crypt.c:1158 crypt_convert+0xd53/0x1070
[  143.238229] Modules linked in:
[  143.238233] CPU: 1 PID: 379 Comm: kworker/u17:3 Not tainted 4.12.14+ #2
[  143.238234] Hardware name: FUJITSU LIFEBOOK U904/FJNB27D, BIOS Version 1=
.09 03/20/2014
[  143.238236] Workqueue: kcryptd kcryptd_crypt
[  143.238238] task: ffff982ccdf628c0 task.stack: ffffb3b5c0bb8000
[  143.238240] RIP: 0010:crypt_convert+0xd53/0x1070
[  143.238242] RSP: 0018:ffffb3b5c0bbbd28 EFLAGS: 00010202
[  143.238243] RAX: 00000000000001ff RBX: ffff982ccbebafe0 RCX: ffffd8d08a2=
fc880
[  143.238244] RDX: 0000000000000868 RSI: ffff982ccbebaf40 RDI: 00000000000=
00000
[  143.238245] RBP: ffffb3b5c0bbbdd8 R08: 0000000000000000 R09: 00000000000=
00018
[  143.238246] R10: ffffb3b5c0073e60 R11: ffffd8d08a2fc880 R12: 00000000000=
00000
[  143.238247] R13: ffff982ccbebaf40 R14: ffff982ccdf5f308 R15: ffff982cd00=
dd288
[  143.238248] FS:  0000000000000000(0000) GS:ffff982cde240000(0000) knlGS:=
0000000000000000
[  143.238249] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  143.238251] CR2: 00007f45350793c4 CR3: 000000006b20a000 CR4: 00000000001=
406e0
[  143.238251] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  143.238252] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[  143.238253] Call Trace:
[  143.238256]  kcryptd_crypt+0x32c/0x3a0
[  143.238261]  process_one_work+0x11c/0x340
[  143.238264]  worker_thread+0x43/0x3e0
[  143.238267]  kthread+0xfe/0x140
[  143.238269]  ? create_worker+0x1a0/0x1a0
[  143.238271]  ? kthread_create_on_node+0x40/0x40
[  143.238275]  ret_from_fork+0x22/0x30
[  143.238276] Code: ff ff 49 8b 7e 10 be 00 00 40 01 e8 a8 2b 9c ff 49 89 =
45 70 e9 42 f3 ff ff 48 8b 75 c0 48 8b 7d c8 e8 52 34 c1 ff e9 d2 fa ff ff =
<0f> ff e9 0f ff ff ff 41 3b 86 d8 00 00 00 0f 84 c2 f3 ff ff 0f
[  143.238306] ---[ end trace 81f0c82a360b9fb6 ]---
[  143.238369] XFS (dm-1): metadata I/O error: block 0x2 ("xfs_trans_read_b=
uf_map") error 5 numblks 1
[  143.238373] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 315 =
of file /usr/src/linux-git/fs/xfs/xfs_trans_buf.c.  Return address =3D 0xff=
ffffff9734a15c
[  143.238378] XFS (dm-1): I/O Error Detected. Shutting down filesystem
[  143.238378] XFS (dm-1): Please umount the filesystem and rectify the pro=
blem(s)

(your patch, compile-fixed, applied on 4.12.14 with offset=3D6)

Bruno

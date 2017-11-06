From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-crypt, dm-integrity: allow unaligned bv_offset (was:
 [Regression, Bisected] dm-crypt IO failures with active slub_debug in 4.12
 and later)
Date: Mon, 6 Nov 2017 18:57:15 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1711061852380.23082@file01.intranet.prod.int.rdu2.redhat.com>
References: <20171102213903.1baa4a10@uranus> <20171106161808.GC25073@redhat.com> <20171106232918.25c0ae1a@uranus>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="185206533-154422859-1510012638=:23082"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171106232918.25c0ae1a@uranus>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@sysophe.eu>
Cc: Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185206533-154422859-1510012638=:23082
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Mon, 6 Nov 2017, Bruno Prémont wrote:

> On Mon, 6 Nov 2017 11:18:09 Mike Snitzer wrote:
> > On Thu, Nov 02 2017 at  4:39pm -0400, Bruno Prémont wrote:
> > > Hi,
> > > 
> > > Between 4.11 and 4.12 I stopped being able to boot my system with root
> > > partition encrypted with dm-crypt (issue still present in 4.14-rc7).
> > > The system was able to open the dm-crypt device and read-only mount the
> > > XFS root partition on it.
> > > Later read-write remounting though caused XFS to shutdown the filesystem
> > > on IO error.
> > > 
> > > Some reports found online indicated a possible coincidence with stack
> > > protection or the like as well as use of slub_debug, the latter causing
> > > the IO errors to surface for me (I have slub_debug=ZP on my kernel
> > > cmdline).
> > > 
> > > I finally got time to go and bisect in order to find the triggering
> > > patch. Bisect log:
> > > 
> > > # good: [a351e9b9fc24e982ec2f0e76379a49826036da12] Linux 4.11
> > > git bisect good a351e9b9fc24e982ec2f0e76379a49826036da12
> > > # bad: [6f7da290413ba713f0cdd9ff1a2a9bb129ef4f6c] Linux 4.12
> > > git bisect bad 6f7da290413ba713f0cdd9ff1a2a9bb129ef4f6c
> > > # bad: [2bd80401743568ced7d303b008ae5298ce77e695] Merge tag 'gpio-v4.12-1' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio
> > > git bisect bad 2bd80401743568ced7d303b008ae5298ce77e695
> > > # good: [8d65b08debc7e62b2c6032d7fe7389d895b92cbc] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
> > > git bisect good 8d65b08debc7e62b2c6032d7fe7389d895b92cbc
> > > # good: [8b03d1ed2c43a2ba5ef3381322ee4515b97381bf] Merge branch 'linux-4.12' of git://github.com/skeggsb/linux into drm-next
> > > git bisect good 8b03d1ed2c43a2ba5ef3381322ee4515b97381bf
> > > # bad: [e897f267c51812bfecec45771a2d835c1a2bdacf] Merge tag 'backlight-next-4.12' of git://git.kernel.org/pub/scm/linux/kernel/git/lee/backlight
> > > git bisect bad e897f267c51812bfecec45771a2d835c1a2bdacf
> > > # good: [46f0537b1ecf672052007c97f102a7e6bf0791e4] Merge branch 'stable-4.12' of git://git.infradead.org/users/pcmoore/audit
> > > git bisect good 46f0537b1ecf672052007c97f102a7e6bf0791e4
> > > # good: [20d5c84bef067b7e804a163e2abca16c47125bad] Merge remote-tracking branches 'asoc/topic/wm8960', 'asoc/topic/wm8978' and 'asoc/topic/zte-tdm' into asoc-next
> > > git bisect good 20d5c84bef067b7e804a163e2abca16c47125bad
> > > # bad: [7b66f13207e60e7c550af730986e77e38a0c69a3] Merge tag 'for-4.12/dm-post-merge-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm
> > > git bisect bad 7b66f13207e60e7c550af730986e77e38a0c69a3
> > > # good: [dd7a8f5dee81ffb1794df1103f07c63fd4f1d766] md/raid5: make chunk_aligned_read() split bios more cleanly.
> > > git bisect good dd7a8f5dee81ffb1794df1103f07c63fd4f1d766
> > > # bad: [6625d903253eb6f003849823e22d7b8de5bfb5b2] dm integrity: use hex2bin instead of open-coded variant
> > > git bisect bad 6625d903253eb6f003849823e22d7b8de5bfb5b2
> > > # bad: [449b668ce0b9069fcaafa6344c7f10fa2ba9632e] dm cache: set/clear the cache core's dirty_bitset when loading mappings
> > > git bisect bad 449b668ce0b9069fcaafa6344c7f10fa2ba9632e
> > > # good: [33d2f09fcb357fd1861c4959d1d3505492bf91f8] dm crypt: introduce new format of cipher with "capi:" prefix
> > > git bisect good 33d2f09fcb357fd1861c4959d1d3505492bf91f8
> > > # bad: [ff3af92b4461be773337111daea80bb91b2cd545] dm crypt: use shifts instead of sector_div
> > > git bisect bad ff3af92b4461be773337111daea80bb91b2cd545
> > > # bad: [1aa0efd4210df1c57764b77040a6615bc9b3ac0f] dm integrity: factor out create_journal() from dm_integrity_ctr()
> > > git bisect bad 1aa0efd4210df1c57764b77040a6615bc9b3ac0f
> > > # bad: [8f0009a225171cc1b76a6b443de5137b26e1374b] dm crypt: optionally support larger encryption sector size
> > > git bisect bad 8f0009a225171cc1b76a6b443de5137b26e1374b
> > > # first bad commit: [8f0009a225171cc1b76a6b443de5137b26e1374b] dm crypt: optionally support larger encryption sector size
> > > 
> > > In order to test on 4.12 I had to revert the following commits,
> > > the first two having been applied on top of bad commit:
> > >   583fe7474c05ee5523e14ef791ea59604cd846dc (dm crypt: fix large block integrity support)
> > >   ff3af92b4461be773337111daea80bb91b2cd545 (dm crypt: use shifts instead of sector_div)
> > >   8f0009a225171cc1b76a6b443de5137b26e1374b (dm crypt: optionally support larger encryption sector size)
> > > 
> > > From looking at 8f0009a225171cc1b76a6b443de5137b26e1374b I can't spot
> > > direct cause though I assume there might be a mismatch in memory
> > > allocation versus access sizes as a consequence of support for larger
> > > encryption sector size (someplace 512 byte versus page size access
> > > tripping on memory poison?).  
> > 
> > Thanks for bisecting this.
> > 
> > Can you apply the following debug patch to see if either of these newer
> > -EIO returns (introduced by commit 8f0009a225) are causing you problems
> > for some reason?
> > 
> > Thanks
> > 
> > diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> > index 05acc42..daefe37 100644
> > --- a/drivers/md/dm-crypt.c
> > +++ b/drivers/md/dm-crypt.c
> > @@ -1056,7 +1056,7 @@ static int crypt_convert_block_aead(struct crypt_config *cc,
> >  	BUG_ON(cc->integrity_iv_size && cc->integrity_iv_size != cc->iv_size);
> >  
> >  	/* Reject unexpected unaligned bio. */
> > -	if (unlikely(bv_in.bv_offset & (cc->sector_size - 1)))
> > +	if (WARN_ON_ONCE(unlikely(bv_in.bv_offset & (cc->sector_size - 1)))))
> >  		return -EIO;
> >  
> >  	dmreq = dmreq_of_req(cc, req);
> > @@ -1149,7 +1149,7 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
> >  	int r = 0;
> >  
> >  	/* Reject unexpected unaligned bio. */
> > -	if (unlikely(bv_in.bv_offset & (cc->sector_size - 1)))
> > +	if (WARN_ON_ONCE(unlikely(bv_in.bv_offset & (cc->sector_size - 1))))
> >  		return -EIO;
> >  
> >  	dmreq = dmreq_of_req(cc, req);
> 
> This second one triggers:
> [  143.238220] ------------[ cut here ]------------
> [  143.238228] WARNING: CPU: 1 PID: 379 at /usr/src/linux-git/drivers/md/dm-crypt.c:1158 crypt_convert+0xd53/0x1070
> [  143.238229] Modules linked in:
> [  143.238233] CPU: 1 PID: 379 Comm: kworker/u17:3 Not tainted 4.12.14+ #2
> [  143.238234] Hardware name: FUJITSU LIFEBOOK U904/FJNB27D, BIOS Version 1.09 03/20/2014
> [  143.238236] Workqueue: kcryptd kcryptd_crypt
> [  143.238238] task: ffff982ccdf628c0 task.stack: ffffb3b5c0bb8000
> [  143.238240] RIP: 0010:crypt_convert+0xd53/0x1070
> [  143.238242] RSP: 0018:ffffb3b5c0bbbd28 EFLAGS: 00010202
> [  143.238243] RAX: 00000000000001ff RBX: ffff982ccbebafe0 RCX: ffffd8d08a2fc880
> [  143.238244] RDX: 0000000000000868 RSI: ffff982ccbebaf40 RDI: 0000000000000000
> [  143.238245] RBP: ffffb3b5c0bbbdd8 R08: 0000000000000000 R09: 0000000000000018
> [  143.238246] R10: ffffb3b5c0073e60 R11: ffffd8d08a2fc880 R12: 0000000000000000
> [  143.238247] R13: ffff982ccbebaf40 R14: ffff982ccdf5f308 R15: ffff982cd00dd288
> [  143.238248] FS:  0000000000000000(0000) GS:ffff982cde240000(0000) knlGS:0000000000000000
> [  143.238249] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  143.238251] CR2: 00007f45350793c4 CR3: 000000006b20a000 CR4: 00000000001406e0
> [  143.238251] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  143.238252] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  143.238253] Call Trace:
> [  143.238256]  kcryptd_crypt+0x32c/0x3a0
> [  143.238261]  process_one_work+0x11c/0x340
> [  143.238264]  worker_thread+0x43/0x3e0
> [  143.238267]  kthread+0xfe/0x140
> [  143.238269]  ? create_worker+0x1a0/0x1a0
> [  143.238271]  ? kthread_create_on_node+0x40/0x40
> [  143.238275]  ret_from_fork+0x22/0x30
> [  143.238276] Code: ff ff 49 8b 7e 10 be 00 00 40 01 e8 a8 2b 9c ff 49 89 45 70 e9 42 f3 ff ff 48 8b 75 c0 48 8b 7d c8 e8 52 34 c1 ff e9 d2 fa ff ff <0f> ff e9 0f ff ff ff 41 3b 86 d8 00 00 00 0f 84 c2 f3 ff ff 0f
> [  143.238306] ---[ end trace 81f0c82a360b9fb6 ]---
> [  143.238369] XFS (dm-1): metadata I/O error: block 0x2 ("xfs_trans_read_buf_map") error 5 numblks 1
> [  143.238373] XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 315 of file /usr/src/linux-git/fs/xfs/xfs_trans_buf.c.  Return address = 0xffffffff9734a15c
> [  143.238378] XFS (dm-1): I/O Error Detected. Shutting down filesystem
> [  143.238378] XFS (dm-1): Please umount the filesystem and rectify the problem(s)
> 
> (your patch, compile-fixed, applied on 4.12.14 with offset=6)
> 
> Bruno

Hi

I've made this patch for this bug. Try it.

Mikulas



From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-crypt, dm-integrity: allow unaligned bv_offset

When slub_debug is enabled, kmalloc returns unaligned memory. XFS uses
this unaligned memory for its buffers (if an unaligned buffer crosses a
page, XFS frees it and allocates a full page instead - see the function
xfs_buf_allocate_memory).

dm-crypt and dm-integrity contain checks if bv_offset is aligned on page
size and these checks fail with slub_debug and XFS.

This patch fixes the bug by removing the bv_offset checks. In dm-crypt, we 
check if bv_len is aligned instead of bv_offset (this check should be 
sufficient to prevent overruns if a bio with too small bv_len is 
received). In dm-integrity, we remove the check for bv_offset and leave 
only the check for bv_len.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v4.12+
Fixes: 8f0009a22517 ("dm crypt: optionally support larger encryption sector size")
Fixes: 7eada909bfd7 ("dm: add integrity target")

---
 drivers/md/dm-crypt.c     |    4 ++--
 drivers/md/dm-integrity.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c
+++ linux-2.6/drivers/md/dm-crypt.c
@@ -1075,7 +1075,7 @@ static int crypt_convert_block_aead(stru
 	BUG_ON(cc->integrity_iv_size && cc->integrity_iv_size != cc->iv_size);
 
 	/* Reject unexpected unaligned bio. */
-	if (unlikely(bv_in.bv_offset & (cc->sector_size - 1)))
+	if (unlikely(bv_in.bv_len & (cc->sector_size - 1)))
 		return -EIO;
 
 	dmreq = dmreq_of_req(cc, req);
@@ -1168,7 +1168,7 @@ static int crypt_convert_block_skcipher(
 	int r = 0;
 
 	/* Reject unexpected unaligned bio. */
-	if (unlikely(bv_in.bv_offset & (cc->sector_size - 1)))
+	if (unlikely(bv_in.bv_len & (cc->sector_size - 1)))
 		return -EIO;
 
 	dmreq = dmreq_of_req(cc, req);
Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c
+++ linux-2.6/drivers/md/dm-integrity.c
@@ -1376,7 +1376,7 @@ static int dm_integrity_map(struct dm_ta
 		struct bvec_iter iter;
 		struct bio_vec bv;
 		bio_for_each_segment(bv, bio, iter) {
-			if (unlikely((bv.bv_offset | bv.bv_len) & ((ic->sectors_per_block << SECTOR_SHIFT) - 1))) {
+			if (unlikely(bv.bv_len & ((ic->sectors_per_block << SECTOR_SHIFT) - 1))) {
 				DMERR("Bio vector (%u,%u) is not aligned on %u-sector boundary",
 					bv.bv_offset, bv.bv_len, ic->sectors_per_block);
 				return DM_MAPIO_KILL;
--185206533-154422859-1510012638=:23082--

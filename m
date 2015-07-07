From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] bio integrity: do not assume bio_integrity_pool
 exists if bioset exists
Date: Tue, 7 Jul 2015 01:00:15 -0400
Message-ID: <20150707050015.GB10269@redhat.com>
References: <20150701165740.GA1573@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150701165740.GA1573@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@kernel.dk
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, mpatocka@redhat.com
List-Id: dm-devel.ids


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 01 2015 at 12:57pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> bio_integrity_alloc() and bio_integrity_free() assume that if a bio was
> allocated from a bioset that that bioset also had its bio_integrity_pool
> allocated using bioset_integrity_create().  This is a very bad
> assumption given that bioset_create() and bioset_integrity_create() are
> completely disjoint.  Not all callers of bioset_create() have been
> trained to also call bioset_integrity_create() -- and they may not care
> to be.
> 
> Fix this by falling back to kmalloc'ing 'struct bio_integrity_payload'
> rather than force all bioset consumers to (wastefully) preallocate a
> bio_integrity_pool that they very likely won't actually need (given the
> niche nature of the current block integrity support).
> 
> Otherwise, a NULL pointer "Kernel BUG" with a trace like the following
> will be observed (as seen on s390x using zfcp storage) because dm-io
> doesn't use bioset_integrity_create() when creating its bioset:
> 
>     [  791.643338] Call Trace:
>     [  791.643339] ([<00000003df98b848>] 0x3df98b848)
>     [  791.643341]  [<00000000002c5de8>] bio_integrity_alloc+0x48/0xf8
>     [  791.643348]  [<00000000002c6486>] bio_integrity_prep+0xae/0x2f0
>     [  791.643349]  [<0000000000371e38>] blk_queue_bio+0x1c8/0x3d8
>     [  791.643355]  [<000000000036f8d0>] generic_make_request+0xc0/0x100
>     [  791.643357]  [<000000000036f9b2>] submit_bio+0xa2/0x198
>     [  791.643406]  [<000003ff801f9774>] dispatch_io+0x15c/0x3b0 [dm_mod]
>     [  791.643419]  [<000003ff801f9b3e>] dm_io+0x176/0x2f0 [dm_mod]
>     [  791.643423]  [<000003ff8074b28a>] do_reads+0x13a/0x1a8 [dm_mirror]
>     [  791.643425]  [<000003ff8074b43a>] do_mirror+0x142/0x298 [dm_mirror]
>     [  791.643428]  [<0000000000154fca>] process_one_work+0x18a/0x3f8
>     [  791.643432]  [<000000000015598a>] worker_thread+0x132/0x3b0
>     [  791.643435]  [<000000000015d49a>] kthread+0xd2/0xd8
>     [  791.643438]  [<00000000005bc0ca>] kernel_thread_starter+0x6/0xc
>     [  791.643446]  [<00000000005bc0c4>] kernel_thread_starter+0x0/0xc
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Cc: stable@vger.kernel.org
> ---
>  block/bio-integrity.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> NOTE: this serves as a more generic fix in the block layer rather than
> the dm-io specific fix which isn't ideal (due to potential for memory
> waste), see:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=17dbe96d4f8a6f87004e6cfb5944872dfe2edb9f
> 
> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> index 0436c21..719b715 100644
> --- a/block/bio-integrity.c
> +++ b/block/bio-integrity.c
> @@ -51,7 +51,7 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
>  	unsigned long idx = BIO_POOL_NONE;
>  	unsigned inline_vecs;
>  
> -	if (!bs) {
> +	if (!bs || !bs->bio_integrity_pool) {
>  		bip = kmalloc(sizeof(struct bio_integrity_payload) +
>  			      sizeof(struct bio_vec) * nr_vecs, gfp_mask);
>  		inline_vecs = nr_vecs;
> @@ -104,7 +104,7 @@ void bio_integrity_free(struct bio *bio)
>  		kfree(page_address(bip->bip_vec->bv_page) +
>  		      bip->bip_vec->bv_offset);
>  
> -	if (bs) {
> +	if (bs && bs->bio_integrity_pool) {
>  		if (bip->bip_slab != BIO_POOL_NONE)
>  			bvec_free(bs->bvec_integrity_pool, bip->bip_vec,
>  				  bip->bip_slab);
> -- 
> 2.3.2 (Apple Git-55)
> 
> 

Both the above block patch and the referenced dm-io patch fix the
following issue.  I really prefer the block fix over the dm-io one.  As
such I'd like to see it go upstream during 4.2-rc.

Jens, what do you think?

Here is an updated NULL pointer trace using 4.2-rc1 (which is easily hit
using the attached reproducer script):

[  239.425111] BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
[  239.426010] IP: [<ffffffff811b2bb0>] mempool_alloc+0x60/0x180
[  239.426010] PGD 0
[  239.426010] Oops: 0000 [#1] SMP
[  239.426010] Modules linked in: dm_mirror dm_region_hash dm_log scsi_debug sg nfsv3 nfs fscache crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel glue_helper lrw gf128mul ablk_helper dm_mod cryptd pcspkr serio_raw virtio_balloon 8139too i2c_piix4 nfsd auth_rpcgss nfs_acl lockd grace sunrpc ext4 mbcache jbd2 ata_generic sd_mod pata_acpi cirrus syscopyarea sysfillrect sysimgblt drm_kms_helper virtio_scsi ttm virtio_blk drm ata_piix libata virtio_pci virtio_ring 8139cp virtio mii i2c_core floppy
[  239.426010] CPU: 2 PID: 134 Comm: kworker/2:2 Not tainted 4.2.0-rc1+ #59
[  239.426010] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  239.426010] Workqueue: kcopyd do_work [dm_mod]
[  239.426010] task: ffff88011a701bc0 ti: ffff880036a10000 task.ti: ffff880036a10000
[  239.426010] RIP: 0010:[<ffffffff811b2bb0>]  [<ffffffff811b2bb0>] mempool_alloc+0x60/0x180
[  239.426010] RSP: 0018:ffff880036a13878  EFLAGS: 00010206
[  239.426010] RAX: ffff880036a13888 RBX: ffff88011a701bc0 RCX: 0000000000000000
[  239.426010] RDX: 0000000000000086 RSI: ffffffff81a88940 RDI: 0000000000000246
[  239.426010] RBP: ffff880036a138e8 R08: 000000000001a9b0 R09: 0000000000000080
[  239.426010] R10: ffff88011b001500 R11: 0000000000000000 R12: 0000000000000060
[  239.426010] R13: ffff880036a138a0 R14: 0000000000011200 R15: 0000000000000000
[  239.426010] FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:0000000000000000
[  239.426010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  239.426010] CR2: 0000000000000048 CR3: 00000000d8797000 CR4: 00000000000407e0
[  239.426010] Stack:
[  239.426010]  0000000000000001 0001121000000010 ffffffff81a88940 ffff88011b001500
[  239.426010]  ffff880036a138c8 ffffffff810e01cd 00000000000004f2 00000000627d6696
[  239.426010]  0000000000000246 0000000000000400 ffff8800da8cfd00 0000000000000010
[  239.426010] Call Trace:
[  239.426010]  [<ffffffff810e01cd>] ? __lock_is_held+0x4d/0x70
[  239.426010]  [<ffffffff8136b00f>] bio_integrity_alloc+0x4f/0x1d0
[  239.426010]  [<ffffffff8136b803>] bio_integrity_prep+0xc3/0x220
[  239.426010]  [<ffffffff8134c56f>] blk_sq_make_request+0x10f/0x570
[  239.426010]  [<ffffffff810e01cd>] ? __lock_is_held+0x4d/0x70
[  239.426010]  [<ffffffff8133b236>] generic_make_request+0xd6/0x110
[  239.426010]  [<ffffffff8133b2e7>] submit_bio+0x77/0x150
[  239.426010]  [<ffffffff81335a3f>] ? bio_alloc_bioset+0x1df/0x2e0
[  239.426010]  [<ffffffffa036cd48>] dispatch_io+0x1a8/0x3a0 [dm_mod]
[  239.426010]  [<ffffffffa036c840>] ? dm_copy_name_and_uuid+0xc0/0xc0 [dm_mod]
[  239.426010]  [<ffffffffa036c870>] ? list_get_page+0x30/0x30 [dm_mod]
[  239.426010]  [<ffffffffa036d7eb>] ? run_io_job+0x9b/0x190 [dm_mod]
[  239.426010]  [<ffffffffa036d4c0>] ? dm_kcopyd_do_callback+0x50/0x50 [dm_mod]
[  239.426010]  [<ffffffffa036d183>] dm_io+0x103/0x210 [dm_mod]
[  239.426010]  [<ffffffffa036c840>] ? dm_copy_name_and_uuid+0xc0/0xc0 [dm_mod]
[  239.426010]  [<ffffffffa036c870>] ? list_get_page+0x30/0x30 [dm_mod]
[  239.426010]  [<ffffffffa036d834>] run_io_job+0xe4/0x190 [dm_mod]
[  239.426010]  [<ffffffffa036d4c0>] ? dm_kcopyd_do_callback+0x50/0x50 [dm_mod]
[  239.426010]  [<ffffffffa036da7a>] process_jobs+0x5a/0x100 [dm_mod]
[  239.426010]  [<ffffffffa036d750>] ? segment_complete+0x170/0x170 [dm_mod]
[  239.426010]  [<ffffffffa036db91>] do_work+0x71/0xa0 [dm_mod]
[  239.426010]  [<ffffffff810a79d7>] process_one_work+0x1e7/0x7e0
[  239.426010]  [<ffffffff810a794a>] ? process_one_work+0x15a/0x7e0
[  239.426010]  [<ffffffff810a80e4>] worker_thread+0x114/0x460
[  239.426010]  [<ffffffff810a7fd0>] ? process_one_work+0x7e0/0x7e0
[  239.426010]  [<ffffffff810aebd7>] kthread+0x107/0x120
[  239.426010]  [<ffffffff817065f0>] ? _raw_spin_unlock_irq+0x30/0x50
[  239.426010]  [<ffffffff810aead0>] ? kthread_create_on_node+0x240/0x240
[  239.426010]  [<ffffffff8170731f>] ret_from_fork+0x3f/0x70
[  239.426010]  [<ffffffff810aead0>] ? kthread_create_on_node+0x240/0x240
[  239.426010] Code: d8 83 e3 af 4d 8d 67 60 0d 00 12 01 00 41 89 de 89 45 9c 48 8d 45 a0 41 81 ce 00 12 01 00 65 48 8b 1c 25 00 ba 00 00 4c 8d 68 18 <49> 8b 77 48 44 89 f7 41 ff 57 50 48 85 c0 74 45 48 8b 4d c8 65
[  239.426010] RIP  [<ffffffff811b2bb0>] mempool_alloc+0x60/0x180
[  239.426010]  RSP <ffff880036a13878>
[  239.426010] CR2: 0000000000000048
[  239.426010] ---[ end trace a4a18906f4031b09 ]---

--azLHFNyN32YCQGCU
Content-Type: application/x-sh
Content-Disposition: attachment; filename="bip_bioset_NULL_ptr.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A=0Aset -xv=0A=0A# adjust DEV to be whatever scsi_debug will c=
reate with the following modprobe:=0ADEV=3D/dev/sde=0Amodprobe scsi_debug d=
ev_size_mb=3D100 num_tgts=3D1 dix=3D17 dif=3D1=0Apvcreate $DEV=0Avgcreate d=
if $DEV=0Alvcreate --type mirror --alloc anywhere --corelog -m1 -L 40M dif=
=0A=0Alsblk=0Admsetup table=0A=0A# must reload the "mirror" table so that i=
t uses the scsi-debug device directly=0A# (rather than through intermediate=
 DM linear devices):=0Aecho "0 81920 mirror core 1 1024 2 $DEV 2048 $DEV 83=
968 1 handle_errors" | dmsetup load dif-lvol0=0Admsetup suspend dif-lvol0=
=0Admsetup resume dif-lvol0=0A=0Add if=3D/dev/zero of=3D/dev/dif/lvol0 bs=
=3D8K oflag=3Ddirect=0A=0Alvremove -f dif/lvol0=0Avgremove dif=0Apvremove $=
DEV=0A=0Asleep 1=0Amodprobe -r scsi_debug=0Amodprobe -r dm-mirror=0A
--azLHFNyN32YCQGCU--

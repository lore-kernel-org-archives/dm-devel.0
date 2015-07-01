From: Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH] bio integrity: do not assume bio_integrity_pool exists
 if bioset exists
Date: Wed, 1 Jul 2015 12:57:40 -0400
Message-ID: <20150701165740.GA1573@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org, mpatocka@redhat.com
List-Id: dm-devel.ids

bio_integrity_alloc() and bio_integrity_free() assume that if a bio was
allocated from a bioset that that bioset also had its bio_integrity_pool
allocated using bioset_integrity_create().  This is a very bad
assumption given that bioset_create() and bioset_integrity_create() are
completely disjoint.  Not all callers of bioset_create() have been
trained to also call bioset_integrity_create() -- and they may not care
to be.

Fix this by falling back to kmalloc'ing 'struct bio_integrity_payload'
rather than force all bioset consumers to (wastefully) preallocate a
bio_integrity_pool that they very likely won't actually need (given the
niche nature of the current block integrity support).

Otherwise, a NULL pointer "Kernel BUG" with a trace like the following
will be observed (as seen on s390x using zfcp storage) because dm-io
doesn't use bioset_integrity_create() when creating its bioset:

    [  791.643338] Call Trace:
    [  791.643339] ([<00000003df98b848>] 0x3df98b848)
    [  791.643341]  [<00000000002c5de8>] bio_integrity_alloc+0x48/0xf8
    [  791.643348]  [<00000000002c6486>] bio_integrity_prep+0xae/0x2f0
    [  791.643349]  [<0000000000371e38>] blk_queue_bio+0x1c8/0x3d8
    [  791.643355]  [<000000000036f8d0>] generic_make_request+0xc0/0x100
    [  791.643357]  [<000000000036f9b2>] submit_bio+0xa2/0x198
    [  791.643406]  [<000003ff801f9774>] dispatch_io+0x15c/0x3b0 [dm_mod]
    [  791.643419]  [<000003ff801f9b3e>] dm_io+0x176/0x2f0 [dm_mod]
    [  791.643423]  [<000003ff8074b28a>] do_reads+0x13a/0x1a8 [dm_mirror]
    [  791.643425]  [<000003ff8074b43a>] do_mirror+0x142/0x298 [dm_mirror]
    [  791.643428]  [<0000000000154fca>] process_one_work+0x18a/0x3f8
    [  791.643432]  [<000000000015598a>] worker_thread+0x132/0x3b0
    [  791.643435]  [<000000000015d49a>] kthread+0xd2/0xd8
    [  791.643438]  [<00000000005bc0ca>] kernel_thread_starter+0x6/0xc
    [  791.643446]  [<00000000005bc0c4>] kernel_thread_starter+0x0/0xc

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org
---
 block/bio-integrity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

NOTE: this serves as a more generic fix in the block layer rather than
the dm-io specific fix which isn't ideal (due to potential for memory
waste), see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=17dbe96d4f8a6f87004e6cfb5944872dfe2edb9f

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 0436c21..719b715 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -51,7 +51,7 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
 	unsigned long idx = BIO_POOL_NONE;
 	unsigned inline_vecs;
 
-	if (!bs) {
+	if (!bs || !bs->bio_integrity_pool) {
 		bip = kmalloc(sizeof(struct bio_integrity_payload) +
 			      sizeof(struct bio_vec) * nr_vecs, gfp_mask);
 		inline_vecs = nr_vecs;
@@ -104,7 +104,7 @@ void bio_integrity_free(struct bio *bio)
 		kfree(page_address(bip->bip_vec->bv_page) +
 		      bip->bip_vec->bv_offset);
 
-	if (bs) {
+	if (bs && bs->bio_integrity_pool) {
 		if (bip->bip_slab != BIO_POOL_NONE)
 			bvec_free(bs->bvec_integrity_pool, bip->bip_vec,
 				  bip->bip_slab);
-- 
2.3.2 (Apple Git-55)

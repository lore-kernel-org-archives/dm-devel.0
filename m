From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] bio-integrity: Fix regression if profile verify_fn is NULL
Date: Wed,  9 Aug 2017 17:47:26 +0200
Message-ID: <20170809154727.2085-2-hch@lst.de>
References: <20170809154727.2085-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170809154727.2085-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: mpatocka@redhat.com, gmazyland@gmail.com, martin.petersen@oracle.com, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

From: Milan Broz <gmazyland@gmail.com>

In dm-integrity target we register integrity profile that have
both generate_fn and verify_fn callbacks set to NULL.

This is used if dm-integrity is stacked under a dm-crypt device
for authenticated encryption (integrity payload contains authentication
tag and IV seed).

In this case the verification is done through own crypto API
processing inside dm-crypt; integrity profile is only holder
of these data. (And memory is owned by dm-crypt as well.)

After the commit (and previous changes)
  Commit 7c20f11680a441df09de7235206f70115fbf6290
  Author: Christoph Hellwig <hch@lst.de>
  Date:   Mon Jul 3 16:58:43 2017 -0600

    bio-integrity: stop abusing bi_end_io

we get this crash:

: BUG: unable to handle kernel NULL pointer dereference at   (null)
: IP:   (null)
: *pde = 00000000
...
:
: Workqueue: kintegrityd bio_integrity_verify_fn
: task: f48ae180 task.stack: f4b5c000
: EIP:   (null)
: EFLAGS: 00210286 CPU: 0
: EAX: f4b5debc EBX: 00001000 ECX: 00000001 EDX: 00000000
: ESI: 00001000 EDI: ed25f000 EBP: f4b5dee8 ESP: f4b5dea4
:  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
: CR0: 80050033 CR2: 00000000 CR3: 32823000 CR4: 001406d0
: Call Trace:
:  ? bio_integrity_process+0xe3/0x1e0
:  bio_integrity_verify_fn+0xea/0x150
:  process_one_work+0x1c7/0x5c0
:  worker_thread+0x39/0x380
:  kthread+0xd6/0x110
:  ? process_one_work+0x5c0/0x5c0
:  ? kthread_worker_fn+0x100/0x100
:  ? kthread_worker_fn+0x100/0x100
:  ret_from_fork+0x19/0x24
: Code:  Bad EIP value.
: EIP:   (null) SS:ESP: 0068:f4b5dea4
: CR2: 0000000000000000

Patch just skip the whole verify workqueue if verify_fn is set to NULL.

Fixes: 7c20f116 ("bio-integrity: stop abusing bi_end_io")
Signed-off-by: Milan Broz <gmazyland@gmail.com>
[hch: trivial whitespace fix]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 83e92beb3c9f..dcfb968c8259 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -387,7 +387,10 @@ static void bio_integrity_verify_fn(struct work_struct *work)
  */
 bool __bio_integrity_endio(struct bio *bio)
 {
-	if (bio_op(bio) == REQ_OP_READ && !bio->bi_status) {
+	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
+
+	if (bio_op(bio) == REQ_OP_READ && !bio->bi_status &&
+	    bi->profile->verify_fn)
 		struct bio_integrity_payload *bip = bio_integrity(bio);
 
 		INIT_WORK(&bip->bip_work, bio_integrity_verify_fn);
-- 
2.11.0

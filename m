From: jiangyiwen <jiangyiwen@huawei.com>
Subject: [dm-devel] [PATCH] block: do not return -EOPNOTSUPP only when issue a
 discard request
Date: Wed, 3 Feb 2016 17:54:36 +0800
Message-ID: <56B1CE5C.10201@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: dm-devel@redhat.com, martin.petersen@oracle.com, =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>, xuejiufei@huawei.com, "Qijiang (Joseph, Euler)" <joseph.qi@huawei.com>
List-Id: dm-devel.ids

commit 8af1954d172a("blkdev: Do not return -EOPNOTSUPP if discard
is supported") only solve the situation of discard, because When
applications issue a discard request to device, they can't expect
deterministic behaviour. However, WRITE SAME should not ignore error
with EOPNOTSUPP, because if applications issue WRITE SAME requests to
device, it should return deterministic results to applications
according to the T10 standard, or else it will cause an inconsistent
state between upper layer and bottom layer.

So ignoring error with EOPNOTSUPP only in discard situation.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
---
 block/blk-lib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 9ebf653..e4f02f1 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -19,7 +19,9 @@ static void bio_batch_end_io(struct bio *bio)
 {
 	struct bio_batch *bb = bio->bi_private;

-	if (bio->bi_error && bio->bi_error != -EOPNOTSUPP)
+	/* ignore -EOPNOTSUPP only when issue a discard request */
+	if (bio->bi_error && (!(bio->bi_rw & REQ_DISCARD) ||
+			(bio->bi_error != -EOPNOTSUPP)))
 		bb->error = bio->bi_error;
 	if (atomic_dec_and_test(&bb->done))
 		complete(bb->wait);
-- 
1.8.4.3

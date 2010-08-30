From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/5] block: make __blk_rq_prep_clone() copy most
	command flags
Date: Mon, 30 Aug 2010 11:58:12 +0200
Message-ID: <1283162296-13650-2-git-send-email-tj__16601.5284871266$1283196683$gmane$org@kernel.org>
References: <1283162296-13650-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Resent-Message-ID: <20100830192431.GG9195@redhat.com>
Resent-To: dm-devel@redhat.com
In-Reply-To: <1283162296-13650-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, snitzer@redhat.com, j-nomura@ce.jp.nec.com, jamie@shareable.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
List-Id: dm-devel.ids

Currently __blk_rq_prep_clone() copies only REQ_WRITE and REQ_DISCARD.
There's no reason to omit other command flags and REQ_FUA needs to be
copied to implement FUA support in request-based dm.

REQ_COMMON_MASK which specifies flags to be copied from bio to request
already identifies all the command flags.  Define REQ_CLONE_MASK to be
the same as REQ_COMMON_MASK for clarity and make __blk_rq_prep_clone()
copy all flags in the mask.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c          |    4 +---
 include/linux/blk_types.h |    1 +
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 495bdc4..2a5b192 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2505,9 +2505,7 @@ EXPORT_SYMBOL_GPL(blk_rq_unprep_clone);
 static void __blk_rq_prep_clone(struct request *dst, struct request *src)
 {
 	dst->cpu = src->cpu;
-	dst->cmd_flags = (rq_data_dir(src) | REQ_NOMERGE);
-	if (src->cmd_flags & REQ_DISCARD)
-		dst->cmd_flags |= REQ_DISCARD;
+	dst->cmd_flags = (src->cmd_flags & REQ_CLONE_MASK) | REQ_NOMERGE;
 	dst->cmd_type = src->cmd_type;
 	dst->__sector = blk_rq_pos(src);
 	dst->__data_len = blk_rq_bytes(src);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 1797994..36edadf 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -168,6 +168,7 @@ enum rq_flag_bits {
 #define REQ_COMMON_MASK \
 	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_HARDBARRIER | REQ_SYNC | \
 	 REQ_META | REQ_DISCARD | REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
+#define REQ_CLONE_MASK		REQ_COMMON_MASK
 
 #define REQ_UNPLUG		(1 << __REQ_UNPLUG)
 #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
-- 
1.7.1

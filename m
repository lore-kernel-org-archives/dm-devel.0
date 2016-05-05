From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/5] block: make bio_inc_remaining() interface
	accessible again
Date: Thu,  5 May 2016 11:54:22 -0400
Message-ID: <1462463665-85312-3-git-send-email-snitzer@redhat.com>
References: <1462463665-85312-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1462463665-85312-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Commit 326e1dbb57 ("block: remove management of bi_remaining when
restoring original bi_end_io") made bio_inc_remaining() private to bio.c
because the only use-case that made sense was confined to the
bio_chain() interface.

Since that time DM thinp went on to use bio_chain() in its relatively
complex implementation of async discard support.  That implementation,
even when converted over to use the new async __blkdev_issue_discard()
interface, depends on deferred completion of the original discard bio --
which is most appropriately implemented using bio_inc_remaining().

DM thinp foolishly duplicated bio_inc_remaining(), local to dm-thin.c as
__bio_inc_remaining(), so re-exporting bio_inc_remaining() allows us to
put an end to that foolishness.

All said, bio_inc_remaining() should really only be used in conjunction
with bio_chain().  It isn't intended for generic bio reference counting.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
---
 block/bio.c         | 11 -----------
 include/linux/bio.h | 11 +++++++++++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 807d25e..0e4aa42 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -311,17 +311,6 @@ static void bio_chain_endio(struct bio *bio)
 	bio_endio(__bio_chain_endio(bio));
 }
 
-/*
- * Increment chain count for the bio. Make sure the CHAIN flag update
- * is visible before the raised count.
- */
-static inline void bio_inc_remaining(struct bio *bio)
-{
-	bio_set_flag(bio, BIO_CHAIN);
-	smp_mb__before_atomic();
-	atomic_inc(&bio->__bi_remaining);
-}
-
 /**
  * bio_chain - chain bio completions
  * @bio: the target bio
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 6b7481f..9faebf7 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -703,6 +703,17 @@ static inline struct bio *bio_list_get(struct bio_list *bl)
 }
 
 /*
+ * Increment chain count for the bio. Make sure the CHAIN flag update
+ * is visible before the raised count.
+ */
+static inline void bio_inc_remaining(struct bio *bio)
+{
+	bio_set_flag(bio, BIO_CHAIN);
+	smp_mb__before_atomic();
+	atomic_inc(&bio->__bi_remaining);
+}
+
+/*
  * bio_set is used to allow other portions of the IO system to
  * allocate their own private memory pools for bio and iovec structures.
  * These memory pools in turn all allocate from the bio_slab
-- 
2.6.4 (Apple Git-63)

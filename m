From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/7] block: Introduce integrity data ownership
	flag
Date: Wed,  1 Oct 2008 03:38:37 -0400
Message-ID: <1222846723-18213-2-git-send-email-martin.petersen@oracle.com>
References: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, neilb@suse.de, agk@sourceware.org
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

A filesystem might supply its own integrity metadata.  Introduce a
flag that indicates whether the filesystem or the block layer owns the
integrity buffer.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 fs/bio-integrity.c  |    3 ++-
 include/linux/bio.h |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index c3e174b..8e409ff 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -107,7 +107,8 @@ void bio_integrity_free(struct bio *bio, struct bio_set *bs)
 	BUG_ON(bip == NULL);
 
 	/* A cloned bio doesn't own the integrity metadata */
-	if (!bio_flagged(bio, BIO_CLONED) && bip->bip_buf != NULL)
+	if (!bio_flagged(bio, BIO_CLONED) && !bio_flagged(bio, BIO_FS_INTEGRITY)
+	    && bip->bip_buf != NULL)
 		kfree(bip->bip_buf);
 
 	mempool_free(bip->bip_vec, bs->bvec_pools[bip->bip_pool]);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 6520ee1..6aba97d 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -109,6 +109,7 @@ struct bio {
 #define BIO_EOPNOTSUPP	7	/* not supported */
 #define BIO_CPU_AFFINE	8	/* complete bio on same CPU as submitted */
 #define BIO_NULL_MAPPED 9	/* contains invalid user pages */
+#define BIO_FS_INTEGRITY 10	/* fs owns integrity data, not block layer */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
 /*
-- 
1.6.0.2

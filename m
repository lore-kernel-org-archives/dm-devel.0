From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 7/8] dm core: pass gfp_mask to
	bio_integrity_clone()
Date: Wed, 18 Mar 2009 17:57:26 +0900
Message-ID: <49C0B776.2070304@ct.jp.nec.com>
References: <49C0B474.4000204@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49C0B474.4000204@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, martin.petersen@oracle.com
List-Id: dm-devel.ids

This patch passes gfp_mask to bio_integrity_clone() in bio-based dm.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: 2.6.29-rc8/drivers/md/dm.c
===================================================================
--- 2.6.29-rc8.orig/drivers/md/dm.c
+++ 2.6.29-rc8/drivers/md/dm.c
@@ -1032,7 +1032,7 @@ static struct bio *split_bvec(struct bio
 	clone->bi_flags |= 1 << BIO_CLONED;
 
 	if (bio_integrity(bio)) {
-		bio_integrity_clone(clone, bio, bs);
+		bio_integrity_clone(clone, bio, GFP_NOIO, bs);
 		bio_integrity_trim(clone,
 				   bio_sector_offset(bio, idx, offset), len);
 	}
@@ -1059,7 +1059,7 @@ static struct bio *clone_bio(struct bio 
 	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
 
 	if (bio_integrity(bio)) {
-		bio_integrity_clone(clone, bio, bs);
+		bio_integrity_clone(clone, bio, GFP_NOIO, bs);
 
 		if (idx != bio->bi_idx || clone->bi_size < bio->bi_size)
 			bio_integrity_trim(clone,

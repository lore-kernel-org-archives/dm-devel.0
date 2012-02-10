From: Cong Wang <amwang@redhat.com>
Subject: [PATCH 55/60] dm: remove the second argument of k[un]map_atomic()
Date: Fri, 10 Feb 2012 13:40:16 +0800
Message-ID: <1328852421-19678-56-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>, Neil Brown <neilb@suse.de>, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

Acked-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/md/dm-crypt.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 8c2a000..db6b516 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -590,9 +590,9 @@ static int crypt_iv_lmk_gen(struct crypt_config *cc, u8 *iv,
 	int r = 0;
 
 	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE) {
-		src = kmap_atomic(sg_page(&dmreq->sg_in), KM_USER0);
+		src = kmap_atomic(sg_page(&dmreq->sg_in));
 		r = crypt_iv_lmk_one(cc, iv, dmreq, src + dmreq->sg_in.offset);
-		kunmap_atomic(src, KM_USER0);
+		kunmap_atomic(src);
 	} else
 		memset(iv, 0, cc->iv_size);
 
@@ -608,14 +608,14 @@ static int crypt_iv_lmk_post(struct crypt_config *cc, u8 *iv,
 	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE)
 		return 0;
 
-	dst = kmap_atomic(sg_page(&dmreq->sg_out), KM_USER0);
+	dst = kmap_atomic(sg_page(&dmreq->sg_out));
 	r = crypt_iv_lmk_one(cc, iv, dmreq, dst + dmreq->sg_out.offset);
 
 	/* Tweak the first block of plaintext sector */
 	if (!r)
 		crypto_xor(dst + dmreq->sg_out.offset, iv, cc->iv_size);
 
-	kunmap_atomic(dst, KM_USER0);
+	kunmap_atomic(dst);
 	return r;
 }
 
-- 
1.7.7.6

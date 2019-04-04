From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] dm-crypt: fix endianess annotations around
	org_sector_of_dmreq
Date: Thu,  4 Apr 2019 18:33:34 +0200
Message-ID: <20190404163334.4453-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

The sector used here is a little endian value, so use the right
type for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-crypt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index dd6565798778..692cddf3fe2a 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1034,11 +1034,11 @@ static u8 *org_iv_of_dmreq(struct crypt_config *cc,
 	return iv_of_dmreq(cc, dmreq) + cc->iv_size;
 }
 
-static uint64_t *org_sector_of_dmreq(struct crypt_config *cc,
+static __le64 *org_sector_of_dmreq(struct crypt_config *cc,
 		       struct dm_crypt_request *dmreq)
 {
 	u8 *ptr = iv_of_dmreq(cc, dmreq) + cc->iv_size + cc->iv_size;
-	return (uint64_t*) ptr;
+	return (__le64 *) ptr;
 }
 
 static unsigned int *org_tag_of_dmreq(struct crypt_config *cc,
@@ -1074,7 +1074,7 @@ static int crypt_convert_block_aead(struct crypt_config *cc,
 	struct bio_vec bv_out = bio_iter_iovec(ctx->bio_out, ctx->iter_out);
 	struct dm_crypt_request *dmreq;
 	u8 *iv, *org_iv, *tag_iv, *tag;
-	uint64_t *sector;
+	__le64 *sector;
 	int r = 0;
 
 	BUG_ON(cc->integrity_iv_size && cc->integrity_iv_size != cc->iv_size);
@@ -1169,7 +1169,7 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
 	struct scatterlist *sg_in, *sg_out;
 	struct dm_crypt_request *dmreq;
 	u8 *iv, *org_iv, *tag_iv;
-	uint64_t *sector;
+	__le64 *sector;
 	int r = 0;
 
 	/* Reject unexpected unaligned bio. */
-- 
2.20.1

From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 1/2] dm-crypt: print device name in integrity
	error message.
Date: Wed, 15 May 2019 16:22:30 +0200
Message-ID: <20190515142231.30590-1-gmazyland@gmail.com>
References: <alpine.LNX.2.21.9999.1905141138180.19368@nlopc43.ioq.uni-jena.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LNX.2.21.9999.1905141138180.19368@nlopc43.ioq.uni-jena.de>
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
Cc: Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

This message should better identify the device with the integrity failure.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-crypt.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 7f6462f74ac8..36dfa36505ed 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1143,9 +1143,11 @@ static int crypt_convert_block_aead(struct crypt_config *cc,
 		r = crypto_aead_decrypt(req);
 	}
 
-	if (r == -EBADMSG)
-		DMERR_LIMIT("INTEGRITY AEAD ERROR, sector %llu",
+	if (r == -EBADMSG) {
+		char b[BDEVNAME_SIZE];
+		DMERR_LIMIT("%s: INTEGRITY AEAD ERROR, sector %llu", bio_devname(ctx->bio_in, b),
 			    (unsigned long long)le64_to_cpu(*sector));
+	}
 
 	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
 		r = cc->iv_gen_ops->post(cc, org_iv, dmreq);
@@ -1788,7 +1790,8 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 		error = cc->iv_gen_ops->post(cc, org_iv_of_dmreq(cc, dmreq), dmreq);
 
 	if (error == -EBADMSG) {
-		DMERR_LIMIT("INTEGRITY AEAD ERROR, sector %llu",
+		char b[BDEVNAME_SIZE];
+		DMERR_LIMIT("%s: INTEGRITY AEAD ERROR, sector %llu", bio_devname(ctx->bio_in, b),
 			    (unsigned long long)le64_to_cpu(*org_sector_of_dmreq(cc, dmreq)));
 		io->error = BLK_STS_PROTECTION;
 	} else if (error < 0)
-- 
2.20.1

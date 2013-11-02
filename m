From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 3/4] dm-crypt: Fix code formatting to make agk
	happy
Date: Sat,  2 Nov 2013 22:24:03 +0100
Message-ID: <1383427444-19174-1-git-send-email-gmazyland@gmail.com>
References: <20131030181241.GA24325@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131030181241.GA24325@agk-dp.fab.redhat.com>
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

Fix code style format.

Add note that loopAES key must be the same size.
(probably should be folded into previous patch)

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-crypt.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index cfdaa12..2d6ee75f 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -706,18 +706,21 @@ static int crypt_iv_tcw_whitening(struct crypt_config *cc,
 
 	/* xor whitening with sector number */
 	memcpy(buf, tcw->whitening, TCW_WHITENING_SIZE);
-	crypto_xor(buf, (u8*)&sector, 8);
-	crypto_xor(&buf[8], (u8*)&sector, 8);
+	crypto_xor(buf, (u8 *)&sector, 8);
+	crypto_xor(&buf[8], (u8 *)&sector, 8);
 
 	/* calculate crc32 for every 32bit part and xor it */
 	sdesc.desc.tfm = tcw->crc32_tfm;
 	sdesc.desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 	for (i = 0; i < 4; i++) {
-		if ((r = crypto_shash_init(&sdesc.desc)))
+		r = crypto_shash_init(&sdesc.desc);
+		if (r)
 			goto out;
-		if ((r = crypto_shash_update(&sdesc.desc, &buf[i * 4], 4)))
+		r = crypto_shash_update(&sdesc.desc, &buf[i * 4], 4);
+		if (r)
 			goto out;
-		if ((r = crypto_shash_final(&sdesc.desc, &buf[i * 4])))
+		r = crypto_shash_final(&sdesc.desc, &buf[i * 4]);
+		if (r)
 			goto out;
 	}
 	crypto_xor(&buf[0], &buf[12], 4);
@@ -748,9 +751,9 @@ static int crypt_iv_tcw_gen(struct crypt_config *cc, u8 *iv,
 
 	/* Calculate IV */
 	memcpy(iv, tcw->iv_seed, cc->iv_size);
-	crypto_xor(iv, (u8*)&sector, 8);
+	crypto_xor(iv, (u8 *)&sector, 8);
 	if (cc->iv_size > 8)
-		crypto_xor(&iv[8], (u8*)&sector, cc->iv_size - 8);
+		crypto_xor(&iv[8], (u8 *)&sector, cc->iv_size - 8);
 
 	return r;
 }
@@ -1663,9 +1666,11 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 		cc->iv_gen_ops = &crypt_iv_null_ops;
 	else if (strcmp(ivmode, "lmk") == 0) {
 		cc->iv_gen_ops = &crypt_iv_lmk_ops;
-		/* Version 2 and 3 is recognised according
+		/*
+		 * Version 2 and 3 is recognised according
 		 * to length of provided multi-key string.
 		 * If present (version 3), last key is used as IV seed.
+		 * All keys (including IV seed) are always the same size.
 		 */
 		if (cc->key_size % cc->key_parts) {
 			cc->key_parts++;
-- 
1.8.4.2

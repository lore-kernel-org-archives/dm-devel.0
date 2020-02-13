From: Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH] dm crypt: use crypt_integrity_aead() helper
Date: Thu, 13 Feb 2020 12:11:26 +0800
Message-ID: <1581567086-17807-1-git-send-email-yangyingliang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: agk@redhat.com, snitzer@redhat.com, yangyingliang@huawei.com
List-Id: dm-devel.ids

Replace test_bit(CRYPT_MODE_INTEGRITY_AEAD, XXX) with
crypt_integrity_aead().

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/md/dm-crypt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index c6a5298..3df90da 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -230,6 +230,8 @@ struct crypt_config {
 static struct scatterlist *crypt_get_sg_data(struct crypt_config *cc,
 					     struct scatterlist *sg);
 
+static bool crypt_integrity_aead(struct crypt_config *cc);
+
 /*
  * Use this to access cipher attributes that are independent of the key.
  */
@@ -346,7 +348,7 @@ static int crypt_iv_benbi_ctr(struct crypt_config *cc, struct dm_target *ti,
 	unsigned bs;
 	int log;
 
-	if (test_bit(CRYPT_MODE_INTEGRITY_AEAD, &cc->cipher_flags))
+	if (crypt_integrity_aead(cc))
 		bs = crypto_aead_blocksize(any_tfm_aead(cc));
 	else
 		bs = crypto_skcipher_blocksize(any_tfm(cc));
@@ -712,7 +714,7 @@ static int crypt_iv_random_gen(struct crypt_config *cc, u8 *iv,
 static int crypt_iv_eboiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 			    const char *opts)
 {
-	if (test_bit(CRYPT_MODE_INTEGRITY_AEAD, &cc->cipher_flags)) {
+	if (crypt_integrity_aead(cc)) {
 		ti->error = "AEAD transforms not supported for EBOIV";
 		return -EINVAL;
 	}
-- 
1.8.3

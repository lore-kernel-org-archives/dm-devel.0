From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] dm-crypt: replace custom implementation of hex2bin()
Date: Thu, 27 Apr 2017 16:52:04 +0300
Message-ID: <20170427135204.5761-1-andriy.shevchenko@linux.intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
List-Id: dm-devel.ids

From: Andy Shevchenko <andy.shevchenko@gmail.com>

There is no need to have a duplication of the generic library, i.e. hex2bin().
Replace the open coded variant.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/md/dm-crypt.c | 27 ++-------------------------
 1 file changed, 2 insertions(+), 25 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 70f765f50c59..ebf9e72d479b 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1814,30 +1814,6 @@ static void kcryptd_queue_crypt(struct dm_crypt_io *io)
 	queue_work(cc->crypt_queue, &io->work);
 }
 
-/*
- * Decode key from its hex representation
- */
-static int crypt_decode_key(u8 *key, char *hex, unsigned int size)
-{
-	char buffer[3];
-	unsigned int i;
-
-	buffer[2] = '\0';
-
-	for (i = 0; i < size; i++) {
-		buffer[0] = *hex++;
-		buffer[1] = *hex++;
-
-		if (kstrtou8(buffer, 16, &key[i]))
-			return -EINVAL;
-	}
-
-	if (*hex != '\0')
-		return -EINVAL;
-
-	return 0;
-}
-
 static void crypt_free_tfms_aead(struct crypt_config *cc)
 {
 	if (!cc->cipher_tfm.tfms_aead)
@@ -2136,7 +2112,8 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
 	kzfree(cc->key_string);
 	cc->key_string = NULL;
 
-	if (cc->key_size && crypt_decode_key(cc->key, key, cc->key_size) < 0)
+	/* Decode key from its hex representation. */
+	if (cc->key_size && hex2bin(cc->key, key, cc->key_size) < 0)
 		goto out;
 
 	r = crypt_setkey(cc);
-- 
2.11.0


From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 2/2] dm-crypt: move detailed message into debug
	level.
Date: Wed, 15 May 2019 16:23:43 +0200
Message-ID: <20190515142343.30641-1-gmazyland@gmail.com>
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
Cc: Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

The information about tag size should not be printed
without debug info set. Also pront device major:minor in
the error message to identify the device instance.

Also use rate limiting and debug level for info about
used crypto API implementaton.
(During online reencryption this message saturates syslog,
because we are moving hotzone across the whole device.)

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-crypt.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 36dfa36505ed..af017d044dc0 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -946,6 +946,7 @@ static int crypt_integrity_ctr(struct crypt_config *cc, struct dm_target *ti)
 {
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 	struct blk_integrity *bi = blk_get_integrity(cc->dev->bdev->bd_disk);
+	struct mapped_device *md = dm_table_get_md(ti->table);
 
 	/* From now we require underlying device with our integrity profile */
 	if (!bi || strcasecmp(bi->profile->name, "DM-DIF-EXT-TAG")) {
@@ -965,7 +966,7 @@ static int crypt_integrity_ctr(struct crypt_config *cc, struct dm_target *ti)
 
 	if (crypt_integrity_aead(cc)) {
 		cc->integrity_tag_size = cc->on_disk_tag_size - cc->integrity_iv_size;
-		DMINFO("Integrity AEAD, tag size %u, IV size %u.",
+		DMDEBUG("%s: Integrity AEAD, tag size %u, IV size %u.", dm_device_name(md),
 		       cc->integrity_tag_size, cc->integrity_iv_size);
 
 		if (crypto_aead_setauthsize(any_tfm_aead(cc), cc->integrity_tag_size)) {
@@ -973,7 +974,7 @@ static int crypt_integrity_ctr(struct crypt_config *cc, struct dm_target *ti)
 			return -EINVAL;
 		}
 	} else if (cc->integrity_iv_size)
-		DMINFO("Additional per-sector space %u bytes for IV.",
+		DMDEBUG("%s: Additional per-sector space %u bytes for IV.", dm_device_name(md),
 		       cc->integrity_iv_size);
 
 	if ((cc->integrity_tag_size + cc->integrity_iv_size) != bi->tag_size) {
@@ -1890,7 +1891,7 @@ static int crypt_alloc_tfms_skcipher(struct crypt_config *cc, char *ciphermode)
 	 * algorithm implementation is used.  Help people debug performance
 	 * problems by logging the ->cra_driver_name.
 	 */
-	DMINFO("%s using implementation \"%s\"", ciphermode,
+	DMDEBUG_LIMIT("%s using implementation \"%s\"", ciphermode,
 	       crypto_skcipher_alg(any_tfm(cc))->base.cra_driver_name);
 	return 0;
 }
@@ -1910,7 +1911,7 @@ static int crypt_alloc_tfms_aead(struct crypt_config *cc, char *ciphermode)
 		return err;
 	}
 
-	DMINFO("%s using implementation \"%s\"", ciphermode,
+	DMDEBUG_LIMIT("%s using implementation \"%s\"", ciphermode,
 	       crypto_aead_alg(any_tfm_aead(cc))->base.cra_driver_name);
 	return 0;
 }
-- 
2.20.1

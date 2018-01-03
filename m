From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] dm-crypt: Add missing check for auth key size
Date: Wed,  3 Jan 2018 22:48:59 +0100
Message-ID: <20180103214859.3842-1-gmazyland@gmail.com>
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

If dm-crypt uses authenticated mode with separate MAC,
there are two concatenated part of the key structure -
key(s) for encryption and authentication key.

This patch adds a missing check for authenticated key length.
If this key length is smaller than actually provided key,
dm-crypt now properly fails instead of crashing.

Reported-by: Salah Coronya <salahx@yahoo.com>
Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-crypt.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 9fc12f556534..4cc3809b2a3a 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1954,10 +1954,15 @@ static int crypt_setkey(struct crypt_config *cc)
 	/* Ignore extra keys (which are used for IV etc) */
 	subkey_size = crypt_subkey_size(cc);
 
-	if (crypt_integrity_hmac(cc))
+	if (crypt_integrity_hmac(cc)) {
+		if (subkey_size < cc->key_mac_size)
+			return -EINVAL;
+
 		crypt_copy_authenckey(cc->authenc_key, cc->key,
 				      subkey_size - cc->key_mac_size,
 				      cc->key_mac_size);
+	}
+
 	for (i = 0; i < cc->tfms_count; i++) {
 		if (crypt_integrity_hmac(cc))
 			r = crypto_aead_setkey(cc->cipher_tfm.tfms_aead[i],
-- 
2.15.1

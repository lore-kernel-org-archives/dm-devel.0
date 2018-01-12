From: Ondrej Kozina <okozina@redhat.com>
Subject: [PATCH] dm crypt: wipe kernel key copy after IV
	initialization
Date: Fri, 12 Jan 2018 16:30:32 +0100
Message-ID: <1515771032-26247-2-git-send-email-okozina@redhat.com>
References: <1515771032-26247-1-git-send-email-okozina@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1515771032-26247-1-git-send-email-okozina@redhat.com>
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
Cc: Ondrej Kozina <okozina@redhat.com>, mpatocka@redhat.com, mbroz@redhat.com
List-Id: dm-devel.ids

Loading key via kernel keyring service we erase internal
key copy immediately after we pass it in crypto layer. This is
wrong because IV is initialised later and we use wrong key
for the initialization (instead of real key there's just zeroed
block).

The bug may cause data corruption if key is loaded via kernel keyring
service first and later same crypt device is reactivated using exactly
same key in hexbyte representation, or vice versa. The bug (and fix)
affects only ciphers using following IVs: essiv, lmk and tcw.

Fixes: c538f6ec9f56 ("dm crypt: add ability to use keys from the kernel
key retention service")
Signed-off-by: Ondrej Kozina <okozina@redhat.com>
---
 drivers/md/dm-crypt.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 9fc12f5..334b0a3 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2053,9 +2053,6 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 
 	ret = crypt_setkey(cc);
 
-	/* wipe the kernel key payload copy in each case */
-	memset(cc->key, 0, cc->key_size * sizeof(u8));
-
 	if (!ret) {
 		set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 		kzfree(cc->key_string);
@@ -2523,6 +2520,10 @@ static int crypt_ctr_cipher(struct dm_target *ti, char *cipher_in, char *key)
 		}
 	}
 
+	/* wipe the kernel key payload copy */
+	if (cc->key_string)
+		memset(cc->key, 0, cc->key_size * sizeof(u8));
+
 	return ret;
 }
 
@@ -2961,6 +2962,9 @@ static int crypt_message(struct dm_target *ti, unsigned argc, char **argv)
 				return ret;
 			if (cc->iv_gen_ops && cc->iv_gen_ops->init)
 				ret = cc->iv_gen_ops->init(cc);
+			/* wipe the kernel key payload copy */
+			if (cc->key_string)
+				memset(cc->key, 0, cc->key_size * sizeof(u8));
 			return ret;
 		}
 		if (argc == 2 && !strcasecmp(argv[1], "wipe")) {
@@ -3007,7 +3011,7 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 static struct target_type crypt_target = {
 	.name   = "crypt",
-	.version = {1, 18, 0},
+	.version = {1, 18, 1},
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
-- 
1.8.3.1

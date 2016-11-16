From: Ondrej Kozina <okozina@redhat.com>
Subject: [PATCH v2] dm-crypt: add ability to use keys from the
	kernel key retention service
Date: Wed, 16 Nov 2016 21:47:11 +0100
Message-ID: <1479329231-4572-1-git-send-email-okozina@redhat.com>
References: <afaabcf3-0ea0-375d-c0f2-6892dd70de2a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <afaabcf3-0ea0-375d-c0f2-6892dd70de2a@gmail.com>
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
Cc: Ondrej Kozina <okozina@redhat.com>, aryabinin@virtuozzo.com, mpatocka@redhat.com, snitzer@redhat.com, mbroz@redhat.com
List-Id: dm-devel.ids

(Please still consider it to be RFC only, I need to modify the uspace teststuite
again due to changes in key_string format. Also the changes to dm-crypt documentation
will follow before final submit. Feature wide I'd consider the patch being complete
unless any bugs would emerge)

The kernel key service is a generic way to store keys for the use of
other subsystems. Currently there is no way to use kernel keys in dm-crypt.
This patch aims to fix that. Instead of key userspace may pass a key
description with preceding ':'. So message that constructs encryption
mapping now looks like this:

  <cipher> [<key>|:<key_string>] <iv_offset> <dev_path> <start> [<#opt_params> <opt_params>]

where <key_string> is in format: <key_size>:<key_type>:<key_description>

Currently we only support two elementary key types: 'user' and 'logon'.
Keys may be loaded in dm-crypt either via <key_string> or using
classical method and pass the key in hex representation directly.

dm-crypt device initialised with a key passed in hex representation may be
replaced with key passed in key_string format and vice versa.

(Patch is based on original work by Andrey Ryabinin)

Signed-off-by: Ondrej Kozina <okozina@redhat.com>
---
 drivers/md/dm-crypt.c | 167 ++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 148 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 0aedd0e..f4189ca 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/key.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/mempool.h>
@@ -29,6 +30,7 @@
 #include <crypto/md5.h>
 #include <crypto/algapi.h>
 #include <crypto/skcipher.h>
+#include <keys/user-type.h>
 
 #include <linux/device-mapper.h>
 
@@ -140,6 +142,7 @@ struct crypt_config {
 
 	char *cipher;
 	char *cipher_string;
+	char *key_string;
 
 	struct crypt_iv_operations *iv_gen_ops;
 	union {
@@ -1490,29 +1493,138 @@ static int crypt_setkey_allcpus(struct crypt_config *cc)
 	return err;
 }
 
-static int crypt_set_key(struct crypt_config *cc, char *key)
+#ifdef CONFIG_KEYS
+static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string)
 {
-	int r = -EINVAL;
-	int key_string_len = strlen(key);
+	char *new_key_string, *key_desc;
+	int ret;
+	struct key *key;
+	const struct user_key_payload *ukp;
 
-	/* The key size may not be changed. */
-	if (cc->key_size != (key_string_len >> 1))
+	/* look for next ':' separating key_type from key_description */
+	key_desc = strpbrk(key_string, ":");
+	if (!key_desc || key_desc == key_string || !strlen(key_desc + 1))
+		return -EINVAL;
+
+	if (strncmp(key_string, "logon", key_desc - key_string) &&
+	    strncmp(key_string, "user", key_desc - key_string))
+		return -EINVAL;
+
+	new_key_string = kstrdup(key_string, GFP_KERNEL);
+	if (!new_key_string)
+		return -ENOMEM;
+
+	/*
+	 * FIXME: are there any key descriptions we should disallow users
+	 * from loading to dm-crypt? i.e.: kernel keys starting with '.'
+	 */
+
+	key = request_key(strncmp(key_string, "user", 4) ? &key_type_logon : &key_type_user, key_desc + 1, NULL);
+	if (IS_ERR(key)) {
+		kzfree(new_key_string);
+		return PTR_ERR(key);
+	}
+
+	rcu_read_lock();
+	ret = key_validate(key);
+	if (ret < 0)
 		goto out;
 
-	/* Hyphen (which gives a key_size of zero) means there is no key. */
-	if (!cc->key_size && strcmp(key, "-"))
+	ukp = user_key_payload(key);
+	if (cc->key_size != ukp->datalen) {
+		ret = -EINVAL;
 		goto out;
+	}
+	memcpy(cc->key, ukp->data, cc->key_size);
+
+	rcu_read_unlock();
+	key_put(key);
 
 	/* clear the flag since following operations may invalidate previously valid key */
 	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 
-	if (cc->key_size && crypt_decode_key(cc->key, key, cc->key_size) < 0)
-		goto out;
+	ret = crypt_setkey_allcpus(cc);
 
-	r = crypt_setkey_allcpus(cc);
-	if (!r)
+	/* wipe the kernel key payload in each case */
+	memset(cc->key, 0, cc->key_size * sizeof(u8));
+
+	if (!ret) {
 		set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
+		kzfree(cc->key_string);
+		cc->key_string = new_key_string;
+	} else
+		kzfree(new_key_string);
+
+	return ret;
+out:
+	rcu_read_unlock();
+	key_put(key);
+	kzfree(new_key_string);
+	return ret;
+}
+
+static int get_key_size(char **key_string)
+{
+	char *colon, dummy;
+	int ret;
+
+	if (*key_string[0] != ':')
+		return strlen(*key_string) >> 1;
 
+	/* look for next ':' in key string */
+	colon = strpbrk(*key_string + 1, ":");
+	if (!colon)
+		return -EINVAL;
+
+	if (sscanf(*key_string + 1, "%u%c", &ret, &dummy) != 2 || dummy != ':')
+		return -EINVAL;
+
+	*key_string = colon;
+
+	/* remaining key string should be :<logon|user>:<key_desc> */
+
+	return ret;
+}
+#else
+static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_desc)
+{
+	return -EINVAL;
+}
+
+static int get_key_size(char **key)
+{
+	return (*key[0] == ':') ? -EINVAL : strlen(*key) >> 1;
+}
+#endif
+
+static int crypt_set_key(struct crypt_config *cc, char *key)
+{
+	int r = -EINVAL;
+	int key_string_len = strlen(key);
+
+	/* Hyphen (which gives a key_size of zero) means there is no key. */
+	if (!cc->key_size && strcmp(key, "-"))
+		goto out;
+
+	/* ':' means that the key is in kernel keyring */
+	if (key[0] == ':')
+		r = crypt_set_keyring_key(cc, key + 1);
+	else {
+		/* clear the flag since following operations may invalidate previously valid key */
+		clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
+
+		/* wipe references to any kernel keyring key */
+		kzfree(cc->key_string);
+		cc->key_string = NULL;
+
+		if (cc->key_size &&
+		    crypt_decode_key(cc->key, key, cc->key_size) < 0)
+			goto out;
+
+		r = crypt_setkey_allcpus(cc);
+		if (!r)
+			set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
+	}
 out:
 	/* Hex key string not needed after here, so wipe it. */
 	memset(key, '0', key_string_len);
@@ -1524,6 +1636,8 @@ static int crypt_wipe_key(struct crypt_config *cc)
 {
 	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 	memset(&cc->key, 0, cc->key_size * sizeof(u8));
+	kzfree(cc->key_string);
+	cc->key_string = NULL;
 
 	return crypt_setkey_allcpus(cc);
 }
@@ -1561,6 +1675,7 @@ static void crypt_dtr(struct dm_target *ti)
 
 	kzfree(cc->cipher);
 	kzfree(cc->cipher_string);
+	kzfree(cc->key_string);
 
 	/* Must zero key material before freeing */
 	kzfree(cc);
@@ -1729,12 +1844,13 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 
 /*
  * Construct an encryption mapping:
- * <cipher> <key> <iv_offset> <dev_path> <start>
+ * <cipher> [<key>|:<key_size>:<user|logon>:<key_description>] <iv_offset> <dev_path> <start>
  */
 static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct crypt_config *cc;
-	unsigned int key_size, opt_params;
+	int key_size;
+	unsigned int opt_params;
 	unsigned long long tmpll;
 	int ret;
 	size_t iv_size_padding;
@@ -1751,7 +1867,11 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		return -EINVAL;
 	}
 
-	key_size = strlen(argv[1]) >> 1;
+	key_size = get_key_size(&argv[1]);
+	if (key_size < 0) {
+		ti->error = "Cannot parse key size";
+		return -EINVAL;
+	}
 
 	cc = kzalloc(sizeof(*cc) + key_size * sizeof(u8), GFP_KERNEL);
 	if (!cc) {
@@ -1958,10 +2078,13 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
 	case STATUSTYPE_TABLE:
 		DMEMIT("%s ", cc->cipher_string);
 
-		if (cc->key_size > 0)
-			for (i = 0; i < cc->key_size; i++)
-				DMEMIT("%02x", cc->key[i]);
-		else
+		if (cc->key_size > 0) {
+			if (cc->key_string)
+				DMEMIT(":%u:%s", cc->key_size, cc->key_string);
+			else
+				for (i = 0; i < cc->key_size; i++)
+					DMEMIT("%02x", cc->key[i]);
+		} else
 			DMEMIT("-");
 
 		DMEMIT(" %llu %s %llu", (unsigned long long)cc->iv_offset,
@@ -2028,6 +2151,12 @@ static int crypt_message(struct dm_target *ti, unsigned argc, char **argv)
 			return -EINVAL;
 		}
 		if (argc == 3 && !strcasecmp(argv[1], "set")) {
+			/* The key size may not be changed. */
+			if (cc->key_size != get_key_size(&argv[2])) {
+				memset(argv[2], '0', strlen(argv[2]));
+				return -EINVAL;
+			}
+
 			ret = crypt_set_key(cc, argv[2]);
 			if (ret)
 				return ret;
@@ -2071,7 +2200,7 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 static struct target_type crypt_target = {
 	.name   = "crypt",
-	.version = {1, 14, 1},
+	.version = {1, 15, 0},
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
-- 
2.7.4

From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [RFC] dm-crypt: add ability to use keys from the kernel key retention service
Date: Tue, 9 Aug 2016 16:56:06 +0300
Message-ID: <1470750966-13028-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <mbroz@redhat.com>, Igor Sukhih <igor@virtuozzo.com>, linux-kernel@vger.kernel.org, Andrey Ryabinin <aryabinin@virtuozzo.com>
List-Id: dm-devel.ids

The kernel key service is a generic way to store keys for the use of
other subsystems. Currently there is no way to use kernel keys in dm-crypt.
This patch aims to fix that. Instead of key userspace may pass a key
description with preceding ':'. So message that constructs encryption
mapping now looks like this:

  <cipher> [<key>|:<key description>] <iv_offset> <dev_path> <start> [<#opt_params> <opt_params>]

(I could propose another possible way to distinguish key from the key description.
This would be to add new opt_param, something like 'key_in_keyring'.
So if key_in_keyring is set than we have key description instead of key.)

Note: We haven't implemented userspace part for this yet.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---
 drivers/md/dm-crypt.c | 95 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 86 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 4e9784b..5a7899d 100644
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
 
@@ -1489,21 +1491,91 @@ static int crypt_setkey_allcpus(struct crypt_config *cc)
 	return err;
 }
 
+#ifdef CONFIG_KEYS
+static int crypt_set_keyring_key(struct crypt_config *cc, char *key_desc)
+{
+	int ret = 0;
+	struct key *key;
+	const struct user_key_payload *ukp;
+
+	key = request_key(&key_type_user, key_desc, NULL);
+	if (IS_ERR(key))
+		return PTR_ERR(key);
+
+	rcu_read_lock();
+	ret = key_validate(key);
+	if (ret < 0)
+		goto out;
+
+	ukp = user_key_payload(key);
+	if (cc->key_size != ukp->datalen) {
+		ret = -EINVAL;
+		goto out;
+	}
+	memcpy(cc->key, ukp->data, cc->key_size);
+out:
+	rcu_read_unlock();
+	key_put(key);
+	return ret;
+}
+
+static int get_key_size(const char *key_desc)
+{
+	int ret;
+	struct key *key;
+
+	if (key_desc[0] != ':')
+		return strlen(key_desc) >> 1;
+
+	key = request_key(&key_type_user, key_desc + 1, NULL);
+	if (IS_ERR(key))
+		return PTR_ERR(key);
+
+	rcu_read_lock();
+	ret = key_validate(key);
+	if (ret < 0)
+		goto out;
+
+	ret = user_key_payload(key)->datalen;
+out:
+	rcu_read_unlock();
+	key_put(key);
+	return ret;
+}
+#else
+static int crypt_set_keyring_key(struct crypt_config *cc, char *key_desc)
+{
+	return -EINVAL;
+}
+
+static int get_key_size(const char *key)
+{
+	return strlen(key) >> 1;
+}
+#endif
+
 static int crypt_set_key(struct crypt_config *cc, char *key)
 {
 	int r = -EINVAL;
 	int key_string_len = strlen(key);
 
-	/* The key size may not be changed. */
-	if (cc->key_size != (key_string_len >> 1))
-		goto out;
-
 	/* Hyphen (which gives a key_size of zero) means there is no key. */
 	if (!cc->key_size && strcmp(key, "-"))
 		goto out;
 
-	if (cc->key_size && crypt_decode_key(cc->key, key, cc->key_size) < 0)
-		goto out;
+	/* ':' means that the key is in kernel keyring */
+	if (key[0] == ':') {
+		if (crypt_set_keyring_key(cc, key + 1))
+			goto out;
+	} else {
+		/* The key size may not be changed. */
+		if (cc->key_size != (key_string_len >> 1))
+			goto out;
+
+		if (cc->key_size &&
+			crypt_decode_key(cc->key, key, cc->key_size) < 0)
+			goto out;
+	}
 
 	set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 
@@ -1730,12 +1802,13 @@ bad_mem:
 
 /*
  * Construct an encryption mapping:
- * <cipher> <key> <iv_offset> <dev_path> <start>
+ * <cipher> [<key>|:<key description>] <iv_offset> <dev_path> <start>
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
@@ -1752,7 +1825,11 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		return -EINVAL;
 	}
 
-	key_size = strlen(argv[1]) >> 1;
+	key_size = get_key_size(argv[1]);
+	if (key_size < 0) {
+		ti->error = "Cannot parse key";
+		return -EINVAL;
+	}
 
 	cc = kzalloc(sizeof(*cc) + key_size * sizeof(u8), GFP_KERNEL);
 	if (!cc) {
-- 
2.7.3

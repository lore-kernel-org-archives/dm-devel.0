From: Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: [PATCH] dm-crypt: support using encrypted keys
Date: Mon, 20 Apr 2020 16:46:59 +0300
Message-ID: <20200420134659.1640089-1-dbaryshkov@gmail.com>
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
Cc: Dmitry Baryshkov <dmitry_baryshkov@mentor.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

From: Dmitry Baryshkov <dmitry_baryshkov@mentor.com>

Allow one to use encrypted in addition to user and login key types for
device encryption.

Signed-off-by: Dmitry Baryshkov <dmitry_baryshkov@mentor.com>
---
 drivers/md/dm-crypt.c | 66 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 50 insertions(+), 16 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 3df90daba89e..7056ab54d7dd 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -34,7 +34,9 @@
 #include <crypto/aead.h>
 #include <crypto/authenc.h>
 #include <linux/rtnetlink.h> /* for struct rtattr and RTA macros only */
+#include <linux/key-type.h>
 #include <keys/user-type.h>
+#include <keys/encrypted-type.h>
 
 #include <linux/device-mapper.h>
 
@@ -2215,12 +2217,44 @@ static bool contains_whitespace(const char *str)
 	return false;
 }
 
+static int set_key_user(struct crypt_config *cc, struct key *key)
+{
+	const struct user_key_payload *ukp;
+
+	ukp = user_key_payload_locked(key);
+	if (!ukp)
+		return -EKEYREVOKED;
+
+	if (cc->key_size != ukp->datalen)
+		return -EINVAL;
+
+	memcpy(cc->key, ukp->data, cc->key_size);
+
+	return 0;
+}
+
+static int set_key_encrypted(struct crypt_config *cc, struct key *key)
+{
+	struct encrypted_key_payload *ekp = key->payload.data[0];
+
+	if (!ekp)
+		return -EKEYREVOKED;
+
+	if (cc->key_size != ekp->decrypted_datalen)
+		return -EINVAL;
+
+	memcpy(cc->key, ekp->decrypted_data, cc->key_size);
+
+	return 0;
+}
+
 static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string)
 {
 	char *new_key_string, *key_desc;
 	int ret;
+	struct key_type *type;
 	struct key *key;
-	const struct user_key_payload *ukp;
+	int (*set_key)(struct crypt_config *cc, struct key *key);
 
 	/*
 	 * Reject key_string with whitespace. dm core currently lacks code for
@@ -2236,15 +2270,24 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 	if (!key_desc || key_desc == key_string || !strlen(key_desc + 1))
 		return -EINVAL;
 
-	if (strncmp(key_string, "logon:", key_desc - key_string + 1) &&
-	    strncmp(key_string, "user:", key_desc - key_string + 1))
+	if (!strncmp(key_string, "logon:", key_desc - key_string + 1)) {
+		type = &key_type_logon;
+		set_key = &set_key_user;
+	} else if (!strncmp(key_string, "user:", key_desc - key_string + 1)) {
+		type = &key_type_user;
+		set_key = &set_key_user;
+	} else if (!strncmp(key_string, "encrypted:", key_desc - key_string + 1)) {
+		type = &key_type_encrypted;
+		set_key = set_key_encrypted;
+	} else {
 		return -EINVAL;
+	}
 
 	new_key_string = kstrdup(key_string, GFP_KERNEL);
 	if (!new_key_string)
 		return -ENOMEM;
 
-	key = request_key(key_string[0] == 'l' ? &key_type_logon : &key_type_user,
+	key = request_key(type,
 			  key_desc + 1, NULL);
 	if (IS_ERR(key)) {
 		kzfree(new_key_string);
@@ -2253,23 +2296,14 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 
 	down_read(&key->sem);
 
-	ukp = user_key_payload_locked(key);
-	if (!ukp) {
-		up_read(&key->sem);
-		key_put(key);
-		kzfree(new_key_string);
-		return -EKEYREVOKED;
-	}
-
-	if (cc->key_size != ukp->datalen) {
+	ret = set_key(cc, key);
+	if (ret < 0) {
 		up_read(&key->sem);
 		key_put(key);
 		kzfree(new_key_string);
-		return -EINVAL;
+		return ret;
 	}
 
-	memcpy(cc->key, ukp->data, cc->key_size);
-
 	up_read(&key->sem);
 	key_put(key);
 
-- 
2.25.1

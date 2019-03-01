From: Franck LENORMAND <franck.lenormand@nxp.com>
Subject: [RFC PATCH 2/2] dm-crypt: Use any key type which is registered
Date: Fri,  1 Mar 2019 17:09:59 +0100
Message-ID: <1551456599-10603-3-git-send-email-franck.lenormand@nxp.com>
References: <1551456599-10603-1-git-send-email-franck.lenormand@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1551456599-10603-1-git-send-email-franck.lenormand@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org
Cc: franck.lenormand@nxp.com, horia.geanta@nxp.com, silvano.dininno@nxp.com, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, dhowells@redhat.com, jmorris@namei.org, serge@hallyn.com
List-Id: dm-devel.ids

There was only 2 key_type supported by dm-crypt which limits other
implementations.

This patch allows to use any key_type which is registered obtaining
the key_type from key framework.

This also remove the compilation dependency between dm-crypt and
key implementations.

Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>
---
 drivers/md/dm-crypt.c    | 11 ++++++-----
 include/linux/key-type.h |  2 ++
 security/keys/key.c      | 42 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index dd538e6..e25efc2 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -35,6 +35,7 @@
 #include <crypto/authenc.h>
 #include <linux/rtnetlink.h> /* for struct rtattr and RTA macros only */
 #include <keys/user-type.h>
+#include <linux/key-type.h>
 
 #include <linux/device-mapper.h>
 
@@ -2010,6 +2011,7 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 	int ret;
 	struct key *key;
 	const struct user_key_payload *ukp;
+	struct key_type *type;
 
 	/*
 	 * Reject key_string with whitespace. dm core currently lacks code for
@@ -2025,16 +2027,15 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 	if (!key_desc || key_desc == key_string || !strlen(key_desc + 1))
 		return -EINVAL;
 
-	if (strncmp(key_string, "logon:", key_desc - key_string + 1) &&
-	    strncmp(key_string, "user:", key_desc - key_string + 1))
-		return -EINVAL;
+	type = get_key_type(key_string, key_desc - key_string);
+	if (!type)
+		return -ENOENT;
 
 	new_key_string = kstrdup(key_string, GFP_KERNEL);
 	if (!new_key_string)
 		return -ENOMEM;
 
-	key = request_key(key_string[0] == 'l' ? &key_type_logon : &key_type_user,
-			  key_desc + 1, NULL);
+	key = request_key(type, key_desc + 1, NULL);
 	if (IS_ERR(key)) {
 		kzfree(new_key_string);
 		return PTR_ERR(key);
diff --git a/include/linux/key-type.h b/include/linux/key-type.h
index bc9af55..2b2167b 100644
--- a/include/linux/key-type.h
+++ b/include/linux/key-type.h
@@ -176,6 +176,8 @@ extern struct key_type key_type_keyring;
 extern int register_key_type(struct key_type *ktype);
 extern void unregister_key_type(struct key_type *ktype);
 
+extern struct key_type *get_key_type(const char *type_name, size_t string_size);
+
 extern int key_payload_reserve(struct key *key, size_t datalen);
 extern int key_instantiate_and_link(struct key *key,
 				    const void *data,
diff --git a/security/keys/key.c b/security/keys/key.c
index 44a80d6..ef76114 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -1156,6 +1156,48 @@ void unregister_key_type(struct key_type *ktype)
 }
 EXPORT_SYMBOL(unregister_key_type);
 
+/**
+ * get_key_type - Get the type of key using its name
+ * @type_name: Name of the key type to get
+ * @string_size: Size of the string to match
+ *
+ * The functions support null ended string (string_size == 0) as well as
+ * pointer on a string matching a number of characters (string_size > 0)
+ *
+ * Returns a pointer on the key type if successful, -ENOENT if the key type
+ * is not registered.
+ */
+struct key_type *get_key_type(const char *type_name, size_t string_size)
+{
+	struct key_type *p;
+	struct key_type *ktype = ERR_PTR(-ENOENT);
+
+	if (!type_name)
+		return ktype;
+
+	down_write(&key_types_sem);
+
+	/* Search the key type in the list */
+	list_for_each_entry(p, &key_types_list, link) {
+		if (string_size) {
+			if (strncmp(p->name, type_name, string_size) == 0) {
+				ktype = p;
+				break;
+			}
+		} else {
+			if (strcmp(p->name, type_name) == 0) {
+				ktype = p;
+				break;
+			}
+		}
+	}
+
+	up_read(&key_types_sem);
+
+	return ktype;
+}
+EXPORT_SYMBOL(get_key_type);
+
 /*
  * Initialise the key management state.
  */
-- 
2.7.4

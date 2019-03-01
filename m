From: Franck LENORMAND <franck.lenormand@nxp.com>
Subject: [RFC PATCH 1/2] drivers: crypto: caam: key: Add caam_tk key type
Date: Fri,  1 Mar 2019 17:09:58 +0100
Message-ID: <1551456599-10603-2-git-send-email-franck.lenormand@nxp.com>
References: <1551456599-10603-1-git-send-email-franck.lenormand@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1551456599-10603-1-git-send-email-franck.lenormand@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org
Cc: franck.lenormand@nxp.com, horia.geanta@nxp.com, silvano.dininno@nxp.com, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, dhowells@redhat.com, jmorris@namei.org, serge@hallyn.com
List-Id: dm-devel.ids

This patch adds a module which creates a new key type which
can be used by the user with the linux key retention service.

The key created by this module are black keys appended with
a tag to create a tag key.
Such a key can be passed to the linux crypto API for the
transforms:
 - tk(cbc(aes))

The configuration string passed to the key service has 3
forms:
 - new <black key encryption> <size in bytes>
 - set <black key encryption> <hex of a key>
 - load <black key encryption> <hex of a blob>
with <black key encryption> = ecb | ccm

When reading or printing a key, it will return a binary blob
which can be saved to a file through powercycle. The blob
can then be loaded.

V2: Expect the data to be loaded to be prepended by ':hex:'

Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>
---
 drivers/crypto/caam/caam_key.c | 623 +++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/caam/caam_key.h |  58 ++++
 2 files changed, 681 insertions(+)
 create mode 100644 drivers/crypto/caam/caam_key.c
 create mode 100644 drivers/crypto/caam/caam_key.h

diff --git a/drivers/crypto/caam/caam_key.c b/drivers/crypto/caam/caam_key.c
new file mode 100644
index 0000000..5d89c9d
--- /dev/null
+++ b/drivers/crypto/caam/caam_key.c
@@ -0,0 +1,623 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2018 NXP
+ * caam key is generated using NXP CAAM hardware block. CAAM generates the
+ * random number (used as a key) and creates its blob for the user.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/parser.h>
+#include <linux/string.h>
+#include <linux/key-type.h>
+#include <linux/rcupdate.h>
+#include <linux/completion.h>
+#include <linux/module.h>
+
+#include "desc.h"
+#include "desc_constr.h"
+#include "caam_desc.h"
+#include "caam_key.h"
+#include "caam_util.h"
+
+/* Key modifier for CAAM key blobbing */
+static const char caam_key_modifier[KEYMOD_SIZE_GM] = {
+	'C', 'A', 'A', 'M', '_', 'K', 'E', 'Y',
+	'_', 'T', 'Y', 'P', 'E', '_', 'V', '1',
+};
+
+/* Operation supported */
+enum caam_key_op {
+	OP_ERROR = -1,
+	OP_NEW_KEY,
+	OP_SET_KEY,
+	OP_LOAD_BLOB,
+};
+
+/* Tokens for the operation to do */
+static const match_table_t key_cmd_tokens = {
+	{OP_NEW_KEY, "new"},
+	{OP_SET_KEY, "set"},
+	{OP_LOAD_BLOB, "load"},
+	{OP_ERROR, NULL}
+};
+
+enum caam_key_fmt {
+	FMT_ERROR = -1,
+	FMT_ECB,
+	FMT_CCM,
+};
+
+/* Tokens for the type of encryption of the black key */
+static const char FMT_ECB_txt[] = "ecb";
+static const char FMT_CCM_txt[] = "ccm";
+
+static const match_table_t key_fmt_tokens = {
+	{FMT_ECB, FMT_ECB_txt},
+	{FMT_CCM, FMT_CCM_txt},
+	{FMT_ERROR, NULL}
+};
+
+int caam_key_tag_black_key(struct caam_key_payload *ckpayload,
+			   size_t black_key_max_len, u8 auth, u8 trusted)
+{
+	struct tag_object_conf tag;
+	enum tag_type type;
+	int ret;
+	u32 size_tagged = black_key_max_len;
+
+	if (!ckpayload)
+		return -EINVAL;
+
+	if (!is_auth(auth) || !is_trusted_key(trusted))
+		return -EINVAL;
+
+	if (auth == KEY_COVER_ECB) {
+		if (trusted == UNTRUSTED_KEY)
+			type = TAG_TYPE_BLACK_KEY_ECB;
+		else
+			type = TAG_TYPE_BLACK_KEY_ECB_TRUSTED;
+	} else {
+		if (trusted == UNTRUSTED_KEY)
+			type = TAG_TYPE_BLACK_KEY_CCM;
+		else
+			type = TAG_TYPE_BLACK_KEY_CCM_TRUSTED;
+	}
+
+	/* Prepare the tag */
+	init_tag_object_header(&tag.header, type);
+	init_blackey_conf(&tag.conf.bk_conf, ckpayload->key_len,
+			  auth == KEY_COVER_CCM,
+			  trusted == TRUSTED_KEY);
+
+	ret = set_tag_object_conf(&tag, ckpayload->black_key,
+				  ckpayload->black_key_len, &size_tagged);
+	if (ret) {
+		pr_err("Tagging fail: %d\n", ret);
+		goto exit;
+	}
+
+	/* Update the size of the black key tagged */
+	ckpayload->black_key_len = size_tagged;
+
+exit:
+	return ret;
+}
+
+static int caam_transform(enum caam_key_op key_cmd,
+			  struct caam_key_payload *ckpayload)
+{
+	int ret;
+	struct device *jrdev;
+	u8 key_cover;
+
+	/* Allocate caam job ring for operation to be performed from CAAM */
+	jrdev = caam_jr_alloc();
+	if (!jrdev) {
+		pr_info("caam_jr_alloc failed\n");
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if (ckpayload->key_fmt_val == FMT_ECB)
+		key_cover = KEY_COVER_ECB;
+	else
+		key_cover = KEY_COVER_CCM;
+
+	switch (key_cmd) {
+	case OP_LOAD_BLOB:
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "input blob: ",
+		       DUMP_PREFIX_OFFSET, 16, 4, ckpayload->blob,
+		       ckpayload->blob_len, 0);
+#endif
+		/* Decapsulate the black blob into a black key */
+		ret = caam_blob_decap(jrdev,
+				      ckpayload->blob, ckpayload->blob_len,
+				      DATA_GENMEM, BLACK_BLOB,
+				      ckpayload->key_mod,
+				      &ckpayload->key_mod_len, DATA_GENMEM,
+				      ckpayload->black_key,
+				      &ckpayload->black_key_len, DATA_GENMEM,
+				      BLACK_KEY, &ckpayload->key_len,
+				      key_cover, UNTRUSTED_KEY);
+		if (ret) {
+			pr_info("key_blob decap fail: %d\n", ret);
+			goto free_jr;
+		}
+
+		break;
+	case OP_SET_KEY:
+
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "input key: ",
+		       DUMP_PREFIX_OFFSET, 16, 4, ckpayload->key,
+		       ckpayload->key_len, 0);
+#endif
+
+		/* Cover the input key  */
+		ret = caam_black_key(jrdev,
+				     ckpayload->key, ckpayload->key_len,
+				     DATA_GENMEM,
+				     ckpayload->black_key,
+				     &ckpayload->black_key_len, DATA_GENMEM,
+				     key_cover, UNTRUSTED_KEY);
+		/*
+		 * Clear the input key
+		 * TODO: Make it secure to not be removed by compiler
+		 */
+		memset(ckpayload->key, 0, ckpayload->key_len);
+
+		if (ret) {
+			pr_info("key covering fail: (%d)\n", ret);
+			goto free_jr;
+		}
+
+		/* Encapsulate the key  */
+		ret = caam_blob_encap(jrdev,
+				      ckpayload->black_key,
+				      ckpayload->black_key_len, DATA_GENMEM,
+				      BLACK_KEY, ckpayload->key_len, key_cover,
+				      UNTRUSTED_KEY,
+				      ckpayload->key_mod,
+				      &ckpayload->key_mod_len, DATA_GENMEM,
+				      ckpayload->blob, &ckpayload->blob_len,
+				      DATA_GENMEM, BLACK_BLOB);
+		if (ret) {
+			pr_info("Blob encapsulation of key fail: %d\n", ret);
+			goto free_jr;
+		}
+
+		break;
+	case OP_NEW_KEY:
+		/*
+		 * We need random data to create a key however we do not
+		 * want
+		 */
+		ret = caam_random_black_key(jrdev,
+					    ckpayload->key_len,
+					    ckpayload->black_key,
+					    &ckpayload->black_key_len,
+					    DATA_GENMEM, key_cover,
+					    UNTRUSTED_KEY);
+
+		if (ret) {
+			pr_info("Random key covering fail: %d\n", ret);
+			goto free_jr;
+		}
+
+		/* Encapsulate the key  */
+		ret = caam_blob_encap(jrdev,
+				      ckpayload->black_key,
+				      ckpayload->black_key_len, DATA_GENMEM,
+				      BLACK_KEY, ckpayload->key_len, key_cover,
+				      UNTRUSTED_KEY,
+				      ckpayload->key_mod,
+				      &ckpayload->key_mod_len, DATA_GENMEM,
+				      ckpayload->blob, &ckpayload->blob_len,
+				      DATA_GENMEM, BLACK_BLOB);
+		if (ret) {
+			pr_info("Blob encapsulation of random fail: %d\n", ret);
+			goto free_jr;
+		}
+
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "black key: ",
+		       DUMP_PREFIX_OFFSET, 16, 4, ckpayload->black_key,
+		       ckpayload->black_key_len, 0);
+	print_hex_dump(KERN_ERR, "blob: ",
+		       DUMP_PREFIX_OFFSET, 16, 4, ckpayload->blob,
+		       ckpayload->blob_len, 0);
+#endif
+
+	/* Tag the black key so it can be passed to CAAM crypto API */
+	ret = caam_key_tag_black_key(ckpayload,
+				     ARRAY_SIZE(ckpayload->black_key),
+				     key_cover, UNTRUSTED_KEY);
+	if (ret) {
+		pr_info("Black key tagging fail: %d\n", ret);
+		goto free_jr;
+	}
+
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "tagged black key: ",
+		       DUMP_PREFIX_OFFSET, 16, 4, ckpayload->black_key,
+		       ckpayload->black_key_len, 0);
+#endif
+
+	/* Update the aliased user_key_payload */
+	ckpayload->upayload.datalen = ckpayload->black_key_len;
+	memcpy(ckpayload->upayload.data, ckpayload->black_key,
+	       ckpayload->upayload.datalen);
+
+free_jr:
+	caam_jr_free(jrdev);
+
+out:
+	if (ret)
+		pr_err("Operation %s(%d) failed\n",
+		       key_cmd_tokens[key_cmd].pattern, key_cmd);
+
+	return ret;
+}
+
+/*
+ * parse_inputdata - parse the keyctl input data and fill in the
+ *		     payload structure for key or its blob.
+ * param[in]: data pointer to the data to be parsed for creating key.
+ * param[in]: p pointer to caam key payload structure to fill parsed data
+ * On success returns 0, otherwise -EINVAL.
+ */
+static enum caam_key_op parse_inputdata(char *data,
+					struct caam_key_payload *ckpayload)
+{
+	substring_t args[MAX_OPT_ARGS];
+	long keylen = 0;
+	int ret = 0;
+	enum caam_key_op op_to_do = OP_ERROR;
+	int key_cmd = -EINVAL;
+	int key_fmt = -EINVAL;
+	char *c = NULL;
+	const char *hex_format = ":hex:";
+	u32 hex_format_size;
+
+	c = strsep(&data, " \t");
+	if (!c) {
+		ret = -EINVAL;
+		pr_err("Failed to find 1st arg\n");
+		goto out;
+	}
+
+	/* Get the keyctl command i.e. new_key or load_blob etc */
+	key_cmd = match_token(c, key_cmd_tokens, args);
+
+	/* Skip spaces to get the 1st argument */
+	c = strsep(&data, " \t");
+	if (!c) {
+		ret = -EINVAL;
+		pr_err("Failed to find 2nd arg\n");
+		goto out;
+	}
+
+	/* Get the keyctl format i.e. ecb or ccm etc */
+	key_fmt = match_token(c, key_fmt_tokens, args);
+
+	/* Skip spaces to get second argument */
+	c = strsep(&data, " \t");
+	if (!c) {
+		ret = -EINVAL;
+		pr_err("Failed to find 3rd arg\n");
+		goto out;
+	}
+
+	switch (key_fmt) {
+	case FMT_ECB:
+		ckpayload->key_fmt_val = KEY_COVER_ECB;
+		break;
+	case FMT_CCM:
+		ckpayload->key_fmt_val = KEY_COVER_CCM;
+		break;
+	case FMT_ERROR:
+		ret = -EINVAL;
+		pr_err("Format %d not supported\n", key_fmt);
+		goto out;
+	}
+
+	/* Prepare arguments */
+	switch (key_cmd) {
+	case OP_NEW_KEY:
+		/* Second argument is key size */
+		ret = kstrtol(c, 10, &keylen);
+		if (ret < 0 || keylen < MIN_KEY_SIZE ||
+		    keylen > MAX_KEY_SIZE) {
+			ret = -EINVAL;
+			pr_err("Failed to retrieve key length\n");
+			goto out;
+		}
+
+		ckpayload->key_len = keylen;
+
+		ckpayload->black_key_len = ARRAY_SIZE(ckpayload->black_key);
+		ckpayload->blob_len = ARRAY_SIZE(ckpayload->blob);
+
+		op_to_do = OP_NEW_KEY;
+
+		break;
+	case OP_SET_KEY:
+		/* Second argument is key data for CAAM*/
+
+		/* key_len = No of characters in key/2 */
+		ckpayload->key_len = strlen(c) / 2;
+		if (ckpayload->blob_len > MAX_KEY_SIZE) {
+			ret = -EINVAL;
+			pr_err("Failed to compute key length\n");
+			goto out;
+		}
+
+		ret = hex2bin(ckpayload->key, c, ckpayload->key_len);
+		if (ret < 0) {
+			ret = -EINVAL;
+			pr_err("Failed to retrieve key data\n");
+			goto out;
+		}
+
+		ckpayload->black_key_len = ARRAY_SIZE(ckpayload->black_key);
+		ckpayload->blob_len = ARRAY_SIZE(ckpayload->blob);
+
+		op_to_do = OP_SET_KEY;
+
+		break;
+	case OP_LOAD_BLOB:
+		/* Second argument is blob data for CAAM */
+		hex_format_size = strlen(hex_format);
+
+		/* The blob is prepended by the format */
+		if (strncmp(c, hex_format, hex_format_size) != 0) {
+			ret = -EINVAL;
+			pr_err("Failed to match blob format\n");
+			goto out;
+		}
+
+		/* Advance the pointer */
+		c += hex_format_size;
+
+		/* Blob_len = No of characters in blob/2 */
+		ckpayload->blob_len = strlen(c) / 2;
+		if (ckpayload->blob_len > MAX_BLOB_SIZE) {
+			ret = -EINVAL;
+			pr_err("Failed to compute blob length\n");
+			goto out;
+		}
+
+		ret = hex2bin(ckpayload->blob, c, ckpayload->blob_len);
+		if (ret < 0) {
+			ret = -EINVAL;
+			pr_err("Failed to retrieve blob data\n");
+			goto out;
+		}
+
+		ckpayload->key_len = ARRAY_SIZE(ckpayload->key);
+		ckpayload->black_key_len = ARRAY_SIZE(ckpayload->black_key);
+
+		op_to_do = OP_LOAD_BLOB;
+
+		break;
+	case OP_ERROR:
+		ret = -EINVAL;
+		pr_err("Command %d not supported\n", key_cmd);
+		break;
+	}
+
+	ckpayload->key_mod = caam_key_modifier;
+	ckpayload->key_mod_len = ARRAY_SIZE(caam_key_modifier);
+
+out:
+	return (ret == 0) ? op_to_do : OP_ERROR;
+}
+
+static struct caam_key_payload *caam_payload_alloc(struct key *key)
+{
+	struct caam_key_payload *ckpayload = NULL;
+	int ret = 0;
+
+	ret = key_payload_reserve(key, sizeof(*ckpayload));
+	if (ret < 0) {
+		pr_err("Failed to reserve payload\n");
+		goto out;
+	}
+
+	ckpayload = kzalloc(sizeof(*ckpayload), GFP_KERNEL);
+	if (!ckpayload)
+		goto out;
+
+out:
+	return ckpayload;
+}
+
+/*
+ * caam_destroy - clear and free the key's payload
+ */
+static void caam_destroy(struct key *key)
+{
+	struct caam_key_payload *ckpayload = NULL;
+
+	/* Retrieve the payload */
+	ckpayload = dereference_key_locked(key);
+	if (!ckpayload)
+		pr_err("Fail to retrieve key payload\n");
+
+	kzfree(ckpayload);
+}
+
+/*
+ * caam_instantiate - create a new caam type key.
+ * Supports the operation to generate a new key. A random number
+ * is generated from CAAM as key data and the corresponding red blob
+ * is formed and stored as key_blob.
+ * Also supports the operation to load the blob and key is derived using
+ * that blob from CAAM.
+ * On success, return 0. Otherwise return errno.
+ */
+static int caam_instantiate(struct key *key,
+			    struct key_preparsed_payload *prep)
+{
+	struct caam_key_payload *ckpayload;
+	size_t datalen;
+	char *data = NULL;
+	int key_cmd = 0;
+	int ret = 0;
+
+	if (!key || !prep) {
+		ret = -EINVAL;
+		pr_err("Input data incorrect\n");
+		goto out;
+	}
+
+	datalen = prep->datalen;
+
+	if (datalen <= 0 || datalen > 32767) {
+		ret = -EINVAL;
+		pr_err("Payload data size incorrect\n");
+		goto out;
+	}
+
+	/* Allocate memory to get a parsable string */
+	data = kmalloc(datalen + 1, GFP_KERNEL);
+	if (!data) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(data, prep->data, datalen);
+	data[datalen] = '\0';
+
+	ckpayload = caam_payload_alloc(key);
+	if (!ckpayload) {
+		pr_err("Fail to allocate payload\n");
+		ret = -ENOMEM;
+		goto free_data;
+	}
+
+	/* Initialize and fill the payload */
+	key_cmd = parse_inputdata(data, ckpayload);
+	if (key_cmd == OP_ERROR) {
+		pr_err("Fail to parse data\n");
+		ret = key_cmd;
+		goto free_payload;
+	}
+
+	/* Create the black key and/or the blob */
+	caam_transform(key_cmd, ckpayload);
+	if (ret != 0) {
+		pr_info("transform fail (%d)\n", ret);
+		goto free_payload;
+	}
+
+	/* Store the payload to the key */
+	rcu_assign_keypointer(key, ckpayload);
+
+	goto out;
+
+free_payload:
+	kzfree(ckpayload);
+
+free_data:
+	kzfree(data);
+
+out:
+	return ret;
+}
+
+/*
+ * caam_read - copy the blob data to userspace.
+ * param[in]: key pointer to key struct
+ * param[in]: buffer pointer to user data for creating key
+ * param[in]: buflen is the length of the buffer
+ * On success, return to userspace the caam key data size.
+ */
+static long caam_read(const struct key *key, char __user *buffer, size_t buflen)
+{
+	const struct caam_key_payload *ckpayload = NULL;
+	size_t size_to_copy;
+	size_t size_copied = 0;
+	unsigned long not_copied;
+	char *to = buffer;
+
+	/* Retrieve the payload */
+	ckpayload = dereference_key_locked(key);
+	if (!ckpayload) {
+		pr_err("Fail to retrieve key payload\n");
+		return -EINVAL;
+	}
+
+	/* Check all the data can be copied */
+	size_to_copy = ckpayload->blob_len;
+
+	/* If buflen == 0, the user request the size needed */
+	if (buflen == 0)
+		return size_to_copy;
+
+	/* Check the buffer */
+	if (!buffer) {
+		pr_err("Buffer not set\n");
+		return -EINVAL;
+	}
+
+	/* Check the buffer is big enough */
+	if (size_to_copy > buflen) {
+		pr_err("Buffer length too short\n");
+		return -ENOMEM;
+	}
+
+	/* Copy blob */
+	not_copied = copy_to_user(to, ckpayload->blob, ckpayload->blob_len);
+	if (not_copied != 0) {
+		pr_err("Copy of black blob failed\n");
+		return -EIO;
+	}
+	size_copied += ckpayload->blob_len;
+
+	if (size_to_copy != size_copied)
+		pr_info("Mismatch between size computed and copied\n");
+
+	return size_copied;
+}
+
+/* Description of the key type for CAAM keys */
+struct key_type key_type_caam_tk = {
+	.name = "caam_tk",
+	.instantiate = caam_instantiate,
+	.destroy = caam_destroy,
+	.read = caam_read,
+};
+EXPORT_SYMBOL_GPL(key_type_caam_tk);
+
+static int __init init_caam_key(void)
+{
+	int ret;
+
+	ret = register_key_type(&key_type_caam_tk);
+	if (ret) {
+		pr_err("Failed to register key storage %s\n",
+		       key_type_caam_tk.name);
+		return -EIO;
+	}
+
+	return ret;
+}
+
+static void __exit cleanup_caam_key(void)
+{
+	unregister_key_type(&key_type_caam_tk);
+}
+
+late_initcall(init_caam_key);
+module_exit(cleanup_caam_key);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/crypto/caam/caam_key.h b/drivers/crypto/caam/caam_key.h
new file mode 100644
index 0000000..93273ea
--- /dev/null
+++ b/drivers/crypto/caam/caam_key.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2018 NXP.
+ *
+ */
+
+#ifndef _KEYS_caam_TYPE_H
+#define _KEYS_caam_TYPE_H
+
+#include <linux/rcupdate.h>
+#include <linux/key-type.h>
+#include <keys/user-type.h>
+#include "caam_desc.h"
+#include "tag_object.h"
+
+extern struct key_type key_type_caam_tk;
+
+/* Minimum key size to be used is 32 bytes and maximum key size fixed
+ * is 128 bytes.
+ * Blob size to be kept is Maximum key size + blob header added by CAAM.
+ */
+
+#define MIN_KEY_SIZE                    16
+#define MAX_KEY_SIZE                    128
+
+#define MAX_BLACK_KEY_SIZE               (MAX_KEY_SIZE + CCM_OVERHEAD +\
+						TAG_OVERHEAD)
+
+#define MAX_BLOB_SIZE                   (MAX_KEY_SIZE + BLOB_OVERHEAD)
+
+struct caam_key_payload {
+	/*
+	 * The aliasing of the structure allow user to see this payload
+	 * as a user defined payload
+	 *
+	 * The structure has to be set during execution
+	 */
+	struct aliased_user_key_payload {
+		struct rcu_head	rcu;
+		unsigned short datalen;
+		char data[MAX_BLACK_KEY_SIZE];
+	} upayload;
+
+	size_t key_len;
+	unsigned char key[MAX_KEY_SIZE + 1];
+	int key_fmt_val;
+
+	size_t black_key_len;
+	unsigned char black_key[MAX_BLACK_KEY_SIZE];
+
+	size_t blob_len;
+	unsigned char blob[MAX_BLOB_SIZE];
+
+	size_t key_mod_len;
+	const void *key_mod;
+};
+
+#endif
-- 
2.7.4

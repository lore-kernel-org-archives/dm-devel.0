Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEE53AA1A7
	for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 06:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576862; cv=none; b=W1b4rfMHb6d3z413z+6/ivEZomFYLhdl38lE1i/XAWvftUFgct0AWswfziFSBAtAS9Q2xIkn9vM0jgHgh763hGH6iHDERp4eQChql91Zv8URV417/5jRDlqnxDJD4bHVFcrrLhMRIAzd5t70+uWlpqP3/66oCsMHWEJIZXegdiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576862; c=relaxed/simple;
	bh=YeBrKtErCddADb0UxtBzrxhMam6DPdqNTOHPK0vJvnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BF+vpvpyJN5JLrRsLJHoUFEmdulgeT/oyRn6VL70OkoePke3TNzPZ+u7OfLCFPrCMW3nhpNFPgdMA+6ob40a1ciAvwG35rSaLgm8BA5naDPM79Y7renmG9zoRmFs/U0nvFSP6zW/E5tm8NcKmO8bxIfrwkbZ6AQdOBt7eze9eMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at; spf=pass smtp.mailfrom=sigma-star.at; dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b=iftDMGKg; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b="iftDMGKg"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49e6598dd44so15526005e9.1
        for <dm-devel@lists.linux.dev>; Sun, 27 Sep 2026 23:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sigma-star.at; s=google; t=1790576858; x=1791181658; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mtksZ2BZrwU7+h7DNG+Yo/8fCJDmorgsU5bKQzZ304k=;
        b=iftDMGKgrOaZmptshj5xLMbITYUDaPXBgc17PwQfaj7OREgihNiqsdtLYNWxKUTyEL
         smRRKdqAHx3ZRitjKrxFNk+vUK1tQjYo+FierbRb4sy1OxrV4/5CvcrOGch15lgxotNd
         wq9GQcFfj2laOfYcl1Ewtg2LefT9MC1kI33ZPjEcFX0+xtXdtCUpkGgIT4NjkLKCSnFy
         17e2ga7QzINmuJIvoxdx1FDV5BKmBJVvonSqnTfum9fMAsoarL45BOjY7wEkkM/PrClB
         WkhbjsR5kgVo6xeCmYrZ5Oj8ZOgoC3ijVCb0XMtxQ1Q+ccFuoW5KIvAb1NWLpsrwAOTT
         4P4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790576858; x=1791181658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mtksZ2BZrwU7+h7DNG+Yo/8fCJDmorgsU5bKQzZ304k=;
        b=JJsoCZ6THjfRXWdFPFHlnJzNZPF9ayhRe4tHODGozYqRQIJQUgPqs5UwdGYLYVS0Cq
         R/khPVDelSdZGTf1gWJOGoHWoa7/Kllqc4KmZMskda43DAHmw2lbT1H/yU7id6ptNBSn
         znNm0L3sARjHHBAFoLCW2jINEZXBkAm3zGFdC0vycJ5hzL+hTlplbNLs6n1qBY54rbxe
         WiutiVy5WwXMYCzfHPCOrYTMA+ZEtZ1g7frjxzPSC6mmG6KOKdO8MPJRz2A7OTRpOSG6
         EbNvzPB4yRbX14OOq+5tPBv4WMVI/dsmypzJbjGqKleHGegS1McamAQnsO9Vo9Hh72f8
         NlSQ==
X-Gm-Message-State: AFuF++nHjhW0UmoGmnbGW3PFvn4evXbCRWYkZmqed0UXuCLvgbYsoGkJ
	cGozGYH8ncIlKSjiUv4ILwKO29ifqMRTpVVcV5TxVs8S0Pk2KdoApyZn2GMmcAuaUys=
X-Gm-Gg: AYBFou0ouz0n523L894FCF5G30qMeUJBPHpRUn/y/fK8zrPcoX85IvcIx2RgaKaMA8Z
	ISIJO8gpRSS5v/sqkBixAFP1phXz2a1dKmjMZMUzToX/g/04OTLnruZ2IrS4XwFejxUvH2ZLZpJ
	gs+cl+CcdZfhPH7pEy1Rj3z/50PcY+vBBR2oCKNqpyhGfEgXAJYYKW3rNaX8avHgppEMDQeZiQ5
	EXCT2wL6xwzqB2OH+Xp7SuLAIFuKdWmoGjJnsVPd93bQ4g42Cz0tIYLKWndx/ictUrtPzg1XyvF
	J1smW3kRZeonzm8DUotBH7DPNAFdk9FdpUlGr8UUx7jz7mec1rOQSbWs711Y0w7OkJi+mhmIwR4
	UWAaqG2Lu5hTEz5uOcVFp/L2dDmJoP2hywfMG5yKTrtaM70OZdzwyXni/wfmoP4PTdzJJpT+urF
	z+MEHiF4pPrroG6gLl7tQlONC0PmhoUBB5A5/79swD1ExbA81cHYs7D2KXLMKr67qthlxxYKNHh
	SMYSz6G1A==
X-Received: by 2002:a05:600c:3494:b0:49f:ff73:9971 with SMTP id 5b1f17b1804b1-49fff7399f4mr64064235e9.18.1790576857980;
        Sun, 27 Sep 2026 23:27:37 -0700 (PDT)
Received: from losig.fritz.box ([2a04:9546:1c54:8601:c375:8df8:9c4c:d013])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a007fd1847sm25431615e9.1.2026.09.27.23.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 23:27:37 -0700 (PDT)
From: Lorenz Kofler <lorenz@sigma-star.at>
To: Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	upstream+dm@sigma-star.at,
	Lorenz Kofler <lorenz@sigma-star.at>
Subject: [RFC PATCH 1/1] dm-integrity: support keys in the kernel keyring
Date: Mon, 28 Sep 2026 08:27:34 +0200
Message-ID: <20260928062734.3805458-2-lorenz@sigma-star.at>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928062734.3805458-1-lorenz@sigma-star.at>
References: <20260928062734.3805458-1-lorenz@sigma-star.at>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The keys of internal_hash, journal_crypt and journal_mac can only be
given as hex strings in the table. Keys that never leave the kernel,
such as trusted keys, cannot be used.

In addition to hex strings, accept keys from the kernel keyring in the
same format as dm-crypt: ":<key_size>:<key_type>:<key_description>".
The lookup is the same as in dm-crypt.

Like DM_CRYPT, DM_INTEGRITY must not be built in when the encrypted or
trusted key types are modules.

Signed-off-by: Lorenz Kofler <lorenz@sigma-star.at>
---
 .../device-mapper/dm-integrity.rst            |  25 +++
 drivers/md/Kconfig                            |   2 +
 drivers/md/dm-integrity.c                     | 164 ++++++++++++++++++
 3 files changed, 191 insertions(+)

diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/Documentation/admin-guide/device-mapper/dm-integrity.rst
index 9c21301423c9..2b7f82912962 100644
--- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
+++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
@@ -146,6 +146,8 @@ internal_hash:algorithm(:key)	(the key is optional)
 	from an upper layer target, such as dm-crypt. The upper layer
 	target should check the validity of the integrity tags.
 
+	The format of the key is described below the list of arguments.
+
 recalculate
 	Recalculate the integrity tags automatically. It is only valid
 	when using internal hash.
@@ -162,6 +164,8 @@ journal_crypt:algorithm(:key)	(the key is optional)
 	the size of files that were written. To protect against this
 	situation, you can encrypt the journal.
 
+	The format of the key is described below the list of arguments.
+
 journal_mac:algorithm(:key)	(the key is optional)
 	Protect sector numbers in the journal from accidental or malicious
 	modification. To protect against accidental modification, use a
@@ -173,6 +177,8 @@ journal_mac:algorithm(:key)	(the key is optional)
 	the journal. Thus, modified sector number would be detected at
 	this stage.
 
+	The format of the key is described below the list of arguments.
+
 block_size:number (default 512)
 	The size of a data block in bytes. The larger the block size the
 	less overhead there is for per-block integrity metadata.
@@ -225,6 +231,25 @@ legacy_recalculate
 	set recalc_sector to zero, and the kernel would not detect the
 	modification.
 
+The key of internal_hash, journal_crypt and journal_mac is encoded either as
+a hexadecimal number or it can be passed as <key_string> prefixed with single
+colon character (':') for keys residing in kernel keyring service.
+
+<key_string>
+	The kernel keyring key is identified by string in following format:
+	<key_size>:<key_type>:<key_description>.
+
+<key_size>
+	The key size in bytes. The kernel key payload size must match
+	the value passed in <key_size>.
+
+<key_type>
+	Either 'logon', 'user', 'encrypted' or 'trusted' kernel key type.
+
+<key_description>
+	The kernel keyring key description integrity target should look for
+	when loading key of <key_type>.
+
 The journal mode (D/J), buffer_sectors, journal_watermark, commit_time and
 allow_discards can be changed when reloading the target (load an inactive
 table and swap the tables with suspend and resume). The other arguments
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index df27c7d066d2..e93bf0c3119d 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -653,6 +653,8 @@ config DM_LOG_WRITES
 config DM_INTEGRITY
 	tristate "Integrity target support"
 	depends on BLK_DEV_DM
+	depends on (ENCRYPTED_KEYS || ENCRYPTED_KEYS=n)
+	depends on (TRUSTED_KEYS || TRUSTED_KEYS=n)
 	select BLK_DEV_INTEGRITY
 	select DM_BUFIO
 	select CRYPTO
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 92970e12267a..6995c870cbf5 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -25,6 +25,11 @@
 #include <crypto/utils.h>
 #include <linux/async_tx.h>
 #include <linux/dm-bufio.h>
+#include <linux/ctype.h>
+#include <linux/key.h>
+#include <keys/user-type.h>
+#include <keys/encrypted-type.h>
+#include <keys/trusted-type.h>
 
 #include "dm-audit.h"
 
@@ -4415,6 +4420,152 @@ static void free_alg(struct alg_spec *a)
 	memset(a, 0, sizeof(*a));
 }
 
+#ifdef CONFIG_KEYS
+
+static bool contains_whitespace(const char *str)
+{
+	while (*str)
+		if (isspace(*str++))
+			return true;
+	return false;
+}
+
+static int set_key_user(struct alg_spec *a, struct key *key)
+{
+	const struct user_key_payload *ukp;
+
+	ukp = user_key_payload_locked(key);
+	if (!ukp)
+		return -EKEYREVOKED;
+
+	if (a->key_size != ukp->datalen)
+		return -EINVAL;
+
+	memcpy(a->key, ukp->data, a->key_size);
+
+	return 0;
+}
+
+static int set_key_encrypted(struct alg_spec *a, struct key *key)
+{
+	const struct encrypted_key_payload *ekp;
+
+	ekp = key->payload.data[0];
+	if (!ekp)
+		return -EKEYREVOKED;
+
+	if (a->key_size != ekp->decrypted_datalen)
+		return -EINVAL;
+
+	memcpy(a->key, ekp->decrypted_data, a->key_size);
+
+	return 0;
+}
+
+static int set_key_trusted(struct alg_spec *a, struct key *key)
+{
+	const struct trusted_key_payload *tkp;
+
+	tkp = key->payload.data[0];
+	if (!tkp)
+		return -EKEYREVOKED;
+
+	if (a->key_size != tkp->key_len)
+		return -EINVAL;
+
+	memcpy(a->key, tkp->key, a->key_size);
+
+	return 0;
+}
+
+/*
+ * Load the key from the kernel keyring. a->key_string has the format
+ * ":<key_size>:<key_type>:<key_description>".
+ */
+static int get_alg_key_from_keyring(struct alg_spec *a)
+{
+	int (*set_key)(struct alg_spec *a, struct key *key);
+	const char *key_type_desc, *key_desc;
+	struct key_type *type;
+	unsigned int key_size;
+	struct key *key;
+	char dummy;
+	int r;
+
+	/*
+	 * Reject key_string with whitespace. dm core currently lacks code for
+	 * proper whitespace escaping in arguments on DM_TABLE_STATUS path.
+	 */
+	if (contains_whitespace(a->key_string))
+		return -EINVAL;
+
+	if (sscanf(a->key_string, ":%u%c", &key_size, &dummy) != 2 || dummy != ':')
+		return -EINVAL;
+	if (!key_size || key_size > KMALLOC_MAX_SIZE)
+		return -EINVAL;
+
+	/* skip ":<key_size>:", the sscanf() above guarantees the second ':' */
+	key_type_desc = strchr(a->key_string + 1, ':') + 1;
+
+	/* look for next ':' separating key_type from key_description */
+	key_desc = strchr(key_type_desc, ':');
+	if (!key_desc || key_desc == key_type_desc || !strlen(key_desc + 1))
+		return -EINVAL;
+
+	if (!strncmp(key_type_desc, "logon:", key_desc - key_type_desc + 1)) {
+		type = &key_type_logon;
+		set_key = set_key_user;
+	} else if (!strncmp(key_type_desc, "user:", key_desc - key_type_desc + 1)) {
+		type = &key_type_user;
+		set_key = set_key_user;
+	} else if (IS_ENABLED(CONFIG_ENCRYPTED_KEYS) &&
+		   !strncmp(key_type_desc, "encrypted:", key_desc - key_type_desc + 1)) {
+		type = &key_type_encrypted;
+		set_key = set_key_encrypted;
+	} else if (IS_ENABLED(CONFIG_TRUSTED_KEYS) &&
+		   !strncmp(key_type_desc, "trusted:", key_desc - key_type_desc + 1)) {
+		type = &key_type_trusted;
+		set_key = set_key_trusted;
+	} else {
+		return -EINVAL;
+	}
+
+	a->key = kmalloc(key_size, GFP_KERNEL);
+	if (!a->key)
+		return -ENOMEM;
+	a->key_size = key_size;
+
+	key = request_key(type, key_desc + 1, NULL);
+	if (IS_ERR(key)) {
+		r = PTR_ERR(key);
+		goto free_key;
+	}
+
+	down_read(&key->sem);
+	r = set_key(a, key);
+	up_read(&key->sem);
+	key_put(key);
+	if (r < 0)
+		goto free_key;
+
+	return 0;
+
+free_key:
+	kfree_sensitive(a->key);
+	a->key = NULL;
+	a->key_size = 0;
+	return r;
+}
+
+#else
+
+static int get_alg_key_from_keyring(struct alg_spec *a)
+{
+	return -EINVAL;
+}
+
+#endif /* CONFIG_KEYS */
+
 static int get_alg_and_key(const char *arg, struct alg_spec *a, char **error, char *error_inval)
 {
 	char *k;
@@ -4429,6 +4580,19 @@ static int get_alg_and_key(const char *arg, struct alg_spec *a, char **error, ch
 	if (k) {
 		*k = 0;
 		a->key_string = k + 1;
+
+		if (a->key_string[0] == ':') {
+			int r = get_alg_key_from_keyring(a);
+
+			if (r == -ENOMEM)
+				goto nomem;
+			if (r == -EINVAL)
+				goto inval;
+			if (r)
+				*error = "Cannot get key from the kernel keyring";
+			return r;
+		}
+
 		if (strlen(a->key_string) & 1)
 			goto inval;
 
-- 
2.55.0


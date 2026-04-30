Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3383FE671
	for <dm-devel@lists.linux.dev>; Thu, 30 Apr 2026 09:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777542777; cv=none; b=heFhs6I6EL4S40oD6Rd2AGvSb4BEmrJU3zDOpAfPgJypQPMTNXt8ToY47JctegbHnRkpn8XGU3rZbwBuwrbgx8NwSsJ6+zVJBdiVlr4ib5nuouzqKlMVkxxnSlVYstQnDstwPo6FeT9297EROV7IEgtVrhUXxVUGscFUIUDKNKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777542777; c=relaxed/simple;
	bh=YF7mURPly9luEsPxd0rpKTFco4gAFRISoSHLxhzDTGs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UCnMgP8zsXpbC59iFizRNzTQCF6MPSqmlGyJUhbbTVollCoLlAWOw6BW8DQ5v/crz0Ns/8IzP8hFg2CYc1U5RIX+MaqNjYZW0pCOOrOoxC92xxzAOlh0AOOBVl0U1yk/mrcQzk9cWRQTR81gCIH+5QN4/eclP5T6gcpd/N0a9zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ka4CJ1Wo; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZIgNARLZ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ka4CJ1Wo";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZIgNARLZ"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63U44ixQ2099753
	for <dm-devel@lists.linux.dev>; Thu, 30 Apr 2026 09:52:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=P9J2qAFZbtJ
	tMoP6ap6YXCFw/ZbSjLrqCW/4CstPghA=; b=ka4CJ1WoR6wbSKINquA4bMpqL1F
	X3P8HJzIAc1XwYaBPagk1NJPbTAMUgrAgKRrYij0bhQKilyTYg2pS+sCzHCeWhdh
	pM1ZFYBR3yxnLEQ6cJVVFtvFTA074isbVuEM+8FKyKk9Gbdt13rqXSfMRsr5ynJu
	ZxSnpgN0ppWTNqe3mqa23+WLszb2GKNswELcubTLKICcAnvDpayhO5pdIRNEhGbe
	ZLnEXXslLy7xeE4Xa6CReFENH9ZgcS3zW1xHrMaldP7yMEKAasP04RfPiSCOVyTb
	HnW8XRmS6fPGKpv9f2VBGpo1E/M03956A6v1QdBXaiQX9vnHrVPHdJfGZ7A==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4duyr416jv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Thu, 30 Apr 2026 09:52:53 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-2da19227bc1so2846811eec.1
        for <dm-devel@lists.linux.dev>; Thu, 30 Apr 2026 02:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777542773; x=1778147573; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P9J2qAFZbtJtMoP6ap6YXCFw/ZbSjLrqCW/4CstPghA=;
        b=ZIgNARLZJuc31raiSrWyF6gUT2h0irz+5sOgYHO/MnwKHIqV68k4QYcLztnr/8HAZr
         A6LCc+tf5UUeFuYThMPDeJSFl4ytzpkDIzzLiYM1cKH/82CJH9ewcJsQq2SSnjhWoiUs
         BDTLiTR1Y+IlytNR+U+S2Yvtpe1cdgWfyiQB75QTiwQtKdlmiEitmhWpMakaYwFJPaSQ
         /tFHcDV+9xW9r/4Ddpyr52PNDelwqPEbQT7YdHo2aaP2tORKS23nrpzHTIqK7ygMioAl
         gxl4oVIYsyLFhpDFg8QM7xgX1bPyzt6lU7BII45CAOm6102vRQPwUh0M75fAc86IBSZK
         SJYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777542773; x=1778147573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P9J2qAFZbtJtMoP6ap6YXCFw/ZbSjLrqCW/4CstPghA=;
        b=VyNUgM1Ti5Ttf5/HSNvVRPu2BLJgG+qN3arNFv9TShP9o+Dqwtb8USYowGgo2FRBVE
         Pt7zXE8YgVXtenA9xAmlTtBSejzS/SjlqH3gxVpJ+AvNH9aM4v0zrmEKLxF21FjchMlq
         gbPfSdmotBefu6c+/vLRG/Vsq7oRPs9kT7LBBAxIos0Z9kU/ssH134iBUk27q9s5Pj27
         kvE39nL9MH9KxwKDE/WEWLMalzhuNsAG1Wx4NnafkKpSVvvFtxCo5kEEyhyXoReKd9SL
         gyEilnOpH1kKbRPhcvZIXrW9gKVBGOfaoPYn66J9OqdE5cJfHNiJFq2Alpjv60jnbPMl
         QJNQ==
X-Forwarded-Encrypted: i=1; AFNElJ9vfIMysaF2I+EpmSvmrcNoOAvaSNqun44d11RwWqQpoATe0hLLx5Skxkw0rMbLIoV9FqZG8uVDEw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2kl5u+PaRtu6ztotMBY3sSWH3cWe3y3hHnQ+YYGrOtzXh13+H
	C43Za3Guy3Sn5kcOsnlWtRq2y/Ed9rxXvKpatovc7vITEC0DI32U96itih4aSHMlZPwynUkOChG
	U6yNDGJ3Fz1YeAJqYheHA3bl2HxEKhRRobzOW6BtQ9o+zxGH8mpgHnvMRZie4YA==
X-Gm-Gg: AeBDietpOOxPWpO/mx9uRNlixEFineMAf3GRok6oU3xNLJHkihKuyD2um7oH/vv4/Yp
	6wE+sLEG01Nrrs49kx7uvn4PWhKwAFZsWveC+/qFkkduourKBZlfxcY2qVT57W6GgHl0ygQZmpy
	uQi0opOSFKVmBbPkJIQd5ggus25Prhn7R4gWuTwmazwnc5v8gJpKifPjloyD3l1e7xyvMFKcFeA
	q8++GPE526Ixt3JUydsBk7hwavxA1Q6KqhgsfltYFiR/59DD84jVfNMikgKBW8nWkFK6yRTE5jf
	HzPmpk/perF+40lSk7I3eFETsPvZ5gTffN73CEcFBaNVUj0VldgVvh9v3TnwAGE9pk15vkwSzr4
	CtxFjxVZfV7mBI85fopVvScTWD0yJ+9CmhoR5OKxaWO6B6AWgE+GC+4MGT8JTv75DKJuycov6dH
	B5s/t8DpcyxOjlRu8=
X-Received: by 2002:a05:7301:5809:b0:2d2:129a:1682 with SMTP id 5a478bee46e88-2ed3dea4fc4mr943455eec.16.1777542772261;
        Thu, 30 Apr 2026 02:52:52 -0700 (PDT)
X-Received: by 2002:a05:7301:5809:b0:2d2:129a:1682 with SMTP id 5a478bee46e88-2ed3dea4fc4mr943439eec.16.1777542771537;
        Thu, 30 Apr 2026 02:52:51 -0700 (PDT)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ed1c0d218dsm5885804eec.27.2026.04.30.02.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 02:52:51 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: linux-block@vger.kernel.org, ebiggers@kernel.org, mpatocka@redhat.com,
        gmazyland@gmail.com, bmarzins@redhat.com
Cc: linux-kernel@vger.kernel.org, adrianvovk@gmail.com,
        dm-devel@lists.linux.dev, quic_mdalam@quicinc.com, israelr@nvidia.com,
        hch@infradead.org, axboe@kernel.dk
Subject: [PATCH v3 2/3] dm-inlinecrypt: add target for inline block device encryption
Date: Thu, 30 Apr 2026 02:52:43 -0700
Message-Id: <20260430095244.3352446-3-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260430095244.3352446-1-linlin.zhang@oss.qualcomm.com>
References: <20260430095244.3352446-1-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=bJcm5v+Z c=1 sm=1 tr=0 ts=69f32675 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=1XWaLZrsAAAA:8
 a=EUspDBNiAAAA:8 a=pgp9PnljQXxSUQaNOToA:9 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDMwMDA5OSBTYWx0ZWRfX1xhIoSKM9kKP
 JB8w0T4IPzEzlTGuOdQ2dJD6IeFOV0D9dB5OpBkbJ7o0LOpFJOITq4yfGG1vemunY4ZZwBtDzZ+
 eBSuePTM8sE1tTI3d496NgDNUbPdxTi1mF61ULZyrSwShl+VEvVqy6a7Vbgmb9g5G1xx7WTr70S
 i5zpdcB3MICuJVA3rhCcw9uIv980DcJHw1lWKTvN4UfAuoSyMSTXQxbq0spDIeIirCvUUHKpohr
 E85yTneSi/ps7ntVGGeJLHAk64mNbtKvHFallVM6nxJipWy7KkR6aen+n0ds2+KDjsJ/JGqgBDs
 ZHkgCT6PsJq6q11p0J2Ra89uNon7UgLefpdlKfLLqaMcvsMxj2OUeAqKY1NhgEriKvEJ31zND2f
 BPB6z1yyF5aJAlMPnO33pyPayGQKEZQYgxbk98G3/8zBXG1mA0murvnH39qBBRGOK3ei2LRDJG6
 lj96KRB0L26S0TA+qJw==
X-Proofpoint-GUID: r-_Q5CHOO1rmh7GrVZqTOorNvRsQq9Z5
X-Proofpoint-ORIG-GUID: r-_Q5CHOO1rmh7GrVZqTOorNvRsQq9Z5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-30_03,2026-04-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 clxscore=1015 suspectscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604300099

From: Eric Biggers <ebiggers@google.com>

Add a new device-mapper target "dm-inlinecrypt" that is similar to
dm-crypt but uses the blk-crypto API instead of the regular crypto API.
This allows it to take advantage of inline encryption hardware such as
that commonly built into UFS host controllers.

The table syntax matches dm-crypt's, but for now only a stripped-down
set of parameters is supported.  For example, for now AES-256-XTS is the
only supported cipher.

dm-inlinecrypt is based on Android's dm-default-key with the
controversial passthrough support removed.  Note that due to the removal
of passthrough support, use of dm-inlinecrypt in combination with
fscrypt causes double encryption of file contents (similar to dm-crypt +
fscrypt), with the fscrypt layer not being able to use the inline
encryption hardware.  This makes dm-inlinecrypt unusable on systems such
as Android that use fscrypt and where a more optimized approach is
needed.  It is however suitable as a replacement for dm-crypt.

dm-inlinecrypt supports both keyring key and hex key, the former avoids
the key to be exposed in dm-table message. Similar to dm-default-key in
Android, it will fallabck to the software block crypto once the inline
crypto hardware cannot support the expected cipher.

Test:
dmsetup create inlinecrypt_logon --table "0 `blockdev --getsz $1` \
inlinecrypt aes-xts-plain64 :64:logon:fde:dminlinecrypt_test_key 0 $1 0"

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
---
 drivers/md/Kconfig          |  11 +
 drivers/md/Makefile         |   1 +
 drivers/md/dm-inlinecrypt.c | 596 ++++++++++++++++++++++++++++++++++++
 3 files changed, 608 insertions(+)
 create mode 100644 drivers/md/dm-inlinecrypt.c

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index c58a9a8ea54e..260c9c5e51bd 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -313,6 +313,17 @@ config DM_CRYPT
 
 	  If unsure, say N.
 
+config DM_INLINECRYPT
+	tristate "Inline encryption target support"
+	depends on BLK_DEV_DM
+	depends on (KEYS || KEYS=n)
+	depends on BLK_INLINE_ENCRYPTION
+	help
+	  This device-mapper target is similar to dm-crypt, but it uses the
+	  blk-crypto API instead of the regular crypto API. This allows it to
+	  take advantage of inline encryption hardware such as that commonly
+	  built into UFS host controllers.
+
 config DM_SNAPSHOT
        tristate "Snapshot target"
        depends on BLK_DEV_DM
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index c338cc6fbe2e..517d1f7d8288 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_DM_UNSTRIPED)	+= dm-unstripe.o
 obj-$(CONFIG_DM_BUFIO)		+= dm-bufio.o
 obj-$(CONFIG_DM_BIO_PRISON)	+= dm-bio-prison.o
 obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
+obj-$(CONFIG_DM_INLINECRYPT)	+= dm-inlinecrypt.o
 obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
 obj-$(CONFIG_DM_DUST)		+= dm-dust.o
 obj-$(CONFIG_DM_FLAKEY)		+= dm-flakey.o
diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
new file mode 100644
index 000000000000..6f804f5a4be6
--- /dev/null
+++ b/drivers/md/dm-inlinecrypt.c
@@ -0,0 +1,596 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2024 Google LLC
+ */
+
+#include <linux/blk-crypto.h>
+#include <linux/ctype.h>
+#include <linux/device-mapper.h>
+#include <linux/hex.h>
+#include <linux/module.h>
+#include <keys/user-type.h>
+
+#define DM_MSG_PREFIX	"inlinecrypt"
+
+static const struct dm_inlinecrypt_cipher {
+	const char *name;
+	enum blk_crypto_mode_num mode_num;
+} dm_inlinecrypt_ciphers[] = {
+	{
+		.name = "aes-xts-plain64",
+		.mode_num = BLK_ENCRYPTION_MODE_AES_256_XTS,
+	},
+};
+
+/**
+ * struct inlinecrypt_ctx - private data of an inlinecrypt target
+ * @dev: the underlying device
+ * @start: starting sector of the range of @dev which this target actually maps.
+ *	   For this purpose a "sector" is 512 bytes.
+ * @cipher_string: the name of the encryption algorithm being used
+ * @iv_offset: starting offset for IVs.  IVs are generated as if the target were
+ *	       preceded by @iv_offset 512-byte sectors.
+ * @sector_size: crypto sector size in bytes (usually 4096)
+ * @sector_bits: log2(sector_size)
+ * @key: the encryption key to use
+ * @max_dun: the maximum DUN that may be used (computed from other params)
+ */
+struct inlinecrypt_ctx {
+	struct dm_dev *dev;
+	sector_t start;
+	const char *cipher_string;
+	unsigned int key_size;
+	u64 iv_offset;
+	unsigned int sector_size;
+	unsigned int sector_bits;
+	struct blk_crypto_key key;
+	u64 max_dun;
+};
+
+static const struct dm_inlinecrypt_cipher *
+lookup_cipher(const char *cipher_string)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dm_inlinecrypt_ciphers); i++) {
+		if (strcmp(cipher_string, dm_inlinecrypt_ciphers[i].name) == 0)
+			return &dm_inlinecrypt_ciphers[i];
+	}
+	return NULL;
+}
+
+static void inlinecrypt_dtr(struct dm_target *ti)
+{
+	struct inlinecrypt_ctx *ctx = ti->private;
+
+	if (ctx->dev) {
+		if (ctx->key.size)
+			blk_crypto_evict_key(ctx->dev->bdev, &ctx->key);
+		dm_put_device(ti, ctx->dev);
+	}
+	kfree_sensitive(ctx->cipher_string);
+	kfree_sensitive(ctx);
+}
+
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
+static int set_key_user(struct key *key, char *bin_key,
+			const unsigned int bin_key_size)
+{
+	const struct user_key_payload *ukp;
+
+	ukp = user_key_payload_locked(key);
+	if (!ukp)
+		return -EKEYREVOKED;
+
+	if (bin_key_size != ukp->datalen)
+		return -EINVAL;
+
+	memcpy(bin_key, ukp->data, bin_key_size);
+
+	return 0;
+}
+
+static int inlinecrypt_get_keyring_key(const char *key_string, u8 *bin_key,
+					const unsigned int bin_key_size)
+{
+	char *key_desc;
+	int ret;
+	struct key_type *type;
+	struct key *key;
+	int (*set_key)(struct key *key, char *bin_key,
+				   const unsigned int bin_key_size);
+
+	/*
+	 * Reject key_string with whitespace. dm core currently lacks code for
+	 * proper whitespace escaping in arguments on DM_TABLE_STATUS path.
+	 */
+	if (contains_whitespace(key_string)) {
+		DMERR("whitespace chars not allowed in key string");
+		return -EINVAL;
+	}
+
+	/* look for next ':' separating key_type from key_description */
+	key_desc = strchr(key_string, ':');
+	if (!key_desc || key_desc == key_string || !strlen(key_desc + 1))
+		return -EINVAL;
+
+	if (!strncmp(key_string, "logon:", key_desc - key_string + 1)) {
+		type = &key_type_logon;
+		set_key = set_key_user;
+	} else {
+		return -EINVAL;
+	}
+
+	key = request_key(type, key_desc + 1, NULL);
+	if (IS_ERR(key))
+		return PTR_ERR(key);
+
+	down_read(&key->sem);
+
+	ret = set_key(key, (char *)bin_key, bin_key_size);
+
+	up_read(&key->sem);
+	key_put(key);
+
+	return ret;
+}
+
+static int get_key_size(char **key_string)
+{
+	char *colon, dummy;
+	int ret;
+
+	if (*key_string[0] != ':') {
+		ret = strlen(*key_string);
+
+		if (ret > 2 * BLK_CRYPTO_MAX_ANY_KEY_SIZE
+			|| ret  % 2
+			|| !ret) {
+			DMERR("Invalid keysize");
+			return -EINVAL;
+		}
+		return ret >> 1;
+	}
+
+	/* look for next ':' in key string */
+	colon = strpbrk(*key_string + 1, ":");
+	if (!colon)
+		return -EINVAL;
+
+	if (sscanf(*key_string + 1, "%u%c", &ret, &dummy) != 2 || dummy != ':')
+		return -EINVAL;
+
+	/* remaining key string should be :<logon|user>:<key_desc> */
+	*key_string = colon;
+
+	return ret;
+}
+
+#else
+
+static int inlinecrypt_get_keyring_key(const char *key_string, u8 *bin_key,
+					const unsigned int bin_key_size)
+{
+	return -EINVAL;
+}
+
+static int get_key_size(char **key_string)
+{
+	int key_hex_size = strlen(*key_string);
+
+	if (*key_string[0] == ':')
+		return -EINVAL;
+
+	if (key_hex_size > 2 * BLK_CRYPTO_MAX_ANY_KEY_SIZE
+		|| key_hex_size  % 2
+		|| !key_hex_size) {
+		DMERR("Invalid keysize");
+		return -EINVAL;
+	}
+
+	return key_hex_size >> 1;
+}
+
+#endif /* CONFIG_KEYS */
+
+static int inlinecrypt_get_key(const char *key_string,
+				u8 key[BLK_CRYPTO_MAX_ANY_KEY_SIZE],
+				const unsigned int key_size)
+{
+	int ret = 0;
+
+	if (key_size > BLK_CRYPTO_MAX_ANY_KEY_SIZE) {
+		DMERR("Invalid keysize");
+		return -EINVAL;
+	}
+
+	/* ':' means the key is in kernel keyring, short-circuit normal key processing */
+	if (key_string[0] == ':') {
+		/* key string should be :<logon|user>:<key_desc> */
+		ret = inlinecrypt_get_keyring_key(key_string + 1, key, key_size);
+		goto out;
+	}
+
+	if (hex2bin(key, key_string, key_size) != 0)
+		ret = -EINVAL;
+
+out:
+	return ret;
+}
+
+static int inlinecrypt_ctr_optional(struct dm_target *ti,
+				    unsigned int argc, char **argv)
+{
+	struct inlinecrypt_ctx *ctx = ti->private;
+	struct dm_arg_set as;
+	static const struct dm_arg _args[] = {
+		{0, 3, "Invalid number of feature args"},
+	};
+	unsigned int opt_params;
+	const char *opt_string;
+	bool iv_large_sectors = false;
+	char dummy;
+	int err;
+
+	as.argc = argc;
+	as.argv = argv;
+
+	err = dm_read_arg_group(_args, &as, &opt_params, &ti->error);
+	if (err)
+		return err;
+
+	while (opt_params--) {
+		opt_string = dm_shift_arg(&as);
+		if (!opt_string) {
+			ti->error = "Not enough feature arguments";
+			return -EINVAL;
+		}
+		if (!strcmp(opt_string, "allow_discards")) {
+			ti->num_discard_bios = 1;
+		} else if (sscanf(opt_string, "sector_size:%u%c",
+				  &ctx->sector_size, &dummy) == 1) {
+			if (ctx->sector_size < SECTOR_SIZE ||
+			    ctx->sector_size > 4096 ||
+			    !is_power_of_2(ctx->sector_size)) {
+				ti->error = "Invalid sector_size";
+				return -EINVAL;
+			}
+		} else if (!strcmp(opt_string, "iv_large_sectors")) {
+			iv_large_sectors = true;
+		} else {
+			ti->error = "Invalid feature arguments";
+			return -EINVAL;
+		}
+	}
+
+	/* dm-inlinecrypt doesn't implement iv_large_sectors=false. */
+	if (ctx->sector_size != SECTOR_SIZE && !iv_large_sectors) {
+		ti->error = "iv_large_sectors must be specified";
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * Construct an inlinecrypt mapping:
+ * <cipher> [<key>|:<key_size>:<logon>:<key_description>] <iv_offset> <dev_path> <start>
+ *
+ * This syntax matches dm-crypt's, but the set of supported functionality has
+ * been stripped down.
+ */
+static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	struct inlinecrypt_ctx *ctx;
+	const struct dm_inlinecrypt_cipher *cipher;
+	u8 raw_key[BLK_CRYPTO_MAX_ANY_KEY_SIZE];
+	unsigned int dun_bytes;
+	unsigned long long tmpll;
+	char dummy;
+	int err;
+
+	if (argc < 5) {
+		ti->error = "Not enough arguments";
+		return -EINVAL;
+	}
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		ti->error = "Out of memory";
+		return -ENOMEM;
+	}
+	ti->private = ctx;
+
+	/* <cipher> */
+	ctx->cipher_string = kstrdup(argv[0], GFP_KERNEL);
+	if (!ctx->cipher_string) {
+		ti->error = "Out of memory";
+		err = -ENOMEM;
+		goto bad;
+	}
+	cipher = lookup_cipher(ctx->cipher_string);
+	if (!cipher) {
+		ti->error = "Unsupported cipher";
+		err = -EINVAL;
+		goto bad;
+	}
+
+	/* <key> */
+	ctx->key_size = get_key_size(&argv[1]);
+	if (ctx->key_size < 0) {
+		ti->error = "Cannot parse key size";
+		return -EINVAL;
+	}
+	err = inlinecrypt_get_key(argv[1], raw_key, ctx->key_size);
+	if (err) {
+		ti->error = "Malformed key string";
+		goto bad;
+	}
+
+	/* <iv_offset> */
+	if (sscanf(argv[2], "%llu%c", &ctx->iv_offset, &dummy) != 1) {
+		ti->error = "Invalid iv_offset sector";
+		err = -EINVAL;
+		goto bad;
+	}
+
+	/* <dev_path> */
+	err = dm_get_device(ti, argv[3], dm_table_get_mode(ti->table),
+			    &ctx->dev);
+	if (err) {
+		ti->error = "Device lookup failed";
+		goto bad;
+	}
+
+	/* <start> */
+	if (sscanf(argv[4], "%llu%c", &tmpll, &dummy) != 1 ||
+	    tmpll != (sector_t)tmpll) {
+		ti->error = "Invalid start sector";
+		err = -EINVAL;
+		goto bad;
+	}
+	ctx->start = tmpll;
+
+	/* optional arguments */
+	ctx->sector_size = SECTOR_SIZE;
+	if (argc > 5) {
+		err = inlinecrypt_ctr_optional(ti, argc - 5, &argv[5]);
+		if (err)
+			goto bad;
+	}
+	ctx->sector_bits = ilog2(ctx->sector_size);
+	if (ti->len & ((ctx->sector_size >> SECTOR_SHIFT) - 1)) {
+		ti->error = "Device size is not a multiple of sector_size";
+		err = -EINVAL;
+		goto bad;
+	}
+	if (ctx->iv_offset & ((ctx->sector_size >> SECTOR_SHIFT) - 1)) {
+		ti->error = "Wrong alignment of iv_offset sector";
+		err = -EINVAL;
+	}
+
+	ctx->max_dun = (ctx->iv_offset + ti->len - 1) >>
+		       (ctx->sector_bits - SECTOR_SHIFT);
+	dun_bytes = DIV_ROUND_UP(fls64(ctx->max_dun), 8);
+
+	err = blk_crypto_init_key(&ctx->key, raw_key, ctx->key_size,
+				  BLK_CRYPTO_KEY_TYPE_RAW,
+				  cipher->mode_num, dun_bytes,
+				  ctx->sector_size);
+	if (err) {
+		ti->error = "Error initializing blk-crypto key";
+		goto bad;
+	}
+
+	err = blk_crypto_start_using_key(ctx->dev->bdev, &ctx->key);
+	if (err) {
+		ti->error = "Error starting to use blk-crypto";
+		goto bad;
+	}
+
+	ti->num_flush_bios = 1;
+
+	err = 0;
+	goto out;
+
+bad:
+	inlinecrypt_dtr(ti);
+out:
+	memzero_explicit(raw_key, sizeof(raw_key));
+	return err;
+}
+
+static int inlinecrypt_map(struct dm_target *ti, struct bio *bio)
+{
+	const struct inlinecrypt_ctx *ctx = ti->private;
+	sector_t sector_in_target;
+	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE] = {};
+
+	bio_set_dev(bio, ctx->dev->bdev);
+
+	/*
+	 * If the bio is a device-level request which doesn't target a specific
+	 * sector, there's nothing more to do.
+	 */
+	if (bio_sectors(bio) == 0)
+		return DM_MAPIO_REMAPPED;
+
+	/*
+	 * The bio should never have an encryption context already, since
+	 * dm-inlinecrypt doesn't pass through any inline encryption
+	 * capabilities to the layer above it.
+	 */
+	if (WARN_ON_ONCE(bio_has_crypt_ctx(bio)))
+		return DM_MAPIO_KILL;
+
+	/* Map the bio's sector to the underlying device. (512-byte sectors) */
+	sector_in_target = dm_target_offset(ti, bio->bi_iter.bi_sector);
+	bio->bi_iter.bi_sector = ctx->start + sector_in_target;
+	/*
+	 * If the bio doesn't have any data (e.g. if it's a DISCARD request),
+	 * there's nothing more to do.
+	 */
+	if (!bio_has_data(bio))
+		return DM_MAPIO_REMAPPED;
+
+	/* Calculate the DUN and enforce data-unit (crypto sector) alignment. */
+	dun[0] = ctx->iv_offset + sector_in_target; /* 512-byte sectors */
+	if (dun[0] & ((ctx->sector_size >> SECTOR_SHIFT) - 1))
+		return DM_MAPIO_KILL;
+	dun[0] >>= ctx->sector_bits - SECTOR_SHIFT; /* crypto sectors */
+
+	/*
+	 * This check isn't necessary as we should have calculated max_dun
+	 * correctly, but be safe.
+	 */
+	if (WARN_ON_ONCE(dun[0] > ctx->max_dun))
+		return DM_MAPIO_KILL;
+
+	bio_crypt_set_ctx(bio, &ctx->key, dun, GFP_NOIO);
+
+	/*
+	 * Since we've added an encryption context to the bio and
+	 * blk-crypto-fallback may be needed to process it, it's necessary to
+	 * use the fallback-aware bio submission code rather than
+	 * unconditionally returning DM_MAPIO_REMAPPED.
+	 *
+	 * To get the correct accounting for a dm target in the case where
+	 * __blk_crypto_submit_bio() doesn't take ownership of the bio (returns
+	 * true), call __blk_crypto_submit_bio() directly and return
+	 * DM_MAPIO_REMAPPED in that case, rather than relying on
+	 * blk_crypto_submit_bio() which calls submit_bio() in that case.
+	 *
+	 * TODO: blk-crypto fallback write slow-path currently double-accounts
+	 * IO in vmstat, as encrypted bios are submitted via submit_bio().
+	 * This does not affect data correctness. Consider fixing this if
+	 * a cleaner accounting model for derived bios is introduced.
+	 */
+	if (__blk_crypto_submit_bio(bio))
+		return DM_MAPIO_REMAPPED;
+	return DM_MAPIO_SUBMITTED;
+}
+
+static void inlinecrypt_status(struct dm_target *ti, status_type_t type,
+			       unsigned int status_flags, char *result,
+			       unsigned int maxlen)
+{
+	const struct inlinecrypt_ctx *ctx = ti->private;
+	unsigned int sz = 0;
+	int num_feature_args = 0;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+	case STATUSTYPE_IMA:
+		result[0] = '\0';
+		break;
+
+	case STATUSTYPE_TABLE:
+		/*
+		 * Warning: like dm-crypt, dm-inlinecrypt includes the key in
+		 * the returned table.  Userspace is responsible for redacting
+		 * the key when needed.
+		 */
+		DMEMIT("%s %*phN %llu %s %llu", ctx->cipher_string,
+		       ctx->key.size, ctx->key.bytes, ctx->iv_offset,
+		       ctx->dev->name, ctx->start);
+		num_feature_args += !!ti->num_discard_bios;
+		if (ctx->sector_size != SECTOR_SIZE)
+			num_feature_args += 2;
+		if (num_feature_args != 0) {
+			DMEMIT(" %d", num_feature_args);
+			if (ti->num_discard_bios)
+				DMEMIT(" allow_discards");
+			if (ctx->sector_size != SECTOR_SIZE) {
+				DMEMIT(" sector_size:%u", ctx->sector_size);
+				DMEMIT(" iv_large_sectors");
+			}
+		}
+		break;
+	}
+}
+
+static int inlinecrypt_prepare_ioctl(struct dm_target *ti,
+				     struct block_device **bdev, unsigned int cmd,
+				     unsigned long arg, bool *forward)
+{
+	const struct inlinecrypt_ctx *ctx = ti->private;
+	const struct dm_dev *dev = ctx->dev;
+
+	*bdev = dev->bdev;
+
+	/* Only pass ioctls through if the device sizes match exactly. */
+	return ctx->start != 0 || ti->len != bdev_nr_sectors(dev->bdev);
+}
+
+static int inlinecrypt_iterate_devices(struct dm_target *ti,
+				       iterate_devices_callout_fn fn,
+				       void *data)
+{
+	const struct inlinecrypt_ctx *ctx = ti->private;
+
+	return fn(ti, ctx->dev, ctx->start, ti->len, data);
+}
+
+#ifdef CONFIG_BLK_DEV_ZONED
+static int inlinecrypt_report_zones(struct dm_target *ti,
+				    struct dm_report_zones_args *args,
+				    unsigned int nr_zones)
+{
+	const struct inlinecrypt_ctx *ctx = ti->private;
+
+	return dm_report_zones(ctx->dev->bdev, ctx->start,
+			ctx->start + dm_target_offset(ti, args->next_sector),
+			args, nr_zones);
+}
+#else
+#define inlinecrypt_report_zones NULL
+#endif
+
+static void inlinecrypt_io_hints(struct dm_target *ti,
+				 struct queue_limits *limits)
+{
+	const struct inlinecrypt_ctx *ctx = ti->private;
+	const unsigned int sector_size = ctx->sector_size;
+
+	limits->logical_block_size =
+		max_t(unsigned int, limits->logical_block_size, sector_size);
+	limits->physical_block_size =
+		max_t(unsigned int, limits->physical_block_size, sector_size);
+	limits->io_min = max_t(unsigned int, limits->io_min, sector_size);
+	limits->dma_alignment = limits->logical_block_size - 1;
+}
+
+static struct target_type inlinecrypt_target = {
+	.name			= "inlinecrypt",
+	.version		= {1, 0, 0},
+	/*
+	 * Do not set DM_TARGET_PASSES_CRYPTO, since dm-inlinecrypt consumes the
+	 * crypto capability itself.
+	 */
+	.features		= DM_TARGET_ZONED_HM,
+	.module			= THIS_MODULE,
+	.ctr			= inlinecrypt_ctr,
+	.dtr			= inlinecrypt_dtr,
+	.map			= inlinecrypt_map,
+	.status			= inlinecrypt_status,
+	.prepare_ioctl		= inlinecrypt_prepare_ioctl,
+	.iterate_devices	= inlinecrypt_iterate_devices,
+	.report_zones		= inlinecrypt_report_zones,
+	.io_hints		= inlinecrypt_io_hints,
+};
+
+module_dm(inlinecrypt);
+
+MODULE_AUTHOR("Eric Biggers <ebiggers@google.com>");
+MODULE_AUTHOR("Linlin Zhang <linlin.zhang@oss.qualcomm.com>");
+MODULE_DESCRIPTION(DM_NAME " target for inline encryption");
+MODULE_LICENSE("GPL");
-- 
2.34.1


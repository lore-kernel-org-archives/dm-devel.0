Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C253C65E2
	for <dm-devel@lists.linux.dev>; Fri, 10 Apr 2026 13:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775828443; cv=none; b=vCR2ik5Q8ZJjozQ9B3iDYCNFZDTgWCMponhRPbL39x0UstMWOlBDzY9zfq4xbDALR10a3YhxfHEB2tqNos3A/n+NiU08iBiWJUycBdw/B61dtDa8pRWPR4Mlk9fLsYFxrB3NoBfchIHE/mw+aHmwbkkTue0vbiwoUhByhd4f674=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775828443; c=relaxed/simple;
	bh=JrZsRg37dArx4JUgb1G+eiWHKPOgSk3fjsvTzanEWlY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FeqrMChAsGxNxNB422Vzmb70mvYIy8VgnsiYeUev3lqsOllITGtnmgusKNO+zmSVI3np2kOdwgvUxCsT+ei0GS0iFn7qQTydETRVzMaMGrQA1ClAknDC9hCbz6MKDQw5ZhpKm+4xXM80pl97JjrLCe7h50N3rCblY4KNmKmMYrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=myi3gwCH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ABE043VS; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="myi3gwCH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ABE043VS"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63AALaK6707656
	for <dm-devel@lists.linux.dev>; Fri, 10 Apr 2026 13:40:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=KPlUXv8EyLc
	n8i2iNpX/Emr42Gml1gSuHDZ1pgLzhdU=; b=myi3gwCHxL/f9AueTB03bNPQsv0
	6I4FU3BumYK3e5/GeT3bmwbo+neFzaNtA0qNjvnTOdOFjkGnJlUKANxQEJV4lr65
	VHGuNK+xg0l0d/IgKbtdCf1SgQPnwXblJpvizDBsTfxDwhUEqFutj+yLXzPYk2WF
	EW50xL3m1Z6sKuQtgULb9262RhIq4nFn+zu0S1nU/wHealW9z1dR850ryHG5sxlL
	yt9/eROWeHpwSYzEqqMLZ8mVzRSUZrFpb/PIsavLQNxHp8mVhie2gZVpJVFLsmB7
	YIV6bynhjAArG/eSAiQArlN/9uoJakFDqAGYZtbh3f8v5hs2jKXus961WTw==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4deudj1k6d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Fri, 10 Apr 2026 13:40:40 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2bdc1b30ac8so1083194eec.1
        for <dm-devel@lists.linux.dev>; Fri, 10 Apr 2026 06:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775828440; x=1776433240; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KPlUXv8EyLcn8i2iNpX/Emr42Gml1gSuHDZ1pgLzhdU=;
        b=ABE043VSD4ELdJWKAyt9XPVQS9pJ1UFRquBenzBBUEknrYLqA2w6K2Vm1LhVvxeHC2
         CL7cv7dC9GVlEZmLOihw443iL+8VaIGt2jcDOUmFos9pT+yIhtMdweO1M3FkcS8yttjM
         RgLWHa4lSfPAKs+XVJO8zAE7ImBuU3AMwq9Sw6+bxNq74NWvh7mRuIO5hx/i4MSPAlz5
         EbfRYJxk/nYdxPXSZBwL0nyO24cLfXvWLjyrS4YMEcm0mLARyp8475C/njgOmdcS1K1u
         BVduasUoMUh6BttdjHZlu3L2+ejY2fz6CmNPjK2WQCJ3zThKk+mXJpUchoUZHjRI6sZf
         GAig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775828440; x=1776433240;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KPlUXv8EyLcn8i2iNpX/Emr42Gml1gSuHDZ1pgLzhdU=;
        b=UW0rWjNfAqHuxjUrow4JqVSReifSrQlmAnXGHWLVdvVe7+No/R4eUd5R89QFt3YCbU
         8KG4aLvsCSYRub8NgMsBwNh7wEFfTvF1hiIDDZgGbNOrIiuZD0nVklDinUWVaWTNrMw2
         7pdXKEKtAG78Pk8QK7hqqovWwa8bMTTLj5O3ZQm7nHcKc2/PTOs4UtYk6CiAnt2Tv48C
         43GITFIBmBKCGfSSpAtarzondjSoMP8dsJXq61+0skd1GeOfgWSA5mrs6d3Zo6nssIED
         lrzFKLkpO2/QOm4Lf8tA/F2JjQaArmC+5HYhBnmEGH60xaElkzT9Dkmsm11/azXiHH3p
         Kg0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXvqLkgK746TGdIaEjveZH2ATyGx6cO2/XFzzg1nc2pbt3yh2HrtTOJQby/GrUKX/8Dlrfk/HB+NA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwFc8QQdDbjLdk7m0IfJ1jIgEuVFN/7fKl7egIf7K0cf/QNFYMR
	8EDAIj8+BVEn/JSFd7i/SDmxv2EoG5cBJhmgJXmyQsNOp5QoB0Ib9WEGVw8D91W89JSDiJdr2cn
	IdvTqJtkuBsETQZPmPqw4OgI1K4ySTE9XM/uz3G6wbb3ymDVAkaMbe7dm56p0Ig==
X-Gm-Gg: AeBDieu0PL3/CofEjOSbEgc3+vSXoO8fRsnjqahxJaLKxMR5MMuMcSJiyT8TDuK0lJZ
	3Uoc8WJBRTXCMIoWmoYvFIVdQSjVBeL0LASK/caLKFDz/VDm4CAo+vKf/TrKefYFB58hkPqdxCW
	dygOJUtxvwdhNvUXAoJIFlKSQyBAN71SVKNuKOSuf69hIZD5YVrCLeswh92XsYA0678KbSmmrRw
	nDKufOe1j7w+a4w3jS0p2BgOIhAER0zZFK86dGkIV3ErANGMeVMjiJkKWrNlxIir9WvEozGtvyi
	W1ZTr2K7dDAk8GqfV7uEWyrhDnWcKmZCOujmjr3sX9ELPHmzIZrCdJiOAi2VzN+gZ0xTesX3jXT
	Pxubai4Rh0JxhtalNw34emarhGt5oFiB/aEpYWHUQMAWi+N4m3FYbSyVBmvBjHf+RS0QkuXUZ2A
	onBApM
X-Received: by 2002:a05:7300:8c85:b0:2be:8216:57db with SMTP id 5a478bee46e88-2d5873ad987mr1694198eec.3.1775828439752;
        Fri, 10 Apr 2026 06:40:39 -0700 (PDT)
X-Received: by 2002:a05:7300:8c85:b0:2be:8216:57db with SMTP id 5a478bee46e88-2d5873ad987mr1694163eec.3.1775828439035;
        Fri, 10 Apr 2026 06:40:39 -0700 (PDT)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d561bde70csm5172631eec.15.2026.04.10.06.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 06:40:38 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: linux-block@vger.kernel.org, ebiggers@kernel.org, mpatocka@redhat.com,
        gmazyland@gmail.com
Cc: linux-kernel@vger.kernel.org, adrianvovk@gmail.com,
        dm-devel@lists.linux.dev, quic_mdalam@quicinc.com, israelr@nvidia.com,
        hch@infradead.org, axboe@kernel.dk
Subject: [PATCH v2 2/3] dm-inlinecrypt: add target for inline block device encryption
Date: Fri, 10 Apr 2026 06:40:30 -0700
Message-Id: <20260410134031.2880675-3-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260410134031.2880675-1-linlin.zhang@oss.qualcomm.com>
References: <20260410134031.2880675-1-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: ZXKdAxTqXCPJv7T3fg4ig6FSnYMOBBN9
X-Proofpoint-GUID: ZXKdAxTqXCPJv7T3fg4ig6FSnYMOBBN9
X-Authority-Analysis: v=2.4 cv=cKfQdFeN c=1 sm=1 tr=0 ts=69d8fdd8 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=1XWaLZrsAAAA:8
 a=EUspDBNiAAAA:8 a=XpLwOsV47Bz5VTnE-JYA:9 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDEyOCBTYWx0ZWRfX4UOsWil7p3BF
 HySdTt4Y7TYZfY+h8cIuxEF+RL2Lki9cBsufJCOniBSAiFr5XMuqk/A4+Yu0DjxIDNpw7/tMoHT
 MJkIYUGcZVLNVWt/0TEhNO0XpWqriIL8QOXW/CeTbrEbb5X9O/iFMn6Ff9a96UYYIlH3kD6/+r2
 QXI5huBZeco16JHf6+mENY++ivAkFOlPKVgQbsR5OjcsoFpSM7R9UO3bdQ4qwetoXu82FygzMUf
 sKkUKYbLLYZKm0e5uLRs14HGfyeAoOKabJPi14fn/x4W56vyhHOHEDXLldCDQcjdXzM11033re2
 B7MYBOmAI8+TIDl5DqH/1oYe4WCZ2GMlr+Qw6YqpVFOGzN3mF2M6KU0GqfDa0akJubTz2GTS+dV
 diVmpz9lPrwYN6FejUw5b5TtGBqS79oo2Kh8QrvGbzPqDZnHh2yiTEnF4vELrrHo7uG3NNQF99a
 aIde7Eyo+k7PMV65HOQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_04,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 suspectscore=0 phishscore=0 lowpriorityscore=0
 adultscore=0 malwarescore=0 bulkscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604100128

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
 drivers/md/Kconfig          |  10 +
 drivers/md/Makefile         |   1 +
 drivers/md/dm-inlinecrypt.c | 559 ++++++++++++++++++++++++++++++++++++
 3 files changed, 570 insertions(+)
 create mode 100644 drivers/md/dm-inlinecrypt.c

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index c58a9a8ea54e..aa541cc22ecc 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -313,6 +313,16 @@ config DM_CRYPT
 
 	  If unsure, say N.
 
+config DM_INLINECRYPT
+	tristate "Inline encryption target support"
+	depends on BLK_DEV_DM
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
index 000000000000..b6e98fdf8af1
--- /dev/null
+++ b/drivers/md/dm-inlinecrypt.c
@@ -0,0 +1,559 @@
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
+	if (ret < 0) {
+		up_read(&key->sem);
+		key_put(key);
+		return ret;
+	}
+
+	up_read(&key->sem);
+	key_put(key);
+
+	return ret;
+}
+
+static int inlinecrypt_get_key(const char *key_string,
+				u8 key[BLK_CRYPTO_MAX_ANY_KEY_SIZE],
+				const unsigned int key_size)
+{
+	int ret = 0;
+
+	/* ':' means the key is in kernel keyring, short-circuit normal key processing */
+	if (key_string[0] == ':') {
+		if (key_size > BLK_CRYPTO_MAX_ANY_KEY_SIZE) {
+			DMERR("Invalid keysize");
+			return -EINVAL;
+		}
+		/* key string should be :<logon|user>:<key_desc> */
+		ret = inlinecrypt_get_keyring_key(key_string + 1, key, key_size);
+		goto out;
+	}
+
+	if (key_size > 2 * BLK_CRYPTO_MAX_ANY_KEY_SIZE
+		|| key_size  % 2
+		|| !key_size) {
+		DMERR("Invalid keysize");
+		return -EINVAL;
+	}
+	if (hex2bin(key, key_string, key_size) != 0)
+		ret = -EINVAL;
+
+out:
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


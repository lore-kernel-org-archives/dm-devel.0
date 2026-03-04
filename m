Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A363A8745
	for <dm-devel@lists.linux.dev>; Wed,  4 Mar 2026 12:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772626662; cv=none; b=crOnlLXwLtknNSVhGaFQlp7+PVLY8Vs0YzzJBd5eyAQ36Y07qL2Nl0/h2nU7p+YB9fpZt2pko9KDZ2BmfWjU2VkXNN/ZU/ZBpgMLt7t+sSm/SQ6rVB5EYR/HHBwP0ZqRj7HuDIPV3H2dggdSbcvZhtXJUoAJhucucm1SUzCX3k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772626662; c=relaxed/simple;
	bh=njh2bthj7lGQKOViJkMsU6uM3q4SBHiy3HpXfN1BycA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TltSutPwDHmP+cpP0rZ3xqFFlRwDGKr5FEWa3h149b/zwX3DAeU8FocBrydqIwRVxD0X268wGbZbakotj24/xBwj8W84z97/MqcFLOZ4Pb9zyz+UaLvzRl56tvnRUSakc8T4HHOLW3PcdrHDm9vdeGT80P5SjJ4/7W56YSqxM7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=B3D52abH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Lw3BIFtS; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="B3D52abH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Lw3BIFtS"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 624CFepj1072557
	for <dm-devel@lists.linux.dev>; Wed, 4 Mar 2026 12:17:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=PUsU+4Fm1/B
	5TzpCA65Vgoz/dx4A6WK4RfM6wueuLh8=; b=B3D52abHqMNtONXi1OsInS3cW5e
	ZzlUkRV4YuY9ifnnhkQAOT21OEU6/arAFLgLjU0ghw780jLIFWXMqXOqxoWVq/eF
	isYT4AsgpSRVz+geRfIp9BIMp9ebvn3j5MAEjO1m5zQmFvnGXij69pvxTjaiwbpi
	iuR9nM8rtN+0GnOYBCkG0xe3uzWoA+dgxlWPjptdOouSeclglyDwPz+Nnow/zDlp
	mgYQjuy7YA7CnWG0ZmlKhkATe6aqDLV006hd0HnZQi0cDd9NSaiI3+m/k7XJAEtm
	TFmwOMh1FXL5q7NkH8V0iyZed+l0TrVo1Up/Oud/u+XjEQI2oGvOS9f/JTg==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cpcxfhkrs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 04 Mar 2026 12:17:39 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-127876be621so3949887c88.1
        for <dm-devel@lists.linux.dev>; Wed, 04 Mar 2026 04:17:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772626659; x=1773231459; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PUsU+4Fm1/B5TzpCA65Vgoz/dx4A6WK4RfM6wueuLh8=;
        b=Lw3BIFtSBAZ8ImdR3sDQk1MjGVdB4AUESWoswVZdV+2E7CCDwFTvQWznNt7IW0FViH
         87n0krADA+JIvJYKV3HxpBDcvnWFd1dG0fFvL3IBqCqLNLf4nMJBE5bfrTC1skNktDJQ
         7Oym9VoGPZJMHOU7HZJrD/+aXDE+YAXwyNjz5IxlvV8UwIHd15bteSoBUM2jJ1DsiuEf
         R9p+jJuY9ly/Zlo2rIn9Z9AVSP7wxQ0orzvlcrgD6/DXRgzTKgvHPm6N5hmEliUkBdp9
         nmecXxQXD+aTmZ/md+m16yxUvjcEiG3iM2CBxaesa/4sSW5BIWs2GioOfGuRQnz4ja45
         BdDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772626659; x=1773231459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PUsU+4Fm1/B5TzpCA65Vgoz/dx4A6WK4RfM6wueuLh8=;
        b=vVn3j9xVXFNtgN8r2Cu656W5CVyMTQu9x3ReJK7c3Kyea08/ubGDePet+3StQn8JB0
         qLz5v2Pqw0lDMnfeUgd+wrAs2AeBkAIOxaWd6FEDUPXyVauE0EwRdwoB6SxR5uCNfHz/
         aI7lZss7j72EXoPj9wQ5OJyvFJetL012DpEWNgc8cY5dMEpfO6N3/5WjDt6qfUP3tm70
         NVSoYiEAchg09fhenoIhKyu9cs0RgkKITInYykKG2x0xis6u1RIA7rtP2KDN2J9au5Nv
         hL/d641c5VgqMjzk2bKWbvSzr7WODAR8BFuDf+z8I/L+U2+EC38xY9emZd+GkhvIxplk
         rV4w==
X-Forwarded-Encrypted: i=1; AJvYcCWdWtCmuwcz725kxLaIrU9BLdbZ9oMU8u52CFiK7rqmuZRIOw95kqucoL6+hVrZJJgyEwm4JxmDPg==@lists.linux.dev
X-Gm-Message-State: AOJu0YygBb/4iH6iplmKHtmLDvITawmh3P9ILC0+BJY5MEGRKQzrAnQs
	NvIyo3fZ1/zEnd2fR9gbhHGIEg4WjYhGbNhpYh2Ao7BwaqFXjQFzdaqM2zEV2Lo5zGHSW0/W4gH
	Yg7Eo6E2QDPGPs4CplqI7wpyoLpw58c4iJhKYUf/QMfai22MSU3e+fSqMxBza5w==
X-Gm-Gg: ATEYQzzdSPYChy2aL7D65kjfvuZEcCBRT0IwTW4qbxMFIa1RqZ2sdtrOJF51yRDxW90
	Y8knPbfr/mE1Q2sWyWjbTDEmxGYSm5QPQtIyTkuHTxIaRdtjLUfnZW65OcU1HhDPctGK35i7SRv
	LaVWpv8F7NNXPLGkoZiYhpMriYCVx2UV9GE/k7rPbdCtomGdG+TlMt+GccD30h8weJC2Eru2yNd
	6qnch/PKPGY68FpQfLp9cgLyjtZEXLYEmwLJWUd4X34ioxXUwALLxbxRO6N3+qHIOoeaBkiGNJg
	8FHaepcLqB51Kn1N1EeRW1/xQAAEOx8FpouZ4B1XtvTBor3a3ko/tdLVR+hnoXaM5i++qEUA7Du
	ZjTDTdC32j3cZiLvaKrdSLGMRgh3mHhk4MnU1nezUSwGZFIkvCrMerdupEoApGU8WmTfgqjODPP
	UmWkZf
X-Received: by 2002:a05:7022:608e:b0:127:9cad:f3d5 with SMTP id a92af1059eb24-128b6fa44acmr609763c88.7.1772626658671;
        Wed, 04 Mar 2026 04:17:38 -0800 (PST)
X-Received: by 2002:a05:7022:608e:b0:127:9cad:f3d5 with SMTP id a92af1059eb24-128b6fa44acmr609755c88.7.1772626657961;
        Wed, 04 Mar 2026 04:17:37 -0800 (PST)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-127899dfc47sm22171276c88.6.2026.03.04.04.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 04:17:37 -0800 (PST)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: linux-block@vger.kernel.org, ebiggers@kernel.org
Cc: linux-kernel@vger.kernel.org, adrianvovk@gmail.com,
        dm-devel@lists.linux.dev, quic_mdalam@quicinc.com, gmazyland@gmail.com,
        israelr@nvidia.com, mpatocka@redhat.com
Subject: [PATCH v1 2/3] dm-inlinecrypt: add target for inline block device encryption
Date: Wed,  4 Mar 2026 04:17:27 -0800
Message-Id: <20260304121729.1532469-3-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com>
References: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: A-D65Fx25ZT1GpUgo_YRxYDMMjUryVWQ
X-Authority-Analysis: v=2.4 cv=R4gO2NRX c=1 sm=1 tr=0 ts=69a822e3 cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=1XWaLZrsAAAA:8
 a=EUspDBNiAAAA:8 a=bWmaV-3qS8QClun7j00A:9 a=Fk4IpSoW4aLDllm1B1p-:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDA5NyBTYWx0ZWRfX9wR4bHaa9itI
 6KrK1fO2c5HqFiUxneA1vVc9/lyaQZaTYBgSV/So6KuvLXMCDzD5n16++Pk0cXKvOI3BbaReXwN
 BOeFwYS4fNCUQLx93O0I0aV3mTF4ce9ERGPiO4vzEK/RHTTSOWQPDJkzxero5Rjci3ttTWFYHFj
 mj3INrPnuxhide35upL7t0/GDgocgbHPyzNn9jtHyWiShG9E/sj/eHNBCEjkF/uOmpJZpryaBrM
 0HPA7i01xGzfRxxS+y7rJBgTOfdf/9B/Rp75QlSxVc/VlrXMJ8/zR1pH15dA1AhKnBxBmMy2CN8
 cHFR/4TvUc2JIlDrdPDo8F//WOvZtg30OTLwCqNejGLElNhXKyTUKAXVn4WO7m/3Um+l4be1ZBo
 N6HlqUpl62hNeTlChYGbro/BCE47P2TKJeubXRMM6yxNzkYbUyulP04q9PneTinMJWI41w+IDJO
 g2ZgJa68o4LrbZPEZ4Q==
X-Proofpoint-GUID: A-D65Fx25ZT1GpUgo_YRxYDMMjUryVWQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 clxscore=1011 phishscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603040097

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

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
---
 drivers/md/Kconfig          |  10 +
 drivers/md/Makefile         |   1 +
 drivers/md/dm-inlinecrypt.c | 416 ++++++++++++++++++++++++++++++++++++
 3 files changed, 427 insertions(+)
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
index 000000000000..251760da9f7e
--- /dev/null
+++ b/drivers/md/dm-inlinecrypt.c
@@ -0,0 +1,416 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2024 Google LLC
+ */
+
+#include <linux/blk-crypto.h>
+#include <linux/device-mapper.h>
+#include <linux/hex.h>
+#include <linux/module.h>
+
+#define DM_MSG_PREFIX	"inlinecrypt"
+
+static const struct dm_inlinecrypt_cipher {
+	const char *name;
+	enum blk_crypto_mode_num mode_num;
+	int key_size;
+} dm_inlinecrypt_ciphers[] = {
+	{
+		.name = "aes-xts-plain64",
+		.mode_num = BLK_ENCRYPTION_MODE_AES_256_XTS,
+		.key_size = 64,
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
+ * <cipher> <key> <iv_offset> <dev_path> <start>
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
+	if (strlen(argv[1]) != 2 * cipher->key_size) {
+		ti->error = "Incorrect key size for cipher";
+		err = -EINVAL;
+		goto bad;
+	}
+	if (hex2bin(raw_key, argv[1], cipher->key_size) != 0) {
+		ti->error = "Malformed key string";
+		err = -EINVAL;
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
+	err = blk_crypto_init_key(&ctx->key, raw_key, cipher->key_size,
+				  BLK_CRYPTO_KEY_TYPE_HW_WRAPPED, cipher->mode_num,
+				  dun_bytes, ctx->sector_size);
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
+	return DM_MAPIO_REMAPPED;
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


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795105914;
	b=W4wTmrXYSwD/Twy2UMTSiFZYb/iZMrU6j+YGr743OHzgdF6CWcdNNtyuel2PATN3cbti
	 5aKW9Rxv1d9jWetGLP8IWdPXZVwDELCevRARUZj+Blj+/pmPP51Beg2fjeBNYGheUqmt6
	 iTlkDpPi1s9bIveqE4xiqcOBR9P4VGZEJEMdruQQwUQXs3pKegesIrgIUz2bWUoUYWDXR
	 h9CRQsjslxplZ1FFJaxuOnhzOVYxcoOSKCZhVGI5Vi/Th9NCgsSahRUATgAQM+Y6tadnO
	 xtOphKvls8nzikThxC/msKPWkGrkfflTPg1ahWGtmzj0kLOpmqP5lJcolNcwaaikrrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795105914;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/a5S7NDVrBgrgw1pAmaajiZXprBonkqhFFDCPxOrong=;
	b=IedvrXPEotrO49Nw2R/daPyizKSz0bGj7ic9zourwCd6kmtC4chYku8ldlefxhJ7WCXU
	 WwFZqoxgXpg/BhxM18TKX09jgQRF5v5ZOujmGRXnhosVDzVQN/Qeqg79JMkiFe+OveVDb
	 iIRhWaw46dJQ13pyUPhBv7bxDJeu4MtLJo8pNrgbBxOwyRhfpo66SvVcxXm3fH3lXllgb
	 6fKHrAJjLRvGEn1Lieaeb2XrZa0VmvotJ5o0dB3hNdGIkJW2UzrRautoAjSTSfEV0Ld4I
	 ZScMKHAbnTgXapQqFMJYbwcn02KRTjWaV5AqJl1j4YIwWJhIeuqqTRjCoz2ufpqRyiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fljHNhqM;
	arc=none smtp.remote-ip=209.85.210.173
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22358606A33A
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 16:31:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22358606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fljHNhqM
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8b5e5e64494so1607561b3a.1
        for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 08:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795105913; x=1795710713; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/a5S7NDVrBgrgw1pAmaajiZXprBonkqhFFDCPxOrong=;
        b=fljHNhqMowfw8JUGmLB/4/dCUiioCwN/Q8DVXyWqd/GUcAFvMvIMeppNcpp62api6L
         6Suc4u6h8jm88BjCn8Do9QXbLabwWGSbvsiet4JQxOdumrtc9Vdxdun4whcxCd2KPxKq
         KTFPSorfuvD0kePaA7KsG6Qmi8BU7G2GXLZbn1zOoDznbuE7V3JGxfk9NjIXzDTV6H0x
         fEHp581/Zl4vH64muf4Rwfdd5F/Gg/UEAiH6IoTTM2opZMJGLKQUZzxlkLBgwN0tjt/7
         lYD9oOL7QMTSkBofeaiYDjx39ulcQWjSEEMk4L6UUbDTQbfG523mzAajVnHCbIWFtJoT
         MByg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795105913; x=1795710713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/a5S7NDVrBgrgw1pAmaajiZXprBonkqhFFDCPxOrong=;
        b=Z29sXGMrL0LAFDySB9rX1NBQpZ79xDd7yvWdQh2dnn5zWzC33KaW7HZvvS/JCdiAIo
         Q91PVAtE3VyeC8tgH1oFa9DzETqDnox3OeZ3nMZ7QxCAI9uLZLKqvNicG4dycQNIMaN6
         ccSF8eA18OMPAJ6O8bk8pEcvNVPjUxNpGWjMoRdOWDf1iHd8XzYCCSVdrFulRqWQ8xcz
         ajJd/CdKL1/xCA7jLw5196K+DH3DOiL7XNJ6tHh3fmlMx/9+nH55Q6je4QXi17haZpDn
         cP9VvIsOUa1eglUOfd86AcCxvoI81OGttoWp4mtV88hAuPExjqqGxpKRUHAX+hkbYBpi
         1hmA==
X-Forwarded-Encrypted: i=1; AL+hErHcBx4G8DaPXIwEc2ZFH/DMms/IzE4iOvsKzN4dlgrZooiQ7SBhaoTL+FfxUmvcQi2y3RDg7Vn+qg==@lists.linux.dev
X-Gm-Message-State: APuU4Z8QgbWuqyxw8Kndi2NXuknmv/BBvK5l9MhObMfbvZKH9IL9xZfq
	Qaua+fn1yvT8GrkdK7e7hD7vxzVXicxwaysifLhLvP9mr728cYU/1Uzc
X-Gm-Gg: AYBFou2TYcVqhJtz4P+iH1CL7BW/21gq2VSU/Zkwmju5D5OHX8HwRoJHqNKb01SoSKp
	IWFplst80DLl96h14dio6QZwueXS3G3t0MucOFcYWlYAMCPsBTjg06rMrw/3ot+uV3nylrdUaFO
	DpotZekO1b/02k920OFpcVOJjyeoy0jXp06OMav5Zkmcxe2NvX2Uf8nXl2Au1GIknKHq1WZc652
	BAWNCe8zek1Lm30bT6CRRZ1pXSOfl5iz2zreMbxF566eJcGmNmrvaIAh/30E1zTa9tYkOPKDc0b
	JC2HzTJ3sjh11DipcGxzpLPWIZ69vjDa059nc/OByP3JQ0KmIAk2P9NqEq8RK6hyipfChCZg1Vi
	RH8PT/uT+aFNUahZNNgmuW3k9l4fzFLsE3VhqXOgXXYDUokKC3Fy0upFDNgRaKn5qQ2IGtt6PXL
	Nxe1va0gf92nWwtutPVs705dqu+rNG1zu4m0RRDHZTyhPBi4oWoR0FHoFEHFL5S0J8S5v56EJnG
	Dpqk7o96/ZZ68hZlbhWQRO9SFdVb+18Q97hA8f6nIoqpBRuCQXvVoDf5d47GFK255OoACxG/cWp
	hAnKfolMRwoVGcfNG+Be16+gP1fPxsZ7NXFIr1g/lo8/9w97WoPSo1PviX8vzzNFVOoLL8zhJR8
	s8GlSrbDx
X-Received: by 2002:a05:6a00:4299:b0:8a0:7dc4:95c0 with SMTP id d2e1a72fcca58-8c87b8da5a6mr172951b3a.15.1795105913098;
        Thu, 19 Nov 2026 08:31:53 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87420be40sm132589b3a.57.2026.11.19.08.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 08:31:52 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: agk@redhat.com,
	bmarzins@redhat.com,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	okozina@redhat.com,
	zkabelac@redhat.com,
	dm-devel@lists.linux.dev
Cc: yangyongpeng@xiaomi.com
Subject: [PATCH v3 2/4] dm-verity: size the hash retain target from the hash area
Date: Fri, 20 Nov 2026 00:31:10 +0800
Message-ID: <20261119163110.1630269-5-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261119163110.1630269-2-yangyongpeng.storage@gmail.com>
References: <20261119163110.1630269-2-yangyongpeng.storage@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

With the dm-bufio default of 256 KiB a large device re-reads hash
blocks evicted under memory pressure, while a small device holds far
more than it needs.

Set the hash client's target to hash_retain_percent (default 10) of
the hash area, computed with mul_u64_u32_div() and clamped at
ULONG_MAX so a large area cannot truncate to near-zero on 32-bit.  A
percentage above 100 is ignored, leaving the dm-bufio default.

The parameter only affects devices created afterwards.

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Assisted-by: LLM
---
v3:
- The leftover sysfs-era bufio_kobj field is removed.
v2:
- Compute the percentage with mul_u64_u32_div() and clamp it at
  ULONG_MAX, so a large area cannot truncate to near-zero on 32-bit.
---
 .../admin-guide/device-mapper/verity.rst      | 15 +++++++++++
 .../admin-guide/kernel-parameters.txt         |  6 +++++
 drivers/md/dm-verity-target.c                 | 26 +++++++++++++++++--
 3 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/verity.rst b/Documentation/admin-guide/device-mapper/verity.rst
index 9e9d4b8157c0..7d6e567cef33 100644
--- a/Documentation/admin-guide/device-mapper/verity.rst
+++ b/Documentation/admin-guide/device-mapper/verity.rst
@@ -328,6 +328,21 @@ Status
 2. Number of corrected blocks by Forward Error Correction.
    '-' if Forward Error Correction is not enabled.
 
+Metadata caching
+================
+
+The hash blocks, and the FEC parity blocks when FEC is enabled, are cached in
+memory by dm-bufio.  How much of the hash tree is kept cached is controlled by
+the ``hash_retain_percent`` module parameter (default 10), settable at boot
+time with ``dm_verity.hash_retain_percent=<0-100>`` or at run time through
+``/sys/module/dm_verity/parameters/hash_retain_percent``.  A value of 0 or
+above 100 leaves the dm-bufio default (256 KiB), which is also what the FEC
+clients keep.  Only devices created afterwards are affected.
+
+The retain target is a floor applied by the memory shrinker, not a cap: when
+there is no memory pressure a fully warmed cache may grow past it, and when
+memory is short dm-bufio evicts buffers until the target is met again.
+
 Example
 =======
 Set up a device::
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0b3c140babd9..914da403c5de 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1351,6 +1351,12 @@ Kernel parameters
 			For details see:
 			Documentation/admin-guide/hw-vuln/reg-file-data-sampling.rst
 
+	dm_verity.hash_retain_percent=
+			[DM] Percentage of the hash area that dm-verity
+			asks dm-bufio to keep cached for a new device.
+			Defaults to 10; 0 or a value above 100 leaves the
+			dm-bufio default.
+
 	dm_verity.keyring_unsealed=
 			[KNL] When set to 1, leave the dm-verity keyring
 			unsealed after initialization so userspace can
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 451c75e30a8f..0e8af1a57d75 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -32,6 +32,8 @@
 #define DM_VERITY_DEFAULT_PREFETCH_SIZE	262144
 #define DM_VERITY_USE_BH_DEFAULT_BYTES	8192
 
+#define DM_VERITY_DEFAULT_HASH_RETAIN_PERCENT	10
+
 #define DM_VERITY_MAX_CORRUPTED_ERRS	100
 
 #define DM_VERITY_OPT_LOGGING		"ignore_corruption"
@@ -50,6 +52,13 @@ static unsigned int dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE
 
 module_param_named(prefetch_cluster, dm_verity_prefetch_cluster, uint, 0644);
 
+/* Default fraction of the hash tree that dm-bufio is asked to keep cached. */
+static unsigned int dm_verity_hash_retain_percent = DM_VERITY_DEFAULT_HASH_RETAIN_PERCENT;
+
+module_param_named(hash_retain_percent, dm_verity_hash_retain_percent, uint, 0644);
+MODULE_PARM_DESC(hash_retain_percent,
+	"Percentage of the hash area to keep cached by default");
+
 static unsigned int dm_verity_use_bh_bytes[4] = {
 	DM_VERITY_USE_BH_DEFAULT_BYTES,	// IOPRIO_CLASS_NONE
 	DM_VERITY_USE_BH_DEFAULT_BYTES,	// IOPRIO_CLASS_RT
@@ -1084,14 +1093,14 @@ static void verity_dtr(struct dm_target *ti)
 
 	kfree(v->alg_name);
 
+	verity_fec_dtr(v);
+
 	if (v->hash_dev)
 		dm_put_device(ti, v->hash_dev);
 
 	if (v->data_dev)
 		dm_put_device(ti, v->data_dev);
 
-	verity_fec_dtr(v);
-
 	kfree(v->signature_key_desc);
 
 	if (v->use_bh_wq)
@@ -1421,6 +1430,7 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	struct dm_verity_sig_opts verify_args = {0};
 	struct dm_arg_set as;
 	unsigned int num;
+	unsigned int hash_retain_percent;
 	unsigned long long num_ll;
 	int r;
 	int i;
@@ -1638,6 +1648,18 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
+	/* Keep a configurable fraction of the hash tree cached by default. */
+	hash_retain_percent = READ_ONCE(dm_verity_hash_retain_percent);
+	if (hash_retain_percent <= 100) {
+		u64 retain = mul_u64_u32_div((u64)(v->hash_end - v->hash_start) <<
+					     v->hash_dev_block_bits,
+					     hash_retain_percent, 100);
+
+		if (retain > ULONG_MAX)
+			retain = ULONG_MAX;
+		dm_bufio_set_retain_bytes(v->bufio, retain);
+	}
+
 	/*
 	 * Using WQ_HIGHPRI improves throughput and completion latency by
 	 * reducing wait times when reading from a dm-verity device.
-- 
2.43.0


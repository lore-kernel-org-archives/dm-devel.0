Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795281613;
	b=eLqDiABDYRuBXZHFamJz8aN7riKtXd5ZWNJzGDy/eUlDv0vq9GTt6YLGQ1r5fWAOKcnA
	 qvfpKaayfz7EV1lpRg3EwaGxenk8uXLmvSm66TIOGkxtxpoobrVlUscRlNVOyfrteNpnu
	 DHIodgTTCSI52kOTWa7r779r8HgSlfNKHss9SexgSb3W82VWhA6WAhjBVJWXZpz+/jaq4
	 N0H/tIKp8RIRwMP2VfrYSIF6Ngp2c9xYhCaIJrnCq4c4hJqGyHUJ/I7B8KCCV9ScFLqoH
	 6Q42GYaSoxELtp00MVCYQQPJFYwcnHuQL/u3BN/CqqPqEPRSzNINfhuwVA/2jUWTXYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795281613;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rlUykUtfAd6tc0dkc+fYssjw//p2e5m8PFvh3uTab8I=;
	b=hzIiWjWh5ycyBgP+hPZB+FQwJo2rG0tXBiltaGzL9UkJTJMwIQl1tp0WB8Szi2pCviN/
	 dHmPJ4PbyHQjRRRmk+tRzG2axfYNFXXj3EPI7xbolvc9qb6vylEjHbe9pPqkV8dKzPJrn
	 qziuJRWPqE1lPe65vRWUlwo/GI15FnQuaQqGl4mPBhWfoTlHjKV1fLanBg/yUvXlb1x2y
	 EDIYL1WnUsZAx5yQY7EFnSXHefW22kA1rftgiLeE6Y7tGD+GQHyBj8IIU53Batb+x/5PE
	 G3DCDs+tE0nEA0oRVkFFao95V58bLYorIhCkwk8dMlnlnEb1LpOzCF8d6siNXYw00Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Cq9NyVox;
	arc=none smtp.remote-ip=209.85.215.171
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B860F606A320
	for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 17:20:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B860F606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Cq9NyVox
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cdab8873d9dso917012a12.1
        for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 09:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795281612; x=1795886412; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rlUykUtfAd6tc0dkc+fYssjw//p2e5m8PFvh3uTab8I=;
        b=Cq9NyVoxgJYQ2FE+m5hiZuSUQFY3hvg9Kjm6dzKA3DCrVsgHpO/c6mr41O83Tokf2I
         rNpNyYUw8/ocvAS73TNu/W0Lg9mXLeE6xGSN5AemA8Sg9t8N/00posB3ji2VCSdvoMCX
         d2GRSjRQ9J0+HOGDk7kGG5DAVwxE7e514LiMhQFVgQxKJQk7XXy2B21jGZlF4w/cGPZi
         jJy+St9j6E8B/daVFaBwiRJk3i9EXyWa4YDoAtDGYGHyuQWxd6Qrz6mcuzf1Ly9HKznC
         cLP5uiHzYhwOReoWDscFaEy82q0mbU8XG5v1o4XeNPOTwvYBXaUu7jFMtNC+lkAzujxr
         Ke8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795281612; x=1795886412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rlUykUtfAd6tc0dkc+fYssjw//p2e5m8PFvh3uTab8I=;
        b=Y80yuFjeddNa9SVS3q/Xnztfml9EXsNyk55hG+AvYDWoWdnEKL+psZUWEjj5Njn0Eg
         D9CXB6KARtmSym6yRcR/bEMZWoce54C5xaie5nwvN4JvkSehc2ye77UbjE5ZfIenBwdD
         l4APiNCYUuNnPlAytpFFnagubu2O6NjoxWv+sESKnqtg8KP/yq/A3Mwtm0p1w3zGDLK1
         oiZq4VVApof4NC522ea8M1DPAt374zM9h5RRHW4fW6Ok4INNoyweNWefqswWdakzalZ+
         6JfBT2BFdjWrWyyCRUBbOh/8DbNb1LKc0tM9PdTZkYWrdGRsmWx+nN/Gvwhf4hrkVaQP
         1pWQ==
X-Forwarded-Encrypted: i=1; AL+hErFbyWqKJFZVNxNv5GK4nDWrqPx8yo+wq75XFtbQtgNTYUq3bDsOIcX3h9o4A0i6KWE1i/t6JldKvg==@lists.linux.dev
X-Gm-Message-State: APuU4Z9IDdQ5aeiv9M2K3WIiKxZfhyLRp9VPglifM3nc800mT2h+hfF7
	q4SJBCbLQgm369CXPLh7gULXaPsHAix/08vKBdHKjeGqKV4tRJdqKojA
X-Gm-Gg: AZFdTZcULRvl+maQicRyiQRfFk0oFbSjQfzDpumHCMZHqgbtkdsEddpv7EnIjmQxi+c
	DBWtPZAbGIh00zjpQRWxrjh/zcO1m3rJVrDXlQIhv8X2JnWE8iKEmj33hN66s0PTTMgSK/jAbdu
	8kZbmxScZF1QqwIOnXAvuLLmzwmypl3Oczb7CwM2E081dZ3Oy/L7kAdgiB2nmDhzoPHrMjo7gjD
	Yhb382+8gWiPW6gUROZfnAQM8f85exKjrhuw1HX00bQttmkFAhnBoF7igqfXEsfTKPJXdbQJCTn
	KqJUQRvpvZ/4RQZr31fE+xKxVVK6iT7L/isVEzA0x95UWRKQWY32yOIrMoAvz7CPDYDwA/tI3aH
	xTr+XqtqvYvlrPRIccVNxh4bCWCU7r0CbKUNUKilnabwkFBCLdx7LIxF0EqLZK0IbRir1a+MRvj
	bitNWc5HpIeHFphHxjU8FJYTqcINx8j1NxYM5JEX1TR6YaPV//437RRszlb0lxqTbUrizVMGhDD
	1f1kRnmLTbu4bV2TeixYYCI1d84b0xECYJeLJcmVz0Ny+l2JdpcR63HLSA2y2p8MwaV2CiquIaw
	QVRjLSzj3jYO2DiHKxZaULTYgYVwYhqT4BB5SjXijiIs1RhKsvCSMUTk2+jCVE4GnkS0I6bB9CN
	ZGATW4leR
X-Received: by 2002:a17:90b:388b:b0:3b4:574:3bd6 with SMTP id 98e67ed59e1d1-3b41c982e09mr6151085a91.66.1795281611580;
        Sat, 21 Nov 2026 09:20:11 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d028a54sm2585657a12.18.2026.11.21.09.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 09:20:11 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: agk@redhat.com,
	bmarzins@redhat.com,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	okozina@redhat.com,
	zkabelac@redhat.com,
	dm-devel@lists.linux.dev
Cc: yangyongpeng@xiaomi.com
Subject: [PATCH v5 3/5] dm-verity: size the hash retain target from the hash area
Date: Sun, 22 Nov 2026 01:19:33 +0800
Message-ID: <20261121171934.3847617-5-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261121171934.3847617-2-yangyongpeng.storage@gmail.com>
References: <20261121171934.3847617-2-yangyongpeng.storage@gmail.com>
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
- Compute the percentage with mul_u64_u32_div() and clamp it at
  ULONG_MAX, so a large area cannot truncate to near-zero on 32-bit.
- The leftover sysfs-era bufio_kobj field is removed.
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


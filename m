Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795250515;
	b=nSP5D4O1pzDt5oTBi2p9l04/RU49JfPWaWhA6RHbEJm2eypNjVtDuAS+Let8khNcW9Wv
	 IwT5PW6X8EhP+lOb97sxExNOwQNAbd5+vnKJ8LXHf8N4SQwvM69zfr+zYYDGwWz4SOf8u
	 bN2T13wQxcTFEk1ANrtJm7NIo0aFl5JahZKOoLqQyt1u1ZwEyIcA3j5T5SHveQzmvo78Y
	 iExygpupiFzacUmK7YlevhI4cEu/f5RZooikPLcM7S+PBANSfwibKYqLpU1Xb0aQ1l6GC
	 DoPrwZ3vmzAM0jkevt2FUBgfCr/vgffP0L2thGrBugrpfu5ERnoKddACGBAKpiOq/mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795250515;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rlUykUtfAd6tc0dkc+fYssjw//p2e5m8PFvh3uTab8I=;
	b=2e2HHu0ns9KqJXI2y99vG1j3mfUi/e1gTVfSIOMQBKHcw4jd3+j011AE7xNZECyly5vL
	 UIJM7SSrJmdAOFoXj064L4XyuNhibz2L9F9hd2ruD+wc+mx8BGbxQcxRRp7EUmXCqrW8C
	 ci09n4pw9J8+kgAnkS7w5Yb/Il9EfhMTYJKloTzCLolkN3LY6pTdjrHfpOcfUH7j18F0/
	 4t9nbkcDESgWt1OnXrk3N/RV09SnqiAeHOUEourfojjjTdp1edEJCnB2f9VlECpUPJdzy
	 SGCzWG09VBGnP/gAp27YFLfZ3Y4XCIqhpQ7CERSmaPoflj41unw7s7rp1utT/OKC2SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=M8IGg269;
	arc=none smtp.remote-ip=209.85.210.171
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1821606A320
	for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 08:41:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1821606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=M8IGg269
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8b67f25e6e1so908092b3a.0
        for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 00:41:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795250514; x=1795855314; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rlUykUtfAd6tc0dkc+fYssjw//p2e5m8PFvh3uTab8I=;
        b=M8IGg269OYnLYfPOXqJBxzRcP3AMzA2KFC3vbiSFkXTGjIpLpwcq7OA5rJO4oKsJ+n
         bsQTVnoj3K2/SPTGGo5QlNpY5Vzl9GQwKrXccmZWJytEAU+GIooEPYYMdi3Crd12F2ez
         EGUROGZzSSdgVRD+gCeR4b4YNYZmv0TLlOYo3Dap/tJ/YUvt4OxU6413WGtAt+NeOiOr
         RcpzxyYRJHk5kQcmCf3gsBBW4ovEpAT1jnBfET0ds9t3Z5y5YnUzUM3Vr8td6USIsrrO
         HNSJiNrGbdpZcrHbMClsJ6bFYQ20o0u6wx3rCoFNlgMOZwFArQHm4Npe1kb6hT49lBTA
         OveA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795250514; x=1795855314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rlUykUtfAd6tc0dkc+fYssjw//p2e5m8PFvh3uTab8I=;
        b=aZtyK7nR27Hktjot7SYIZAZGE2j5Nskhcw/+XQ/YLoL7ukdeRHqSQbJnnRiHMlkOAn
         X8c/CI2y2mUfH0/4PXJmXy0mF2TYwXM9ng5wmmgpjEgXAi8GwQAfqtRwMm8zQd6jMovd
         +kK+G82acyDumDEaqCW9BjtVVlYpd8AljX04EVGgAg9eKEJg2MdConKC+Abte8hzWbFg
         ArggN9Fru57Cld8D+upVXUlKkUnaOMiTK88GcroVfBf1EdWkWs67FssiZKwddAkb5p+B
         OCXpCUGMAtu5DmjgpzCrLTwK1upSrprBMyZF6PhweHwp8+zGNRnWU2l0w1jvzQzPUNFp
         U62Q==
X-Forwarded-Encrypted: i=1; AL+hErE5Qku+97FriXHC9kv8wVFPfXo2aZ3N7uO8FJKpILPGYmowASUmZgNqU+IRoNd4P63CyRabGMSD9g==@lists.linux.dev
X-Gm-Message-State: APuU4Z9zr0KV4NiMqA3pfuCK2At72z15QBDXkPiskbjEpvidJAPl5wG3
	PaNMr7ziQndno1/cLtqoG9qxptDiu1EXQPCd0/t3PR8NdXGEtxwZQlem
X-Gm-Gg: AZFdTZfnXjRiTZN9dli+fJMT1ZNUho8kzsqQ43S4/ZASl5W2hI+2i33HBgtvx95QZQD
	xf2ohswIipugEJQjSBB77ZantsEFXYGrCwO3XoUCLNZcsVno/tvgwWL/r0VbAPKcGcz9QdxT/hs
	wR2RWRO+9nhx/A+p1VSOH2l0EHrw6s8cqdxuqUcUyo1YiZOcbfJ+SZT0aAVYN2NYm1J+ebAUB+V
	f/6Gju/cekWop+azxUcBBl74xllmkOFFrhANS1lNx//Jq0s6eLoFFj41XPEBuSYZDjIm2KGw8m5
	oFC+uHuxUeIUKuAJ84OWyOLjlb+SG5eKYHW+/76fgKurwV0ZLWW3LuO71d/EvlKwdjJLhhhzRuv
	29fCIVfU9jNZwCq1v/p20QX+avG0QpaXHLg46AbNYxa3BEh0c3ilB+nX0ww/8fLZ7xVlKAWrjHT
	xrjyQ38xrg8LpfSwQzrVFQ7gvxyQtVxtQh6SRUscoFDJX66DZszJdO8g358qQwF1vdBcLH4MIN3
	PdJYU7iYWN4bufkY4F+urxLo2AVHgDmNdRG3a0J6pr6xnAHd+KrLZ337clXWWnI5mN2/mdFR+tN
	GqPSiAe6N2Sb3CmQxACTGGHzd6go6hS3N9D/TZZrzcJzJHg7buUCxO3vbMgqGAeCqt/eMyVmXEW
	vnez4Ut9PmjoNuKqkqYH5gh/alIiBwQ==
X-Received: by 2002:a05:6300:614a:b0:3e9:27a0:e9bf with SMTP id adf61e73a8af0-4014cb3952bmr5385075637.23.1795250513895;
        Sat, 21 Nov 2026 00:41:53 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87353b889sm2605350b3a.42.2026.11.21.00.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 00:41:53 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: agk@redhat.com,
	bmarzins@redhat.com,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	okozina@redhat.com,
	zkabelac@redhat.com,
	dm-devel@lists.linux.dev
Cc: yangyongpeng@xiaomi.com
Subject: [PATCH v4 2/4] dm-verity: size the hash retain target from the hash area
Date: Sat, 21 Nov 2026 16:41:18 +0800
Message-ID: <20261121084119.3418879-4-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261121084119.3418879-2-yangyongpeng.storage@gmail.com>
References: <20261121084119.3418879-2-yangyongpeng.storage@gmail.com>
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


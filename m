Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022540;
	b=J4rQJLdabiVI7c3BoexBuxmpHbP5TKkZl4HAi3FKXe7eLbQoYeh9qBdM7PzEe+JNrTtv
	 uO7RFLF9tAYOTjPLM1P4u4OtV4WBMmZo9SyB1PTxeAkyxL/KbtavAJlr5yPZ55UBlGjGD
	 4q293iZhlYGjWhk2VKnVvKkhO4d/R0yQxnb3HD25iw3ur0jZxXtar211NVFoyIxXGNDpc
	 ju0PytJMINjJiPAXuGVNqXVzirTCbVkhWK/rxVyQbrxG+zvXS4Pk0awrRifVZZgRBz//l
	 pU+hRZQudgTelflN9264DVDhV2UpF9H+J3klRP3qX/53XUiGYY7ZrIhh3v2RaZVOgaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022540;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l9V8Zz3Qc1+nIuiVVFzdkodqoixlmxD/LQ7/ZEqo/RM=;
	b=B67r7mrwxZRHgFovRg4Io8IrQeiB4cHZFYSOqEgzWuuP3n+gev2vzEn5sFXtnzGxqSqy
	 nJRAji2R9czUkGkkQB8TFh3M1pXaRgojj9EQ4eYxvxicV+YGngViedosWwcTZOFsFsrX/
	 qB6RhvIIFVji/lQc1HNm4y39UbTTUKkW1e/6YzgbJH4/4+0d5BHXRvXXV+wqBngz5ph1C
	 MaOOzT2np2++8vws1cYk62HKRswi2RrEKxdanEdW2VEyGTHyYKmBRUYKv/VI/GLG8Xy/r
	 nSaqDVkBPujH2xWZfzbmYqUwWiS1sbuSMD65FaUkTWilzbKXIpwDbv77u6F6QpLJvow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ttw1tQsp;
	arc=none smtp.remote-ip=209.85.215.174
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA5F606A325
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 17:22:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DEA5F606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ttw1tQsp
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc4aa18f9afso837308a12.3
        for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 09:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795022539; x=1795627339; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l9V8Zz3Qc1+nIuiVVFzdkodqoixlmxD/LQ7/ZEqo/RM=;
        b=Ttw1tQspFSohSHK8nD+i4MXtRvKGo8SQ7x1t/TtM5WHFW/uOd6ohycyIwYsEE0/DHz
         OsknkWl18SbTp3S37EwVrU9X8lakPnBp/TzytamlARiHVLu23XN6WQWnI1AjJDkPeNki
         iCZFQlfZ5mjWe/zSTm92Y5o42TB8ZrSxWyE/s2iS2LAj0GzW25np1AIqKeqz+vnG1XGI
         V2hIWhHfo1+lizHXyvVGLiGH2OtNkiRZCGB6Nfq+SKh2thEoUXedZQbzlQOyYSlyBOhF
         CsujuaJVc1UMkgHE/t8bMPQthdCc6ooNsdiuMZuf1RmJL76+Ei5tzJ6geUXYI5L+dg7J
         BAYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795022539; x=1795627339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=l9V8Zz3Qc1+nIuiVVFzdkodqoixlmxD/LQ7/ZEqo/RM=;
        b=bjeeQJzMp4pHijCDYanPTTBw+2O5igkvEImbBxL6SBPQ0NLvIwpMlUn5UnEM7FOTBG
         9ArToq+hU8ZnCy4qF9T441DHUOKmt+QsaD5EIE/O8uDyar+9hJm+/Hn0XVRVfIFTtkSg
         N/qCCX07SmdyflkRk586QcHLXiwhRDda0BKPbZgQgwDJr7m40aepSWpaPSkerGJZqfPI
         7lLuHOvioaV0jGtp0tjDph1dzy8S21XJG+FAEHQikSN8BgChkKTu5h5joGA1Bx2hA5DP
         tqet6Csv6O5xM0uvxf7R9fds15CP30e9Ru4xeJ/1J/AA9egZgIusEgil0lVrurD7+UgM
         E1GA==
X-Forwarded-Encrypted: i=1; AL+hErFu5IvU+WuoAiJRGHp1I6VAHoUb1fL4lJjCPNu7OtpK59AyAiM4OWlhDVz8Nq+b6sUQGqbzuO9scg==@lists.linux.dev
X-Gm-Message-State: APuU4Z/QhDUSQVuQvwoEsL4Vj61CXCvuwMKj6otg9wR/UDpdEQCnqSm1
	9CmL2pFX+Xc5C+PQREESBa4GD8PkWZM07e9XvLkKEpn1oB1wdMq5h1fc
X-Gm-Gg: AZFdTZfxpygfTYhjfg4TpDnOd/dYq49uhKu3O6Je+jAA+W0Mgb6pRDFqmga9tos7PWp
	0mr+Z5d09oPU9ZRfDWqtCvUVB03d2BdEifeITmiG4MBoCF/xMpp7c6PaTQf79hn16cx8kvMv5LV
	enfdcT973q4C0lUnIRFqFNVQ4B2IcpDVtRx4LeLjli4C3+y23aKh7j6PTdxIX81/QWcE8+WioeN
	hAnFMFyN6I8bnAqoyC94tW2mqOazgwsvHF2yS19ulsJp3gO6VFAUvsAsHtDllhR6yafridVgW4C
	3RQTOqWMJZarY3A7PRqSX9P3Y75XgrC4iJo0fV9LklwR9QlgS38f5xqGFWErGzISEG2s8imSQbE
	jQ/pZ+q30I9P2wSVI0kgxA8VIoCqjr5ePHvRw1DD76hbMKR13xdGVuKEEvqeczvqjtDnqpzTTdA
	i8YyrfxFvPnZE9foWMeZgmnkREtrvgfxkw3clIpMnhNodczwmimy8ilRI/daLuejebXXpo6DupC
	syz+GIa+UecGvTRUECMaEmcXX5YWlRT/NoKgQG86a7kEETwSch5yrjRIaG7NiUtE2MpE5wO5NpZ
	Ks1Ntz0rnRQvZr7JaMFvUhLLUkC2bo8sK2qgt9VAc764rGxJgR9emRsEdqBuRXyOKr2V6XQeWWB
	QpZ7AwOQn
X-Received: by 2002:a17:90b:3891:b0:3ab:2737:3396 with SMTP id 98e67ed59e1d1-3b3d07d9354mr3438494a91.65.1795022539102;
        Wed, 18 Nov 2026 09:22:19 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3f7067012sm135659a91.12.2026.11.18.09.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 09:22:18 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: agk@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	mpatocka@redhat.com,
	snitzer@kernel.org
Cc: yangyongpeng@xiaomi.com
Subject: [PATCH v2 4/4] dm-verity: add messages to inspect, prefetch and drop hash blocks
Date: Thu, 19 Nov 2026 01:21:34 +0800
Message-ID: <20261118172133.689163-6-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118172133.689163-2-yangyongpeng.storage@gmail.com>
References: <20261118172133.689163-2-yangyongpeng.storage@gmail.com>
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

Nothing lets a user warm a verity device's cache ahead of the reads
that will need it, or release the memory a device no longer needs.

Add three messages.  retain_bytes <hash|fec> [<bytes>] reports or sets
a client's retain target.  prefetch_hash [<start> <count>] starts
reading hash blocks asynchronously; it is not limited by the retain
target, which only applies to eviction.  drop_hash [<start> <count>]
drops hash blocks, keeping those that are in use or dirty.

prefetch_hash and drop_hash are unsupported on try_verify_in_tasklet
devices (-EOPNOTSUPP), whose bufio client cannot evict or wait for a
buffer that is still being read.

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Assisted-by: LLM
---
v2:
- Reject prefetch_hash on try_verify_in_tasklet devices
  (-EOPNOTSUPP), same as drop_hash.
- Accept prefetch_hash/drop_hash with an empty hash area
  (levels == 0) as a no-op instead of failing.
---
 .../admin-guide/device-mapper/verity.rst      |  43 +++++
 drivers/md/dm-verity-target.c                 | 169 ++++++++++++++++++
 2 files changed, 212 insertions(+)

diff --git a/Documentation/admin-guide/device-mapper/verity.rst b/Documentation/admin-guide/device-mapper/verity.rst
index 9e9d4b8157c0..ec29cc6b6dc7 100644
--- a/Documentation/admin-guide/device-mapper/verity.rst
+++ b/Documentation/admin-guide/device-mapper/verity.rst
@@ -328,6 +328,49 @@ Status
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
+Each client's retain target and memory use are visible under
+``/sys/block/dm-N/dm-bufio/<hash|fec|fec-data>/`` on the verity device's own
+block device, and the target can be changed by writing that directory's
+``retain_bytes`` attribute; see
+Documentation/admin-guide/device-mapper/dm-bufio.rst.  The directories are
+created when the device is activated and removed when it is suspended, so a
+table reload always finds the new table's directories in place.
+
+Messages
+========
+
+``retain_bytes <hash|fec> [<bytes>]``
+    Report the retain target of the hash or FEC parity client, or set it
+    (0 resets to the dm-bufio default).  ``fec`` requires FEC to be
+    enabled.  The reply is ``retain_bytes=<bytes>``.
+
+``prefetch_hash [<start> <count>]``
+    Start reading hash blocks into the cache; without arguments, the whole
+    hash area.  The read is asynchronous and is not limited by the retain
+    target, which only applies to eviction.  Not supported on devices
+    created with ``try_verify_in_tasklet`` (``-EOPNOTSUPP``), whose bufio
+    client cannot evict or wait for a buffer that is still being read.
+
+``drop_hash [<start> <count>]``
+    Drop hash blocks from the cache, keeping blocks that are in use or
+    dirty.  Not supported on devices created with ``try_verify_in_tasklet``
+    (``-EOPNOTSUPP``), whose bufio client cannot drop buffers.
+
+Both cache commands still work while the device is suspended: prefetch
+reads are queued and complete on resume, and ``drop_hash`` finds an empty
+cache because verity resets the bufio client on suspend.
+
 Example
 =======
 Set up a device::
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 8059c842b9f9..94ace13c6091 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1933,6 +1933,174 @@ static void verity_resume(struct dm_target *ti)
 
 static void verity_register_bufio_sysfs(struct dm_verity *v);
 
+static int verity_prefetch_hash(struct dm_verity *v, unsigned int argc,
+				char **argv, char *result, unsigned int maxlen)
+{
+	sector_t total = v->hash_end - v->hash_start;
+	sector_t start, n;
+	unsigned long long value;
+	unsigned int sz = 0;
+
+	/*
+	 * On a no_sleep client a buffer being read cannot be evicted or
+	 * waited for, so an unfinished prefetch would outlive a suspend or
+	 * teardown; drop_hash rejects this case for the same reason.
+	 */
+	if (v->use_bh_wq) {
+		DMERR("prefetch_hash unsupported on tasklet-verifying device");
+		return -EOPNOTSUPP;
+	}
+
+	if (argc == 1) {
+		start = 0;
+		n = total;
+	} else if (argc == 3) {
+		if (kstrtoull(argv[1], 0, &value) || (sector_t)value != value)
+			return -EINVAL;
+		start = value;
+
+		if (kstrtoull(argv[2], 0, &value) || (sector_t)value != value)
+			return -EINVAL;
+		n = value;
+	} else {
+		return -EINVAL;
+	}
+
+	if (start >= total) {
+		if (!total) {
+			n = 0;
+			goto out;
+		}
+		DMERR("prefetch_hash start %llu beyond hash area (%llu blocks)",
+		      (unsigned long long)start, (unsigned long long)total);
+		return -EINVAL;
+	}
+
+	n = min(n, total - start);
+	n = min_t(sector_t, n, UINT_MAX);
+
+out:
+	dm_bufio_prefetch(v->bufio, v->hash_start + start, n);
+
+	DMEMIT("prefetch_hash: started %llu blocks", (unsigned long long)n);
+
+	return 1;
+}
+
+static int verity_drop_hash(struct dm_verity *v, unsigned int argc,
+			    char **argv, char *result, unsigned int maxlen)
+{
+	sector_t total = v->hash_end - v->hash_start;
+	sector_t start, n;
+	unsigned long long value;
+	unsigned int sz = 0;
+
+	/*
+	 * dm_bufio_forget_buffers() ends up in cache_remove_range(), which
+	 * cannot run on a client created with DM_BUFIO_CLIENT_NO_SLEEP.
+	 */
+	if (v->use_bh_wq) {
+		DMERR("drop_hash unsupported on tasklet-verifying device");
+		return -EOPNOTSUPP;
+	}
+
+	if (argc == 1) {
+		start = 0;
+		n = total;
+	} else if (argc == 3) {
+		if (kstrtoull(argv[1], 0, &value) || (sector_t)value != value)
+			return -EINVAL;
+		start = value;
+
+		if (kstrtoull(argv[2], 0, &value) || (sector_t)value != value)
+			return -EINVAL;
+		n = value;
+	} else {
+		return -EINVAL;
+	}
+
+	if (start >= total) {
+		if (!total) {
+			n = 0;
+			goto out;
+		}
+		DMERR("drop_hash start %llu beyond hash area (%llu blocks)",
+		      (unsigned long long)start, (unsigned long long)total);
+		return -EINVAL;
+	}
+
+	n = min(n, total - start);
+
+out:
+	dm_bufio_forget_buffers(v->bufio, v->hash_start + start, n);
+
+	DMEMIT("drop_hash: dropped %llu", (unsigned long long)n);
+
+	return 1;
+}
+
+/*
+ * retain_bytes <hash|fec> [<bytes>]
+ *
+ * Report the selected client's retain target, or set it (0 resets to the
+ * dm-bufio default, non-zero is rounded up to a block boundary).
+ */
+static int verity_retain_bytes(struct dm_verity *v, unsigned int argc,
+			       char **argv, char *result, unsigned int maxlen)
+{
+	struct dm_bufio_client *bufio;
+	unsigned long long value;
+	unsigned int sz = 0;
+
+	if (argc < 2 || argc > 3)
+		return -EINVAL;
+
+	if (!strcasecmp(argv[1], "hash")) {
+		bufio = v->bufio;
+	} else if (!strcasecmp(argv[1], "fec")) {
+		if (!verity_fec_is_enabled(v)) {
+			DMERR("FEC is not enabled");
+			return -EINVAL;
+		}
+		bufio = v->fec->bufio;
+	} else {
+		return -EINVAL;
+	}
+
+	if (argc == 3) {
+		if (kstrtoull(argv[2], 0, &value) ||
+		    (unsigned long)value != value)
+			return -EINVAL;
+		dm_bufio_set_retain_bytes(bufio, value);
+	}
+
+	DMEMIT("retain_bytes=%lu", dm_bufio_get_retain_bytes(bufio));
+
+	return 1;
+}
+
+static int verity_message(struct dm_target *ti, unsigned int argc, char **argv,
+			  char *result, unsigned int maxlen)
+{
+	struct dm_verity *v = ti->private;
+
+	if (!argc)
+		return -EINVAL;
+
+	if (!strcasecmp(argv[0], "retain_bytes"))
+		return verity_retain_bytes(v, argc, argv, result, maxlen);
+
+	if (!strcasecmp(argv[0], "prefetch_hash"))
+		return verity_prefetch_hash(v, argc, argv, result, maxlen);
+
+	if (!strcasecmp(argv[0], "drop_hash"))
+		return verity_drop_hash(v, argc, argv, result, maxlen);
+
+	DMERR("unknown message '%s'", argv[0]);
+
+	return -EINVAL;
+}
+
 static struct target_type verity_target = {
 	.name		= "verity",
 /* Note: the LSMs depend on the singleton and immutable features */
@@ -1947,6 +2115,7 @@ static struct target_type verity_target = {
 	.postsuspend	= verity_postsuspend,
 	.resume		= verity_resume,
 	.status		= verity_status,
+	.message	= verity_message,
 	.prepare_ioctl	= verity_prepare_ioctl,
 	.iterate_devices = verity_iterate_devices,
 	.io_hints	= verity_io_hints,
-- 
2.43.0


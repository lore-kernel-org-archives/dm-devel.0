Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794921618;
	b=2T39r++rtA3PApGURJlCsS20+pi/tmhGzudBPyQCKhRwCuWz5fR23O3kU5rkD5SYtKyH
	 xfTXuKaEOxVr6no/BoQkrr/3JeVb17uaqHHQPmBLEMSZFl3XRJ0LwXL+nK4jgkvEYahgk
	 5I4nQSgEhBhdgcFfL50BDbLJ7XWR0JSWmiN01BbyYepY0cK59aJ2p75r6P6gKsEbFwJzB
	 F+n0BA8uK01/FF4VTF3arUNVdEe23zacJRuWwuCED2w2GC36SzQodr+Mj/rd8SapbMQbg
	 Hii5ulVTLQt5fhYEXzzlYfcXELCGuMVVxLjP/JxCiG1T46ZkFfT7ZwU7SRT4oGWaKgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794921618;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=iWlxrv+AcT5ZQb4bjWQXKVckOuAz/YqFbGaqUunOEYU=;
	b=tUuDxvEWAWOquWc3h02GNT21SN9RIcDEslWoBf0ccPlHVyWJpQfZRiLAic4aTO9VZoHG
	 MN4HHtRPDCkUxGGoZ3zOIAYF7+YutC/CGUaqpYdcexkqmvMkUZ++vSEfxSFaBJFtuyzoh
	 Hty1WyWR4K6noSvfcvF6zBz9nbZlJdXPxj+2heY+tY6MT09HDE4J7RfzTXcElijTPmuzS
	 iD2rr2QYr8+Zh9K61hkfBg6URv/y5zF9zADi5fSe/cwyCU1W9QDzBd/9KBI6w5kDRAUFI
	 5wPKVM9T6EFz+3+Kb5odC8ZoLDf3OVfrsUTPdFrz/hT8j0Ss5G/C9ULahXg4Hu4BVNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q4o6k9M6;
	arc=none smtp.remote-ip=209.85.214.174
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2208B606A323
	for <dm-devel@lists.linux.dev>; Tue, 17 Nov 2026 13:20:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2208B606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q4o6k9M6
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2e9995ce866so43736495ad.0
        for <dm-devel@lists.linux.dev>; Tue, 17 Nov 2026 05:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794921617; x=1795526417; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iWlxrv+AcT5ZQb4bjWQXKVckOuAz/YqFbGaqUunOEYU=;
        b=q4o6k9M6S/Qfqv8kfhjqerPX5Tn7f1OfLPXluU3u8lbuYz8Pp0MNlffHfk9HN9tVxD
         wd6asrQXzCvmx96TcLgnfznTbzUAVD5Eo22NPH5Xa4DvJ5kZR+9DDw3hgRqM6vnFAL7n
         I7uX3ACh2o//bCpfGQOSEKT1FsR/oXr1rKRGTX0tRo6beUVDC1kTI502+eclhgl7e/dk
         nMyHhtFVzloHQohKqTji8GKeUOqpB11LsRqVhtSGrx1pKMIRwY3Sy7N9pjz5VSDy/qPx
         r2PiledMzjQFsxtMkJfNV7rCwCYgRDZRhUiWbhF9XU/k/rzCGB+6GHu+fDUkjlroC2/e
         uU6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794921617; x=1795526417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iWlxrv+AcT5ZQb4bjWQXKVckOuAz/YqFbGaqUunOEYU=;
        b=CwAVh6cKqUMdtbVZ6gUcWKpQx74LAkqxquYyXxkevYjkjPwaY++05Ms6Ko6tM6ubgk
         6ICkUvJFJUdaLCWwre1KWLlUc9kc1e2DMmRzIlCSIv9f8Uc98He9kYtQmhBfrQAVcM1v
         fnxirt0VEyBesFvHzk340bIUsRXBJ+fxZSinLvoGi65t7Ggeqqgjv6pTnXzv+eOrJoxH
         +JqegCEsX64kOKqUWRFDTkXwLZZq2zFu7Ngrl26qhigUgpp1ukoa4HwvfkGX7FKiNa4M
         N660Vwh+HdkYG2EKy8kIW+PGpqahr7B1e774Zpd0ilOM0h+y9XnXh41PvRLL1OqpyoVf
         nPJQ==
X-Gm-Message-State: APuU4Z+fBNoh/3g2avdLrbNAufnI7CCaR4cpBekqWfDoVUVEeYToQdq4
	Juh8wRL1X3U5g84DuCnm1TIvhZnrco+4ORxmUG8k4PJpVgXp5ymiY7Rg
X-Gm-Gg: AZFdTZf126GiKBFx9slNAvarvYbTGR6OsEXo0TH2tO4K+hANAmqnX46NHGFanvdO91r
	9/CihcMYJ/3lbRA0YEeEXMyDLMcwRw0WEQdAKHsnhY4fmGdvYrrlCMyVZ/l1BoD+ga+CWfa1TLy
	onYOHMxt5AIXKIMoxinPUX2GkNojBinDtfNCJ77MKM4UcfbYdygNCQNtr3ZI+fYwRrQtIZzgUdS
	baEF7plXda5peg0B+uL7rc2JavJ2a70fzYfmbMFMB3m30BxIChz81oItrJPFhZbx89l3584lFak
	ZyWy1qhYUx0vgIiRCcSxEELFsQKQiQ/FQL8MKipJg1OHnaf1e14rS+KdN+s/D2EeWcbFtS7H6ci
	Q+Nw4xnIzssw2J/QjKTLo4kXGQjZbYcwLCOhaWNkcswwSZo/w7sTJ8Dfc64ETsbvr+PuYwVXPRW
	wkUryJc9ifYXrIeLYTFR0Bu5GG1SGUOop7Mx+hkfSAE/MjrM2HDeNgEkclleahXO/7myvK/97jk
	H8L5Ie9iQ2Dk1rOkjTG7UZbXFJKKXIC4OWAPdWHRfCeYWiyBVoeeuU1GK451U6ycVF3EPebMsrW
	+IxgpGO9PU++Ua+MWnr9sG5PeleF3SyvfwXZR9b/l98tt0XyI4LlGnbODQktMqzmUhP8KLrcAVO
	lTsBXocjM
X-Received: by 2002:a17:903:3c6f:b0:2ed:379:159f with SMTP id d9443c01a7336-2ee0da9672bmr128183515ad.20.1794921617298;
        Tue, 17 Nov 2026 05:20:17 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2efd7a5f754sm16064915ad.52.2026.11.17.05.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 05:20:16 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Yongpeng Yang <yangyongpeng@xiaomi.com>
Subject: [PATCH 4/4] dm-verity: add messages to inspect, prefetch and drop hash blocks
Date: Tue, 17 Nov 2026 21:19:20 +0800
Message-ID: <20261117131918.2745193-7-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117131918.2745193-2-yangyongpeng.storage@gmail.com>
References: <20261117131918.2745193-2-yangyongpeng.storage@gmail.com>
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

drop_hash is unsupported on try_verify_in_tasklet devices, whose bufio
client cannot drop buffers (-EOPNOTSUPP).

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Assisted-by: LLM
---
 .../admin-guide/device-mapper/verity.rst      |  42 +++++
 drivers/md/dm-verity-target.c                 | 149 ++++++++++++++++++
 2 files changed, 191 insertions(+)

diff --git a/Documentation/admin-guide/device-mapper/verity.rst b/Documentation/admin-guide/device-mapper/verity.rst
index 9e9d4b8157c0..8fea6130765b 100644
--- a/Documentation/admin-guide/device-mapper/verity.rst
+++ b/Documentation/admin-guide/device-mapper/verity.rst
@@ -328,6 +328,48 @@ Status
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
+Documentation/admin-guide/device-mapper/dm-bufio.rst.  The directories appear
+when the device is first activated and disappear with it.  Reloading the
+table removes the old table's directories; the new table's reappear on the
+next resume.
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
+    target, which only applies to eviction.
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
index 3ae1b25fdbf6..e197befe0793 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1874,6 +1874,154 @@ static void verity_resume(struct dm_target *ti)
 	verity_register_bufio_sysfs(ti->private);
 }
 
+static int verity_prefetch_hash(struct dm_verity *v, unsigned int argc,
+				char **argv, char *result, unsigned int maxlen)
+{
+	sector_t total = v->hash_end - v->hash_start;
+	sector_t start, n;
+	unsigned long long value;
+	unsigned int sz = 0;
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
+		DMERR("prefetch_hash start %llu beyond hash area (%llu blocks)",
+		      (unsigned long long)start, (unsigned long long)total);
+		return -EINVAL;
+	}
+
+	n = min(n, total - start);
+	n = min_t(sector_t, n, UINT_MAX);
+
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
+		DMERR("drop_hash start %llu beyond hash area (%llu blocks)",
+		      (unsigned long long)start, (unsigned long long)total);
+		return -EINVAL;
+	}
+
+	n = min(n, total - start);
+
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
+ * dm-bufio default, non-zero is rounded down to a block boundary).
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
@@ -1886,6 +2034,7 @@ static struct target_type verity_target = {
 	.postsuspend	= verity_postsuspend,
 	.resume		= verity_resume,
 	.status		= verity_status,
+	.message	= verity_message,
 	.prepare_ioctl	= verity_prepare_ioctl,
 	.iterate_devices = verity_iterate_devices,
 	.io_hints	= verity_io_hints,
-- 
2.43.0


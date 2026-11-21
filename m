Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795281620;
	b=zpryDo3K3XS7NSjL0nir0Im3WrzB2sBfbgzKHwDa8HKYPmvoLYqcoW+r5uZ8dhVfHuuJ
	 w3s0MMwnJs72jGMm9xNY/IH+No9Q9nhDl810hvuoTKMIB3QUeDUru23LWQhLFbCt4/lwC
	 abUIGLP5zGF723JjEULkRfnQp9yvOFHAHgcqvMyd5gsEWyCjnxznWcEet0unrsMLmRQTm
	 X7ms6YQA+3jxlpg/y2TgbTzf/LNZEqxeTFxU1vYARx2GZIBxzCVo/h1VwdpsUhOdq0dmm
	 8x0Y4TI/p56VLrDQMXXIh8+3qZ10L8DwuVVYMiCCU6cTrOpj3sJHfEG1l8LjhY4+opQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795281620;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QQY54W7gaQ/CXed8xVrd+8aplb3vRSPbN+71Nw4x//U=;
	b=Tlb6GsmhNr7+zbFN9j7dcy+VchWvOto3dp6LVDWj+oJI8LaGnLnjLfx6p0HPYh4jfydd
	 SYBGrKWf8HuvGENz9tO/M0xDodhWRUxcRf2KBA7X0Xq+pXXMWeviM/XRdh32tehFHzuoO
	 7qZCS8I/DohXBYT7qzejh8scKg1CPtqqM1RkFOMWUUAjrLjewuhBUptKB5odWKUd3h699
	 TF7iUdOgZbMTYBTtJVhMANJstTI+dqswz7v/gn8kRvk+YP/vRB7Xp7sTCKfucYsdgXQRK
	 XMXeIFIyhyCZPfVCdw8ZFlO7Dv5HAq58E043GL5/VKnRRhl2jderpXtpYjAHrWNkoSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=r0W+LPHj;
	arc=none smtp.remote-ip=209.85.214.179
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76507606A320
	for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 17:20:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76507606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=r0W+LPHj
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2f07a960666so902505ad.1
        for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 09:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795281620; x=1795886420; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QQY54W7gaQ/CXed8xVrd+8aplb3vRSPbN+71Nw4x//U=;
        b=r0W+LPHjxqyEAOFHke42YGrdFG4ZRIcA1mwRO7ajAnX/xVtFW8ncrVsCOCNcQwSSR5
         fp18tvAE2S3NnUKi3kRP5JLx/z8pvcstn4WIoN1vp+GnfxoKE4V1IPfgSJtMzaTUPGmV
         bFxPmA3aCSYR2l3OdaILAvVosFGRF4XFBN8ai9RDPNARmwqux3GtaSplC91jpsI+3X/C
         IwGO65uHQhsVul8m9O/uaC5Uo6HFhUWs9PpiIA0DpvJBpS6MEg7UO8TKjRoacRIgdKik
         LVmcOOqNiPTymVhIx6CtXwSIEw42fFAIqD56cixUR/TAbWb+0PZAhfNMslbplXlAYlH/
         1Emw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795281620; x=1795886420;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QQY54W7gaQ/CXed8xVrd+8aplb3vRSPbN+71Nw4x//U=;
        b=jcooVEZRERQJNgiKNllwWQNU0AhdTJTfSHOn5tdsemXtJsiATaZn+K3u7YQavpPqjG
         j1/Vocr1mjJW54ZjZe57Tgf48B4/rxd19PY+qX0nmnessbbvLlrA+oVI5SIcW/v8nHF5
         ckZTlKCu3Uwa4PyY3Au/Zei7QG5rwUsOPV/YIFjBvxAjSswN2dPLG7flK+G2oeI/jPmD
         EN4PaHU6W/0jMNPlMYK7wZDfzgXEbNHQ2TZ8Oju/qv/mdfFMcTBcDwrEBiFYlRlyS/Km
         tskTVN8Dd0O5obNiVT7HD8XaunYk7WWWnWcISIZkoLuUdSKIjVgy6DM45wsY547laIxt
         HpNw==
X-Forwarded-Encrypted: i=1; AL+hErENV2uW3zZf8oRHgKlDaIW41RmIDe/hZF9/V5TfTqfQSWUbzvubSVc2qUv5tj2v22mxoN5b3UtpAQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z8j2B+ALqKbnZcPhp8GnQFbd2PKMQMLK4KSNMOCggsX80UfOFIC
	JZ6z38m6QTarvpk+kOfjokWNxR2DnpUSmi0Ure/fybFJMueX+ZbstbHd
X-Gm-Gg: AZFdTZcfm0Iah4eL5w3wnLLkgx/oDL3lzaMNFGvCFWOii5yUWYIenpIWuSyxJOreSgd
	kA7oiFvfk+izYkco2ifk1MYv6Z1eW8PDQo3DODZ1vGiO2GKItEMTbjOadMexUK5NfWpv3DduU9b
	T/ay6D+cQsythMSv3FRibaQoKRNd5Kczg2B1qrkBUIqLG2xyHkqOGC3pYK6WgQqc1yRsjxBhnkv
	hOxQx6s14YSB0vOQ1gFZJf8xZcRbT85Ak4FbPQrNVZ7PDSh3fljLa5mHhNIC2V/CxasKYQDMJpY
	jO5zS2BwQbnr0Y7xjsrsZpM1NkhaMONCPgSStvwuet2bwQTzBPAqoYWx4+9T5mPdE2PKUygYJLc
	YPQmSyTEiTBMuH9bXsevM+rwslC6XMVkxwYXi5r2zJSnZkADKPsnTaVunxDMY5M2Z5nFWvfnmrG
	VTi4tqpQtN5hpqi+9SvyELkrBs42L1HXT8OmNGljIzY/AzgWMYAuJT5r3feKCQ+jolx+OWBfWTZ
	/ntI9A5sv/y6ZOpCb3rkpOI74gq5mqPmyQGqgumCStvYjjzrQALk5BFxqwLA4xZHHe7fzTF5LYs
	pXHhEMn3LKDpSFyygHUfmR8MueGCdC/ZNwWjji/HwdcDeWlJwf2rPlNHIoitnIHE+B5a8REVwYj
	z98Q9m/9B
X-Received: by 2002:a17:90b:1801:b0:3ac:8446:c1b5 with SMTP id 98e67ed59e1d1-3b41c9e4b0dmr6503794a91.31.1795281619617;
        Sat, 21 Nov 2026 09:20:19 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d028a54sm2585657a12.18.2026.11.21.09.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 09:20:18 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: agk@redhat.com,
	bmarzins@redhat.com,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	okozina@redhat.com,
	zkabelac@redhat.com,
	dm-devel@lists.linux.dev
Cc: yangyongpeng@xiaomi.com
Subject: [PATCH v5 5/5] dm-verity: add messages to prefetch and drop the hash cache
Date: Sun, 22 Nov 2026 01:19:35 +0800
Message-ID: <20261121171934.3847617-7-yangyongpeng.storage@gmail.com>
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

Nothing lets a user warm a verity device's cache ahead of the reads
that will need it, or release the memory a device no longer needs.

Add two messages.  prefetch_hash [<start> <count>] starts reading hash
blocks asynchronously; it is not limited by the retain target, which
only applies to eviction.  drop_hash [<start> <count>] drops hash
blocks, keeping those that are in use or dirty.  Together they let
userspace warm the cache when a device is about to be used and release
the memory when it goes cold, instead of occupying it continuously.

Both are rejected with -EBUSY while the device is suspended, since
their I/O bypasses the suspended dm queue, and with -EOPNOTSUPP on
try_verify_in_tasklet devices, whose bufio client cannot evict or wait
for a buffer that is still being read.

The suspended check needs no further serialization: __dm_suspend()
sets the suspended flag before the final synchronize_srcu() that
precedes ->postsuspend, so a message that passed the check is drained
by that barrier before the bufio reset (the whole prefetch execution,
including the window where a buffer sits with hold_count == 1 outside
dm_bufio_lock, happens inside the SRCU read section), and a message
that arrives after the barrier sees the flag.  The reads a completed
prefetch left in flight are waited out by the reset itself:
drop_buffers() evicts the buffer and __make_buffer_clean() waits on
B_READING.

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Assisted-by: LLM
---
v4:
- prefetch_hash and drop_hash now return -EBUSY while the device is
  suspended: their I/O bypasses the suspended dm queue, and the check
  is safe without further serialization because __dm_suspend() sets
  the suspended flag before the final synchronize_srcu() that precedes
  ->postsuspend, so a message that passed the check is drained before
  the bufio reset (sashiko).
v3:
- Split out of the previous message patch; contains only the cache
  lifecycle commands.
- Reject prefetch_hash on try_verify_in_tasklet devices
  (-EOPNOTSUPP), same as drop_hash.
- Accept prefetch_hash/drop_hash with an empty hash area
  (levels == 0) as a no-op instead of failing.
---
 .../admin-guide/device-mapper/verity.rst      |  15 +++
 drivers/md/dm-verity-target.c                 | 124 +++++++++++++++++-
 2 files changed, 137 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/verity.rst b/Documentation/admin-guide/device-mapper/verity.rst
index 1e532c4251ae..17e98e85e416 100644
--- a/Documentation/admin-guide/device-mapper/verity.rst
+++ b/Documentation/admin-guide/device-mapper/verity.rst
@@ -353,6 +353,21 @@ Messages
     ``retain_bytes=<bytes> current_bytes=<bytes> buffers=<n>``, so the
     client's actual memory use can be watched through the message.
 
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
+``prefetch_hash`` and ``drop_hash`` return ``-EBUSY`` while the device is
+suspended, since their I/O bypasses the suspended dm queue.
+
 Example
 =======
 Set up a device::
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index bd2368312b05..b7c29a8083d2 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1837,12 +1837,117 @@ static void verity_postsuspend(struct dm_target *ti)
 	verity_security_clear_integrity(ti);
 }
 
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
 /*
  * retain_bytes <hash|fec> [<bytes>]
  *
  * Report the selected client's retain target, or set it (0 resets to the
- * dm-bufio default, non-zero is rounded up to a block boundary).  The reply
- * also reports the bytes and buffers currently cached by the client.
+ * dm-bufio default, non-zero is rounded up to a block boundary).
  */
 static int verity_retain_bytes(struct dm_verity *v, unsigned int argc,
 			       char **argv, char *result, unsigned int maxlen)
@@ -1894,6 +1999,21 @@ static int verity_message(struct dm_target *ti, unsigned int argc, char **argv,
 	if (!strcasecmp(argv[0], "retain_bytes"))
 		return verity_retain_bytes(v, argc, argv, result, maxlen);
 
+	/*
+	 * prefetch/drop touch the bufio cache and the backing device, whose
+	 * reads bypass the suspended dm queue: reject them while suspended.
+	 */
+	if (dm_suspended(ti)) {
+		DMERR("message during suspend");
+		return -EBUSY;
+	}
+
+	if (!strcasecmp(argv[0], "prefetch_hash"))
+		return verity_prefetch_hash(v, argc, argv, result, maxlen);
+
+	if (!strcasecmp(argv[0], "drop_hash"))
+		return verity_drop_hash(v, argc, argv, result, maxlen);
+
 	DMERR("unknown message '%s'", argv[0]);
 
 	return -EINVAL;
-- 
2.43.0


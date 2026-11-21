Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795250530;
	b=W8ZbdIYf0Vo2IHKBm6Z6kXqzo9M3xwBp9tVx8rHFUbCcH6ssh+Xn/7T4stNNBtDx48Jt
	 +yzHYq2CLsCykjy4bCERMyaXG6VC3jpPxIelW3oxDdBa9SAuAGPMH1VQSGH728eBOTOvz
	 h3q+hxUsczHrxhTafW4Imqkjq3I5xraw69enj0YEhXjnF6bYbzsQDfNWVFILCsUMEtaJd
	 cQIGhiAkytAzItavR/DPQSHcCOoQMRiAePnKJasE4ssvRfnDXQODIOJAUpvZQV8wWjcTd
	 d7M5qRDujK3wJAaDM1EzooCYr3AmtSpb2wFokYmW4maTzjjBCWm2DAYZx7lV/rYXyeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795250530;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QQY54W7gaQ/CXed8xVrd+8aplb3vRSPbN+71Nw4x//U=;
	b=TcBJFkOrvuBEnoSzyL+HR6yrS7TfDK6ZzWS9cnuelXn58QnbbWHPgwJafB+BO32az44N
	 JKo6ZoiM0nARqaaYAn5tH1/hJuNub2XxABgQUNQv7ACZN0gJagVYPaXLweXiLa23YS+av
	 WYsnudmaGlN1dmQOkTWHqCZhMHQ7li/S16oRUhyEMXqDMMtCMyjRMTWVyG0GWxmfnVTxB
	 KIh9cT4eMitWQe19+1VwlkTIonNr+P+Vzf+P502L6nHGAaxVPPaJGuS6aD/A7zHxRP+sy
	 JO1hWJpVNfa4Ig/DfON/S0sRcB0p/JXUK6vdY3ioDUlM2UbULsHG6yTLi3P/geThyaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BMLbpJPt;
	arc=none smtp.remote-ip=209.85.215.175
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B40B606A320
	for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 08:42:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B40B606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BMLbpJPt
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cc758830601so1361754a12.2
        for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 00:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795250529; x=1795855329; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QQY54W7gaQ/CXed8xVrd+8aplb3vRSPbN+71Nw4x//U=;
        b=BMLbpJPt2kGpXwdWqUbAP5yxoAzNGaHYbsETOnop+u1zjJuRZfAnjPRIlDkNrhFujw
         ohgMFXXhusboyr7knYG+FKVVBIRG5nZoOGGO8fc0MKArHenAYcqnKywypv0Bh3Jyp+yC
         OZUC26xVKE83eHnqpah55gKCu8N+8gXMnwZfC+v27xsxK0XhQSu6ifV+Zw9UebFeuW/M
         Z68wSv9kMLz38Y1LQZVF3OOQkUYwt2bHo8P31WZF/eSrW5bFcy7ljvcejC8BjfM0lsYH
         YhgUWWXW8NQzP6Ta0LEk/6S7iMMLr0EYzstI/Q4U+p7eczRaVvkweMaCvQfZYJsFhQo/
         iWow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795250529; x=1795855329;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QQY54W7gaQ/CXed8xVrd+8aplb3vRSPbN+71Nw4x//U=;
        b=iceMV7RVT/Q4JjrGK0Z6fYmTMxNxypU0sVkzfbwqJs3abYHlvT5og1M4SVi2KCxq0j
         D7T+B2iD9/+VZ57CWDzchMmSNyH3ReP4uYLY5jygbC0xgRduaVvyD0Mc9sGSjaiCAED0
         r6OsZverJa4eFeH3f5cqFkvbLH+wBxrpu3lsoeqVNOpKglO8HQ9GVisLMLAmSHQReatB
         i7h71QMjwm6nHuX0MCUdKFNk1v2O3ZTGL5V/MxwTG7T1fFi1j8u+AAuhMqv+u+hwEND5
         2TXAp/FE/eQ3pzyXIdyIEg9bpsaDg0p1/i+KZybv79Y+MdYXMbe5YQqikzhVk+0a3BWX
         Wk3w==
X-Forwarded-Encrypted: i=1; AL+hErGwyt0r98OAz4fa0Is0C3kdF9k1O/vdgUU5AnzbZ42QxHyK3p7t8Mr7GjrBL+UWS1rVA16Kugh9hg==@lists.linux.dev
X-Gm-Message-State: APuU4Z/+f43Alp2s/7zXyr/bpeesC6mJZoJz0kAp2cu7Gk7FMWuL042a
	W75xTE6g/ynfUIbFu09BePbAtl/UTthKfNehgukt1jlTwznfq4PAk4z7
X-Gm-Gg: AZFdTZcc1cW6UYN/SM5XCcoab0MmvmTJXx7l2AHZa0vB2yZTZdCeXUEZADIh97WvQz5
	CfTZ97Ab8UvMuK4UHDyGlzIN+9CL6eYzLnAB07VZOnieZeVAJu9k4sTJ7luYJ3YaeCKBbyzVqBO
	aBMqHGlnleZ3NMTiky18vySxcCunNEFtKHVz47mEEZMvmI8DcekL2+yb/1Nv3oaXvanOeHRGufh
	hhwnWANyA5UFPWaAvTcy4Qs1P/xzF7w91WP4vxWRRisZtT2GhJUCH5avMU7G8CP3pSGQu2KOn//
	EhMP1/HBPAIRGu18V5WDbKQltqouX2nBg2+VSi90pggW+ijnlRU5pnJZufVeG/9ret6GDIc2YV1
	Fcn4qCTPEKIZjdSGwTuUTBjWuyiWuC2tRpiIPVhJUW746wbo6rNBI+dF2xfCq/qLLbiZDRmKzu4
	fU4jfUTzCxJKEufw00V+HVySeMsRSa4OD+3LUWSz8NepXlg1nBY3GmBGl7lwCBnfYluWHZC3oNk
	pprIF8DgdvLT92jc5OrMkRty2md18we9kK83kc/vBpJp2HNmLqwXdNd6/0grbrh8Dn1qVDqHoq0
	raKxstfN6oBXFAS+tU+9EhsTb+aQdln8BcQ1GwvrFp3eR7fqtuiEOztvsXWiIIFvuw5CM65RkRE
	kqvKPtCXmR5WJ5O29pBX0ni2xHeS66Q==
X-Received: by 2002:a05:6a21:2c17:b0:3e2:1160:6d20 with SMTP id adf61e73a8af0-4014a17aa66mr7271049637.3.1795250529402;
        Sat, 21 Nov 2026 00:42:09 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87353b889sm2605350b3a.42.2026.11.21.00.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 00:42:09 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: agk@redhat.com,
	bmarzins@redhat.com,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	okozina@redhat.com,
	zkabelac@redhat.com,
	dm-devel@lists.linux.dev
Cc: yangyongpeng@xiaomi.com
Subject: [PATCH v4 4/4] dm-verity: add messages to prefetch and drop the hash cache
Date: Sat, 21 Nov 2026 16:41:20 +0800
Message-ID: <20261121084119.3418879-6-yangyongpeng.storage@gmail.com>
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


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795105922;
	b=rqo94ELGYPDlg5XayPXruP0s85FVsPUw50gRkZGdcHHNwZnp5QED0QQCpgnzUdquyt6r
	 6Pnkv9KGdmXn9mlxHEn41xxU+on15dvlJgP2HYIy0NjIbYMH44ZR6mQP/vVl9nDgezBnI
	 828/X2t4Vx8PS8mTmw7eh9f3RfsBU+7Ys0ZhFoja0Qa/aorbcnHRcTTFvhwIzYfoPPTrz
	 K9xOvfHrfPBQgPL5RZ2EKfbLXzyyVtN6qDwluwpRFWKanB7INtAocpigEfqs13HorhNvN
	 vQs6+sUj4kAAdqcdVZ3Kd7+RtALY1vUQT0CXg2iC9bzXqkTg/1MnXyd056vmz0TnKiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795105922;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a4ox1t6Gwtr0oP1XRr8WgvKzIydTuZ1Rk95OKxmwQ3M=;
	b=UJeVwr7Mue4TQzMXIsGQA7D2LJ7XlRyTT2Al8zjCM5NWa3dd7pDXMjySqrJTy6izc6vj
	 OFHPlpL1TUzYRuUSSUlbpuMxoovjoL53j89cIZx/JBIAhn+Gt8NBat082zAyxkcT9EfSJ
	 fwJH5e7X4fk8dOdGbAX3JPJISxK3llLKzHeeEWvLGFWHnlSfozJgaqbz3SyzKu9E1GO8m
	 W75WPUmlizqRJYU5CIAHZecCFCWvt874938hVIRDfo7qkGtdaguQfiw52w9qPE9nUpqJf
	 azH8B3FU4TbFrmndh2UnnktlFq1d4M/qvZEpcFjD1+IkPcXfDW2V1immSh7XYfoM/5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DHTekPaN;
	arc=none smtp.remote-ip=209.85.210.173
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFD8606A32C
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 16:32:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5AFD8606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DHTekPaN
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8b6a88e4341so1321546b3a.1
        for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 08:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795105922; x=1795710722; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a4ox1t6Gwtr0oP1XRr8WgvKzIydTuZ1Rk95OKxmwQ3M=;
        b=DHTekPaNRNaJO1AfBhwtCufJCMTroPyoJdP4vfLtshwZSyse2mufAgq/bsAFRiY8Sc
         UoHGWaPfgAmUY1cU+LUCLSnTQ8Xhviq5iJbacNhfuMAR3ZPm1eMrCsjGw7IMprTrlidK
         SLPLcCJNzDGuh41fnuwVyvvaavkhIzJ1IOPlEjo+wOdcySKIfUSkuHXqcYmXRktOW1Wo
         gi5mLH9yT+W4K84E7p1spMNO95ScGl1O1+IxG1zJOUZA1oSB2P1bv6anpDZ3qGPv4d9n
         tFAdI9BM8iXgmE/Z9eLBkBTuJD24D2izFqFpO+QtT8O3VZ0e4IsXbTW96vzTKOCtMX5d
         PIHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795105922; x=1795710722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=a4ox1t6Gwtr0oP1XRr8WgvKzIydTuZ1Rk95OKxmwQ3M=;
        b=pk4Q3DD6ijGJsHQCzdAMqLqS61C4xC91VOYgY3HScTeaEasc6W+b9N4ZAaoCFzez73
         lIya5AgzGaeJqXv3dCNFvX1CeUPzJqafs20VIs1NMdI3skRQ97DKOZmh6oIU6njDLfE+
         onpRAnE6cr1vlDylbCyqdWMyhAhKRFZt/4Y6hbrfIFatrmbIYm5euemB2bK6Mrqh7OYv
         TMz5w6g+Q90KPEilG0rMaieoWDrzloVFZ3hvpDvi1TcIgaxS6dTu6jcTIlrdsi6FVuvA
         2SMqBa3XJb6AlKo71BL8rO9221AXjteYVcZJ6bjvdV99/x2m+c0Hu52T0Mp9Lv9Lck+K
         5B5w==
X-Forwarded-Encrypted: i=1; AL+hErEUskAZJ0+NdrLSzhUP/c+W7MJK/npz/Zv5uZ2/DsGp36DlpwMASU++gQmCem329ZFbg9OLVa6RcA==@lists.linux.dev
X-Gm-Message-State: APuU4Z9FmYxrblOpuTsdNr4E4vwtZWUs3K1LTyxuxdJjZF5ckjP9OmID
	2ZqwoBYVAeeFIkO+0tLRdOHNy/KuEPOnuw6zAOFfT0SCsuL4upBIBKIf
X-Gm-Gg: AYBFou11AxJ0HsK5Gvx+PpsvVO4k73TNn0oJcy+6nk8l2dweSmzvzOfy5EIasL5AHhu
	f/Az9ZRf0JDPrDh6r+lF4ISuQSSkD++KVLlZFcbttcgEpncuEKMlpra2waK5AiizLNlZ9QUwjJl
	DXz6e4IQ68MG83SQZVZul4MnO+ReAhrmJuA17xrrN14RnHe5eKVh4nFlFESPc1L66ttKmHrqJLX
	56oWbxSbmnsR20aLOIZS09tWzw6y5dSdNs7SIouuErcQEmx43UWKJ/1SVs5iMfzYs0g/eoEa7Lq
	PZwxr/GF/exVNuSedAIA1cU9Qm6xvB63ebAm+RaMYbXJA7XWIUQKCboK9lyoLMm8bPdt4Wkbd6K
	JuUJ5zIalCn3Cjj0jZby5xlR6D5c7x0HHmp+1opgEMjFplELctvGUfTtd+NvGbOzqL+UHo14DiD
	DHgP5L9VVhyGiVj6MGjEr+CV5CQKfcgStUgFNn2/csiz5WBARwj86fnu5qPYEA8H3Io5PJCwpjc
	CgPEiSIbNrVhgPEPDNEjL72DZi4+p4FB5P2E4Oa6hwB/Ql0baCdZd452blHEZ/y8FWnWpS9AnkU
	gemgviAIpQNK/4SmIdr0eQeoaREbYfel8hP33WOZZ0rV+IDvs0mpblEyFnUfFBBu2km/k0lbvx9
	ACBeXqJ8p
X-Received: by 2002:a05:6a00:181d:b0:8a0:23d4:f4e7 with SMTP id d2e1a72fcca58-8c87ce33af7mr159274b3a.38.1795105921384;
        Thu, 19 Nov 2026 08:32:01 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87420be40sm132589b3a.57.2026.11.19.08.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 08:32:00 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: agk@redhat.com,
	bmarzins@redhat.com,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	okozina@redhat.com,
	zkabelac@redhat.com,
	dm-devel@lists.linux.dev
Cc: yangyongpeng@xiaomi.com
Subject: [PATCH v3 4/4] dm-verity: add messages to prefetch and drop the hash cache
Date: Fri, 20 Nov 2026 00:31:12 +0800
Message-ID: <20261119163110.1630269-7-yangyongpeng.storage@gmail.com>
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

Nothing lets a user warm a verity device's cache ahead of the reads
that will need it, or release the memory a device no longer needs.

Add two messages.  prefetch_hash [<start> <count>] starts reading hash
blocks asynchronously; it is not limited by the retain target, which
only applies to eviction.  drop_hash [<start> <count>] drops hash
blocks, keeping those that are in use or dirty.  Together they let
userspace warm the cache when a device is about to be used and release
the memory when it goes cold, instead of occupying it continuously.

prefetch_hash and drop_hash are unsupported on try_verify_in_tasklet
devices (-EOPNOTSUPP), whose bufio client cannot evict or wait for a
buffer that is still being read.

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Assisted-by: LLM
---
v3:
- Split out of the previous message patch; contains only the cache
  lifecycle commands.
- Reject prefetch_hash on try_verify_in_tasklet devices
  (-EOPNOTSUPP), same as drop_hash.
- Accept prefetch_hash/drop_hash with an empty hash area
  (levels == 0) as a no-op instead of failing.
---
 .../admin-guide/device-mapper/verity.rst      |  16 +++
 drivers/md/dm-verity-target.c                 | 115 +++++++++++++++++-
 2 files changed, 129 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/verity.rst b/Documentation/admin-guide/device-mapper/verity.rst
index 1e532c4251ae..ab772fb2d7b6 100644
--- a/Documentation/admin-guide/device-mapper/verity.rst
+++ b/Documentation/admin-guide/device-mapper/verity.rst
@@ -353,6 +353,22 @@ Messages
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
+While the device is suspended, ``prefetch_hash`` reads are queued and
+complete on resume, and ``drop_hash`` finds an empty cache because
+verity resets the bufio client on suspend; both are harmless.
+
 Example
 =======
 Set up a device::
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index bd2368312b05..a4ac8a13e405 100644
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
@@ -1894,6 +1999,12 @@ static int verity_message(struct dm_target *ti, unsigned int argc, char **argv,
 	if (!strcasecmp(argv[0], "retain_bytes"))
 		return verity_retain_bytes(v, argc, argv, result, maxlen);
 
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


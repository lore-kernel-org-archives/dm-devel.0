Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795105910;
	b=jvnK4KWfYeM2VSrVvLggMWrP8OPAUhWO2fsfqmev8mly1rhtECdvcBjmJFIXWXjFY+z6
	 K0csyVjlzwcyrhV7trL/H3E/oJDwwMHcBfKOSKgVy296WICLn+RAqb+bHomNxQ48VWSsk
	 SUY+8OleymDbeGcwGkUdANjZnHY8FJCMzMY3b5Aj1JHzuIS47rogC4s1CEgdx8pLKooiu
	 +didYrsqUx1EPyamBuy3foTG3pNrYBM98v+v1uYzl5Lfkszh0ubXHO2HXAswXJ+GFMbc4
	 TWu86cp3h8pTPgmvo9L/fjLloBedo40PKrdJq/y0uEoPXeN2lXK5I6WKpYDS2lMgxiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795105910;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rpu5Q1Ic5QgKGEDPIcad9niGBMMY47MNAvd8TSg1ZYM=;
	b=PqbaR3ctRTFY2t7bae5qUldshY4u6GaiFNBUX9nFNoCMly6IbaRwWtVtg7GosNvZXUHo
	 MzkeJ+5SYYn8SydoqQbDbQY/TghvrfTHBYde13PKD8Ue3y/bytJ9XG43r87LhzUHgb7Uf
	 1aJRnIy5wfWEbaT2qIr9M4amOGZgk5GD5OFAYltaFgH0pUgyWo/JJEofK6QEePDmv+HbH
	 WMGhtCDhr06LHJsUBX1wQFbKS+YJ3QnVIBJCw08uP8jKlG5MQXlkIpdVedSLPUaW/RiU4
	 kCb0GvDjkHpKncHrPCWtE15MvqdH+34SspHUfpshjTPSeDT1tjfjgmVj61ja2QJPkzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=clDkhswI;
	arc=none smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6798E606A331
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 16:31:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6798E606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=clDkhswI
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8a60f90a924so1204161b3a.3
        for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 08:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795105909; x=1795710709; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rpu5Q1Ic5QgKGEDPIcad9niGBMMY47MNAvd8TSg1ZYM=;
        b=clDkhswI3b2vLwGev9kMN9XlPnrvX/rFZ2ft+OUAjzltViZCVJ4hPhQdNhKSqhWoy3
         Rol/h8MSu+Yso/tOZTY0eBi8mgFHmKO5afN9YRJ5XKFP8xlJa09VQX+ltoLrg+qsBzWx
         KG8U9d5SkfW4aDSZGVgFIO8dl0V6xKnebcKLjWNpvt6adpo6NbNBH1WRHKXaWeMClYCU
         +H6EPd0xZs8mxx9CIEwdeKtrPh9ONcWRhsoHaAClqlMLofEzK53rse7t8h+GfGbS3Ohg
         941N8e2kGcMbnH+U16lgwRZV3dftdL44nTWSm2sqxwrz23XmhB4EcXBLzNXYGw9XTQiC
         ojrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795105909; x=1795710709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Rpu5Q1Ic5QgKGEDPIcad9niGBMMY47MNAvd8TSg1ZYM=;
        b=DNQPyFZl1059Jh4pdTPMccCy9VsdpSY+zQEIDsMUm/ccViMSJUaU36mgehEBTvDCEn
         QMCq/viVhFFBZ4G51fowc5kmBSCnVhtSgRF9EahStEWnemv50W7XrM83GYtYRW4PMxRH
         xAtT7SmAxf6EafstcWg5ZMH8rS6D5QDR33PjEC37vqGJRY0gvk++w6erolg+e6qiNIoV
         Q0SHWtaLmoCEn9Q8fKSuDUf4aboAiZFaMwQ61UNjEl3yrO9T8PF4EJ/MflQVEAYPsVMf
         3KkpE2k9pM2DLZV6DGZ740KTAcrjmhrl5d8DNoUIRcZXuyCUKLKlkna6iMqW+G4aG6sq
         FBIA==
X-Forwarded-Encrypted: i=1; AL+hErHSoDvLiNqidB3V2OY3k1bl5UAXq+0NEYMYlZ5/wOQoUe5x3JcdH16nM0VdGxIiCNNbUmml/gR4qg==@lists.linux.dev
X-Gm-Message-State: APuU4Z8DSwaH6MrEiwbML6sLhwzwFUFC02bLdJjRBkPY6WuoJ1OMgC3v
	vxjZkaa9LszK32gXWxfC+vunuRMvWaito70zbBg9ZZAxS1URFLQqKgC68o4R/dW0
X-Gm-Gg: AYBFou0TWf9Ct0gOt6zQ8Fg8OrgeKvMH62LU2QX4yaGVywTnG3Nrj09LWvmos+sIMSC
	eqzmkLQBf0MtJPmi8nDdMw6mRTWIprgvCTYACJoTlVS5P8qbWkMcUfxNVfkexUF2yw6xUDQbmrg
	htsM4MWqzNWZEh+udW+566trBVlSS9qo5CMT/vOE48LugIzqx+EZJwGeg3PzFrknE1VM59lYMx9
	Rl4iU7nMSEeKh8BMPW6S8SPGvWtmD6gx4tCPSG7oT7HzsiLnRF7nXB3o/MES2BHIgPBNs3kv4Nq
	+RWtwI1Y0aBBckzHkFin8kUmLwERHU8ekAe4RHeDsO4kgn7na0b6RXcbkFxFafppDKQFKqy5Ibn
	4gaHQDsK4W5AYYp8pDmm2FlI0IHZ0X6HNenpum6QBH7Tblz/e+wzhDmjA03WrE9KMhHo/hm5iV/
	5S+olv97xvX/Iob6wl05gHdklJQBMC3ms+P2Y+36vemZ2Hufk//2pghcB+NaeCiEGZZRijGqOuF
	1RpUXkt8UgMjuPA7NAvo2sn4YTWKN9Md6D7taZqAbCmhiLwb9slGswMM7LAgX7sjpILFjr5u6Mk
	mi4Z+CLyG42yiQAdX7Tm6xdJY2kMw7vP3d0vMVuD4yF+Elawn3uU/Mddl24nALgdElG9JvHd6Zg
	g7OvXVwHq
X-Received: by 2002:a05:6a00:a117:b0:8bf:cc92:55c0 with SMTP id d2e1a72fcca58-8c87ca5202dmr141491b3a.37.1795105908500;
        Thu, 19 Nov 2026 08:31:48 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87420be40sm132589b3a.57.2026.11.19.08.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 08:31:48 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: agk@redhat.com,
	bmarzins@redhat.com,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	okozina@redhat.com,
	zkabelac@redhat.com,
	dm-devel@lists.linux.dev
Cc: yangyongpeng@xiaomi.com
Subject: [PATCH v3 1/4] dm-bufio: make the retain target per client
Date: Fri, 20 Nov 2026 00:31:09 +0800
Message-ID: <20261119163110.1630269-4-yangyongpeng.storage@gmail.com>
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

dm_bufio_retain_bytes is a module-wide value shared by every dm-bufio
user, so raising it to keep one device's metadata cached also makes
every small, idle device hold on to memory it does not need.

Give each client its own target, initialized from the module parameter
at creation.  The parameter keeps its meaning as the default for new
clients; clients that already exist are not affected.  Also export a
way to query the retain target and the cached buffer count, so a
target can report its memory use.

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Assisted-by: LLM
---
v3:
- Get rid of sysfs realted code.
v2:
- Round a non-zero target up to a block boundary instead of down, so
  it keeps at least as many bytes as requested.
---
 drivers/md/dm-bufio.c    | 41 +++++++++++++++++++++++++++++++++++++++-
 include/linux/dm-bufio.h |  8 ++++++++
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 3b66cf1cb931..f3abf90793c9 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -994,6 +994,8 @@ struct dm_bufio_client {
 
 	unsigned int minimum_buffers;
 
+	unsigned long retain_bytes;	/* READ_ONCE/WRITE_ONCE, no lock needed */
+
 	sector_t start;
 
 	struct shrinker *shrinker;
@@ -2284,6 +2286,42 @@ void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned int n)
 }
 EXPORT_SYMBOL_GPL(dm_bufio_set_minimum_buffers);
 
+/*
+ * Set the number of bytes this client tries to keep cached; 0 resets it
+ * to the module default.  Non-zero values are rounded up to a block
+ * boundary, so the target keeps at least as many bytes as requested.
+ */
+void dm_bufio_set_retain_bytes(struct dm_bufio_client *c, unsigned long bytes)
+{
+	if (!bytes) {
+		WRITE_ONCE(c->retain_bytes, READ_ONCE(dm_bufio_retain_bytes));
+		return;
+	}
+
+	/* clamp so the round-up below cannot overflow */
+	if (bytes > ULONG_MAX - c->block_size + 1)
+		bytes = ULONG_MAX - c->block_size + 1;
+
+	WRITE_ONCE(c->retain_bytes,
+		   DIV_ROUND_UP(bytes, c->block_size) * c->block_size);
+}
+EXPORT_SYMBOL_GPL(dm_bufio_set_retain_bytes);
+
+unsigned long dm_bufio_get_retain_bytes(struct dm_bufio_client *c)
+{
+	return READ_ONCE(c->retain_bytes);
+}
+EXPORT_SYMBOL_GPL(dm_bufio_get_retain_bytes);
+
+/*
+ * The number of buffers currently cached by this client.
+ */
+unsigned long dm_bufio_get_cached_buffers(struct dm_bufio_client *c)
+{
+	return cache_total(&c->cache);
+}
+EXPORT_SYMBOL_GPL(dm_bufio_get_cached_buffers);
+
 unsigned int dm_bufio_get_block_size(struct dm_bufio_client *c)
 {
 	return c->block_size;
@@ -2389,7 +2427,7 @@ static void drop_buffers(struct dm_bufio_client *c)
 
 static unsigned long get_retain_buffers(struct dm_bufio_client *c)
 {
-	unsigned long retain_bytes = READ_ONCE(dm_bufio_retain_bytes);
+	unsigned long retain_bytes = READ_ONCE(c->retain_bytes);
 
 	if (likely(c->sectors_per_block_bits >= 0))
 		retain_bytes >>= c->sectors_per_block_bits + SECTOR_SHIFT;
@@ -2522,6 +2560,7 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 
 	mutex_init(&c->lock);
 	spin_lock_init(&c->spinlock);
+	c->retain_bytes = READ_ONCE(dm_bufio_retain_bytes);
 	INIT_LIST_HEAD(&c->reserved_buffers);
 	c->need_reserved_buffers = reserved_buffers;
 
diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
index d1503b815a78..f4d86b4b7e0f 100644
--- a/include/linux/dm-bufio.h
+++ b/include/linux/dm-bufio.h
@@ -158,6 +158,14 @@ void dm_bufio_forget_buffers(struct dm_bufio_client *c, sector_t block, sector_t
  */
 void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned int n);
 
+/*
+ * Configure and query the per-client retain target; 0 resets the
+ * module default.
+ */
+void dm_bufio_set_retain_bytes(struct dm_bufio_client *c, unsigned long bytes);
+unsigned long dm_bufio_get_retain_bytes(struct dm_bufio_client *c);
+unsigned long dm_bufio_get_cached_buffers(struct dm_bufio_client *c);
+
 unsigned int dm_bufio_get_block_size(struct dm_bufio_client *c);
 sector_t dm_bufio_get_device_size(struct dm_bufio_client *c);
 struct dm_io_client *dm_bufio_get_dm_io_client(struct dm_bufio_client *c);
-- 
2.43.0


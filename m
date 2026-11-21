Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795281607;
	b=XpEN302zxLg42Lt5fjDqE0y3aAkf62sf71zMmi2TR/ciYTHZcCsAe+dPThwtjLVX0Xkc
	 1jwTdnZnNUeXYsvEpjaXjXVoiBdNoGgDsOX0SkQ4wbY/EhU0BR162wh7HOV3zB8VmeQJ3
	 bXoUPDkI21HSQ2uU4CrCji+ZO77rX3frCBv5VNpW5uXvoE79xESvhSAhqFxXBTsLA+Khf
	 kPZTj5inArzDE4GWXy3Wtp9fwuzvA13QM6p+XlHqBvSsIjO7C3NAdwfXJEKGj5mW/+W5x
	 OE21K/XUfRH3F9p9H/9I9lAr0kKfcDvOUjnGTIpMQMf6DqJ/dWb/Zn/8suGzwelonRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795281607;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o3fmF6+qVamNcSp+6Xy7RoJYcMMDNIJkRq6K+y3sVwY=;
	b=vDfNLsl1+i59FLDp+bfR9DwkfaBYTN1WhLG0/Td3dhAjINjOeQkyzFKjAART33wu3fri
	 GOkmBaBlAEx1v0KcoJc+NO+auMUi+kniBf5VqurAYKa0iGRiyOcl3dTulNdcfdIxQzRfE
	 8blQUcwU9B2dzJNOCQn0sfOJp70dd3t6a0hDe3egQWHZXXP3itcV7ePKWfMKufZJzoAdC
	 Nb4CVC1N2P8xmRxY2fwyxAyec5eRBjL7iJNFTAe5n69N/6AEqQfYfFkbnHV9Vlc+ArRBB
	 m+cfv8vQaP0aQg7tv74pkDxP6xzlKMT1fVC7rcm9P9HfEQXIOGz++3W+w9ykh721JDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=K76F8uDH;
	arc=none smtp.remote-ip=209.85.210.174
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1B2606A320
	for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 17:20:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F1B2606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=K76F8uDH
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8c6c06b3321so1670931b3a.3
        for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 09:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795281607; x=1795886407; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o3fmF6+qVamNcSp+6Xy7RoJYcMMDNIJkRq6K+y3sVwY=;
        b=K76F8uDHGUFp0dnWva7awf/UWf7tW6jKBJTljTu8DKJtQ7g2j992Z+L9BLgjIyxZPK
         +gJ4NXcG8IkiYjg2wlkp1JIZtFjBdQzvNiv8iuSRx0GfJ+5m976Q5h3OnR75jckT8LL6
         lhv+6ssE3gQGvhoHIYQsDiovj19XV/CHA5aekrUD0JmNlXnq00j7Hh/xH+aBnUjA2XNH
         xU2BxaP4eM6sS58ax4PAB7IM4cCkku+im/jlI52QUgRxO0NaZPKV25gQYJ6+4L0DPEku
         Q6hmsDR1CX2kfl6e8D0pMTIL8wvXUzt5jtMoAih5pfKIMgHm1nZLbjwLWeL4ohXHXYqd
         US4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795281607; x=1795886407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=o3fmF6+qVamNcSp+6Xy7RoJYcMMDNIJkRq6K+y3sVwY=;
        b=oFToSCOW6ZGd23vGuoo8pQ44FroXyz70Xus+9JacK013enXAqLRD7HkFui7d32A33E
         YXE+S/Y1nkmrgLy+lKRRAGr4wHseje1qlHd3rhevS11GKgP6Kw3bpjPTFcfLta+dY1N8
         wqUMim+KuJ+EeL6yv6PERVMM8fJGY4coimYZKeGHkFDOcpR7qmeLNoQYoFx3AjaZW5Mu
         33kwAcHR2o8KLfyfulUaaemUz/4etLgeUAYU2QVYR50/A7RRF8NXxbJ1sxHZKjjgUUud
         k/Z3fw+sKxGcSBigT0ltA1KC+nSEwEPE2LHXb2p0OCYRi8VuUxGH1aGGcVWBQFIx1FQA
         rDWg==
X-Forwarded-Encrypted: i=1; AL+hErEHkv5adJ65YHDBuhyXsjXiIei6oDKoKTyEgk9cAKCRLSQWwlI2yTVF1HdBrXPT3Jss8o8TC4twRA==@lists.linux.dev
X-Gm-Message-State: APuU4Z+YoQpo1MIgaspc2ixgykXnGdkmMyewbbs5TxZkJWa6v1SxkTar
	b6BxPsdQMLTkkCu0Py85GoFs6527qo+H8V+WESUR47XNBW2YQHeCjzmr
X-Gm-Gg: AZFdTZcR0er5ipJPF93xTLzY6dlk//k2WGnuf0zQHwDLUsfHIT8vyR1UWrUYbf5+Rcm
	zNLvpiv0xBTMvbMMl5at4emre4BNxgosF1IWXm25OBVYZc+p+pHLvK/fLHSMzHMz/AxNQkhNBV/
	4rVVPSwQjWYkK/lpKoZaMmGOzkcXxrZo5tsEQvo7g/+KrcG/6TFfOM233MJQllBD8io+3k2FO75
	sxCDz6rFLKlgrmLIFyNG2n/Bq3pagLH710JLRrbomMOh/BpBjSLvqumVkju+Iv7jjFO/aZ6XTq6
	uruljtaEjz9sdqlKW2yZqPVG3RmzSW0iKhIi1a4lfPkxgH+bu+K7E/iYfMhWsjn2+MqeLZwNm/T
	lVgRS8v17YIV1L3VJCOw30IsM9iwv6URqkyuDnDGhzgjZEHjIhvRVaVCDfAufk/kap66KSmRWRO
	PilVXZG4ee+X4yPrDtUFPZ4xLVPr+Ult0lvc1MBpz7S6g/quWRgye5cVn+s9IVuRleLymRFS1VZ
	24I5VAmAWEhZDzk7P5l/K0egOZIgoipJjjjNtBFnjEGt1y7qEL4LP5o98YdTde31WSFoOGB45z7
	xW06QK52OhpXkqcFn8JPJrhr3O3mdZN16MoCgzF92aUGKRho8oHT6Mzi72+XEnadf1EaraxEGc3
	n+LVZAI7c
X-Received: by 2002:a05:6a20:9f86:b0:3eb:39fd:bacc with SMTP id adf61e73a8af0-4014d360ed8mr6595566637.50.1795281606555;
        Sat, 21 Nov 2026 09:20:06 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d028a54sm2585657a12.18.2026.11.21.09.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 09:20:05 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: agk@redhat.com,
	bmarzins@redhat.com,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	okozina@redhat.com,
	zkabelac@redhat.com,
	dm-devel@lists.linux.dev
Cc: yangyongpeng@xiaomi.com
Subject: [PATCH v5 2/5] dm-bufio: make the retain target per client
Date: Sun, 22 Nov 2026 01:19:32 +0800
Message-ID: <20261121171934.3847617-4-yangyongpeng.storage@gmail.com>
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
- Round a non-zero target up to a block boundary instead of down, so
  it keeps at least as many bytes as requested (Benjamin Marzinski).
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


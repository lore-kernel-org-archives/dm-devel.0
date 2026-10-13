Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2630455294D
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 20:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791924924; cv=none; b=WdhC4X0LYLZCPGbqVNOCQRFNlq21R5/bann5EV6Z59FvrtLa1tufvAeoPCKJcG7QFrtYdksddKsDpX+WZMCwGkdI7Hn5mgqlKsdr2vGKOLfQJy8kZnhaXPpTp71/MuipsMh6DPur2BlyR3jV3+p0qXc9UNOb64m2JtRuKgTECs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791924924; c=relaxed/simple;
	bh=r0p2adqwMj/5lT7C+TYVmZHcVYZ+gdU2HSJ4o7+sSAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMQldlWlqpjuEIT9r3PNPG9FVtWaVmjtCUJf3QDw+KYTPdfJ8Fps9hp1Cz+5Yjib1bUFuOA1jpbZqAfmGH51jD/7APs+FaLbd2oD3lsb8Y4IcUGesjIu1kFpTvuHtcOtwkcK3nuIvwrK8HlQSc5odNTh/zpy/Qxf4kspIA+VN/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y1aegcnO; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y1aegcnO"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a16c399641so34061135e9.2
        for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 13:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791924916; x=1792529716; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u2SC7dcI1Y+PPMkABrALMaBjWk253olXayI/6F0cq90=;
        b=Y1aegcnO949RIlRX8d3vbvxD/k5f2KoRGk6Dw7fb6Q56DjnuMuNIk7V+1z5oIZd+6Z
         KI0qYPgqRuZeRJcrDyFIMKdptWhNlrOYMJjT3mVq7FJvy+hQqr8g+h5yumyR9c62TXXO
         sbsFJSHDqAs2oO3irST8jQzgGN4AQF73mNYIvrAQxMarBqs3Gxj/jV3UiiZ+6YxaSWEb
         /rUuPYe+qbyhjYdVVymox7c0YKPGQkoywFCbjRy+KLB1SYOUFhskpjVNFXbIYkh8l53o
         eCjxx66RG2i8Ww0eUusqzG8tIe1/WJI4PZyfN/f1Gfqf1bhnC9LbrXSRs3eAIz5kvL8h
         9pUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791924916; x=1792529716;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=u2SC7dcI1Y+PPMkABrALMaBjWk253olXayI/6F0cq90=;
        b=AGnaoG6nq37no44k5Zk4TqU7DsUvxHZw3VfJOf4i/1oZo5Q79Ier9DMwyM9QvRt5t8
         qQZInE/gGS2KhBGK99FZ7XPcDQCbTdxFRGXngLkWC/9FsyVgm48WByLLk/MC+d4zbeOd
         1pTs+bGstOgfwOnxitqsNFkwVnfVSa2dPD9jUkAx9sK98d1AnkLxXj+/2CPxxW6YRneO
         SzD2zgSyjqTC0YFjTeNKAbKoK1TVt9YzFtt5lPK9+i9tLsPsbfZXXWnrKQ9gN0/Mo2gd
         dqg3GCwuW1p00l7ZzjhU2urTAEtsY+7uJm6AbePIvIRwpNzMBJFTLwPc9Al09DwGW+Kd
         9Fsg==
X-Forwarded-Encrypted: i=1; AKwUvBy92NSylaGNsmEkKCvvo6aRrBcjL0hTyBTxLaPimN1AKQ0YZTpbd0zfqX7p09JdMLTkcvmfJNHReA==@lists.linux.dev
X-Gm-Message-State: AFq9FYJ4qoCicnZfCjFI6xP7hLJVihsOXLiIU7y0nLH/PSJ+KBzwLn3t
	ja2wIobn5jdDbsSGVjHUG4u0/kYl3CblpvlVJKy3SUKPxnq1wJhhduFn
X-Gm-Gg: AYBFou1XxfZFff0K0Swm+chI9NJIPTJCok+hl8+xnjc9GvoJ0T2FfH9UUs0r5RuiXf3
	DLqnWgrze9rGneJ+85i+44jiDW4OkWY0gFWjPlY36UcUUadWztllqJsQsmi4PBXmqKevHKrD0rA
	DG1wc4jPaZJ5zCh8t8/HEcibo3CRG0zAHfJ1ejMueUMmmqZw6R94OCHJuWrRxo5jG8hz7H/2zff
	ffopPncbdTOKG4PSoiJDTZawEiIttIPHek17mCR8+1nhuXrayzJ7++uNL/1KLUoFDUWrTQ847xf
	4fJpqezw1BkXbEFVbkB1C5+B9inFE7jHg1ReM1wwv63ukpfaSvUQeB2njiEsg/BU0nQAO5Z8caM
	WyTObZBG3SlIp1nXB1M0n0pN60MpM+Zq06E6JjTxWe4zxQGEerW3Slw1Lo0GEoRcXeF2NofOEbD
	sLhI2AEZBH9+oNqOJ1LpGb/vD9XCgZZM4+i8j56zXa29wblrTUu42YVVDqfMs8/QpGCditji4b8
	7rycmQ1w0nwMiycXPh8zWyCH3+INCmDo8wB+gbE72+LSlUOQ7DKR0VFtfWpB79la2N6dYAuW6xH
X-Received: by 2002:a05:600c:1553:b0:49f:e8bf:8f9b with SMTP id 5b1f17b1804b1-4a18e443ea6mr263806405e9.4.1791924916136;
        Tue, 13 Oct 2026 13:55:16 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de7273a0esm2380730f8f.29.2026.10.13.13.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 13:55:13 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: linux-block@vger.kernel.org
Cc: asml.silence@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v10 02/13] iov_iter: add iterator type for dmabuf maps
Date: Tue, 13 Oct 2026 21:54:46 +0100
Message-ID: <20b8e9c900c7656e43e039a0d97213a2a781ba4f.1791924581.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1791924581.git.asml.silence@gmail.com>
References: <cover.1791924581.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a new iterator type for dmabuf maps. The map in an opaque
object with internals and format specific to the subsystem / driver, and
only it can use that subsystem / driver for issuing IO. The task of the
middle layers is to pass the map / iterator further down, maybe doing
basic splitting and length checking. The iterator can only be used by
operations of the file the associated map was created for.

Suggested-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/iov_iter.h |  2 ++
 include/linux/uio.h      | 11 +++++++++++
 lib/iov_iter.c           | 29 +++++++++++++++++++++++------
 3 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/include/linux/iov_iter.h b/include/linux/iov_iter.h
index f9a17fbbd398..2f91884d733b 100644
--- a/include/linux/iov_iter.h
+++ b/include/linux/iov_iter.h
@@ -310,6 +310,8 @@ size_t iterate_and_advance2(struct iov_iter *iter, size_t len, void *priv,
 		return iterate_folioq(iter, len, priv, priv2, step);
 	if (iov_iter_is_xarray(iter))
 		return iterate_xarray(iter, len, priv, priv2, step);
+	if (WARN_ON_ONCE(iov_iter_is_dmabuf_map(iter)))
+		return 0;
 	return iterate_discard(iter, len, priv, priv2, step);
 }
 
diff --git a/include/linux/uio.h b/include/linux/uio.h
index fe2e985d74d2..638c1116e912 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -12,6 +12,7 @@
 
 struct page;
 struct folio_queue;
+struct dma_buf_io_map;
 
 typedef unsigned int __bitwise iov_iter_extraction_t;
 
@@ -29,6 +30,7 @@ enum iter_type {
 	ITER_FOLIOQ,
 	ITER_XARRAY,
 	ITER_DISCARD,
+	ITER_DMABUF_MAP,
 };
 
 #define ITER_SOURCE	1	// == WRITE
@@ -71,6 +73,7 @@ struct iov_iter {
 				const struct folio_queue *folioq;
 				struct xarray *xarray;
 				void __user *ubuf;
+				struct dma_buf_io_map *dmabuf_map;
 			};
 			size_t count;
 		};
@@ -155,6 +158,11 @@ static inline bool iov_iter_is_xarray(const struct iov_iter *i)
 	return iov_iter_type(i) == ITER_XARRAY;
 }
 
+static inline bool iov_iter_is_dmabuf_map(const struct iov_iter *i)
+{
+	return iov_iter_type(i) == ITER_DMABUF_MAP;
+}
+
 static inline unsigned char iov_iter_rw(const struct iov_iter *i)
 {
 	return i->data_source ? WRITE : READ;
@@ -300,6 +308,9 @@ void iov_iter_folio_queue(struct iov_iter *i, unsigned int direction,
 			  unsigned int first_slot, unsigned int offset, size_t count);
 void iov_iter_xarray(struct iov_iter *i, unsigned int direction, struct xarray *xarray,
 		     loff_t start, size_t count);
+void iov_iter_dmabuf_map(struct iov_iter *i, unsigned int direction,
+			struct dma_buf_io_map *map,
+			loff_t off, size_t count);
 ssize_t iov_iter_get_pages2(struct iov_iter *i, struct page **pages,
 			size_t maxsize, unsigned maxpages, size_t *start);
 ssize_t iov_iter_get_pages_alloc2(struct iov_iter *i, struct page ***pages,
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 2072c04e99d0..6831a5d9396e 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -575,7 +575,8 @@ void iov_iter_advance(struct iov_iter *i, size_t size)
 {
 	if (unlikely(i->count < size))
 		size = i->count;
-	if (likely(iter_is_ubuf(i)) || unlikely(iov_iter_is_xarray(i))) {
+	if (likely(iter_is_ubuf(i)) || unlikely(iov_iter_is_xarray(i)) ||
+	    unlikely(iov_iter_is_dmabuf_map(i))) {
 		i->iov_offset += size;
 		i->count -= size;
 	} else if (likely(iter_is_iovec(i) || iov_iter_is_kvec(i))) {
@@ -631,7 +632,8 @@ void iov_iter_revert(struct iov_iter *i, size_t unroll)
 		return;
 	}
 	unroll -= i->iov_offset;
-	if (iov_iter_is_xarray(i) || iter_is_ubuf(i)) {
+	if (iov_iter_is_xarray(i) || iter_is_ubuf(i) ||
+	    iov_iter_is_dmabuf_map(i)) {
 		BUG(); /* We should never go beyond the start of the specified
 			* range since we might then be straying into pages that
 			* aren't pinned.
@@ -775,6 +777,20 @@ void iov_iter_xarray(struct iov_iter *i, unsigned int direction,
 }
 EXPORT_SYMBOL(iov_iter_xarray);
 
+void iov_iter_dmabuf_map(struct iov_iter *i, unsigned int direction,
+			 struct dma_buf_io_map *map,
+			 loff_t off, size_t count)
+{
+	WARN_ON(direction & ~(READ | WRITE));
+	*i = (struct iov_iter){
+		.iter_type = ITER_DMABUF_MAP,
+		.data_source = direction,
+		.dmabuf_map = map,
+		.count = count,
+		.iov_offset = off,
+	};
+}
+
 /**
  * iov_iter_discard - Initialise an I/O iterator that discards data
  * @i: The iterator to initialise.
@@ -856,7 +872,7 @@ unsigned long iov_iter_alignment(const struct iov_iter *i)
 		return iov_iter_alignment_bvec(i);
 
 	/* With both xarray and folioq types, we're dealing with whole folios. */
-	if (iov_iter_is_folioq(i))
+	if (iov_iter_is_folioq(i) || iov_iter_is_dmabuf_map(i))
 		return i->iov_offset | i->count;
 	if (iov_iter_is_xarray(i))
 		return (i->xarray_start + i->iov_offset) | i->count;
@@ -872,7 +888,7 @@ unsigned long iov_iter_gap_alignment(const struct iov_iter *i)
 	size_t size = i->count;
 	unsigned k;
 
-	if (iter_is_ubuf(i))
+	if (iter_is_ubuf(i) || iov_iter_is_dmabuf_map(i))
 		return 0;
 
 	if (WARN_ON(!iter_is_iovec(i)))
@@ -1469,11 +1485,12 @@ EXPORT_SYMBOL_GPL(import_ubuf);
 void iov_iter_restore(struct iov_iter *i, struct iov_iter_state *state)
 {
 	if (WARN_ON_ONCE(!iov_iter_is_bvec(i) && !iter_is_iovec(i) &&
-			 !iter_is_ubuf(i)) && !iov_iter_is_kvec(i))
+			 !iter_is_ubuf(i) && !iov_iter_is_kvec(i) &&
+			 !iov_iter_is_dmabuf_map(i)))
 		return;
 	i->iov_offset = state->iov_offset;
 	i->count = state->count;
-	if (iter_is_ubuf(i))
+	if (iter_is_ubuf(i) || iov_iter_is_dmabuf_map(i))
 		return;
 	/*
 	 * For the *vec iters, nr_segs + iov is constant - if we increment
-- 
2.54.0


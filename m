Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3094A0911
	for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 13:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789997971; cv=none; b=PQpP918fqq+UBMfDKyQ4ptBXgKrdtJrXNgtI7QYos3VsdoOQf49/Yi28Gy0YL5ANDGgmuJe2eK7Y/vxtjkJK1tL6OeBUPiIapw2j6nB/aXoK4CqZvWB+I11CSFgtkTNlWKm+j9QsMFwRnJCwEuIY++npqxAnQ3unvH/dbk6rIZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789997971; c=relaxed/simple;
	bh=9vQH2FkifwfjUkmpno2ejJJq+JJRqKfmbGSl7/camvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhLzL3wZLzt75zxufXAEshSPHueQ/zeMk/Kt41NqrF9rHFek1RZZFd2kk2BtC+5oXr6BGLHmXl5TwVM3bcNnQtT0Sw/H18XhfAova8WS2mOBXJ0VhQ4s5eHZfkv/NZ+UEPzeh8CJBelqipSjfvNoBcPDRclH9sWFE4KbYI4bR6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z8UaZuZg; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z8UaZuZg"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e79a408deso16962745e9.2
        for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 06:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789997967; x=1790602767; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lhfYmNfKHeufPvJ/pLV04jPXJys5SvK0KBUyCDM0noo=;
        b=Z8UaZuZgpbNfnUkGqMP+ai0WUGHMtn+A5nrCgSTePZWA/Xk17u0rtLcreU9cQ7afqn
         Tkw0rKaSD2qoxhV0kNlIRtJaimpDGDjYBPFKY5NgP0CNWhgvueVnaHQtydkN7GqSwS2H
         c7lbvhVvzk9YjQp5FL7Q8NQRSXMQmHJtPPdvkwa8+pmGqOtUguet+cSiXWD4qxnZV+4+
         sNNwKBWEMCNbWlMVaJkUXe4TekRNoukAdwWQgX1Kvuj7kSwOczfH7FzUeqB8l3FYCs9u
         b635eLOQr0qUrmY9jnrW+5x09e9MoZ2AogAgYn12wDc1VEHmcRzO/zzqj7HlnVxukOo9
         uizw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789997967; x=1790602767;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lhfYmNfKHeufPvJ/pLV04jPXJys5SvK0KBUyCDM0noo=;
        b=HKQ2GR8ZmsX1wztZmvfLIwUuLF74RdmI8S58mD+uKlzeIXlbV5gAoa9ZKONNFioVAx
         uKhlR99j+B9pU5BNkYnOILGN2I3tQomBeC9Ui4s/6uEcsjI+8WzIQYBcvibBTRlEULJi
         d5nLyzfhEXQNtev+qiOOAuTzAw0azl6XyQAsoF+y7+JaBr2HqWG81PCxAojjuiEPeDeZ
         Eu3HwJJoX1MPtG96wR9VTZzhcl8Fd4GXVWiGYLf4OxeIO8DmRtoA9Rmv1v7JiLz+LwI9
         U4du7RWECAZxulIItv6n+6PuPfYousz+/OYKO+2neMv0OqN/Poug/4BMevCk9k9PkHr2
         VJPw==
X-Forwarded-Encrypted: i=1; AKwUvBx62oqTgM92Cfgjl39oAf4kquu0Ssm5Q5dV1F3pMdN7pBQ/ImrB4Egem7bNapO4eBiulWMcwJOtAQ==@lists.linux.dev
X-Gm-Message-State: AFuF++kg8RHYy/b1c0hvgNIAQAIU2GdPDkgTeoK9bJfYqVDSFtlF8RLE
	THePD/wMxFR8HCE7tULJQQ3UtLUjL+V5EjuDzd5alSrt/wbtdt0Cgsi6
X-Gm-Gg: AYBFou09dIg7WMvHtwtFeRCNRuN8WzhkYb4uCwyQ1ItrWd+E3+rQmVjeoXc+bwKjFbk
	F4dgo49kI06dKmvYkekgvLcqwU06m/UugDupLfIoehOdL0oh0eljAm6OCkA+g23NyT3WpaVzOvF
	V7Uvt2aLNLxwGjXQ2kdloQFLP6HRHlBCQSzPpQDFPIDb+GZfN2Dt0pZCRmBoM8kQcptIQyLUJHm
	29xZN1y+0ywZd/9uJfVyBfG8F+wqb1RZVxGMZGTVkwLfGE3yTF1iKqs+ZNSJOBubURswZFjxph4
	l+pRUthrKXtviVDZ/0sSy8ZjYqZoFwC1fDoBKTgnJMsPEObQ1qm9RPQaM1a8gs0QaSDKJ07IPe7
	eF3leDGi2Hn8msJ470NL7oZZsMQKGzzfbTpDZGapyw0ayfMKWAG+eb3GO97uuQ4ThV3dUHV8Dpv
	la6xHQTr01HgK79QtO2Qka037GXx5jPqF9Y3wvqCv9kVzJk7PKCVqCtWvlVsH2mqvFrceX9N1EC
	IddiafXm/HDAbEGl1irymyC7jykQoTm4gJiVwPiCXMUpyxsbXmafHc4Y+NHPaoeRvutPU6remdT
	0ujv7gJ7p5NNErMxO+sBbCIEKk0VSw==
X-Received: by 2002:a05:600c:19cb:b0:49e:8184:f619 with SMTP id 5b1f17b1804b1-49fc57410f2mr151435725e9.22.1789997966776;
        Mon, 21 Sep 2026 06:39:26 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-213-26.dab.02.net. [82.132.213.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fc585920fsm617171605e9.4.2026.09.21.06.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 06:39:26 -0700 (PDT)
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
	Phil Cayton <phil.cayton@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v6 02/13] iov_iter: add iterator type for dmabuf maps
Date: Mon, 21 Sep 2026 14:38:46 +0100
Message-ID: <6b78003332b57ec3a4552d7393464636793aff76.1789997898.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1789997898.git.asml.silence@gmail.com>
References: <cover.1789997898.git.asml.silence@gmail.com>
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
 include/linux/uio.h | 11 +++++++++++
 lib/iov_iter.c      | 29 +++++++++++++++++++++++------
 2 files changed, 34 insertions(+), 6 deletions(-)

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


Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116C04756DB
	for <dm-devel@lists.linux.dev>; Tue, 28 Jul 2026 21:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785274190; cv=none; b=r1bv3PZdUTCc8/avt7o3DLzdEweQXHuZRkZI3u41jr9SfhagRVZXspptKmiOycMZvPx87iTZpReHkCwl/oPuK8PGvm+FGXxB1tjhQ7bGKnyxRupiVdYl7NwjgiI9LQNNPuWG20tNemWXPogRZFQd5q1k+98dfAr9hSHUGV3Jvm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785274190; c=relaxed/simple;
	bh=7Cx4C9dxI3ZjGFKQyK7oa4f12dQmgpPqsHOYLKXis2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ypuo7ddNlBG3twRxz+93ZsPna6OxomiQ6GOiO0vizvGRxOtKeF3/60W/3by0hF3/6rwDqL0Pr75iPQ4be3HV0crGKsXiRc11rI5i8rep8Cfbmcx0KhmvU1Ti8sxSXXescbcaaFh6RngNQOBACAyvJCNFWIWvVx2Mh2eGj0I47Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EoLADRyX; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EoLADRyX"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47f752b3423so189976f8f.3
        for <dm-devel@lists.linux.dev>; Tue, 28 Jul 2026 14:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785274186; x=1785878986; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Uu/V2cY9fiEPZWKdFNoipI3xUZZg8n/4RaaqV8GEYhU=;
        b=EoLADRyX51ofnSxTVBoMvNaik4Ol/zJp+Hy9VJvgQNnvrixJlt78WPotlYLlKl6SFG
         DzhGeUeT9I0DqZHkVq4bW5AZCuYT0dAGtAzn84d/Q6F4Nsg/Yacz+tqePhajr0RfdgKk
         6+SpllXzZgf8fiJv7VQiNL7Qejt5H+L6uqWWhbc/Ar0nLY4ZIMBXjpfJRDvLookzZ6z4
         Q1jYOTm9/pgx8bMcjBmgdh87qs7MF3zXEaz2duG5e2/T1iJVVkO39iwsseUiJuONasQT
         rhkiDvT9M71n7vv5788jdRyPmfmbyO5tJVaHSbW7z7sY5TrJtyi6gM/llxEwUr6D+1PQ
         Z/HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785274186; x=1785878986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Uu/V2cY9fiEPZWKdFNoipI3xUZZg8n/4RaaqV8GEYhU=;
        b=bd9WXjvF7XPcbAUxEX8SOVs7U71ZG67FXAKGEa3VF8GBJ/1roSG4XKHJ7Jh7qE+fl9
         G1YcoEaViuFgmr/ZMKqkkYkbcepPgqQHibM8CNzDUMv8/yj6MeF6Od0oncL7pclVEoJs
         iKbPhakqWUn/FmOGbq8J9ECslJ7BGaEqS+sWQ/QN+Lsso9a1YlWh9NLrFp5MHHelU+Ra
         0cqWnTKKdvfInuQ+C9Zq3cSXUoQDuj+8xFaKf/C3d9gQFdW4Sm0qK0feKu9bgjFUz7CU
         Ged144OkaAmrA0e3592OzxDGt9P+rjzq45MhirsrSf1NQ8DPttzlGSiL9c8ibISNXQUD
         IpUg==
X-Forwarded-Encrypted: i=1; AHgh+RoDDhlKDV8KztN389Pi+0eRKououCq+B4t4qBATZLTnyWfk6UxC42j+u+sxx0//vnu8FQTBX9TQhQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyFgM2z+WNO+gXRbm0gIIBQ3kHdTMi2z1Gwq1QXFBH/0D/La73E
	jSnO0unv8ycyITi9uzB0k5KFjF61q8Ig1VSSsIW0Hnnbntfp18NleQWa
X-Gm-Gg: AR+sD135HddfQqmSZ6nYN5aLR5fwM9Ic5Tlfn3paqv7+zC6GNq4q7cZy2W2IdsxPz/M
	jjIA0pkpH8Cc5i1K0lqsE734ZjXFpNIXmYn1yEQQm8VkzzuubInZS2LTgPaKRL7QQsihJkAGkCI
	0fYaoh5/LGv3luQnIfO1pOegPs05ml+fDXXk5m1o44KmQaLEMOfUiuwzO2TFarUAcK0ZdL4wbVg
	zZBfO3Cynw6H7by5D730QTaD3oqKALjNxbbmJsN6mBqx+H3NGj+YBgm4VQpQDc6r9GVZp+oenS6
	NSV1BST5deeDwQLXi6lqvCa4lXcbaPr9NbQ+BPqe8hX+UPSVXw8WVE6+rnReBoxvoz8MO8kxf12
	cNB+61Rx3+ILS7bkOECSr9zDuqqm3i7foo5KF8hqaV2w6GFmBs9dxIsyXnFTYt79ygc1XFmulWa
	z6NFnghNjbEkiyQBqOKHbQbpkS/RpIVZHlpZFjpUXTJ31BU8POM1huwLEOryvJgNEii9w73L2yk
	iM6OF1PJNjypncaZTc=
X-Received: by 2002:a5d:584c:0:b0:47f:95ce:6f48 with SMTP id ffacd0b85a97d-47fb1ec9671mr5039007f8f.11.1785274186132;
        Tue, 28 Jul 2026 14:29:46 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6ac44bcsm2245329f8f.11.2026.07.28.14.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 14:29:45 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Cc: asml.silence@gmail.com,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	David Sterba <dsterba@suse.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	dm-devel@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
Subject: [PATCH v4 02/14] iov_iter: add iterator type for dmabuf maps
Date: Tue, 28 Jul 2026 22:29:14 +0100
Message-ID: <132442812a40277a5904cb2a8ca1e02f4f6e82a2.1785274111.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785274111.git.asml.silence@gmail.com>
References: <cover.1785274111.git.asml.silence@gmail.com>
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
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/uio.h | 11 +++++++++++
 lib/iov_iter.c      | 29 +++++++++++++++++++++++------
 2 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index a9bc5b3067e3..6c31ec131a71 100644
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
index 273919b16161..6398b306d0e2 100644
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
@@ -841,7 +857,7 @@ static unsigned long iov_iter_alignment_bvec(const struct iov_iter *i)
 
 unsigned long iov_iter_alignment(const struct iov_iter *i)
 {
-	if (likely(iter_is_ubuf(i))) {
+	if (likely(iter_is_ubuf(i)) || iov_iter_is_dmabuf_map(i)) {
 		size_t size = i->count;
 		if (size)
 			return ((unsigned long)i->ubuf + i->iov_offset) | size;
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


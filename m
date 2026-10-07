Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F0035C687
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 01:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791337412; cv=none; b=kWXVg4h+tMFTQ+E516+WVhggJhcWy3MVNqk1/Sm3CJCd4hJ7p3/GLxXZL9ZmXNE4pEGm8HkjNTjbhdhbKf17iuVPr36Z2F/6U/Hg9yrLlHLAmy/+J7wrHjl/pxT6tLIuQP38BBfMDHNmredlK8v9OgFAxHYaz10DmYu3HyQJpN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791337412; c=relaxed/simple;
	bh=3Fg4fgarhp43AXGD3uCEPBH0DKGK1BrLFUwZDank6PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHwvoAEXUPlEzlnGi5EXTWwYhRibJ/2cA9U9MeoQv232kce055WvJHcE4EX1HyY1tWSdiu/5s8sjMxfj1lTSxL2RTmVKM4IzkQEteMmlQEf7q2PRx+2UYCDfnmYJQUC713G6xZ0VHZHYy0fFmlHJ9VBirncyVxoPHqkDFVTpf+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yeytnvx6; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yeytnvx6"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a16bc2278aso9552015e9.1
        for <dm-devel@lists.linux.dev>; Tue, 06 Oct 2026 18:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791337405; x=1791942205; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TBD7LAGhjErBgJ6Wm5F1SHztZSPVsK9gsGPfOw+QBug=;
        b=Yeytnvx6qEEYcn8Kd5STU4BzFsEfFPbfk0YTACOZ0wU1YDzHtP1cjmL8TzAyB3RCKa
         ZqVCNzu7AbG/1u94i+KZrMP/6QL08Yak/jeCraiUthuspMYPDbaUroLJUgz4olAXpgAs
         t2e+IA0mwheDjDxpiJKKGNjlgzzFvQIgMr8env9eL8hX0AHxmdvcVl8OdE/fy+mgImOv
         TinrqAPc9ibKIYac/PssPcs8iYkSb0LKkTXxnOWNmWLaK+ZucZs/abtTDPUs4m6BGuL/
         wGqNjbl1iJu9A93xbkE3iQWQ8u0yEJ3XwdSaLLh9B8cbZ3R2oKwUoNvY1XVH6x/BlOsz
         mdUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791337405; x=1791942205;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TBD7LAGhjErBgJ6Wm5F1SHztZSPVsK9gsGPfOw+QBug=;
        b=mK868tPwnhWYH1+2Ylo/BETw+HUeXzDaTgR7p+txt7nuUSnQNvDZCdXlGt7bF+i9U8
         i1K6A7LTk0XPp2zn9hGfEPwhqN27ZfEW7XaswGAfCarui3t38N0RnVxPdVfSt6k+UMiI
         KjpLGMr+sV7Igm+fkJ2hzU7AwKEpL/OMUXhMZed85oxv7tK/7L9Qkso88C3taiWTtQXO
         TCoj8P13ST8ZXLP+5cM4AYSYpjfatNnoIa/YBRE3ZqMv1i2ytbctzjz+2tjG2eOvLjY0
         q9wRBE/BIPYhXFmMbhLqk8FnkPzStgffMd5Onwj5W5goc8Pei3I5Tgaieto4sWFunsHC
         iMbw==
X-Forwarded-Encrypted: i=1; AKwUvBz6/KxA1UPLnymc/syMYh5iZDFVWaCIOV9nbq2XvxGowKhoMFUEWcUkVDeE76fXBK+uuUb/gYQlNQ==@lists.linux.dev
X-Gm-Message-State: AFuF++l6waj5rWqzhAdHlAwHVzfcikJnRyjPUWPJhH0/KeKrIX80rO5M
	kfcPDcDfJdevPvIP1XWxDaJFRLIfgz7k3SnB7N+6a5JMj4kImBTnsId8
X-Gm-Gg: AYBFou2jAg1pJAt/9tjzpLeYfQp/92VOq4J6QC6H2vOjfKYqIppZ4zqOXzwBQDIbGsT
	LtMyrrsGcV9orjgMwWVfbx9+ZZNH7RUqdaSNU/tzbdYQ40pFYgIORKkCDE81wgYUD6yzKpVj44g
	qzb94ylRGiCAt6WqoYEeEes3YYgEy2dlLylrgtxlAH0f4I6AnEjYVFL0H5+DtT97or+Rk38t+iW
	W949I3CX8WSUo3FvZ1R8VwCMnTuc543n/bOX34VXPruYL3NmT7RlfZaxfL05+ikyNhzybeZVEMt
	d8oBxWuIH/hr1xMgIHM/WHiElLSPdd29OwsjP7qyhbczIPvGLtZwGxIxN21/bOOSp8y45i/XGmX
	2du30MNyqXciVG8jNmV78kIM2UWV4qV3t6oa63DUdAeC0ZT+mN4wgYhR539puKnxWTpIwN6kVo6
	k/oIbfRgd2yhb8KiNTKl/neWCQ6lKVbKv1TZ/8UbS8aLbiLylslksQIhZxzszk+cwvtTlnHpBpC
	BPAolN4F7rmptZJ2zhZWcYI9Tb97UPhzzjs78BwipI3vc/SVOxwygSKhOwuxfJYpYdWlp0edw6X
X-Received: by 2002:a05:600c:3e16:b0:49d:2536:402e with SMTP id 5b1f17b1804b1-4a1806649afmr7712265e9.30.1791337405094;
        Tue, 06 Oct 2026 18:43:25 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a17f653d7csm26423895e9.14.2026.10.06.18.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 18:43:23 -0700 (PDT)
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
Subject: [PATCH v9 09/13] io_uring/rsrc: introduce buf registration structure
Date: Wed,  7 Oct 2026 02:42:52 +0100
Message-ID: <82a5ed8b6de7015b9ec3c6aac51ec2597749a1df.1791336930.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1791336930.git.asml.silence@gmail.com>
References: <cover.1791336930.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation to following changes, instead of passing an iovec for
buffer registration introduce a new structure. It'll be moved to uapi
later, but for now it's initialised early from a user provided iovec.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 47 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 1efaf29514e8..7e58e9d96055 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -27,8 +27,13 @@ struct io_rsrc_update {
 	u32				offset;
 };
 
+struct io_uring_regbuf_desc {
+	__u64 uaddr;
+	__u64 size;
+};
+
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
-						   struct iovec *iov);
+						   struct io_uring_regbuf_desc *desc);
 
 static int hpage_acct_ref(struct io_ring_ctx *ctx, struct page *hpage,
 			  bool *acct_new)
@@ -81,6 +86,15 @@ static bool hpage_acct_unref(struct io_ring_ctx *ctx, struct page *hpage)
 
 #define IO_CACHED_BVECS_SEGS	32
 
+static void io_iov_to_regbuf_desc(const struct iovec *iov,
+				  struct io_uring_regbuf_desc *desc)
+{
+	*desc = (struct io_uring_regbuf_desc) {
+		.uaddr = (u64)(uintptr_t)iov->iov_base,
+		.size = iov->iov_len,
+	};
+}
+
 int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
 {
 	unsigned long page_limit, cur_pages, new_pages;
@@ -398,6 +412,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		return -EINVAL;
 
 	for (done = 0; done < nr_args; done++) {
+		struct io_uring_regbuf_desc desc;
 		struct io_rsrc_node *node;
 		u64 tag = 0;
 
@@ -411,7 +426,9 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 			err = -EFAULT;
 			break;
 		}
-		node = io_sqe_buffer_register(ctx, iov);
+
+		io_iov_to_regbuf_desc(iov, &desc);
+		node = io_sqe_buffer_register(ctx, &desc);
 		if (IS_ERR(node)) {
 			err = PTR_ERR(node);
 			break;
@@ -870,26 +887,26 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 }
 
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
-						   struct iovec *iov)
+						   struct io_uring_regbuf_desc *desc)
 {
+	unsigned long uaddr = (unsigned long)desc->uaddr;
+	size_t size = desc->size;
 	struct io_mapped_ubuf *imu = NULL;
 	struct page **pages = NULL;
 	struct io_rsrc_node *node;
 	unsigned long off;
-	size_t size;
 	int ret, nr_pages, i;
 	struct io_imu_folio_data data;
 	bool coalesced = false;
 
-	if (!iov->iov_base) {
-		if (iov->iov_len)
+	if (!uaddr) {
+		if (size)
 			return ERR_PTR(-EFAULT);
 		/* remove the buffer without installing a new one */
 		return NULL;
 	}
 
-	ret = io_validate_user_buf_range((unsigned long)iov->iov_base,
-					 iov->iov_len);
+	ret = io_validate_user_buf_range(uaddr, size);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -898,8 +915,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 		return ERR_PTR(-ENOMEM);
 
 	ret = -ENOMEM;
-	pages = io_pin_pages((unsigned long) iov->iov_base, iov->iov_len,
-				&nr_pages);
+	pages = io_pin_pages(uaddr, size, &nr_pages);
 	if (IS_ERR(pages)) {
 		ret = PTR_ERR(pages);
 		pages = NULL;
@@ -921,10 +937,9 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	if (ret)
 		goto done;
 
-	size = iov->iov_len;
 	/* store original address for later verification */
-	imu->ubuf = (unsigned long) iov->iov_base;
-	imu->len = iov->iov_len;
+	imu->ubuf = uaddr;
+	imu->len = size;
 	imu->folio_shift = PAGE_SHIFT;
 	imu->release = io_release_ubuf;
 	imu->priv = imu;
@@ -934,7 +949,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 		imu->folio_shift = data.folio_shift;
 	refcount_set(&imu->refs, 1);
 
-	off = (unsigned long)iov->iov_base & ~PAGE_MASK;
+	off = uaddr & ~PAGE_MASK;
 	if (coalesced)
 		off += data.first_folio_page_idx << PAGE_SHIFT;
 
@@ -986,6 +1001,7 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		memset(iov, 0, sizeof(*iov));
 
 	for (i = 0; i < nr_args; i++) {
+		struct io_uring_regbuf_desc desc;
 		struct io_rsrc_node *node;
 		u64 tag = 0;
 
@@ -1009,7 +1025,8 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			}
 		}
 
-		node = io_sqe_buffer_register(ctx, iov);
+		io_iov_to_regbuf_desc(iov, &desc);
+		node = io_sqe_buffer_register(ctx, &desc);
 		if (IS_ERR(node)) {
 			ret = PTR_ERR(node);
 			break;
-- 
2.54.0


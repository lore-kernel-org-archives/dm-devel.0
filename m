Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B566B4F6484
	for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 11:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791975758; cv=none; b=jKPysY+oNNftsbsG+LeNPIRJF5gqO2C59+x3Fdmq4LiK2pG6iTooKjtTLupc0d4C2e9MtX8vyNPOmXyLB1Pw5CIlDgTfC1kYTILCWAJ2TdoAlCzRfPo23/v0+pGg3zVeR2lLngdgwoOaCGuILes/buKIvz9NDufbRVHtPJYErZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791975758; c=relaxed/simple;
	bh=poMU3IMk+s1i+OL6PspfjWv+5wjZjdnLVtCEDY3Hn+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LM78IAa/1LYpDQfZx+D2NdM8XuC1RNzNeeOceX1v8sv1Z3AJnrwIeJuWv4iTkB0lhGidCuFBujq0ceQ19k10NhN8yQa9mNU5bPUeQ9rDZ6gmgsm/s+CMsHI+kP3TuUpzhG93N4OC/O7Fy9LEyCnGq2MQgCLE+zp6JYHeVybdTYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h/7JVdUn; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h/7JVdUn"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a16aaf2067so10596175e9.0
        for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 04:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791975748; x=1792580548; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sjQY12JZJkEEoHUMGZ5pLsy3Pmh4yJs101KM8nm2S/U=;
        b=h/7JVdUnpFXo+uaitFD3OPryFXwBxRx8CrjXKkTjA4rlEcsRecxwEQBHDowPCFfuRU
         cwS26RPwIuGq3Mhgzmh0oDANXmHh+Q8P/1UxnDuNyVcDfcUmS1rGb3bb9+Tj2AttZssX
         rVSWMdmzbSkT2OjpMmOE+phPWko1tP4Ol17aJB9cAOow8tdOCwOjgXJRKO22YmFfl25j
         d+nkwFQhPDD5BeadELe9ncvCMpI0Ds5AhluO0E1ah2ThkNi3HjZh7QspZ+0apxKuGjIZ
         r7sDcMz/aJgSN923KIsv3jCd4V8BKcOVdvbg4NhouHy1Kdwn9p4tHGAuc9asccWUCoN9
         3R0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791975748; x=1792580548;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sjQY12JZJkEEoHUMGZ5pLsy3Pmh4yJs101KM8nm2S/U=;
        b=dMCOy9F51l45hiO6djoXWKskzCzsjUDpVZWSjFmYwNHeJdfL2uFYLRCmx3uHS6APR8
         OsZR/pU31QacQcLAFhGwzF6hJQyzk7aml9CgvIqKkl3vj4ujSMPC/B+0TdhqiH640kY3
         6ZKDzwUWxH3IrIbc6wnrzYXo6EOKEXWyhj5g8JXdnIRjF4+opTqraJ8oWaMMZ4gkr4Dp
         womFVs/EMnXnmotLY0/ZuqPI+0sUzR7/XGPK/4roRg0nR5pnGwoqjisPke9nF/yfagvh
         dJ/D/sGuSkuN+MM5lPF+hp037SS7DhwpbpqBKmnXMZK5ID7VxrOwTRxF82dzF/zkOpBG
         KnxQ==
X-Forwarded-Encrypted: i=1; AKwUvByEFq6fKMigRU45KgYHgev3E75QB6JnWPHX1OSTdkLsRTyY02rKn3UtUdSwikI/GSLXKcJ4EyDu5A==@lists.linux.dev
X-Gm-Message-State: AFq9FYJSInD/L/332RB6hXzpU6PfvtY4h9HW/n41WfhGKDVO3M77//oY
	cHNcB8hsYZ26hYYRko5t5skHTmEBXBix71rQv6mQmDg1QO5jEDjjuRlK
X-Gm-Gg: AYBFou3RVuy2fn8nz96mo7E9P1Xraplr/UV2WqN3EltRdtZv7Zytm8jSCqSoJwSXGpD
	SakA1dgrf91LKuXLbse7qwmugJIB6hpM+u0g501D1EZUmE+c5v9culL0uqn57G9rMgOCMdyWS92
	c+/kCfAH+cx820tqkpTqW+fLABwC9oK2NxmYfe5xBQZJI1ZpjrLjLAswdiajFEGqAmQL7ylUe5O
	zI/b2a8JtWVV2TR8UXTkMChe8c6jjR+LJY8fzGu9D+euhMkkOiGoBAg4k347C4h8SgxSCGkvfVr
	HfWJnwpDwAaXJS8LhTY9uHmn6SNX+6h+IpGA9iz266D7BM6rIg96ySbpWWi9rv7ntKYAPMr9h+G
	GOO0S4WOz9o9jIoMcYJhYnbqEHNcrvxcmeitm2MSGoDTCGYqjf5H0k+18YEUFXhQ4L1vqUbDb++
	l9U7qIOf+X3Ca+LKSsVY66UFDMXjEtMfTYy1Ri+ygiyoSo+g9fJDIt7okLJ5k1giSe45uCJlAWE
	tN8waZWUvrmTTP3tZLmaGgsgl7V0fC/oUxz0zynYJyJ/Yvs5faDCyVnUelzbQYOqDUipsP/baMm
X-Received: by 2002:a05:600c:8716:b0:4a1:62b8:9aa1 with SMTP id 5b1f17b1804b1-4a18e44885dmr316691205e9.2.1791975747413;
        Wed, 14 Oct 2026 04:02:27 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1b45eb78csm38078845e9.2.2026.10.14.04.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 04:02:26 -0700 (PDT)
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
Subject: [PATCH v11 05/13] block: add dma-buf support for raw bdev
Date: Wed, 14 Oct 2026 12:02:03 +0100
Message-ID: <c01c4709dc55a12fb0f2fe1ec847b5f1f0c92789.1791975048.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1791975048.git.asml.silence@gmail.com>
References: <cover.1791975048.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a simple proxy implementation of init_dma_buf_io_ctx() forwarding
the call to a new struct block_device_operations operation. Also reject
dma-buf backed iterators for buffered IO.

Reviewed-by: Christoph Hellwig <hch@lst.de>
[pavel: reject dma-buf without O_DIRECT]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/fops.c           | 24 ++++++++++++++++++++++++
 include/linux/blkdev.h |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/block/fops.c b/block/fops.c
index 827dc9eecba7..6c6700df943c 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -730,6 +730,9 @@ blkdev_direct_write(struct kiocb *iocb, struct iov_iter *from)
 
 static ssize_t blkdev_buffered_write(struct kiocb *iocb, struct iov_iter *from)
 {
+	if (unlikely(iov_iter_is_dmabuf_map(from)))
+		return -EOPNOTSUPP;
+
 	return iomap_file_buffered_write(iocb, from, &blkdev_iomap_ops, NULL,
 			NULL);
 }
@@ -855,6 +858,11 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		if (ret < 0 || !count)
 			goto reexpand;
 	}
+	if (unlikely(iov_iter_is_dmabuf_map(to))) {
+		if (!ret)
+			ret = -EOPNOTSUPP;
+		goto reexpand;
+	}
 
 	/*
 	 * Take i_rwsem and invalidate_lock to avoid racing with set_blocksize
@@ -958,6 +966,21 @@ static int blkdev_mmap_prepare(struct vm_area_desc *desc)
 	return generic_file_mmap_prepare(desc);
 }
 
+static int blkdev_init_dma_buf_io_ctx(struct file *file,
+				      struct dma_buf_io_ctx *ctx)
+{
+	struct block_device *bdev = file_bdev(file);
+	struct gendisk *disk = bdev->bd_disk;
+
+	if (!(file->f_flags & O_DIRECT))
+		return -EINVAL;
+	if (!disk->fops->init_dma_buf_io_ctx)
+		return -EOPNOTSUPP;
+	if (bdev_has_integrity_csum(bdev))
+		return -EOPNOTSUPP;
+	return disk->fops->init_dma_buf_io_ctx(bdev, ctx);
+}
+
 const struct file_operations def_blk_fops = {
 	.open		= blkdev_open,
 	.release	= blkdev_release,
@@ -976,6 +999,7 @@ const struct file_operations def_blk_fops = {
 	.fallocate	= blkdev_fallocate,
 	.uring_cmd	= blkdev_uring_cmd,
 	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
+	.init_dma_buf_io_ctx = blkdev_init_dma_buf_io_ctx,
 };
 
 static __init int blkdev_init(void)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d003a9d2d1f6..2d5c30823aab 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1599,6 +1599,8 @@ struct block_device_operations {
 	/* returns the length of the identifier or a negative errno: */
 	int (*get_unique_id)(struct gendisk *disk, u8 id[16],
 			enum blk_unique_id id_type);
+	int (*init_dma_buf_io_ctx)(struct block_device *,
+				   struct dma_buf_io_ctx *);
 	struct module *owner;
 	const struct pr_ops *pr_ops;
 
-- 
2.54.0


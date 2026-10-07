Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC1A34EF05
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 01:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791336741; cv=none; b=WnJ2dYvTTxIsuNLwfTndTJT2mnwc4vlU+opgaSPvEUDF5lX3rhrXXIF6opWYRYwKH6GtRGPe/d/XJTrXZ7OJLMCmuRNMwjyn8uhqxgMnfGgj37FUUSicIseBz+Vzj9cFxGpUG8Dogn1eAEOD2z4erJ/AwUJ5j09be1lqUs9xmVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791336741; c=relaxed/simple;
	bh=L6TVWpongEDpA7TiLe+SNULpjIEu9UzpPIkgkHUo5Rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyoEJMUDZy1y4hTkbSZE+veKOtR8/9Z9DEZjN1fbHqB0VWoVz3wksm5e83e3P0WjDDFKOrMJlx+ngvyYQLhlgd2YrNngB4lD3COsfCU95yyaLKTVzN0D9BCaJvuVfXcbRMjwOvrOUcLJzQC63Z/Eo5h4xiD+Sv6QY0ARhiV0kko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lU/I1SgX; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lU/I1SgX"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a02718da81so10886605e9.1
        for <dm-devel@lists.linux.dev>; Tue, 06 Oct 2026 18:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791336737; x=1791941537; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nls4uSWUi3FtYOHw3kmfxrWIUNA1MBsyApDbzhyJZsE=;
        b=lU/I1SgX1XBybpQbeesmzqxdTWbViyFn1bj+oKMYlyuMmHkFKZup3nnRpQoGwp07xe
         2Nn24EOPaXDnlHyTFy0AXSOkbQcQbHa9FwCHQbDcuEzCCXpKAOpV+Oq1e2e99+CvqwDv
         fC84bkl3ueZHbEOOd4cDTMrU/HUZWd5zDBQboIjXfyjJmMu6odJx9jdLbVQ/jA6Llf0i
         4TIo6G7m+pJOtdcDO8q1+CXAp/zLZOF79M9Q9SiJqOl+VYhT7KTdVvhMOXVCxCyuMQR2
         X0dE0Vo2u3tBoFhvztAyduOV/BzJ6OU+D89rB3oZgah2pHfrRfHtZMi+WE6zLRClnEuY
         UyFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791336737; x=1791941537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Nls4uSWUi3FtYOHw3kmfxrWIUNA1MBsyApDbzhyJZsE=;
        b=rjfdC9AaWxL56L9W6zhUy4r2ztJs+zVBxbzE2niozLXdgc/e0B0TlGh+5nhtuhmVNE
         guUuDO5bOtvkZVf1bVcaxNrb9AL8YQHXGhb6klzTkf9wUGj9mcwMqX3kgmHY0PmV1FPB
         ex1WEvc67HJ+Lr2En971XzexPRPt6jgXVn4LXSwOsGhqkIAqxBXSRK13YCJfOc8Snmts
         RyHCsgvsQ6SsHCF3CZ1b5Z1f2UVhBQ94E3Nowes/OKEtf54sCtU3QPfLpSiHrQB123Go
         6GmPAg3aiEeX47tpAVIp07hY5GMoV7cD1LrmaECFlv+9Hf1DOYbQI7EfSANuZA4tRTzw
         dbLw==
X-Forwarded-Encrypted: i=1; AKwUvBx/E+k2Ix1dbj+RlfPYg6f1I8FVK/BwoEuxzAphIHWBeCSsNNoeVXcsqkJIKoY3JoU7Sonwa4ewAQ==@lists.linux.dev
X-Gm-Message-State: AFuF++kERT7ep31NQncUVoxpSABiy1AFEMY7fI3rcPMyoDkjjXtxlZFM
	givhldgB6Vypjxo3hmPN/pw4RW+TghMNRrMVA5sQeAW9t/ajuuyrT186
X-Gm-Gg: AYBFou1JSlp+uelRBwXYVu3obwKzny3DaJ3mX853xavjF9Et2DObNuxOwMj7uBNgy91
	7EikaTO6gSERChDO+hCe55PnS8Ggr1cTlHtzpT2x7m9vTmZbZkWpubXfhoBCwggucZUk//Sr6mb
	yv5AE/ShwsTTALriA+/A98Qf0j71S0PvkOxlmPXveIs48geSRFAvqErvVJ6HZMB3/MG5V7cLB7n
	tNmrOnbF4YHNCw4WbhA+BCuGL3RX/9ASd24Htd1N0XZZ3CLt7FMfpbLEZN2pzLe/VKKdQCypYDs
	lFV9E6+Dk47tA0GdSIYOS0w66SKB+pVabF88SlozU6bWGSgo0REGn/EsO07V6KdpFyFTzD+rhPM
	ojCKjc9srrx80YXckXE/DQ142OHiImeyPqxMIxzXfU5tHlxYLE74Q/LGppgXKDYIb5lVlASRKIZ
	qVWZaXPOGY09nZqQSmO+BWMpaA3HDi73w3C0lnrsR0/9S6IddFz6XoSFg1GlyA9n5TWHlTQW4pr
	9MrocnDi7oNwqXH3NNWPGpeFA9AY+8wrIbKam5gwpgUJz4qq0vGsN7SwpSi/EHXXQoJFBpOKVYJ
X-Received: by 2002:a05:600c:820a:b0:49f:f9d1:e618 with SMTP id 5b1f17b1804b1-4a180311281mr8069355e9.17.1791336737511;
        Tue, 06 Oct 2026 18:32:17 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a17f6538b7sm21183615e9.13.2026.10.06.18.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 18:32:16 -0700 (PDT)
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
Subject: [PATCH v8 03/13] block: add dma-buf support for raw bdev
Date: Wed,  7 Oct 2026 02:31:46 +0100
Message-ID: <af2b48a490186edf38f1d4a5dfd9513574f7a350.1791336002.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1791336002.git.asml.silence@gmail.com>
References: <cover.1791336002.git.asml.silence@gmail.com>
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
 block/fops.c           | 22 ++++++++++++++++++++++
 include/linux/blkdev.h |  2 ++
 2 files changed, 24 insertions(+)

diff --git a/block/fops.c b/block/fops.c
index 827dc9eecba7..e9da48ab73be 100644
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
@@ -958,6 +966,19 @@ static int blkdev_mmap_prepare(struct vm_area_desc *desc)
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
+	return disk->fops->init_dma_buf_io_ctx(bdev, ctx);
+}
+
 const struct file_operations def_blk_fops = {
 	.open		= blkdev_open,
 	.release	= blkdev_release,
@@ -976,6 +997,7 @@ const struct file_operations def_blk_fops = {
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


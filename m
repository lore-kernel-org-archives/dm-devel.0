Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4B047A0DB
	for <dm-devel@lists.linux.dev>; Tue, 28 Jul 2026 21:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785274201; cv=none; b=JmqmiaP19VevlGXwoOicHkYXwlI1/Orxn3tNT8rIl4UOOsUIeric4+3XcQIaVNlCPeqg9neK+1ij9izpuwGUJFAnsjbzgt9cTHkvVpz2A5SMCGxP+r+aI+64ARGVfy93X/PiSUXqwXGIK/G1ojYdAVhJ3CHMmcT5BQ0D2GO2xmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785274201; c=relaxed/simple;
	bh=XDQjNbbhKar8uY0avv/kD/aMx3Th5Bc2yUeUMO7wAXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9WnGd5XuSfComc12VMIVmHmNiV9XL5q4Wq5TUv6MZjnx5k648ZFU5DbzCojij7zSd4taZvi3uHG3/awrZeyYRnCH1JlJuRr2l+HsB9Wgaqf6WIUxPm6cZeq1xgsBI5T3QGnX67p2So6b9qZXDtjKHx7NZXHerOIgxQrxiqr1II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fnt5riJK; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fnt5riJK"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-471eeac43bfso265620f8f.3
        for <dm-devel@lists.linux.dev>; Tue, 28 Jul 2026 14:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785274196; x=1785878996; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zGURBnMw6fzU2CZK+DQfnrMi2Ya0rXE6R9ZmtmaHTkk=;
        b=Fnt5riJKSgNjJ4bA7zETUN7hJIKoKOC1dKqJ88g8P+4TbLIYF2/DxcjXFNiQNJzHOf
         XQ993g+U06F2P2dmjY0sPWpDUg+KuDhC6Yr19KkQfl4AU7W2mVQZATA9EvQ4ItESkPQz
         f9lLS1F0xIEmsvtMfyTzww66N0tcSCsRjLPeQ87OpX2TGJo43EZFj2cz6tAsJTNjsdRC
         tWwAZ6xEIfXDV1X/IoTx84Eqqi8LXXboitd6YaRK0foWmWP9GiL/egcc0ajkN+rU4sI2
         /hOUzMN36BLyPtOJw3hsQH0PlclIE02CjVKpMMyMAZlkerJb4Kte2h9kXAPzcL8+xTR/
         8IoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785274196; x=1785878996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zGURBnMw6fzU2CZK+DQfnrMi2Ya0rXE6R9ZmtmaHTkk=;
        b=GPJCm76/PSmfZ7Z3Eu1HwHVRrFSNa2K2LtiKrMudGiUjfNw8cp0nxTX+8llXfazc8G
         CokWJTcuYzecb63jA0V607dsqkZQaquq3cF5b/BiCRxphdOtikklv3bYhd1Hm0iqGC9n
         KrRUlyaNszWGLvV11097i6VeDsWjyaBfct/PHGPYKvQIi7IK0QtOLvsBESlu9OkN5GbM
         BrQ9HlGtYiJchUdTe01ZixCc+Q4zQ7SWs50XqDNW4ZIQtjXtLg5TiRLt7jJQ3+DtIade
         DEoEbasYkMtIlDICeCXiNYDV5Dgd4jVbZE26DNZskmUbejYlxZaq9UlERI3QlmNdVn2r
         yKhw==
X-Forwarded-Encrypted: i=1; AHgh+Rp05OzSquCjt28ixHsWUdRae6MNLOM9W9Fn2rIkRrXQkslBNjfgtZHzEi+4JcU6sTEjQa1c0EnLpg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxS+5IjjVd3nzDr/9l48Dv2lAG8m2mQ3d0/B3aSPhvR15YFsWrG
	RKw7sNZhlFXE5q2ALU/Uk1UtnY1Gbcd9/qghs/DSiN55cXZmIS9V0/T+
X-Gm-Gg: AR+sD13x4YTI5cCcbupQPa9g8ZqdUpbbjAWQJT4az44m4JTBf8i7SUFXZ0zUiGdVDAn
	uKk20MzH9B47m2c7336M/D9ceOojbP92of25FF1xzZqbBefn7NV8EpbD1KL/8fP1F3Uy+zC6pUB
	w0fsP8ovw83DJZQ5XHmZ435WOtvU4/Jzfx4y+Ku1N5gXU/w5+21+R4W14w53rAM/yVB2c1Urjhl
	cJqpI87yTgVVUIvI0PeygC9cFHiJU9Ap81kqslxGMzZnXsUfbDIO8YgQHWt8Gf+lZRotxxIOkG7
	fdLzn/Tt+26q3VH4mIDqVgnwiTkGPD1UltdJzu+2PgYb83+YTW68Iqnsuy47ijVwdrXgNvvVNk1
	fIcEZyH3CV+6N18irZL3u/UcwyYpRk6s+zR+/iFc8H/GfTlLICyVQ6PdNsQo/8TSVh9bI7aeMh9
	r7387JgbKC23LkcvBppHy2BaJkx9TXVum71IFCrpB0foQgzgZm7Cu/M/lKFFfnFi1/CT5Szwk/L
	1wVx26T
X-Received: by 2002:a5d:5d09:0:b0:47f:94a8:d6db with SMTP id ffacd0b85a97d-47fb1f14a61mr4656094f8f.34.1785274196213;
        Tue, 28 Jul 2026 14:29:56 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6ac44bcsm2245329f8f.11.2026.07.28.14.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 14:29:54 -0700 (PDT)
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
Subject: [PATCH v4 07/14] block: forward init_dma_buf_io_ctx to drivers
Date: Tue, 28 Jul 2026 22:29:19 +0100
Message-ID: <e0cc82a15419ba7b38eb0bb00ae34cf3d0c3a938.1785274111.git.asml.silence@gmail.com>
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

Add a simple proxy implementation of init_dma_buf_io_ctx() forwarding
the call to a new struct block_device_operations operation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/fops.c           | 14 ++++++++++++++
 include/linux/blkdev.h |  2 ++
 2 files changed, 16 insertions(+)

diff --git a/block/fops.c b/block/fops.c
index 37d491f45015..d83cdbab65a6 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -926,6 +926,19 @@ static int blkdev_mmap_prepare(struct vm_area_desc *desc)
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
+		return -EINVAL;
+	return disk->fops->init_dma_buf_io_ctx(bdev, ctx);
+}
+
 const struct file_operations def_blk_fops = {
 	.open		= blkdev_open,
 	.release	= blkdev_release,
@@ -944,6 +957,7 @@ const struct file_operations def_blk_fops = {
 	.fallocate	= blkdev_fallocate,
 	.uring_cmd	= blkdev_uring_cmd,
 	.fop_flags	= FOP_BUFFER_RASYNC,
+	.init_dma_buf_io_ctx = blkdev_init_dma_buf_io_ctx,
 };
 
 static __init int blkdev_init(void)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9213a5716f95..9f4c92e51dc9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1682,6 +1682,8 @@ struct block_device_operations {
 	/* returns the length of the identifier or a negative errno: */
 	int (*get_unique_id)(struct gendisk *disk, u8 id[16],
 			enum blk_unique_id id_type);
+	int (*init_dma_buf_io_ctx)(struct block_device *,
+				   struct dma_buf_io_ctx *);
 	struct module *owner;
 	const struct pr_ops *pr_ops;
 
-- 
2.54.0


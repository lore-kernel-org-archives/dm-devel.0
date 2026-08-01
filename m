Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC37525771
	for <dm-devel@lists.linux.dev>; Sat,  1 Aug 2026 15:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785599383; cv=none; b=WAiH5PBAQ7+xrCEcirG3cFUE3U/6iAXIoH8UquqA4k75YFzL4TXu1oDzZNRBEWhgmoM5ihcnKAmLEB7oZ/pjTaQ55/tehXUNwezJr34MaBe5k47X8vUJNeEXzy0McXMAdFK4UZu1FTc25v/TyR3/vC4w77BBU8BuFPw1gBFUxL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785599383; c=relaxed/simple;
	bh=g0r+cM2oJU8p0aW6ejF1reDF155X4adWxCLLoLHu2uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDeiCOIfXbuxJi9Uz5Pa1kuKX7cXLfME4VjaRPYnu32mQNGXnH/Ko3e5VWBz9eGq+LDTzQUtKE6C/vp7Rmbm3l08EC6jnuiqzGVTLJouI5yqPqE8z1gOpNrS6CLjJi4sVuhmObdELQsID6QtTJbvlEM1n91pItWs7hYSr++5e+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=stDDuVVP; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="stDDuVVP"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d049069377so14209185ad.0
        for <dm-devel@lists.linux.dev>; Sat, 01 Aug 2026 08:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785599381; x=1786204181; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XTGwQGVc0bqlcGV09Qbia8ah/Xj1ofLPkaifBOkmHiQ=;
        b=stDDuVVPlSk3XTqqq7SRYMSbxX9eOS94G8E93IEAYFcnxDwzG48zdhJvmy3zzYw97u
         vx0GuRTwT142G8BXVdEca7eB0P2KtTOmnvGQRmyHAUDPrBW9TsUbMS1TRoMv0ixUdB8D
         DfKOMd7+oVdkgEm0SYmCOF7YbIyKuLBOpW0d9SfnmOP69gjBjoyCNPlPQd4h1z42iV/y
         fx9F0yiZwSmeUuKNCMmjvCQrBNpSjfEVkyC9su3EJMjyx6qYIBGyDXP+58BQ7aCzgl1j
         J+Rkm+8tzPm8mdLPWD9hbJFzHjLi/HufjfqzGgEIIOU9JWjpRpYdL+naFuIYjBZIaXsM
         2DvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785599381; x=1786204181;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XTGwQGVc0bqlcGV09Qbia8ah/Xj1ofLPkaifBOkmHiQ=;
        b=T4Nc2AHPKQLqLYP4B3+ag16BWysnJ1h1rGE8xTyeojaeSfi1qzon2oFWvMVcKALGe2
         +0ypx1mg91ySXlWa4+ocwcJBk13o6FHPElza2uh9Ekj5ww4YHAy/5v4woXMNVpWXHjDd
         /uC4NHjloyZjr9RdMq+26eJWBd1JgfrbtqKw9v5AFc+mpzXBcH40HiafpeVHGWOiB7Tk
         Vz9NqOMQQ9vwq+V++QBT4PaKzXsKpbfjj6+Mp8SiwFTOQ5Yk4EmWyVKQyO4DmFfRCRLv
         wkk1kxegWUr8IaY3J4rySrmdq5vkTKAkc7ZmgEGfzK5KMXX3AMIE6zYw4aO04RICELX0
         iqXg==
X-Forwarded-Encrypted: i=1; AHgh+RpcxAzjsdQ0k5YeWO4F145XRf7eVszBPiYuVFTwUkbf9RVlcK6B9OLcgTivpZKmo6QefpUGKh6hBQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxlAoRvmH0wJ29PAQXn9paq8Cr3InCS2HeIWeTRRpzQZ5rnZaKZ
	wTIokjA1HuwKMTGbM5aZsf2KDGc/XwgogA6Vm+2yGH1EdE5oxGHyOLZO
X-Gm-Gg: AR+sD11I3XVB0LuhU5XXTbAEYg4pXzhZtcjafK8NTwQoGsmt0mZlFWZbTtzJ0ssazBW
	quZTTPqnjqCagmtH3fgHSAC64Z0V/v6rm/KGOvIilX3LEWuBqEQJNssmUHxDPQtB3kEO6eTKZGb
	HURVMGsBgJieeVVWnC3RfBRGOGzYDhkDUtIRh6hJ8jArIfoLq9X8uzX9O4kwtkTTn0eut6QpQU6
	27Rb+fWRzK5LimGXHnSyHEKdwpyb6DWR9wR5KMa0ryqD//9GfAl32AgZPB/mFpUN7g1+usBiR1f
	OYCKy8iLwJP2mmwz8Ollf5if9PXFCZq9Q62Rx6ABSPHgaOxP8lf0iWXl0a3j9xNvq80IhmrxTF7
	KN55FKJ+p/DCqrWMJjAAGTkH30eMhVD4tUcZHtXZuY0AtU1jo9NhhuDlywCEJ588zePz0XJQUqO
	iZbbMXwypQ0f890FEdVyXtzJNLK8qyLf1J0NCkPsdCTJhRWglw8dmM+nAw8U+anJaw66gJJPQh7
	qVITmKvPI+UFuHa0PTkujhFU0DQKth3yYmMZiln53SGsqU=
X-Received: by 2002:a17:903:2450:b0:2cf:9347:f445 with SMTP id d9443c01a7336-2d05219f5c9mr36286255ad.10.1785599381195;
        Sat, 01 Aug 2026 08:49:41 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:61d0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b12202bsm18287605ad.66.2026.08.01.08.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 08:49:40 -0700 (PDT)
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
Subject: [PATCH v5 08/16] block: add dma-buf support for raw bdev
Date: Sat,  1 Aug 2026 16:46:20 +0100
Message-ID: <b32dd786296e1683378c9e037e2b9f26ec24fee8.1785596451.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785596451.git.asml.silence@gmail.com>
References: <cover.1785596451.git.asml.silence@gmail.com>
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
 block/fops.c           | 19 +++++++++++++++++++
 include/linux/blkdev.h |  2 ++
 2 files changed, 21 insertions(+)

diff --git a/block/fops.c b/block/fops.c
index 56bbacf6e317..3c403afb0f64 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -767,6 +767,9 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			ret = direct_write_fallback(iocb, from, ret,
 					blkdev_buffered_write(iocb, from));
 	} else {
+		if (unlikely(iov_iter_is_dmabuf_map(from)))
+			return -EOPNOTSUPP;
+
 		/*
 		 * Take i_rwsem and invalidate_lock to avoid racing with
 		 * set_blocksize changing i_blkbits/folio order and punching
@@ -821,6 +824,8 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		if (ret < 0 || !count)
 			goto reexpand;
 	}
+	if (unlikely(iov_iter_is_dmabuf_map(to)))
+		return -EOPNOTSUPP;
 
 	/*
 	 * Take i_rwsem and invalidate_lock to avoid racing with set_blocksize
@@ -924,6 +929,19 @@ static int blkdev_mmap_prepare(struct vm_area_desc *desc)
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
@@ -942,6 +960,7 @@ const struct file_operations def_blk_fops = {
 	.fallocate	= blkdev_fallocate,
 	.uring_cmd	= blkdev_uring_cmd,
 	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
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


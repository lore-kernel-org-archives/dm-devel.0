Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5F14CC60E
	for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 13:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790602377; cv=none; b=D8xyjCRnvT1mwxwFu8uE0o3wrOVzOCvxfYe3BdlsxVIvmxgHbgXQkINNvtE+L5RTktg4Aty7eqSZlSON2Qv9FAoQfHPOGSP9x1QqRqU96/oIx3u97C2VnNLMgQsDmsRAiisxa01pbXTAv3Bcm0R0Q0JiF7cRBQQ2biPHNyYvffM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790602377; c=relaxed/simple;
	bh=s/pMlWhML39X7WPnWJGpXvJM/zWMeJLTmEHcD+dWxB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRNxE3c0XzbdA12OtSrEECFXrgGo9MJMrY2mmN3lj17ascXm8KMbqDYL266DJP5uTZURf5tFdZ1D+3kDKbrPr8ZfIp8/rW5Y1A4zvPfUJv5baWW2VxAt0vga0PW6X+gn8MlfhQu5lr3PyLllhX8oFajon3yREw8AhOqqS80nlJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JbX4UTSu; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JbX4UTSu"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485984ebf5cso2436921f8f.0
        for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 06:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790602372; x=1791207172; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zNN8LK2yF6e2Er4Otjr5e2ZaUKzvWbebPH7D4oJybmc=;
        b=JbX4UTSuWOkU60HyZRxDE9NK/j/V7Imx70dQh+i+7SjjWuCJuFKHZ9/h5HDbgvg81B
         6Y3eyy3TwR5CWAcmfxMYU9+nau19SmrI9xAC+uJI/FDz0DrcMudCAdF+4nnktChX1h6T
         MZ0OXMkD6fyOghtt5nWTXC4QRA+qAJkJ4ax9Sv29mdzoPDollViNwESrfqHdFbZVr1B7
         fl+6F3H15BKRhOlHY85eiDK3cugP+xUm+fMJ8/b01eZNO5+L3yrHmw2R/bhGHXl1nBCh
         qUXdiHiVURQjHr2gZ3zjLEzdpUQtaCiYsQK4VyBDmbBPfJYDm+VbEKimb9yS63Nsn+ln
         JNSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790602372; x=1791207172;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zNN8LK2yF6e2Er4Otjr5e2ZaUKzvWbebPH7D4oJybmc=;
        b=wBS6c0YHyzZFUOmVZ3f1zucaRBN3YrhSINJtSMHRE5SMnealc6LFmeBBY0LK5ti60V
         biyRb2SwkLzBymtgboivD9nFzPHkfsvCYcCya17NJhQ5LbBz+ex6sbu/ehB6cJa3LGAD
         CdWgeUv3miTM55y6mMzGgQfpu6b5Z420ZepTyJXkx+Qj9NKRgw5rh7Cm3NBqKNF2EN+2
         9CB52VwrEI/P33lLXFMAzcX2s2QcLHplJBcge33iZ9zdiaXmUQFGgefSOVbt88hfRJwA
         Q/oafMht8mkDEQr6wZBDjL6WCj1/n88es4y1MIViL1fjViMONh1LC/FIdV57kEZ1SOt4
         LKBg==
X-Forwarded-Encrypted: i=1; AKwUvBx5RgJZWltw0IxbSOZHSHAgYoxb2HnBNq6hI+IJD4A4w5Y3BbCXXzEPhl6XjHlAV8UdBx8gDC//ww==@lists.linux.dev
X-Gm-Message-State: AFq9FYLMlsJv9Y936E0FouDXRA/2EKzGeEEkVw/I9nNQqHisEURCCri/
	775oNn3CmS7IjWb+W37WVTps/JQ2YSnWIP2B5wuXT+OZ7wdA9uTyHZAP
X-Gm-Gg: AYBFou3skDncJlEIYxJq5PrJcg78h5v7YrMUfdEeUnpc9/j8qP2EB4CTgEjsNR+JXJZ
	MWgigCvRB461KkIv0qEwfEfBOrXvhvBjeN6SrvgYMLmIMOv54PE7Wz0pZQGaNT2soA4ibitZv9C
	g/DTRInP8lmLs/p9aeCHyG6UAVT5S1xSwUfhUe+1VT7f69gNIeEGCOgaYG2WutWEJiUnzGXsxNP
	9gM0mlqfyeTcJ4N+TlMIV47FD0dSbg37pl3o1hf97iQXdD0OSXUJScZNIF2RQKFhAxLNcC5M638
	ofjyZowXqrQaRc9FLnI+nBdWeGAwrwzd4Sxsa85Ha1CskPE7pdlam9lPna3cnmGBemiX/EtTsic
	6NkzCZDH6mcJxTkKI/jET0AYXR5+I2LiPACZnJqNQFxEGcq972kNoYrMcoGAbAMyJe+EvSKgbGi
	RX0e/OQOTtjBIkb4IX2cH8OWJkhfZtnxVWgJrI6VEWHxQIMipgxelys8WDaGIjWHgGiZte/2wU1
	r+6VTaOux16oMiCjNfr6zQkvaRocEedKdsN0HtQmhxoSDZG7Pb0dtuZsOIrJyScwmAYAd3eeO5/
X-Received: by 2002:a05:6000:4911:b0:486:f99f:8236 with SMTP id ffacd0b85a97d-48872ac74e0mr24072487f8f.44.1790602371877;
        Mon, 28 Sep 2026 06:32:51 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a349731sm28090164f8f.12.2026.09.28.06.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 06:32:50 -0700 (PDT)
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
Subject: [PATCH v7 05/13] block: add dma-buf support for raw bdev
Date: Mon, 28 Sep 2026 14:32:21 +0100
Message-ID: <a6b81e65b1f09b6ed1f71f294e5a94896ea1ead7.1790602223.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1790602223.git.asml.silence@gmail.com>
References: <cover.1790602223.git.asml.silence@gmail.com>
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
 block/fops.c           | 25 ++++++++++++++++++++++++-
 include/linux/blkdev.h |  2 ++
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index 641621db700f..d05a78d0919a 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -783,7 +783,8 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		ret = blkdev_direct_write(iocb, from);
-		if (ret >= 0 && iov_iter_count(from)) {
+		if (ret >= 0 && iov_iter_count(from) &&
+		    !iov_iter_is_dmabuf_map(from)) {
 			ret = direct_write_fallback(iocb, from, ret,
 					blkdev_buffered_write(iocb, from));
 			need_sync = true;
@@ -796,6 +797,9 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			need_sync = true;
 		}
 	} else {
+		if (unlikely(iov_iter_is_dmabuf_map(from)))
+			return -EOPNOTSUPP;
+
 		/*
 		 * Take i_rwsem and invalidate_lock to avoid racing with
 		 * set_blocksize changing i_blkbits/folio order and punching
@@ -851,6 +855,11 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
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
@@ -954,6 +963,19 @@ static int blkdev_mmap_prepare(struct vm_area_desc *desc)
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
@@ -972,6 +994,7 @@ const struct file_operations def_blk_fops = {
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


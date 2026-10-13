Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98742559C83
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 20:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791924934; cv=none; b=Fgivn5QD6UJicVxCDcQ0jG7aHqZJgAfzwm+yRRgxmcrr1cTItXVrQHg8rG7jMcP4JgvhDXamj0R6uCGDL0ZeQOJLg1l0PVZBVWKXWBeUMmvRPPd4r4H963qng5QhsSbcxMX0OZ773ZyRaBRY3+jbejzQxnHmC8ovRg/wa0e4oN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791924934; c=relaxed/simple;
	bh=poMU3IMk+s1i+OL6PspfjWv+5wjZjdnLVtCEDY3Hn+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHAo2ZlE+DPSbv/OuGmCM/dLgZ0DzXi53stNZTTUCo3zhTOb4KBlRi0dNto7Ak5LnyGYQjQFv0pyS9QlqSE3ZEoV+oYjrPYUP3noHOm5qbdg9dbs0klSUTTfgazucnZ75xATo715loBZl0eRtBzbEHh8kwP4sQBfh8mGQCBC5yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s7+Ynrxu; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s7+Ynrxu"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48b0946c2c2so2151026f8f.3
        for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 13:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791924927; x=1792529727; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sjQY12JZJkEEoHUMGZ5pLsy3Pmh4yJs101KM8nm2S/U=;
        b=s7+YnrxuLn04wgtq+zBTxXiI0Jzy4TbFceHDtkvIhlEpNznX8umJ7cKWyfI2Ov2nue
         Zv9EbRvKXyg9b3s9pei87SQRaNfNXwd6bKBHbwWtp5wKEK/XBRnN0JwPSgN3cr6puWAW
         y7FmxLYk6+bSQe5MN/k0gUdwlUAbHcVqhsA/9pG9DINmPJJBj8/b6pHKwLDlGqwTO72y
         qrQZZsJIWOpLIK67NiZ4SF+1Nn2buEnV/9PBoeE5xT7LIC2mLV0BDR/uXyNduIAfEtzo
         0oMR/SOi3bFsovwRpjyJboLZvXigxYcabcvM/6/32TQlUjXdfzzSLLCGx1krVwQFkeCZ
         QcSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791924927; x=1792529727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sjQY12JZJkEEoHUMGZ5pLsy3Pmh4yJs101KM8nm2S/U=;
        b=oYimm61VtgZT5/ErE3iwqJDjbIuXf6EnalDoBybDFn2gZNJVoms2VbSFxs99/KZwcg
         RpxH6Px84UMnSoudNze0s8iGSSOan2WOkrOjb2HC89u4gzfSqp2B96jBv6Rt/8PchuEW
         ay6wVQhQRPcsmmdKCA1kp0taRw/mtpyqtVczIwsUiJlrTtStnXwmPpYwDH+QTC4vfbxZ
         LnYDZ7JNtTlvgZDBAsDIMXJnBSgUdK5/gzy3SSYyw+7iyXjW5QFdl0xwaJQN+Ma/JoLb
         MdC0DrZrc19l57DECnTyCzhEoXdns8+cKaZlHPQS1dDAw5n29vyvOZwH+Devv5X9r2iB
         lW4w==
X-Forwarded-Encrypted: i=1; AKwUvBwDL2EmLWAFbQixVjev6dDW7jHF0JCMIYL3+zyzrIe9bCoqszpHHOJ5iMKx95psEY4Ir8Nf4nztAQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYKzUneitdIPFP9FKOD95sckApyrC3h63FAJOTyQUvxO07LSVyrP
	9K9qSGx680iib6hFRffAVzCyi0NRbzoOmgYbMF5/qXFrgudD2riBRJEz
X-Gm-Gg: AYBFou0nWYZJglbWGXQi5MjpCLgro4qmcqg09ZU8ur6FAH0biBmQ3BMj8j1aZOf5dPs
	P91eknMOhPnTeW7WIv4W5eGote2mZZLeR1dzOPasRkfFgXu3VF2tJWGT71GCeeA/xTPRX8vF4Fa
	s7lbiZdQVKCH5VMFnYppIbVFqy6fI/WxHUvOHO8yPkVzUuCXxZMQMg+kBYvxrhaglDScxezXM3Q
	pvf6Pmlp6nAPihXxCwEQc1Fs2qtWwGj+rSLxAU82/129IJAjfJ6qhDiUKwpReb73UZzIE19YcC/
	68+c33oLP5nC/33p8hWaXs2zaehNfN51IvuUP/TRGuzqbGe3Ci/LSLdawpPzhFZ5B0oDTSUtaRg
	9KxVKUGeMWkyLppMS5zNA2uKKPFFtAw5RT0Y8yMpxAT+VGs98kdThmJqqG5L1rpjbdLeeuhoTOc
	NlN1gYxfnqF69CvpchkWWXSsjOqaXnFF3Dpb1ZCnheIv4Hjyk1fcEkqqeC6Ns5EkjwJviaGjmlA
	mpFPUb1hF+g0P0YiUU7+H5QwHomEQS51EYlBBK43flW3G0uAch30jKwZCL/ixOMJxqK+SNftSlb
X-Received: by 2002:a5d:5d09:0:b0:482:fd9c:3740 with SMTP id ffacd0b85a97d-48dbaae8af0mr23656771f8f.22.1791924926558;
        Tue, 13 Oct 2026 13:55:26 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de7273a0esm2380730f8f.29.2026.10.13.13.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 13:55:24 -0700 (PDT)
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
Subject: [PATCH v10 05/13] block: add dma-buf support for raw bdev
Date: Tue, 13 Oct 2026 21:54:49 +0100
Message-ID: <78b3f2bb6e3ce576ee99252b88f0af8602b436d1.1791924581.git.asml.silence@gmail.com>
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


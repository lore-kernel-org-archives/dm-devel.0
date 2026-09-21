Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDAC4A2A7C
	for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 13:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789997980; cv=none; b=UBymPKmKcrGGqMQaOCoBI9LstEaCYWuH4y3M8jm3sZqCm3/kUINrOIMl/GAfmwFHp4iwITxJz3vibK2KAHPvJqam6WbPO2Zt5YT2/1/bgixqDMViPh5DcA1olWdH57NlY7FIdQaFfBfR26JquVX1IqBhJ9nB25ggNE+h/aaiax0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789997980; c=relaxed/simple;
	bh=4botMd0JRxgaa+oDvZMUZvvmXYyk4mBy6faGFHabX+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMLCvj1ctQPq+FoTiwxhoL7FBNKi5N/1i7+ZZ6sM+Oaull5Goz1QCcMIwtfB+tcYLBpuTW8GZF1WWifpFIZ79GzDwUMXcM+fVUkcT5rJ1JFeG32XwfVre+X4EHa874RzOf1/qLO8h0iDHMW+aZnuJR0hkFhIUX0ZBja5SABICVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BBesYLC/; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BBesYLC/"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912d3931so22495445e9.3
        for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 06:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789997977; x=1790602777; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LfiQtDTMXplRc+HRsAYVyvIssf+oWzUZ0qqIFwpPEw8=;
        b=BBesYLC/C4DS8qBZxtzgKALfxmXSJgvQDqMCF49MAPdLG2zebPDNtKgXBktzwtdt8t
         1SVFhCk8/6+muODzab+ab/nL2gb+CwwqEZ+2oGuzMW/jl4wz9K2XD499aRtXwl98aoNK
         Qk+LfuhkCv/4641gil9DHIDsSAdm2aVdomh4GV5MEy5x/3b1WdWp6NqAG0hCycUdcCXA
         j4zoZvt0mV2Mua/CyOE3IaZJLNnTkVmLVkS/b57XJx8HkR+201MroHXCEmB0HO07MTvf
         dbYktdQmioCSnpUH7eT2avj3Iq/cSLQiy11NqilJOPliI94s6a94DPEdDBvb5OO98Nde
         NvMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789997977; x=1790602777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LfiQtDTMXplRc+HRsAYVyvIssf+oWzUZ0qqIFwpPEw8=;
        b=XyGnX4rgAiqIMCtNxdc0Lqjw3RUvrX1I5zfuxZ2L7EwK64FhLGWvHk0TtWwYAdvSno
         UJNhbkG0fF49+0jeSS9NMOJ2jKA/3piN9gntnMJnmCJ8h/R/9P8Z757WPn4lFpTxLRYU
         mBhcfoh2RS14uywiw2iSECKHpvWO140YLwWgH7IH/Le6iyDA+aXqBSZ5R/RALK9tn+mO
         +vT5/C9dFVWLG1xK6mLG0+AJZrLZVD2QpTOLKTGQ0B2Jb+O/jeP0UMYC66hllNL2Q8BH
         mOYuCGQS7T+uM88zvgOXkgkXaOUcRya0lRWyd/AsGOAHlRAVaNG8YQ5PTz5hmvJagOP7
         Ma0w==
X-Forwarded-Encrypted: i=1; AKwUvBy398un89wD23xhYWRNTfuy5ORA64t/W4g7Rw4bn63K3CpzNovtyOtf2s8ksmSQdznYNuJ47pSEJg==@lists.linux.dev
X-Gm-Message-State: AFuF++kphzeAKWSPFZ6qWfzs0g3ECoVOnKWxdgeffc0pl888Svj8xn96
	ypVidIE4wdjxaqANwmospriR/vPSEucdqqCfqMLIHe7AzUPF/UpoGhGu
X-Gm-Gg: AYBFou0AuQgZXELzXW1RnbcKT8rbDEfQp6+HFAoFo6Wgjqg+Prhmz+UqvcLixuoLGtW
	y31DgaWdU2pOsiPJj9zuku3o/mmyAy2fGOsnmkdLqZlfR/JgB8kzZa0s1iVjNa/pKLF+dflo23j
	ZEhB/nQp0a97FpyxoJkHtdj+6t1Q9bMJi3+kvk946+CvRbpaxJKbipHyWPqiKL76peKt2i57fLe
	XWmouBrDixsgTKQCah3yiw578AIhySXy1wXqVw4iHwC/A5eWSFFx1yNBexiay6CNku0c+iPz07r
	q41WyN1rczGLY49dq26ePUgoG7J0TDUY5cs0eLFm7h7tIdpr8tr3z3VR91hCYQMZEUZD8oBP41x
	uTBiAVem3ZKrAI+nBHDo6RzOzxbhT57kxbqh03K3fB/qcO3gdXBAXuPD20SQrivNLLDXgEeCDnT
	R1w1ij67c4hroOnm/fX4Ux6XcTTbVL+Za1Qp8CAY8UB6aWDXDDlb8PA7Nkcrk8iTKHQGcQMIIyq
	P0urHHBjyiwYt0uDHskvifLMRn5pY301XdOQ1EAlFK+9EJDfhqzUVFPnY7UbQYv8QT+eV/WJ4qF
	fHagS/osV87DkSQal0WQpdr1/Bwzt73k+ltilbRr
X-Received: by 2002:a05:600c:c493:b0:49e:74b6:740f with SMTP id 5b1f17b1804b1-49fc573603amr145209165e9.17.1789997977065;
        Mon, 21 Sep 2026 06:39:37 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-213-26.dab.02.net. [82.132.213.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fc585920fsm617171605e9.4.2026.09.21.06.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 06:39:35 -0700 (PDT)
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
Subject: [PATCH v6 05/13] block: add dma-buf support for raw bdev
Date: Mon, 21 Sep 2026 14:38:49 +0100
Message-ID: <eafcbbf7e75e75e98d0791b843fae0f2423a4ecd.1789997898.git.asml.silence@gmail.com>
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

Add a simple proxy implementation of init_dma_buf_io_ctx() forwarding
the call to a new struct block_device_operations operation. Also reject
dma-buf backed iterators for buffered IO.

Reviewed-by: Christoph Hellwig <hch@lst.de>
[pavel: reject dma-buf without O_DIRECT]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/fops.c           | 22 +++++++++++++++++++++-
 include/linux/blkdev.h |  2 ++
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index 09fa42f8d8fa..0252d26969a4 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -782,7 +782,8 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		ret = blkdev_direct_write(iocb, from);
-		if (ret >= 0 && iov_iter_count(from)) {
+		if (ret >= 0 && iov_iter_count(from) &&
+		    !iov_iter_is_dmabuf_map(from)) {
 			ret = direct_write_fallback(iocb, from, ret,
 					blkdev_buffered_write(iocb, from));
 			need_sync = true;
@@ -795,6 +796,9 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			need_sync = true;
 		}
 	} else {
+		if (unlikely(iov_iter_is_dmabuf_map(from)))
+			return -EOPNOTSUPP;
+
 		/*
 		 * Take i_rwsem and invalidate_lock to avoid racing with
 		 * set_blocksize changing i_blkbits/folio order and punching
@@ -850,6 +854,8 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		if (ret < 0 || !count)
 			goto reexpand;
 	}
+	if (unlikely(iov_iter_is_dmabuf_map(to)))
+		return -EOPNOTSUPP;
 
 	/*
 	 * Take i_rwsem and invalidate_lock to avoid racing with set_blocksize
@@ -953,6 +959,19 @@ static int blkdev_mmap_prepare(struct vm_area_desc *desc)
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
@@ -971,6 +990,7 @@ const struct file_operations def_blk_fops = {
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


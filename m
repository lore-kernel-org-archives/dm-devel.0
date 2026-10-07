Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0485A35E1AA
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 01:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791337403; cv=none; b=UfoGUrXGq1YAm3PAyA55NYuEuPZilwioVoG9ax6mEpd8XfDyLlwVADuhCxrPkLcsZ64ASG2VMhjiN9yVd8VmBw/h032XJ5I7PxtfXssnjpxPjZanGC4FH+/2R+o12TovmJgVhO9CmMFFYNucztV7NUEsQlggTEU4V5ZXRv3GGrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791337403; c=relaxed/simple;
	bh=L6TVWpongEDpA7TiLe+SNULpjIEu9UzpPIkgkHUo5Rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPtdbtxEB42PE/X5rnvnDtD8sV6SFwrRX1WWEQtecXI/q5ivXwUcX44vHvCwIGAT8jJNrj165dORbHzqMV84uvuuiVHF8ZZyGWWFIdP80jNS/59QkPH/Iuaz0/CENqShPXhmH/Qez1/Q+yBIuS+JoGynMegNOCzxjMZ5FC0SeUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cdUe44mW; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cdUe44mW"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a1698ea378so10372325e9.2
        for <dm-devel@lists.linux.dev>; Tue, 06 Oct 2026 18:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791337398; x=1791942198; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nls4uSWUi3FtYOHw3kmfxrWIUNA1MBsyApDbzhyJZsE=;
        b=cdUe44mWSSwZUUTdpsKaGwlsy78yIIGLMOXnVOpPHi9KX87I3EZVMg/bjbj2BB5JDE
         IYCqsVgJExMboUz43q8q+/EYT3Fo/ZJnrCJ7saLXtKKE0J98YRasPGxhGpXmODuHXeH+
         viyI2iP30sVfOnFnnpVp4mQvfpFFhuCb+u34yo5qO24eXIJAH8WUM74Nteo1jipxMFVn
         9r6egMmByQKsp3Vz9euBHmyhWQe8bCJsJKuBEa6x2RhHrPSG8GQxcCDEKDsXAxPLwS2W
         fKLbrGtsIvn1nM1wBc8fcnkeY5ZkYYblhTfiMSupUX0VQIqMXPrzpP6Cwl1yg1xj9SdH
         vo2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791337398; x=1791942198;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Nls4uSWUi3FtYOHw3kmfxrWIUNA1MBsyApDbzhyJZsE=;
        b=QMhX2yExnUK81wrLMrxAmDP0jtxYS6yaSZMJnIGQEnff8Fcep5E87G/JYZ3tNl+ngI
         iZZNrnUPGK0kL4YC032ZAXwZhd4br076B0n8QG7WT/WT3tqwePQGbao3K9vU5xPj8+P8
         EjPebf1HdeVQvvavDHKBuGgOOgErds8G5u9SvhGzlMoK0fuLNiRqaYtZnKB//wkmJ30Q
         HqGWNEkBzEnHOAJNDAn8ODxfgGeswG4pkaWKV98VfmLtqqB4Oz4KI3SHjCTnhvjtIave
         pL4L2d9dys7GdyjHP3XUI3rwhMDbLmEf37tsobl0BMPmhljrpN/LrgpnsRGumRnfWKN/
         8glQ==
X-Forwarded-Encrypted: i=1; AKwUvBzyBgWXZC+wveaYxORuK9E3pAl0WsoFWldDk70pSTnk/5mO2WhnZSYDrB9rLnK1A5lLB8O9DBT3wg==@lists.linux.dev
X-Gm-Message-State: AFuF++m0ij+aEwZClLwbNscVLTge868JRWsUV+sSajDsaU4MlT6mj23s
	difdo8+xespaaPg8ZYD1hb6c7URKw4GDikC7u3lOOS7oKkr1FhxRGtg5
X-Gm-Gg: AYBFou1EpdzC9fZIyTwxS8dwjDoKQJcCrGq9eyEcwbQagvQ7UFrKy/qoDwQQqj/U0ql
	7df96UcEbt+gdSyWQnZAFQTyf2YoqHq62MRPghnDUbh3pb8IevcDC/BYctPGanFzG0yKAK2XBnS
	M5V7kUjIVIYJdws5UDviD1pQmIHegXiXSDIt+jSZNWff92Eq4v4cSRbv0Wd/AzRI4p4ldh0Pv0W
	kdd4GUdfpvbVDA8ttrHyH7nL7CemO5Pf0t3cUi6tp0ekxH7DB6IUvOxAkTxCTwoudqbDB1g2NvH
	y04xpTyxGjD8fztijDe03AmoqZMmxEjbVeFPKo42roNWFGxmD2lyU1O3tyBkj25OynUlmDY84Z0
	dB36dLQLDVB2LPGqylwck9bUOQBNCIt7gg+RxT1u/0/Y0jOdNL97tqQtTWjfdQy6Py0GZTVGE7/
	nhm/68lyAS58GrHHfH8z9eaiqAwy5DccIS0OLu2EPJN7WmNYl/kQ80yFqpjYgT+t0L2WvMVTgzf
	K1qNn81C6mcHzqTnbNsuaYy90BLt16y97ogsFterHMR9h4qZgqgJXIZ7mGH0Gvi0Dd6ZHJ2I6cR
X-Received: by 2002:a05:600c:c16f:b0:4a0:2484:2800 with SMTP id 5b1f17b1804b1-4a1800ca1c3mr7313145e9.3.1791337398229;
        Tue, 06 Oct 2026 18:43:18 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a17f653d7csm26423895e9.14.2026.10.06.18.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 18:43:16 -0700 (PDT)
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
Subject: [PATCH v9 05/13] block: add dma-buf support for raw bdev
Date: Wed,  7 Oct 2026 02:42:48 +0100
Message-ID: <af2b48a490186edf38f1d4a5dfd9513574f7a350.1791336930.git.asml.silence@gmail.com>
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


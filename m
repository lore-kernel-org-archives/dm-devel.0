Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C14466B00
	for <dm-devel@lists.linux.dev>; Thu,  8 Oct 2026 12:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791462478; cv=none; b=gmpGpuVinLosOcTWSShSsV2447BUX2A6xh5+LCU+ZOcD8bgBTsOMgG07+mgUeHRVjhxP8S0CmVNTPJSHGuERpd1ViOiUwblUXDgbSLy/XeTHzCPnByoDvVCeakGIBqzXMi3E9sDcVfqzlL+YQd99jvYl+fzTtnrpWndDAKN/CRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791462478; c=relaxed/simple;
	bh=M/of0yKyhsge6MIBInUspqDhJmPuNOVFyiktJawrHXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=J/5FCwPKYA5LlBOCFDTNHKNZ2qWiBSqCWCSk52FCgb9Jx0X/TFSYe3KvBPxDIaK1ZquqCQa2hyr9g5/T58lOlJ5nBEkQTOPWI0Jb3Rt8y19HMDn/7XRrYPJBqQx4czngMfidqjnHZTxPaD1eDaXE684pi0wD5385yA0VoRxNIe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=tdC5+MT+; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="tdC5+MT+"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261008122753epoutp03b5685c715241e278540abd17949ca561~cjaDAC_3o2964929649epoutp038
	for <dm-devel@lists.linux.dev>; Thu,  8 Oct 2026 12:27:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261008122753epoutp03b5685c715241e278540abd17949ca561~cjaDAC_3o2964929649epoutp038
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791462473;
	bh=y3JROMvSkErlghFufMEpz2e3fgBQWeAkOo4JhswqA7k=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=tdC5+MT+GmAi5muBRq1BT1yN1ZKyFBL9HVTHiJoMUk9qir3KHpRlhz35ERD8YB6Bl
	 i1eJ514gd7g1gNeb0KlrladiC9kKg0NHCB+yBiTYgiBHVNFGcUFtxIU50PqOf5+JRY
	 f9jIGFX133rc42c6pXTmJz1rl62OYAb4OJmJKBEI=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20261008122752epcas5p3d0e2b9158c0268ad04675e87ce26f1a2~cjaCjkMAU1506315063epcas5p3z;
	Thu,  8 Oct 2026 12:27:52 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.93]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4j0q5M5zGqz3hhT3; Thu,  8 Oct
	2026 12:27:51 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20261008122751epcas5p1c1717e88968c87ac8cd3f6f7cd53fd94~cjaBJv_6d1842018420epcas5p1H;
	Thu,  8 Oct 2026 12:27:51 +0000 (GMT)
Received: from [107.122.10.194] (unknown [107.122.10.194]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261008122747epsmtip1643989c6f636e89fda3b56fc37de2645~cjZ9_NBhB1436814368epsmtip1X;
	Thu,  8 Oct 2026 12:27:47 +0000 (GMT)
Message-ID: <bbb87d6b-b7a3-487a-8be4-27f3f9ce4a1b@samsung.com>
Date: Thu, 8 Oct 2026 17:57:47 +0530
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 05/13] block: add dma-buf support for raw bdev
To: Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Sumit Semwal
	<sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?=
	<christian.koenig@amd.com>, Keith Busch <kbusch@kernel.org>, Sagi Grimberg
	<sagi@grimberg.me>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
	Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Andrew Morton
	<akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Nitesh Shetty
	<nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, Mike Snitzer
	<snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Benjamin
	Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Content-Language: en-US
From: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>
In-Reply-To: <af2b48a490186edf38f1d4a5dfd9513574f7a350.1791336930.git.asml.silence@gmail.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261008122751epcas5p1c1717e88968c87ac8cd3f6f7cd53fd94
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261007014324epcas5p2a7f3b03f118c9a1d1c633fe839ed1e46
References: <cover.1791336930.git.asml.silence@gmail.com>
	<CGME20261007014324epcas5p2a7f3b03f118c9a1d1c633fe839ed1e46@epcas5p2.samsung.com>
	<af2b48a490186edf38f1d4a5dfd9513574f7a350.1791336930.git.asml.silence@gmail.com>

On 10/7/2026 7:12 AM, Pavel Begunkov wrote:
> +static int blkdev_init_dma_buf_io_ctx(struct file *file,
> +				      struct dma_buf_io_ctx *ctx)
> +{
> +	struct block_device *bdev = file_bdev(file);
> +	struct gendisk *disk = bdev->bd_disk;
> +
> +	if (!(file->f_flags & O_DIRECT))
> +		return -EINVAL;
> +	if (!disk->fops->init_dma_buf_io_ctx)
> +		return -EOPNOTSUPP;

dma-buf doesn't work with PI: bi_dmabuf_map aliases bi_io_vec, and 
blk_integrity_iterate() walks it as bvecs to generate/verify the 
checksum. rw-dmabuf liburing test hangs on a PI enabled NVMe. Something 
like below is needed:

diff --git a/block/blk-mq.c b/block/blk-mq.c
index e929f94b25c7..1b7f8cbbda8b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3150,6 +3150,12 @@ void blk_mq_submit_bio(struct bio *bio)
                 goto queue_exit;
         }

+       if (unlikely(op_is_dmabuf(bio->bi_opf) &&
+               bdev_has_integrity_csum(bio->bi_bdev))) {
+               bio_endio_status(bio, BLK_STS_NOTSUPP);
+               goto queue_exit;
+       }
+
         if ((bio->bi_opf & REQ_POLLED) && !blk_mq_can_poll(q)) {
                 bio_endio_status(bio, BLK_STS_NOTSUPP);
                 goto queue_exit;
diff --git a/block/fops.c b/block/fops.c
index e9da48ab73be..6c6700df943c 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -976,6 +976,8 @@ static int blkdev_init_dma_buf_io_ctx(struct file *file,
                 return -EINVAL;
         if (!disk->fops->init_dma_buf_io_ctx)
                 return -EOPNOTSUPP;
+       if (bdev_has_integrity_csum(bdev))
+               return -EOPNOTSUPP;
         return disk->fops->init_dma_buf_io_ctx(bdev, ctx);
  }


Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027B81845
	for <dm-devel@lists.linux.dev>; Fri, 10 Nov 2023 01:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="eSmdPPCg"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6be0277c05bso1449802b3a.0
        for <dm-devel@lists.linux.dev>; Thu, 09 Nov 2023 17:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699578112; x=1700182912; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b06Vj9lOHSb9sRVpxi+IgZjFW0xvb2n47gh9duK5vpM=;
        b=eSmdPPCgtwbgeF6WE8x14qBuF3H5QVSAZ8F+j1nrs+ltcS/r4rtK7wMfBMStr1aZHx
         KNVlCXhFEEiXMAvh+zS894fqJ8yZOTxadFyR0O0Z8+afr0IFXDEijMJUIF03ZIw042rQ
         5/9ujW/faxC8DwxgA+PsfLjEBIUWYTAqTBayo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699578112; x=1700182912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b06Vj9lOHSb9sRVpxi+IgZjFW0xvb2n47gh9duK5vpM=;
        b=LHNGUit4/Zem7iYtdCNtnQHxw6fQ1z67CpS0A3dSO0k76LtOn7jHn69bdo/7ItCxZN
         NTpkHbweWGLcxZm8AGK/R5HdansZ5i/1AoeQjQkT56TX02xSQK+CeNbkD47uUPyW8hUa
         G0VXM7eofCNJhBrzir8LxsbXCKp3zabtifES+Bszkgb8TXEmzZe0wQW0gQ1LCigNmPPr
         4YkJcLNJAFotFikBL3peWBZq7tAFupi8UViKagyxMZFpOxMZW/3+7Fr/I2zIQuCcvqVD
         4c5JRH92RO17oERjNO4MhnGBe2OYtQmEX/ZmF6ik/5htiDjMHUV6frskOQAztKB00mHW
         IShw==
X-Gm-Message-State: AOJu0YxlyELqxzZrVWOPwk1xCJyGu023KpsvTinUdmi3x9qjhTXM7vC8
	EyyEBMCe7L8YMmdax8Cjt4+Z699/722e61lTE84=
X-Google-Smtp-Source: AGHT+IEcUrMoRB4M3cFIJYYG0U9EFFBVtRT/665jkYTpjvDYxK5d5N79MHBfBn5NU+hQE8l3/c87lA==
X-Received: by 2002:aa7:88d6:0:b0:6c3:1b90:8554 with SMTP id k22-20020aa788d6000000b006c31b908554mr6534965pff.12.1699578112454;
        Thu, 09 Nov 2023 17:01:52 -0800 (PST)
Received: from localhost ([2620:15c:9d:2:e584:25c0:d29c:54c])
        by smtp.gmail.com with UTF8SMTPSA id m15-20020a056a00080f00b006c4db182074sm82725pfk.196.2023.11.09.17.01.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Nov 2023 17:01:52 -0800 (PST)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Dave Chinner <david@fromorbit.com>,
	Brian Foster <bfoster@redhat.com>,
	Sarthak Kukreti <sarthakkukreti@chromium.org>
Subject: [PATCH v9 3/3] loop: Add support for provision requests
Date: Thu,  9 Nov 2023 17:01:38 -0800
Message-ID: <20231110010139.3901150-4-sarthakkukreti@chromium.org>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
In-Reply-To: <20231110010139.3901150-1-sarthakkukreti@chromium.org>
References: <20231110010139.3901150-1-sarthakkukreti@chromium.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for provision requests to loopback devices. Loop devices
will configure provision support based on whether the underlying block
device/file can support the provision request and, upon receiving a
provision bio, will map it to the backing device/storage. For loop devices
over files, a REQ_OP_PROVISION request will translate to an fallocate()
mode 0 call on the backing file.

Caveat: For filesystems with copy-on-write semantics, REQ_OP_PROVISION
will guarantee the success of only the next write to the provisioned range
with a ENOSPC.

Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/block/loop.c | 39 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 9f2d412fc560..c84d4acdb18c 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -311,16 +311,20 @@ static int lo_fallocate(struct loop_device *lo, struct request *rq, loff_t pos,
 {
 	/*
 	 * We use fallocate to manipulate the space mappings used by the image
-	 * a.k.a. discard/zerorange.
+	 * a.k.a. discard/provision/zerorange.
 	 */
 	struct file *file = lo->lo_backing_file;
 	int ret;
 
-	mode |= FALLOC_FL_KEEP_SIZE;
+	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE) &&
+	    !bdev_max_discard_sectors(lo->lo_device))
+		return -EOPNOTSUPP;
 
-	if (!bdev_max_discard_sectors(lo->lo_device))
+	if (mode == 0 && !bdev_max_provision_sectors(lo->lo_device))
 		return -EOPNOTSUPP;
 
+	mode |= FALLOC_FL_KEEP_SIZE;
+
 	ret = file->f_op->fallocate(file, mode, pos, blk_rq_bytes(rq));
 	if (unlikely(ret && ret != -EINVAL && ret != -EOPNOTSUPP))
 		return -EIO;
@@ -488,6 +492,13 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 				FALLOC_FL_PUNCH_HOLE);
 	case REQ_OP_DISCARD:
 		return lo_fallocate(lo, rq, pos, FALLOC_FL_PUNCH_HOLE);
+	case REQ_OP_PROVISION:
+		/*
+		 * fallocate() guarantees that the next writes to the
+		 * provisioned range will succeed without ENOSPC but does not
+		 * guarantee that every write to this range will succeed.
+		 */
+		return lo_fallocate(lo, rq, pos, 0);
 	case REQ_OP_WRITE:
 		if (cmd->use_aio)
 			return lo_rw_aio(lo, cmd, pos, ITER_SOURCE);
@@ -754,6 +765,25 @@ static void loop_sysfs_exit(struct loop_device *lo)
 				   &loop_attribute_group);
 }
 
+static void loop_config_provision(struct loop_device *lo)
+{
+	struct file *file = lo->lo_backing_file;
+	struct inode *inode = file->f_mapping->host;
+
+	/*
+	 * If the backing device is a block device, mirror its provisioning
+	 * capability.
+	 */
+	if (S_ISBLK(inode->i_mode)) {
+		blk_queue_max_provision_sectors(lo->lo_queue,
+			bdev_max_provision_sectors(I_BDEV(inode)));
+	} else if (file->f_op->fallocate) {
+		blk_queue_max_provision_sectors(lo->lo_queue, UINT_MAX >> 9);
+	} else {
+		blk_queue_max_provision_sectors(lo->lo_queue, 0);
+	}
+}
+
 static void loop_config_discard(struct loop_device *lo)
 {
 	struct file *file = lo->lo_backing_file;
@@ -1092,6 +1122,7 @@ static int loop_configure(struct loop_device *lo, blk_mode_t mode,
 	blk_queue_io_min(lo->lo_queue, bsize);
 
 	loop_config_discard(lo);
+	loop_config_provision(lo);
 	loop_update_rotational(lo);
 	loop_update_dio(lo);
 	loop_sysfs_init(lo);
@@ -1304,6 +1335,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	}
 
 	loop_config_discard(lo);
+	loop_config_provision(lo);
 
 	/* update dio if lo_offset or transfer is changed */
 	__loop_update_dio(lo, lo->use_dio);
@@ -1857,6 +1889,7 @@ static blk_status_t loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	case REQ_OP_FLUSH:
 	case REQ_OP_DISCARD:
 	case REQ_OP_WRITE_ZEROES:
+	case REQ_OP_PROVISION:
 		cmd->use_aio = false;
 		break;
 	default:
-- 
2.39.2


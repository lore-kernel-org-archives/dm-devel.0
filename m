Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59023C77B7A
	for <dm-devel@archiver.kernel.org>; Thu, 18 May 2023 22:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684449249;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Dic/IMrLDKZfUZoKkkq5Wx5FT1W9FUlNkNQtFXynTVg=;
	b=PKc3Wmc44DzhEuMXFu0vVor4hH66Ec877oRqd3mmBVd2G4nnS9F4OHpqgBf2oBfD0cE68Y
	RzgHaiSqgedu+tI1cUX4/2vOQqj2v89S1XvnwWYakC6OFCKw/O3xAIWPS4PEC63ePIKpVd
	XtF/vadFgf2jt81K00m2TgaLXppnBF8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-AX7AiryCMGef82EtDYryig-1; Thu, 18 May 2023 18:34:06 -0400
X-MC-Unique: AX7AiryCMGef82EtDYryig-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4AA4D101A555;
	Thu, 18 May 2023 22:34:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 37A3E492B01;
	Thu, 18 May 2023 22:34:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 234D719465B2;
	Thu, 18 May 2023 22:34:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ADA3E19465B2
 for <dm-devel@listman.corp.redhat.com>; Thu, 18 May 2023 22:34:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 92BE0492B03; Thu, 18 May 2023 22:34:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8AAA6492B02
 for <dm-devel@redhat.com>; Thu, 18 May 2023 22:34:02 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67D34299E745
 for <dm-devel@redhat.com>; Thu, 18 May 2023 22:34:02 +0000 (UTC)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com
 [209.85.214.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-209-JRosKrS-MUmJqhDAU6fumw-1; Thu, 18 May 2023 18:34:00 -0400
X-MC-Unique: JRosKrS-MUmJqhDAU6fumw-1
Received: by mail-pl1-f175.google.com with SMTP id
 d9443c01a7336-1ae408f4d1aso20867225ad.0
 for <dm-devel@redhat.com>; Thu, 18 May 2023 15:34:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684449239; x=1687041239;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=D1nBFbl2kNhqRXHkgIUn6lQxv3BWL5XvL+95Aso43MI=;
 b=WQS5JPcLobRPAc84O31+rabnF8tLoeFDX5w8hAcjQkBX8bcaybKK9nPFidegoIhyhF
 +R9bhr707KFQ6fTC3xQ6srRpNSH2Sftal14rMySj3fKCeGjeijKFxbcIf/BqasysjFF8
 ynjRYyl52RFP6nRaMVZg4J+PTJDnmzuiqJMelF+RX956zhAlw5X0CPVKlmvJF846tsKJ
 Wy8IeDdfVn1mbHfvEIlu/pVwh4CG38sRfm2UqIQmcVp8eWa0YAuWTYC8P9i1mKDBZeH0
 4NDka12DjETB842u5i+svbi30X4Eesl2RnmaGRthfVyfjYIsD4FSWP5P3mpGWpywjqGY
 v/Mg==
X-Gm-Message-State: AC+VfDzY36t3Bbh+ufvB63OuxawxA2Z8aaSxfBNNADhjLKVRJihSwxV9
 kSCFEN9S/0N2yRsBJieTzN7bzyg+cMugxkwlHY5fmQ==
X-Google-Smtp-Source: ACHHUZ7zJhYjfPa+ZbTaOHzNa4SnFtqdlL9pTqh+Bv9ufbfnFBxQYSdHmDSrGjM9o2XMte6XYk8eIA==
X-Received: by 2002:a17:903:2689:b0:1ac:8837:df8 with SMTP id
 jf9-20020a170903268900b001ac88370df8mr699263plb.6.1684449239382; 
 Thu, 18 May 2023 15:33:59 -0700 (PDT)
Received: from sarthakkukreti-glaptop.corp.google.com ([100.107.238.113])
 by smtp.gmail.com with ESMTPSA id
 q4-20020a170902b10400b001aafb802efbsm1996502plr.12.2023.05.18.15.33.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 18 May 2023 15:33:59 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Date: Thu, 18 May 2023 15:33:26 -0700
Message-ID: <20230518223326.18744-6-sarthakkukreti@chromium.org>
In-Reply-To: <20230518223326.18744-1-sarthakkukreti@chromium.org>
References: <20230518223326.18744-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH v7 5/5] loop: Add support for provision requests
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>,
 "Michael S. Tsirkin" <mst@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add support for provision requests to loopback devices.
Loop devices will configure provision support based on
whether the underlying block device/file can support
the provision request and upon receiving a provision bio,
will map it to the backing device/storage. For loop devices
over files, a REQ_OP_PROVISION request will translate to
an fallocate mode 0 call on the backing file.

Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
---
 drivers/block/loop.c | 34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index bc31bb7072a2..7fe1a6629754 100644
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
@@ -488,6 +492,8 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 				FALLOC_FL_PUNCH_HOLE);
 	case REQ_OP_DISCARD:
 		return lo_fallocate(lo, rq, pos, FALLOC_FL_PUNCH_HOLE);
+	case REQ_OP_PROVISION:
+		return lo_fallocate(lo, rq, pos, 0);
 	case REQ_OP_WRITE:
 		if (cmd->use_aio)
 			return lo_rw_aio(lo, cmd, pos, ITER_SOURCE);
@@ -754,6 +760,25 @@ static void loop_sysfs_exit(struct loop_device *lo)
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
@@ -1092,6 +1117,7 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 	blk_queue_io_min(lo->lo_queue, bsize);
 
 	loop_config_discard(lo);
+	loop_config_provision(lo);
 	loop_update_rotational(lo);
 	loop_update_dio(lo);
 	loop_sysfs_init(lo);
@@ -1304,6 +1330,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	}
 
 	loop_config_discard(lo);
+	loop_config_provision(lo);
 
 	/* update dio if lo_offset or transfer is changed */
 	__loop_update_dio(lo, lo->use_dio);
@@ -1830,6 +1857,7 @@ static blk_status_t loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	case REQ_OP_FLUSH:
 	case REQ_OP_DISCARD:
 	case REQ_OP_WRITE_ZEROES:
+	case REQ_OP_PROVISION:
 		cmd->use_aio = false;
 		break;
 	default:
-- 
2.40.1.698.g37aff9b760-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


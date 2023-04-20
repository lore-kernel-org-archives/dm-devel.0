Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 648FBC77B73
	for <dm-devel@archiver.kernel.org>; Thu, 20 Apr 2023 01:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681955269;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Pnwvz7Nf9qNM8gqXPW8xAKbM+oT8GTOHh+uXgpZ9XF8=;
	b=ew9qVs5VX3dJpVm0P5l6ufeCRi54P6Wx6akmGJaSK4QRBm/QWf3Uplb2OMo6hB6P368P0y
	43nt1IJPi4RNg4nqKR+++K+tazdXUetyJ1zaIbbpTEhgbwsxDZqHjppI9Vgg5FBoeNVe7m
	jv3Xbosrq8VEst0dCtszMHM1JmW/zfs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-232-dzUFokSvNeSSyhShxgvHjw-1; Wed, 19 Apr 2023 21:47:47 -0400
X-MC-Unique: dzUFokSvNeSSyhShxgvHjw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5403185A7A4;
	Thu, 20 Apr 2023 01:47:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 839842026D16;
	Thu, 20 Apr 2023 01:47:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3359B19465B9;
	Thu, 20 Apr 2023 01:47:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C37D519465B5
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Apr 2023 01:47:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6DB8C492B06; Thu, 20 Apr 2023 01:47:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 64B6B492B05
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 01:47:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 497D1811E7E
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 01:47:43 +0000 (UTC)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
 [209.85.210.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-Bt06mpYQPZSQEDBcJ9lJIw-1; Wed, 19 Apr 2023 21:47:39 -0400
X-MC-Unique: Bt06mpYQPZSQEDBcJ9lJIw-1
Received: by mail-pf1-f169.google.com with SMTP id
 d2e1a72fcca58-63b51fd2972so447720b3a.3
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 18:47:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681955258; x=1684547258;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=lyurZ/3V3e/TfJ64+oQeFZRXuRpGYngRPpwbALjOBlU=;
 b=DDYtBLnwA5xaOgAkphQ2l2Y2Ib+njtuAV1rJO0ct8er7MKi3EzwmgKiGWT5czlTnMK
 RKGJeWZFVyXNRi/E08St7+SbedsI2ba3C4UYlDw9fxTcmB1r7kg8BF4EKcKPIDq1Wt9R
 Da0Ro/BfG0XIJR4IOZkWGmI/TJ1yOklafvJBWJQWDx8omsoFjFwBskr/+K3nq+voaRo4
 WwJxaDcDFzi9hazNYA/BYRBqlf+q+7rKWzN96m9z3WsRSfbPf0RbNnqSdAsJw/5cL4LN
 N2vjnxnvK/dIyyAPwpNOCkhHuZdxO1EgbMtVMjNBvrlr9mqBFudrE+SkXI9iwG1JUdEV
 U2ng==
X-Gm-Message-State: AAQBX9cp2adETXEub1QM4nk8x0n/ktKHkUOxixW0vAJ0klL5I9YDukyf
 UaSRJZFof2ukJtu5kUwd1wYdAVPhu5SNGWPmBi8=
X-Google-Smtp-Source: AKy350azF3Q2VfJRGkzUywFfeQrYRuuCXsZ99E9a6W8nqlVd2cwXSPd2Fqy1TX8MhR0Y0U2TO1ZDXA==
X-Received: by 2002:a05:6a00:1489:b0:63d:3aed:44fb with SMTP id
 v9-20020a056a00148900b0063d3aed44fbmr6882651pfu.21.1681955258324; 
 Wed, 19 Apr 2023 18:47:38 -0700 (PDT)
Received: from sarthakkukreti-glaptop.hsd1.ca.comcast.net
 ([2601:647:4200:b5b0:402e:4c2e:4e90:d79d])
 by smtp.gmail.com with ESMTPSA id
 y4-20020a62ce04000000b006363690dddasm60753pfg.5.2023.04.19.18.47.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 19 Apr 2023 18:47:37 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Date: Wed, 19 Apr 2023 18:47:34 -0700
Message-ID: <20230420014734.302304-1-sarthakkukreti@chromium.org>
In-Reply-To: <20230420004850.297045-2-sarthakkukreti@chromium.org>
References: <20230420004850.297045-2-sarthakkukreti@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH v5-fix 1/5] block: Don't invalidate pagecache for
 invalid falloc modes
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
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Only call truncate_bdev_range() if the fallocate mode is
supported. This fixes a bug where data in the pagecache
could be invalidated if the fallocate() was called on the
block device with an invalid mode.

Fixes: 25f4c41415e5 ("block: implement (some of) fallocate for block devices")
Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
---
 block/fops.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index d2e6be4e3d1c..d359254c645d 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -648,26 +648,37 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 
 	filemap_invalidate_lock(inode->i_mapping);
 
-	/* Invalidate the page cache, including dirty pages. */
-	error = truncate_bdev_range(bdev, file->f_mode, start, end);
-	if (error)
-		goto fail;
-
+	/*
+	 * Invalidate the page cache, including dirty pages, for valid
+	 * de-allocate mode calls to fallocate().
+	 */
 	switch (mode) {
 	case FALLOC_FL_ZERO_RANGE:
 	case FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE:
-		error = blkdev_issue_zeroout(bdev, start >> SECTOR_SHIFT,
-					     len >> SECTOR_SHIFT, GFP_KERNEL,
-					     BLKDEV_ZERO_NOUNMAP);
+		error = truncate_bdev_range(bdev, file->f_mode, start, end);
+		if (!error)
+			error = blkdev_issue_zeroout(bdev,
+						     start >> SECTOR_SHIFT,
+						     len >> SECTOR_SHIFT,
+						     GFP_KERNEL,
+						     BLKDEV_ZERO_NOUNMAP);
 		break;
 	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE:
-		error = blkdev_issue_zeroout(bdev, start >> SECTOR_SHIFT,
-					     len >> SECTOR_SHIFT, GFP_KERNEL,
-					     BLKDEV_ZERO_NOFALLBACK);
+		error = truncate_bdev_range(bdev, file->f_mode, start, end);
+		if (!error)
+			error = blkdev_issue_zeroout(bdev,
+						     start >> SECTOR_SHIFT,
+						     len >> SECTOR_SHIFT,
+						     GFP_KERNEL,
+						     BLKDEV_ZERO_NOFALLBACK);
 		break;
 	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE | FALLOC_FL_NO_HIDE_STALE:
-		error = blkdev_issue_discard(bdev, start >> SECTOR_SHIFT,
-					     len >> SECTOR_SHIFT, GFP_KERNEL);
+		error = truncate_bdev_range(bdev, file->f_mode, start, end);
+		if (!error)
+			error = blkdev_issue_discard(bdev,
+						     start >> SECTOR_SHIFT,
+						     len >> SECTOR_SHIFT,
+						     GFP_KERNEL);
 		break;
 	default:
 		error = -EOPNOTSUPP;
-- 
2.40.0.634.g4ca3ef3211-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


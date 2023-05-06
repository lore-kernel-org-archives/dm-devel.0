Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFFEFC7EE32
	for <dm-devel@archiver.kernel.org>; Sat,  6 May 2023 06:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683354572;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ukXmm6dHCmHcRxrHe8V6KWNaRa1QHtYSSHQaU2bbmcM=;
	b=RyZk93XU8AjvQNSygK3b/N/A9iI0eIlI7OFUu6HFkaarocxrdUBFHEzFw7INB67Vm/tqbx
	Ums1cEJpw4mtbsqNRct0aqje1A7P5vSkTnHc+fS3QWiUs2qVuj+2xMW1AvuwrNdmB+484f
	4fpTxH80/K6nA1wMgX7UmxXL6KbJYvE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-84-hBsytj49Mb6mgCDY2lO0Aw-1; Sat, 06 May 2023 02:29:29 -0400
X-MC-Unique: hBsytj49Mb6mgCDY2lO0Aw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70CFD1C05AF3;
	Sat,  6 May 2023 06:29:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5DAE6492B01;
	Sat,  6 May 2023 06:29:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2BBF91946588;
	Sat,  6 May 2023 06:29:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 357951946586
 for <dm-devel@listman.corp.redhat.com>; Sat,  6 May 2023 06:29:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 26A571121315; Sat,  6 May 2023 06:29:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EEBA1121314
 for <dm-devel@redhat.com>; Sat,  6 May 2023 06:29:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F28F3281424D
 for <dm-devel@redhat.com>; Sat,  6 May 2023 06:29:24 +0000 (UTC)
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com
 [209.85.215.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-dToab9vYOLeDeic7e4aGjg-1; Sat, 06 May 2023 02:29:23 -0400
X-MC-Unique: dToab9vYOLeDeic7e4aGjg-1
Received: by mail-pg1-f175.google.com with SMTP id
 41be03b00d2f7-51452556acdso1657924a12.2
 for <dm-devel@redhat.com>; Fri, 05 May 2023 23:29:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1683354562; x=1685946562;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=/WfFr/Ybkjxxlz0qBx9KvOEXPiQmOGJ7KxenW4nxces=;
 b=DX8LGgpkVnl3F/qFTX7sSx3tdmBH1DybxdoRZGscHyiWbc9HFv4hSKI1M5r72V+/0B
 Xzdr3eEd6zNhVCPRx1Ekou5R2aX6Y6Wyjn0V0ms0djl1R4cqo69B2PdCFhfmbp998/HM
 YFLIQT8BETWGLF9/2RAbkqDLDCaqXTBKZ5CchayMJq8do+EKDGmntaWzDc5E2K1SMqcR
 OWL/VPkW8QYxTfWPIgTdy3Vi/GUtbVQp6aWDRBEELdF5LRoLGT3Sd7NcJ5vGEszH23op
 yr6iTZknPltAK9WsFBWTK5gRCdSqoS9z+uruNk9Qfw18kocdLgPmIEzXq5VBZwt8eswD
 5rfg==
X-Gm-Message-State: AC+VfDy5X502n/P/xJJszUNmyAZI1AM8RTmXv/iNTXvaWT5b2orR1H3C
 ntjnCweqtiV0etpgufKwMvX1ALGSPn26PpVZq8U=
X-Google-Smtp-Source: ACHHUZ7OAUraDBnWZXSPqOYiIq8qtM/wfnvjpq6zwOo0KtFQaZ+pcntbtfauYsJHK69Wtp4Otp15eA==
X-Received: by 2002:a17:903:120d:b0:1a5:2993:8aa6 with SMTP id
 l13-20020a170903120d00b001a529938aa6mr4399812plh.63.1683354561829; 
 Fri, 05 May 2023 23:29:21 -0700 (PDT)
Received: from sarthakkukreti-glaptop.hsd1.ca.comcast.net
 ([2601:647:4200:b5b0:f19c:a713:5517:ed4])
 by smtp.gmail.com with ESMTPSA id
 q16-20020a170902dad000b001ac381f1ce9sm2793598plx.185.2023.05.05.23.29.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 05 May 2023 23:29:21 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Date: Fri,  5 May 2023 23:29:05 -0700
Message-ID: <20230506062909.74601-2-sarthakkukreti@chromium.org>
In-Reply-To: <20230506062909.74601-1-sarthakkukreti@chromium.org>
References: <20230420004850.297045-1-sarthakkukreti@chromium.org>
 <20230506062909.74601-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH v6 1/5] block: Don't invalidate pagecache for
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
 Mike Snitzer <snitzer@kernel.org>, stable@vger.kernel.org,
 Christoph Hellwig <hch@infradead.org>,
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

Only call truncate_bdev_range() if the fallocate mode is
supported. This fixes a bug where data in the pagecache
could be invalidated if the fallocate() was called on the
block device with an invalid mode.

Fixes: 25f4c41415e5 ("block: implement (some of) fallocate for block devices")
Cc: stable@vger.kernel.org
Reported-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
---
 block/fops.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index d2e6be4e3d1c..4c70fdc546e7 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -648,24 +648,35 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 
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
+		error = truncate_bdev_range(bdev, file->f_mode, start, end);
+		if (error)
+			goto fail;
+
 		error = blkdev_issue_zeroout(bdev, start >> SECTOR_SHIFT,
 					     len >> SECTOR_SHIFT, GFP_KERNEL,
 					     BLKDEV_ZERO_NOUNMAP);
 		break;
 	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE:
+		error = truncate_bdev_range(bdev, file->f_mode, start, end);
+		if (error)
+			goto fail;
+
 		error = blkdev_issue_zeroout(bdev, start >> SECTOR_SHIFT,
 					     len >> SECTOR_SHIFT, GFP_KERNEL,
 					     BLKDEV_ZERO_NOFALLBACK);
 		break;
 	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE | FALLOC_FL_NO_HIDE_STALE:
+		error = truncate_bdev_range(bdev, file->f_mode, start, end);
+		if (error)
+			goto fail;
+
 		error = blkdev_issue_discard(bdev, start >> SECTOR_SHIFT,
 					     len >> SECTOR_SHIFT, GFP_KERNEL);
 		break;
-- 
2.40.1.521.gf1e218fcd8-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


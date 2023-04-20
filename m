Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A903AC77B72
	for <dm-devel@archiver.kernel.org>; Thu, 20 Apr 2023 17:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682011710;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nHTTnsEfG/kRbAFbe8uzd2QqusIF/lB7kkmKNOFh1l8=;
	b=imqWS0aWckV943crWK7jJCkRH1BmMbcQZe141E8uM4vKsV7XnHSFHg3MZlzoZB9JOPNmOV
	Xv35jgde3wW2LNclYGFSIQlOZxnYIa1vHT9vnUJe4u4YmEyECM6ACR+B48pGKYuuEPbxdC
	GBpEzliyPKGA84fNJ5WWZaQGB70ZZqM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-LTbimyFmMbe4gs-3KkasZA-1; Thu, 20 Apr 2023 13:28:29 -0400
X-MC-Unique: LTbimyFmMbe4gs-3KkasZA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E65B5811E7B;
	Thu, 20 Apr 2023 17:28:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9DA952026D16;
	Thu, 20 Apr 2023 17:28:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5F3411946A40;
	Thu, 20 Apr 2023 17:28:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7621319466DF
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Apr 2023 17:28:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 58162492B00; Thu, 20 Apr 2023 17:28:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 50F41492C3E
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 17:28:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35D223C0C8A3
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 17:28:24 +0000 (UTC)
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com
 [209.85.210.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-fNVEBPmCM3WFZjz-PcWJPA-1; Thu, 20 Apr 2023 13:28:22 -0400
X-MC-Unique: fNVEBPmCM3WFZjz-PcWJPA-1
Received: by mail-pf1-f182.google.com with SMTP id
 d2e1a72fcca58-63b67a26069so1774790b3a.0
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 10:28:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1682011701; x=1684603701;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=3x8N7sxsFvg5b0uwbahj+PwbPcqRN9aSzyeMa7PrIzY=;
 b=Ql97cOD8ufq6rIhCWGXvUFfH8USabU9yTXw7EMKxBLbKNpspUEfoHHdS1Mlq9g48Ba
 Cuxy81M2AWy9B1jW+4jVE6F32+SKCjjNvez4p4Q75bbUQqYNQ6VPNPql+J+b+DxH+LDh
 j3dOc4pOFPjZZGl3dgNShg8bTqXGdbuh1q16S0Ybm5Mu/n72WTE0p1vuV1xJLhZb8y/V
 ZVk7BYUUSsZWm72Kp3XsY++cVSvUNTY4jM99R74aPRklNUmqStdT8CCSxfmbVSBHyCiD
 suKCQTy1DS7mOZbOilhnL5EfPHy7Ki9oFU+FFMWrJ0j3tlRjLfObVyG0vm2f6E1fgDD9
 NBXA==
X-Gm-Message-State: AAQBX9eTxORVhs6C+7CwWv+kfBlEZu/2B4DTt7VJglhWOc5Mtz8G0gBM
 ZfkI1ZDCRY7nEvj1itaBHqWuRlCzFPUHDj8TxxY=
X-Google-Smtp-Source: AKy350aamevL738b4lQu+r4Mb45ADgAjxr+szLfVa8OCWWSr0APnPjIlT0WZwrlfZ+8BR9m9vFOf1A==
X-Received: by 2002:a05:6a20:d38d:b0:f0:558b:8fbb with SMTP id
 iq13-20020a056a20d38d00b000f0558b8fbbmr2889057pzb.34.1682011700784; 
 Thu, 20 Apr 2023 10:28:20 -0700 (PDT)
Received: from sarthakkukreti-glaptop.hsd1.ca.comcast.net
 ([2601:647:4200:b5b0:42d9:debc:8d41:e6c4])
 by smtp.gmail.com with ESMTPSA id
 t9-20020a6549c9000000b0051b3ef1295csm1360372pgs.53.2023.04.20.10.28.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 20 Apr 2023 10:28:20 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Date: Thu, 20 Apr 2023 10:28:07 -0700
Message-ID: <20230420172807.323150-1-sarthakkukreti@chromium.org>
In-Reply-To: <ZEFmS9h81Wwlv9+/@redhat.com>
References: <ZEFmS9h81Wwlv9+/@redhat.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
 Mike Snitzer <snitzer@kernel.org>, stable@vger.kernel.org,
 Christoph Hellwig <hch@infradead.org>,
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
Cc: stable@vger.kernel.org
Reported-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
---
 block/fops.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index d2e6be4e3d1c..20b1eddcbe25 100644
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
+		if (!error)
+			goto fail;
+
 		error = blkdev_issue_discard(bdev, start >> SECTOR_SHIFT,
 					     len >> SECTOR_SHIFT, GFP_KERNEL);
 		break;
-- 
2.40.0.396.gfff15efe05-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B705E94139
	for <dm-devel@archiver.kernel.org>; Sat,  7 Oct 2023 01:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696642141;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HcFjBQb2hq2sGfh9w07VCF7PT1cALaIXoQp7PZM6Vlk=;
	b=P5vXlxxxkvnHzxHREYRZq3HZFJz0eUknsGpMjWspS4Y+9B6CaOPZidji9hRMKi2OegHoLJ
	5qtMj0JiwZeE8Q+Nw85Nbx34LnSgtwSAXEFOnFaG89tjFDIJ64mcV7mj+Jju1Z7tA5XBq/
	PHZ1lz7se0vsKF66g0c7Bmo+2B+U4Rg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-0srYIhn3NDmINfdV9RhBBg-1; Fri, 06 Oct 2023 21:28:48 -0400
X-MC-Unique: 0srYIhn3NDmINfdV9RhBBg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC20E3C0F370;
	Sat,  7 Oct 2023 01:28:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CC6A842485F;
	Sat,  7 Oct 2023 01:28:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AB3031946589;
	Sat,  7 Oct 2023 01:28:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D61A51946588
 for <dm-devel@listman.corp.redhat.com>; Sat,  7 Oct 2023 01:28:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B56FEC158BA; Sat,  7 Oct 2023 01:28:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AD484C15BB8
 for <dm-devel@redhat.com>; Sat,  7 Oct 2023 01:28:44 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (unknown
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85F323C0F378
 for <dm-devel@redhat.com>; Sat,  7 Oct 2023 01:28:44 +0000 (UTC)
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com
 [209.85.215.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-3epDXGGSPoaDwDBHDnKvkQ-1; Fri, 06 Oct 2023 21:28:27 -0400
X-MC-Unique: 3epDXGGSPoaDwDBHDnKvkQ-1
Received: by mail-pg1-f180.google.com with SMTP id
 41be03b00d2f7-58d261807e8so6017a12.2
 for <dm-devel@redhat.com>; Fri, 06 Oct 2023 18:28:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696642106; x=1697246906;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=rQNnXBnSwzfsN2zrI7/k3aUY1SO1WpMoDwjEZpkrIxM=;
 b=EBYYdjWgKnbktqiaQxHtGfTkof2ffuQfxQC6cVxFROqWnqh3KK9LPgWp16ISfrfNYJ
 RvLtnIRiFNfY+sZuWTJ8v7QQ1MkoQGIZF+okN/g7XQsVE4wsL4WbhPc8Z6bQZZ5sD11u
 fSZMAah8E/CusDhA0SOdESAWgJyJ0zcQdAIoHKcY4eVhGKG9Xf4+aR33modOApxIDInV
 O7a5BS0SPT9Nkmz/ZUvkCmNGpbr5ybO51EltHmjlRGlBeOKCFNIJY2RZ+St+ULGw7uOp
 ftiE7jLpXtpA8E73ERzo9lHonDprH7A6Wqxdq7wLpR5PpkrD/hwNlnZrssW73BX+8dk7
 WzXg==
X-Gm-Message-State: AOJu0Yypbx7oN7fJhnQ2JtVm0DOEEWsDF/j7Zr3cayX8jSDWvToRnF7e
 9scS9VqS+S5CIWhEbeLB9StLd3nV1n5vAo8ClNQ=
X-Google-Smtp-Source: AGHT+IFgSpdJXRlHpObTlC1ba3rWEGA93CD9bVltNHco7wy1/jSBrQ0keIe/jvsDstn28NxLhH5baA==
X-Received: by 2002:a05:6a20:9699:b0:161:2bed:6b36 with SMTP id
 hp25-20020a056a20969900b001612bed6b36mr8700355pzc.31.1696642106158; 
 Fri, 06 Oct 2023 18:28:26 -0700 (PDT)
Received: from localhost ([2620:15c:9d:2:138c:8976:eb4a:a91c])
 by smtp.gmail.com with UTF8SMTPSA id
 kx14-20020a170902f94e00b001ab39cd875csm4580815plb.133.2023.10.06.18.28.24
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 06 Oct 2023 18:28:25 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Date: Fri,  6 Oct 2023 18:28:13 -0700
Message-ID: <20231007012817.3052558-2-sarthakkukreti@chromium.org>
In-Reply-To: <20231007012817.3052558-1-sarthakkukreti@chromium.org>
References: <20231007012817.3052558-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH v8 1/5] block: Don't invalidate pagecache for
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
Cc: Jens Axboe <axboe@kernel.dk>, Dave Chinner <david@fromorbit.com>,
 Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <djwong@kernel.org>,
 Brian Foster <bfoster@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, stable@vger.kernel.org,
 Christoph Hellwig <hch@infradead.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Sarthak Kukreti <sarthakkukreti@chromium.org>, Christoph Hellwig <hch@lst.de>,
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 block/fops.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index acff3d5d22d4..73e42742543f 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -772,24 +772,35 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 
 	filemap_invalidate_lock(inode->i_mapping);
 
-	/* Invalidate the page cache, including dirty pages. */
-	error = truncate_bdev_range(bdev, file_to_blk_mode(file), start, end);
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
+		error = truncate_bdev_range(bdev, file_to_blk_mode(file), start, end);
+		if (error)
+			goto fail;
+
 		error = blkdev_issue_zeroout(bdev, start >> SECTOR_SHIFT,
 					     len >> SECTOR_SHIFT, GFP_KERNEL,
 					     BLKDEV_ZERO_NOUNMAP);
 		break;
 	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE:
+		error = truncate_bdev_range(bdev, file_to_blk_mode(file), start, end);
+		if (error)
+			goto fail;
+
 		error = blkdev_issue_zeroout(bdev, start >> SECTOR_SHIFT,
 					     len >> SECTOR_SHIFT, GFP_KERNEL,
 					     BLKDEV_ZERO_NOFALLBACK);
 		break;
 	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE | FALLOC_FL_NO_HIDE_STALE:
+		error = truncate_bdev_range(bdev, file_to_blk_mode(file), start, end);
+		if (error)
+			goto fail;
+
 		error = blkdev_issue_discard(bdev, start >> SECTOR_SHIFT,
 					     len >> SECTOR_SHIFT, GFP_KERNEL);
 		break;
-- 
2.42.0.609.gbb76f46606-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


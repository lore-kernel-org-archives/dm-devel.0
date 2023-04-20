Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 356F1C6FD18
	for <dm-devel@archiver.kernel.org>; Thu, 20 Apr 2023 00:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681951745;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OcWgEtW66LPBGpuc07HMpPGjW93DWs+YP2zwP288a8o=;
	b=R2kgn9HkBjcRUqNegVn3pWaCWweJkZuoGyDIQacS43GMQsAzbY4QQ64GsOyPBD1PvNetFx
	yC19j7neGKtRVD0RKJWDUXmvr+Bt20Ik0XpDAbDM8cyiKr+IUmJs2iacQI+n6Ynmnbub3O
	1bLLk5mo6RLIAXvLZsEY/jb20n8W2mw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-L1crD2FYO2yLSHDryC968A-1; Wed, 19 Apr 2023 20:49:03 -0400
X-MC-Unique: L1crD2FYO2yLSHDryC968A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D7DF811E7C;
	Thu, 20 Apr 2023 00:49:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5AE29492C3F;
	Thu, 20 Apr 2023 00:49:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3A83E19465B9;
	Thu, 20 Apr 2023 00:49:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 25E0419465B5
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Apr 2023 00:49:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1AB091410F21; Thu, 20 Apr 2023 00:49:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 11CA81410F20
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 00:49:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB0DB101A556
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 00:48:59 +0000 (UTC)
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com
 [209.85.210.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-306-RkHfO5G6NuaO7YO89SjW7A-1; Wed, 19 Apr 2023 20:48:58 -0400
X-MC-Unique: RkHfO5G6NuaO7YO89SjW7A-1
Received: by mail-pf1-f174.google.com with SMTP id
 d2e1a72fcca58-63b7096e2e4so457783b3a.2
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 17:48:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681951737; x=1684543737;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=G8Jg49/KQsZt4WzBpHKtXWTZpexlXZcV39964TwtkKY=;
 b=U6P5BWHDDYtHbb98oVBpqDTDj7qj2MPPv8VJId6vr4bSw6MhV5RudJ3NK6X39hlVYu
 /XAzXcwbODYDAr9WoDoq57K0ufxkX5A0Ok34ynCTyUaHrZedXLxFmMOFC3W+/I0CrXQU
 RHOHimonMCB40p31mE6b+kjOR2SRmOepmL2N4wZDvFBpBpbmfiBfEDl9wyb1Y/oJHmQ8
 AKkLQsE1C+JBx7kmQH7gzVfyU0e/eSSOuK+o2jYFCsueJ66JBYD9FvW7QsqziZKi2Ay8
 FnBbohZVHrtY3IgGHJ7WoNcBkGngnxM+wbvlZ+jWNF3ZeLUbIt6rlLJNXZD4a4JEO6Ka
 It/A==
X-Gm-Message-State: AAQBX9esmPWEwDjfO5pijncnsEdQ8CgkRLtWo41/goaQHvw14eSRhbXM
 SYMXzfgmIev41xe774davB15xckoBXYwolMhKFo=
X-Google-Smtp-Source: AKy350Zv7+C4nbn5BKw2snuixQns/eVqKDeE09iyFz2LG4XBGopEf6DRHNtYzyNhmmireBFKIpsriQ==
X-Received: by 2002:a17:902:ea0f:b0:19c:b11b:ffca with SMTP id
 s15-20020a170902ea0f00b0019cb11bffcamr8862265plg.23.1681951736959; 
 Wed, 19 Apr 2023 17:48:56 -0700 (PDT)
Received: from sarthakkukreti-glaptop.corp.google.com
 ([2620:15c:9d:200:5113:a333:10ce:e2d])
 by smtp.gmail.com with ESMTPSA id
 io18-20020a17090312d200b001a65575c13asm74323plb.48.2023.04.19.17.48.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 19 Apr 2023 17:48:56 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Date: Wed, 19 Apr 2023 17:48:46 -0700
Message-ID: <20230420004850.297045-2-sarthakkukreti@chromium.org>
In-Reply-To: <20230420004850.297045-1-sarthakkukreti@chromium.org>
References: <20230414000219.92640-1-sarthakkukreti@chromium.org>
 <20230420004850.297045-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH v5 1/5] block: Don't invalidate pagecache for
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
Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
---
 block/fops.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index d2e6be4e3d1c..2fd7e8b9ab48 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -648,25 +648,27 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 
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
+		error = truncate_bdev_range(bdev, file->f_mode, start, end) ||
+			blkdev_issue_zeroout(bdev, start >> SECTOR_SHIFT,
 					     len >> SECTOR_SHIFT, GFP_KERNEL,
 					     BLKDEV_ZERO_NOUNMAP);
 		break;
 	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE:
-		error = blkdev_issue_zeroout(bdev, start >> SECTOR_SHIFT,
+		error = truncate_bdev_range(bdev, file->f_mode, start, end) ||
+			blkdev_issue_zeroout(bdev, start >> SECTOR_SHIFT,
 					     len >> SECTOR_SHIFT, GFP_KERNEL,
 					     BLKDEV_ZERO_NOFALLBACK);
 		break;
 	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE | FALLOC_FL_NO_HIDE_STALE:
-		error = blkdev_issue_discard(bdev, start >> SECTOR_SHIFT,
+		error = truncate_bdev_range(bdev, file->f_mode, start, end) ||
+			blkdev_issue_discard(bdev, start >> SECTOR_SHIFT,
 					     len >> SECTOR_SHIFT, GFP_KERNEL);
 		break;
 	default:
-- 
2.40.0.634.g4ca3ef3211-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


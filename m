Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80A79C77B72
	for <dm-devel@archiver.kernel.org>; Thu, 20 Apr 2023 18:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682014575;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=V32As65SoxU5BJLkArUTF89wChj/AmhVZ0Hgr7P5xHM=;
	b=KYKYVS7qpy2UtH8MT4WhDTN8iuxVFX+goRpBE02uB56FLCfDX3oUWsKTeEhhW/H3yWFvXP
	khGEPNfn7Ghf6GiUPP4woiFB5302vdflU5K58Ru+KAUyDnLPp4TQ/5ZlNrcLMNbg4CuZ6Z
	HKLFnXjs2j3PI7lK4VyZpsbLaOtGeIk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-20--dxYW5iqMwKHaX4iVqoimA-1; Thu, 20 Apr 2023 14:16:11 -0400
X-MC-Unique: -dxYW5iqMwKHaX4iVqoimA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73E4E3815EF3;
	Thu, 20 Apr 2023 18:16:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1DCFE51E3;
	Thu, 20 Apr 2023 18:16:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C89DF1946A40;
	Thu, 20 Apr 2023 18:15:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6A7CC19466DF
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Apr 2023 18:15:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 81DC740BC798; Thu, 20 Apr 2023 18:15:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A0D040BC79A
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 18:15:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B1A3800B35
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 18:15:47 +0000 (UTC)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
 [209.85.216.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-zrApUewqMjaR6SHs-5KMow-1; Thu, 20 Apr 2023 14:15:45 -0400
X-MC-Unique: zrApUewqMjaR6SHs-5KMow-1
Received: by mail-pj1-f51.google.com with SMTP id
 98e67ed59e1d1-24781e23c27so1141228a91.0
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 11:15:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1682014544; x=1684606544;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=jdrDhaZEOy+UKGsi82P8bV8Exkli2SlfWKGwO5/v5to=;
 b=jNt2hyLQoQDMxAfwO+1b0ilp1ZPAFPkmeDZiVcrYX8YK4hDrP01HwPfSkNjNJqgS/0
 u6bCaIeGcfUxdF/2sMU1zqV6wguazGhPISfliLi4VpJsUB58JG0Ih4Rsh8fk+DAxsBxw
 xFx2CvsSER0TW6m1c+fzq6ERqyATIuVGiYPLfo8j92L2jX9asn+VYcliXzBUf7D76N7p
 mzH8sLVTIVNOx6j3vHlT2BkdgFzYzNkEPOM/OCi2Cu64/yco2Pv0a60d6qPVlAzJQ03X
 sPPlWonl/vtwJBCMqYfnJCE3wnCnJbtmA7kz+Pyf2NmhF64w5WZ5bTzVatDpy7eqNP4l
 bK1A==
X-Gm-Message-State: AAQBX9eEABuxEocjzVfv8SNYERHuD7p1a50/ju4VahjIayHgmJlgCFa/
 eKGUm4w3QkK7XdJ/GakbHbmhvm18q0jRCjKPkOU=
X-Google-Smtp-Source: AKy350ZaDYxOz1KaCvteqlMJzUhYsjwN2ABUnz4TxRTY2yv//E9hm9d6g/BfyYrSik+PBwHYtByO3w==
X-Received: by 2002:a17:90a:4f0b:b0:247:1e13:90ef with SMTP id
 p11-20020a17090a4f0b00b002471e1390efmr2574129pjh.20.1682014544026; 
 Thu, 20 Apr 2023 11:15:44 -0700 (PDT)
Received: from sarthakkukreti-glaptop.hsd1.ca.comcast.net
 ([2601:647:4200:b5b0:236d:acb8:49ac:b60a])
 by smtp.gmail.com with ESMTPSA id
 il7-20020a17090b164700b00247150f2091sm3373157pjb.8.2023.04.20.11.15.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 20 Apr 2023 11:15:43 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Date: Thu, 20 Apr 2023 11:15:40 -0700
Message-ID: <20230420181540.337203-1-sarthakkukreti@chromium.org>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
2.40.0.396.gfff15efe05-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


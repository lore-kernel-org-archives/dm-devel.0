Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9D46C3DA7C
	for <dm-devel@archiver.kernel.org>; Mon,  2 Jan 2023 07:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672645390;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zeLhSfivtLckslFk7UWSQPdtEC72ycB8rxGGjPfw8hk=;
	b=IhNCtfZfyy6RZACLbA4rlj+m6hXk2/TnM6V0r/47yM5h/73UBP7MJ8j6ZP1BAAewRf9Een
	Txqy4oMjwBkskTC6wVxxMYgVbYx14Fe0IQJRaUarsYm0tdY3D6GjdyN3jvgI4BEOH4vAx6
	5Ys0syhf1CWCu7HPN3NGurwko7S4mf0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-399-JWn-j_jwNzyVQcuL5Rhy3A-1; Mon, 02 Jan 2023 02:43:07 -0500
X-MC-Unique: JWn-j_jwNzyVQcuL5Rhy3A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50750857A86;
	Mon,  2 Jan 2023 07:43:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3B3AD2166B37;
	Mon,  2 Jan 2023 07:43:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 447041947061;
	Mon,  2 Jan 2023 07:43:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4F66E1946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 29 Dec 2022 08:13:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 32DF1112132D; Thu, 29 Dec 2022 08:13:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B5BA112132C
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 08:13:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C447101A521
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 08:13:09 +0000 (UTC)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
 [209.85.216.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-294-E-UkOD7OPGG3T6aXRU65tQ-1; Thu, 29 Dec 2022 03:13:07 -0500
X-MC-Unique: E-UkOD7OPGG3T6aXRU65tQ-1
Received: by mail-pj1-f48.google.com with SMTP id
 o1-20020a17090a678100b00219cf69e5f0so22271347pjj.2
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 00:13:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=97i6P/h7b+1gvIVRYO+DX34CDfR4Yqv0wh8jpsVN6uA=;
 b=2LHibui2YbNWIH8SE0ZP04hyjaT2ILtDYYTeH+ARLJ1i0wK1wYabXqyKr9/Tes9jCH
 YAeSKziDQHAb+qy7wY+rcZIb9A5kkyCoTseIKL1Qt7ZUqvi2+nTj8FfRgG/7Hv6IuLv0
 pO666S5UEwnQ3uFVJY04/auppQkiHaPK9b1v6wZyTOB+gFY1xMKbjuu9ZeUYpiFIV+5R
 GLqd/3oDyx6GsH5oizhn9uwacJVPD6nCgNdmXzCajJz91vEo5TXvg9iGwJlZRQ2cYo3u
 cRYbby8V0+c5pjCF7RFqV9t4N/WLbfDvHRKgeujV9RrGtZIVBikN3vprazsZm+cqLeGc
 +sCA==
X-Gm-Message-State: AFqh2kpLu8hZbLnnyDaWUF3ScoU/jDleiJ78jdhwhLf6sI2HkOjJpH1Y
 CfQPOXiUjp9z+9R4+qP0oRgNDw==
X-Google-Smtp-Source: AMrXdXuG8djGml0FmIoeHtIQvCDtglHyJ1RnAJ0w5NvdgLWhnB8c6w6P+S+xrI2iEBZecvFqN4EojA==
X-Received: by 2002:a17:902:9687:b0:192:9ab2:fd1c with SMTP id
 n7-20020a170902968700b001929ab2fd1cmr2910136plp.26.1672301586179; 
 Thu, 29 Dec 2022 00:13:06 -0800 (PST)
Received: from sarthakkukreti-glaptop.hsd1.ca.comcast.net
 ([2601:647:4200:b5b0:75ff:1277:3d7b:d67a])
 by smtp.gmail.com with ESMTPSA id
 12-20020a170902e9cc00b00192820d00d0sm6496325plk.120.2022.12.29.00.13.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 29 Dec 2022 00:13:05 -0800 (PST)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: sarthakkukreti@google.com, dm-devel@redhat.com,
 linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Thu, 29 Dec 2022 00:12:48 -0800
Message-Id: <20221229081252.452240-4-sarthakkukreti@chromium.org>
In-Reply-To: <20221229081252.452240-1-sarthakkukreti@chromium.org>
References: <20221229081252.452240-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Mon, 02 Jan 2023 07:42:59 +0000
Subject: [dm-devel] [PATCH v2 3/7] fs: Introduce FALLOC_FL_PROVISION
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

FALLOC_FL_PROVISION is a new fallocate() allocation mode that
sends a hint to (supported) thinly provisioned block devices to
allocate space for the given range of sectors via REQ_OP_PROVISION.

The man pages for both fallocate(2) and posix_fallocate(3) describe
the default allocation mode as:

```
The default operation (i.e., mode is zero) of fallocate()
allocates the disk space within the range specified by offset and len.
...
subsequent writes to bytes in the specified range are guaranteed
not to fail because of lack of disk space.
```

For thinly provisioned storage constructs (dm-thin, filesystems on sparse
files), the term 'disk space' is overloaded and can either mean the apparent
disk space in the filesystem/thin logical volume or the true disk
space that will be utilized on the underlying non-sparse allocation layer.

The use of a separate mode allows us to cleanly disambiguate whether fallocate()
causes allocation only at the current layer (default mode) or whether it propagates
allocations to underlying layers (provision mode) for thinly provisioned filesystems/
block devices. For devices that do not support REQ_OP_PROVISION, both these
allocation modes will be equivalent. Given the performance cost of sending provision
requests to the underlying layers, keeping the default mode as-is allows users to
preserve existing behavior.

Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
---
 block/fops.c                | 15 +++++++++++----
 include/linux/falloc.h      |  3 ++-
 include/uapi/linux/falloc.h |  8 ++++++++
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 50d245e8c913..01bde561e1e2 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -598,7 +598,8 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 #define	BLKDEV_FALLOC_FL_SUPPORTED					\
 		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
-		 FALLOC_FL_ZERO_RANGE | FALLOC_FL_NO_HIDE_STALE)
+		 FALLOC_FL_ZERO_RANGE | FALLOC_FL_NO_HIDE_STALE |	\
+		 FALLOC_FL_PROVISION)
 
 static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 			     loff_t len)
@@ -634,9 +635,11 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 	filemap_invalidate_lock(inode->i_mapping);
 
 	/* Invalidate the page cache, including dirty pages. */
-	error = truncate_bdev_range(bdev, file->f_mode, start, end);
-	if (error)
-		goto fail;
+	if (mode != FALLOC_FL_PROVISION) {
+		error = truncate_bdev_range(bdev, file->f_mode, start, end);
+		if (error)
+			goto fail;
+	}
 
 	switch (mode) {
 	case FALLOC_FL_ZERO_RANGE:
@@ -654,6 +657,10 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 		error = blkdev_issue_discard(bdev, start >> SECTOR_SHIFT,
 					     len >> SECTOR_SHIFT, GFP_KERNEL);
 		break;
+	case FALLOC_FL_PROVISION:
+		error = blkdev_issue_provision(bdev, start >> SECTOR_SHIFT,
+					       len >> SECTOR_SHIFT, GFP_KERNEL);
+		break;
 	default:
 		error = -EOPNOTSUPP;
 	}
diff --git a/include/linux/falloc.h b/include/linux/falloc.h
index f3f0b97b1675..b9a40a61a59b 100644
--- a/include/linux/falloc.h
+++ b/include/linux/falloc.h
@@ -30,7 +30,8 @@ struct space_resv {
 					 FALLOC_FL_COLLAPSE_RANGE |	\
 					 FALLOC_FL_ZERO_RANGE |		\
 					 FALLOC_FL_INSERT_RANGE |	\
-					 FALLOC_FL_UNSHARE_RANGE)
+					 FALLOC_FL_UNSHARE_RANGE |	\
+					 FALLOC_FL_PROVISION)
 
 /* on ia32 l_start is on a 32-bit boundary */
 #if defined(CONFIG_X86_64)
diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
index 51398fa57f6c..2d323d113eed 100644
--- a/include/uapi/linux/falloc.h
+++ b/include/uapi/linux/falloc.h
@@ -77,4 +77,12 @@
  */
 #define FALLOC_FL_UNSHARE_RANGE		0x40
 
+/*
+ * FALLOC_FL_PROVISION acts as a hint for thinly provisioned devices to allocate
+ * blocks for the range/EOF.
+ *
+ * FALLOC_FL_PROVISION can only be used with allocate-mode fallocate.
+ */
+#define FALLOC_FL_PROVISION		0x80
+
 #endif /* _UAPI_FALLOC_H_ */
-- 
2.37.3

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


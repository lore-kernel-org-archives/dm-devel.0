Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06673E95A8E
	for <dm-devel@archiver.kernel.org>; Sun,  8 Oct 2023 23:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696808496;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SWtGgtFZQ79q43gxIRuBPBLvzO7cEc1Nc8P964PZVog=;
	b=MD0CrRM8IaXRSfszcZRKcRZv5XMfgBkVLVWL06b9Ig7/UWNc6/mKDpjBaOWbmnGlMEOz4I
	4kFy5pxGO0rOZqGouf2zVSHxzA4ZMNj+tgT8GYwxUA5+pcsLqA4GdDq70z5i7L2l8XaDwA
	U0HxPUSMqEKynjiWvihCgClfUK+zyxQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-416-EtIW8Ea2Pa-ALfKAxaTREg-1; Sun, 08 Oct 2023 19:41:22 -0400
X-MC-Unique: EtIW8Ea2Pa-ALfKAxaTREg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2A05380670E;
	Sun,  8 Oct 2023 23:41:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B1A84140E953;
	Sun,  8 Oct 2023 23:41:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5EDB61946595;
	Sun,  8 Oct 2023 23:41:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 35ADB194658C
 for <dm-devel@listman.corp.redhat.com>; Sun,  8 Oct 2023 23:41:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1DF9F2156711; Sun,  8 Oct 2023 23:41:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 16646215670B
 for <dm-devel@redhat.com>; Sun,  8 Oct 2023 23:41:18 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2D138039C1
 for <dm-devel@redhat.com>; Sun,  8 Oct 2023 23:41:18 +0000 (UTC)
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com
 [209.85.160.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-576-QbCJbcxGOii-sEHuvA9tpg-1; Sun, 08 Oct 2023 19:41:16 -0400
X-MC-Unique: QbCJbcxGOii-sEHuvA9tpg-1
Received: by mail-oa1-f51.google.com with SMTP id
 586e51a60fabf-1d544a4a2f2so2743568fac.3
 for <dm-devel@redhat.com>; Sun, 08 Oct 2023 16:41:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696808476; x=1697413276;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=WhYJRI062pcX8jyWpJ2qutO3TNLI93kE5AesIBQ7T3Q=;
 b=AxNuhawBJRUt0BfiRVLB3rIeOImgLyPYjkvRN/aX2IUknT6LLnjtPxj8Zu0XZ+CFdR
 pNyP9urlQae1jalfxsRr9KLw44AzYakzA/PDU7RUk61/+UH4N7Rr3BUZngA4QS41Eaj0
 88APIUV3R4h5c+yieeZJGniUbxO8vjbHSQcPdcM1WW1FpnvEK4yHiA11L+XB6898FDPn
 ziqEwfLVTyKBQUFdbnv7lVl08SPpjVXwLfhlTXtsqewcgFjidKb1Fsq07CSkIMdKecco
 DG5xBXh071adzfKyCtltgByLazCunOpgSIV+UHXuQoq5FtND7UBLZTATC8QO1YBU01hx
 L2Rg==
X-Gm-Message-State: AOJu0YzyvqtTW7ISBFLPiixxbtbYutnkYZTfl3FqRU0q8WHs15FbxsdM
 KBfB46WH/z5GJRIKWvTt73AraQ==
X-Google-Smtp-Source: AGHT+IEzdfSk/TfN3oKWe+ZCwTpXTbsQop8JnwDS51200ueprTMLUFr7+5xNPnWdiMt6htdwMZNbVg==
X-Received: by 2002:a05:6870:2050:b0:1dd:67a6:ed75 with SMTP id
 l16-20020a056870205000b001dd67a6ed75mr16462942oad.44.1696808475832; 
 Sun, 08 Oct 2023 16:41:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au.
 [49.180.20.59]) by smtp.gmail.com with ESMTPSA id
 x14-20020aa784ce000000b0068fb5e44827sm5000804pfn.67.2023.10.08.16.41.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 08 Oct 2023 16:41:15 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1qpdOb-00BI8g-18;
 Mon, 09 Oct 2023 10:41:13 +1100
Date: Mon, 9 Oct 2023 10:41:13 +1100
From: Dave Chinner <david@fromorbit.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZSM+Ge1YTtx935W9@dread.disaster.area>
References: <20231007012817.3052558-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20231007012817.3052558-1-sarthakkukreti@chromium.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [RFC PATCH 6/5] xfs: detect block devices requiring
 provisioning
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <djwong@kernel.org>,
 Brian Foster <bfoster@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

Block device provisioning detection infrastructure.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c   |  2 ++
 fs/xfs/xfs_buf.h   |  1 +
 fs/xfs/xfs_mount.h | 11 ++++++++++-
 fs/xfs/xfs_super.c |  4 ++++
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index c1ece4a08ff4..f37edae6e68e 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2014,6 +2014,8 @@ xfs_alloc_buftarg(
 	btp->bt_bdev = bdev;
 	btp->bt_daxdev = fs_dax_get_by_bdev(bdev, &btp->bt_dax_part_off,
 					    mp, ops);
+	if (bdev_max_provision_sectors(bdev))
+		btp->bt_needs_provisioning = true;
 
 	/*
 	 * Buffer IO error rate limiting. Limit it to no more than 10 messages
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index df8f47953bb4..1719a8fce49f 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -106,6 +106,7 @@ typedef struct xfs_buftarg {
 	size_t			bt_meta_sectormask;
 	size_t			bt_logical_sectorsize;
 	size_t			bt_logical_sectormask;
+	bool			bt_needs_provisioning;
 
 	/* LRU control structures */
 	struct shrinker		bt_shrinker;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index d19cca099bc3..f1eec563c61d 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -407,6 +407,13 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
 #define XFS_OPSTATE_WARNED_LARP		9
 /* Mount time quotacheck is running */
 #define XFS_OPSTATE_QUOTACHECK_RUNNING	10
+/*
+ * If the block device underlying either the data or rt volume needs
+ * provisioning to guarantee space availability, this flag will be set.
+ * Operations that need to check, issue or free provisioning trigger off
+ * this flag.
+ */
+#define XFS_OPSTATE_PROVISION_BLOCKS	11
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
@@ -434,6 +441,7 @@ __XFS_IS_OPSTATE(quotacheck_running, QUOTACHECK_RUNNING)
 #else
 # define xfs_is_quotacheck_running(mp)	(false)
 #endif
+__XFS_IS_OPSTATE(provisioning_blocks, PROVISION_BLOCKS)
 
 static inline bool
 xfs_should_warn(struct xfs_mount *mp, long nr)
@@ -452,7 +460,8 @@ xfs_should_warn(struct xfs_mount *mp, long nr)
 	{ (1UL << XFS_OPSTATE_WARNED_SCRUB),		"wscrub" }, \
 	{ (1UL << XFS_OPSTATE_WARNED_SHRINK),		"wshrink" }, \
 	{ (1UL << XFS_OPSTATE_WARNED_LARP),		"wlarp" }, \
-	{ (1UL << XFS_OPSTATE_QUOTACHECK_RUNNING),	"quotacheck" }
+	{ (1UL << XFS_OPSTATE_QUOTACHECK_RUNNING),	"quotacheck" }, \
+	{ (1UL << XFS_OPSTATE_PROVISION_BLOCKS),	"provision" }
 
 /*
  * Max and min values for mount-option defined I/O
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 819a3568b28f..a5b15ddfb31e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -471,11 +471,15 @@ xfs_open_devices(
 	mp->m_ddev_targp = xfs_alloc_buftarg(mp, ddev);
 	if (!mp->m_ddev_targp)
 		goto out_close_rtdev;
+	if (mp->m_ddev_targp->bt_needs_provisioning)
+		xfs_set_provisioning_blocks(mp);
 
 	if (rtdev) {
 		mp->m_rtdev_targp = xfs_alloc_buftarg(mp, rtdev);
 		if (!mp->m_rtdev_targp)
 			goto out_free_ddev_targ;
+		if (mp->m_rtdev_targp->bt_needs_provisioning)
+			xfs_set_provisioning_blocks(mp);
 	}
 
 	if (logdev && logdev != ddev) {

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


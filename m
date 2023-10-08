Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB0C8E95A8E
	for <dm-devel@archiver.kernel.org>; Sun,  8 Oct 2023 23:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696808736;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4JLqQ7OfyYupFDyJlSmCIt17XnKnsnoQjMDXNH8mi2M=;
	b=iZHhQmKK9yVszjw843ukahOGe8l3fPg7oZZMBd6nl7m0yWc3CXBNlkIjoPqXCLTtrEf1gS
	yLygeNhvlrZCUNtUzFWartZBMYRrTuOF3NsAyYgt2Wgv9reN9tQ5cXlBTsTRDmI8tTk5SH
	+exM0Z+4C0zT3ZTSE+oiV9bQJihvON4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-29-oADOvNWlPTedifEtKmownQ-1; Sun, 08 Oct 2023 19:45:33 -0400
X-MC-Unique: oADOvNWlPTedifEtKmownQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 963678007A4;
	Sun,  8 Oct 2023 23:45:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3BAFC400F36;
	Sun,  8 Oct 2023 23:45:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 06A0D1946595;
	Sun,  8 Oct 2023 23:45:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6CC67194658C
 for <dm-devel@listman.corp.redhat.com>; Sun,  8 Oct 2023 23:45:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 57397175B5; Sun,  8 Oct 2023 23:45:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E61F170E4
 for <dm-devel@redhat.com>; Sun,  8 Oct 2023 23:45:30 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 307B385A5BA
 for <dm-devel@redhat.com>; Sun,  8 Oct 2023 23:45:30 +0000 (UTC)
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com
 [209.85.167.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-epAJfkaDMPOuqh9V6pqygQ-1; Sun, 08 Oct 2023 19:45:21 -0400
X-MC-Unique: epAJfkaDMPOuqh9V6pqygQ-1
Received: by mail-oi1-f176.google.com with SMTP id
 5614622812f47-3af6cd01323so2844975b6e.3
 for <dm-devel@redhat.com>; Sun, 08 Oct 2023 16:45:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696808721; x=1697413521;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=iIUGA5nyGTXIkeVMBhQE5fUan1nQD7xdjAl3FqxZfHs=;
 b=ugsPX9BWU+bWl4BrU6AuMrZiD9ixY9jv5+VuLlYdaR0LdckQADRf1wRTI4jqmsjFJ4
 ny3fCuDa6AGXKF2WBNjtMuDa6nZPigZDTffma0hv6Ni38Kzp6oVgLmqYYiAxMAkfUhZi
 NZ3zZw3AFFe8lLGsUPkNKTlBAVjU0tnFTje9OPrwh134duhOf0OT/vjTj4xL1jcFT5oS
 wzfkneM5020m54+eZmPkG1hYY942bbtw3cFwVug+FEuX8TTt1OkRG83I/17tHJ/H5z4l
 tWs9GTqB3v1Xh/gL4nVTYNG14EKV9168bA1vWTRkW0f1yO9PebbyVRKv5Wlmrx0VKGIX
 2C1Q==
X-Gm-Message-State: AOJu0YxMmfUBBxDKvv03IKNc8ypR9I3cSwhLJF+bmW06paSXlxnpaBVc
 qVbYJnFujtFt/AUOpmUOC1Is3g==
X-Google-Smtp-Source: AGHT+IE4ZtKoa5V64XLddUAQlfgY0O4kC79VmJ41/fARv+skVul5l6HD62OAku+HYlksQ55wgVACwg==
X-Received: by 2002:a05:6808:1406:b0:3ae:108c:57b3 with SMTP id
 w6-20020a056808140600b003ae108c57b3mr20743909oiv.39.1696808720820; 
 Sun, 08 Oct 2023 16:45:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au.
 [49.180.20.59]) by smtp.gmail.com with ESMTPSA id
 19-20020aa79153000000b0069353ac3d38sm5090447pfi.69.2023.10.08.16.45.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 08 Oct 2023 16:45:20 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1qpdSY-00BIBn-0I;
 Mon, 09 Oct 2023 10:45:18 +1100
Date: Mon, 9 Oct 2023 10:45:18 +1100
From: Dave Chinner <david@fromorbit.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZSM/Dvr1LWICYd2C@dread.disaster.area>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [RFC PATCH 7/5] xfs: add block device provisioning for
 fallocate
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

Provision space in the block device for preallocated file space when
userspace asks for it. Make sure to do this outside of transaction
context so it can fail without causing a filesystem shutdown.

XXX: async provisioning submission/completion interface would be
really useful here....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 42 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index fcefab687285..5dddd1e7bc47 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -772,6 +772,37 @@ xfs_free_eofblocks(
 	return error;
 }
 
+static int
+xfs_bmap_provision_blocks(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*imap,
+	int			nimaps)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_buftarg	*target;
+	int			i;
+
+	if (!xfs_is_provisioning_blocks(mp))
+		return 0;
+
+	target = xfs_inode_buftarg(ip);
+	if (!target->bt_needs_provisioning)
+		return 0;
+
+	for (i = 0; i < nimaps; i++) {
+		int	error;
+
+		error = blkdev_issue_provision(target->bt_bdev,
+				XFS_FSB_TO_DADDR(mp, imap->br_startblock),
+				XFS_FSB_TO_BB(mp, imap->br_blockcount),
+				GFP_KERNEL, 0);
+		ASSERT(error != -EOPNOTSUPP);
+		if (error)
+			return error;
+	}
+	return 0;
+}
+
 int
 xfs_alloc_file_space(
 	struct xfs_inode	*ip,
@@ -780,7 +811,6 @@ xfs_alloc_file_space(
 {
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_off_t		count;
-	xfs_filblks_t		allocated_fsb;
 	xfs_filblks_t		allocatesize_fsb;
 	xfs_extlen_t		extsz, temp;
 	xfs_fileoff_t		startoffset_fsb;
@@ -884,15 +914,17 @@ xfs_alloc_file_space(
 		if (error)
 			break;
 
-		allocated_fsb = imapp->br_blockcount;
-
 		if (nimaps == 0) {
 			error = -ENOSPC;
 			break;
 		}
 
-		startoffset_fsb += allocated_fsb;
-		allocatesize_fsb -= allocated_fsb;
+		error = xfs_bmap_provision_blocks(ip, imapp, nimaps);
+		if (error)
+			break;
+
+		startoffset_fsb += imapp->br_blockcount;
+		allocatesize_fsb -= imapp->br_blockcount;
 	}
 
 	return error;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


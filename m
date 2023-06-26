Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3340EB64D9
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jun 2023 20:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687811215;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=z2w5A4gbBJNjGyW2xH9rzlNYpsZN2xumUcjbnwucDbI=;
	b=DOFZqC+dBxLfs3xBSqKSTgyfNHHH8/dMYrNUXDd8g+8Y4M/EY56SxEJ+E1he/9MGYmQHCh
	uy3fhB7UODyjwR+vxV+MPdE5zMJckyBbDz7eMiIt7jVmp+5goPKmrLJfJfAa1OEVCjJbBC
	i1m/BsWPDuvfA4hKyZqqmJm+BztVmmk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-1QNPJw6aP_6pXfe3fIbeOg-1; Mon, 26 Jun 2023 16:26:43 -0400
X-MC-Unique: 1QNPJw6aP_6pXfe3fIbeOg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3103418E0BCB;
	Mon, 26 Jun 2023 20:25:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F16DE1121319;
	Mon, 26 Jun 2023 20:25:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BFD431946588;
	Mon, 26 Jun 2023 20:25:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CF7F91946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 26 Jun 2023 20:25:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 91CB015230A1; Mon, 26 Jun 2023 20:25:28 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 835D215230A0;
 Mon, 26 Jun 2023 20:25:28 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id 6EF2030C045B; Mon, 26 Jun 2023 20:25:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 66F8A3FB76; Mon, 26 Jun 2023 22:25:28 +0200 (CEST)
Date: Mon, 26 Jun 2023 22:25:28 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <1a33ace-57f9-9ef9-b967-d6617ca33089@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH] block: flush the disk cache on BLKFLSBUF
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
Cc: linux-block@vger.kernel.org, Marc Smith <msmith626@gmail.com>,
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The BLKFLSBUF ioctl doesn't send the flush bio to the block device, thus
flushed data may be lurking in the disk cache and they may not be really
flushed to the stable storage.

This patch adds the call to blkdev_issue_flush to blkdev_flushbuf.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/ioctl.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/block/ioctl.c
===================================================================
--- linux-2.6.orig/block/ioctl.c
+++ linux-2.6/block/ioctl.c
@@ -351,6 +351,7 @@ static int blkdev_flushbuf(struct block_
 		return -EACCES;
 	fsync_bdev(bdev);
 	invalidate_bdev(bdev);
+	blkdev_issue_flush(bdev);
 	return 0;
 }
 
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


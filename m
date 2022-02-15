Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2974AC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 11:02:37 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-qEZMUl-nMv2LbdLKYFfsKQ-1; Tue, 15 Feb 2022 06:02:33 -0500
X-MC-Unique: qEZMUl-nMv2LbdLKYFfsKQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2D61802925;
	Tue, 15 Feb 2022 11:02:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 84FAB78DE9;
	Tue, 15 Feb 2022 11:02:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 165634BB7C;
	Tue, 15 Feb 2022 11:02:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21FB2PEp014792 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Feb 2022 06:02:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 017FC401DB6; Tue, 15 Feb 2022 11:02:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F1F1E401DB0
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 11:02:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6F6D811E76
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 11:02:24 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-413-qg2LxjzhOkq__8rtU1IEZw-1; Tue, 15 Feb 2022 06:02:23 -0500
X-MC-Unique: qg2LxjzhOkq__8rtU1IEZw-1
Received: from [2001:4bb8:184:543c:6bdf:22f4:7f0a:fe97] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nJuiP-002E1A-AE; Tue, 15 Feb 2022 10:05:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Date: Tue, 15 Feb 2022 11:05:36 +0100
Message-Id: <20220215100540.3892965-2-hch@lst.de>
In-Reply-To: <20220215100540.3892965-1-hch@lst.de>
References: <20220215100540.3892965-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH 1/5] blk-mq: make the blk-mq stacking code
	optional
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The code to stack blk-mq drivers is only used by dm-multipath, and
will preferably stay that way.  Make it optional and only selected
by device mapper, so that the buildbots more easily catch abuses
like the one that slipped in in the ufs driver in the last merged
window.  Another positive side effects is that kernel builds without
device mapper shrink a little bit as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/Kconfig      | 3 +++
 block/blk-mq.c     | 2 ++
 drivers/md/Kconfig | 1 +
 3 files changed, 6 insertions(+)

diff --git a/block/Kconfig b/block/Kconfig
index 205f8d01c6952..168b873eb666d 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -230,6 +230,9 @@ config BLK_PM
 config BLOCK_HOLDER_DEPRECATED
 	bool
 
+config BLK_MQ_STACKING
+	bool
+
 source "block/Kconfig.iosched"
 
 endif # BLOCK
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6c59ffe765fde..db62d34afb637 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2840,6 +2840,7 @@ void blk_mq_submit_bio(struct bio *bio)
 				blk_mq_try_issue_directly(rq->mq_hctx, rq));
 }
 
+#ifdef CONFIG_BLK_MQ_STACKING
 /**
  * blk_cloned_rq_check_limits - Helper function to check a cloned request
  *                              for the new queue limits
@@ -3017,6 +3018,7 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 	return -ENOMEM;
 }
 EXPORT_SYMBOL_GPL(blk_rq_prep_clone);
+#endif /* CONFIG_BLK_MQ_STACKING */
 
 /*
  * Steal bios from a request and add them to a bio list.
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index b5ea378e66cb1..998a5cfdbc4e9 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -204,6 +204,7 @@ config BLK_DEV_DM
 	tristate "Device mapper support"
 	select BLOCK_HOLDER_DEPRECATED if SYSFS
 	select BLK_DEV_DM_BUILTIN
+	select BLK_MQ_STACKING
 	depends on DAX || DAX=n
 	help
 	  Device-mapper is a low level volume manager.  It works by allowing
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


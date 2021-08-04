Return-Path: <SRS0=Qr9I=M3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79ED5C4338F
	for <dm-devel@archiver.kernel.org>; Wed,  4 Aug 2021 09:46:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0017661002
	for <dm-devel@archiver.kernel.org>; Wed,  4 Aug 2021 09:46:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0017661002
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-YiO3GKrXM5q3o4_UjeiPhw-1; Wed, 04 Aug 2021 05:46:43 -0400
X-MC-Unique: YiO3GKrXM5q3o4_UjeiPhw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A20C487D543;
	Wed,  4 Aug 2021 09:46:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 880456E6EA;
	Wed,  4 Aug 2021 09:46:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 59665181A3E9;
	Wed,  4 Aug 2021 09:46:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1749kbMs006274 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 4 Aug 2021 05:46:37 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 026242077FCB; Wed,  4 Aug 2021 09:46:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F17612077FD6
	for <dm-devel@redhat.com>; Wed,  4 Aug 2021 09:46:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90222106655B
	for <dm-devel@redhat.com>; Wed,  4 Aug 2021 09:46:33 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-223-Z2hJIT5XMpmqylf-mMqxeQ-1; Wed, 04 Aug 2021 05:46:29 -0400
X-MC-Unique: Z2hJIT5XMpmqylf-mMqxeQ-1
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mBDT1-005eAr-0z; Wed, 04 Aug 2021 09:45:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Date: Wed,  4 Aug 2021 11:41:45 +0200
Message-Id: <20210804094147.459763-7-hch@lst.de>
In-Reply-To: <20210804094147.459763-1-hch@lst.de>
References: <20210804094147.459763-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH 6/8] dm: move setting md->type into
	dm_setup_md_queue
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Move setting md->type from both callers into dm_setup_md_queue.
This ensures that md->type is only set to a valid value after the queue
has been fully setup, something we'll rely on future changes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-ioctl.c | 4 ----
 drivers/md/dm.c       | 5 +++--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 2209cbcd84db..2575074a2204 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1436,9 +1436,6 @@ static int table_load(struct file *filp, struct dm_ioctl *param, size_t param_si
 	}
 
 	if (dm_get_md_type(md) == DM_TYPE_NONE) {
-		/* Initial table load: acquire type of table. */
-		dm_set_md_type(md, dm_table_get_type(t));
-
 		/* setup md->queue to reflect md's type (may block) */
 		r = dm_setup_md_queue(md, t);
 		if (r) {
@@ -2187,7 +2184,6 @@ int __init dm_early_create(struct dm_ioctl *dmi,
 	if (r)
 		goto err_destroy_table;
 
-	md->type = dm_table_get_type(t);
 	/* setup md->queue to reflect md's type (may block) */
 	r = dm_setup_md_queue(md, t);
 	if (r) {
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7971ec8ce677..f003bd5b93ce 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2052,9 +2052,9 @@ EXPORT_SYMBOL_GPL(dm_get_queue_limits);
  */
 int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 {
-	int r;
+	enum dm_queue_mode type = dm_table_get_type(t);
 	struct queue_limits limits;
-	enum dm_queue_mode type = dm_get_md_type(md);
+	int r;
 
 	switch (type) {
 	case DM_TYPE_REQUEST_BASED:
@@ -2081,6 +2081,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 	r = dm_table_set_restrictions(t, md->queue, &limits);
 	if (r)
 		return r;
+	md->type = type;
 
 	blk_register_queue(md->disk);
 
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


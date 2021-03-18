Return-Path: <SRS0=wQ+j=IQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B73BC433DB
	for <dm-devel@archiver.kernel.org>; Thu, 18 Mar 2021 06:59:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A4ACF64F10
	for <dm-devel@archiver.kernel.org>; Thu, 18 Mar 2021 06:59:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4ACF64F10
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-Ktl-7rsDOxKWdFBf-HuGsw-1; Thu, 18 Mar 2021 02:59:11 -0400
X-MC-Unique: Ktl-7rsDOxKWdFBf-HuGsw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D92A881281;
	Thu, 18 Mar 2021 06:59:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8183A6F991;
	Thu, 18 Mar 2021 06:59:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F21331800B8A;
	Thu, 18 Mar 2021 06:59:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12I6wYBN022185 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Mar 2021 02:58:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 89220210FE11; Thu, 18 Mar 2021 06:58:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8435F210FE13
	for <dm-devel@redhat.com>; Thu, 18 Mar 2021 06:58:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5725B85A5AA
	for <dm-devel@redhat.com>; Thu, 18 Mar 2021 06:58:32 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-595-by04_EbqM0acx5KNLgJ_cA-1; Thu, 18 Mar 2021 02:58:29 -0400
X-MC-Unique: by04_EbqM0acx5KNLgJ_cA-1
Received: from [2001:4bb8:18c:bb3:e1cf:ad2f:7ff7:7a0b] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1lMmGQ-002enr-Al; Thu, 18 Mar 2021 06:36:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: snitzer@redhat.com
Date: Thu, 18 Mar 2021 07:36:08 +0100
Message-Id: <20210318063608.295974-1-hch@lst.de>
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
Cc: dm-devel@redhat.com
Subject: [dm-devel] [PATCH] dm: unexport dm_{get,put}_table_device
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

These are only used inside the main dm module.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 50b693d776d603..f81bfacfd80de3 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -840,7 +840,6 @@ int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode,
 	*result = &td->dm_dev;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(dm_get_table_device);
 
 void dm_put_table_device(struct mapped_device *md, struct dm_dev *d)
 {
@@ -854,7 +853,6 @@ void dm_put_table_device(struct mapped_device *md, struct dm_dev *d)
 	}
 	mutex_unlock(&md->table_devices_lock);
 }
-EXPORT_SYMBOL(dm_put_table_device);
 
 static void free_table_devices(struct list_head *devices)
 {
-- 
2.30.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


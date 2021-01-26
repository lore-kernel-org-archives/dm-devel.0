Return-Path: <SRS0=Cj1z=G5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 906FFC433DB
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 09:14:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F08BB2074B
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 09:14:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F08BB2074B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hisilicon.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599--41BOfJsOmOOiTGbC3vE6A-1; Tue, 26 Jan 2021 04:14:43 -0500
X-MC-Unique: -41BOfJsOmOOiTGbC3vE6A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C258210054FF;
	Tue, 26 Jan 2021 09:14:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A524B71D57;
	Tue, 26 Jan 2021 09:14:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 78B0E4E590;
	Tue, 26 Jan 2021 09:14:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10Q2wj7Y030356 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 25 Jan 2021 21:58:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E7070110FC0E; Tue, 26 Jan 2021 02:58:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E319D110FC0D
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 02:58:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F168811E78
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 02:58:42 +0000 (UTC)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-89-5AMXYISpPIOM3l62RmoVZA-1; Mon, 25 Jan 2021 21:58:37 -0500
X-MC-Unique: 5AMXYISpPIOM3l62RmoVZA-1
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DPrXZ1pvNz7ZDD;
	Tue, 26 Jan 2021 10:39:10 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
	DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server
	id 14.3.498.0; Tue, 26 Jan 2021 10:40:18 +0800
From: Tian Tao <tiantao6@hisilicon.com>
To: <agk@redhat.com>, <snitzer@redhat.com>
Date: Tue, 26 Jan 2021 10:40:02 +0800
Message-ID: <1611628802-48765-1-git-send-email-tiantao6@hisilicon.com>
MIME-Version: 1.0
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 26 Jan 2021 04:10:04 -0500
Cc: dm-devel@redhat.com
Subject: [dm-devel] [PATCH] dm writecache: fix NULL check before some
	freeing functions is not needed
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

fixed the below warning:
./drivers/md/dm-writecache.c:2008:2-7: WARNING: NULL check before some
freeing functions is not needed.
./drivers/md/dm-writecache.c:2024:2-7: WARNING: NULL check before some
freeing functions is not needed.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 drivers/md/dm-writecache.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index d5223a0..8abf185 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -2004,8 +2004,7 @@ static void writecache_dtr(struct dm_target *ti)
 	if (wc->ssd_dev)
 		dm_put_device(ti, wc->ssd_dev);
 
-	if (wc->entries)
-		vfree(wc->entries);
+	vfree(wc->entries);
 
 	if (wc->memory_map) {
 		if (WC_MODE_PMEM(wc))
@@ -2020,8 +2019,7 @@ static void writecache_dtr(struct dm_target *ti)
 	if (wc->dm_io)
 		dm_io_client_destroy(wc->dm_io);
 
-	if (wc->dirty_bitmap)
-		vfree(wc->dirty_bitmap);
+	vfree(wc->dirty_bitmap);
 
 	kfree(wc);
 }
-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=zgrO=PK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D434C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 22 Oct 2021 06:25:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 742B661108
	for <dm-devel@archiver.kernel.org>; Fri, 22 Oct 2021 06:25:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 742B661108
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=baidu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-feBejArbMumRPldhys5o6Q-1; Fri, 22 Oct 2021 02:25:44 -0400
X-MC-Unique: feBejArbMumRPldhys5o6Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA9D51006AA4;
	Fri, 22 Oct 2021 06:25:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A1C4F1009AB7;
	Fri, 22 Oct 2021 06:25:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 649294E58E;
	Fri, 22 Oct 2021 06:25:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19L8tI9f031312 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 21 Oct 2021 04:55:18 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 74E50C77E0; Thu, 21 Oct 2021 08:55:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E596D1BB0
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 08:55:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3697B100B8EA
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 08:55:13 +0000 (UTC)
Received: from baidu.com (mx24.baidu.com [111.206.215.185]) by
	relay.mimecast.com with ESMTP id us-mta-457-5YVVQQUTPJudrJqBwOiSow-1;
	Thu, 21 Oct 2021 04:55:11 -0400
X-MC-Unique: 5YVVQQUTPJudrJqBwOiSow-1
Received: from BJHW-Mail-Ex09.internal.baidu.com (unknown [10.127.64.32])
	by Forcepoint Email with ESMTPS id 300F11A63D338FBF8652;
	Thu, 21 Oct 2021 16:39:12 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
	BJHW-Mail-Ex09.internal.baidu.com (10.127.64.32) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
	15.1.2308.14; Thu, 21 Oct 2021 16:39:12 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
	BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
	15.1.2308.14; Thu, 21 Oct 2021 16:39:11 +0800
From: Cai Huoqing <caihuoqing@baidu.com>
To: <caihuoqing@baidu.com>
Date: Thu, 21 Oct 2021 16:39:09 +0800
Message-ID: <20211021083910.1971-1-caihuoqing@baidu.com>
MIME-Version: 1.0
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-EX02.internal.baidu.com (172.31.51.42) To
	BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex09_2021-10-21 16:39:12:212
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 22 Oct 2021 02:25:38 -0400
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [dm-devel] [PATCH] dm writecache: Make use of the helper macro
	kthread_run()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Repalce kthread_create/wake_up_process() with kthread_run()
to simplify the code.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/md/dm-writecache.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 017806096b91..4b8991cde223 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -2264,14 +2264,13 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	raw_spin_lock_init(&wc->endio_list_lock);
 	INIT_LIST_HEAD(&wc->endio_list);
-	wc->endio_thread = kthread_create(writecache_endio_thread, wc, "writecache_endio");
+	wc->endio_thread = kthread_run(writecache_endio_thread, wc, "writecache_endio");
 	if (IS_ERR(wc->endio_thread)) {
 		r = PTR_ERR(wc->endio_thread);
 		wc->endio_thread = NULL;
 		ti->error = "Couldn't spawn endio thread";
 		goto bad;
 	}
-	wake_up_process(wc->endio_thread);
 
 	/*
 	 * Parse the mode (pmem or ssd)
@@ -2493,14 +2492,13 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		wc->memory_map_size -= (uint64_t)wc->start_sector << SECTOR_SHIFT;
 
 		bio_list_init(&wc->flush_list);
-		wc->flush_thread = kthread_create(writecache_flush_thread, wc, "dm_writecache_flush");
+		wc->flush_thread = kthread_run(writecache_flush_thread, wc, "dm_writecache_flush");
 		if (IS_ERR(wc->flush_thread)) {
 			r = PTR_ERR(wc->flush_thread);
 			wc->flush_thread = NULL;
 			ti->error = "Couldn't spawn flush thread";
 			goto bad;
 		}
-		wake_up_process(wc->flush_thread);
 
 		r = calculate_memory_size(wc->memory_map_size, wc->block_size,
 					  &n_blocks, &n_metadata_blocks);
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


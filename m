Return-Path: <SRS0=zjfM=LD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A200EC48BCD
	for <dm-devel@archiver.kernel.org>; Wed,  9 Jun 2021 06:03:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1A4B061351
	for <dm-devel@archiver.kernel.org>; Wed,  9 Jun 2021 06:03:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A4B061351
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-kPfTVZMSNqW2hh_X-M2atA-1; Wed, 09 Jun 2021 02:03:39 -0400
X-MC-Unique: kPfTVZMSNqW2hh_X-M2atA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0181801B16;
	Wed,  9 Jun 2021 06:03:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9283B5D9E2;
	Wed,  9 Jun 2021 06:03:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6458D180B651;
	Wed,  9 Jun 2021 06:03:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1593XZv4030742 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Jun 2021 23:33:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2C6DFFED28; Wed,  9 Jun 2021 03:33:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2743FFDCFA
	for <dm-devel@redhat.com>; Wed,  9 Jun 2021 03:33:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83E49101A55F
	for <dm-devel@redhat.com>; Wed,  9 Jun 2021 03:33:32 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com
	[45.249.212.255]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-294--FUCp61PMRuyjeScQDhxFQ-1; Tue, 08 Jun 2021 23:33:30 -0400
X-MC-Unique: -FUCp61PMRuyjeScQDhxFQ-1
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G0Bsg5NG5z1BJfW;
	Wed,  9 Jun 2021 11:09:27 +0800 (CST)
Received: from dggpeml500020.china.huawei.com (7.185.36.88) by
	dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2176.2; Wed, 9 Jun 2021 11:14:19 +0800
Received: from huawei.com (10.175.127.227) by dggpeml500020.china.huawei.com
	(7.185.36.88) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2;
	Wed, 9 Jun 2021 11:14:18 +0800
From: Baokun Li <libaokun1@huawei.com>
To: <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
	<yangjihong1@huawei.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer
	<snitzer@redhat.com>, <dm-devel@redhat.com>
Date: Wed, 9 Jun 2021 11:23:02 +0800
Message-ID: <20210609032329.951926-2-libaokun1@huawei.com>
In-Reply-To: <20210609032329.951926-1-libaokun1@huawei.com>
References: <20210609032329.951926-1-libaokun1@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
	dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1593XZv4030742
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 09 Jun 2021 02:03:13 -0400
Cc: yukuai3@huawei.com, libaokun1@huawei.com
Subject: [dm-devel] [PATCH -next] dm writecache: use list_move instead of
	list_del/list_add in dm-writecache.c
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Using list_move() instead of list_del() + list_add() in dm-writecache.c.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
 drivers/md/dm-writecache.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index ea9f0d8fff1d..a809a616d691 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1868,15 +1868,13 @@ static void writecache_writeback(struct work_struct *work)
 			if (unlikely(read_original_sector(wc, f) ==
 				     read_original_sector(wc, e))) {
 				BUG_ON(!f->write_in_progress);
-				list_del(&e->lru);
-				list_add(&e->lru, &skipped);
+				list_move(&e->lru, &skipped);
 				cond_resched();
 				continue;
 			}
 		}
 		wc->writeback_size++;
-		list_del(&e->lru);
-		list_add(&e->lru, &wbl.list);
+		list_move(&e->lru, &wbl.list);
 		wbl.size++;
 		e->write_in_progress = true;
 		e->wc_list_contiguous = 1;
@@ -1911,8 +1909,7 @@ static void writecache_writeback(struct work_struct *work)
 			//	break;
 
 			wc->writeback_size++;
-			list_del(&g->lru);
-			list_add(&g->lru, &wbl.list);
+			list_move(&g->lru, &wbl.list);
 			wbl.size++;
 			g->write_in_progress = true;
 			g->wc_list_contiguous = BIO_MAX_VECS;


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


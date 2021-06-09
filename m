Return-Path: <SRS0=zjfM=LD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA19C48BCF
	for <dm-devel@archiver.kernel.org>; Wed,  9 Jun 2021 11:22:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3F05C6139A
	for <dm-devel@archiver.kernel.org>; Wed,  9 Jun 2021 11:22:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F05C6139A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-HUwBVwjqPF2V6DFbprYqbg-1; Wed, 09 Jun 2021 07:22:25 -0400
X-MC-Unique: HUwBVwjqPF2V6DFbprYqbg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C581BCC621;
	Wed,  9 Jun 2021 11:22:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 391A160917;
	Wed,  9 Jun 2021 11:22:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A7E1F1809CAF;
	Wed,  9 Jun 2021 11:22:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1596tltS014715 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Jun 2021 02:55:48 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C74631043A35; Wed,  9 Jun 2021 06:55:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C1B3E10439B1
	for <dm-devel@redhat.com>; Wed,  9 Jun 2021 06:55:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1F70101A55F
	for <dm-devel@redhat.com>; Wed,  9 Jun 2021 06:55:43 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
	[45.249.212.187]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-389-Uk1usuyyPDicCPmJCj-1hg-1; Wed, 09 Jun 2021 02:55:40 -0400
X-MC-Unique: Uk1usuyyPDicCPmJCj-1hg-1
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G0Hmz3cS8zWtK4;
	Wed,  9 Jun 2021 14:50:43 +0800 (CST)
Received: from dggpeml500020.china.huawei.com (7.185.36.88) by
	dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2176.2; Wed, 9 Jun 2021 14:55:25 +0800
Received: from huawei.com (10.175.127.227) by dggpeml500020.china.huawei.com
	(7.185.36.88) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2;
	Wed, 9 Jun 2021 14:55:24 +0800
From: Baokun Li <libaokun1@huawei.com>
To: <linux-kernel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, "Mike
	Snitzer" <snitzer@redhat.com>, <dm-devel@redhat.com>
Date: Wed, 9 Jun 2021 15:04:33 +0800
Message-ID: <20210609070433.1323812-1-libaokun1@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1596tltS014715
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 09 Jun 2021 07:22:15 -0400
Cc: Hulk Robot <hulkci@huawei.com>, yuehaibing@huawei.com,
	kernel-janitors@vger.kernel.org, yangjihong1@huawei.com,
	libaokun1@huawei.com, yukuai3@huawei.com, weiyongjun1@huawei.com
Subject: [dm-devel] [PATCH -next v2] dm writecache: use list_move instead of
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
V1->V2:
	CC mailist

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


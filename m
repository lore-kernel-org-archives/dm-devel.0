Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26CE7C83F01
	for <dm-devel@archiver.kernel.org>; Wed, 30 Aug 2023 13:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693402811;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qb9asY/8KIXwIu10HVywNs+kMMr/tJkyjPDxmkJz3GA=;
	b=TCT93yETsDRnneBfCWrrU2j6fWH4iZUbd5+0TGwg4YDN6ppgMT+XFPMh0vxx5lPro0NLQR
	fEgSHqUu1yBr7NzlC+umdZLkBN2hNqf6Rs2BaaORQNGGbAb5AaiT65qxq1TEHkIXHjl4ju
	yQ3FBSFk0BHnBHIMn7uHa93OZczgvmY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-D_eL2ukdMoaAItDXqraWFA-1; Wed, 30 Aug 2023 09:40:07 -0400
X-MC-Unique: D_eL2ukdMoaAItDXqraWFA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2634480027F;
	Wed, 30 Aug 2023 13:40:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4A97440C6F4C;
	Wed, 30 Aug 2023 13:40:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 04B9B19465A3;
	Wed, 30 Aug 2023 13:39:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C8DC81946594
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Aug 2023 10:37:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 742506B292; Wed, 30 Aug 2023 10:37:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C26F6466B
 for <dm-devel@redhat.com>; Wed, 30 Aug 2023 10:37:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07C2D3C0FC80
 for <dm-devel@redhat.com>; Wed, 30 Aug 2023 10:37:00 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com
 [45.249.212.188]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-WOcstaRxPLa35ytv_oAMyg-1; Wed, 30 Aug 2023 06:36:57 -0400
X-MC-Unique: WOcstaRxPLa35ytv_oAMyg-1
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.55])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RbKr10FXBzNmsN;
 Wed, 30 Aug 2023 18:13:21 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemi500008.china.huawei.com
 (7.221.188.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Wed, 30 Aug
 2023 18:16:58 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer
 <snitzer@kernel.org>
Date: Wed, 30 Aug 2023 18:16:42 +0800
Message-ID: <20230830101642.774485-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Wed, 30 Aug 2023 13:29:53 +0000
Subject: [dm-devel] [PATCH -next] dm stats: Use list_for_each_entry() helper
 instead of list_for_each() and container_of()
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
Cc: ruanjinjie@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huawei.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Convert list_for_each() and container_of() to list_for_each_entry()
so that the l list_head pointer and container_of() call are no longer
needed, which can reduce a few lines of code. No functional changed.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 drivers/md/dm-stats.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index db2d997a6c18..06304b0ad906 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -240,12 +240,10 @@ void dm_stats_cleanup(struct dm_stats *stats)
 
 static void dm_stats_recalc_precise_timestamps(struct dm_stats *stats)
 {
-	struct list_head *l;
 	struct dm_stat *tmp_s;
 	bool precise_timestamps = false;
 
-	list_for_each(l, &stats->list) {
-		tmp_s = container_of(l, struct dm_stat, list_entry);
+	list_for_each_entry(tmp_s, &stats->list, list_entry) {
 		if (tmp_s->stat_flags & STAT_PRECISE_TIMESTAMPS) {
 			precise_timestamps = true;
 			break;
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=rSqa=QD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7705C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 16 Nov 2021 14:00:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 441C461BF4
	for <dm-devel@archiver.kernel.org>; Tue, 16 Nov 2021 14:00:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 441C461BF4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-ERMUTHTuOUWyDAFXiPnNJQ-1; Tue, 16 Nov 2021 09:00:15 -0500
X-MC-Unique: ERMUTHTuOUWyDAFXiPnNJQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2646C8799EB;
	Tue, 16 Nov 2021 14:00:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0236718BAB;
	Tue, 16 Nov 2021 14:00:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3DEF91819AC1;
	Tue, 16 Nov 2021 14:00:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AGDxrf6002155 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 16 Nov 2021 08:59:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0B1691121315; Tue, 16 Nov 2021 13:59:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 04BB7112131E
	for <dm-devel@redhat.com>; Tue, 16 Nov 2021 13:59:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3228480B91D
	for <dm-devel@redhat.com>; Tue, 16 Nov 2021 13:59:50 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
	[45.249.212.187]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-431-yvLkQ2i_PF-CIwFpG2huKg-1; Tue, 16 Nov 2021 08:59:46 -0500
X-MC-Unique: yvLkQ2i_PF-CIwFpG2huKg-1
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HtngP0sglzZd6g;
	Tue, 16 Nov 2021 21:57:21 +0800 (CST)
Received: from kwepemm600010.china.huawei.com (7.193.23.86) by
	dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Tue, 16 Nov 2021 21:59:43 +0800
Received: from [10.174.179.176] (10.174.179.176) by
	kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.15; Tue, 16 Nov 2021 21:59:42 +0800
From: lixiaokeng <lixiaokeng@huawei.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Martin Wilck
	<mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, "dm-devel
	mailing list" <dm-devel@redhat.com>
References: <78637f61-851d-cf9d-d308-9c22396d2071@huawei.com>
Message-ID: <c410b6c9-4d46-bb64-4336-89c7af7600bc@huawei.com>
Date: Tue, 16 Nov 2021 21:59:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <78637f61-851d-cf9d-d308-9c22396d2071@huawei.com>
X-Originating-IP: [10.174.179.176]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
	kwepemm600010.china.huawei.com (7.193.23.86)
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
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: [dm-devel] [PATCH 2/5] remove unnecessary memset
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
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

MALLOC will set memory zero. memset is unnecessary.
Remove it.

Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
---
 libmultipath/log.c  | 1 -
 multipathd/waiter.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/libmultipath/log.c b/libmultipath/log.c
index 10fa32cd..f41efb5b 100644
--- a/libmultipath/log.c
+++ b/libmultipath/log.c
@@ -57,7 +57,6 @@ static int logarea_init (int size)
 		FREE(la);
 		return 1;
 	}
-	memset(la->start, 0, size);

 	la->empty = 1;
 	la->end = la->start + size;
diff --git a/multipathd/waiter.c b/multipathd/waiter.c
index bbe6c2a1..f74b395a 100644
--- a/multipathd/waiter.c
+++ b/multipathd/waiter.c
@@ -33,7 +33,6 @@ static struct event_thread *alloc_waiter (void)
 	struct event_thread *wp;

 	wp = (struct event_thread *)MALLOC(sizeof(struct event_thread));
-	memset(wp, 0, sizeof(struct event_thread));

 	return wp;
 }
--

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


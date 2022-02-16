Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C16EC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 16 Feb 2022 06:59:43 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-SLmXt2GNNROUHItfQrWAcQ-1; Wed, 16 Feb 2022 01:59:36 -0500
X-MC-Unique: SLmXt2GNNROUHItfQrWAcQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABF5A100B79A;
	Wed, 16 Feb 2022 06:59:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E1CC16A39;
	Wed, 16 Feb 2022 06:59:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CD5741826D01;
	Wed, 16 Feb 2022 06:59:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21G6uCBw021340 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Feb 2022 01:56:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 17BBD7AD6; Wed, 16 Feb 2022 06:56:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 12E637AC9
	for <dm-devel@redhat.com>; Wed, 16 Feb 2022 06:56:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B94F41C05EA8
	for <dm-devel@redhat.com>; Wed, 16 Feb 2022 06:56:06 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
	[45.249.212.187]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-644-TW3KjEzxP66oVJzxJ3UXPw-1; Wed, 16 Feb 2022 01:56:04 -0500
X-MC-Unique: TW3KjEzxP66oVJzxJ3UXPw-1
Received: from kwepemi100013.china.huawei.com (unknown [172.30.72.54])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Jz7Wg3bzBzcbYP;
	Wed, 16 Feb 2022 14:35:59 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
	kwepemi100013.china.huawei.com (7.221.188.136) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.21; Wed, 16 Feb 2022 14:37:05 +0800
Received: from [127.0.0.1] (10.174.177.249) by kwepemm600003.china.huawei.com
	(7.193.23.202) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21;
	Wed, 16 Feb 2022 14:37:04 +0800
To: <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <b0ec028e-bc9e-f705-9674-ffc4a01ee2f0@huawei.com>
Date: Wed, 16 Feb 2022 14:37:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
	Thunderbird/68.2.2
MIME-Version: 1.0
X-Originating-IP: [10.174.177.249]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
	kwepemm600003.china.huawei.com (7.193.23.202)
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
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>, lixiaokeng <lixiaokeng@huawei.com>,
	dm-devel@redhat.com,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	wuguanghao <wuguanghao3@huawei.com>
Subject: [dm-devel] [PATCH] md: remove unused dm_thin_remove_block()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


dm_thin_remove_block() is no longer unused, just remove it.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
---
 drivers/md/dm-thin-metadata.c | 12 ------------
 drivers/md/dm-thin-metadata.h |  1 -
 2 files changed, 13 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 1a96a07cbf44..986a2dc9a686 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1740,18 +1740,6 @@ static int __remove_range(struct dm_thin_device *td, dm_block_t begin, dm_block_
 	return dm_btree_insert(&pmd->tl_info, pmd->root, keys, &value, &pmd->root);
 }

-int dm_thin_remove_block(struct dm_thin_device *td, dm_block_t block)
-{
-	int r = -EINVAL;
-
-	pmd_write_lock(td->pmd);
-	if (!td->pmd->fail_io)
-		r = __remove(td, block);
-	pmd_write_unlock(td->pmd);
-
-	return r;
-}
-
 int dm_thin_remove_range(struct dm_thin_device *td,
 			 dm_block_t begin, dm_block_t end)
 {
diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
index 7ef56bd2a7e3..4d7a2caf21d9 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -166,7 +166,6 @@ int dm_pool_alloc_data_block(struct dm_pool_metadata *pmd, dm_block_t *result);
 int dm_thin_insert_block(struct dm_thin_device *td, dm_block_t block,
 			 dm_block_t data_block);

-int dm_thin_remove_block(struct dm_thin_device *td, dm_block_t block);
 int dm_thin_remove_range(struct dm_thin_device *td,
 			 dm_block_t begin, dm_block_t end);

-- 
2.32.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


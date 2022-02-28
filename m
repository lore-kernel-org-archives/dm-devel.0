Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2D66C433F5
	for <dm-devel@archiver.kernel.org>; Tue,  1 Mar 2022 07:17:33 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-478-WDW4gJ_YOm6dGML_PcBJ1g-1; Tue, 01 Mar 2022 02:17:29 -0500
X-MC-Unique: WDW4gJ_YOm6dGML_PcBJ1g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F18A3801DDC;
	Tue,  1 Mar 2022 07:17:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 130DD5DBBE;
	Tue,  1 Mar 2022 07:17:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5A27F1809C98;
	Tue,  1 Mar 2022 07:17:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21SEGIhG012231 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 28 Feb 2022 09:16:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B29A344F707; Mon, 28 Feb 2022 14:16:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AECEE44F709
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 14:16:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9663D811E75
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 14:16:18 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com
	[45.249.212.189]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-204-wjauTrk3PcaH1Q-jy_YYOg-1; Mon, 28 Feb 2022 09:16:14 -0500
X-MC-Unique: wjauTrk3PcaH1Q-jy_YYOg-1
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.56])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4K6hhY4HZKz9sQf;
	Mon, 28 Feb 2022 21:54:53 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
	dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.21; Mon, 28 Feb 2022 21:58:25 +0800
Received: from localhost.localdomain (10.175.127.227) by
	dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.21; Mon, 28 Feb 2022 21:58:25 +0800
From: Luo Meng <luomeng12@huawei.com>
To: <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>,
	<ejt@redhat.com>
Date: Mon, 28 Feb 2022 22:13:54 +0800
Message-ID: <20220228141354.1091687-1-luomeng12@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
	dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21SEGIhG012231
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 01 Mar 2022 02:17:20 -0500
Cc: luomeng12@huawei.com, yukuai3@huawei.com
Subject: [dm-devel] [PTACH] Revert "dm space maps: don't reset space map
	allocation cursor when committing"
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

This reverts commit 5faafc77f7de69147d1e818026b9a0cbf036a7b2.

This commit 5faafc77f7de ("dm space maps: don't reset space map allocation
cursor when committing") change the way to find free block.

But when use ramdisk(not support discard) for thin-pool,and storage
over-commitment. Then constantly create and delete file, can find block
in thin-pool, but can't find block in ramdisk.

So need revert this patch.

Fixes: 5faafc77f7de ("dm space maps: don't reset space map allocation cursor when committing")
Signed-off-by: Luo Meng <luomeng12@huawei.com>
---
 drivers/md/persistent-data/dm-space-map-disk.c     | 9 +--------
 drivers/md/persistent-data/dm-space-map-metadata.c | 9 +--------
 2 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/md/persistent-data/dm-space-map-disk.c b/drivers/md/persistent-data/dm-space-map-disk.c
index d0a8d5e73c28..17afbebd9244 100644
--- a/drivers/md/persistent-data/dm-space-map-disk.c
+++ b/drivers/md/persistent-data/dm-space-map-disk.c
@@ -134,14 +134,6 @@ static int sm_disk_new_block(struct dm_space_map *sm, dm_block_t *b)
 	 * Any block we allocate has to be free in both the old and current ll.
 	 */
 	r = sm_ll_find_common_free_block(&smd->old_ll, &smd->ll, smd->begin, smd->ll.nr_blocks, b);
-	if (r == -ENOSPC) {
-		/*
-		 * There's no free block between smd->begin and the end of the metadata device.
-		 * We search before smd->begin in case something has been freed.
-		 */
-		r = sm_ll_find_common_free_block(&smd->old_ll, &smd->ll, 0, smd->begin, b);
-	}
-
 	if (r)
 		return r;
 
@@ -164,6 +156,7 @@ static int sm_disk_commit(struct dm_space_map *sm)
 		return r;
 
 	memcpy(&smd->old_ll, &smd->ll, sizeof(smd->old_ll));
+	smd->begin = 0;
 	smd->nr_allocated_this_transaction = 0;
 
 	return 0;
diff --git a/drivers/md/persistent-data/dm-space-map-metadata.c b/drivers/md/persistent-data/dm-space-map-metadata.c
index 392ae26134a4..42920e930dbd 100644
--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -453,14 +453,6 @@ static int sm_metadata_new_block_(struct dm_space_map *sm, dm_block_t *b)
 	 * Any block we allocate has to be free in both the old and current ll.
 	 */
 	r = sm_ll_find_common_free_block(&smm->old_ll, &smm->ll, smm->begin, smm->ll.nr_blocks, b);
-	if (r == -ENOSPC) {
-		/*
-		 * There's no free block between smm->begin and the end of the metadata device.
-		 * We search before smm->begin in case something has been freed.
-		 */
-		r = sm_ll_find_common_free_block(&smm->old_ll, &smm->ll, 0, smm->begin, b);
-	}
-
 	if (r)
 		return r;
 
@@ -512,6 +504,7 @@ static int sm_metadata_commit(struct dm_space_map *sm)
 		return r;
 
 	memcpy(&smm->old_ll, &smm->ll, sizeof(smm->old_ll));
+	smm->begin = 0;
 	smm->allocated_this_transaction = 0;
 
 	return 0;
-- 
2.31.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


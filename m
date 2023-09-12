Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5137CA0EC3
	for <dm-devel@archiver.kernel.org>; Tue, 12 Sep 2023 13:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694525637;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1Ji5AgwCEQS6MSp3p6db2OejqkMc+6yF9K+vul5oG0M=;
	b=dVUSDZb+3HRBwHXbtBa3XV7lyHM3v3/ddouSJE1vhcxDRnhtAsyO779Okxd+gStizjY0R6
	clK+5Bqjz5cX/9/HG2c0p5hR2OV/BAilUZa3KE9SGqTNBt4dU5SGqFxyFLUgfUNivgOIVZ
	e9H94TB6J5ZlNBi0RNQsSfkAg0r21yo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-NhROb6HqPMef001EiqeIgQ-1; Tue, 12 Sep 2023 09:33:54 -0400
X-MC-Unique: NhROb6HqPMef001EiqeIgQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20A6F3C0EAA9;
	Tue, 12 Sep 2023 13:33:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2244B2026D68;
	Tue, 12 Sep 2023 13:33:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C7D4919465B3;
	Tue, 12 Sep 2023 13:33:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4EB02194658D
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Sep 2023 12:30:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3C18740C6EBF; Tue, 12 Sep 2023 12:30:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3523F40C6EA8
 for <dm-devel@redhat.com>; Tue, 12 Sep 2023 12:30:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F397729AB435
 for <dm-devel@redhat.com>; Tue, 12 Sep 2023 12:30:13 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com
 [45.249.212.189]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-HcP0GUnkMCWG93sTQ4MMcQ-1; Tue, 12 Sep 2023 08:30:12 -0400
X-MC-Unique: HcP0GUnkMCWG93sTQ4MMcQ-1
Received: from dggpemm500011.china.huawei.com (unknown [172.30.72.54])
 by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4RlN9s0W98zMl9J;
 Tue, 12 Sep 2023 20:26:41 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpemm500011.china.huawei.com
 (7.185.36.110) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Tue, 12 Sep
 2023 20:30:07 +0800
From: Li Lingfeng <lilingfeng3@huawei.com>
To: <dm-devel@redhat.com>
Date: Tue, 12 Sep 2023 20:26:05 +0800
Message-ID: <20230912122605.3487911-1-lilingfeng3@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500011.china.huawei.com (7.185.36.110)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH] dm: remove dm_set_md_type()
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, houtao1@huawei.com, yukuai3@huawei.com,
 lilingfeng3@huawei.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huawei.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Commit ba30585936b0 ("dm: move setting md->type into dm_setup_md_queue")
has removed the only reference to dm_set_md_type(), so remove
dm_set_md_type() now.

Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
---
 drivers/md/dm.c | 6 ------
 drivers/md/dm.h | 1 -
 2 files changed, 7 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f0f118ab20fa..6b9d04ca09d0 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2316,12 +2316,6 @@ void dm_unlock_md_type(struct mapped_device *md)
 	mutex_unlock(&md->type_lock);
 }
 
-void dm_set_md_type(struct mapped_device *md, enum dm_queue_mode type)
-{
-	BUG_ON(!mutex_is_locked(&md->type_lock));
-	md->type = type;
-}
-
 enum dm_queue_mode dm_get_md_type(struct mapped_device *md)
 {
 	return md->type;
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index f682295af91f..cc55ef3441be 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -76,7 +76,6 @@ bool dm_table_request_based(struct dm_table *t);
 
 void dm_lock_md_type(struct mapped_device *md);
 void dm_unlock_md_type(struct mapped_device *md);
-void dm_set_md_type(struct mapped_device *md, enum dm_queue_mode type);
 enum dm_queue_mode dm_get_md_type(struct mapped_device *md);
 struct target_type *dm_get_immutable_target_type(struct mapped_device *md);
 
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


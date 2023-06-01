Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2826C7EE23
	for <dm-devel@archiver.kernel.org>; Thu,  1 Jun 2023 06:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685600181;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3+EwbU0QQGIBm51h7m/Sw9Z5RQuchGK4H+aP9FWYP44=;
	b=NPM3JxJV02I/BVBZPdtvmM8KQ0JyzPRDEJ768xwYrvStnO9fjQQ2ZprpGHou4+0elw9+Fy
	g2o3wQPdUs6sPaChBUm5Gyfj9/CqtWDJ9/8dsmmXkq2bK/O6kY+ihB1JQNlvGM+7Yp+ieD
	Uy8p2jzJBPtb+qc3gBb3MUxDHlLXM0I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-41-fjZ9uLmIPiqmXX16C4crTA-1; Thu, 01 Jun 2023 02:16:18 -0400
X-MC-Unique: fjZ9uLmIPiqmXX16C4crTA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3719800141;
	Thu,  1 Jun 2023 06:16:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5AAC42166B25;
	Thu,  1 Jun 2023 06:16:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 14BD9194343F;
	Thu,  1 Jun 2023 06:16:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DBC2F19451E5
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Jun 2023 06:16:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C4A8540C6CD8; Thu,  1 Jun 2023 06:16:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BD5FC40C6EC4
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 06:16:14 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 510EE1C060C1
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 06:16:14 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com
 [45.249.212.255]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-14-PXdj_DT5OkSV9ABd5OXfqQ-1; Thu, 01 Jun 2023 02:16:11 -0400
X-MC-Unique: PXdj_DT5OkSV9ABd5OXfqQ-1
Received: from dggpemm500011.china.huawei.com (unknown [172.30.72.53])
 by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QWwkR1gVyz18LnG;
 Thu,  1 Jun 2023 14:11:27 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpemm500011.china.huawei.com
 (7.185.36.110) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 1 Jun
 2023 14:16:06 +0800
From: Li Lingfeng <lilingfeng3@huawei.com>
To: <dm-devel@redhat.com>
Date: Thu, 1 Jun 2023 14:14:23 +0800
Message-ID: <20230601061423.3594104-1-lilingfeng3@huawei.com>
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
Subject: [dm-devel] [PATCH] dm: don't lock fs when the map is NULL in
 process of suspend
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
Cc: yi.zhang@huawei.com, snitzer@kernel.org, linux-kernel@vger.kernel.org,
 houtao1@huawei.com, yukuai3@huawei.com, lilingfeng3@huawei.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huawei.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

As described in commit 38d11da522aa ("dm: don't lock fs when the map is
NULL in process of resume"), deadlock may be triggered between do_resume
and do_mount.
What's more, do_suspend and do_mount can also trigger it.
So clear DM_SUSPEND_LOCKFS_FLAG in dm_suspend instead of do_resume.

Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
---
 drivers/md/dm-ioctl.c | 5 +----
 drivers/md/dm.c       | 3 +++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index cc77cf3d4109..7d5c9c582ed2 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1168,13 +1168,10 @@ static int do_resume(struct dm_ioctl *param)
 	/* Do we need to load a new map ? */
 	if (new_map) {
 		sector_t old_size, new_size;
-		int srcu_idx;
 
 		/* Suspend if it isn't already suspended */
-		old_map = dm_get_live_table(md, &srcu_idx);
-		if ((param->flags & DM_SKIP_LOCKFS_FLAG) || !old_map)
+		if (param->flags & DM_SKIP_LOCKFS_FLAG)
 			suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
-		dm_put_live_table(md, srcu_idx);
 		if (param->flags & DM_NOFLUSH_FLAG)
 			suspend_flags |= DM_SUSPEND_NOFLUSH_FLAG;
 		if (!dm_suspended_md(md))
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3b694ba3a106..39424a0b3cd6 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2809,6 +2809,9 @@ int dm_suspend(struct mapped_device *md, unsigned int suspend_flags)
 
 	map = rcu_dereference_protected(md->map, lockdep_is_held(&md->suspend_lock));
 
+	if (!map)
+		suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
+
 	r = __dm_suspend(md, map, suspend_flags, TASK_INTERRUPTIBLE, DMF_SUSPENDED);
 	if (r)
 		goto out_unlock;
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCFC2C77B78
	for <dm-devel@archiver.kernel.org>; Tue, 18 Apr 2023 14:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681827994;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VUGnkjqtSWA4UI6CHbmxOHt9w9pXTNjCOCUpPHWqOng=;
	b=C3Dttqi9JSVR/3lvk557Bm01/aMsqtkqFplI1iUtHncPXVwhQwejyGsN2v0hp+VKzrQPXJ
	r31lRslCMjH6WXoXXfTdB6cHJ8UjzdoX2WG7bP6GA707IebVkzZ826lrrPnVnmOb57JK6v
	2j7SB9Ac2vR5qfP7wo3mFmj2euN8vk8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-qLq4pUe8O0qENc-z37hLRg-1; Tue, 18 Apr 2023 10:26:31 -0400
X-MC-Unique: qLq4pUe8O0qENc-z37hLRg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6300101A551;
	Tue, 18 Apr 2023 14:26:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7EF2E1121314;
	Tue, 18 Apr 2023 14:26:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 469C61946594;
	Tue, 18 Apr 2023 14:26:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9EFC6194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Apr 2023 08:57:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8F1A640C83B6; Tue, 18 Apr 2023 08:57:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 87D3D40C83A9
 for <dm-devel@redhat.com>; Tue, 18 Apr 2023 08:57:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 384D93C11782
 for <dm-devel@redhat.com>; Tue, 18 Apr 2023 08:57:25 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
 [45.249.212.187]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-oKioRL7wMHC34Xj7q9Ja6A-1; Tue, 18 Apr 2023 04:57:23 -0400
X-MC-Unique: oKioRL7wMHC34Xj7q9Ja6A-1
Received: from dggpemm500011.china.huawei.com (unknown [7.185.36.110])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Q0y332TYczsRFq;
 Tue, 18 Apr 2023 16:37:19 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpemm500011.china.huawei.com
 (7.185.36.110) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 18 Apr
 2023 16:38:48 +0800
From: Li Lingfeng <lilingfeng3@huawei.com>
To: <dm-devel@redhat.com>
Date: Tue, 18 Apr 2023 16:38:04 +0800
Message-ID: <20230418083804.2548437-1-lilingfeng3@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500011.china.huawei.com (7.185.36.110)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Tue, 18 Apr 2023 14:26:19 +0000
Subject: [dm-devel] [PATCH -next] dm: don't lock fs when the map is NULL in
 process of resume
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huawei.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Commit fa247089de99 ("dm: requeue IO if mapping table not yet available")
added a detection of whether the mapping table is available in the IO
submission process. If the mapping table is unavailable, it returns
BLK_STS_RESOURCE and requeues the IO.
This can lead to the following deadlock problem:

dm create                                      mount
ioctl(DM_DEV_CREATE_CMD)
ioctl(DM_TABLE_LOAD_CMD)
                               do_mount
                                vfs_get_tree
                                 ext4_get_tree
                                  get_tree_bdev
                                   sget_fc
                                    alloc_super
                                     // got &s->s_umount
                                     down_write_nested(&s->s_umount, ...);
                                   ext4_fill_super
                                    ext4_load_super
                                     ext4_read_bh
                                      submit_bio
                                      // submit and wait io end
ioctl(DM_DEV_SUSPEND_CMD)
dev_suspend
 do_resume
  dm_suspend
   __dm_suspend
    lock_fs
     freeze_bdev
      get_active_super
       grab_super
        // wait for &s->s_umount
        down_write(&s->s_umount);
  dm_swap_table
   __bind
    // set md->map(can't get here)

IO will be continuously requeued while holding the lock since mapping
table is null. At the same time, mapping table won't be set since the
lock is not available.
Like request-based DM, bio-based DM also has the same problem.

It's not proper to just abort IO if the mapping table not available.
So clear DM_SKIP_LOCKFS_FLAG when the mapping table is NULL.

Fixes: fa247089de99 ("dm: requeue IO if mapping table not yet available")
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
---
 drivers/md/dm-ioctl.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 50a1259294d1..48e5554e3b69 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1168,10 +1168,14 @@ static int do_resume(struct dm_ioctl *param)
 	/* Do we need to load a new map ? */
 	if (new_map) {
 		sector_t old_size, new_size;
+		int srcu_idx;
 
+		old_map = dm_get_live_table(md, &srcu_idx);
 		/* Suspend if it isn't already suspended */
-		if (param->flags & DM_SKIP_LOCKFS_FLAG)
+		if ((param->flags & DM_SKIP_LOCKFS_FLAG) || !old_map)
 			suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
+		dm_put_live_table(md, srcu_idx);
+
 		if (param->flags & DM_NOFLUSH_FLAG)
 			suspend_flags |= DM_SUSPEND_NOFLUSH_FLAG;
 		if (!dm_suspended_md(md))
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


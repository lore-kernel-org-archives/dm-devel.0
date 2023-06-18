Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5594EEB64D7
	for <dm-devel@archiver.kernel.org>; Sun, 18 Jun 2023 14:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687097913;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eaTAJJ4tQi9oIhF1gDkPuYHyu7YYdYVA/dkWn4bwAB4=;
	b=dBU4hWZvqiTvZcLKxVaDSSSNgjrQnaLD20eqbrJUVfKN0+7qoVqp1OA3h3588H1302oZH3
	HYWqoTqQyM/KlHQkmVj5Usw5TqQDlG19s08Aa/2LIjvayJs2dbAzKFh+oSxIqEpKs4Fr+H
	PXXta35vN1Qx0gEK3HeL73JP9RcLtyk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-CHMAIrWEPsSRz28UJLYtBg-1; Sun, 18 Jun 2023 10:18:29 -0400
X-MC-Unique: CHMAIrWEPsSRz28UJLYtBg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44F233C025B3;
	Sun, 18 Jun 2023 14:18:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C5E0A40C6F56;
	Sun, 18 Jun 2023 14:18:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7B8401946594;
	Sun, 18 Jun 2023 14:18:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BA20C1946589
 for <dm-devel@listman.corp.redhat.com>; Sun, 18 Jun 2023 14:18:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 769F748FB02; Sun, 18 Jun 2023 14:18:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E92448FB01
 for <dm-devel@redhat.com>; Sun, 18 Jun 2023 14:18:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 535211C04B40
 for <dm-devel@redhat.com>; Sun, 18 Jun 2023 14:18:22 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-A3mseszwPJ-eFb1XXhoWZA-1; Sun, 18 Jun 2023 10:18:18 -0400
X-MC-Unique: A3mseszwPJ-eFb1XXhoWZA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 9EDB960C79;
 Sun, 18 Jun 2023 14:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F3BC433C0;
 Sun, 18 Jun 2023 14:18:16 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	lilingfeng3@huawei.com
Date: Sun, 18 Jun 2023 10:18:14 -0400
Message-Id: <20230618141814.864905-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] Patch "dm: don't lock fs when the map is NULL during
 suspend or resume" has been added to the 6.1-stable tree
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm: don't lock fs when the map is NULL during suspend or resume

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-don-t-lock-fs-when-the-map-is-null-during-suspend.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit d095b9b6985baeff4e10308896522af93b8f8eb4
Author: Li Lingfeng <lilingfeng3@huawei.com>
Date:   Thu Jun 1 14:14:23 2023 +0800

    dm: don't lock fs when the map is NULL during suspend or resume
    
    [ Upstream commit 2760904d895279f87196f0fa9ec570c79fe6a2e4 ]
    
    As described in commit 38d11da522aa ("dm: don't lock fs when the map is
    NULL in process of resume"), a deadlock may be triggered between
    do_resume() and do_mount().
    
    This commit preserves the fix from commit 38d11da522aa but moves it to
    where it also serves to fix a similar deadlock between do_suspend()
    and do_mount().  It does so, if the active map is NULL, by clearing
    DM_SUSPEND_LOCKFS_FLAG in dm_suspend() which is called by both
    do_suspend() and do_resume().
    
    Fixes: 38d11da522aa ("dm: don't lock fs when the map is NULL in process of resume")
    Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 83aecd9250ba6..6ae1c19b82433 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1151,13 +1151,10 @@ static int do_resume(struct dm_ioctl *param)
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
index 24284d22f15bc..acf7e7551c941 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2801,6 +2801,10 @@ int dm_suspend(struct mapped_device *md, unsigned int suspend_flags)
 	}
 
 	map = rcu_dereference_protected(md->map, lockdep_is_held(&md->suspend_lock));
+	if (!map) {
+		/* avoid deadlock with fs/namespace.c:do_mount() */
+		suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
+	}
 
 	r = __dm_suspend(md, map, suspend_flags, TASK_INTERRUPTIBLE, DMF_SUSPENDED);
 	if (r)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


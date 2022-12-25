Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F33CC4167B
	for <dm-devel@archiver.kernel.org>; Sun, 25 Dec 2022 13:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671974396;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=06PTUWJpRdl57gGSPCySGc3BqgYcCQbaCroDZdcDoxQ=;
	b=BNqyvJrkn2guB5nsjMPE9m+jXJHWY23v2yJv/n+JLpWdBGkqCIfuI+P2gV8zy/m0x6eL1Q
	gOllxXJmNZXxIq4eOwpDIaMMaE7RmDr4kstdI4IK4lnwriwNnjeyFx/WkD58rQvXGDxe7u
	LAWC77dmxQ0AuaqsVT/xRCrlF3xLoto=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-2dRzFKTwNmeXrW1m7hBnTw-1; Sun, 25 Dec 2022 08:19:52 -0500
X-MC-Unique: 2dRzFKTwNmeXrW1m7hBnTw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 333F3858F09;
	Sun, 25 Dec 2022 13:19:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 215221121314;
	Sun, 25 Dec 2022 13:19:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 079C51946588;
	Sun, 25 Dec 2022 13:19:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ADC431946586
 for <dm-devel@listman.corp.redhat.com>; Sun, 25 Dec 2022 13:19:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A34E42166B35; Sun, 25 Dec 2022 13:19:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B5C02166B34
 for <dm-devel@redhat.com>; Sun, 25 Dec 2022 13:19:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BC5B101A52E
 for <dm-devel@redhat.com>; Sun, 25 Dec 2022 13:19:49 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-pmSMaDsLMR-vwgUzLOjKig-1; Sun, 25 Dec 2022 08:19:47 -0500
X-MC-Unique: pmSMaDsLMR-vwgUzLOjKig-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id E3DB860C24;
 Sun, 25 Dec 2022 13:19:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC65AC433EF;
 Sun, 25 Dec 2022 13:19:45 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	yukuai3@huawei.com
Date: Sun, 25 Dec 2022 08:19:43 -0500
Message-Id: <20221225131944.601847-1-sashal@kernel.org>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] Patch "dm: make sure create and remove dm device won't
 race with open and close table" has been added to the 6.1-stable tree
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm: make sure create and remove dm device won't race with open and close table

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-make-sure-create-and-remove-dm-device-won-t-race-.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit c54c815ac3d64cd35fc10e8eff95deda62b154e4
Author: Yu Kuai <yukuai3@huawei.com>
Date:   Tue Nov 15 22:10:49 2022 +0800

    dm: make sure create and remove dm device won't race with open and close table
    
    [ Upstream commit d563792c8933a810d28ce0f2831f0726c2b15a31 ]
    
    open_table_device() and close_table_device() is protected by
    table_devices_lock, hence use it to protect add_disk() and
    del_gendisk().
    
    Prepare to track per-add_disk holder relations in dm.
    
    Signed-off-by: Yu Kuai <yukuai3@huawei.com>
    Reviewed-by: Mike Snitzer <snitzer@kernel.org>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Link: https://lore.kernel.org/r/20221115141054.1051801-6-yukuai1@huaweicloud.com
    Signed-off-by: Jens Axboe <axboe@kernel.dk>
    Stable-dep-of: 1a581b721699 ("dm: track per-add_disk holder relations in DM")
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8fb0b97b2df1..f10ac680cef4 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1965,7 +1965,14 @@ static void cleanup_mapped_device(struct mapped_device *md)
 		spin_unlock(&_minor_lock);
 		if (dm_get_md_type(md) != DM_TYPE_NONE) {
 			dm_sysfs_exit(md);
+
+			/*
+			 * Hold lock to make sure del_gendisk() won't concurrent
+			 * with open/close_table_device().
+			 */
+			mutex_lock(&md->table_devices_lock);
 			del_gendisk(md->disk);
+			mutex_unlock(&md->table_devices_lock);
 		}
 		dm_queue_destroy_crypto_profile(md->queue);
 		put_disk(md->disk);
@@ -2325,15 +2332,24 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 	if (r)
 		return r;
 
+	/*
+	 * Hold lock to make sure add_disk() and del_gendisk() won't concurrent
+	 * with open_table_device() and close_table_device().
+	 */
+	mutex_lock(&md->table_devices_lock);
 	r = add_disk(md->disk);
+	mutex_unlock(&md->table_devices_lock);
 	if (r)
 		return r;
 
 	r = dm_sysfs_init(md);
 	if (r) {
+		mutex_lock(&md->table_devices_lock);
 		del_gendisk(md->disk);
+		mutex_unlock(&md->table_devices_lock);
 		return r;
 	}
+
 	md->type = type;
 	return 0;
 }

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


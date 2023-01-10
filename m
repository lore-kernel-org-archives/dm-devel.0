Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F6D6C54EBD
	for <dm-devel@archiver.kernel.org>; Tue, 10 Jan 2023 02:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673317692;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/Qu+Sv0qveyGDA8tG649ibCBblzzOcDT3jRrLck4xtU=;
	b=CRrZ1NlqD13VXsFPyT/0oOcqSoq2zGqTx98q8AzRPwEv1PoShKC2dGTUEYKbZczqc8Fsxf
	7TjCkSMn7bQ/eU1QR5iS0neKw77nZm/r/uOxgyl6g7QCN3LfP7NDrXSDieWSMeG4gfv0Ze
	b/Z7DBJlPILerhLTVR7KraQEvWkdyUE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-TUBVzOXDOmOC9USjHGHf1g-1; Mon, 09 Jan 2023 21:28:09 -0500
X-MC-Unique: TUBVzOXDOmOC9USjHGHf1g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9ADF8811E6E;
	Tue, 10 Jan 2023 02:28:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8935440C2064;
	Tue, 10 Jan 2023 02:28:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6326F19459DB;
	Tue, 10 Jan 2023 02:28:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E0FA61946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 10 Jan 2023 02:28:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 79F161121318; Tue, 10 Jan 2023 02:28:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 72C661121314
 for <dm-devel@redhat.com>; Tue, 10 Jan 2023 02:28:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 534E73C0CD3C
 for <dm-devel@redhat.com>; Tue, 10 Jan 2023 02:28:05 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-140-w6ItTWULNRq1JNgjF7-8wQ-1; Mon, 09 Jan 2023 21:28:01 -0500
X-MC-Unique: w6ItTWULNRq1JNgjF7-8wQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id E8DFA614BE;
 Tue, 10 Jan 2023 02:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD61DC433EF;
 Tue, 10 Jan 2023 02:27:59 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	luomeng12@huawei.com
Date: Mon,  9 Jan 2023 21:27:57 -0500
Message-Id: <20230110022758.2864767-1-sashal@kernel.org>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] Patch "dm thin: resume even if in FAIL mode" has been
 added to the 4.19-stable tree
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm thin: resume even if in FAIL mode

to the 4.19-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-thin-resume-even-if-in-fail-mode.patch
and it can be found in the queue-4.19 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit a73aeed02ca2e67f6b7ed6662f664affd8fb3d82
Author: Luo Meng <luomeng12@huawei.com>
Date:   Wed Nov 30 10:09:45 2022 +0800

    dm thin: resume even if in FAIL mode
    
    [ Upstream commit 19eb1650afeb1aa86151f61900e9e5f1de5d8d02 ]
    
    If a thinpool set fail_io while suspending, resume will fail with:
     device-mapper: resume ioctl on vg-thinpool  failed: Invalid argument
    
    The thin-pool also can't be removed if an in-flight bio is in the
    deferred list.
    
    This can be easily reproduced using:
    
      echo "offline" > /sys/block/sda/device/state
      dd if=/dev/zero of=/dev/mapper/thin bs=4K count=1
      dmsetup suspend /dev/mapper/pool
      mkfs.ext4 /dev/mapper/thin
      dmsetup resume /dev/mapper/pool
    
    The root cause is maybe_resize_data_dev() will check fail_io and return
    error before called dm_resume.
    
    Fix this by adding FAIL mode check at the end of pool_preresume().
    
    Cc: stable@vger.kernel.org
    Fixes: da105ed5fd7e ("dm thin metadata: introduce dm_pool_abort_metadata")
    Signed-off-by: Luo Meng <luomeng12@huawei.com>
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 1916becc20e0..386cb3395378 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3549,20 +3549,28 @@ static int pool_preresume(struct dm_target *ti)
 	 */
 	r = bind_control_target(pool, ti);
 	if (r)
-		return r;
+		goto out;
 
 	r = maybe_resize_data_dev(ti, &need_commit1);
 	if (r)
-		return r;
+		goto out;
 
 	r = maybe_resize_metadata_dev(ti, &need_commit2);
 	if (r)
-		return r;
+		goto out;
 
 	if (need_commit1 || need_commit2)
 		(void) commit(pool);
+out:
+	/*
+	 * When a thin-pool is PM_FAIL, it cannot be rebuilt if
+	 * bio is in deferred list. Therefore need to return 0
+	 * to allow pool_resume() to flush IO.
+	 */
+	if (r && get_pool_mode(pool) == PM_FAIL)
+		r = 0;
 
-	return 0;
+	return r;
 }
 
 static void pool_suspend_active_thins(struct pool *pool)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


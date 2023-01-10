Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ABE3C54EBD
	for <dm-devel@archiver.kernel.org>; Tue, 10 Jan 2023 02:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673317552;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=X0OyGIHPg7MqhVECVTF8f0JwuuNDUzE9CNgZZdIssjo=;
	b=MKhoRIQ1GxG1O61+9Biix0z90H0Dcb9OjxlAhSBD9TBmW45ttCaocE5o8Sx1dQroFlFBjN
	JtXjP2jLqIoxRMSvtfW65ldLxjW+q8VAiXOaGbxx5j47QNq8rXAD2AOjkVFzfKvCJa1qOc
	xJGG2f3eHLkKZyCGGPLqVQdEPm4cT3Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451--5NUfZnoMQqHDyeniwkq5w-1; Mon, 09 Jan 2023 21:25:49 -0500
X-MC-Unique: -5NUfZnoMQqHDyeniwkq5w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C1B8101A52E;
	Tue, 10 Jan 2023 02:25:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4BC50492B00;
	Tue, 10 Jan 2023 02:25:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 25D2B19459DB;
	Tue, 10 Jan 2023 02:25:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B40421946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 10 Jan 2023 02:25:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5E6E7492C1B; Tue, 10 Jan 2023 02:25:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 569F0492C18
 for <dm-devel@redhat.com>; Tue, 10 Jan 2023 02:25:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C9B938041D4
 for <dm-devel@redhat.com>; Tue, 10 Jan 2023 02:25:43 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-aAfGXsXRODu6Y-VdI7OzVw-1; Mon, 09 Jan 2023 21:25:41 -0500
X-MC-Unique: aAfGXsXRODu6Y-VdI7OzVw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 2F89EB810CF;
 Tue, 10 Jan 2023 02:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C39DC433EF;
 Tue, 10 Jan 2023 02:25:38 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	luomeng12@huawei.com
Date: Mon,  9 Jan 2023 21:25:37 -0500
Message-Id: <20230110022537.2862903-1-sashal@kernel.org>
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
Subject: [dm-devel] Patch "dm thin: resume even if in FAIL mode" has been
 added to the 5.4-stable tree
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm thin: resume even if in FAIL mode

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-thin-resume-even-if-in-fail-mode.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit ac99413d3a22b5c9db7fc55f0ecca8d9798a622f
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
index 1af5873923e8..4f161725dda0 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3593,23 +3593,31 @@ static int pool_preresume(struct dm_target *ti)
 	 */
 	r = bind_control_target(pool, ti);
 	if (r)
-		return r;
+		goto out;
 
 	dm_pool_register_pre_commit_callback(pool->pmd,
 					     metadata_pre_commit_callback, pt);
 
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


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37DA7C77B61
	for <dm-devel@archiver.kernel.org>; Thu, 13 Apr 2023 11:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681386609;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dRG8ExzZOSwNetFi17yX21HwgxjbwnEH1FqOUuf6xTM=;
	b=XhFODRCEIgUz9gAQ0cEA1bLGQnMQMgZ5+0MKKT9x9Qd55MOPs+xfSBfgVFr13pQ8KyAPWV
	2K5nINlbuQXdiUaVN3kLzNy1J0dITs2VQvJQTOJHhh47Nz3NMYxIZMzJGL+DTvb5RFI566
	Jgah/uzJAwala9wJM1E6yhdr2BIKxQk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-1oO38TATNlaNpvSCATT6fQ-1; Thu, 13 Apr 2023 07:50:07 -0400
X-MC-Unique: 1oO38TATNlaNpvSCATT6fQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01727101A552;
	Thu, 13 Apr 2023 11:50:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E2E77492C14;
	Thu, 13 Apr 2023 11:50:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BCAFE19465B7;
	Thu, 13 Apr 2023 11:50:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8FA0619465B6
 for <dm-devel@listman.corp.redhat.com>; Thu, 13 Apr 2023 11:50:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 63145492B00; Thu, 13 Apr 2023 11:50:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BE21492C3E
 for <dm-devel@redhat.com>; Thu, 13 Apr 2023 11:50:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42F53800B35
 for <dm-devel@redhat.com>; Thu, 13 Apr 2023 11:50:04 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-333-H2m1X7ukMVqKcT4z_OT4Pw-1; Thu, 13 Apr 2023 07:50:02 -0400
X-MC-Unique: H2m1X7ukMVqKcT4z_OT4Pw-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4PxyBS54X0z4f3jMx
 for <dm-devel@redhat.com>; Thu, 13 Apr 2023 19:33:20 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgCH77KA6DdkC6FCHQ--.33135S5;
 Thu, 13 Apr 2023 19:33:22 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: dm-devel@redhat.com,
	song@kernel.org,
	logang@deltatee.com
Date: Thu, 13 Apr 2023 19:32:13 +0800
Message-Id: <20230413113217.1934353-2-yukuai1@huaweicloud.com>
In-Reply-To: <20230413113217.1934353-1-yukuai1@huaweicloud.com>
References: <20230413113217.1934353-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgCH77KA6DdkC6FCHQ--.33135S5
X-Coremail-Antispam: 1UD129KBjvJXoWxXFW8CF17JrW5Xr1kKF4xtFb_yoW5CFW3p3
 y8tF15Wr48ZFZxZFZrJa4DCa4rZr10qFy7try7Cw4rJw1rKw43tFyS9FyjyFyDAFyrAw45
 Zw15tFWrurZ2kr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUU9q14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
 x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
 Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1l84
 ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I2
 62IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcV
 AFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG
 0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vIr41l4I8I3I
 0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWU
 GVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI
 0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0
 rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r
 4UJbIYCTnIWIevJa73UjIFyTuYvjfU5SoXUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH -next v6 1/5] md: factor out a helper to wake up
 md_thread directly
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yukuai1@huaweicloud.com, yukuai3@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

md_wakeup_thread() can't wakeup md_thread->tsk if md_thread->run is
still in progress, and in some cases md_thread->tsk need to be woke up
directly, like md_set_readonly() and do_md_stop().

Commit 9dfbdafda3b3 ("md: unlock mddev before reap sync_thread in
action_store") introduce a new scenario where unregister sync_thread is
not protected by 'reconfig_mutex', this can cause null-ptr-deference in
theroy:

t1: md_set_readonly		t2: action_store
				md_unregister_thread
				// 'reconfig_mutex' is not held
// 'reconfig_mutex' is held by caller
if (mddev->sync_thread)
				 thread = *threadp
				 *threadp = NULL
 wake_up_process(mddev->sync_thread->tsk)
 // null-ptr-deference

This patch factor out a helper to wake up md_thread directly, so that
'sync_thread' won't be accessed multiple times from the reader side. And
perhaps this helper will be used later to fix action_store().

This patch also prepare to protect md_thread with rcu.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9bc05f451d42..e3c30500bd15 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -92,6 +92,7 @@ static struct workqueue_struct *md_rdev_misc_wq;
 static int remove_and_add_spares(struct mddev *mddev,
 				 struct md_rdev *this);
 static void mddev_detach(struct mddev *mddev);
+static void md_wakeup_thread_directly(struct md_thread *thread);
 
 enum md_ro_state {
 	MD_RDWR,
@@ -6269,10 +6270,12 @@ static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
 	}
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-	if (mddev->sync_thread)
-		/* Thread might be blocked waiting for metadata update
-		 * which will now never happen */
-		wake_up_process(mddev->sync_thread->tsk);
+
+	/*
+	 * Thread might be blocked waiting for metadata update which will now
+	 * never happen
+	 */
+	md_wakeup_thread_directly(mddev->sync_thread);
 
 	if (mddev->external && test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
 		return -EBUSY;
@@ -6333,10 +6336,12 @@ static int do_md_stop(struct mddev *mddev, int mode,
 	}
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-	if (mddev->sync_thread)
-		/* Thread might be blocked waiting for metadata update
-		 * which will now never happen */
-		wake_up_process(mddev->sync_thread->tsk);
+
+	/*
+	 * Thread might be blocked waiting for metadata update which will now
+	 * never happen
+	 */
+	md_wakeup_thread_directly(mddev->sync_thread);
 
 	mddev_unlock(mddev);
 	wait_event(resync_wait, (mddev->sync_thread == NULL &&
@@ -7886,6 +7891,12 @@ static int md_thread(void *arg)
 	return 0;
 }
 
+static void md_wakeup_thread_directly(struct md_thread *thread)
+{
+	if (thread)
+		wake_up_process(thread->tsk);
+}
+
 void md_wakeup_thread(struct md_thread *thread)
 {
 	if (thread) {
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


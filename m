Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D813C433FE
	for <dm-devel@archiver.kernel.org>; Tue, 11 Oct 2022 07:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665472934;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xUySnuJQBf1iAGfN2165YAvIbf9fms0PVtw5ADksUaw=;
	b=ONhOj/fNkskcXCDC7HYyhfYxFMSU8TLJpCzX5YEbD//dgC0P5IKN7/PbXh2FNAVsSy3qAE
	ycX1cWPrV2nXL8gXo4bCsRzVm96nv6fMUWWIxsfE+k3fIyA9zXUKWo4ACIcIS7Ou9E9cDM
	aNEWPzKIGBViZ6RPkSk54JV1zjveWMo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-PE7g31lpOBi24TKRAOpWWA-1; Tue, 11 Oct 2022 03:22:11 -0400
X-MC-Unique: PE7g31lpOBi24TKRAOpWWA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC9771C07552;
	Tue, 11 Oct 2022 07:22:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 966BD145D82C;
	Tue, 11 Oct 2022 07:22:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E29531946A51;
	Tue, 11 Oct 2022 07:22:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 52E4E1946597
 for <dm-devel@listman.corp.redhat.com>; Mon, 10 Oct 2022 14:42:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2723F2027061; Mon, 10 Oct 2022 14:42:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F7252083A6D
 for <dm-devel@redhat.com>; Mon, 10 Oct 2022 14:42:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4337B185A7A3
 for <dm-devel@redhat.com>; Mon, 10 Oct 2022 14:33:34 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-TcpBwQ4lPdiCawDBYKXQDg-1; Mon, 10 Oct 2022 10:33:29 -0400
X-MC-Unique: TcpBwQ4lPdiCawDBYKXQDg-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4MmLXK4yk9zlB0w;
 Mon, 10 Oct 2022 22:14:57 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
 by APP4 (Coremail) with SMTP id gCh0CgA3N8lSKURjZQ07AA--.26864S4;
 Mon, 10 Oct 2022 22:16:52 +0800 (CST)
From: Luo Meng <luomeng@huaweicloud.com>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, ejt@redhat.com
Date: Mon, 10 Oct 2022 22:39:05 +0800
Message-Id: <20221010143905.240306-1-luomeng@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgA3N8lSKURjZQ07AA--.26864S4
X-Coremail-Antispam: 1UD129KBjvJXoWxGryDWFyrCF15GFy8tw17GFg_yoW5WF4Upw
 4Fg39ay3s5WF1jvw4kJw4UAa4jyF4Fyay5GrW3Cryxu34fX345uFWxXF93XFyDJFyUJrsx
 XFy3t3yruF1UtF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUgGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
 AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
 j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
 kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
 bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
 AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
 42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s
 1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnI
 WIevJa73UjIFyTuYvjxUOyCJDUUUU
X-CM-SenderInfo: 5oxrzvtqj6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Tue, 11 Oct 2022 07:22:04 +0000
Subject: [dm-devel] dm: Fix UAF in run_timer_softirq()
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
Cc: luomeng12@huawei.com, yukuai3@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Luo Meng <luomeng12@huawei.com>

When dm_resume() and dm_destroy() are concurrent, it will
lead to UAF.

One of the concurrency UAF can be shown as below:

        use                                  free
do_resume                           |
  __find_device_hash_cell           |
    dm_get                          |
      atomic_inc(&md->holders)      |
                                    | dm_destroy
				    |   __dm_destroy
				    |     if (!dm_suspended_md(md))
                                    |     atomic_read(&md->holders)
				    |     msleep(1)
  dm_resume                         |
    __dm_resume                     |
      dm_table_resume_targets       |
	pool_resume                 |
	  do_waker  #add delay work |
				    |     dm_table_destroy
				    |       pool_dtr
				    |         __pool_dec
                                    |           __pool_destroy
                                    |             destroy_workqueue
                                    |             kfree(pool) # free pool
	time out
__do_softirq
  run_timer_softirq # pool has already been freed

This can be easily reproduced using:
  1. create thin-pool
  2. dmsetup suspend pool
  3. dmsetup resume pool
  4. dmsetup remove_all # Concurrent with 3

The root cause of UAF bugs is that dm_resume() adds timer after
dm_destroy() skips cancel timer beause of suspend status. After
timeout, it will call run_timer_softirq(), however pool has already
been freed. The concurrency UAF bug will happen.

Therefore, canceling timer is moved after md->holders is zero.

Signed-off-by: Luo Meng <luomeng12@huawei.com>
---
 drivers/md/dm.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 60549b65c799..379525313628 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2420,6 +2420,19 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 
 	blk_mark_disk_dead(md->disk);
 
+	/*
+	 * Rare, but there may be I/O requests still going to complete,
+	 * for example.  Wait for all references to disappear.
+	 * No one should increment the reference count of the mapped_device,
+	 * after the mapped_device state becomes DMF_FREEING.
+	 */
+	if (wait)
+		while (atomic_read(&md->holders))
+			msleep(1);
+	else if (atomic_read(&md->holders))
+		DMWARN("%s: Forcibly removing mapped_device still in use! (%d users)",
+		       dm_device_name(md), atomic_read(&md->holders));
+
 	/*
 	 * Take suspend_lock so that presuspend and postsuspend methods
 	 * do not race with internal suspend.
@@ -2436,19 +2449,6 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 	dm_put_live_table(md, srcu_idx);
 	mutex_unlock(&md->suspend_lock);
 
-	/*
-	 * Rare, but there may be I/O requests still going to complete,
-	 * for example.  Wait for all references to disappear.
-	 * No one should increment the reference count of the mapped_device,
-	 * after the mapped_device state becomes DMF_FREEING.
-	 */
-	if (wait)
-		while (atomic_read(&md->holders))
-			msleep(1);
-	else if (atomic_read(&md->holders))
-		DMWARN("%s: Forcibly removing mapped_device still in use! (%d users)",
-		       dm_device_name(md), atomic_read(&md->holders));
-
 	dm_table_destroy(__unbind(md));
 	free_dev(md);
 }
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


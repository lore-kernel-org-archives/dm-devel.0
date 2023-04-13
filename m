Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AD54C77B6E
	for <dm-devel@archiver.kernel.org>; Thu, 13 Apr 2023 11:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681386610;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OysyTrvySiqXWHvtLFv9Ce2Ff9zqktQ9S6ifvdmHOOU=;
	b=YXhFHMmUXnJKoDqREw8gXA0uZFW3uhIFxDdYGmjIzUE6MOKxLdUdmboOoYfFwioUF3LaZ/
	k4rrHY2NA96RbofCvKw22L7BZ3suzee6R+jxVMmwqk1dvU6V3BSyV+WsMQOg2Fi0fGL0qd
	EGcA5mZdIYgFNEGEiGXLAvk+41L6z+4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-loUQ6sY5OvSIVqPiNAAJIw-1; Thu, 13 Apr 2023 07:50:08 -0400
X-MC-Unique: loUQ6sY5OvSIVqPiNAAJIw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2240538123AD;
	Thu, 13 Apr 2023 11:50:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0F22B2027043;
	Thu, 13 Apr 2023 11:50:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E210419465B7;
	Thu, 13 Apr 2023 11:50:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0149A1946A75
 for <dm-devel@listman.corp.redhat.com>; Thu, 13 Apr 2023 11:50:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E6A01492C14; Thu, 13 Apr 2023 11:50:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DE911492C13
 for <dm-devel@redhat.com>; Thu, 13 Apr 2023 11:50:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C35DB85530F
 for <dm-devel@redhat.com>; Thu, 13 Apr 2023 11:50:04 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-hFTPRBNiMrqGQxIgBO7cfw-1; Thu, 13 Apr 2023 07:50:01 -0400
X-MC-Unique: hFTPRBNiMrqGQxIgBO7cfw-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4PxyBT6kDfz4f3whD
 for <dm-devel@redhat.com>; Thu, 13 Apr 2023 19:33:21 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgCH77KA6DdkC6FCHQ--.33135S8;
 Thu, 13 Apr 2023 19:33:23 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: dm-devel@redhat.com,
	song@kernel.org,
	logang@deltatee.com
Date: Thu, 13 Apr 2023 19:32:16 +0800
Message-Id: <20230413113217.1934353-5-yukuai1@huaweicloud.com>
In-Reply-To: <20230413113217.1934353-1-yukuai1@huaweicloud.com>
References: <20230413113217.1934353-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgCH77KA6DdkC6FCHQ--.33135S8
X-Coremail-Antispam: 1UD129KBjvJXoWxJF1xXrWfJryrKF4UKw18Grg_yoWrXFyUp3
 yfKas0yF18XrWfXw4xJaykCF1rXr1vqFZrtryxX34rCwn8Gws3tFyrWa4Dt3WDC34rAFs0
 q3W5GrW8CFyUWr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUU9G14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
 kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
 z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr
 1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
 M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
 v20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
 F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48JMx
 C20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAF
 wI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20x
 vE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v2
 0xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxV
 W8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbmZX7UUUUU==
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH -next v6 4/5] md/bitmap: factor out a helper to
 set timeout
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

Register/unregister 'mddev->thread' are both under 'reconfig_mutex',
however, some context didn't hold the mutex to access mddev->thread,
which can cause null-ptr-deference:

1) md_bitmap_daemon_work() can be called from md_check_recovery() where
'reconfig_mutex' is not held, deference 'mddev->thread' might cause
null-ptr-deference, because md_unregister_thread() reset the pointer
before stopping the thread.

2) timeout_store() access 'mddev->thread' multiple times,
null-ptr-deference can be triggered if 'mddev->thread' is reset in the
middle.

This patch factor out a helper to set timeout, the new helper always
check if 'mddev->thread' is null first, so that problem 1 can be fixed.

Now that this helper only access 'mddev->thread' once, but it's possible
that 'mddev->thread' is freed while this helper is still in progress,
hence the problem is not fixed yet. Follow up patches will fix this by
protecting md_thread with rcu.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 014e5c8a4fe0..29fd41ef55a6 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1218,11 +1218,22 @@ static bitmap_counter_t *md_bitmap_get_counter(struct bitmap_counts *bitmap,
 					       sector_t offset, sector_t *blocks,
 					       int create);
 
+static void mddev_set_timeout(struct mddev *mddev, unsigned long timeout,
+			      bool force)
+{
+	struct md_thread *thread = mddev->thread;
+
+	if (!thread)
+		return;
+
+	if (force || thread->timeout < MAX_SCHEDULE_TIMEOUT)
+		thread->timeout = timeout;
+}
+
 /*
  * bitmap daemon -- periodically wakes up to clean bits and flush pages
  *			out to disk
  */
-
 void md_bitmap_daemon_work(struct mddev *mddev)
 {
 	struct bitmap *bitmap;
@@ -1246,7 +1257,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
 
 	bitmap->daemon_lastrun = jiffies;
 	if (bitmap->allclean) {
-		mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
+		mddev_set_timeout(mddev, MAX_SCHEDULE_TIMEOUT, true);
 		goto done;
 	}
 	bitmap->allclean = 1;
@@ -1343,8 +1354,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
 
  done:
 	if (bitmap->allclean == 0)
-		mddev->thread->timeout =
-			mddev->bitmap_info.daemon_sleep;
+		mddev_set_timeout(mddev, mddev->bitmap_info.daemon_sleep, true);
 	mutex_unlock(&mddev->bitmap_info.mutex);
 }
 
@@ -1797,8 +1807,7 @@ void md_bitmap_destroy(struct mddev *mddev)
 	mddev->bitmap = NULL; /* disconnect from the md device */
 	spin_unlock(&mddev->lock);
 	mutex_unlock(&mddev->bitmap_info.mutex);
-	if (mddev->thread)
-		mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
+	mddev_set_timeout(mddev, MAX_SCHEDULE_TIMEOUT, true);
 
 	md_bitmap_free(bitmap);
 }
@@ -1941,7 +1950,7 @@ int md_bitmap_load(struct mddev *mddev)
 	/* Kick recovery in case any bits were set */
 	set_bit(MD_RECOVERY_NEEDED, &bitmap->mddev->recovery);
 
-	mddev->thread->timeout = mddev->bitmap_info.daemon_sleep;
+	mddev_set_timeout(mddev, mddev->bitmap_info.daemon_sleep, true);
 	md_wakeup_thread(mddev->thread);
 
 	md_bitmap_update_sb(bitmap);
@@ -2446,17 +2455,11 @@ timeout_store(struct mddev *mddev, const char *buf, size_t len)
 		timeout = MAX_SCHEDULE_TIMEOUT-1;
 	if (timeout < 1)
 		timeout = 1;
-	mddev->bitmap_info.daemon_sleep = timeout;
-	if (mddev->thread) {
-		/* if thread->timeout is MAX_SCHEDULE_TIMEOUT, then
-		 * the bitmap is all clean and we don't need to
-		 * adjust the timeout right now
-		 */
-		if (mddev->thread->timeout < MAX_SCHEDULE_TIMEOUT)
-			mddev->thread->timeout = timeout;
-	}
 
+	mddev->bitmap_info.daemon_sleep = timeout;
+	mddev_set_timeout(mddev, timeout, false);
 	md_wakeup_thread(mddev->thread);
+
 	return len;
 }
 
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


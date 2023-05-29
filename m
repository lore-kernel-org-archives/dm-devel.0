Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2734C77B7E
	for <dm-devel@archiver.kernel.org>; Mon, 29 May 2023 13:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685366740;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XlhevLoExuWF1gkDQJ8GJtfPndCrk5uYyGD27SOMTy4=;
	b=TDVBTg5FGIY07BeRVTInLpOCOkA4ZUAHOLMADj9JzYpbsZn9liEgEyanKPAksiJdaEpZXM
	3ErXTvWrXoeyqLVX3vSVtoH93dO+ICSFmGsZwF8TAYLZR7Yo0/H72PIEyjPiGcO1nAVF4v
	bigDBy3R+8GzwK/IKz9FhZuuq3wtgpE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-gQYXPMV8OKeOlDJ23UtcPQ-1; Mon, 29 May 2023 09:25:37 -0400
X-MC-Unique: gQYXPMV8OKeOlDJ23UtcPQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D03D101AA42;
	Mon, 29 May 2023 13:25:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 87BC32166B2B;
	Mon, 29 May 2023 13:25:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C738B19465B7;
	Mon, 29 May 2023 13:25:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B7916194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 29 May 2023 13:24:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A41D720296C8; Mon, 29 May 2023 13:24:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C9D520296C6
 for <dm-devel@redhat.com>; Mon, 29 May 2023 13:24:22 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C87F1C0512C
 for <dm-devel@redhat.com>; Mon, 29 May 2023 13:24:22 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-ehQEa18kOVSVezrGiktKqw-1; Mon, 29 May 2023 09:24:20 -0400
X-MC-Unique: ehQEa18kOVSVezrGiktKqw-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QVGT94nXbz4f3sk0;
 Mon, 29 May 2023 21:24:13 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAHvbB9p3RkWVPoKQ--.23397S6;
 Mon, 29 May 2023 21:24:15 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: guoqing.jiang@linux.dev, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com, song@kernel.org
Date: Mon, 29 May 2023 21:20:33 +0800
Message-Id: <20230529132037.2124527-3-yukuai1@huaweicloud.com>
In-Reply-To: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAHvbB9p3RkWVPoKQ--.23397S6
X-Coremail-Antispam: 1UD129KBjvJXoWxuF45Ww4rtw1rCF1DAFyfXrb_yoW5Xr1kp3
 yftas8ArW8JFy3Z343K3WDZay5Zw1IqrWDtrW3W3s5JF1fJF47Gw1Y93WxAFykJa4ftr15
 Xa98JFWfuryrGr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUPY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
 x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
 Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
 A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
 0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
 IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
 Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
 xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
 6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
 Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
 Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr
 1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUAGYLU
 UUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH -next v2 2/6] md: refactor action_store() for
 'idle' and 'frozen'
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

Prepare to handle 'idle' and 'frozen' differently to fix a deadlock, there
are no functional changes except that MD_RECOVERY_RUNNING is checked
again after 'reconfig_mutex' is held.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 61 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 45 insertions(+), 16 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9b97731e1fe4..23e8e7eae062 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4755,6 +4755,46 @@ action_show(struct mddev *mddev, char *page)
 	return sprintf(page, "%s\n", type);
 }
 
+static void stop_sync_thread(struct mddev *mddev)
+{
+	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+		return;
+
+	if (mddev_lock(mddev))
+		return;
+
+	/*
+	 * Check again in case MD_RECOVERY_RUNNING is cleared before lock is
+	 * held.
+	 */
+	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
+		mddev_unlock(mddev);
+		return;
+	}
+
+	if (work_pending(&mddev->del_work))
+		flush_workqueue(md_misc_wq);
+
+	if (mddev->sync_thread) {
+		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+		md_reap_sync_thread(mddev);
+	}
+
+	mddev_unlock(mddev);
+}
+
+static void idle_sync_thread(struct mddev *mddev)
+{
+	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+	stop_sync_thread(mddev);
+}
+
+static void frozen_sync_thread(struct mddev *mddev)
+{
+	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+	stop_sync_thread(mddev);
+}
+
 static ssize_t
 action_store(struct mddev *mddev, const char *page, size_t len)
 {
@@ -4762,22 +4802,11 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 		return -EINVAL;
 
 
-	if (cmd_match(page, "idle") || cmd_match(page, "frozen")) {
-		if (cmd_match(page, "frozen"))
-			set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-		else
-			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
-		    mddev_lock(mddev) == 0) {
-			if (work_pending(&mddev->del_work))
-				flush_workqueue(md_misc_wq);
-			if (mddev->sync_thread) {
-				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-				md_reap_sync_thread(mddev);
-			}
-			mddev_unlock(mddev);
-		}
-	} else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+	if (cmd_match(page, "idle"))
+		idle_sync_thread(mddev);
+	else if (cmd_match(page, "frozen"))
+		frozen_sync_thread(mddev);
+	else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return -EBUSY;
 	else if (cmd_match(page, "resync"))
 		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


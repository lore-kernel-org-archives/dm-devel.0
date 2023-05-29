Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A9D3C77B7A
	for <dm-devel@archiver.kernel.org>; Mon, 29 May 2023 13:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685366789;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tv3pjYcpMPJ9FwERR7pxXTpzKA9minqq1DvURKzil/E=;
	b=LXAjnVfRPb4dCeuQTT5N+GD3yO7s5b5OouglkxH0nWTyKAqorIJxXK8SIsKUl4ZlFkfoQw
	vnU7aey8JRCLQ/1SNv/lo8U1llmUWShf/cVgYtoSSxMrw3U6BSsChXJtABeMssVAn7nXfa
	Ky78MF25G1ddc66AaQEaEaKfmY6lq2Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-439-wKWTWoLOP5a0teK3SxHNcQ-1; Mon, 29 May 2023 09:26:27 -0400
X-MC-Unique: wKWTWoLOP5a0teK3SxHNcQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B87D811E7F;
	Mon, 29 May 2023 13:26:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 29320492B0A;
	Mon, 29 May 2023 13:26:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5560419465B3;
	Mon, 29 May 2023 13:25:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C19C219465A2
 for <dm-devel@listman.corp.redhat.com>; Mon, 29 May 2023 13:24:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B4D48140E956; Mon, 29 May 2023 13:24:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AD769140E954
 for <dm-devel@redhat.com>; Mon, 29 May 2023 13:24:26 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F0B78007D9
 for <dm-devel@redhat.com>; Mon, 29 May 2023 13:24:26 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-92-E2102jXOOxacZEwcoyUX7Q-1; Mon, 29 May 2023 09:24:24 -0400
X-MC-Unique: E2102jXOOxacZEwcoyUX7Q-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QVGTF29lhz4f3w0v;
 Mon, 29 May 2023 21:24:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAHvbB9p3RkWVPoKQ--.23397S10;
 Mon, 29 May 2023 21:24:18 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: guoqing.jiang@linux.dev, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com, song@kernel.org
Date: Mon, 29 May 2023 21:20:37 +0800
Message-Id: <20230529132037.2124527-7-yukuai1@huaweicloud.com>
In-Reply-To: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAHvbB9p3RkWVPoKQ--.23397S10
X-Coremail-Antispam: 1UD129KBjvJXoW7CF1DXF15WF4fCry5trW3Awb_yoW8CryUpF
 WfWas8GrW8ZFW3ZrW7Ka4DJayrAw40vayjyFy3Wa4rJF13ta129345uF1UAFWDAa9aq3WY
 y3W5JFs3Zry8Cw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUP214x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
 kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
 z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
 xdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
 M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
 v20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
 F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
 IY04v7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
 wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc4
 0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY1x0267AK
 xVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JV
 WxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VU17G
 YJUUUUU==
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH -next v2 6/6] md: enhance checking in
 md_check_recovery()
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

For md_check_recovery():

1) if 'MD_RECOVERY_RUNING' is not set, register new sync_thread.
2) if 'MD_RECOVERY_RUNING' is set:
 a) if 'MD_RECOVERY_DONE' is not set, don't do anything, wait for
   md_do_sync() to be done.
 b) if 'MD_RECOVERY_DONE' is set, unregister sync_thread. Current code
   expects that sync_thread is not NULL, otherwise new sync_thread will
   be registered, which will corrupt the array.

Make sure md_check_recovery() won't register new sync_thread if
'MD_RECOVERY_RUNING' is still set, and a new WARN_ON_ONCE() is added for
the above corruption,

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f90226e6ddf8..9da0fc906bbd 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9397,16 +9397,24 @@ void md_check_recovery(struct mddev *mddev)
 		if (mddev->sb_flags)
 			md_update_sb(mddev, 0);
 
-		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
-		    !test_bit(MD_RECOVERY_DONE, &mddev->recovery)) {
-			/* resync/recovery still happening */
-			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-			goto unlock;
-		}
-		if (mddev->sync_thread) {
+		/*
+		 * Never start a new sync thread if MD_RECOVERY_RUNNING is
+		 * still set.
+		 */
+		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
+			if (!test_bit(MD_RECOVERY_DONE, &mddev->recovery)) {
+				/* resync/recovery still happening */
+				clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+				goto unlock;
+			}
+
+			if (WARN_ON_ONCE(!mddev->sync_thread))
+				goto unlock;
+
 			md_reap_sync_thread(mddev);
 			goto unlock;
 		}
+
 		/* Set RUNNING before clearing NEEDED to avoid
 		 * any transients in the value of "sync_action".
 		 */
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


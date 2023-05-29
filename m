Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82863C77B7A
	for <dm-devel@archiver.kernel.org>; Mon, 29 May 2023 13:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685366730;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=K5ILKcHdvhXaGz1gy9M+PCexedLSd4QOP/SuMMf9Ilg=;
	b=XLgciTyRAPvOnakxlbWpBRVRuZAekj7naqE6fWbPSQZoHHAks1k6Snkn7ecK90taljMm8e
	gbSv6UOdMDK5OBJG/RjYKgepYHDaMtZK1YEUKAURN6+bGNnv35ggSNgN1uf925S2UhD6wK
	3sKshM8UpEmbDGm2y6pwEkqxmPEJDJw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-gC33WvOBN1iZIu2Kt-6ZYg-1; Mon, 29 May 2023 09:25:28 -0400
X-MC-Unique: gC33WvOBN1iZIu2Kt-6ZYg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0691A3C0BE33;
	Mon, 29 May 2023 13:25:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EE8DE140E954;
	Mon, 29 May 2023 13:25:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ACAE61946595;
	Mon, 29 May 2023 13:25:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C5D6E19465B2
 for <dm-devel@listman.corp.redhat.com>; Mon, 29 May 2023 13:24:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 45B792166B2F; Mon, 29 May 2023 13:24:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D79F2166B2B
 for <dm-devel@redhat.com>; Mon, 29 May 2023 13:24:23 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21061800159
 for <dm-devel@redhat.com>; Mon, 29 May 2023 13:24:23 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-457-4ACubHW_OVeQlTYFfkFAGA-1; Mon, 29 May 2023 09:24:20 -0400
X-MC-Unique: 4ACubHW_OVeQlTYFfkFAGA-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QVGTB16Q7z4f3sk1;
 Mon, 29 May 2023 21:24:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAHvbB9p3RkWVPoKQ--.23397S7;
 Mon, 29 May 2023 21:24:15 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: guoqing.jiang@linux.dev, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com, song@kernel.org
Date: Mon, 29 May 2023 21:20:34 +0800
Message-Id: <20230529132037.2124527-4-yukuai1@huaweicloud.com>
In-Reply-To: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAHvbB9p3RkWVPoKQ--.23397S7
X-Coremail-Antispam: 1UD129KBjvJXoWxJryUWFy7Zw43WFW7ArWUurg_yoW8KFyUpF
 WxJa95Ar4DArsxAr17Jan7uay5Xwn2gFWDtry3Ca1fG3WfAr4qqFn0gFWUuFykCa4fAF9F
 q3Z5XF43ZFy8Wr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUPY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
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
 1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUCXdbU
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH -next v2 3/6] md: add a mutex to synchronize idle
 and frozen in action_store()
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

Currently, for idle and frozen, action_store will hold 'reconfig_mutex'
and call md_reap_sync_thread() to stop sync thread, however, this will
cause deadlock (explained in the next patch). In order to fix the
problem, following patch will release 'reconfig_mutex' and wait on
'resync_wait', like md_set_readonly() and do_md_stop() does.

Consider that action_store() will set/clear 'MD_RECOVERY_FROZEN'
unconditionally, which might cause unexpected problems, for example,
frozen just set 'MD_RECOVERY_FROZEN' and is still in progress, while
'idle' clear 'MD_RECOVERY_FROZEN' and new sync thread is started, which
might starve in progress frozen. A mutex is added to synchronize idle
and frozen from action_store().

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 5 +++++
 drivers/md/md.h | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 23e8e7eae062..63a993b52cd7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -644,6 +644,7 @@ void mddev_init(struct mddev *mddev)
 	mutex_init(&mddev->open_mutex);
 	mutex_init(&mddev->reconfig_mutex);
 	mutex_init(&mddev->delete_mutex);
+	mutex_init(&mddev->sync_mutex);
 	mutex_init(&mddev->bitmap_info.mutex);
 	INIT_LIST_HEAD(&mddev->disks);
 	INIT_LIST_HEAD(&mddev->all_mddevs);
@@ -4785,14 +4786,18 @@ static void stop_sync_thread(struct mddev *mddev)
 
 static void idle_sync_thread(struct mddev *mddev)
 {
+	mutex_lock(&mddev->sync_mutex);
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	stop_sync_thread(mddev);
+	mutex_unlock(&mddev->sync_mutex);
 }
 
 static void frozen_sync_thread(struct mddev *mddev)
 {
+	mutex_init(&mddev->delete_mutex);
 	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	stop_sync_thread(mddev);
+	mutex_unlock(&mddev->sync_mutex);
 }
 
 static ssize_t
diff --git a/drivers/md/md.h b/drivers/md/md.h
index bfd2306bc750..2fa903de5bd0 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -537,6 +537,9 @@ struct mddev {
 	/* Protect the deleting list */
 	struct mutex			delete_mutex;
 
+	/* Used to synchronize idle and frozen for action_store() */
+	struct mutex			sync_mutex;
+
 	bool	has_superblocks:1;
 	bool	fail_last_dev:1;
 	bool	serialize_policy:1;
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


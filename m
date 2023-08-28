Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA930C83F18
	for <dm-devel@archiver.kernel.org>; Mon, 28 Aug 2023 02:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693188315;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kxKCQC7jFVd69+KAeivf6cTcwE+N+hiYY8B1O8RshFc=;
	b=JtQ1vUScniphbF4CkPmPKT15KutuWjlPfvtmE1TGmOdkQgkvCYZwHCFYdF4kGHHbe0AXig
	B4msWWt5LfPJEsrrjpara1DjI+lVTsdvaV5VGcg/WuI4QTh6tdEQopPyvZlpTQlU1Tjyu1
	05qffNtgCYODBXpz8y8aMp7X4QOuvgw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-70-A-D_lDSuNGafxdxi5XyOIw-1; Sun, 27 Aug 2023 22:05:10 -0400
X-MC-Unique: A-D_lDSuNGafxdxi5XyOIw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 59BDD101A528;
	Mon, 28 Aug 2023 02:05:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 468571121319;
	Mon, 28 Aug 2023 02:05:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 136E419465B9;
	Mon, 28 Aug 2023 02:05:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 010C419465B3
 for <dm-devel@listman.corp.redhat.com>; Mon, 28 Aug 2023 02:05:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C5EB440282C; Mon, 28 Aug 2023 02:04:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BD0C64021B9
 for <dm-devel@redhat.com>; Mon, 28 Aug 2023 02:04:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A14E4101A59A
 for <dm-devel@redhat.com>; Mon, 28 Aug 2023 02:04:59 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-260-7aZF0jF4Ogm9TPE4k68e5g-1; Sun, 27 Aug 2023 22:04:55 -0400
X-MC-Unique: 7aZF0jF4Ogm9TPE4k68e5g-1
Received: from mail02.huawei.com (unknown [172.30.67.169])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RYv5F6SXZz4f3k60;
 Mon, 28 Aug 2023 10:04:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAnBai7AOxk9qcCBw--.25880S16;
 Mon, 28 Aug 2023 10:04:50 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org,
 xni@redhat.com
Date: Mon, 28 Aug 2023 10:00:05 +0800
Message-Id: <20230828020021.2489641-13-yukuai1@huaweicloud.com>
In-Reply-To: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
References: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAnBai7AOxk9qcCBw--.25880S16
X-Coremail-Antispam: 1UD129KBjvJXoW7Cr1fWr4rArWkGF15Ar15CFg_yoW8Gr43pa
 nFgFWru3409rWrAF1kXF4q9FykJ3y8KrZF9r9rC3Z3uayrXr17GF1FqF1UWr92vFyfGa13
 Jw4UJ3WkC348KrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUPI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
 kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
 z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
 4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
 3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
 IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
 M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
 kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
 14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
 kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAF
 wI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr
 0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQ
 SdkUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH -next v2 12/28] md/raid5-cache: use new apis to
 suspend array for r5c_journal_mode_store()
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

r5c_journal_mode_set() will suspend array and it has only 2 caller, the
other caller raid_ctl() already suspend the array with new apis.

This is not hot path, so performance is not concerned.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid5-cache.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 109367fec7c0..38d38f2e33bc 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2584,9 +2584,7 @@ int r5c_journal_mode_set(struct mddev *mddev, int mode)
 	    mode == R5C_JOURNAL_MODE_WRITE_BACK)
 		return -EINVAL;
 
-	mddev_suspend(mddev);
 	conf->log->r5c_journal_mode = mode;
-	mddev_resume(mddev);
 
 	pr_debug("md/raid:%s: setting r5c cache mode to %d: %s\n",
 		 mdname(mddev), mode, r5c_journal_mode_str[mode]);
@@ -2611,11 +2609,11 @@ static ssize_t r5c_journal_mode_store(struct mddev *mddev,
 		if (strlen(r5c_journal_mode_str[mode]) == len &&
 		    !strncmp(page, r5c_journal_mode_str[mode], len))
 			break;
-	ret = mddev_lock(mddev);
+	ret = mddev_suspend_and_lock(mddev);
 	if (ret)
 		return ret;
 	ret = r5c_journal_mode_set(mddev, mode);
-	mddev_unlock(mddev);
+	mddev_unlock_and_resume(mddev);
 	return ret ?: length;
 }
 
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


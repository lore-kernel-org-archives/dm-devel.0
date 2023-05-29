Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AEC3C7EE2E
	for <dm-devel@archiver.kernel.org>; Mon, 29 May 2023 13:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685366743;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zVV11vZIO2MM+9/ishb3X++F1WSl41I93YBmjBSMxC0=;
	b=Y2BGiku6erEiLmkyXVrc+d6/AGTuA5h8DMiXwslza7IUcPmXBLIv8vLRsFxxmylcwxk8Ah
	yyCFIMY/vqwzV2ndEpUWCYd7b30IyyYG5SjOj9BowtU54jLXd7uKeGLk478G2V8psbTyWk
	NT5E8AgD6ekxTcEfP+5OaiPq2KbhaO4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509-6gXI7SuBMueyUAUYPhurGA-1; Mon, 29 May 2023 09:25:39 -0400
X-MC-Unique: 6gXI7SuBMueyUAUYPhurGA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14FC3800B35;
	Mon, 29 May 2023 13:25:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 03FB6C154D1;
	Mon, 29 May 2023 13:25:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DADD01946A41;
	Mon, 29 May 2023 13:25:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CBF8119465B5
 for <dm-devel@listman.corp.redhat.com>; Mon, 29 May 2023 13:24:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 51BED2166B2E; Mon, 29 May 2023 13:24:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 48A072166B2B
 for <dm-devel@redhat.com>; Mon, 29 May 2023 13:24:22 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2814A185A78E
 for <dm-devel@redhat.com>; Mon, 29 May 2023 13:24:22 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-JKcAW8mYOW2dBrpgSYodGQ-1; Mon, 29 May 2023 09:24:19 -0400
X-MC-Unique: JKcAW8mYOW2dBrpgSYodGQ-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QVGT84zs8z4f3mKv;
 Mon, 29 May 2023 21:24:12 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAHvbB9p3RkWVPoKQ--.23397S4;
 Mon, 29 May 2023 21:24:14 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: guoqing.jiang@linux.dev, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com, song@kernel.org
Date: Mon, 29 May 2023 21:20:31 +0800
Message-Id: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAHvbB9p3RkWVPoKQ--.23397S4
X-Coremail-Antispam: 1UD129KBjvdXoW7Gw1rAw43JrW7Zr4kur4fGrg_yoWfurX_Xa
 43XFy3Gr47WF15JFyDKr1jv3yDGF45ur1DXFyFqayjyr17WrnrCr1Duw1a9w1Yva42yF18
 ArWUCrWxurs7WjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
 9fnUUIcSsGvfJTRUUUbIxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
 6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
 A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
 6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
 Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
 I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
 4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
 n2kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
 0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
 IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxV
 AFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AK
 xVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa
 7VU1a9aPUUUUU==
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
Subject: [dm-devel] [PATCH -next v2 0/6] md: fix that MD_RECOVERY_RUNNING
 can be cleared while sync_thread is still running
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

Changes in v2:
 - rebase for the latest md-next

Patch 1 revert the commit because it will cause MD_RECOVERY_RUNNING to be
cleared while sync_thread is still running. The deadlock this patch tries
to fix will be fixed by patch 2-5.

Patch 6 enhance checking to prevent MD_RECOVERY_RUNNING to be cleared
while sync_thread is still running.

Yu Kuai (6):
  Revert "md: unlock mddev before reap sync_thread in action_store"
  md: refactor action_store() for 'idle' and 'frozen'
  md: add a mutex to synchronize idle and frozen in action_store()
  md: refactor idle/frozen_sync_thread() to fix deadlock
  md: wake up 'resync_wait' at last in md_reap_sync_thread()
  md: enhance checking in md_check_recovery()

 drivers/md/dm-raid.c |   1 -
 drivers/md/md.c      | 124 +++++++++++++++++++++++++++++--------------
 drivers/md/md.h      |   5 ++
 3 files changed, 88 insertions(+), 42 deletions(-)

-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


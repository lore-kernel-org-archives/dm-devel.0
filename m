Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AC53C77B6E
	for <dm-devel@archiver.kernel.org>; Thu, 13 Apr 2023 11:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681386575;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dCZlkOBldVjBw+yfQx81SETRRmePQX5712wHXJmNAWg=;
	b=NsmyOBEJ/kWJQkZIoytvXwKRS0HXE9sURNOJk8QwHdW9RNUYNuD0V49JKdDwywEwZbj8jg
	PJFakEhbK4mgQCCrATKOhdYXpf9OGrCmptBTrPZsAisGBWPRZcvG5BvDFi2JhJ87C/iJEC
	XlCAnGWCnX1Df7dSzWO6BYmDcIsKh4o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-EbSpi1J8MkuPszJBxmXx1g-1; Thu, 13 Apr 2023 07:49:34 -0400
X-MC-Unique: EbSpi1J8MkuPszJBxmXx1g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC36E855300;
	Thu, 13 Apr 2023 11:49:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8CD7BC15E7F;
	Thu, 13 Apr 2023 11:49:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 39BE119465B7;
	Thu, 13 Apr 2023 11:49:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A0F3919465B6
 for <dm-devel@listman.corp.redhat.com>; Thu, 13 Apr 2023 11:49:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8100F492C14; Thu, 13 Apr 2023 11:49:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 79556492C13
 for <dm-devel@redhat.com>; Thu, 13 Apr 2023 11:49:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28EC53C0F220
 for <dm-devel@redhat.com>; Thu, 13 Apr 2023 11:49:27 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-zxqp3FiSMh2hB32ncY_igw-1; Thu, 13 Apr 2023 07:49:24 -0400
X-MC-Unique: zxqp3FiSMh2hB32ncY_igw-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4PxyBS4CbCz4f409k
 for <dm-devel@redhat.com>; Thu, 13 Apr 2023 19:33:20 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgCH77KA6DdkC6FCHQ--.33135S4;
 Thu, 13 Apr 2023 19:33:22 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: dm-devel@redhat.com,
	song@kernel.org,
	logang@deltatee.com
Date: Thu, 13 Apr 2023 19:32:12 +0800
Message-Id: <20230413113217.1934353-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgCH77KA6DdkC6FCHQ--.33135S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw4rXrW3GF15GFWfGr48JFb_yoW8WF4kpF
 ZIgF9xZw4UCr43ZFsxZa42ka45G3WrGayUKryxA34ruFy5ur98Jr1UJFy8WF9rWFyfJa9F
 qF15Jr1DCF1UtaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUyl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
 6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
 0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
 jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
 1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48J
 MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwV
 AFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv2
 0xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4
 v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
 14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH -next v6 0/5] md: protect md_thread with rcu
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

Changes in v6:
 - remove first patch from v5, and use rcu_asign_pointer() directly from
 caller.
 - always use rcu_read_lock/unlock to protect mddev_set_timeout().

Changes in v5:
 - use rcu_dereference_protected() instead of rcu_access_pointer() where
 rcu_read_lock/unlock is not required.
 - add patch 4,5 to handle that bitmap timeout is set multiple times.

Changes in v4:
 - remove patch 2 from v3
 - fix sparse errors and warnings from v3, in order to do that, all access
 to md_thread need to be modified, patch 2-4 is splited to avoid a huge
 patch.

Changes in v3:
 - remove patch 3 from v2
 - use rcu instead of a new lock

Changes in v2:
 - fix a compile error for md-cluster in patch 2
 - replace spin_lock/unlock with spin_lock/unlock_irq in patch 5
 - don't wake up inside the new lock in md wakeup_thread in patch 5

Yu Kuai (5):
  md: factor out a helper to wake up md_thread directly
  dm-raid: remove useless checking in raid_message()
  md/bitmap: always wake up md_thread in timeout_store
  md/bitmap: factor out a helper to set timeout
  md: protect md_thread with rcu

 drivers/md/dm-raid.c      |  4 +-
 drivers/md/md-bitmap.c    | 43 +++++++++++--------
 drivers/md/md-cluster.c   |  7 ++--
 drivers/md/md-multipath.c |  4 +-
 drivers/md/md.c           | 88 +++++++++++++++++++++------------------
 drivers/md/md.h           |  8 ++--
 drivers/md/raid1.c        |  7 ++--
 drivers/md/raid1.h        |  2 +-
 drivers/md/raid10.c       | 21 ++++++----
 drivers/md/raid10.h       |  2 +-
 drivers/md/raid5-cache.c  | 22 ++++++----
 drivers/md/raid5.c        | 15 +++----
 drivers/md/raid5.h        |  2 +-
 13 files changed, 126 insertions(+), 99 deletions(-)

-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B4CEC7EE2C
	for <dm-devel@archiver.kernel.org>; Fri, 25 Aug 2023 03:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692933270;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Og58g+wlEK8GTAzTwwEhThIKSD7djbkmapN++rECdcc=;
	b=Mzdhy+Wr3tPEE9IXRe8sB5xM0yLZjafkTNxwhmCUr2OEcQFvIivepxOGZr0B/rn1N2CZdT
	iaEVT/gAdid+opGfzFQcAldnW/nR4Hoosot5p6Y5Ev1slCqabanmVT38tUNVHRf2rxn7Ym
	RQfJud5uZQuNtjNuQlie48MIj/xFhBU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-7zrLLdq9OuCHZdx9yHen-A-1; Thu, 24 Aug 2023 23:14:26 -0400
X-MC-Unique: 7zrLLdq9OuCHZdx9yHen-A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 94F118D40A0;
	Fri, 25 Aug 2023 03:14:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 39ACEC09A0E;
	Fri, 25 Aug 2023 03:14:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C24CE19465A3;
	Fri, 25 Aug 2023 03:14:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2E2B61946589
 for <dm-devel@listman.corp.redhat.com>; Fri, 25 Aug 2023 03:14:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DE72E2166B27; Fri, 25 Aug 2023 03:14:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D704A2166B26
 for <dm-devel@redhat.com>; Fri, 25 Aug 2023 03:14:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC073857A84
 for <dm-devel@redhat.com>; Fri, 25 Aug 2023 03:14:21 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-484-1gE_6BblNFG3zwce4uJ_Rg-1; Thu, 24 Aug 2023 23:14:17 -0400
X-MC-Unique: 1gE_6BblNFG3zwce4uJ_Rg-1
Received: from mail02.huawei.com (unknown [172.30.67.169])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4RX4mc3V3Tz4f3tDD;
 Fri, 25 Aug 2023 11:14:08 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAnBah_HOhkveEWBg--.3212S4;
 Fri, 25 Aug 2023 11:14:09 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org,
 xni@redhat.com
Date: Fri, 25 Aug 2023 11:09:49 +0800
Message-Id: <20230825030956.1527023-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAnBah_HOhkveEWBg--.3212S4
X-Coremail-Antispam: 1UD129KBjvJXoWxJryktw1kGFy8Jw43tFWUArb_yoW8KFWDp3
 9aqF43Zw1UWr1rJr43X3y8Wr90qws3WrZxKr9xWr4Fkw17uwn7Jw1Sga1Fgr97AFy3A3ZI
 yr98Xw48CF18ZrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUvY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
 JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
 Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
 I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
 4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
 n2kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
 0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
 IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
 AFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v2
 6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0J
 UdHUDUUUUU=
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
Subject: [dm-devel] [PATCH -next v2 0/7] md: initialize 'active_io' while
 allocating mddev
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
 - rebase for md-next;
 - update commit message for patch 3;

This is the 4th patchset to do some preparatory work to synchronize
io with array reconfiguration.

1) The first patchset refactor 'active_io', make sure that mddev_suspend()
will wait for io to be done. [1]

2) The second patchset remove 'quiesce' callback from mddev_suspend(), so
that mddev_suspend() doesn't rely on 'quiesce' callback is registered,
and can be used for all personalites; [2]

3) Make array reconfiguration independent from daemon thread,
and synchronize it with io will be much easier because io may rely on
daemon thread to be done.

4) This patchset move initialization of 'active_io' from md_run() to
md_alloc(), so that mddev_suspend() won't rely on holding 'reconfig_mutex'
to check if 'mddev->pers' is set, and it can be called at any time after
mddev is allocated.(Done by patch 1, and other patches are cleanup)

Yu Kuai (7):
  md: initialize 'active_io' while allocating mddev
  md: initialize 'writes_pending' while allocating mddev
  md: don't rely on 'mddev->pers' to be set in mddev_suspend()
  md-bitmap: remove the checking of 'pers->quiesce' from
    location_store()
  md-bitmap: suspend array earlier in location_store()
  md: don't check 'mddev->pers' from suspend_hi_store()
  md: don't check 'mddev->pers' and 'pers->quiesce' from
    suspend_lo_store()

[1] https://lore.kernel.org/all/20230621165110.1498313-1-yukuai1@huaweicloud.com/
[2] https://lore.kernel.org/all/20230628012931.88911-2-yukuai1@huaweicloud.com/

Yu Kuai (7):
  md: initialize 'active_io' while allocating mddev
  md: initialize 'writes_pending' while allocating mddev
  md: don't rely on 'mddev->pers' to be set in mddev_suspend()
  md-bitmap: remove the checking of 'pers->quiesce' from
    location_store()
  md-bitmap: suspend array earlier in location_store()
  md: don't check 'mddev->pers' from suspend_hi_store()
  md: don't check 'mddev->pers' and 'pers->quiesce' from
    suspend_lo_store()

 drivers/md/dm-raid.c   |   7 ++-
 drivers/md/md-bitmap.c |  47 +++++++++----------
 drivers/md/md.c        | 100 ++++++++++++++++++++---------------------
 drivers/md/md.h        |   4 +-
 drivers/md/raid1.c     |   3 +-
 drivers/md/raid10.c    |   3 --
 drivers/md/raid5.c     |   3 --
 7 files changed, 78 insertions(+), 89 deletions(-)

-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


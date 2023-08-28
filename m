Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E028FC83F15
	for <dm-devel@archiver.kernel.org>; Mon, 28 Aug 2023 02:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693188302;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=odiIgSOmMaG5XVk3a2fvWhqPN9KMs8D091EGGxrlwUk=;
	b=YiER+I/G5r6kIaqEOaPWyCFj4h+PNrsMViSGeYBE75V9GSnRD2mJtS0ItNnw2DrDuz9lSZ
	keRdCVGTOkof+UamOEXwVj2At4tJ88e36JS4Z9wrhl5hfhLAZAnyGwiabUeGuzehynRjZn
	62xslNs5NJ4bzFzf31cotv+y7CuR5LI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-AkVYIujNOm-vz1H5DqVN8w-1; Sun, 27 Aug 2023 22:04:59 -0400
X-MC-Unique: AkVYIujNOm-vz1H5DqVN8w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0709E101AA48;
	Mon, 28 Aug 2023 02:04:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AFBE7492C13;
	Mon, 28 Aug 2023 02:04:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8081A19465B3;
	Mon, 28 Aug 2023 02:04:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8603619465A8
 for <dm-devel@listman.corp.redhat.com>; Mon, 28 Aug 2023 02:04:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 613FDC15E6B; Mon, 28 Aug 2023 02:04:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 590DFC15E6A
 for <dm-devel@redhat.com>; Mon, 28 Aug 2023 02:04:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3ED95101A52E
 for <dm-devel@redhat.com>; Mon, 28 Aug 2023 02:04:53 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-508-aQ0dHn3pMly2UuFBUz4UZw-1; Sun, 27 Aug 2023 22:04:50 -0400
X-MC-Unique: aQ0dHn3pMly2UuFBUz4UZw-1
Received: from mail02.huawei.com (unknown [172.30.67.169])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RYv575L96z4f3lVZ;
 Mon, 28 Aug 2023 10:04:43 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAnBai7AOxk9qcCBw--.25880S4;
 Mon, 28 Aug 2023 10:04:44 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org,
 xni@redhat.com
Date: Mon, 28 Aug 2023 09:59:53 +0800
Message-Id: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAnBai7AOxk9qcCBw--.25880S4
X-Coremail-Antispam: 1UD129KBjvJXoWxZFWxCw1UWF1ruFyUAw18Xwb_yoW5tFWUp3
 9rtFZIvw48JFy5Ar4xX34DGF95Jw4rKrZFkr9xCw1rC3W3GryrArW8Gr98XrZYkFyfAr9r
 Ja4DX34rGr18Aa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUvY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
 Y2ka0xkIwI1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
 xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
 MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
 0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v2
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH -next v2 00/28] md: synchronize io with array
 reconfiguration
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

Changes in v2:
 - rebase with latest md-next
 - remove some follow up cleanup patches, these patches will be sent
 later after this patchset.

After previous four patchset of preparatory work, this patchset impelement
a new version of mddev_suspend(), the new apis:
 - reconfig_mutex is not required;
 - the weird logical that suspend array hold 'reconfig_mutex' for
   mddev_check_recovery() to update superblock is not needed;
 - the special handling, 'pers->prepare_suspend', for raid456 is not
   needed;
 - It's safe to be called at any time once mddev is allocated, and it's
   designed to be used from slow path where array configuration is changed;

And use the new api to replace:

mddev_lock
mddev_suspend or not
// array reconfiguration
mddev_resume or not
mddev_unlock

With:

mddev_suspend
mddev_lock
// array reconfiguration
mddev_unlock
mddev_resume

However, the above change is not possible for raid5 and raid-cluster in
some corner cases, and mddev_suspend/resume() is replaced with quiesce()
callback, which will suspend the array as well.

This patchset is tested in my VM with mdadm testsuite with loop device
except for 10ddf tests(they always fail before this patchset).

A lot of cleanups will be started after this patchset.

Yu Kuai (28):
  md: use READ_ONCE/WRITE_ONCE for 'suspend_lo' and 'suspend_hi'
  md: use 'mddev->suspended' for is_md_suspended()
  md: add new helpers to suspend/resume array
  md: add new helpers to suspend/resume and lock/unlock array
  md: use new apis to suspend array for suspend_lo/hi_store()
  md: use new apis to suspend array for level_store()
  md: use new apis to suspend array for serialize_policy_store()
  md/dm-raid: use new apis to suspend array
  md/md-bitmap: use new apis to suspend array for location_store()
  md/raid5-cache: use READ_ONCE/WRITE_ONCE for 'conf->log'
  md/raid5-cache: use new apis to suspend array for
    r5c_disable_writeback_async()
  md/raid5-cache: use new apis to suspend array for
    r5c_journal_mode_store()
  md/raid5: use new apis to suspend array for raid5_store_stripe_size()
  md/raid5: use new apis to suspend array for raid5_store_skip_copy()
  md/raid5: use new apis to suspend array for
    raid5_store_group_thread_cnt()
  md/raid5: use new apis to suspend array for
    raid5_change_consistency_policy()
  md/raid5: replace suspend with quiesce() callback
  md: quiesce before md_kick_rdev_from_array() for md-cluster
  md: use new apis to suspend array for ioctls involed array
    reconfiguration
  md: use new apis to suspend array for adding/removing rdev from
    state_store()
  md: use new apis to suspend array for bind_rdev_to_array()
  md: use new apis to suspend array related to serial pool in
    state_store()
  md: use new apis to suspend array in backlog_store()
  md: suspend array in md_start_sync() if array need reconfiguration
  md: cleanup mddev_create/destroy_serial_pool()
  md/md-linear: cleanup linear_add()
  md: remove old apis to suspend the array
  md: rename __mddev_suspend/resume() back to mddev_suspend/resume()

 drivers/md/dm-raid.c       |   8 +-
 drivers/md/md-autodetect.c |   4 +-
 drivers/md/md-bitmap.c     |  18 ++-
 drivers/md/md-linear.c     |   2 -
 drivers/md/md.c            | 250 ++++++++++++++++++++++---------------
 drivers/md/md.h            |  52 ++++++--
 drivers/md/raid5-cache.c   |  61 +++++----
 drivers/md/raid5.c         |  56 ++++-----
 8 files changed, 253 insertions(+), 198 deletions(-)

-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


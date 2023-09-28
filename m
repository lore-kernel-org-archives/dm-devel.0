Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEBFCCE7B00
	for <dm-devel@archiver.kernel.org>; Thu, 28 Sep 2023 06:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695882734;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nkyI5PR0Fmrn0JWgJYM8Muot2V50ymvRudwNjr5qTVg=;
	b=V+AkD+0FWQ3E7QvPHlFtJS/hdVCVchynWYUc4YRegCw2i3iRdb04Vv2CzhgvrPCLGbLaVc
	8RanS8ne7qko/Wfet48yGzWQCDVmZzo/8nj2W5jUF4ocyG66Tsypsfiq412KvaM6A+hcPj
	HhLJtH0QI90fl7o76P4rj2kJBAqFOMM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-JfwG3gF0Myqchp17CbrlBA-1; Thu, 28 Sep 2023 02:32:11 -0400
X-MC-Unique: JfwG3gF0Myqchp17CbrlBA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79A8081B15E;
	Thu, 28 Sep 2023 06:32:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0F50D140273D;
	Thu, 28 Sep 2023 06:32:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7C8851946588;
	Thu, 28 Sep 2023 06:32:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A51F41946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Sep 2023 06:22:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8B99210D14C7; Thu, 28 Sep 2023 06:22:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8301D10EE6C9
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 06:22:04 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35E2A1C0CCB7
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 06:22:04 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-296-Goo_au8JN62j0zpeSFO7OA-1; Thu, 28 Sep 2023 02:22:00 -0400
X-MC-Unique: Goo_au8JN62j0zpeSFO7OA-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Rx3KW3rlKz4f3jMF;
 Thu, 28 Sep 2023 14:21:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAnvdyCGxVl3v1WBg--.22861S4;
 Thu, 28 Sep 2023 14:21:56 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: xni@redhat.com, agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
 song@kernel.org
Date: Thu, 28 Sep 2023 14:15:18 +0800
Message-Id: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAnvdyCGxVl3v1WBg--.22861S4
X-Coremail-Antispam: 1UD129KBjvJXoWxAFy7Xw47tF45tryfAFyrZwb_yoWrJw4Dp3
 9FqFZIvw48JFy5Ar4xX34DWF93Jw4FkrZFkr9xWw4rC3W3GryrCrW8Jr98Xr9YkFyfAr9r
 Ja48Xw1rCr18AFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUvF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
 Y2ka0xkIwI1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
 xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
 MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
 0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AK
 xVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvj
 fUoOJ5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH -next v3 00/25] md: synchronize io with array
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

Changes in v3:
 - rebase with latest md-next;
 - remove patch 2 from v2, and replace it with a new patch;
 - fix a null-ptr-derefrence in rdev_attr_store() that mddev is used
 before checking;
 - merge patch 20-22 from v1 into one patch;
 - mddev_lock() used to be called first and can be interruptted, allow new
 api, which is called before mddev_lock() now, to be interruptted as well;
 - improve some comments and coding;

Changes in v2:
 - rebase with latest md-next;
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

Yu Kuai (25):
  md: use READ_ONCE/WRITE_ONCE for 'suspend_lo' and 'suspend_hi'
  md: replace is_md_suspended() with 'mddev->suspended' in
    md_check_recovery()
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
  md: use new apis to suspend array for ioctls involed array
    reconfiguration
  md: use new apis to suspend array for adding/removing rdev from
    state_store()
  md: use new apis to suspend array before
    mddev_create/destroy_serial_pool
  md: cleanup mddev_create/destroy_serial_pool()
  md/md-linear: cleanup linear_add()
  md: suspend array in md_start_sync() if array need reconfiguration
  md: remove old apis to suspend the array
  md: rename __mddev_suspend/resume() back to mddev_suspend/resume()

 drivers/md/dm-raid.c       |  10 +-
 drivers/md/md-autodetect.c |   4 +-
 drivers/md/md-bitmap.c     |  18 ++-
 drivers/md/md-linear.c     |   2 -
 drivers/md/md.c            | 233 ++++++++++++++++++++-----------------
 drivers/md/md.h            |  43 +++++--
 drivers/md/raid5-cache.c   |  64 +++++-----
 drivers/md/raid5.c         |  56 ++++-----
 8 files changed, 226 insertions(+), 204 deletions(-)

-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1E59C64EC4
	for <dm-devel@archiver.kernel.org>; Mon,  6 Mar 2023 16:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678120184;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2rQYRnbce7uwaymwLyUkzNpEi77msqNwvUA1lL6Pt8Y=;
	b=bgG8UEq+e2uycgCFSDJA9MCX4Y6sIv3wbh+UJfmmowBMtylwWn7LrnMMSWzBUpyrnSfkAJ
	4XlDIhs0v+n+ctGbMpd4kK/TafXo0fXkmEl/vK0rxbAdBTFXchxrPbAeYcvMxq0F3hqRsq
	Y//iqc83f52qM+P/QGog0EKrZ6pY98E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-eDZ0924SMGmOVEcfcm9PTA-1; Mon, 06 Mar 2023 11:29:40 -0500
X-MC-Unique: eDZ0924SMGmOVEcfcm9PTA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07729100F90A;
	Mon,  6 Mar 2023 16:29:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E5FDBC159BB;
	Mon,  6 Mar 2023 16:29:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D0561194658D;
	Mon,  6 Mar 2023 16:29:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3BCC81946586
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Mar 2023 11:33:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1F46B492B01; Mon,  6 Mar 2023 11:33:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 17A83492B00
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 11:33:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1EA71C05AD4
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 11:33:52 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-NbV7yEq5MSCAcHbQHH5-gw-1; Mon, 06 Mar 2023 06:33:50 -0500
X-MC-Unique: NbV7yEq5MSCAcHbQHH5-gw-1
Received: from mail02.huawei.com (unknown [172.30.67.169])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4PVc0Q1m5qz4f3nVC;
 Mon,  6 Mar 2023 19:33:42 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
 by APP3 (Coremail) with SMTP id _Ch0CgDn4R+OzwVkiz3CEQ--.12154S4;
 Mon, 06 Mar 2023 19:33:44 +0800 (CST)
From: yangerkun <yangerkun@huaweicloud.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 dm-devel@redhat.com
Date: Mon,  6 Mar 2023 19:56:48 +0800
Message-Id: <20230306115648.3154696-1-yangerkun@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: _Ch0CgDn4R+OzwVkiz3CEQ--.12154S4
X-Coremail-Antispam: 1UD129KBjvJXoWxWF1rGrW5CF1fZw48XryrJFb_yoWrGr48pF
 Z8Wry5KFs7JryYqr4qkF1ktFy3Kr47AFy7JrW7W3WDCa4UW34DJFy7Way5XrnxGFy7JFy7
 tFZ7GFy8tr18Jw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUyG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWUuVWrJwAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vI
 r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
 xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
 cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
 AvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
 xVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Mon, 06 Mar 2023 16:29:31 +0000
Subject: [dm-devel] [PATCH v2] dm-crypt: fix softlockup in dmcrypt_write
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
Cc: yangerkun@huawei.com, yangerkun@huaweicloud.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: yangerkun <yangerkun@huawei.com>

We meet a softlockup:

localhost login: [ 3391.153255][   C12] watchdog: BUG: soft lockup - CPU#12 stuck for 23s! [dmcrypt_write/2:2897]
...
[ 3391.258372][   C12] CPU: 12 PID: 2897 Comm: dmcrypt_write/2 Tainted: G             L    5.10.0+ #8
[ 3391.267288][   C12] Hardware name: Huawei TaiShan 2280 V2/BC82AMDDA, BIOS 1.75 04/26/2021
[ 3391.275428][   C12] pstate: 80400009 (Nzcv daif +PAN -UAO -TCO BTYPE=--)
[ 3391.282102][   C12] pc : blk_attempt_bio_merge.part.6+0x38/0x158
[ 3391.288080][   C12] lr : blk_attempt_plug_merge+0xc0/0x1b0
[ 3391.293540][   C12] sp : ffff8000718abc30
[ 3391.297530][   C12] x29: ffff8000718abc30 x28: 0000000000000000
[ 3391.303509][   C12] x27: ffff2020361d9ac0 x26: 0000000000000001
[ 3391.309488][   C12] x25: 0000000000000001 x24: ffff8000718abd08
[ 3391.315467][   C12] x23: ffff0020a10dbb00 x22: 0000000000000001
[ 3391.321445][   C12] x21: ffff8000718abe20 x20: ffff0020a10dbb00
[ 3391.327424][   C12] x19: ffff0020aed7b040 x18: 0000000000000000
[ 3391.333402][   C12] x17: 0000000000000000 x16: fffffdffffe00000
[ 3391.339381][   C12] x15: 0000000000001000 x14: 0000000000000000
[ 3391.345359][   C12] x13: 0000000000002000 x12: ffff2060011f9070
[ 3391.351338][   C12] x11: 0000000000000001 x10: 0000000000000002
[ 3391.357316][   C12] x9 : ffff800010586c38 x8 : ffff202009a7f200
[ 3391.363294][   C12] x7 : ffff8000718abd00 x6 : ffff20200df33750
[ 3391.369274][   C12] x5 : 0000000000000001 x4 : 0000000000000000
[ 3391.375252][   C12] x3 : 0000000000000001 x2 : ffff0020a10dbb00
[ 3391.381230][   C12] x1 : ffff0020aed7b040 x0 : 0000000000001000
[ 3391.387210][   C12] Call trace:
[ 3391.390338][   C12]  blk_attempt_bio_merge.part.6+0x38/0x158
[ 3391.395970][   C12]  blk_attempt_plug_merge+0xc0/0x1b0
[ 3391.401085][   C12]  blk_mq_submit_bio+0x398/0x550
[ 3391.405856][   C12]  submit_bio_noacct+0x308/0x380
[ 3391.410630][   C12]  dmcrypt_write+0x1e4/0x208 [dm_crypt]
[ 3391.416005][   C12]  kthread+0x130/0x138
[ 3391.419911][   C12]  ret_from_fork+0x10/0x18

dmcrypt_write will be wakeup once there is a not empty write_tree, and
before really submit_bio, the old write_tree will be peeled, so there
may not so much bio, but every time we check RB_EMPTY_ROOT, it may be
false since the heavy load write, so the softlockup can trigger.

We can add cond_resched every time before or after kcryptd_io_write, but
dmcrypt_write seems performance sensitive since it will submit all
pending write, so we choose cond_resched after 1s before the 'while'
submit bio.

Fixes: dc2676210c42 ("dm crypt: offload writes to thread")
Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 drivers/md/dm-crypt.c | 6 ++++++
 1 file changed, 6 insertions(+)

v1->v2:
change schedule() to cond_resched()

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 40cb1719ae4d..6a675257e00e 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1894,6 +1894,7 @@ static int dmcrypt_write(void *data)
 {
 	struct crypt_config *cc = data;
 	struct dm_crypt_io *io;
+	unsigned long start_time = jiffies;
 
 	while (1) {
 		struct rb_root write_tree;
@@ -1916,6 +1917,7 @@ static int dmcrypt_write(void *data)
 
 		schedule();
 
+		start_time = jiffies;
 		set_current_state(TASK_RUNNING);
 		spin_lock_irq(&cc->write_thread_lock);
 		goto continue_locked;
@@ -1927,6 +1929,10 @@ static int dmcrypt_write(void *data)
 
 		BUG_ON(rb_parent(write_tree.rb_node));
 
+		if (time_is_before_jiffies(start_time + HZ)) {
+			cond_resched();
+			start_time = jiffies;
+		}
 		/*
 		 * Note: we cannot walk the tree here with rb_next because
 		 * the structures may be freed when kcryptd_io_write is called.
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


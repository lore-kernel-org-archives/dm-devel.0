Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 930FBC46467
	for <dm-devel@archiver.kernel.org>; Tue, 29 Nov 2022 02:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669688901;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2ppSf0m1W63JDMTcbwZuhVwskMGX/VStbBc1OWwRDjo=;
	b=T3zZ81cC6aFUD+JhgDgiN7l0hm3DqtsN6At7QX7Jqr/1Nyz1WNZRiBvw6mSIDqiR13VTXy
	qo92n2QemL6nLI9azwS3wud44lASMlKirGK9lb0s2j0d+UR7MtWIRuPkJVFqaSkd0b2cYZ
	eP6s13TvZOLN4KB0fbZHraWX2exVp8M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-425-bgAK7UMJOp2UyHUZfLxkwg-1; Mon, 28 Nov 2022 21:28:18 -0500
X-MC-Unique: bgAK7UMJOp2UyHUZfLxkwg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78961101AA5D;
	Tue, 29 Nov 2022 02:28:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 046414B400F;
	Tue, 29 Nov 2022 02:28:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DCC2419465A0;
	Tue, 29 Nov 2022 02:28:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2765A1946A44
 for <dm-devel@listman.corp.redhat.com>; Tue, 29 Nov 2022 02:28:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0E397C15BB3; Tue, 29 Nov 2022 02:28:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 06238C15BA4
 for <dm-devel@redhat.com>; Tue, 29 Nov 2022 02:28:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF4BA3C0257D
 for <dm-devel@redhat.com>; Tue, 29 Nov 2022 02:28:11 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-522-Srji3vXZOIGdUh6A9Vou5Q-1; Mon, 28 Nov 2022 21:28:07 -0500
X-MC-Unique: Srji3vXZOIGdUh6A9Vou5Q-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4NLmTW0Tqyz4f3nqG;
 Tue, 29 Nov 2022 10:27:59 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
 by APP1 (Coremail) with SMTP id cCh0CgBHPaweboVjlJ0JBQ--.11870S5;
 Tue, 29 Nov 2022 10:28:01 +0800 (CST)
From: Luo Meng <luomeng12@huawei.com>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, ejt@redhat.com
Date: Tue, 29 Nov 2022 10:48:47 +0800
Message-Id: <20221129024850.1842973-2-luomeng12@huawei.com>
In-Reply-To: <20221129024850.1842973-1-luomeng12@huawei.com>
References: <20221129024850.1842973-1-luomeng12@huawei.com>
MIME-Version: 1.0
X-CM-TRANSID: cCh0CgBHPaweboVjlJ0JBQ--.11870S5
X-Coremail-Antispam: 1UD129KBjvJXoWxWry5Ar48Kry7Cr4DKFyrXrb_yoW5Wr43pw
 4rA3yayw1DXr4UX3yvyw4kWFyxJa1SvFW2kr1fursrAa4fWw1YvFy2grZ8Way7GrZrAF9x
 X3Wxt39xXrn0yFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUP0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
 A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
 w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
 W0oVCq3wA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0
 oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFc
 xC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_
 Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMx
 AIw28IcVAKzI0EY4vE52x082I5MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
 wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc4
 0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AK
 xVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr
 1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1NJ55UU
 UUU==
X-CM-SenderInfo: 5oxrzvtqj6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [dm-devel v2 1/4] dm thin: Fix UAF in run_timer_softirq()
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
Cc: luomeng12@huawei.com, yukuai3@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When dm_resume() and dm_destroy() are concurrent, it will
lead to UAF, as follows:

 BUG: KASAN: use-after-free in __run_timers+0x173/0x710
 Write of size 8 at addr ffff88816d9490f0 by task swapper/0/0

 CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.0.0-rc6-00001-gaed496328fcd-dirty #26
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
 Call Trace:
  <IRQ>
  dump_stack_lvl+0x73/0x9f
  print_report.cold+0x132/0xaa2
  _raw_spin_lock_irqsave+0xcd/0x160
  __run_timers+0x173/0x710
  kasan_report+0xad/0x110
  __run_timers+0x173/0x710
  __asan_store8+0x9c/0x140
  __run_timers+0x173/0x710
  call_timer_fn+0x310/0x310
  pvclock_clocksource_read+0xfa/0x250
  kvm_clock_read+0x2c/0x70
  kvm_clock_get_cycles+0xd/0x20
  ktime_get+0x5c/0x110
  lapic_next_event+0x38/0x50
  clockevents_program_event+0xf1/0x1e0
  run_timer_softirq+0x49/0x90
  __do_softirq+0x16e/0x62c
  __irq_exit_rcu+0x1fa/0x270
  irq_exit_rcu+0x12/0x20
  sysvec_apic_timer_interrupt+0x8e/0xc0

One of the concurrency UAF can be shown as below:

        use                                  free
do_resume                           |
  __find_device_hash_cell           |
    dm_get                          |
      atomic_inc(&md->holders)      |
                                    | dm_destroy
                                    |   __dm_destroy
                                    |     if (!dm_suspended_md(md))
                                    |     atomic_read(&md->holders)
                                    |     msleep(1)
  dm_resume                         |
    __dm_resume                     |
      dm_table_resume_targets       |
        pool_resume                 |
          do_waker  #add delay work |
  dm_put                            |
    atomic_dec(&md->holders)        |
                                    |     dm_table_destroy
                                    |       pool_dtr
                                    |         __pool_dec
                                    |           __pool_destroy
                                    |             destroy_workqueue
                                    |             kfree(pool) # free pool
        time out
__do_softirq
  run_timer_softirq # pool has already been freed

This can be easily reproduced using:
  1. create thin-pool
  2. dmsetup suspend pool
  3. dmsetup resume pool
  4. dmsetup remove_all # Concurrent with 3

The root cause of UAF bugs is that dm_resume() adds timer after
dm_destroy() skips cancel timer beause of suspend status. After
timeout, it will call run_timer_softirq(), however pool has already
been freed. The concurrency UAF bug will happen.

Therefore, canceling timer again in __pool_destroy().

Fixes: 991d9fa02da0d (dm: add thin provisioning target)
Signed-off-by: Luo Meng <luomeng12@huawei.com>
---
 drivers/md/dm-thin.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index e76c96c760a9..dc271c107fb5 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2889,6 +2889,8 @@ static void __pool_destroy(struct pool *pool)
 	dm_bio_prison_destroy(pool->prison);
 	dm_kcopyd_client_destroy(pool->copier);
 
+	cancel_delayed_work_sync(&pool->waker);
+	cancel_delayed_work_sync(&pool->no_space_timeout);
 	if (pool->wq)
 		destroy_workqueue(pool->wq);
 
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


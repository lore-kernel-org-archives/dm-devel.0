Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EB3BC636CC
	for <dm-devel@archiver.kernel.org>; Thu, 16 Feb 2023 08:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676536032;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CEbQaiGgfmZ+fSU3+cNdv5Lbypi5pIosFoxG4072EMc=;
	b=fYWexs7vRAl7vG+F78DvN6VOLKWvZHAM+bxtzp6zryz8LoQatLvpEdChXtCiVSyDl36pDd
	1G3Uqfub8y7IkecgOfZbMvlp15SJokUuYzDcjPc1icEYQvHo5kR2mSOEPLhF1cvANlcGpf
	SaL71q+Hg5l4fICZuUZDHnPqFsgghbk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-AzuQvT6COQuMFfXp0niA-Q-1; Thu, 16 Feb 2023 03:27:10 -0500
X-MC-Unique: AzuQvT6COQuMFfXp0niA-Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60C0D100F901;
	Thu, 16 Feb 2023 08:27:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4FF6A1121314;
	Thu, 16 Feb 2023 08:27:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 42A7D1946589;
	Thu, 16 Feb 2023 08:27:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 51F231946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Feb 2023 11:23:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 401B9C15BAD; Wed, 15 Feb 2023 11:23:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 39009C15BA0
 for <dm-devel@redhat.com>; Wed, 15 Feb 2023 11:23:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E085811E9C
 for <dm-devel@redhat.com>; Wed, 15 Feb 2023 11:23:53 +0000 (UTC)
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-492-dsbDsYzHOeaM-AQJGnr6lQ-1; Wed, 15 Feb 2023 06:23:51 -0500
X-MC-Unique: dsbDsYzHOeaM-AQJGnr6lQ-1
Received: by mail-qv1-f70.google.com with SMTP id
 i7-20020a056214020700b004ffce246a2bso10340865qvt.3
 for <dm-devel@redhat.com>; Wed, 15 Feb 2023 03:23:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=LN1QDI3q1xvJS6EN1eycIX6A9uuWoSbN95l3Hnu1WxQ=;
 b=m2aaQqPGWZeS/XLhzDPAvmWTDZSM+fMO0+Mo+HSb67o8M/2Q66P6EG0eYEDdx5NmjJ
 ecK94VAw6QLQbiD7euFvDpZbDCuGHT+CTof0YMToW0fdE6hvHikf9m8EN/uJi9xtifyW
 WylX0acElWxFrqB1ulU6J2giD+h7mkFjIZUj/xb/gELYvblZyKphruhutDR/EnC3ttPj
 id64b52rboY6qmZV9/L4R0Wjh2UnK3tARZixJFAr669hiBOTtXNc+6jJlnm7K8O7KQUZ
 pTJrE2rYvstLpOyc46swxgE3AaESYL5KODkkh5Dm/4I4fyeMyhiPdHQlm1VR8LZ3uHlV
 iefQ==
X-Gm-Message-State: AO0yUKUgihNEEVz9hnge3I3LEr/SsfPQCYgjQFT9FwWlayBbvhblevmE
 iDowwKydkzM9SGylzABv4NaglECv7wsm8ISvNXl3yAsllz+IEn8y19NSjgSaMcuqsD/fClO3Bfv
 wVHboZZDVVWAFCKzeKnnUJjo8ALeGodDvE48Gfwj8jg==
X-Received: by 2002:a0c:e148:0:b0:53c:301f:21e5 with SMTP id
 c8-20020a0ce148000000b0053c301f21e5mr125056qvl.71.1676460231079; 
 Wed, 15 Feb 2023 03:23:51 -0800 (PST)
X-Google-Smtp-Source: AK7set/yE6pY9gorKN8Jm3UhsB5mOjfN6cvLR1gtiWgMNji7pciGKUKTvaPVUd5djogeLBLBeMyoLyseeKso6+NqjQo=
X-Received: by 2002:a0c:e148:0:b0:53c:301f:21e5 with SMTP id
 c8-20020a0ce148000000b0053c301f21e5mr125051qvl.71.1676460230864; Wed, 15 Feb
 2023 03:23:50 -0800 (PST)
MIME-Version: 1.0
From: Pingfan Liu <piliu@redhat.com>
Date: Wed, 15 Feb 2023 19:23:40 +0800
Message-ID: <CAF+s44TZw40c_hNDi78VkMq6Xhp23h5j_cadHWirOnYW-wR=NQ@mail.gmail.com>
To: dm-devel@redhat.com
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Thu, 16 Feb 2023 08:27:05 +0000
Subject: [dm-devel] A hang bug of dm on s390x
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
Cc: Ming Lei <minlei@redhat.com>, Tao Liu <ltao@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi guys,

I encountered  a hang issue on a s390x system.  The tested kernel is
not preemptible and booting with "nr_cpus=1"

The test steps:
      umount /home
      lvremove /dev/rhel_s390x-kvm-011/home
      ## uncomment "snapshot_autoextend_threshold = 70" and
      "snapshot_autoextend_percent = 20" in /etc/lvm/lvm.conf

      systemctl enable lvm2-monitor.service
      systemctl start lvm2-monitor.service

      lvremove -y rhel_s390x-kvm-011/thinp
      lvcreate -L 10M -T rhel_s390x-kvm-011/thinp
      lvcreate -V 400M -T rhel_s390x-kvm-011/thinp -n src
      mkfs.ext4 /dev/rhel_s390x-kvm-011/src
      mount /dev/rhel_s390x-kvm-011/src /mnt
      for((i=0;i<4;i++)); do dd if=/dev/zero of=/mnt/test$i.img
bs=100M count=1; done

And the system hangs with the console log [1]

The related kernel config

    CONFIG_PREEMPT_NONE_BUILD=y
    CONFIG_PREEMPT_NONE=y
    CONFIG_PREEMPT_COUNT=y
    CONFIG_SCHED_CORE=y

It turns out that when hanging, the kernel is stuck in the dead-loop
in the function dm_wq_work()
        while (!test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) {
                spin_lock_irq(&md->deferred_lock);
                bio = bio_list_pop(&md->deferred);
                spin_unlock_irq(&md->deferred_lock);

                if (!bio)
                        break;
                thread_cpu = smp_processor_id();
                submit_bio_noacct(bio);
        }
where dm_wq_work()->__submit_bio_noacct()->...->dm_handle_requeue()
keeps generating new bio, and the condition "if (!bio)" can not be
meet.


After applying the following patch, the issue is gone.

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e1ea3a7bd9d9..95c9cb07a42f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2567,6 +2567,7 @@ static void dm_wq_work(struct work_struct *work)
                        break;

                submit_bio_noacct(bio);
+               cond_resched();
        }
 }

But I think it is not a proper solution. And without this patch, if
removing nr_cpus=1 (the system has two cpus), the issue can not be
triggered. That says when more than one cpu, the above loop can exit
by the condition "if (!bio)"

Any ideas?

Thanks,

Pingfan

[1]: the console log when hanging

 [ 2062.321473] device-mapper: thin: 253:4: reached low water mark for
data device: sending event.
 [ 2062.353217] dm-3: detected capacity change from 122880 to 147456
 [-- MARK -- Wed Dec 14 08:45:00 2022]
[ 2062.376690] device-mapper: thin: 253:4: switching pool to
out-of-data-space (queue IO) mode
 [ 2122.393998] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
 [ 2122.394011] (detected by 0, t=6002 jiffies, g=36205, q=624 ncpus=1)
 [ 2122.394014] rcu: All QSes seen, last rcu_sched kthread activity
6002 (4295149593-4295143591), jiffies_till_next_fqs=1, root ->qsmask
0x0
 [ 2122.394017] rcu: rcu_sched kthread starved for 6002 jiffies!
g36205 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
 [ 2122.394019] rcu: Unless rcu_sched kthread gets sufficient CPU
time, OOM is now expected behavior.
 [ 2122.394020] rcu: RCU grace-period kthread stack dump:
 [ 2122.394022] task:rcu_sched       state:R  running task     stack:
  0 pid:   15 ppid:     2 flags:0x00000000
 [ 2122.394027] Call Trace:
 [ 2122.394030]  [<00000001001fd5b0>] __schedule+0x300/0x6c0
 [ 2122.394040]  [<00000001001fd9d2>] schedule+0x62/0xf0
 [ 2122.394042]  [<000000010020360c>] schedule_timeout+0x8c/0x170
 [ 2122.394045]  [<00000000ff9e219e>] rcu_gp_fqs_loop+0x30e/0x3d0
 [ 2122.394053]  [<00000000ff9e3ee2>] rcu_gp_kthread+0x132/0x1b0
 [ 2122.394054]  [<00000000ff980578>] kthread+0x108/0x110
 [ 2122.394058]  [<00000000ff9035cc>] __ret_from_fork+0x3c/0x60
 [ 2122.394061]  [<000000010020455a>] ret_from_fork+0xa/0x30
 [ 2122.394064] rcu: Stack dump where RCU GP kthread last ran:
 [ 2122.394064] Task dump for CPU 0:
 [ 2122.394066] task:kworker/0:2     state:R  running task     stack:
  0 pid:16943 ppid:     2 flags:0x00000004
 [ 2122.394070] Workqueue: kdmflush/253:6 dm_wq_work [dm_mod]
 [ 2122.394100] Call Trace:
 [ 2122.394100]  [<00000000ff98bb98>] sched_show_task.part.0+0xf8/0x130
 [ 2122.394106]  [<00000001001efc9a>]
rcu_check_gp_kthread_starvation+0x172/0x190
 [ 2122.394111]  [<00000000ff9e5afe>] print_other_cpu_stall+0x2de/0x370
 [ 2122.394113]  [<00000000ff9e5d60>] check_cpu_stall+0x1d0/0x270
 [ 2122.394114]  [<00000000ff9e6152>] rcu_sched_clock_irq+0x82/0x230
 [ 2122.394117]  [<00000000ff9f808a>] update_process_times+0xba/0xf0
 [ 2122.394121]  [<00000000ffa0adfa>] tick_sched_handle+0x4a/0x70
 [ 2122.394124]  [<00000000ffa0b2fe>] tick_sched_timer+0x5e/0xc0
 [ 2122.394126]  [<00000000ff9f8cb6>] __hrtimer_run_queues+0x136/0x290
 [ 2122.394128]  [<00000000ff9f9f80>] hrtimer_interrupt+0x150/0x2d0
 [ 2122.394130]  [<00000000ff90ce36>] do_IRQ+0x56/0x70
 [ 2122.394133]  [<00000000ff90d216>] do_irq_async+0x56/0xb0
 [ 2122.394135]  [<00000001001f6786>] do_ext_irq+0x96/0x160
 [ 2122.394138]  [<00000001002047bc>] ext_int_handler+0xdc/0x110
 [ 2122.394140]  [<000003ff8005cf48>]
dm_split_and_process_bio+0x28/0x4d0 [dm_mod]
 [ 2122.394152] ([<000003ff8005d2ec>]
dm_split_and_process_bio+0x3cc/0x4d0 [dm_mod])
 [ 2122.394162]  [<000003ff8005dca8>] dm_submit_bio+0x68/0x110 [dm_mod]
 [ 2122.394173]  [<00000000ffda0698>] __submit_bio+0x78/0x190
 [ 2122.394178]  [<00000000ffda081c>] __submit_bio_noacct+0x6c/0x1e0
 [ 2122.394180]  [<000003ff8005c2ac>] dm_wq_work+0x5c/0xc0 [dm_mod]
 [ 2122.394190]  [<00000000ff9771e6>] process_one_work+0x216/0x4a0
 [ 2122.394196]  [<00000000ff9779a4>] worker_thread+0x64/0x4a0
 [ 2122.394198]  [<00000000ff980578>] kthread+0x108/0x110
 [ 2122.394199]  [<00000000ff9035cc>] __ret_from_fork+0x3c/0x60
 [ 2122.394201]  [<000000010020455a>] ret_from_fork+0xa/0x30
 [ 2302.444001] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
 [ 2302.444015] (detected by 0, t=24007 jiffies, g=36205, q=624 ncpus=1)
 [ 2302.444018] rcu: All QSes seen, last rcu_sched kthread activity
24007 (4295167598-4295143591), jiffies_till_next_fqs=1, root ->qsmask
0x0
 [ 2302.444021] rcu: rcu_sched kthread starved for 24007 jiffies!
g36205 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
 [ 2302.444024] rcu: Unless rcu_sched kthread gets sufficient CPU
time, OOM is now expected behavior.
 [ 2302.444025] rcu: RCU grace-period kthread stack dump:
 [ 2302.444027] task:rcu_sched       state:R  running task     stack:
  0 pid:   15 ppid:     2 flag[-- MARK -- Wed Dec 14 08:50:00 2022]
s:0x00000000
 [ 2302.444204] Call Trace:
 [ 2302.444207]  [<00000001001fd5b0>] __schedule+0x300/0x6c0
 [ 2302.444216]  [<00000001001fd9d2>] schedule+0x62/0xf0
 [ 2302.444218]  [<000000010020360c>] schedule_timeout+0x8c/0x170
 [ 2302.444221]  [<00000000ff9e219e>] rcu_gp_fqs_loop+0x30e/0x3d0
 [ 2302.444227]  [<00000000ff9e3ee2>] rcu_gp_kthread+0x132/0x1b0
 [ 2302.444229]  [<00000000ff980578>] kthread+0x108/0x110
 [ 2302.444232]  [<00000000ff9035cc>] __ret_from_fork+0x3c/0x60
 [ 2302.444235]  [<000000010020455a>] ret_from_fork+0xa/0x30
 [ 2302.444237] rcu: Stack dump where RCU GP kthread last ran:
 [ 2302.444238] Task dump for CPU 0:
 [ 2302.444239] task:kworker/0:2     state:R  running task     stack:
  0 pid:16943 ppid:     2 flags:0x00000004
 [ 2302.444244] Workqueue: kdmflush/253:6 dm_wq_work [dm_mod]
 [ 2302.444270] Call Trace:
 [ 2302.444270]  [<00000000ff98bb98>] sched_show_task.part.0+0xf8/0x130
 [ 2302.444275]  [<00000001001efc9a>]
rcu_check_gp_kthread_starvation+0x172/0x190
 [ 2302.444280]  [<00000000ff9e5afe>] print_other_cpu_stall+0x2de/0x370
 [ 2302.444282]  [<00000000ff9e5d60>] check_cpu_stall+0x1d0/0x270
 [ 2302.444284]  [<00000000ff9e6152>] rcu_sched_clock_irq+0x82/0x230
 [ 2302.444286]  [<00000000ff9f808a>] update_process_times+0xba/0xf0
 [ 2302.444290]  [<00000000ffa0adfa>] tick_sched_handle+0x4a/0x70
 [ 2302.444292]  [<00000000ffa0b2fe>] tick_sched_timer+0x5e/0xc0
 [ 2302.444294]  [<00000000ff9f8cb6>] __hrtimer_run_queues+0x136/0x290
 [ 2302.444296]  [<00000000ff9f9f80>] hrtimer_interrupt+0x150/0x2d0
 [ 2302.444298]  [<00000000ff90ce36>] do_IRQ+0x56/0x70
 [ 2302.444301]  [<00000000ff90d216>] do_irq_async+0x56/0xb0
 [ 2302.444303]  [<00000001001f6786>] do_ext_irq+0x96/0x160
 [ 2302.444306]  [<00000001002047bc>] ext_int_handler+0xdc/0x110
 [ 2302.444308]  [<00000000ffbe2a1e>] kmem_cache_alloc+0x15e/0x530
 [ 2302.444316]  [<00000000ffb3e780>] mempool_alloc+0x60/0x210
 [ 2302.444319]  [<00000000ffd9ac4e>] bio_alloc_bioset+0x1ae/0x410
 [ 2302.444324]  [<00000000ffd9af8c>] bio_alloc_clone+0x3c/0x90
 [ 2302.444326]  [<000003ff8005cf9a>]
dm_split_and_process_bio+0x7a/0x4d0 [dm_mod]
 [ 2302.444337]  [<000003ff8005dca8>] dm_submit_bio+0x68/0x110 [dm_mod]
 [ 2302.444347]  [<00000000ffda0698>] __submit_bio+0x78/0x190
 [ 2302.444350]  [<00000000ffda081c>] __submit_bio_noacct+0x6c/0x1e0
 [ 2302.444353]  [<000003ff8005c2ac>] dm_wq_work+0x5c/0xc0 [dm_mod]
 [ 2302.444363]  [<00000000ff9771e6>] process_one_work+0x216/0x4a0
 [ 2302.444367]  [<00000000ff9779a4>] worker_thread+0x64/0x4a0
 [ 2302.444369]  [<00000000ff980578>] kthread+0x108/0x110
 [ 2302.444371]  [<00000000ff9035cc>] __ret_from_fork+0x3c/0x60
 [ 2302.444373]  [<000000010020455a>] ret_from_fork+0xa/0x30

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


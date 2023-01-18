Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38DFBC32793
	for <dm-devel@archiver.kernel.org>; Wed, 18 Jan 2023 12:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674046276;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mVkxNv5VSNJp9dQGD7LRugn0iI/XiGiN92iklPw9+TQ=;
	b=BZimbNX4BFmfVJpmk3FXVntoEDTeyfwGlklWFwauDRr6oP/o0AFYQFQbFIqCtvY2lIYjoN
	pp+TGf2syI8oEZSMtPcDCXJ+sW0hVbjXLR+kjo3HNVWP+Ism0RBwP3UohLclCmsOi3vUw5
	aACS17uWSgDDF6cSZCCnycQaHn77bus=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-HfKy8nSYO12MsuCdRFfEqA-1; Wed, 18 Jan 2023 07:51:13 -0500
X-MC-Unique: HfKy8nSYO12MsuCdRFfEqA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A96C1C0897B;
	Wed, 18 Jan 2023 12:51:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 85D3B40C2064;
	Wed, 18 Jan 2023 12:51:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3A4AC1946A6E;
	Wed, 18 Jan 2023 12:50:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1E3E119465B7
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 Jan 2023 12:29:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 127A551E5; Wed, 18 Jan 2023 12:29:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 09DB439D92
 for <dm-devel@redhat.com>; Wed, 18 Jan 2023 12:29:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDF103C025C3
 for <dm-devel@redhat.com>; Wed, 18 Jan 2023 12:29:57 +0000 (UTC)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com
 [209.85.128.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-650-RU8lzTCyMAywC36zmC0OWg-1; Wed, 18 Jan 2023 07:29:55 -0500
X-MC-Unique: RU8lzTCyMAywC36zmC0OWg-1
Received: by mail-wm1-f42.google.com with SMTP id
 o17-20020a05600c511100b003db021ef437so1383057wms.4
 for <dm-devel@redhat.com>; Wed, 18 Jan 2023 04:29:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=gzh6ZrkqkngEv4MJOGo9ILn27Q8HsTKFLPq04ZSdKzI=;
 b=OIlYlssK+8OJ7ANRSiaW/8P+aAT2KT3Po2vKVCikjyZEO22AwuuiejlOzzDAzPhzYG
 4cUgnvDl9Z2dwSXzZY9QgiaZt+A5wKmSSwk261ovGENHxKu4ihAjhfo2E0KKyHLGTzH0
 zKNS6OGxbjiFuW1eVt6rmMIFLE7FiXWtw3EIhoC/j2I8tTnaem0Kb55r9+lIf7sxuM8C
 ISU+SSDeqe3j6g27eu/JHtCdCp01bUChTTsKqEd2281k3hIdwlLLaL49R0o2p1MRuiZ9
 bgSoAeRcCn/osoC6p2jyJpPKSRfzyhBpUyYvqzfKLERHj3zsp/o/gWJGrnz+QyBNG9lt
 SZTw==
X-Gm-Message-State: AFqh2krQ0lz8kqnoT1S8/cw9GOi2Aa7HscNuchqUamdKhZeWUHqOPKH0
 k54lowJd0kbLkZhYAIDoGhI9Iw==
X-Google-Smtp-Source: AMrXdXs1kXOwnf+26OwalpWOCGPYwQHM8EqP1UfjXxvtA5lVGTq96frjem/V1tF7n1YGnykFoQESew==
X-Received: by 2002:a05:600c:4e94:b0:3db:bc5:b2ae with SMTP id
 f20-20020a05600c4e9400b003db0bc5b2aemr4738707wmq.41.1674044994224; 
 Wed, 18 Jan 2023 04:29:54 -0800 (PST)
Received: from marvin.hq.arr ([185.109.18.135])
 by smtp.gmail.com with ESMTPSA id
 n42-20020a05600c3baa00b003d9f14e9085sm2099344wms.17.2023.01.18.04.29.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 18 Jan 2023 04:29:53 -0800 (PST)
From: Nikos Tsironis <ntsironis@arrikto.com>
To: snitzer@kernel.org,
	agk@redhat.com,
	dm-devel@redhat.com
Date: Wed, 18 Jan 2023 14:29:44 +0200
Message-Id: <20230118122946.20435-1-ntsironis@arrikto.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH 0/2] dm era: avoid deadlock when swapping table
 with dm-era target
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
Cc: ejt@redhat.com, ntsironis@arrikto.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Under certain conditions, swapping a table, that includes a dm-era
target, with a new table, causes a deadlock.

This happens when a status (STATUSTYPE_INFO) or message IOCTL is blocked
in the suspended dm-era target.

dm-era executes all metadata operations in a worker thread, which stops
processing requests when the target is suspended, and resumes again when
the target is resumed.

So, running 'dmsetup status' or 'dmsetup message' for a suspended dm-era
device blocks, until the device is resumed.

If we then load a new table to the device, while the aforementioned
dmsetup command is blocked in dm-era, and resume the device, we
deadlock.

The problem is that the 'dmsetup status' and 'dmsetup message' commands
hold a reference to the live table, i.e., they hold an SRCU read lock on
md->io_barrier, while they are blocked.

When the device is resumed, the old table is replaced with the new one
by dm_swap_table(), which ends up calling synchronize_srcu() on
md->io_barrier.

Since the blocked dmsetup command is holding the SRCU read lock, and the
old table is never resumed, 'dmsetup resume' blocks too, and we have a
deadlock.

The only way to recover is by rebooting.

Steps to reproduce:

1. Create device with dm-era target

    # dmsetup create eradev --table "0 1048576 era /dev/datavg/erameta /dev/datavg/eradata 8192"

2. Suspend the device

    # dmsetup suspend eradev

3. Load new table to device, e.g., to resize the device. Note, that, we
   must load the new table _after_ suspending the device to ensure the
   constructor of the new target instance reads up-to-date metadata, as
   committed by the post-suspend hook of dm-era.

    # dmsetup load eradev --table "0 2097152 era /dev/datavg/erameta /dev/datavg/eradata 8192"

4. Device now has LIVE and INACTIVE tables

    # dmsetup info eradev
    Name:              eradev
    State:             SUSPENDED
    Read Ahead:        16384
    Tables present:    LIVE & INACTIVE
    Open count:        0
    Event number:      0
    Major, minor:      252, 2
    Number of targets: 1

5. Retrieve the status of the device. This blocks because the device is
   suspended. Equivalently, any 'dmsetup message' operation would block
   too. This command holds the SRCU read lock on md->io_barrier.

    # dmsetup status eradev

6. Resume the device. The resume operation tries to swap the old table
   with the new one and deadlocks, because it synchronizes SRCU for the
   old table, while the blocked 'dmsetup status' holds the SRCU read
   lock. And the old table is never resumed again at this point.

    # dmsetup resume eradev

7. The relevant dmesg logs are:

[ 7093.345486] dm-2: detected capacity change from 1048576 to 2097152
[ 7250.875665] INFO: task dmsetup:1986 blocked for more than 120 seconds.
[ 7250.875722]       Not tainted 5.16.0-rc2-release+ #16
[ 7250.875756] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 7250.875803] task:dmsetup         state:D stack:    0 pid: 1986 ppid:  1313 flags:0x00000000
[ 7250.875809] Call Trace:
[ 7250.875812]  <TASK>
[ 7250.875816]  __schedule+0x330/0x8b0
[ 7250.875827]  schedule+0x4e/0xc0
[ 7250.875831]  schedule_timeout+0x20f/0x2e0
[ 7250.875836]  ? do_set_pte+0xb8/0x120
[ 7250.875843]  ? prep_new_page+0x91/0xa0
[ 7250.875847]  wait_for_completion+0x8c/0xf0
[ 7250.875854]  perform_rpc+0x95/0xb0 [dm_era]
[ 7250.875862]  in_worker1.constprop.20+0x48/0x70 [dm_era]
[ 7250.875867]  ? era_iterate_devices+0x30/0x30 [dm_era]
[ 7250.875872]  ? era_status+0x64/0x1e0 [dm_era]
[ 7250.875877]  era_status+0x64/0x1e0 [dm_era]
[ 7250.875882]  ? dm_get_live_or_inactive_table.isra.11+0x20/0x20 [dm_mod]
[ 7250.875900]  ? __mod_node_page_state+0x82/0xc0
[ 7250.875909]  retrieve_status+0xbc/0x1e0 [dm_mod]
[ 7250.875921]  ? dm_get_live_or_inactive_table.isra.11+0x20/0x20 [dm_mod]
[ 7250.875932]  table_status+0x61/0xa0 [dm_mod]
[ 7250.875942]  ctl_ioctl+0x1b5/0x4f0 [dm_mod]
[ 7250.875956]  dm_ctl_ioctl+0xa/0x10 [dm_mod]
[ 7250.875966]  __x64_sys_ioctl+0x8e/0xd0
[ 7250.875970]  do_syscall_64+0x3a/0xd0
[ 7250.875974]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 7250.875980] RIP: 0033:0x7f20b7cd4017
[ 7250.875984] RSP: 002b:00007ffd443874b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 7250.875988] RAX: ffffffffffffffda RBX: 000055d69d6bd0e0 RCX: 00007f20b7cd4017
[ 7250.875991] RDX: 000055d69d6bd0e0 RSI: 00000000c138fd0c RDI: 0000000000000003
[ 7250.875993] RBP: 000000000000001e R08: 00007f20b81df648 R09: 00007ffd44387320
[ 7250.875996] R10: 00007f20b81deb53 R11: 0000000000000246 R12: 000055d69d6bd110
[ 7250.875998] R13: 00007f20b81deb53 R14: 000055d69d6bd000 R15: 0000000000000000
[ 7250.876002]  </TASK>
[ 7250.876004] INFO: task dmsetup:1987 blocked for more than 120 seconds.
[ 7250.876046]       Not tainted 5.16.0-rc2-release+ #16
[ 7250.876083] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 7250.876129] task:dmsetup         state:D stack:    0 pid: 1987 ppid:  1385 flags:0x00000000
[ 7250.876134] Call Trace:
[ 7250.876136]  <TASK>
[ 7250.876138]  __schedule+0x330/0x8b0
[ 7250.876142]  schedule+0x4e/0xc0
[ 7250.876145]  schedule_timeout+0x20f/0x2e0
[ 7250.876149]  ? __queue_work+0x226/0x420
[ 7250.876156]  wait_for_completion+0x8c/0xf0
[ 7250.876160]  __synchronize_srcu.part.19+0x92/0xc0
[ 7250.876167]  ? __bpf_trace_rcu_stall_warning+0x10/0x10
[ 7250.876173]  ? dm_swap_table+0x2f4/0x310 [dm_mod]
[ 7250.876185]  dm_swap_table+0x2f4/0x310 [dm_mod]
[ 7250.876198]  ? table_load+0x360/0x360 [dm_mod]
[ 7250.876207]  dev_suspend+0x95/0x250 [dm_mod]
[ 7250.876217]  ctl_ioctl+0x1b5/0x4f0 [dm_mod]
[ 7250.876231]  dm_ctl_ioctl+0xa/0x10 [dm_mod]
[ 7250.876240]  __x64_sys_ioctl+0x8e/0xd0
[ 7250.876244]  do_syscall_64+0x3a/0xd0
[ 7250.876247]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 7250.876252] RIP: 0033:0x7f15e9254017
[ 7250.876254] RSP: 002b:00007ffffdc59458 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 7250.876257] RAX: ffffffffffffffda RBX: 000055d4d99560e0 RCX: 00007f15e9254017
[ 7250.876260] RDX: 000055d4d99560e0 RSI: 00000000c138fd06 RDI: 0000000000000003
[ 7250.876261] RBP: 000000000000000f R08: 00007f15e975f648 R09: 00007ffffdc592c0
[ 7250.876263] R10: 00007f15e975eb53 R11: 0000000000000246 R12: 000055d4d9956110
[ 7250.876265] R13: 00007f15e975eb53 R14: 000055d4d9956000 R15: 0000000000000001
[ 7250.876269]  </TASK>

Fix this by allowing metadata operations triggered by user space to run
in the corresponding user space thread, instead of queueing them for
execution by the dm-era worker thread.

This way, even if the device is suspended, the metadata operations will
run and release the SRCU read lock, preventing a subsequent table reload
(dm_swap_table()) from deadlocking.

To make this possible use a mutex to serialize access to the metadata
between the worker thread and the user space threads.

This is a follow up on https://listman.redhat.com/archives/dm-devel/2021-December/msg00044.html.

Nikos Tsironis (2):
  dm era: allocate in-core writesets when loading metadata
  dm era: avoid deadlock when swapping table

 drivers/md/dm-era-target.c | 78 ++++++++++++++++++++++++++++++--------
 1 file changed, 63 insertions(+), 15 deletions(-)

-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


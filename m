Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C1DEC678D4
	for <dm-devel@archiver.kernel.org>; Wed,  1 Mar 2023 21:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677707573;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UhhybF4kZv3FLyFJjqRY5pSzHRprkHjOJ39YnO9z9N8=;
	b=jWycYi5xXa5dBtSeIButK6pvEANa0gMEQ6GgtyTi09RPpEr3EaJUz2hE3oF9s9DOKW4c15
	USjJauZGi6TyWde22uXNtk0Zi9+3jMl+Bsalta2XEHtal4mZeakcrMuOK1teK3ncV+jeQB
	2fH/erCy6QHOQSDCOTZ0YeG/xbnUAAc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-YOsa4pgHOACtqw4-4n6YQQ-1; Wed, 01 Mar 2023 16:52:51 -0500
X-MC-Unique: YOsa4pgHOACtqw4-4n6YQQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB9C83C0ED57;
	Wed,  1 Mar 2023 21:52:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 393FB18EC1;
	Wed,  1 Mar 2023 21:52:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2AE1819452CD;
	Wed,  1 Mar 2023 21:52:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4E3F519472FC
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Mar 2023 21:52:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 31D1D4014CF3; Wed,  1 Mar 2023 21:52:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 29E1F40C6EC4
 for <dm-devel@redhat.com>; Wed,  1 Mar 2023 21:52:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF85D85D184
 for <dm-devel@redhat.com>; Wed,  1 Mar 2023 21:52:44 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-404-cTdClVtpMnGEBCswAOsl_g-1; Wed, 01 Mar 2023 16:52:40 -0500
X-MC-Unique: cTdClVtpMnGEBCswAOsl_g-1
Received: from localhost (localhost [127.0.0.1])
 by mx.ewheeler.net (Postfix) with ESMTP id A577685;
 Wed,  1 Mar 2023 13:46:11 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
 by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
 with LMTP id 8a16r7X22FRJ; Wed,  1 Mar 2023 13:46:10 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mx.ewheeler.net (Postfix) with ESMTPSA id 6C1AB45;
 Wed,  1 Mar 2023 13:46:10 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 6C1AB45
Date: Wed, 1 Mar 2023 13:46:08 -0800 (PST)
From: Eric Wheeler <dm-devel@lists.ewheeler.net>
To: dm-devel@redhat.com
Message-ID: <fad2265d-bfd0-68c5-e04d-8687cbf2aa59@ewheeler.net>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] dm-thin: deadlock between dm_pool_issue_prefetches and
 dm_pool_get_metadata_transaction_id
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
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello Mike, Joe, Alasdair, list:

I think we hit an edge case in dm-thin that is triggering a deadlock. 

Every night right we do thin metadata dumps (for "reasons"), and this
has worked for years. Recently there was a crash while a thin metadata
snapshot was reserved (metadata snapshot, not a volume snapshot).

When the system came up we tried to release the metadata reserve, but when 
we did, it resulted in a deadlock. We have been using 4.19.y, so we 
switched to 6.2 to find out if the problem still exists.  It does, and 
the stack traces for 6.2 are below.

	]# dmsetup message /dev/mapper/data-pool0-tpool 0 release_metadata_snap
	<hangs forever, 
	 `dmsetup` spins 100% CPU, 
	 lots of noise in dmesg>

I thought it was strange that `cat /proc/<pid>/stack` for `dmsetup`
above was empty, perhaps that is irrelevant.

We had to delete the pool and restore from backup to get the customer 
online quickly, but I do have a `dd` image of the metadata volume if you 
need it. It is 16 gigabytes and I can upload it somewhere with an off-list 
email link if you would like.

Apologies in advance, but my stack traces do not have line numbers, so
hopefully this is enough to start with.

Thanks for your help!

-Eric

======== From Linux v6.2.1 ========

[  616.926063] INFO: task kworker/u96:1:857 blocked for more than 368 seconds.
[  616.927007]       Tainted: G            E      6.2.1-1.el7.elrepo.x86_64 #1
[  616.927793] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  616.928604] task:kworker/u96:1   state:D stack:0     pid:857   ppid:2      flags:0x00004000
[  616.929442] Workqueue: dm-thin do_worker [dm_thin_pool]
[  616.930281] Call Trace:
[  616.931104]  <TASK>
[  616.931880]  __schedule+0x2d8/0x8f0
[  616.932716]  schedule+0x68/0xf0
[  616.933546]  rwsem_down_read_slowpath+0x286/0x500
[  616.934368]  down_read+0x43/0xa0
[  616.935188]  dm_pool_issue_prefetches+0x1e/0x52 [dm_thin_pool]
[  616.936015]  do_worker+0x33/0xe0 [dm_thin_pool]
[  616.936826]  process_one_work+0x1bb/0x390
[  616.937655]  worker_thread+0x4d/0x390
[  616.938456]  ? __pfx_worker_thread+0x10/0x10
[  616.939250]  kthread+0xf0/0x120
[  616.940030]  ? __pfx_kthread+0x10/0x10
[  616.940785]  ret_from_fork+0x2c/0x50
[  616.941571]  </TASK>


[  494.063707] INFO: task lvs:4782 blocked for more than 245 seconds.
[  494.064005]       Tainted: G            E      6.2.1-1.el7.elrepo.x86_64 #1
[  494.064297] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  494.064588] task:lvs             state:D stack:0     pid:4782  ppid:4780   flags:0x00000000
[  494.064884] Call Trace:
[  494.065178]  <TASK>
[  494.065467]  __schedule+0x2d8/0x8f0
[  494.065761]  schedule+0x68/0xf0
[  494.066057]  rwsem_down_read_slowpath+0x286/0x500
[  494.066351]  ? __wake_up_common+0x85/0x180
[  494.066662]  down_read+0x43/0xa0
[  494.066958]  dm_pool_get_metadata_transaction_id+0x23/0x60 [dm_thin_pool]
[  494.067258]  pool_status+0xfc/0x730 [dm_thin_pool]
[  494.067558]  ? __alloc_pages+0x187/0x350
[  494.067854]  retrieve_status+0xc7/0x210 [dm_mod]
[  494.068178]  ? __pfx_table_status+0x10/0x10 [dm_mod]
[  494.068485]  table_status+0x66/0xb0 [dm_mod]
[  494.068793]  ctl_ioctl+0x200/0x4b0 [dm_mod]
[  494.069109]  dm_ctl_ioctl+0xe/0x20 [dm_mod]
[  494.069415]  __x64_sys_ioctl+0x95/0xd0
[  494.069721]  do_syscall_64+0x3b/0x90
[  494.070020]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[  494.070310] RIP: 0033:0x7ff5a2ef54a7
[  494.070591] RSP: 002b:00007ffd67e004f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  494.070874] RAX: ffffffffffffffda RBX: 000055e8b10bd470 RCX: 00007ff5a2ef54a7
[  494.071170] RDX: 000055e8b34eb010 RSI: 00000000c138fd0c RDI: 0000000000000004
[  494.071463] RBP: 00007ff5a3a47d83 R08: 00007ff5a3a488d0 R09: 00007ffd67e00420
[  494.071760] R10: 000000000000001e R11: 0000000000000246 R12: 000055e8b34eb010
[  494.072066] R13: 00007ff5a3a47d83 R14: 000055e8b2b07df0 R15: 00007ff5a3a47d83
[  494.072369]  </TASK>


======== From Linux v4.19.93 ========
kernel: INFO: task dmeventd:3549 blocked for more than 120 seconds.
kernel:      Not tainted 4.19.93 #1
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kernel: dmeventd        D    0  3549      1 0x00000080
kernel: Call Trace:
kernel: ? __schedule+0x1f6/0x7a0
kernel: schedule+0x32/0x80
kernel: rwsem_down_read_failed+0x139/0x1c0
kernel: call_rwsem_down_read_failed+0x14/0x30
kernel: down_read+0x1c/0x30
kernel: dm_pool_get_metadata_transaction_id+0x1e/0x50 [dm_thin_pool]
kernel: pool_status+0x20c/0x750 [dm_thin_pool]
kernel: ? dm_get_live_or_inactive_table.isra.5+0x20/0x20 [dm_mod]
kernel: ? __alloc_pages_nodemask+0x12a/0x2e0
kernel: retrieve_status+0xad/0x1c0 [dm_mod]
kernel: ? dm_get_live_or_inactive_table.isra.5+0x20/0x20 [dm_mod]
kernel: table_status+0x61/0xa0 [dm_mod]
kernel: ctl_ioctl+0x1d3/0x500 [dm_mod]
kernel: ? kmem_cache_free+0x10f/0x130
kernel: dm_ctl_ioctl+0xa/0x10 [dm_mod]
kernel: do_vfs_ioctl+0xa9/0x620
kernel: ksys_ioctl+0x60/0x90
kernel: __x64_sys_ioctl+0x16/0x20
kernel: do_syscall_64+0x5b/0x1b0
kernel: entry_SYSCALL_64_after_hwframe+0x44/0xa9
kernel: RIP: 0033:0x7fde7f796307
kernel: Code: Bad RIP value.
kernel: RSP: 002b:00007fde77d49948 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
kernel: RAX: ffffffffffffffda RBX: 0000559539267550 RCX: 00007fde7f796307
kernel: RDX: 00007fde68001a10 RSI: 00000000c138fd0c RDI: 0000000000000007
kernel: RBP: 00007fde7fee8d83 R08: 0000000000000004 R09: 00007fde7fee98c0
kernel: R10: 000000000000001e R11: 0000000000000246 R12: 00007fde68001a10
kernel: R13: 00007fde7fee8d83 R14: 00007fde680018d0 R15: 00007fde7fee8d83
kernel:      Not tainted 4.19.93 #1


kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kernel: Call Trace:
kernel: ? __schedule+0x1f6/0x7a0
kernel: schedule+0x32/0x80
kernel: rwsem_down_read_failed+0x139/0x1c0
kernel: call_rwsem_down_read_failed+0x14/0x30
kernel: down_read+0x1c/0x30
kernel: dm_thin_find_block+0x2e/0x70 [dm_thin_pool]
kernel: thin_map+0x167/0x260 [dm_thin_pool]
kernel: ? nf_ip_reroute+0x60/0x60
kernel: __map_bio+0x42/0x180 [dm_mod]
kernel: __split_and_process_non_flush+0xf8/0x1e0 [dm_mod]
kernel: ? __send_empty_flush.constprop.40+0x60/0x60 [dm_mod]
kernel: __split_and_process_bio+0xa9/0x1b0 [dm_mod]
kernel: __dm_make_request.isra.36+0x3f/0x90 [dm_mod]
kernel: generic_make_request+0x19a/0x3d0
kernel: kthread+0xf8/0x130
kernel: ? kthread_bind+0x10/0x10
kernel: ret_from_fork+0x35/0x40
kernel:      Not tainted 4.19.93 #1



--
Eric Wheeler

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


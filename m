Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E271EE7F143
	for <dm-devel@archiver.kernel.org>; Tue, 26 Sep 2023 22:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695769063;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=M+kQZz8lFikClzDfS2vKurKFd5yVyYryN/EuRg9/M5A=;
	b=epPBgPBdY9IEZwdmpJHQeWpxEj/wZD8RkSdrm4375X2FFkr9bAbqan2gAZsRaFB/vT4U/1
	Q+EBA9s0SSPGEdWuHWKMQZ4shJJ2gfKxYXCKix20ltI4dyMzT4iRe7OCSSWKGLrBJUCVLo
	QQPA7/wqh5trKMQQDBgHqj02nPjFzU8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-fgnTXSLpM8yRWM4igf-PEw-1; Tue, 26 Sep 2023 18:57:40 -0400
X-MC-Unique: fgnTXSLpM8yRWM4igf-PEw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B562C811E7E;
	Tue, 26 Sep 2023 22:57:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2E5549A;
	Tue, 26 Sep 2023 22:57:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 65B9C194658D;
	Tue, 26 Sep 2023 22:57:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BBE811946588
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Sep 2023 22:30:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7861640C2070; Tue, 26 Sep 2023 22:30:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 70DC440C2064
 for <dm-devel@redhat.com>; Tue, 26 Sep 2023 22:30:35 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 535D8811E7B
 for <dm-devel@redhat.com>; Tue, 26 Sep 2023 22:30:35 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-434-MOJvEQcYN3q5gdBaHMRBHQ-1; Tue,
 26 Sep 2023 18:30:33 -0400
X-MC-Unique: MOJvEQcYN3q5gdBaHMRBHQ-1
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1qlGDv-00A6KY-L1; Tue, 26 Sep 2023 22:08:07 +0000
Date: Tue, 26 Sep 2023 23:08:07 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Message-ID: <ZRNWRyc7xPY17fvt@casper.infradead.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] Sleeping function called from invalid context
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: infradead.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Got this in linux-next 20230926, and I don't think it's due to my
patches on top (it may be, will verify):

04178 generic/347       run fstests generic/347 at 2023-09-26 17:24:55
04178 XFS (sdb): Mounting V5 Filesystem c0c11e6a-170c-48e4-84c5-42b46d6d5197
04178 XFS (sdb): Ending clean mount
04179 BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1525
04179 in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1096408, name: kworker/u16:32
04179 preempt_count: 1, expected: 0
04179 RCU nest depth: 0, expected: 0
04179 4 locks held by kworker/u16:32/1096408:
04179  #0: ffff88800ac6ff38 ((wq_completion)dm-thin){+.+.}-{0:0}, at: process_one_work+0x17b/0x4a0
04179  #1: ffff88800800be48 ((work_completion)(&pool->worker)){+.+.}-{0:0}, at: process_one_work+0x17b/0x4a0
04179  #2: ffff88804d8715d0 (&pmd->root_lock){++++}-{3:3}, at: dm_thin_alloc_data_block+0x26/0xb0
04179  #3: ffff88800db2fe98 (&ea->lock){+.+.}-{2:2}, at: dm_ea_context_alloc+0x2a/0x380
04179 Preemption disabled at:
04179 [<ffffffff81878cba>] dm_ea_context_alloc+0x2a/0x380
04179 CPU: 6 PID: 1096408 Comm: kworker/u16:32 Kdump: loaded Not tainted 6.6.0-rc3-next-20230926-00005-geb8b46fa6084-dirty #289
04179 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
04179 Workqueue: dm-thin do_worker
04179 Call Trace:
04179  <TASK>
04179  dump_stack_lvl+0x69/0x80
04179  dump_stack+0x10/0x20
04179  __might_resched+0x1a8/0x2c0
04179  __might_sleep+0x3d/0x70
04179  down_read+0x19/0x180
04179  cache_get+0x46/0xc0
04179  new_read+0x44/0x180
04179  dm_bufio_read+0x24/0x30
04179  dm_bm_read_lock+0x21/0x70
04179  dm_tm_read_lock+0x24/0xa0
04179  sm_ll_find_free_block+0xa1/0x190
04179  sm_ll_find_common_free_block+0x2e/0x80
04179  sm_disk_new_block_in_range+0x2f/0x70
04179  sm_alloc_extent+0xe/0x10
04179  dm_ea_context_alloc+0x4e/0x380
04179  dm_thin_alloc_data_block+0x4f/0xb0
04179  alloc_data_block+0x51/0x190
04179  process_cell+0x34b/0x620
04179  ? _raw_spin_unlock_irq+0x22/0x50
04179  do_worker+0x275/0xa00
04179  process_one_work+0x1d8/0x4a0
04179  ? process_one_work+0x17b/0x4a0
04179  worker_thread+0x1d9/0x3d0
04179  ? rescuer_thread+0x370/0x370
04179  kthread+0x109/0x140
04179  ? kthread_complete_and_exit+0x20/0x20
04179  ret_from_fork+0x31/0x50
04179  ? kthread_complete_and_exit+0x20/0x20
04179  ret_from_fork_asm+0x11/0x20
04179  </TASK>
04179 
04179 =============================
04179 [ BUG: Invalid wait context ]
04179 6.6.0-rc3-next-20230926-00005-geb8b46fa6084-dirty #289 Tainted: G        W         
04179 -----------------------------
04179 kworker/u16:32/1096408 is trying to lock:
04179 ffff88803d8c02f0 (&bc->trees[i].lock){++++}-{3:3}, at: cache_get+0x46/0xc0
04179 other info that might help us debug this:
04179 context-{4:4}
04179 4 locks held by kworker/u16:32/1096408:
04179  #0: ffff88800ac6ff38 ((wq_completion)dm-thin){+.+.}-{0:0}, at: process_one_work+0x17b/0x4a0
04179  #1: ffff88800800be48 ((work_completion)(&pool->worker)){+.+.}-{0:0}, at: process_one_work+0x17b/0x4a0
04179  #2: ffff88804d8715d0 (&pmd->root_lock){++++}-{3:3}, at: dm_thin_alloc_data_block+0x26/0xb0
04179  #3: ffff88800db2fe98 (&ea->lock){+.+.}-{2:2}, at: dm_ea_context_alloc+0x2a/0x380
04179 stack backtrace:
04179 CPU: 6 PID: 1096408 Comm: kworker/u16:32 Kdump: loaded Tainted: G        W          6.6.0-rc3-next-20230926-00005-geb8b46fa6084-dirty #289
04179 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
04179 Workqueue: dm-thin do_worker
04179 Call Trace:
04179  <TASK>
04179  dump_stack_lvl+0x4a/0x80
04179  dump_stack+0x10/0x20
04179  __lock_acquire+0x9c9/0x26d0
04179  ? dump_stack_lvl+0x73/0x80
04179  lock_acquire+0xb8/0x280
04179  ? cache_get+0x46/0xc0
04179  ? __might_resched+0x1b4/0x2c0
04179  down_read+0x3c/0x180
04179  ? cache_get+0x46/0xc0
04179  cache_get+0x46/0xc0
04179  new_read+0x44/0x180
04179  dm_bufio_read+0x24/0x30
04179  dm_bm_read_lock+0x21/0x70
04179  dm_tm_read_lock+0x24/0xa0
04179  sm_ll_find_free_block+0xa1/0x190
04179  sm_ll_find_common_free_block+0x2e/0x80
04179  sm_disk_new_block_in_range+0x2f/0x70
04179  sm_alloc_extent+0xe/0x10
04179  dm_ea_context_alloc+0x4e/0x380
04179  ? save_sm_roots+0x70/0x70
04179  dm_thin_alloc_data_block+0x4f/0xb0
04179  alloc_data_block+0x51/0x190
04179  process_cell+0x34b/0x620
04179  ? _raw_spin_unlock_irq+0x22/0x50
04179  do_worker+0x275/0xa00
04179  process_one_work+0x1d8/0x4a0
04179  ? process_one_work+0x17b/0x4a0
04179  worker_thread+0x1d9/0x3d0
04179  ? rescuer_thread+0x370/0x370
04179  kthread+0x109/0x140
04179  ? kthread_complete_and_exit+0x20/0x20
04179  ret_from_fork+0x31/0x50
04179  ? kthread_complete_and_exit+0x20/0x20
04179  ret_from_fork_asm+0x11/0x20
04179  </TASK>

I have a few more of these, but I don't see any new information in them.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


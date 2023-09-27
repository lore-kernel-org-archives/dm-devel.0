Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBA9DE80A82
	for <dm-devel@archiver.kernel.org>; Wed, 27 Sep 2023 04:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695790133;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tNZnjfmz/aSffhcSaC1RfoYZeflH2hyP4E5R10MJ3+o=;
	b=eA2gfoOVPEdTT7nJoOKy/Uy1AOU/amW5Cd7fNfTgbTscC7gDi3lip/K8h6vqYt6OnvaKM8
	L/lyEBDpfD9ZQTudZ9yiqbNwvMlfZptPIkdHUsGrZwPFyvh8W01RTL3M6nrrPuHr97noLK
	jf9xJm5ev42gr1T5fBVY25L8H9M4Tg4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-80-UBZ9lLlJOGeA5ZWYgjdAig-1; Wed, 27 Sep 2023 00:48:50 -0400
X-MC-Unique: UBZ9lLlJOGeA5ZWYgjdAig-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A89A3811E7E;
	Wed, 27 Sep 2023 04:48:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 74C07492C37;
	Wed, 27 Sep 2023 04:48:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 11A341946589;
	Wed, 27 Sep 2023 04:48:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BE8081946588
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Sep 2023 04:42:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AD64F2156A27; Wed, 27 Sep 2023 04:42:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A5AF82156702
 for <dm-devel@redhat.com>; Wed, 27 Sep 2023 04:42:24 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86D87185A790
 for <dm-devel@redhat.com>; Wed, 27 Sep 2023 04:42:24 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-488-9DmI9wqLPhmAqzOmvQUGDg-1; Wed,
 27 Sep 2023 00:42:20 -0400
X-MC-Unique: 9DmI9wqLPhmAqzOmvQUGDg-1
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1qlMNO-00BoS6-Az; Wed, 27 Sep 2023 04:42:18 +0000
Date: Wed, 27 Sep 2023 05:42:18 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com
Message-ID: <ZROyqtbB6OuMOqci@casper.infradead.org>
References: <ZRNWRyc7xPY17fvt@casper.infradead.org>
 <ZRNg7ctL4cx75RVh@casper.infradead.org>
MIME-Version: 1.0
In-Reply-To: <ZRNg7ctL4cx75RVh@casper.infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] Sleeping function called from invalid context
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
Cc: Mike Snitzer <snitzer@kernel.org>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: infradead.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Sep 26, 2023 at 11:53:33PM +0100, Matthew Wilcox wrote:
> I'm going to sleep now instead of running the last 10 steps of the
> bisect.  If nobody's found this when I wake up, I'll finish it then.

Bisection found it.  I confirmed by hand; checking out this commit
yields a failed test, and then reverting it leads to a success.

commit 026e4728c276cdf3ec618a71a38181864596027b
Author: Joe Thornber <ejt@redhat.com>
Date:   Wed Sep 13 10:39:09 2023 +0100

    dm thin: Use the extent allocator for data blocks

    The thin_pool object now contains an extent-allocator, and each thin
    device contains an allocation-context from this.  The allocation
    context is used to guide data block allocations.  The actual
    allocation book-keeping is still done by the space-map.

    2 new specific unit tests were added to dm-unit:

       /thinp/fragmentation/thins
       /thinp/fragmentation/snapshots

       https://github.com/jthornber/dm-unit/blob/main/src/tests/thinp.rs

    Signed-off-by: Joe Thornber <ejt@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>

Joe, in case you missed the earlier splat:

00009 generic/347       run fstests generic/347 at 2023-09-27 04:07:02
00010 BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1519
00010 in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 79, name: kworker/u16:3
00010 preempt_count: 1, expected: 0
00010 RCU nest depth: 0, expected: 0
00010 4 locks held by kworker/u16:3/79:
00010  #0: ffff888008a22138 ((wq_completion)dm-thin){+.+.}-{0:0}, at: process_one_work+0x17b/0x4a0
00010  #1: ffff888004fb7e48 ((work_completion)(&pool->worker)){+.+.}-{0:0}, at: process_one_work+0x17b/0x4a0
00010  #2: ffff88800cb1c1d0 (&pmd->root_lock){++++}-{3:3}, at: dm_thin_alloc_data_block+0x26/0xb0
00010  #3: ffff888008b77298 (&ea->lock){+.+.}-{2:2}, at: dm_ea_context_alloc+0x2a/0x380
00010 Preemption disabled at:
00010 [<ffffffff8186f6ca>] dm_ea_context_alloc+0x2a/0x380
00010 CPU: 5 PID: 79 Comm: kworker/u16:3 Kdump: loaded Not tainted 6.6.0-rc2-00004-g026e4728c276 #306
00010 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
00010 Workqueue: dm-thin do_worker
00010 Call Trace:
00010  <TASK>
00010  dump_stack_lvl+0x69/0x80
00010  dump_stack+0x10/0x20
00010  __might_resched+0x1a8/0x2c0
00010  __might_sleep+0x3d/0x70
00010  down_read+0x19/0x180
00010  cache_get+0x46/0xc0
00010  new_read+0x44/0x180
00010  dm_bufio_read+0x24/0x30
00010  dm_bm_read_lock+0x21/0x70
00010  dm_tm_read_lock+0x24/0xa0
00010  sm_ll_find_free_block+0xa1/0x190
00010  sm_ll_find_common_free_block+0x2e/0x80
00010  sm_disk_new_block_in_range+0x2f/0x70
00010  sm_alloc_extent+0xe/0x10
00010  dm_ea_context_alloc+0x4e/0x380
00010  ? save_sm_roots+0x70/0x70
00010  dm_thin_alloc_data_block+0x4f/0xb0
00010  alloc_data_block+0x51/0x190
00010  process_cell+0x34b/0x620
00010  ? _raw_spin_unlock_irq+0x22/0x50
00010  do_worker+0x275/0xa00
00010  process_one_work+0x1d8/0x4a0
00010  ? process_one_work+0x17b/0x4a0
00010  worker_thread+0x1d9/0x3d0
00010  ? wq_sysfs_prep_attrs+0x90/0x90
00010  kthread+0x109/0x140
00010  ? kthread_complete_and_exit+0x20/0x20
00010  ret_from_fork+0x31/0x50
00010  ? kthread_complete_and_exit+0x20/0x20
00010  ret_from_fork_asm+0x11/0x20
00010  </TASK>
00010
00010 =============================
00010 [ BUG: Invalid wait context ]
00010 6.6.0-rc2-00004-g026e4728c276 #306 Tainted: G        W
00010 -----------------------------
00010 kworker/u16:3/79 is trying to lock:
00010 ffff88800cda7330 (&bc->trees[i].lock){++++}-{3:3}, at: cache_get+0x46/0xc0
00010 other info that might help us debug this:
00010 context-{4:4}
00010 4 locks held by kworker/u16:3/79:
00010  #0: ffff888008a22138 ((wq_completion)dm-thin){+.+.}-{0:0}, at: process_one_work+0x17b/0x4a0
00010  #1: ffff888004fb7e48 ((work_completion)(&pool->worker)){+.+.}-{0:0}, at: process_one_work+0x17b/0x4a0
00010  #2: ffff88800cb1c1d0 (&pmd->root_lock){++++}-{3:3}, at: dm_thin_alloc_data_block+0x26/0xb0
00010  #3: ffff888008b77298 (&ea->lock){+.+.}-{2:2}, at: dm_ea_context_alloc+0x2a/0x380
00010 stack backtrace:
00010 CPU: 5 PID: 79 Comm: kworker/u16:3 Kdump: loaded Tainted: G        W          6.6.0-rc2-00004-g026e4728c276 #306
00010 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
00010 Workqueue: dm-thin do_worker
00010 Call Trace:
00010  <TASK>
00010  dump_stack_lvl+0x4a/0x80
00010  dump_stack+0x10/0x20
00010  __lock_acquire+0x9c9/0x26d0
00010  ? dump_stack_lvl+0x73/0x80
00010  lock_acquire+0xb8/0x280
00010  ? cache_get+0x46/0xc0
00010  ? __might_resched+0x1b4/0x2c0
00010  down_read+0x3c/0x180
00010  ? cache_get+0x46/0xc0
00010  cache_get+0x46/0xc0
00010  new_read+0x44/0x180
00010  dm_bufio_read+0x24/0x30
00010  dm_bm_read_lock+0x21/0x70
00010  dm_tm_read_lock+0x24/0xa0
00010  sm_ll_find_free_block+0xa1/0x190
00010  sm_ll_find_common_free_block+0x2e/0x80
00010  sm_disk_new_block_in_range+0x2f/0x70
00010  sm_alloc_extent+0xe/0x10
00010  dm_ea_context_alloc+0x4e/0x380
00010  ? save_sm_roots+0x70/0x70
00010  dm_thin_alloc_data_block+0x4f/0xb0
00010  alloc_data_block+0x51/0x190
00010  process_cell+0x34b/0x620
00010  ? _raw_spin_unlock_irq+0x22/0x50
00010  do_worker+0x275/0xa00
00010  process_one_work+0x1d8/0x4a0
00010  ? process_one_work+0x17b/0x4a0
00010  worker_thread+0x1d9/0x3d0
00010  ? wq_sysfs_prep_attrs+0x90/0x90
00010  kthread+0x109/0x140
00010  ? kthread_complete_and_exit+0x20/0x20
00010  ret_from_fork+0x31/0x50
00010  ? kthread_complete_and_exit+0x20/0x20
00010  ret_from_fork_asm+0x11/0x20
00010  </TASK>


This seems fairly clear to me; there's a spin_lock() around the call to
__alloc() in dm_ea_context_alloc(), which then calls all the way down
that stack until you get to cache_get(), which takes a semaphore and
the locking validation quite reasonably says "You can't do that".

I'm sure you don't need my help coming up with a fix.  Although I might
ask that you turn on at least some basic locking checks in future while
developing your code, even if not full lockdep.  I think this particular
warning comes out of CONFIG_DEBUG_ATOMIC_SLEEP=y.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


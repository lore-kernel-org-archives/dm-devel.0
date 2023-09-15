Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFF64EEEC00
	for <dm-devel@archiver.kernel.org>; Fri, 15 Sep 2023 19:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694805624;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Zb0E9AFZNO1Wrp1PzpySOgOOIbk+4PwwFCZ8VPTZS9g=;
	b=aR7COZuTb+7vw0v+mUC2Zo8exMPIk+EOj7pXH6AAUd0/kJS9THif5QWdsUBCkhbP1AiK+3
	YwpMZJ9fMI6+OOTqmg+4Dee2wSrKwGoEf/wAW5Q0FBthy+ydQ1+Bwk4zQ/soIFl67wDAT9
	NGVDCS09dz+WH9EJTJfHxs0eZvjlprc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-70-eRs5jCMqMaySiL0C8muAVQ-1; Fri, 15 Sep 2023 15:20:21 -0400
X-MC-Unique: eRs5jCMqMaySiL0C8muAVQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A5CC1818E53;
	Fri, 15 Sep 2023 19:20:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 16F7A409746E;
	Fri, 15 Sep 2023 19:20:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D53F4194658C;
	Fri, 15 Sep 2023 19:20:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 574471946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Sep 2023 19:13:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 384C81CBC3; Fri, 15 Sep 2023 19:13:24 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 22EF928FD;
 Fri, 15 Sep 2023 19:13:23 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id CE95130C2C07; Fri, 15 Sep 2023 19:13:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 C98D03FB7D; Fri, 15 Sep 2023 21:13:23 +0200 (CEST)
Date: Fri, 15 Sep 2023 21:13:23 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
In-Reply-To: <ZQSoWU78md88xFgB@redhat.com>
Message-ID: <dbee74a-cb51-ad2-7cad-4ac67488c84@redhat.com>
References: <4f5737f0-9299-4968-8cb5-07c7645bbffd@kernel.dk>
 <514767b4-5b2a-4f8e-a6ba-6722ddac5330@kernel.dk>
 <ZQSoWU78md88xFgB@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] DM brokeness with NOWAIT
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
Cc: Jens Axboe <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Fri, 15 Sep 2023, Mike Snitzer wrote:

> On Fri, Sep 15 2023 at 12:14P -0400,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
> > On 9/15/23 10:04 AM, Jens Axboe wrote:
> > > Hi,
> > > 
> > > Threw some db traffic into my testing mix, and that ended in tears
> > > very quickly:
> > > 
> > > CPU: 7 PID: 49609 Comm: ringbuf-read.t Tainted: G        W          6.6.0-rc1-g39956d2dcd81 #129
> > > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> > > Call Trace:
> > >  <TASK>
> > >  dump_stack_lvl+0x11d/0x1b0
> > >  __might_resched+0x3c3/0x5e0
> > >  ? preempt_count_sub+0x150/0x150
> > >  mempool_alloc+0x1e2/0x390
> > >  ? sanity_check_pinned_pages+0x23/0x1010
> > >  ? mempool_resize+0x7d0/0x7d0
> > >  bio_alloc_bioset+0x417/0x8c0
> > >  ? bvec_alloc+0x200/0x200
> > >  ? __gup_device_huge+0x900/0x900
> > >  bio_alloc_clone+0x53/0x100
> > >  dm_submit_bio+0x27f/0x1a20
> > >  ? lock_release+0x4b7/0x670
> > >  ? pin_user_pages_fast+0xb6/0xf0
> > >  ? blk_try_enter_queue+0x1a0/0x4d0
> > >  ? dm_dax_direct_access+0x260/0x260
> > >  ? rcu_is_watching+0x12/0xb0
> > >  ? blk_try_enter_queue+0x1cc/0x4d0
> > >  __submit_bio+0x239/0x310
> > >  ? __bio_queue_enter+0x700/0x700
> > >  ? kvm_clock_get_cycles+0x40/0x60
> > >  ? ktime_get+0x285/0x470
> > >  submit_bio_noacct_nocheck+0x4d9/0xb80
> > >  ? should_fail_request+0x80/0x80
> > >  ? preempt_count_sub+0x150/0x150
> > >  ? folio_flags+0x6c/0x1e0
> > >  submit_bio_noacct+0x53e/0x1b30
> > >  blkdev_direct_IO.part.0+0x833/0x1810
> > >  ? rcu_is_watching+0x12/0xb0
> > >  ? lock_release+0x4b7/0x670
> > >  ? blkdev_read_iter+0x40d/0x530
> > >  ? reacquire_held_locks+0x4e0/0x4e0
> > >  ? __blkdev_direct_IO_simple+0x780/0x780
> > >  ? rcu_is_watching+0x12/0xb0
> > >  ? __mark_inode_dirty+0x297/0xd50
> > >  ? preempt_count_add+0x72/0x140
> > >  blkdev_read_iter+0x2a4/0x530
> > >  ? blkdev_write_iter+0xc40/0xc40
> > >  io_read+0x369/0x1490
> > >  ? rcu_is_watching+0x12/0xb0
> > >  ? io_writev_prep_async+0x260/0x260
> > >  ? __fget_files+0x279/0x410
> > >  ? rcu_is_watching+0x12/0xb0
> > >  io_issue_sqe+0x18a/0xd90
> > >  io_submit_sqes+0x970/0x1ed0
> > >  __do_sys_io_uring_enter+0x14d4/0x2650
> > >  ? io_submit_sqes+0x1ed0/0x1ed0
> > >  ? rcu_is_watching+0x12/0xb0
> > >  ? __do_sys_io_uring_register+0x3f6/0x2190
> > >  ? io_req_caches_free+0x500/0x500
> > >  ? ksys_mmap_pgoff+0x85/0x5b0
> > >  ? rcu_is_watching+0x12/0xb0
> > >  ? trace_irq_enable.constprop.0+0xd0/0x100
> > >  do_syscall_64+0x39/0xb0
> > >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > 
> > > which seems to demonstrate a misunderstanding on what REQ_NOWAIT is
> > > about. In particulary, it seems to assume you can then submit with
> > > atomic context? DM does an rcu_read_lock() and happily proceeds to
> > > attempt to submit IO under RCU being disabled.
> > 
> > Did a quick check to see where this came from, and it got added with:
> > 
> > commit 563a225c9fd207326c2a2af9d59b4097cb31ce70
> > Author: Mike Snitzer <snitzer@kernel.org>
> > Date:   Sat Mar 26 21:08:36 2022 -0400
> > 
> >     dm: introduce dm_{get,put}_live_table_bio called from dm_submit_bio
> > 
> > which conspiciously doesn't include any numbers on why this is necessary
> > or a good thing, and notably probably wasn't tested? This landed in 5.19
> > fwiw.
> 
> Don't recall what I was thinking, and I clearly didn't properly test
> either... should've consulted Mikulas.  Sorry for the trouble.
> 
> Would you like to send a formal patch with your Signed-off-by and I'll
> mark it for stable@ and get it to Linus?
> 
> Mike

We could revert that commit or we could change the all the remaining 
GFP_NOIOs in drivers/md/dm.c to "bio_opf & REQ_NOWAIT ? GFP_NOWAIT : 
GFP_NOIO". I'm not sure which one of these possibilities is better.

Converting GFP_NOIOs would complicate dm.c a bit, but it would make sure 
that requests with REQ_NOWAIT don't really sleep. What do you think?

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D4D1C04A68
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jul 2022 23:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658876686;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wfosjo3rmYQD/ZQgRrQd4LzlRU/UIhTuaPbE+CTdTtw=;
	b=IRTotNZA8FACbLnZg3N4CcAhW/yzL07rsYxUl90ntKGuNQgAsPa60ta5Ej5Uh58JTl2iAg
	GGD3CRViTgYzfZIHXdjnt02QywANhcY5hFzOPBFg0ALWfVE2A/Hg53Zbscc8/ifNQLm8hO
	ePQ6wIvWhNO3oIsx64hdOEVWDmC3MJI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-4KI77djMO8qUGOJiCKYnsg-1; Tue, 26 Jul 2022 19:04:42 -0400
X-MC-Unique: 4KI77djMO8qUGOJiCKYnsg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6AE885A581;
	Tue, 26 Jul 2022 23:04:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 71CE01121314;
	Tue, 26 Jul 2022 23:04:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 412CA1945D89;
	Tue, 26 Jul 2022 23:04:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D24D71945D89
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Jul 2022 23:04:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B1A921121319; Tue, 26 Jul 2022 23:04:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ADE541121314
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 23:04:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CB621C05AB4
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 23:04:36 +0000 (UTC)
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-OGzsmkBRMgqUloo-vx76Rw-1; Tue, 26 Jul 2022 19:04:35 -0400
X-MC-Unique: OGzsmkBRMgqUloo-vx76Rw-1
Received: by mail-qk1-f199.google.com with SMTP id
 br36-20020a05620a462400b006b5fa8e5dd5so13134434qkb.1
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 16:04:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=J1ATw0IlBGEkqdlkshb2bwGF7dYQhPMOv0081AFBSKM=;
 b=UdsHQF2kATI2y2Fpy2V23UBqiFePtHsxY8vmYvyLtmFquY7MCCxXK0ZgX+CvmETV65
 /89YyTmI5gWof8Y7ecO/I91HzOZBMd1O/Nd06mejMN5cvWaa00Yb7bWmvmERUinalvdc
 E8/2UTb0ptGIKLpBryLiIwb0CAVM90lbZLXgbKXsdwR7r6Kt4cZI6WouJ8QwjKc2ACsn
 FS+xFazTJuy9v++7hiI6IdiKALSo2m7A1dD9fhXGjKQi5wa8EhzOi8sb8vtbOthSrjx4
 8aR7tpAY4xQVTisI4AEzqwdDIYognWyQ22iwwlSbIR03W1txL2fO8Ttwy0/YWiYgS7qB
 Zn5g==
X-Gm-Message-State: AJIora/e/mi/XdTm2cLLHl+KK0pusjchZF+ijNMZg8nkROBost7/zgTB
 Gg5m7Q5/70GTXke1nLVAZSFET4dWZXq+SaFkVw+7GnlazqBoMvltcPZmLLT+9h70gDy1fIJzPNq
 Ruri2swyH0bkh9Q==
X-Received: by 2002:a05:622a:190a:b0:31f:31ef:b19b with SMTP id
 w10-20020a05622a190a00b0031f31efb19bmr13438405qtc.598.1658876674801; 
 Tue, 26 Jul 2022 16:04:34 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sBZnC6M/b02SB460Ac4uRP4ybgCW44wcZGEOGi8qsbxJ/1D7McO93jFdwEd8G4VpUh2V8tMQ==
X-Received: by 2002:a05:622a:190a:b0:31f:31ef:b19b with SMTP id
 w10-20020a05622a190a00b0031f31efb19bmr13438386qtc.598.1658876674465; 
 Tue, 26 Jul 2022 16:04:34 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 gb7-20020a05622a598700b0031ecb762677sm9772271qtb.66.2022.07.26.16.04.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 26 Jul 2022 16:04:33 -0700 (PDT)
Date: Tue, 26 Jul 2022 19:04:32 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Milan Broz <gmazyland@gmail.com>
Message-ID: <YuBzAIXQXBRwukR7@redhat.com>
References: <20220726160959.89247-1-snitzer@kernel.org>
 <6a158b48-10d3-6427-bc44-e7f78513380b@gmail.com>
MIME-Version: 1.0
In-Reply-To: <6a158b48-10d3-6427-bc44-e7f78513380b@gmail.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v2 0/6] dm verity: optionally use tasklets
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
Cc: Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Nathan Huckleberry <nhuck@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jul 26 2022 at  5:44P -0400,
Milan Broz <gmazyland@gmail.com> wrote:

> On 26/07/2022 18:09, Mike Snitzer wrote:
> > Hi,
> > 
> > Please see this updated patchset that reflects what I've staged for
> > the 5.20 merge window, see:
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.20
> > 
> > My only outstanding question, from previous v1 patchset, is: should
> > the verify_wq be created using WQ_HIGHPRI instead of WQ_CPU_INTENSIVE?
> > (I doubt it has a significant impact on performance but if you have
> > insight on why you made that change, and if it meaningful, I'd happily
> > apply the change).
> > 
> > I've tested using cryptsetup's testsuite (which has dm-verity tests)
> > but I haven't tested the "try_verify_in_tasklet" feature.

I wasn't lying above: I haven't tested the "try_verify_in_tasklet"
feature.  I just figured I didn't break what Huck posted by cleaning
it up while reviewing closely ;)

> Hi Mike,
> 
> I added new veritysetup option --use-tasklets for testing to a new branch
> https://gitlab.com/cryptsetup/cryptsetup/-/commits/verify-tasklet
> 
> I tried to run verity-compat-test (on that branch above), not used the flag yet,
> just in one simple option flag test (see the branch).

OK, thanks for doing this work, really appreciate it.  How is it I
would initiate this test using your "verify-tasklet" branch?

(I only ever run "make check", I'm not a power user with cryptsetup's
testing. So any pointers on how best to focus on dm-verity testing
using the existing make targets and options would be welcomed.

But I looked at your new test and if I understand it correctly: it
just loads a test device with "try_verify_in_tasklet" set in the
optional args.

(safe to assume any IO issued to the device is a sideffect of udev
scripts?)

But yeah, you haven't even tried to break it yet.. and it fell over ;)

> But with your patches (on top of 5.19.0-rc8) and my testing 32bit VM:
> 
> - FEC tests are skipped even if FEC is enabled in kernel.
> I think the whole FEC is broken with your patches.
> (Beware, test will skip FEC quietly! Usually CONFIG_DM_VERITY_FEC is disabled,
> so we have to ignore it.)

with tasklets the FEC code path should always punt to the workqueue.
Which is free to sleep.  But the following lockdep tracing you
provided seems to be concerned about the dm_bufio_get in tasklet
(having locked w/ irqsave) vs dm_bufio_prefetch in workqueue locking
global_spinlock with spin_lock (not _irqsave).

I'm just missing the link between the two, as in: how would the
dm_bufio_get directly get to dm_bufio_prefetch without first bouncing
through the workqueue? (answer should always be: you can't).

If the lockdep report shows how, I'm missing it (with suboptimal
reading ability of lockdep traces).

Oh.. I think it's just saying that since all the locking is with a
spinlock, no matter the context, there is potential for issues, with
inconsistent locking.  It isn't saying it actually triggered the
deadlock. Basically seems like false-positive (workqueue won't ever be
in interrupt context).

I wonder if adjust_total_allocated() should just grow some lockdep
annotation to silence lockdep rather than go to the extreme of it
using _irqsave (but I'll go with that first).

Thanks,
Mike

> - Also I see this warning (in that simple option test I added).
> 
> : =====================================================
> : WARNING: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected
> : 5.19.0-rc8+ #767 Not tainted
> : -----------------------------------------------------
> : kworker/u16:6/2488 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> : f7a38090 (global_spinlock){+.+.}-{2:2}, at: adjust_total_allocated+0x95/0x120 [dm_bufio]
> : \x0aand this task is already holding:
> : c555086c (&c->spinlock){..-.}-{2:2}, at: dm_bufio_lock+0x54/0x60 [dm_bufio]
> : which would create a new lock dependency:
> :  (&c->spinlock){..-.}-{2:2} -> (global_spinlock){+.+.}-{2:2}
> : \x0abut this new dependency connects a SOFTIRQ-irq-safe lock:
> :  (&c->spinlock){..-.}-{2:2}
> : \x0a... which became SOFTIRQ-irq-safe at:
> :   lock_acquire+0xb2/0x2b0
> :   _raw_spin_lock_irqsave_nested+0x3b/0x90
> :   dm_bufio_lock+0x54/0x60 [dm_bufio]
> :   new_read+0x32/0x120 [dm_bufio]
> :   dm_bufio_get+0xd/0x10 [dm_bufio]
> :   verity_verify_level+0x199/0x220 [dm_verity]
> :   verity_hash_for_block+0x26/0xf0 [dm_verity]
> :   verity_verify_io+0x134/0x490 [dm_verity]
> :   verity_tasklet+0xf/0x7f [dm_verity]
> :   tasklet_action_common.constprop.0+0xd0/0xf0
> :   tasklet_action+0x21/0x30
> :   __do_softirq+0xb4/0x4c5
> :   run_ksoftirqd+0x35/0x50
> :   smpboot_thread_fn+0x174/0x230
> :   kthread+0xd2/0x100
> :   ret_from_fork+0x19/0x24
> : \x0ato a SOFTIRQ-irq-unsafe lock:
> :  (global_spinlock){+.+.}-{2:2}
> : \x0a... which became SOFTIRQ-irq-unsafe at:
> : ...
> :   lock_acquire+0xb2/0x2b0
> :   _raw_spin_lock+0x28/0x70
> :   adjust_total_allocated+0x95/0x120 [dm_bufio]
> :   __link_buffer+0xb2/0xf0 [dm_bufio]
> :   __bufio_new+0x20b/0x2b0 [dm_bufio]
> :   dm_bufio_prefetch+0x90/0x1f0 [dm_bufio]
> :   verity_prefetch_io+0x142/0x180 [dm_verity]
> :   process_one_work+0x246/0x530
> :   worker_thread+0x47/0x3e0
> :   kthread+0xd2/0x100
> :   ret_from_fork+0x19/0x24
> : \x0aother info that might help us debug this:\x0a
> :  Possible interrupt unsafe locking scenario:\x0a
> :        CPU0                    CPU1
> :        ----                    ----
> :   lock(global_spinlock);
> :                                local_irq_disable();
> :                                lock(&c->spinlock);
> :                                lock(global_spinlock);
> :   <Interrupt>
> :     lock(&c->spinlock);
> : \x0a *** DEADLOCK ***\x0a
> : 3 locks held by kworker/u16:6/2488:
> :  #0: c55494b8 ((wq_completion)kverityd){+.+.}-{0:0}, at: process_one_work+0x1d0/0x530
> :  #1: c6c49f38 ((work_completion)(&pw->work)){+.+.}-{0:0}, at: process_one_work+0x1d0/0x530
> :  #2: c555086c (&c->spinlock){..-.}-{2:2}, at: dm_bufio_lock+0x54/0x60 [dm_bufio]
> : \x0athe dependencies between SOFTIRQ-irq-safe lock and the holding lock:
> : -> (&c->spinlock){..-.}-{2:2} ops: 2 {
> :    IN-SOFTIRQ-W at:
> :                     lock_acquire+0xb2/0x2b0
> :                     _raw_spin_lock_irqsave_nested+0x3b/0x90
> :                     dm_bufio_lock+0x54/0x60 [dm_bufio]
> :                     new_read+0x32/0x120 [dm_bufio]
> :                     dm_bufio_get+0xd/0x10 [dm_bufio]
> :                     verity_verify_level+0x199/0x220 [dm_verity]
> :                     verity_hash_for_block+0x26/0xf0 [dm_verity]
> :                     verity_verify_io+0x134/0x490 [dm_verity]
> :                     verity_tasklet+0xf/0x7f [dm_verity]
> :                     tasklet_action_common.constprop.0+0xd0/0xf0
> :                     tasklet_action+0x21/0x30
> :                     __do_softirq+0xb4/0x4c5
> :                     run_ksoftirqd+0x35/0x50
> :                     smpboot_thread_fn+0x174/0x230
> :                     kthread+0xd2/0x100
> :                     ret_from_fork+0x19/0x24
> :    INITIAL USE at:
> :                    lock_acquire+0xb2/0x2b0
> :                    _raw_spin_lock_irqsave_nested+0x3b/0x90
> :                    dm_bufio_lock+0x54/0x60 [dm_bufio]
> :                    dm_bufio_prefetch+0x4b/0x1f0 [dm_bufio]
> :                    verity_prefetch_io+0x3c/0x180 [dm_verity]
> :                    process_one_work+0x246/0x530
> :                    worker_thread+0x47/0x3e0
> :                    kthread+0xd2/0x100
> :                    ret_from_fork+0x19/0x24
> :  }
> :  ... key      at: [<f7a384e8>] __key.24+0x0/0xffffeb18 [dm_bufio]
> : \x0athe dependencies between the lock to be acquired
> :  and SOFTIRQ-irq-unsafe lock:
> : -> (global_spinlock){+.+.}-{2:2} ops: 129329 {
> :    HARDIRQ-ON-W at:
> :                     lock_acquire+0xb2/0x2b0
> :                     _raw_spin_lock+0x28/0x70
> :                     adjust_total_allocated+0x95/0x120 [dm_bufio]
> :                     __link_buffer+0xb2/0xf0 [dm_bufio]
> :                     __bufio_new+0x20b/0x2b0 [dm_bufio]
> :                     dm_bufio_prefetch+0x90/0x1f0 [dm_bufio]
> :                     verity_prefetch_io+0x142/0x180 [dm_verity]
> :                     process_one_work+0x246/0x530
> :                     worker_thread+0x47/0x3e0
> :                     kthread+0xd2/0x100
> :                     ret_from_fork+0x19/0x24
> :    SOFTIRQ-ON-W at:
> :                     lock_acquire+0xb2/0x2b0
> :                     _raw_spin_lock+0x28/0x70
> :                     adjust_total_allocated+0x95/0x120 [dm_bufio]
> :                     __link_buffer+0xb2/0xf0 [dm_bufio]
> :                     __bufio_new+0x20b/0x2b0 [dm_bufio]
> :                     dm_bufio_prefetch+0x90/0x1f0 [dm_bufio]
> :                     verity_prefetch_io+0x142/0x180 [dm_verity]
> :                     process_one_work+0x246/0x530
> :                     worker_thread+0x47/0x3e0
> :                     kthread+0xd2/0x100
> :                     ret_from_fork+0x19/0x24
> :    INITIAL USE at:
> :                    lock_acquire+0xb2/0x2b0
> :                    _raw_spin_lock+0x28/0x70
> :                    adjust_total_allocated+0x95/0x120 [dm_bufio]
> :                    __link_buffer+0xb2/0xf0 [dm_bufio]
> :                    __bufio_new+0x20b/0x2b0 [dm_bufio]
> :                    dm_bufio_prefetch+0x90/0x1f0 [dm_bufio]
> :                    verity_prefetch_io+0x142/0x180 [dm_verity]
> :                    process_one_work+0x246/0x530
> :                    worker_thread+0x47/0x3e0
> :                    kthread+0xd2/0x100
> :                    ret_from_fork+0x19/0x24
> :  }
> :  ... key      at: [<f7a38090>] global_spinlock+0x10/0xffffef80 [dm_bufio]
> :  ... acquired at:
> :    lock_acquire+0xb2/0x2b0
> :    _raw_spin_lock+0x28/0x70
> :    adjust_total_allocated+0x95/0x120 [dm_bufio]
> :    __link_buffer+0xb2/0xf0 [dm_bufio]
> :    __bufio_new+0x20b/0x2b0 [dm_bufio]
> :    dm_bufio_prefetch+0x90/0x1f0 [dm_bufio]
> :    verity_prefetch_io+0x3c/0x180 [dm_verity]
> :    process_one_work+0x246/0x530
> :    worker_thread+0x47/0x3e0
> :    kthread+0xd2/0x100
> :    ret_from_fork+0x19/0x24
> :
> : \x0astack backtrace:
> : CPU: 1 PID: 2488 Comm: kworker/u16:6 Not tainted 5.19.0-rc8+ #767
> : Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
> : Workqueue: kverityd verity_prefetch_io [dm_verity]
> : Call Trace:
> :  dump_stack_lvl+0x68/0x98
> :  dump_stack+0xd/0x10
> :  print_bad_irq_dependency.cold+0x1f2/0x1f8
> :  __lock_acquire+0x2522/0x2840
> :  ? __this_cpu_preempt_check+0xf/0x11
> :  lock_acquire+0xb2/0x2b0
> :  ? adjust_total_allocated+0x95/0x120 [dm_bufio]
> :  ? __this_cpu_preempt_check+0xf/0x11
> :  _raw_spin_lock+0x28/0x70
> :  ? adjust_total_allocated+0x95/0x120 [dm_bufio]
> :  adjust_total_allocated+0x95/0x120 [dm_bufio]
> :  __link_buffer+0xb2/0xf0 [dm_bufio]
> :  ? alloc_buffer+0xc3/0x100 [dm_bufio]
> :  __bufio_new+0x20b/0x2b0 [dm_bufio]
> :  dm_bufio_prefetch+0x90/0x1f0 [dm_bufio]
> :  verity_prefetch_io+0x3c/0x180 [dm_verity]
> :  process_one_work+0x246/0x530
> :  ? 0xc1000000
> :  worker_thread+0x47/0x3e0
> :  kthread+0xd2/0x100
> :  ? process_one_work+0x530/0x530
> :  ? kthread_complete_and_exit+0x20/0x20
> :  ret_from_fork+0x19/0x24
> 
> 
> m.
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


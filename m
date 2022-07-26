Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32A29C00144
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jul 2022 21:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658871898;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=At5kj1XPDAN0TMfOzf2zWBBuhfx4sa901UvFKoTGl0U=;
	b=SI6ULXCdfhSE0kvwIarzSpf/sK02ss0RVZqoxPb4AFHg+53yTw4BUz7IMhQRYHo8D3xsmr
	bTXEV0L+x89I120lwGKEDRV4fcbIc6qf4a0RXhODArl2VYDdEQPXoVXpjkXkOZiknXjL0U
	oMpxmmWTeayHpHgII07lTT+EDcjDyIg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-g8LpICT4OACJcF8bmjr7IA-1; Tue, 26 Jul 2022 17:44:55 -0400
X-MC-Unique: g8LpICT4OACJcF8bmjr7IA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E6621C0BDF4;
	Tue, 26 Jul 2022 21:44:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5CDD2492CA2;
	Tue, 26 Jul 2022 21:44:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EBF431945D8A;
	Tue, 26 Jul 2022 21:44:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 201941945D86
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Jul 2022 21:44:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0FC181121319; Tue, 26 Jul 2022 21:44:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BE451121314
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 21:44:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E10D33C10227
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 21:44:49 +0000 (UTC)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com
 [209.85.208.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-336-26Yo9taRPk2X4Fr1ISpqyw-1; Tue, 26 Jul 2022 17:44:48 -0400
X-MC-Unique: 26Yo9taRPk2X4Fr1ISpqyw-1
Received: by mail-ed1-f41.google.com with SMTP id c12so11834442ede.3
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 14:44:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=y0SfT3NLIh2u6M9l7ic0baYpAxaNgCVe18Z+xznVahw=;
 b=K3e+HXla2+Cf0WlFQwoN9Ggr34kpe8yzXmrKl5evgZStwwsmDNuctv3W+wWzH7YZ5R
 a65GhJBdqmGHik1F8r4hZqBiKhSNOCpvznojje+P/LTrym5IRs9evDjt9zHv6LTcRVQP
 B9jbKeTwOeZeT0E+87AFAB1lgMYdTQtYqEdI4tiux3vKcFDb2Y8J4SitTdy+8MpjR1Mp
 XgGo/P8uf0AAMvneuSUZeSoPjuyvorDVfb9U3nNnxHe4tIJNm1pVMIJd/SocqtjwWaU6
 U6TXDzEnedky+RBtkqvpTHxD0qTz3HKoKHF3tapS2STTxfpZ648fOg4SctIcdxPgj01/
 rEyg==
X-Gm-Message-State: AJIora8GrPmBDl6WbcN0nxpovEbACFaXkNPbrP2asePZwwB+T6dqHvE0
 dxkNuN/hwKcJQ1DOSBXhrkKGpbLhcrg=
X-Google-Smtp-Source: AGRyM1uPnTEAce3q4wUmtkhYCYEVOlUA047FG1NCkm1tiRUMydbaljHTpp5mhzIvf8frd68yU5KB6A==
X-Received: by 2002:a05:6402:3046:b0:43c:684e:635d with SMTP id
 bs6-20020a056402304600b0043c684e635dmr4389327edb.353.1658871886705; 
 Tue, 26 Jul 2022 14:44:46 -0700 (PDT)
Received: from [192.168.2.27] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
 by smtp.gmail.com with ESMTPSA id
 n15-20020a05640206cf00b0043be9b2f7d2sm4563974edy.38.2022.07.26.14.44.45
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 26 Jul 2022 14:44:46 -0700 (PDT)
Message-ID: <6a158b48-10d3-6427-bc44-e7f78513380b@gmail.com>
Date: Tue, 26 Jul 2022 23:44:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: Mike Snitzer <snitzer@kernel.org>
References: <20220726160959.89247-1-snitzer@kernel.org>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <20220726160959.89247-1-snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
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
 Sami Tolvanen <samitolvanen@google.com>, Nathan Huckleberry <nhuck@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 26/07/2022 18:09, Mike Snitzer wrote:
> Hi,
> 
> Please see this updated patchset that reflects what I've staged for
> the 5.20 merge window, see:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.20
> 
> My only outstanding question, from previous v1 patchset, is: should
> the verify_wq be created using WQ_HIGHPRI instead of WQ_CPU_INTENSIVE?
> (I doubt it has a significant impact on performance but if you have
> insight on why you made that change, and if it meaningful, I'd happily
> apply the change).
> 
> I've tested using cryptsetup's testsuite (which has dm-verity tests)
> but I haven't tested the "try_verify_in_tasklet" feature.

Hi Mike,

I added new veritysetup option --use-tasklets for testing to a new branch
https://gitlab.com/cryptsetup/cryptsetup/-/commits/verify-tasklet

I tried to run verity-compat-test (on that branch above), not used the flag yet,
just in one simple option flag test (see the branch).

But with your patches (on top of 5.19.0-rc8) and my testing 32bit VM:

- FEC tests are skipped even if FEC is enabled in kernel.
I think the whole FEC is broken with your patches.
(Beware, test will skip FEC quietly! Usually CONFIG_DM_VERITY_FEC is disabled,
so we have to ignore it.)

- Also I see this warning (in that simple option test I added).

: =====================================================
: WARNING: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected
: 5.19.0-rc8+ #767 Not tainted
: -----------------------------------------------------
: kworker/u16:6/2488 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
: f7a38090 (global_spinlock){+.+.}-{2:2}, at: adjust_total_allocated+0x95/0x120 [dm_bufio]
: \x0aand this task is already holding:
: c555086c (&c->spinlock){..-.}-{2:2}, at: dm_bufio_lock+0x54/0x60 [dm_bufio]
: which would create a new lock dependency:
:  (&c->spinlock){..-.}-{2:2} -> (global_spinlock){+.+.}-{2:2}
: \x0abut this new dependency connects a SOFTIRQ-irq-safe lock:
:  (&c->spinlock){..-.}-{2:2}
: \x0a... which became SOFTIRQ-irq-safe at:
:   lock_acquire+0xb2/0x2b0
:   _raw_spin_lock_irqsave_nested+0x3b/0x90
:   dm_bufio_lock+0x54/0x60 [dm_bufio]
:   new_read+0x32/0x120 [dm_bufio]
:   dm_bufio_get+0xd/0x10 [dm_bufio]
:   verity_verify_level+0x199/0x220 [dm_verity]
:   verity_hash_for_block+0x26/0xf0 [dm_verity]
:   verity_verify_io+0x134/0x490 [dm_verity]
:   verity_tasklet+0xf/0x7f [dm_verity]
:   tasklet_action_common.constprop.0+0xd0/0xf0
:   tasklet_action+0x21/0x30
:   __do_softirq+0xb4/0x4c5
:   run_ksoftirqd+0x35/0x50
:   smpboot_thread_fn+0x174/0x230
:   kthread+0xd2/0x100
:   ret_from_fork+0x19/0x24
: \x0ato a SOFTIRQ-irq-unsafe lock:
:  (global_spinlock){+.+.}-{2:2}
: \x0a... which became SOFTIRQ-irq-unsafe at:
: ...
:   lock_acquire+0xb2/0x2b0
:   _raw_spin_lock+0x28/0x70
:   adjust_total_allocated+0x95/0x120 [dm_bufio]
:   __link_buffer+0xb2/0xf0 [dm_bufio]
:   __bufio_new+0x20b/0x2b0 [dm_bufio]
:   dm_bufio_prefetch+0x90/0x1f0 [dm_bufio]
:   verity_prefetch_io+0x142/0x180 [dm_verity]
:   process_one_work+0x246/0x530
:   worker_thread+0x47/0x3e0
:   kthread+0xd2/0x100
:   ret_from_fork+0x19/0x24
: \x0aother info that might help us debug this:\x0a
:  Possible interrupt unsafe locking scenario:\x0a
:        CPU0                    CPU1
:        ----                    ----
:   lock(global_spinlock);
:                                local_irq_disable();
:                                lock(&c->spinlock);
:                                lock(global_spinlock);
:   <Interrupt>
:     lock(&c->spinlock);
: \x0a *** DEADLOCK ***\x0a
: 3 locks held by kworker/u16:6/2488:
:  #0: c55494b8 ((wq_completion)kverityd){+.+.}-{0:0}, at: process_one_work+0x1d0/0x530
:  #1: c6c49f38 ((work_completion)(&pw->work)){+.+.}-{0:0}, at: process_one_work+0x1d0/0x530
:  #2: c555086c (&c->spinlock){..-.}-{2:2}, at: dm_bufio_lock+0x54/0x60 [dm_bufio]
: \x0athe dependencies between SOFTIRQ-irq-safe lock and the holding lock:
: -> (&c->spinlock){..-.}-{2:2} ops: 2 {
:    IN-SOFTIRQ-W at:
:                     lock_acquire+0xb2/0x2b0
:                     _raw_spin_lock_irqsave_nested+0x3b/0x90
:                     dm_bufio_lock+0x54/0x60 [dm_bufio]
:                     new_read+0x32/0x120 [dm_bufio]
:                     dm_bufio_get+0xd/0x10 [dm_bufio]
:                     verity_verify_level+0x199/0x220 [dm_verity]
:                     verity_hash_for_block+0x26/0xf0 [dm_verity]
:                     verity_verify_io+0x134/0x490 [dm_verity]
:                     verity_tasklet+0xf/0x7f [dm_verity]
:                     tasklet_action_common.constprop.0+0xd0/0xf0
:                     tasklet_action+0x21/0x30
:                     __do_softirq+0xb4/0x4c5
:                     run_ksoftirqd+0x35/0x50
:                     smpboot_thread_fn+0x174/0x230
:                     kthread+0xd2/0x100
:                     ret_from_fork+0x19/0x24
:    INITIAL USE at:
:                    lock_acquire+0xb2/0x2b0
:                    _raw_spin_lock_irqsave_nested+0x3b/0x90
:                    dm_bufio_lock+0x54/0x60 [dm_bufio]
:                    dm_bufio_prefetch+0x4b/0x1f0 [dm_bufio]
:                    verity_prefetch_io+0x3c/0x180 [dm_verity]
:                    process_one_work+0x246/0x530
:                    worker_thread+0x47/0x3e0
:                    kthread+0xd2/0x100
:                    ret_from_fork+0x19/0x24
:  }
:  ... key      at: [<f7a384e8>] __key.24+0x0/0xffffeb18 [dm_bufio]
: \x0athe dependencies between the lock to be acquired
:  and SOFTIRQ-irq-unsafe lock:
: -> (global_spinlock){+.+.}-{2:2} ops: 129329 {
:    HARDIRQ-ON-W at:
:                     lock_acquire+0xb2/0x2b0
:                     _raw_spin_lock+0x28/0x70
:                     adjust_total_allocated+0x95/0x120 [dm_bufio]
:                     __link_buffer+0xb2/0xf0 [dm_bufio]
:                     __bufio_new+0x20b/0x2b0 [dm_bufio]
:                     dm_bufio_prefetch+0x90/0x1f0 [dm_bufio]
:                     verity_prefetch_io+0x142/0x180 [dm_verity]
:                     process_one_work+0x246/0x530
:                     worker_thread+0x47/0x3e0
:                     kthread+0xd2/0x100
:                     ret_from_fork+0x19/0x24
:    SOFTIRQ-ON-W at:
:                     lock_acquire+0xb2/0x2b0
:                     _raw_spin_lock+0x28/0x70
:                     adjust_total_allocated+0x95/0x120 [dm_bufio]
:                     __link_buffer+0xb2/0xf0 [dm_bufio]
:                     __bufio_new+0x20b/0x2b0 [dm_bufio]
:                     dm_bufio_prefetch+0x90/0x1f0 [dm_bufio]
:                     verity_prefetch_io+0x142/0x180 [dm_verity]
:                     process_one_work+0x246/0x530
:                     worker_thread+0x47/0x3e0
:                     kthread+0xd2/0x100
:                     ret_from_fork+0x19/0x24
:    INITIAL USE at:
:                    lock_acquire+0xb2/0x2b0
:                    _raw_spin_lock+0x28/0x70
:                    adjust_total_allocated+0x95/0x120 [dm_bufio]
:                    __link_buffer+0xb2/0xf0 [dm_bufio]
:                    __bufio_new+0x20b/0x2b0 [dm_bufio]
:                    dm_bufio_prefetch+0x90/0x1f0 [dm_bufio]
:                    verity_prefetch_io+0x142/0x180 [dm_verity]
:                    process_one_work+0x246/0x530
:                    worker_thread+0x47/0x3e0
:                    kthread+0xd2/0x100
:                    ret_from_fork+0x19/0x24
:  }
:  ... key      at: [<f7a38090>] global_spinlock+0x10/0xffffef80 [dm_bufio]
:  ... acquired at:
:    lock_acquire+0xb2/0x2b0
:    _raw_spin_lock+0x28/0x70
:    adjust_total_allocated+0x95/0x120 [dm_bufio]
:    __link_buffer+0xb2/0xf0 [dm_bufio]
:    __bufio_new+0x20b/0x2b0 [dm_bufio]
:    dm_bufio_prefetch+0x90/0x1f0 [dm_bufio]
:    verity_prefetch_io+0x3c/0x180 [dm_verity]
:    process_one_work+0x246/0x530
:    worker_thread+0x47/0x3e0
:    kthread+0xd2/0x100
:    ret_from_fork+0x19/0x24
:
: \x0astack backtrace:
: CPU: 1 PID: 2488 Comm: kworker/u16:6 Not tainted 5.19.0-rc8+ #767
: Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
: Workqueue: kverityd verity_prefetch_io [dm_verity]
: Call Trace:
:  dump_stack_lvl+0x68/0x98
:  dump_stack+0xd/0x10
:  print_bad_irq_dependency.cold+0x1f2/0x1f8
:  __lock_acquire+0x2522/0x2840
:  ? __this_cpu_preempt_check+0xf/0x11
:  lock_acquire+0xb2/0x2b0
:  ? adjust_total_allocated+0x95/0x120 [dm_bufio]
:  ? __this_cpu_preempt_check+0xf/0x11
:  _raw_spin_lock+0x28/0x70
:  ? adjust_total_allocated+0x95/0x120 [dm_bufio]
:  adjust_total_allocated+0x95/0x120 [dm_bufio]
:  __link_buffer+0xb2/0xf0 [dm_bufio]
:  ? alloc_buffer+0xc3/0x100 [dm_bufio]
:  __bufio_new+0x20b/0x2b0 [dm_bufio]
:  dm_bufio_prefetch+0x90/0x1f0 [dm_bufio]
:  verity_prefetch_io+0x3c/0x180 [dm_verity]
:  process_one_work+0x246/0x530
:  ? 0xc1000000
:  worker_thread+0x47/0x3e0
:  kthread+0xd2/0x100
:  ? process_one_work+0x530/0x530
:  ? kthread_complete_and_exit+0x20/0x20
:  ret_from_fork+0x19/0x24


m.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


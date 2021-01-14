Return-Path: <SRS0=Ey+N=GS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B512C433DB
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jan 2021 08:29:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6137D22597
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jan 2021 08:29:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6137D22597
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-QXsroDr2Na2WpiE0VCnb-g-1; Fri, 15 Jan 2021 03:29:05 -0500
X-MC-Unique: QXsroDr2Na2WpiE0VCnb-g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B4C81009464;
	Fri, 15 Jan 2021 08:29:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A8105D739;
	Fri, 15 Jan 2021 08:29:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8363D1809C9F;
	Fri, 15 Jan 2021 08:28:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10EFigJd003601 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 14 Jan 2021 10:44:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 98D3DDEE6A; Thu, 14 Jan 2021 15:44:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 93BF4DEE7C
	for <dm-devel@redhat.com>; Thu, 14 Jan 2021 15:44:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DEBC80120A
	for <dm-devel@redhat.com>; Thu, 14 Jan 2021 15:44:40 +0000 (UTC)
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-99-Y-IoeGr6NiqNXammmVEt4Q-1; Thu, 14 Jan 2021 10:44:35 -0500
X-MC-Unique: Y-IoeGr6NiqNXammmVEt4Q-1
Received: from MUA by vps-vb.mhejs.net with esmtps
	(TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128) (Exim 4.93.0.4)
	(envelope-from <mail@maciej.szmigiero.name>)
	id 1l04nP-0000Eb-9U; Thu, 14 Jan 2021 16:44:23 +0100
To: Ignat Korchagin <ignat@cloudflare.com>
References: <20210113191717.1439-1-ignat@cloudflare.com>
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Message-ID: <2a187957-a6c6-4550-8ad7-570571f75a26@maciej.szmigiero.name>
Date: Thu, 14 Jan 2021 16:44:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210113191717.1439-1-ignat@cloudflare.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 15 Jan 2021 03:28:57 -0500
Cc: snitzer@redhat.com, kernel-team@cloudflare.com, dm-crypt@saout.de,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	dm-devel@redhat.com, linux-crypto <linux-crypto@vger.kernel.org>,
	agk@redhat.com
Subject: Re: [dm-devel] [dm-crypt] [PATCH] dm crypt: defer the decryption to
 a tasklet, when being called with interrupts disabled
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Ignat,

On 13.01.2021 20:17, Ignat Korchagin wrote:
> On some specific hardware on early boot we occasionally get
> 
> [ 1193.920255][    T0] BUG: sleeping function called from invalid context at mm/mempool.c:381
> [ 1193.936616][    T0] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 0, name: swapper/69
> [ 1193.953233][    T0] no locks held by swapper/69/0.
> [ 1193.965871][    T0] irq event stamp: 575062
> [ 1193.977724][    T0] hardirqs last  enabled at (575061): [<ffffffffab73f662>] tick_nohz_idle_exit+0xe2/0x3e0
> [ 1194.002762][    T0] hardirqs last disabled at (575062): [<ffffffffab74e8af>] flush_smp_call_function_from_idle+0x4f/0x80
> [ 1194.029035][    T0] softirqs last  enabled at (575050): [<ffffffffad600fd2>] asm_call_irq_on_stack+0x12/0x20
> [ 1194.054227][    T0] softirqs last disabled at (575043): [<ffffffffad600fd2>] asm_call_irq_on_stack+0x12/0x20
> [ 1194.079389][    T0] CPU: 69 PID: 0 Comm: swapper/69 Not tainted 5.10.6-cloudflare-kasan-2021.1.4-dev #1
> [ 1194.104103][    T0] Hardware name: NULL R162-Z12-CD/MZ12-HD4-CD, BIOS R10 06/04/2020
> [ 1194.119591][    T0] Call Trace:
> [ 1194.130233][    T0]  dump_stack+0x9a/0xcc
> [ 1194.141617][    T0]  ___might_sleep.cold+0x180/0x1b0
> [ 1194.153825][    T0]  mempool_alloc+0x16b/0x300
> [ 1194.165313][    T0]  ? remove_element+0x160/0x160
> [ 1194.176961][    T0]  ? blk_mq_end_request+0x4b/0x490
> [ 1194.188778][    T0]  crypt_convert+0x27f6/0x45f0 [dm_crypt]
> [ 1194.201024][    T0]  ? rcu_read_lock_sched_held+0x3f/0x70
> [ 1194.212906][    T0]  ? module_assert_mutex_or_preempt+0x3e/0x70
> [ 1194.225318][    T0]  ? __module_address.part.0+0x1b/0x3a0
> [ 1194.237212][    T0]  ? is_kernel_percpu_address+0x5b/0x190
> [ 1194.249238][    T0]  ? crypt_iv_tcw_ctr+0x4a0/0x4a0 [dm_crypt]
> [ 1194.261593][    T0]  ? is_module_address+0x25/0x40
> [ 1194.272905][    T0]  ? static_obj+0x8a/0xc0
> [ 1194.283582][    T0]  ? lockdep_init_map_waits+0x26a/0x700
> [ 1194.295570][    T0]  ? __raw_spin_lock_init+0x39/0x110
> [ 1194.307330][    T0]  kcryptd_crypt_read_convert+0x31c/0x560 [dm_crypt]
> [ 1194.320496][    T0]  ? kcryptd_queue_crypt+0x1be/0x380 [dm_crypt]
> [ 1194.333203][    T0]  blk_update_request+0x6d7/0x1500
> [ 1194.344841][    T0]  ? blk_mq_trigger_softirq+0x190/0x190
> [ 1194.356831][    T0]  blk_mq_end_request+0x4b/0x490
> [ 1194.367994][    T0]  ? blk_mq_trigger_softirq+0x190/0x190
> [ 1194.379693][    T0]  flush_smp_call_function_queue+0x24b/0x560
> [ 1194.391847][    T0]  flush_smp_call_function_from_idle+0x59/0x80
> [ 1194.403969][    T0]  do_idle+0x287/0x450
> [ 1194.413891][    T0]  ? arch_cpu_idle_exit+0x40/0x40
> [ 1194.424716][    T0]  ? lockdep_hardirqs_on_prepare+0x286/0x3f0
> [ 1194.436399][    T0]  ? _raw_spin_unlock_irqrestore+0x39/0x40
> [ 1194.447759][    T0]  cpu_startup_entry+0x19/0x20
> [ 1194.458038][    T0]  secondary_startup_64_no_verify+0xb0/0xbb
> 
> IO completion can be queued to a different CPU by the block subsystem as a "call
> single function/data". The CPU may run these routines from the idle task, but it
> does so with interrupts disabled.
> 
> It is not a good idea to do decryption with irqs disabled even in an idle task
> context, so just defer it to a tasklet as with requests from hard irqs.
> 
> Fixes: 39d42fa96ba1 ("dm crypt: add flags to optionally bypass kcryptd workqueues")
> Cc: <stable@vger.kernel.org> # v5.9+
> Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>

Thanks for working on this.

Looking at all these patches submitted in the last few weeks it seems
to me that there are some non-trivial implicit assumptions in dm-crypt
which are invalidated when bypassing its workqueues.

It might be difficult to find the more subtle of them by trial and error,
especial these which don't cause crashes but silent data corruption
instead.

I wonder if somebody with block and Crypto API knowledge could chime in
here to statically review the code - I've added linux-crypto and
linux-block to the CC list.

By the way, I would appreciate if you could CC on dm-crypt "no workqueue"
patches since I am interested in this functionality.

Thanks,
Maciej

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


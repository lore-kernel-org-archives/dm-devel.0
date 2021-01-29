Return-Path: <SRS0=tECb=HA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FAD9C433E0
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 09:39:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BFE4D64DFD
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 09:39:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFE4D64DFD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-Eu1DVEQtN2ay9vCBK_uJ1Q-1; Fri, 29 Jan 2021 04:39:27 -0500
X-MC-Unique: Eu1DVEQtN2ay9vCBK_uJ1Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63D229CC03;
	Fri, 29 Jan 2021 09:39:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 446B65D740;
	Fri, 29 Jan 2021 09:39:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 140861809CA1;
	Fri, 29 Jan 2021 09:39:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10T3ZRvF026401 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 22:35:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B42E911701F8; Fri, 29 Jan 2021 03:35:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B041A11701CB
	for <dm-devel@redhat.com>; Fri, 29 Jan 2021 03:35:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FAB2101A560
	for <dm-devel@redhat.com>; Fri, 29 Jan 2021 03:35:25 +0000 (UTC)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com
	[209.85.167.52]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-430-w3csvG1GP8qJvFj3vrr5gQ-1; Thu, 28 Jan 2021 22:35:20 -0500
X-MC-Unique: w3csvG1GP8qJvFj3vrr5gQ-1
Received: by mail-lf1-f52.google.com with SMTP id h12so10531093lfp.9
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 19:35:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
	bh=E+fyB3jemzqc2Klqmp10DJel7sV4sj7Wt+Uyo3A1uHg=;
	b=gnltnPU2n+133uQMxRntc0ifW2x84jl4piFH4qDh7IRT2kfYTthO1Uq4xI0CJlDyNA
	LVUCwCgFvbvZETTR2Q2Lr5nqCMJaogNCddZknxa3ScFQ40ciJneqUFpltuCRDPfmviAU
	E/iLbotSK18hpAw848IV7o4emddLMvhZt1Cwrd2IshGZBqmawbd8QmC/JE/ZuXFlWxtm
	f/yJ3QAOoL0YTuhf2QsY3lrJjmdeKpShRUbXVQ66ywB8UAWNZDbkzEGQl019BgZ/+bTJ
	kZIHjfrSTAmesuildHBbq/x7xy962901B60UjeaWPlG6U6LXw9KnTYnhlJMeZT0o9PrD
	sMyA==
X-Gm-Message-State: AOAM532j+b0sBdOdhIX8Bzs4S+NW3+n1kcxq3L/UTe00ehDjhSe3OPpF
	PvShKGAAGY4BS0lhAlZpw2jx5wXmMwMTzSMWnA4+Yw==
X-Google-Smtp-Source: ABdhPJyCDscoWvIP9e9KvcUAOFxv6g+AqDZQFwny0M3pCSZmzT+OC3RYBsefAd4yTA4xQvTd7wCQErZ1aq6qXjw8OyY=
X-Received: by 2002:a05:6512:2251:: with SMTP id
	i17mr1018389lfu.566.1611891318779; 
	Thu, 28 Jan 2021 19:35:18 -0800 (PST)
MIME-Version: 1.0
From: Ivan Babrou <ivan@cloudflare.com>
Date: Thu, 28 Jan 2021 19:35:07 -0800
Message-ID: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
To: kernel-team <kernel-team@cloudflare.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 29 Jan 2021 04:33:26 -0500
Cc: Mike Snitzer <snitzer@redhat.com>,
	"Peter Zijlstra \(Intel\)" <peterz@infradead.org>,
	Ignat Korchagin <ignat@cloudflare.com>, linux-mm@kvack.org,
	dm-devel@redhat.com, Alexander Potapenko <glider@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Miroslav Benes <mbenes@suse.cz>,
	Jiri Slaby <jirislaby@kernel.org>, Alasdair Kergon <agk@redhat.com>,
	Hailong liu <liu.hailong6@zte.com.cn>, x86@kernel.org,
	kasan-dev@googlegroups.com, Ingo Molnar <mingo@redhat.com>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>, Borislav Petkov <bp@alien8.de>,
	Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
	Dmitry Vyukov <dvyukov@google.com>, Julien Thierry <jthierry@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [dm-devel] BUG: KASAN: stack-out-of-bounds in
	unwind_next_frame+0x1df5/0x2650
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello,

We've noticed the following regression in Linux 5.10 branch:

[  128.367231][    C0]
==================================================================
[  128.368523][    C0] BUG: KASAN: stack-out-of-bounds in
unwind_next_frame (arch/x86/kernel/unwind_orc.c:371
arch/x86/kernel/unwind_orc.c:544)
[  128.369744][    C0] Read of size 8 at addr ffff88802fceede0 by task
kworker/u2:2/591
[  128.370916][    C0]
[  128.371269][    C0] CPU: 0 PID: 591 Comm: kworker/u2:2 Not tainted
5.10.11-cloudflare-kasan-2021.1.15 #1
[  128.372626][    C0] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[  128.374346][    C0] Workqueue: writeback wb_workfn (flush-254:0)
[  128.375275][    C0] Call Trace:
[  128.375763][    C0]  <IRQ>
[  128.376221][    C0]  dump_stack+0x7d/0xa3
[  128.376843][    C0]  print_address_description.constprop.0+0x1c/0x210
[  128.377827][    C0]  ? _raw_spin_lock_irqsave
(arch/x86/include/asm/atomic.h:202
include/asm-generic/atomic-instrumented.h:707
include/asm-generic/qspinlock.h:82 include/linux/spinlock.h:195
include/linux/spinlock_api_smp.h:119 kernel/locking/spinlock.c:159)
[  128.378624][    C0]  ? _raw_write_unlock_bh (kernel/locking/spinlock.c:158)
[  128.379389][    C0]  ? unwind_next_frame (arch/x86/kernel/unwind_orc.c:444)
[  128.380177][    C0]  ? unwind_next_frame
(arch/x86/kernel/unwind_orc.c:371 arch/x86/kernel/unwind_orc.c:544)
[  128.380954][    C0]  ? unwind_next_frame
(arch/x86/kernel/unwind_orc.c:371 arch/x86/kernel/unwind_orc.c:544)
[  128.381736][    C0]  kasan_report.cold+0x1f/0x37
[  128.382438][    C0]  ? unwind_next_frame
(arch/x86/kernel/unwind_orc.c:371 arch/x86/kernel/unwind_orc.c:544)
[  128.383192][    C0]  unwind_next_frame+0x1df5/0x2650
[  128.383954][    C0]  ? asm_common_interrupt
(arch/x86/include/asm/idtentry.h:622)
[  128.384726][    C0]  ? get_stack_info_noinstr
(arch/x86/kernel/dumpstack_64.c:157)
[  128.385530][    C0]  ? glue_xts_req_128bit+0x110/0x6f0 glue_helper
[  128.386509][    C0]  ? deref_stack_reg (arch/x86/kernel/unwind_orc.c:418)
[  128.387267][    C0]  ? is_module_text_address (kernel/module.c:4566
kernel/module.c:4550)
[  128.388077][    C0]  ? glue_xts_req_128bit+0x110/0x6f0 glue_helper
[  128.389048][    C0]  ? kernel_text_address.part.0 (kernel/extable.c:145)
[  128.389901][    C0]  ? glue_xts_req_128bit+0x110/0x6f0 glue_helper
[  128.390865][    C0]  ? stack_trace_save (kernel/stacktrace.c:82)
[  128.391550][    C0]  arch_stack_walk+0x8d/0xf0
[  128.392216][    C0]  ? kfree (mm/slub.c:3142 mm/slub.c:4124)
[  128.392807][    C0]  stack_trace_save+0x96/0xd0
[  128.393535][    C0]  ? create_prof_cpu_mask (kernel/stacktrace.c:113)
[  128.394320][    C0]  ? blk_update_request (block/blk-core.c:264
block/blk-core.c:1468)
[  128.395113][    C0]  ? asm_call_irq_on_stack (arch/x86/entry/entry_64.S:796)
[  128.395887][    C0]  ? do_softirq_own_stack
(arch/x86/include/asm/irq_stack.h:27
arch/x86/include/asm/irq_stack.h:77 arch/x86/kernel/irq_64.c:77)
[  128.396678][    C0]  ? irq_exit_rcu (kernel/softirq.c:393
kernel/softirq.c:423 kernel/softirq.c:435)
[  128.397349][    C0]  ? common_interrupt (arch/x86/kernel/irq.c:239)
[  128.398086][    C0]  ? asm_common_interrupt
(arch/x86/include/asm/idtentry.h:622)
[  128.398886][    C0]  ? get_page_from_freelist (mm/page_alloc.c:3480
mm/page_alloc.c:3904)
[  128.399759][    C0]  kasan_save_stack+0x20/0x50
[  128.400453][    C0]  ? kasan_save_stack (mm/kasan/common.c:48)
[  128.401175][    C0]  ? kasan_set_track (mm/kasan/common.c:56)
[  128.401881][    C0]  ? kasan_set_free_info (mm/kasan/generic.c:360)
[  128.402646][    C0]  ? __kasan_slab_free (mm/kasan/common.c:283
mm/kasan/common.c:424)
[  128.403375][    C0]  ? slab_free_freelist_hook (mm/slub.c:1577)
[  128.404199][    C0]  ? kfree (mm/slub.c:3142 mm/slub.c:4124)
[  128.404835][    C0]  ? nvme_pci_complete_rq+0x105/0x350 nvme
[  128.405765][    C0]  ? blk_done_softirq (include/linux/list.h:282
block/blk-mq.c:581)
[  128.406552][    C0]  ? __do_softirq
(arch/x86/include/asm/jump_label.h:25 include/linux/jump_label.h:200
include/trace/events/irq.h:142 kernel/softirq.c:299)
[  128.407272][    C0]  ? asm_call_irq_on_stack (arch/x86/entry/entry_64.S:796)
[  128.408087][    C0]  ? do_softirq_own_stack
(arch/x86/include/asm/irq_stack.h:27
arch/x86/include/asm/irq_stack.h:77 arch/x86/kernel/irq_64.c:77)
[  128.408878][    C0]  ? irq_exit_rcu (kernel/softirq.c:393
kernel/softirq.c:423 kernel/softirq.c:435)
[  128.409602][    C0]  ? common_interrupt (arch/x86/kernel/irq.c:239)
[  128.410366][    C0]  ? asm_common_interrupt
(arch/x86/include/asm/idtentry.h:622)
[  128.411184][    C0]  ? skcipher_walk_next (crypto/skcipher.c:322
crypto/skcipher.c:384)
[  128.412009][    C0]  ? skcipher_walk_virt (crypto/skcipher.c:487)
[  128.412811][    C0]  ? glue_xts_req_128bit+0x110/0x6f0 glue_helper
[  128.413792][    C0]  ? asm_common_interrupt
(arch/x86/include/asm/idtentry.h:622)
[  128.414562][    C0]  ? kcryptd_crypt_write_convert+0x3a2/0xa10 dm_crypt
[  128.415591][    C0]  ? crypt_map+0x5c1/0xc70 dm_crypt
[  128.416389][    C0]  ? __map_bio.isra.0+0x109/0x450 dm_mod
[  128.417275][    C0]  ? __split_and_process_non_flush+0x728/0xd10 dm_mod
[  128.418293][    C0]  ? dm_submit_bio+0x4f1/0xec0 dm_mod
[  128.419068][    C0]  ? submit_bio_noacct (block/blk-core.c:934
block/blk-core.c:982 block/blk-core.c:1061)
[  128.419806][    C0]  ? submit_bio (block/blk-core.c:1079)
[  128.420458][    C0]  ? _raw_spin_lock_irqsave
(arch/x86/include/asm/atomic.h:202
include/asm-generic/atomic-instrumented.h:707
include/asm-generic/qspinlock.h:82 include/linux/spinlock.h:195
include/linux/spinlock_api_smp.h:119 kernel/locking/spinlock.c:159)
[  128.421244][    C0]  ? _raw_write_unlock_bh (kernel/locking/spinlock.c:158)
[  128.422015][    C0]  ? ret_from_fork (arch/x86/entry/entry_64.S:302)
[  128.422696][    C0]  ? kmem_cache_free (mm/slub.c:3142 mm/slub.c:3158)
[  128.423427][    C0]  ? memset (mm/kasan/common.c:84)
[  128.424000][    C0]  ? dma_pool_free (mm/dmapool.c:405)
[  128.424698][    C0]  ? slab_free_freelist_hook (mm/slub.c:1577)
[  128.425518][    C0]  ? dma_pool_create (mm/dmapool.c:405)
[  128.426234][    C0]  ? kmem_cache_free (mm/slub.c:3142 mm/slub.c:3158)
[  128.426923][    C0]  ? raise_softirq_irqoff
(arch/x86/include/asm/preempt.h:26 kernel/softirq.c:469)
[  128.427691][    C0]  kasan_set_track+0x1c/0x30
[  128.428366][    C0]  kasan_set_free_info+0x1b/0x30
[  128.429113][    C0]  __kasan_slab_free+0x110/0x150
[  128.429838][    C0]  slab_free_freelist_hook+0x66/0x120
[  128.430628][    C0]  kfree+0xbf/0x4d0
[  128.431192][    C0]  ? nvme_pci_complete_rq+0x105/0x350 nvme
[  128.432107][    C0]  ? nvme_unmap_data+0x349/0x440 nvme
[  128.432882][    C0]  nvme_pci_complete_rq+0x105/0x350 nvme
[  128.433750][    C0]  blk_done_softirq+0x2ff/0x590
[  128.434441][    C0]  ? blk_mq_stop_hw_queue (block/blk-mq.c:573)
[  128.435161][    C0]  ? _raw_spin_lock_bh (kernel/locking/spinlock.c:150)
[  128.435894][    C0]  ? _raw_spin_lock_bh (kernel/locking/spinlock.c:150)
[  128.436582][    C0]  __do_softirq+0x1a0/0x667
[  128.437218][    C0]  asm_call_irq_on_stack+0x12/0x20
[  128.437975][    C0]  </IRQ>
[  128.438397][    C0]  do_softirq_own_stack+0x37/0x40
[  128.439120][    C0]  irq_exit_rcu+0x110/0x1b0
[  128.439807][    C0]  common_interrupt+0x74/0x120
[  128.440545][    C0]  asm_common_interrupt+0x1e/0x40
[  128.441287][    C0] RIP: 0010:skcipher_walk_next
(crypto/skcipher.c:322 crypto/skcipher.c:384)
[  128.442126][    C0] Code: 85 dd 10 00 00 49 8d 7c 24 08 49 89 14 24
48 b9 00 00 00 00 00 fc ff df 41 81 e5 ff 0f 00 00 48 89 fe 48 c1 ee
03 80 3c 0e 00 <0f> 85 80 10 00 00 48 89 c6 4d 89 6c 24 08 48 bc
All code
========
   0: 85 dd                test   %ebx,%ebp
   2: 10 00                adc    %al,(%rax)
   4: 00 49 8d              add    %cl,-0x73(%rcx)
   7: 7c 24                jl     0x2d
   9: 08 49 89              or     %cl,-0x77(%rcx)
   c: 14 24                adc    $0x24,%al
   e: 48 b9 00 00 00 00 00 movabs $0xdffffc0000000000,%rcx
  15: fc ff df
  18: 41 81 e5 ff 0f 00 00 and    $0xfff,%r13d
  1f: 48 89 fe              mov    %rdi,%rsi
  22: 48 c1 ee 03          shr    $0x3,%rsi
  26: 80 3c 0e 00          cmpb   $0x0,(%rsi,%rcx,1)
  2a:* 0f 85 80 10 00 00    jne    0x10b0 <-- trapping instruction
  30: 48 89 c6              mov    %rax,%rsi
  33: 4d 89 6c 24 08        mov    %r13,0x8(%r12)
  38: 48                    rex.W
  39: bc                    .byte 0xbc

Code starting with the faulting instruction
===========================================
   0: 0f 85 80 10 00 00    jne    0x1086
   6: 48 89 c6              mov    %rax,%rsi
   9: 4d 89 6c 24 08        mov    %r13,0x8(%r12)
   e: 48                    rex.W
   f: bc                    .byte 0xbc
[  128.445089][    C0] RSP: 0018:ffff88802fceebf0 EFLAGS: 00000246
[  128.445969][    C0] RAX: ffff888003b571b8 RBX: 0000000000000000
RCX: dffffc0000000000
[  128.447124][    C0] RDX: ffffea00017cd580 RSI: 1ffff11005f9dda8
RDI: ffff88802fceed40
[  128.448281][    C0] RBP: ffff88802fceec70 R08: ffff88802fceedc4
R09: 00000000ffffffee
[  128.449457][    C0] R10: 0000000000000000 R11: 1ffff11005f9ddaf
R12: ffff88802fceed38
[  128.450641][    C0] R13: 0000000000000000 R14: ffff888003b57138
R15: ffff88802fceedc8
[  128.451827][    C0]  ? arch_stack_walk (arch/x86/kernel/stacktrace.c:24)
[  128.452482][    C0]  skcipher_walk_virt+0x4be/0x7e0
[  128.453242][    C0]  glue_xts_req_128bit+0x110/0x6f0 glue_helper
[  128.454175][    C0]  ? aesni_set_key+0x1e0/0x1e0 aesni_intel
[  128.455042][    C0]  ? irq_exit_rcu (kernel/softirq.c:406
kernel/softirq.c:425 kernel/softirq.c:435)
[  128.455719][    C0]  ? glue_xts_crypt_128bit_one+0x280/0x280 glue_helper
[  128.456753][    C0]  asm_common_interrupt+0x1e/0x40
[  128.457530][    C0] RIP: b8fa2500:0xdffffc0000000000
[  128.458305][    C0] Code: Unable to access opcode bytes at RIP
0xdffffbffffffffd6.

Code starting with the faulting instruction
===========================================
[  128.459443][    C0] RSP: 974be3f3:ffff88809c437290 EFLAGS: 00000004
ORIG_RAX: 0000001000000010
[  128.460755][    C0] RAX: 0000000000000000 RBX: ffff888003b571b8
RCX: 0000000000000000
[  128.461967][    C0] RDX: ffff888003b57240 RSI: ffff888003b57240
RDI: ffffffe000000010
[  128.463152][    C0] RBP: dffffc0000000200 R08: 0000000000000801
R09: ffffea0001123480
[  128.464345][    C0] R10: ffffed1000000200 R11: ffffffff00000000
R12: ffff888000000000
[  128.465522][    C0] R13: ffff888003b57138 R14: ffff88809c437290
R15: ffffea00002c5b08
[  128.466710][    C0]  ? get_page_from_freelist (mm/page_alloc.c:3913)
[  128.467560][    C0]  ? worker_thread (include/linux/list.h:282
kernel/workqueue.c:2419)
[  128.468279][    C0]  ? kthread (kernel/kthread.c:292)
[  128.468919][    C0]  ? ret_from_fork (arch/x86/entry/entry_64.S:302)
[  128.469607][    C0]  ? __writeback_inodes_wb (fs/fs-writeback.c:1793)
[  128.470418][    C0]  ? wb_writeback (fs/fs-writeback.c:1898)
[  128.471145][    C0]  ? process_one_work
(arch/x86/include/asm/jump_label.h:25 include/linux/jump_label.h:200
include/trace/events/workqueue.h:108 kernel/workqueue.c:2277)
[  128.471930][    C0]  ? worker_thread (include/linux/list.h:282
kernel/workqueue.c:2419)
[  128.472668][    C0]  ? ret_from_fork (arch/x86/entry/entry_64.S:302)
[  128.473329][    C0]  ? __zone_watermark_ok (mm/page_alloc.c:3793)
[  128.474065][    C0]  ? __kasan_kmalloc.constprop.0
(mm/kasan/common.c:56 mm/kasan/common.c:461)
[  128.474914][    C0]  ? crypt_convert+0x27e5/0x4530 dm_crypt
[  128.475796][    C0]  ? mempool_alloc (mm/mempool.c:392)
[  128.476493][    C0]  ? crypt_iv_tcw_ctr+0x4a0/0x4a0 dm_crypt
[  128.477433][    C0]  ? bio_add_page (block/bio.c:943)
[  128.478129][    C0]  ? __bio_try_merge_page (block/bio.c:935)
[  128.478923][    C0]  ? bio_associate_blkg (block/blk-cgroup.c:1869)
[  128.479693][    C0]  ? kcryptd_crypt_write_convert+0x581/0xa10 dm_crypt
[  128.480721][    C0]  ? crypt_map+0x5c1/0xc70 dm_crypt
[  128.481527][    C0]  ? bio_clone_blkg_association (block/blk-cgroup.c:1883)
[  128.482426][    C0]  ? __map_bio.isra.0+0x109/0x450 dm_mod
[  128.483310][    C0]  ? __split_and_process_non_flush+0x728/0xd10 dm_mod
[  128.484354][    C0]  ? __send_empty_flush+0x4b0/0x4b0 dm_mod
[  128.485223][    C0]  ? __part_start_io_acct (block/blk-core.c:1336)
[  128.486009][    C0]  ? dm_submit_bio+0x4f1/0xec0 dm_mod
[  128.486829][    C0]  ? __split_and_process_non_flush+0xd10/0xd10 dm_mod
[  128.487915][    C0]  ? submit_bio_noacct (block/blk-core.c:934
block/blk-core.c:982 block/blk-core.c:1061)
[  128.488686][    C0]  ? _cond_resched (kernel/sched/core.c:6124)
[  128.489388][    C0]  ? blk_queue_enter (block/blk-core.c:1044)
[  128.490300][    C0]  ? iomap_readahead (fs/iomap/buffered-io.c:1438)
[  128.491041][    C0]  ? write_one_page (mm/page-writeback.c:2171)
[  128.491759][    C0]  ? submit_bio (block/blk-core.c:1079)
[  128.492432][    C0]  ? submit_bio_noacct (block/blk-core.c:1079)
[  128.493248][    C0]  ? _raw_spin_lock
(arch/x86/include/asm/atomic.h:202
include/asm-generic/atomic-instrumented.h:707
include/asm-generic/qspinlock.h:82 include/linux/spinlock.h:183
include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[  128.493975][    C0]  ? iomap_submit_ioend (fs/iomap/buffered-io.c:1215)
[  128.494761][    C0]  ? xfs_vm_writepages (fs/xfs/xfs_aops.c:578)
[  128.495529][    C0]  ? xfs_dax_writepages (fs/xfs/xfs_aops.c:578)
[  128.496278][    C0]  ? __blk_mq_do_dispatch_sched
(block/blk-mq-sched.c:135 (discriminator 1))
[  128.497120][    C0]  ? do_writepages (mm/page-writeback.c:2355)
[  128.497831][    C0]  ? page_writeback_cpu_online (mm/page-writeback.c:2345)
[  128.498681][    C0]  ? _raw_spin_lock
(arch/x86/include/asm/atomic.h:202
include/asm-generic/atomic-instrumented.h:707
include/asm-generic/qspinlock.h:82 include/linux/spinlock.h:183
include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[  128.499405][    C0]  ? wake_up_bit (kernel/sched/wait_bit.c:15
kernel/sched/wait_bit.c:149)
[  128.500072][    C0]  ? __writeback_single_inode (fs/fs-writeback.c:1470)
[  128.500908][    C0]  ? writeback_sb_inodes (fs/fs-writeback.c:1725)
[  128.501703][    C0]  ? __writeback_single_inode (fs/fs-writeback.c:1634)
[  128.502571][    C0]  ? finish_writeback_work.constprop.0
(fs/fs-writeback.c:1242)
[  128.503525][    C0]  ? __writeback_inodes_wb (fs/fs-writeback.c:1793)
[  128.504336][    C0]  ? wb_writeback (fs/fs-writeback.c:1898)
[  128.505031][    C0]  ? __writeback_inodes_wb (fs/fs-writeback.c:1846)
[  128.505902][    C0]  ? cpumask_next (lib/cpumask.c:24)
[  128.506570][    C0]  ? get_nr_dirty_inodes (fs/inode.c:94 fs/inode.c:102)
[  128.507348][    C0]  ? wb_workfn (fs/fs-writeback.c:2054
fs/fs-writeback.c:2082)
[  128.508014][    C0]  ? dequeue_entity (kernel/sched/fair.c:4347)
[  128.508744][    C0]  ? inode_wait_for_writeback (fs/fs-writeback.c:2065)
[  128.509586][    C0]  ? put_prev_entity (kernel/sched/fair.c:4501)
[  128.510300][    C0]  ? __switch_to
(arch/x86/include/asm/bitops.h:55
include/asm-generic/bitops/instrumented-atomic.h:29
include/linux/thread_info.h:55 arch/x86/include/asm/fpu/internal.h:572
arch/x86/kernel/process_64.c:598)
[  128.510990][    C0]  ? __switch_to_asm (arch/x86/entry/entry_64.S:255)
[  128.511695][    C0]  ? __schedule (kernel/sched/core.c:3782
kernel/sched/core.c:4528)
[  128.512373][    C0]  ? process_one_work
(arch/x86/include/asm/jump_label.h:25 include/linux/jump_label.h:200
include/trace/events/workqueue.h:108 kernel/workqueue.c:2277)
[  128.513133][    C0]  ? worker_thread (include/linux/list.h:282
kernel/workqueue.c:2419)
[  128.513850][    C0]  ? rescuer_thread (kernel/workqueue.c:2361)
[  128.514566][    C0]  ? kthread (kernel/kthread.c:292)
[  128.515200][    C0]  ? __kthread_bind_mask (kernel/kthread.c:245)
[  128.515960][    C0]  ? ret_from_fork (arch/x86/entry/entry_64.S:302)
[  128.516641][    C0]
[  128.516983][    C0] The buggy address belongs to the page:
[  128.517838][    C0] page:000000007a390a2b refcount:0 mapcount:0
mapping:0000000000000000 index:0x0 pfn:0x2fcee
[  128.519428][    C0] flags: 0x1ffff800000000()
[  128.520102][    C0] raw: 001ffff800000000 ffffea0000bf3b88
ffffea0000bf3b88 0000000000000000
[  128.521396][    C0] raw: 0000000000000000 0000000000000000
00000000ffffffff 0000000000000000
[  128.522673][    C0] page dumped because: kasan: bad access detected
[  128.523642][    C0]
[  128.523984][    C0] addr ffff88802fceede0 is located in stack of
task kworker/u2:2/591 at offset 216 in frame:
[  128.525503][    C0]  glue_xts_req_128bit+0x0/0x6f0 glue_helper
[  128.526390][    C0]
[  128.526745][    C0] this frame has 5 objects:
[  128.527405][    C0]  [48, 200) 'walk'
[  128.527407][    C0]  [272, 304) 'b'
[  128.527969][    C0]  [336, 400) 's'
[  128.528509][    C0]  [432, 496) 'd'
[  128.529047][    C0]  [528, 608) 'subreq'
[  128.529607][    C0]
[  128.530568][    C0] Memory state around the buggy address:
[  128.531443][    C0]  ffff88802fceec80: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[  128.532708][    C0]  ffff88802fceed00: 00 f1 f1 f1 f1 f1 f1 00 00
00 00 00 00 00 00 00
[  128.533911][    C0] >ffff88802fceed80: 00 00 00 00 00 00 00 00 00
00 f2 f2 f2 f2 f2 f2
[  128.535106][    C0]                                                        ^
[  128.536197][    C0]  ffff88802fceee00: f2 f2 f2 00 00 00 00 f2 f2
f2 f2 00 00 00 00 00
[  128.537404][    C0]  ffff88802fceee80: 00 00 00 f2 f2 f2 f2 00 00
00 00 00 00 00 00 f2

There are other stacks that end in the same place without dm-crypt
involvement, but they are much harder for us to reproduce, so let's
stick with this one.

After some bisecting from myself and Ignat, we were able to find the
commit that fixes the issue, which is:

* https://github.com/torvalds/linux/commit/ce8f86ee94fabcc98537ddccd7e82cfd360a4dc5?w=1

mm/page_alloc: add a missing mm_page_alloc_zone_locked() tracepoint

The trace point *trace_mm_page_alloc_zone_locked()* in __rmqueue() does
not currently cover all branches.  Add the missing tracepoint and check
the page before do that.

We don't have CONFIG_CMA enabled, so it can be distilled to:

$ git diff HEAD^..HEAD
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 14b9e83ff9da..b5961d530929 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2871,7 +2871,8 @@ __rmqueue(struct zone *zone, unsigned int order,
int migratetype,
                        goto retry;
        }

-       trace_mm_page_alloc_zone_locked(page, order, migratetype);
+       if (page)
+               trace_mm_page_alloc_zone_locked(page, order, migratetype);
        return page;
 }

If I apply this patch on top of 5.10.11, the issue disappears.

I can't say I understand the connection here.

It's worth mentioning that the issue doesn't reproduce with
UNWINDER_FRAME_POINTER rather than UNWINDER_ORC. This fact makes me
think that ORC is to blame here somehow, but it's beyond my
understanding.

Here's how I replicate the issue in qemu running Debian Buster:

# /tmp is tmpfs in our case
$ qemu-img create -f qcow2 /tmp/nvme-$USER.img 10G

$ sudo qemu-system-x86_64 -smp 1 -m 3G -enable-kvm -cpu host -kernel
~/vmlinuz -initrd ~/initrd.img -nographic -device e1000 -device
nvme,drive=nvme0,serial=deadbeaf1,num_queues=8 -drive
file=/tmp/nvme-$USER.img,if=none,id=nvme0 -append 'console=ttyS0
kasan_multi_shot'

Inside of the VM:

root@localhost:~# echo -e '[Match]\nName=enp*\n[Network]\nDHCP=yes' >
/etc/systemd/network/00-dhcp.network
root@localhost:~# systemctl restart systemd-networkd
root@localhost:~# apt-get update
root@localhost:~# apt-get install -y --no-install-recommends cryptsetup
root@localhost:~# echo potato > keyfile
root@localhost:~# chmod 0400 keyfile
root@localhost:~# cryptsetup -q luksFormat /dev/nvme0n1 keyfile
root@localhost:~# cryptsetup open --type luks --key-file keyfile
--disable-keyring /dev/nvme0n1 luks-nvme0n1
root@localhost:~# dmsetup table /dev/mapper/luks-nvme0n1 | sed 's/$/ 2
no_read_workqueue no_write_workqueue/' | dmsetup reload
/dev/mapper/luks-nvme0n1
root@localhost:~# dmsetup suspend /dev/mapper/luks-nvme0n1 && dmsetup
resume /dev/mapper/luks-nvme0n1
root@localhost:~# mkfs.xfs -f /dev/mapper/luks-nvme0n1
root@localhost:~# mount /dev/mapper/luks-nvme0n1 /mnt

The workload that triggers the KASAN complaint is the following:

root@localhost:~# while true; do rm -f /mnt/random.data.target && dd
if=/dev/zero of=/mnt/random.data bs=10M count=400 status=progress &&
mv /mnt/random.data /mnt/random.data.target; sleep 1; done

It might take a few iterations to trigger.

Note that dmcrypt setup in our case depends on Ignat's patches, which
are included in 5.10.11 and 5.11-rc5, so during bisection between
5.11-rc3 and 5.11-rc4 they needed to be reapplied.

I'm going to ask for a backport of the "fix" to stable, but it feels
like there's a bigger issue here.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


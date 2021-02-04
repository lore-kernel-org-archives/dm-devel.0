Return-Path: <SRS0=5DIA=HG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5A79C433DB
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 02:51:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C40E964DEE
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 02:51:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C40E964DEE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-_e1kKElCOZu6xt3yCwNv7Q-1; Wed, 03 Feb 2021 21:51:35 -0500
X-MC-Unique: _e1kKElCOZu6xt3yCwNv7Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FD2F10059D6;
	Thu,  4 Feb 2021 02:51:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 703841A8A9;
	Thu,  4 Feb 2021 02:51:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BBDA74EE76;
	Thu,  4 Feb 2021 02:51:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1142pNJo025952 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Feb 2021 21:51:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B3306200A4F5; Thu,  4 Feb 2021 02:51:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE18C2026D11
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 02:51:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9BF63101A56C
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 02:51:18 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-152-zMf2GXPaPUSEsndCesJJNA-1;
	Wed, 03 Feb 2021 21:51:16 -0500
X-MC-Unique: zMf2GXPaPUSEsndCesJJNA-1
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com
	[66.24.58.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 9B0CA64F4A;
	Thu,  4 Feb 2021 02:44:50 +0000 (UTC)
Date: Wed, 3 Feb 2021 21:44:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ivan Babrou <ivan@cloudflare.com>
Message-ID: <20210203214448.2703930e@oasis.local.home>
In-Reply-To: <CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
References: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
	<CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Song Liu <songliubraving@fb.com>, Mike Snitzer <snitzer@redhat.com>,
	"Peter Zijlstra \(Intel\)" <peterz@infradead.org>,
	Yonghong Song <yhs@fb.com>, Ignat Korchagin <ignat@cloudflare.com>,
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
	dm-devel@redhat.com, Alexander Potapenko <glider@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>, "Joel Fernandes
	\(Google\)" <joel@joelfernandes.org>, Miroslav Benes <mbenes@suse.cz>,
	Jiri Slaby <jirislaby@kernel.org>, Alasdair Kergon <agk@redhat.com>, Ingo,
	Daniel Borkmann <daniel@iogearbox.net>,
	kernel-team <kernel-team@cloudflare.com>,
	Hailong liu <liu.hailong6@zte.com.cn>, x86@kernel.org,
	John Fastabend <john.fastabend@gmail.com>,
	kasan-dev@googlegroups.com, Molnar <mingo@redhat.com>,
	Ryabinin <aryabinin@virtuozzo.com>,
	Andrii Nakryiko <andriin@fb.com>, Andrey,
	Robert Richter <rric@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Josh Poimboeuf <jpoimboe@redhat.com>, KP Singh <kpsingh@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>, bpf@vger.kernel.org,
	Dmitry Vyukov <dvyukov@google.com>, Julien Thierry <jthierry@redhat.com>,
	Linux Kernel Network Developers <netdev@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>, Martin KaFai Lau <kafai@fb.com>
Subject: Re: [dm-devel] BUG: KASAN: stack-out-of-bounds in
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 2 Feb 2021 19:09:44 -0800
Ivan Babrou <ivan@cloudflare.com> wrote:

> On Thu, Jan 28, 2021 at 7:35 PM Ivan Babrou <ivan@cloudflare.com> wrote:
> >
> > Hello,
> >
> > We've noticed the following regression in Linux 5.10 branch:
> >
> > [  128.367231][    C0]
> > ==================================================================
> > [  128.368523][    C0] BUG: KASAN: stack-out-of-bounds in
> > unwind_next_frame (arch/x86/kernel/unwind_orc.c:371

The bug is a stack-out-of-bounds error in unwind_orc.c, right?

> > arch/x86/kernel/unwind_orc.c:544)
> > [  128.369744][    C0] Read of size 8 at addr ffff88802fceede0 by task
> > kworker/u2:2/591
> > [  128.370916][    C0]
> > [  128.371269][    C0] CPU: 0 PID: 591 Comm: kworker/u2:2 Not tainted
> > 5.10.11-cloudflare-kasan-2021.1.15 #1
> > [  128.372626][    C0] Hardware name: QEMU Standard PC (i440FX + PIIX,
> > 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
> > [  128.374346][    C0] Workqueue: writeback wb_workfn (flush-254:0)
> > [  128.375275][    C0] Call Trace:
> > [  128.375763][    C0]  <IRQ>
> > [  128.376221][    C0]  dump_stack+0x7d/0xa3
> > [  128.376843][    C0]  print_address_description.constprop.0+0x1c/0x210
[ snip ? results ]
> > (arch/x86/kernel/unwind_orc.c:371 arch/x86/kernel/unwind_orc.c:544)
[ snip ]
> > [  128.381736][    C0]  kasan_report.cold+0x1f/0x37
[ snip ]
> > [  128.383192][    C0]  unwind_next_frame+0x1df5/0x2650
[ snip ]
> > [  128.391550][    C0]  arch_stack_walk+0x8d/0xf0
[ snip ]
> > [  128.392807][    C0]  stack_trace_save+0x96/0xd0
[ snip ]
> > arch/x86/include/asm/irq_stack.h:77 arch/x86/kernel/irq_64.c:77)
[ snip ]
> > [  128.399759][    C0]  kasan_save_stack+0x20/0x50
[ snip ]
> > [  128.427691][    C0]  kasan_set_track+0x1c/0x30
> > [  128.428366][    C0]  kasan_set_free_info+0x1b/0x30
> > [  128.429113][    C0]  __kasan_slab_free+0x110/0x150
> > [  128.429838][    C0]  slab_free_freelist_hook+0x66/0x120
> > [  128.430628][    C0]  kfree+0xbf/0x4d0

[ snip the rest ]

> > [  128.441287][    C0] RIP: 0010:skcipher_walk_next
> > (crypto/skcipher.c:322 crypto/skcipher.c:384)

Why do we have an RIP in skcipher_walk_next, if its the unwinder that
had a bug? Or are they related?

Or did skcipher_walk_next trigger something in KASAN which did a stack
walk via the unwinder, and that caused another issue?

Looking at the unwinder code in question, we have:

static bool deref_stack_regs(struct unwind_state *state, unsigned long addr,
                             unsigned long *ip, unsigned long *sp)
{
        struct pt_regs *regs = (struct pt_regs *)addr;

        /* x86-32 support will be more complicated due to the &regs->sp hack */
        BUILD_BUG_ON(IS_ENABLED(CONFIG_X86_32));

        if (!stack_access_ok(state, addr, sizeof(struct pt_regs)))
                return false;

        *ip = regs->ip;
        *sp = regs->sp; <- pointer to here
        return true;
}

and the caller of the above static function:

        case UNWIND_HINT_TYPE_REGS:
                if (!deref_stack_regs(state, sp, &state->ip, &state->sp)) {
                        orc_warn_current("can't access registers at %pB\n",
                                         (void *)orig_ip);
                        goto err;
                }


Could it possibly be that there's some magic canary on the stack that
causes KASAN to trigger if you read it? For example, there's this in
the stack tracer:

kernel/trace/trace_stack.c: check_stack()

        while (i < stack_trace_nr_entries) {
                int found = 0;

                stack_trace_index[x] = this_size;
                p = start;

                for (; p < top && i < stack_trace_nr_entries; p++) {
                        /*
                         * The READ_ONCE_NOCHECK is used to let KASAN know that
                         * this is not a stack-out-of-bounds error.
                         */
                        if ((READ_ONCE_NOCHECK(*p)) == stack_dump_trace[i]) {
                                stack_dump_trace[x] = stack_dump_trace[i++];
                                this_size = stack_trace_index[x++] =
                                        (top - p) * sizeof(unsigned long);
                                found = 1;


That is because I read the entire stack frame looking for values, and I
know where the top of the stack is, and will not go past it. But it too
triggered a stack-out-of-bounds error, which required the above
READ_ONCE_NOCHECK() to quiet KASAN. Not to mention there's already some
READ_ONCE_NOCHECK() calls in the unwinder. Maybe this too is required?

Would this work?

diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 73f800100066..22eaf3683c2a 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -367,8 +367,8 @@ static bool deref_stack_regs(struct unwind_state *state, unsigned long addr,
 	if (!stack_access_ok(state, addr, sizeof(struct pt_regs)))
 		return false;
 
-	*ip = regs->ip;
-	*sp = regs->sp;
+	*ip = READ_ONCE_NOCHECK(regs->ip);
+	*sp = READ_ONCE_NOCHECK(regs->sp);
 	return true;
 }
 
-- Steve

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


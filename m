Return-Path: <SRS0=5DIA=HG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CDC2C433DB
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 09:14:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D178D64DF2
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 09:14:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D178D64DF2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1612430091;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8xDSOOJPEfBGhTFuwdNhxsltE22hoNMsws9EMfZmO20=;
	b=C/ZegcWkpGQsoLY4nTXmrtua4lsNEDb+rUnbNrMi0H057e/hz+n8ABK1zxx1Ot4Mg/gz5G
	4Zb+qY69H6sy6P/YFmL23vvVFMHJxndVLA2QxRM/rXfM+4LIEdWib0we1WxyQ74uHmSKCT
	9NUckrKjzb94u24FEx/3zG7iMHKA5jo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-Rvp6F6LdOcqPaPLh2s-1hA-1; Thu, 04 Feb 2021 04:14:49 -0500
X-MC-Unique: Rvp6F6LdOcqPaPLh2s-1hA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74106107ACE4;
	Thu,  4 Feb 2021 09:14:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 321E660C71;
	Thu,  4 Feb 2021 09:14:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D60DC4EE76;
	Thu,  4 Feb 2021 09:14:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 113J5aCM001915 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Feb 2021 14:05:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 11904779F4; Wed,  3 Feb 2021 19:05:36 +0000 (UTC)
Received: from treble (ovpn-120-118.rdu2.redhat.com [10.10.120.118])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 61D86709A9;
	Wed,  3 Feb 2021 19:05:21 +0000 (UTC)
Date: Wed, 3 Feb 2021 13:05:18 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Ivan Babrou <ivan@cloudflare.com>
Message-ID: <20210203190518.nlwghesq75enas6n@treble>
References: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
	<CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
	<YBrTaVVfWu2R0Hgw@hirez.programming.kicks-ass.net>
	<CABWYdi2ephz57BA8bns3reMGjvs5m0hYp82+jBLZ6KD3Ba6zdQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CABWYdi2ephz57BA8bns3reMGjvs5m0hYp82+jBLZ6KD3Ba6zdQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 04 Feb 2021 04:14:38 -0500
Cc: Song Liu <songliubraving@fb.com>, Mike Snitzer <snitzer@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ignat Korchagin <ignat@cloudflare.com>,
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
	dm-devel@redhat.com, Alexander Potapenko <glider@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Joel Fernandes \(Google\)" <joel@joelfernandes.org>,
	Miroslav Benes <mbenes@suse.cz>, Jiri Slaby <jirislaby@kernel.org>,
	Alasdair Kergon <agk@redhat.com>, Daniel Borkmann <daniel@iogearbox.net>,
	kernel-team <kernel-team@cloudflare.com>,
	Hailong liu <liu.hailong6@zte.com.cn>, x86@kernel.org,
	John Fastabend <john.fastabend@gmail.com>,
	kasan-dev@googlegroups.com, Alexey Kardashevskiy <aik@ozlabs.ru>,
	Ingo Molnar <mingo@redhat.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Andrii Nakryiko <andriin@fb.com>, Robert Richter <rric@kernel.org>,
	"Steven Rostedt \(VMware\)" <rostedt@goodmis.org>,
	Borislav Petkov <bp@alien8.de>, Yonghong Song <yhs@fb.com>,
	KP Singh <kpsingh@chromium.org>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 03, 2021 at 09:46:55AM -0800, Ivan Babrou wrote:
> > Can you pretty please not line-wrap console output? It's unreadable.
> 
> GMail doesn't make it easy, I'll send a link to a pastebin next time.
> Let me know if you'd like me to regenerate the decoded stack.
> 
> > > edfd9b7838ba5e47f19ad8466d0565aba5c59bf0 is the first bad commit
> > > commit edfd9b7838ba5e47f19ad8466d0565aba5c59bf0
> >
> > Not sure what tree you're on, but that's not the upstream commit.
> 
> I mentioned that it's a rebased core-static_call-2020-10-12 tag and
> added a link to the upstream hash right below.
> 
> > > Author: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > > Date:   Tue Aug 18 15:57:52 2020 +0200
> > >
> > >     tracepoint: Optimize using static_call()
> > >
> >
> > There's a known issue with that patch, can you try:
> >
> >   http://lkml.kernel.org/r/20210202220121.435051654@goodmis.org
> 
> I've tried it on top of core-static_call-2020-10-12 tag rebased on top
> of v5.9 (to make it reproducible), and the patch did not help. Do I
> need to apply the whole series or something else?

Can you recreate with this patch, and add "unwind_debug" to the cmdline?
It will spit out a bunch of stack data.


From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH] Subject: [PATCH] x86/unwind: Add 'unwind_debug' cmdline
 option

Sometimes the one-line ORC unwinder warnings aren't very helpful.  Take
the existing frame pointer unwind_dump() and make it useful for all
unwinders.

I don't want to be too aggressive about enabling the dumps, so for now
they're only enabled with the use of a new 'unwind_debug' cmdline
option.  When enabled, it will dump the full contents of the stack when
an error condition is encountered, or when dump_stack() is called.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 .../admin-guide/kernel-parameters.txt         |  6 +++
 arch/x86/include/asm/unwind.h                 |  3 ++
 arch/x86/kernel/dumpstack.c                   | 39 ++++++++++++++
 arch/x86/kernel/unwind_frame.c                | 51 +++----------------
 arch/x86/kernel/unwind_orc.c                  |  5 +-
 5 files changed, 58 insertions(+), 46 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 3d6604a949f8..d29689aa62a2 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5521,6 +5521,12 @@
 	unknown_nmi_panic
 			[X86] Cause panic on unknown NMI.
 
+	unwind_debug	[X86-64]
+			Enable unwinder debug output.  This can be
+			useful for debugging certain unwinder error
+			conditions, including corrupt stacks and
+			bad/missing unwinder metadata.
+
 	usbcore.authorized_default=
 			[USB] Default USB device authorization:
 			(default -1 = authorized except for wireless USB,
diff --git a/arch/x86/include/asm/unwind.h b/arch/x86/include/asm/unwind.h
index 70fc159ebe69..5101d7ef7912 100644
--- a/arch/x86/include/asm/unwind.h
+++ b/arch/x86/include/asm/unwind.h
@@ -123,4 +123,7 @@ static inline bool task_on_another_cpu(struct task_struct *task)
 #endif
 }
 
+extern bool unwind_debug __ro_after_init;
+void unwind_dump(struct unwind_state *state);
+
 #endif /* _ASM_X86_UNWIND_H */
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 299c20f0a38b..febfd5b7f62a 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -29,6 +29,42 @@ static int die_counter;
 
 static struct pt_regs exec_summary_regs;
 
+bool unwind_debug __ro_after_init;
+static int __init unwind_debug_cmdline(char *str)
+{
+	unwind_debug = true;
+	return 0;
+}
+early_param("unwind_debug", unwind_debug_cmdline);
+
+void unwind_dump(struct unwind_state *state)
+{
+	unsigned long word, *sp;
+	struct stack_info stack_info = {0};
+	unsigned long visit_mask = 0;
+
+	printk_deferred("unwinder dump: stack type:%d next_sp:%p mask:0x%lx graph_idx:%d\n",
+			state->stack_info.type, state->stack_info.next_sp,
+			state->stack_mask, state->graph_idx);
+
+	sp = state->task == current ? __builtin_frame_address(0)
+				    : (void *)state->task->thread.sp;
+
+	for (; sp; sp = PTR_ALIGN(stack_info.next_sp, sizeof(long))) {
+		if (get_stack_info(sp, state->task, &stack_info, &visit_mask))
+			break;
+
+		for (; sp < stack_info.end; sp++) {
+
+			word = READ_ONCE_NOCHECK(*sp);
+
+			printk_deferred("%0*lx: %0*lx (%pB)\n", BITS_PER_LONG/4,
+					(unsigned long)sp, BITS_PER_LONG/4,
+					word, (void *)word);
+		}
+	}
+}
+
 bool noinstr in_task_stack(unsigned long *stack, struct task_struct *task,
 			   struct stack_info *info)
 {
@@ -301,6 +337,9 @@ static void show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		if (stack_name)
 			printk("%s </%s>\n", log_lvl, stack_name);
 	}
+
+	if (unwind_debug)
+		unwind_dump(&state);
 }
 
 void show_stack(struct task_struct *task, unsigned long *sp,
diff --git a/arch/x86/kernel/unwind_frame.c b/arch/x86/kernel/unwind_frame.c
index d7c44b257f7f..6bcdf6ecad65 100644
--- a/arch/x86/kernel/unwind_frame.c
+++ b/arch/x86/kernel/unwind_frame.c
@@ -28,48 +28,6 @@ unsigned long *unwind_get_return_address_ptr(struct unwind_state *state)
 	return state->regs ? &state->regs->ip : state->bp + 1;
 }
 
-static void unwind_dump(struct unwind_state *state)
-{
-	static bool dumped_before = false;
-	bool prev_zero, zero = false;
-	unsigned long word, *sp;
-	struct stack_info stack_info = {0};
-	unsigned long visit_mask = 0;
-
-	if (dumped_before)
-		return;
-
-	dumped_before = true;
-
-	printk_deferred("unwind stack type:%d next_sp:%p mask:0x%lx graph_idx:%d\n",
-			state->stack_info.type, state->stack_info.next_sp,
-			state->stack_mask, state->graph_idx);
-
-	for (sp = PTR_ALIGN(state->orig_sp, sizeof(long)); sp;
-	     sp = PTR_ALIGN(stack_info.next_sp, sizeof(long))) {
-		if (get_stack_info(sp, state->task, &stack_info, &visit_mask))
-			break;
-
-		for (; sp < stack_info.end; sp++) {
-
-			word = READ_ONCE_NOCHECK(*sp);
-
-			prev_zero = zero;
-			zero = word == 0;
-
-			if (zero) {
-				if (!prev_zero)
-					printk_deferred("%p: %0*x ...\n",
-							sp, BITS_PER_LONG/4, 0);
-				continue;
-			}
-
-			printk_deferred("%p: %0*lx (%pB)\n",
-					sp, BITS_PER_LONG/4, word, (void *)word);
-		}
-	}
-}
-
 static bool in_entry_code(unsigned long ip)
 {
 	char *addr = (char *)ip;
@@ -244,7 +202,6 @@ static bool update_stack_state(struct unwind_state *state,
 						  addr, addr_p);
 	}
 
-	/* Save the original stack pointer for unwind_dump(): */
 	if (!state->orig_sp)
 		state->orig_sp = frame;
 
@@ -346,13 +303,17 @@ bool unwind_next_frame(struct unwind_state *state)
 			"WARNING: kernel stack regs at %p in %s:%d has bad 'bp' value %p\n",
 			state->regs, state->task->comm,
 			state->task->pid, next_bp);
-		unwind_dump(state);
+
+		if (unwind_debug)
+			unwind_dump(state);
 	} else {
 		printk_deferred_once(KERN_WARNING
 			"WARNING: kernel stack frame pointer at %p in %s:%d has bad value %p\n",
 			state->bp, state->task->comm,
 			state->task->pid, next_bp);
-		unwind_dump(state);
+
+		if (unwind_debug)
+			unwind_dump(state);
 	}
 the_end:
 	state->stack_info.type = STACK_TYPE_UNKNOWN;
diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 73f800100066..38265eac41dd 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -13,8 +13,11 @@
 
 #define orc_warn_current(args...)					\
 ({									\
-	if (state->task == current)					\
+	if (state->task == current) {					\
 		orc_warn(args);						\
+		if (unwind_debug)					\
+			unwind_dump(state);				\
+	}								\
 })
 
 extern int __start_orc_unwind_ip[];
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


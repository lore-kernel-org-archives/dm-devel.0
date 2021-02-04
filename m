Return-Path: <SRS0=5DIA=HG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED661C433E9
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 09:15:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8092564DF2
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 09:15:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8092564DF2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1612430111;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vM7T1yanmVRqE1evQxgWUFFB5GckGctSGrjWu3Ld93Y=;
	b=fb5BrWJpHqDDwZkV+f0kmgqZ99httuG5Syk3hWVNTViP3RQ8lHqBCiviO4Vxr4XPxT4043
	NjhABU5Eho6UxrghCnVN37ZvsbAngIyZkerWdoMGdUODGOzQg4ZlM6Vj0DEiA4x0RbWQBi
	fLqV1P+Pd1B5JUc+7FOlNIh4B7wRtHc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-Y7IEnWITPWG3737DINs6vA-1; Thu, 04 Feb 2021 04:15:09 -0500
X-MC-Unique: Y7IEnWITPWG3737DINs6vA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 037D0AFA86;
	Thu,  4 Feb 2021 09:15:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D6C1C5D762;
	Thu,  4 Feb 2021 09:15:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9FC8657DFA;
	Thu,  4 Feb 2021 09:15:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1143A1dA027892 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Feb 2021 22:10:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1B27D5D9C9; Thu,  4 Feb 2021 03:10:01 +0000 (UTC)
Received: from treble (ovpn-113-81.rdu2.redhat.com [10.10.113.81])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D31EF5D9C0;
	Thu,  4 Feb 2021 03:09:50 +0000 (UTC)
Date: Wed, 3 Feb 2021 21:09:48 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Message-ID: <20210204030948.dmsmwyw6fu5kzgey@treble>
References: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
	<CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
	<20210203214448.2703930e@oasis.local.home>
MIME-Version: 1.0
In-Reply-To: <20210203214448.2703930e@oasis.local.home>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 04 Feb 2021 04:14:38 -0500
Cc: Song Liu <songliubraving@fb.com>, Mike Snitzer <snitzer@redhat.com>,
	"Peter Zijlstra \(Intel\)" <peterz@infradead.org>,
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
	kasan-dev@googlegroups.com, Ingo Molnar <mingo@redhat.com>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Andrii Nakryiko <andriin@fb.com>,
	Robert Richter <rric@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>, bpf@vger.kernel.org,
	Dmitry Vyukov <dvyukov@google.com>, Julien Thierry <jthierry@redhat.com>,
	Linux Kernel Network Developers <netdev@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ivan Babrou <ivan@cloudflare.com>, Martin KaFai Lau <kafai@fb.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 03, 2021 at 09:44:48PM -0500, Steven Rostedt wrote:
> > > [  128.441287][    C0] RIP: 0010:skcipher_walk_next
> > > (crypto/skcipher.c:322 crypto/skcipher.c:384)
> 
> Why do we have an RIP in skcipher_walk_next, if its the unwinder that
> had a bug? Or are they related?
> 
> Or did skcipher_walk_next trigger something in KASAN which did a stack
> walk via the unwinder, and that caused another issue?

It was interrupted by an IRQ, which then called kfree(), which then
called kasan_save_stack(), which then called the unwinder, which then
read "out-of-bounds" between stack frames.

In this case it was because of some crypto code missing ORC annotations.

> Looking at the unwinder code in question, we have:
> 
> static bool deref_stack_regs(struct unwind_state *state, unsigned long addr,
>                              unsigned long *ip, unsigned long *sp)
> {
>         struct pt_regs *regs = (struct pt_regs *)addr;
> 
>         /* x86-32 support will be more complicated due to the &regs->sp hack */
>         BUILD_BUG_ON(IS_ENABLED(CONFIG_X86_32));
> 
>         if (!stack_access_ok(state, addr, sizeof(struct pt_regs)))
>                 return false;
> 
>         *ip = regs->ip;
>         *sp = regs->sp; <- pointer to here
>         return true;
> }
> 
> and the caller of the above static function:
> 
>         case UNWIND_HINT_TYPE_REGS:
>                 if (!deref_stack_regs(state, sp, &state->ip, &state->sp)) {
>                         orc_warn_current("can't access registers at %pB\n",
>                                          (void *)orig_ip);
>                         goto err;
>                 }
> 
> 
> Could it possibly be that there's some magic canary on the stack that
> causes KASAN to trigger if you read it?

Right, the unwinder isn't allowed to read between stack frames.

In fact, you read my mind, I was looking at the other warning in network
code:

  [160676.598929][    C4]  asm_common_interrupt+0x1e/0x40
  [160676.608966][    C4] RIP: 0010:0xffffffffc17d814c
  [160676.618812][    C4] Code: 8b 4c 24 40 4c 8b 44 24 48 48 8b 7c 24 70 48 8b 74 24 68 48 8b 54 24 60 48 8b 4c 24 58 48 8b 44 24 50 48 81 c4 a8 00 00 00 9d <c3> 20 27 af 8f ff ff ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00
  [160676.649371][    C4] RSP: 0018:ffff8893dfd4f620 EFLAGS: 00000282
  [160676.661073][    C4] RAX: 0000000000000000 RBX: ffff8881be9c9c80 RCX: 0000000000000000
  [160676.674788][    C4] RDX: dffffc0000000000 RSI: 000000000000000b RDI: ffff8881be9c9c80
  [160676.688508][    C4] RBP: ffff8881be9c9ce0 R08: 0000000000000000 R09: ffff8881908c4c97
  [160676.702249][    C4] R10: ffffed1032118992 R11: ffff88818a4ce68c R12: ffff8881be9c9eea
  [160676.716000][    C4] R13: ffff8881be9c9c92 R14: ffff8880063ba5ac R15: ffff8880063ba5a8
  [160676.729895][    C4]  ? tcp_set_state+0x5/0x620
  [160676.740426][    C4]  ? tcp_fin+0xeb/0x5a0
  [160676.750287][    C4]  ? tcp_data_queue+0x1e78/0x4ce0
  [160676.761089][    C4]  ? tcp_urg+0x76/0xc50

This line gives a big clue:

  [160676.608966][    C4] RIP: 0010:0xffffffffc17d814c

That address, without a function name, most likely means that it was
running in some generated code (mostly likely BPF) when it got
interrupted.

Right now, the ORC unwinder tries to fall back to frame pointers when it
encounters generated code:

	orc = orc_find(state->signal ? state->ip : state->ip - 1);
	if (!orc)
		/*
		 * As a fallback, try to assume this code uses a frame pointer.
		 * This is useful for generated code, like BPF, which ORC
		 * doesn't know about.  This is just a guess, so the rest of
		 * the unwind is no longer considered reliable.
		 */
		orc = &orc_fp_entry;
		state->error = true;
	}

Because the ORC unwinder is guessing from that point onward, it's
possible for it to read the KASAN stack redzone, if the generated code
hasn't set up frame pointers.  So the best fix may be for the unwinder
to just always bypass KASAN when reading the stack.

The unwinder has a mechanism for detecting and warning about
out-of-bounds, and KASAN is short-circuiting that.

This should hopefully get rid of *all* the KASAN unwinder warnings, both
crypto and networking.

diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 040194d079b6..1f69a23a4715 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -376,8 +376,8 @@ static bool deref_stack_regs(struct unwind_state *state, unsigned long addr,
 	if (!stack_access_ok(state, addr, sizeof(struct pt_regs)))
 		return false;
 
-	*ip = regs->ip;
-	*sp = regs->sp;
+	*ip = READ_ONCE_NOCHECK(regs->ip);
+	*sp = READ_ONCE_NOCHECK(regs->sp);
 	return true;
 }
 
@@ -389,8 +389,8 @@ static bool deref_stack_iret_regs(struct unwind_state *state, unsigned long addr
 	if (!stack_access_ok(state, addr, IRET_FRAME_SIZE))
 		return false;
 
-	*ip = regs->ip;
-	*sp = regs->sp;
+	*ip = READ_ONCE_NOCHECK(regs->ip);
+	*sp = READ_ONCE_NOCHECK(regs->sp);
 	return true;
 }
 
@@ -411,12 +411,12 @@ static bool get_reg(struct unwind_state *state, unsigned int reg_off,
 		return false;
 
 	if (state->full_regs) {
-		*val = ((unsigned long *)state->regs)[reg];
+		*val = READ_ONCE_NOCHECK(((unsigned long *)state->regs)[reg]);
 		return true;
 	}
 
 	if (state->prev_regs) {
-		*val = ((unsigned long *)state->prev_regs)[reg];
+		*val = READ_ONCE_NOCHECK(((unsigned long *)state->prev_regs)[reg]);
 		return true;
 	}
 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


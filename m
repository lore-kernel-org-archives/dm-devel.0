Return-Path: <SRS0=5DIA=HG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51670C433E9
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 09:15:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C2DC064F5C
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 09:15:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2DC064F5C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1612430107;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZzQYSH0fnaWft8hcfQDx+tSM/+8o2g+EokkeN7BhePQ=;
	b=QjlPIwds4lC5N0ubojc3GLWNE8kohsk9dWbdl4S7CHUsr8Mq9ltU73WbpoUQkPKrbBnGs2
	BHF53jAVti0yaKYBr8UwS2CgFTjVQ92T7G1DsR9P/nyRydRgUOXMvQ+/SSHXNJef/zbvUQ
	hvE+0wTZWrYITef43AFAsBzyWq6jlcE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-EvSti9ykMD2QMpjVPPANAQ-1; Thu, 04 Feb 2021 04:15:04 -0500
X-MC-Unique: EvSti9ykMD2QMpjVPPANAQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A60E31020C21;
	Thu,  4 Feb 2021 09:14:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8686E10013DB;
	Thu,  4 Feb 2021 09:14:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 595B94EEEC;
	Thu,  4 Feb 2021 09:14:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1140HG44005316 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Feb 2021 19:17:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 75C89101E66C; Thu,  4 Feb 2021 00:17:16 +0000 (UTC)
Received: from treble (ovpn-113-81.rdu2.redhat.com [10.10.113.81])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 911A2100AE4D;
	Thu,  4 Feb 2021 00:17:03 +0000 (UTC)
Date: Wed, 3 Feb 2021 18:17:00 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Ivan Babrou <ivan@cloudflare.com>
Message-ID: <20210204001700.ry6dpqvavcswyvy7@treble>
References: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
	<CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
	<YBrTaVVfWu2R0Hgw@hirez.programming.kicks-ass.net>
	<CABWYdi2ephz57BA8bns3reMGjvs5m0hYp82+jBLZ6KD3Ba6zdQ@mail.gmail.com>
	<20210203190518.nlwghesq75enas6n@treble>
	<CABWYdi1ya41Ju9SsHMtRQaFQ=s8N23D3ADn6OV6iBwWM6H8=Zw@mail.gmail.com>
	<20210203232735.nw73kugja56jp4ls@treble>
	<CABWYdi1zd51Jb35taWeGC-dR9SChq-4ixvyKms3KOKgV0idfPg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CABWYdi1zd51Jb35taWeGC-dR9SChq-4ixvyKms3KOKgV0idfPg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 03, 2021 at 03:30:35PM -0800, Ivan Babrou wrote:
> > > > Can you recreate with this patch, and add "unwind_debug" to the cmdline?
> > > > It will spit out a bunch of stack data.
> > >
> > > Here's the three I'm building:
> > >
> > > * https://github.com/bobrik/linux/tree/ivan/static-call-5.9
> > >
> > > It contains:
> > >
> > > * v5.9 tag as the base
> > > * static_call-2020-10-12 tag
> > > * dm-crypt patches to reproduce the issue with KASAN
> > > * x86/unwind: Add 'unwind_debug' cmdline option
> > > * tracepoint: Fix race between tracing and removing tracepoint
> > >
> > > The very same issue can be reproduced on 5.10.11 with no patches,
> > > but I'm going with 5.9, since it boils down to static call changes.
> > >
> > > Here's the decoded stack from the kernel with unwind debug enabled:
> > >
> > > * https://gist.github.com/bobrik/ed052ac0ae44c880f3170299ad4af56b
> > >
> > > See my first email for the exact commands that trigger this.
> >
> > Thanks.  Do you happen to have the original dmesg, before running it
> > through the post-processing script?
> 
> Yes, here it is:
> 
> * https://gist.github.com/bobrik/8c13e6a02555fb21cadabb74cdd6f9ab

It appears the unwinder is getting lost in crypto code.  No idea what
this has to do with static calls though.  Or maybe you're seeing
multiple issues.

Does this fix it?


diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index a31de0c6ccde..36c55341137c 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -2,7 +2,14 @@
 #
 # x86 crypto algorithms
 
-OBJECT_FILES_NON_STANDARD := y
+OBJECT_FILES_NON_STANDARD_sha256-avx2-asm.o		:= y
+OBJECT_FILES_NON_STANDARD_sha512-ssse3-asm.o		:= y
+OBJECT_FILES_NON_STANDARD_sha512-avx-asm.o		:= y
+OBJECT_FILES_NON_STANDARD_sha512-avx2-asm.o		:= y
+OBJECT_FILES_NON_STANDARD_crc32c-pcl-intel-asm_64.o	:= y
+OBJECT_FILES_NON_STANDARD_camellia-aesni-avx2-asm_64.o	:= y
+OBJECT_FILES_NON_STANDARD_sha1_avx2_x86_64_asm.o	:= y
+OBJECT_FILES_NON_STANDARD_sha1_ni_asm.o			:= y
 
 obj-$(CONFIG_CRYPTO_GLUE_HELPER_X86) += glue_helper.o
 
diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aesni-intel_avx-x86_64.S
index 5fee47956f3b..59c36b88954f 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -237,8 +237,8 @@ define_reg j %j
 .noaltmacro
 .endm
 
-# need to push 4 registers into stack to maintain
-STACK_OFFSET = 8*4
+# need to push 5 registers into stack to maintain
+STACK_OFFSET = 8*5
 
 TMP1 =   16*0    # Temporary storage for AAD
 TMP2 =   16*1    # Temporary storage for AES State 2 (State 1 is stored in an XMM register)
@@ -257,6 +257,8 @@ VARIABLE_OFFSET = 16*8
 
 .macro FUNC_SAVE
         #the number of pushes must equal STACK_OFFSET
+	push	%rbp
+	mov	%rsp, %rbp
         push    %r12
         push    %r13
         push    %r14
@@ -271,12 +273,14 @@ VARIABLE_OFFSET = 16*8
 .endm
 
 .macro FUNC_RESTORE
+        add     $VARIABLE_OFFSET, %rsp
         mov     %r14, %rsp
 
         pop     %r15
         pop     %r14
         pop     %r13
         pop     %r12
+	pop	%rbp
 .endm
 
 # Encryption of a single block

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


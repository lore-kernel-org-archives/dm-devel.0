Return-Path: <SRS0=CL6l=HT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5458C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:34:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3AF7464E15
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:34:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3AF7464E15
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-wYdj3TQWPziKtWKcBkIwDQ-1; Wed, 17 Feb 2021 10:34:05 -0500
X-MC-Unique: wYdj3TQWPziKtWKcBkIwDQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27E146D4EE;
	Wed, 17 Feb 2021 15:33:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5EB2360C61;
	Wed, 17 Feb 2021 15:33:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8E29118095CB;
	Wed, 17 Feb 2021 15:33:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 114Jq2ev013864 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Feb 2021 14:52:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BD947106A32; Thu,  4 Feb 2021 19:52:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B62E3106A2B
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 19:51:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5BA8811E88
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 19:51:59 +0000 (UTC)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com
	[209.85.167.47]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-448-liZHSw3HM1OXNL5h-6TxgA-1; Thu, 04 Feb 2021 14:51:57 -0500
X-MC-Unique: liZHSw3HM1OXNL5h-6TxgA-1
Received: by mail-lf1-f47.google.com with SMTP id d3so6341493lfg.10
	for <dm-devel@redhat.com>; Thu, 04 Feb 2021 11:51:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=FToFoRW57QEfMw0vp233PBaMzzSywEYZZwEWphiSDG8=;
	b=owRNBfSuqsg39JsO6upf6P35nJPey2aaxOldI3cbyNkXqeYJ0Cy1lb7CKEVY/hcuxZ
	jqLPQkL15F2Bpfw0kn2Y1owPakSerFJEhJHi3CEQ1jk+ua9T3CTC/dRStw5Duk8OTZHB
	puJXCMeM3+7jdXgAxViJvcPSwF1l7sDrioU67ydhYrtynSwTNmjbUGp7ywnPnCeU3bDm
	MqTY/0U3Qtl+3cJJSVvRts+HSiavH7XXYdCV6zTRBQL+QF8n7CM8oajEFAi274jOKh+3
	SdUcaLVEprF8NfQKi3aX9yinBU1h9eUe9DAvyoXnyhyIlm61uQoxivCLyzbunMLJXacE
	t0eg==
X-Gm-Message-State: AOAM5326S4s/5r/4FEu4L5dkmSfr+29yWz2WXtE+bb8m/87iwyrMccPf
	8Dl0ia2mK6fQ2mIGDIfOkgfMxtjLz04wKNvO2MyDsg==
X-Google-Smtp-Source: ABdhPJw6yc26ixa+BNP3THtxCTWaeQD524mnhSMrIKSYnAhxtWx3VpBmUou9Z3mhYHUs2DgfYkVuuxjVCVG8de8YSi0=
X-Received: by 2002:a05:6512:3904:: with SMTP id
	a4mr526525lfu.340.1612468315961; 
	Thu, 04 Feb 2021 11:51:55 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
	<CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
	<YBrTaVVfWu2R0Hgw@hirez.programming.kicks-ass.net>
	<CABWYdi2ephz57BA8bns3reMGjvs5m0hYp82+jBLZ6KD3Ba6zdQ@mail.gmail.com>
	<20210203190518.nlwghesq75enas6n@treble>
	<CABWYdi1ya41Ju9SsHMtRQaFQ=s8N23D3ADn6OV6iBwWM6H8=Zw@mail.gmail.com>
	<20210203232735.nw73kugja56jp4ls@treble>
	<CABWYdi1zd51Jb35taWeGC-dR9SChq-4ixvyKms3KOKgV0idfPg@mail.gmail.com>
	<20210204001700.ry6dpqvavcswyvy7@treble>
In-Reply-To: <20210204001700.ry6dpqvavcswyvy7@treble>
From: Ivan Babrou <ivan@cloudflare.com>
Date: Thu, 4 Feb 2021 11:51:44 -0800
Message-ID: <CABWYdi2GsFW9ExXAQ55tvr+K86eY15T1XFoZDDBro9hJK5Gpqg@mail.gmail.com>
To: Josh Poimboeuf <jpoimboe@redhat.com>
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
X-Mailman-Approved-At: Wed, 17 Feb 2021 10:31:26 -0500
Cc: Song Liu <songliubraving@fb.com>, Mike Snitzer <snitzer@redhat.com>,
	Alexey Kardashevskiy <aik@ozlabs.ru>,
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
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 3, 2021 at 4:17 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Wed, Feb 03, 2021 at 03:30:35PM -0800, Ivan Babrou wrote:
> > > > > Can you recreate with this patch, and add "unwind_debug" to the cmdline?
> > > > > It will spit out a bunch of stack data.
> > > >
> > > > Here's the three I'm building:
> > > >
> > > > * https://github.com/bobrik/linux/tree/ivan/static-call-5.9
> > > >
> > > > It contains:
> > > >
> > > > * v5.9 tag as the base
> > > > * static_call-2020-10-12 tag
> > > > * dm-crypt patches to reproduce the issue with KASAN
> > > > * x86/unwind: Add 'unwind_debug' cmdline option
> > > > * tracepoint: Fix race between tracing and removing tracepoint
> > > >
> > > > The very same issue can be reproduced on 5.10.11 with no patches,
> > > > but I'm going with 5.9, since it boils down to static call changes.
> > > >
> > > > Here's the decoded stack from the kernel with unwind debug enabled:
> > > >
> > > > * https://gist.github.com/bobrik/ed052ac0ae44c880f3170299ad4af56b
> > > >
> > > > See my first email for the exact commands that trigger this.
> > >
> > > Thanks.  Do you happen to have the original dmesg, before running it
> > > through the post-processing script?
> >
> > Yes, here it is:
> >
> > * https://gist.github.com/bobrik/8c13e6a02555fb21cadabb74cdd6f9ab
>
> It appears the unwinder is getting lost in crypto code.  No idea what
> this has to do with static calls though.  Or maybe you're seeing
> multiple issues.
>
> Does this fix it?
>
>
> diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
> index a31de0c6ccde..36c55341137c 100644
> --- a/arch/x86/crypto/Makefile
> +++ b/arch/x86/crypto/Makefile
> @@ -2,7 +2,14 @@
>  #
>  # x86 crypto algorithms
>
> -OBJECT_FILES_NON_STANDARD := y
> +OBJECT_FILES_NON_STANDARD_sha256-avx2-asm.o            := y
> +OBJECT_FILES_NON_STANDARD_sha512-ssse3-asm.o           := y
> +OBJECT_FILES_NON_STANDARD_sha512-avx-asm.o             := y
> +OBJECT_FILES_NON_STANDARD_sha512-avx2-asm.o            := y
> +OBJECT_FILES_NON_STANDARD_crc32c-pcl-intel-asm_64.o    := y
> +OBJECT_FILES_NON_STANDARD_camellia-aesni-avx2-asm_64.o := y
> +OBJECT_FILES_NON_STANDARD_sha1_avx2_x86_64_asm.o       := y
> +OBJECT_FILES_NON_STANDARD_sha1_ni_asm.o                        := y
>
>  obj-$(CONFIG_CRYPTO_GLUE_HELPER_X86) += glue_helper.o
>
> diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aesni-intel_avx-x86_64.S
> index 5fee47956f3b..59c36b88954f 100644
> --- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
> +++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
> @@ -237,8 +237,8 @@ define_reg j %j
>  .noaltmacro
>  .endm
>
> -# need to push 4 registers into stack to maintain
> -STACK_OFFSET = 8*4
> +# need to push 5 registers into stack to maintain
> +STACK_OFFSET = 8*5
>
>  TMP1 =   16*0    # Temporary storage for AAD
>  TMP2 =   16*1    # Temporary storage for AES State 2 (State 1 is stored in an XMM register)
> @@ -257,6 +257,8 @@ VARIABLE_OFFSET = 16*8
>
>  .macro FUNC_SAVE
>          #the number of pushes must equal STACK_OFFSET
> +       push    %rbp
> +       mov     %rsp, %rbp
>          push    %r12
>          push    %r13
>          push    %r14
> @@ -271,12 +273,14 @@ VARIABLE_OFFSET = 16*8
>  .endm
>
>  .macro FUNC_RESTORE
> +        add     $VARIABLE_OFFSET, %rsp
>          mov     %r14, %rsp
>
>          pop     %r15
>          pop     %r14
>          pop     %r13
>          pop     %r12
> +       pop     %rbp
>  .endm
>
>  # Encryption of a single block
>

This patch seems to fix the following warning:

[  147.995699][    C0] WARNING: stack going in the wrong direction? at
glue_xts_req_128bit+0x21f/0x6f0 [glue_helper]

Or at least I cannot see it anymore when combined with your other
patch, not sure if it did the trick by itself.

This sounds like a good reason to send them both.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


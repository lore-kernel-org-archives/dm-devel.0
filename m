Return-Path: <SRS0=CL6l=HT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B3E0C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:34:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C2AFE64E15
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:34:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2AFE64E15
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-SAe0cAz1MZ6Q-NsFFp7TNQ-1; Wed, 17 Feb 2021 10:34:18 -0500
X-MC-Unique: SAe0cAz1MZ6Q-NsFFp7TNQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A178192CC41;
	Wed, 17 Feb 2021 15:34:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7988B60C62;
	Wed, 17 Feb 2021 15:34:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C96E957DF9;
	Wed, 17 Feb 2021 15:34:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 114IfcnU004097 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Feb 2021 13:41:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7572F2166B35; Thu,  4 Feb 2021 18:41:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 659932166B2F
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 18:41:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1623100EDBD
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 18:41:34 +0000 (UTC)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com
	[209.85.208.175]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-231-b7GSiPwnMWGAIo6EBck6Tw-1; Thu, 04 Feb 2021 13:41:32 -0500
X-MC-Unique: b7GSiPwnMWGAIo6EBck6Tw-1
Received: by mail-lj1-f175.google.com with SMTP id t8so4622474ljk.10
	for <dm-devel@redhat.com>; Thu, 04 Feb 2021 10:41:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=QilnL1GiLc35zL0JKgGqLLH0jCvxrl7AURnizvwxOrk=;
	b=tbA5GPico3kbJdhcV5HemT9QRDrPg0ep/KkxBygZZGohxbw3HLLYzy6SpY/SMXm0ap
	4bOM9iiO2jvh7X/6VMfLsyMTgeUpDIdGUa55iyKiQVYuLIIiJaOslyWmwqcmrtc4179r
	wdvhRkPTJmGuohH8EQhv9mZOWKOUZfHMh7IKw6liN35nsceBJmf0nukFR/JvLtddQ8ao
	M0+iG4WbKKAulvEkc9DxKT6jokwmXwgm8Pgr9xTh+yxNQW4cxpE/beWSYMa+cu/cBRjc
	LQbMYT0p6IjCG22Rf5u0UaXeCr/X1lVgZHYYJfGuAlRzqjI8zQYQxtfp6HpS0uon04FD
	TtSg==
X-Gm-Message-State: AOAM532v1UTBdUq2DXqy7iibPkX/W49kCmVHNRtHaKhBN9oyI+8gQuiK
	Bvx6ZJhkZhzg65ksnH5PVX12kvBQ7E1UesPZj+SUcw==
X-Google-Smtp-Source: ABdhPJwJtrhYEdPaQdR6fHW3cU2NP6bOoOiL2TtDHuAX1Y9bu5c2RTiAw480hYJajzznm79yfeZHPAMVBc9ok0h1jMo=
X-Received: by 2002:a2e:9b57:: with SMTP id o23mr427754ljj.314.1612464090601; 
	Thu, 04 Feb 2021 10:41:30 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
	<CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
	<20210203214448.2703930e@oasis.local.home>
	<20210204030948.dmsmwyw6fu5kzgey@treble>
In-Reply-To: <20210204030948.dmsmwyw6fu5kzgey@treble>
From: Ivan Babrou <ivan@cloudflare.com>
Date: Thu, 4 Feb 2021 10:41:18 -0800
Message-ID: <CABWYdi15x=-2qenWSdX_ONSha_Pz7GFJrx8axN6CJS5cWxTTSg@mail.gmail.com>
To: Josh Poimboeuf <jpoimboe@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 17 Feb 2021 10:31:26 -0500
Cc: Song Liu <songliubraving@fb.com>, Mike Snitzer <snitzer@redhat.com>,
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
	Steven Rostedt <rostedt@goodmis.org>,
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

On Wed, Feb 3, 2021 at 7:10 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> This line gives a big clue:
>
>   [160676.608966][    C4] RIP: 0010:0xffffffffc17d814c
>
> That address, without a function name, most likely means that it was
> running in some generated code (mostly likely BPF) when it got
> interrupted.

We do have eBPF/XDP in our environment.

> Right now, the ORC unwinder tries to fall back to frame pointers when it
> encounters generated code:
>
>         orc = orc_find(state->signal ? state->ip : state->ip - 1);
>         if (!orc)
>                 /*
>                  * As a fallback, try to assume this code uses a frame pointer.
>                  * This is useful for generated code, like BPF, which ORC
>                  * doesn't know about.  This is just a guess, so the rest of
>                  * the unwind is no longer considered reliable.
>                  */
>                 orc = &orc_fp_entry;
>                 state->error = true;
>         }
>
> Because the ORC unwinder is guessing from that point onward, it's
> possible for it to read the KASAN stack redzone, if the generated code
> hasn't set up frame pointers.  So the best fix may be for the unwinder
> to just always bypass KASAN when reading the stack.
>
> The unwinder has a mechanism for detecting and warning about
> out-of-bounds, and KASAN is short-circuiting that.
>
> This should hopefully get rid of *all* the KASAN unwinder warnings, both
> crypto and networking.

It definitely worked on my dm-crypt case, and I've tried it without
your previous AVX related patch. I will apply it to our tree and
deploy to the staging KASAN environment to see how it fares with
respect to networking stacks. Feel free to ping me if I don't get back
to you with the results on Monday.

Thanks for looking into this!

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


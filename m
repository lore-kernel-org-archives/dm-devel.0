Return-Path: <SRS0=5DIA=HG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7A88C433E0
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 09:14:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 317BB64DF2
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 09:14:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 317BB64DF2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-2rCaVYinPPusznZgHH59AA-1; Thu, 04 Feb 2021 04:14:49 -0500
X-MC-Unique: 2rCaVYinPPusznZgHH59AA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 934BE804036;
	Thu,  4 Feb 2021 09:14:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 510AF60C78;
	Thu,  4 Feb 2021 09:14:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B100918095CC;
	Thu,  4 Feb 2021 09:14:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 113MgExF028625 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Feb 2021 17:42:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 01B4FAE7A6; Wed,  3 Feb 2021 22:42:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F07C9F8965
	for <dm-devel@redhat.com>; Wed,  3 Feb 2021 22:42:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D388B858F13
	for <dm-devel@redhat.com>; Wed,  3 Feb 2021 22:42:09 +0000 (UTC)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com
	[209.85.208.181]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-498-H2k9E1c5P_-p8C99dlAyAQ-1; Wed, 03 Feb 2021 17:42:05 -0500
X-MC-Unique: H2k9E1c5P_-p8C99dlAyAQ-1
Received: by mail-lj1-f181.google.com with SMTP id f19so1031708ljn.5
	for <dm-devel@redhat.com>; Wed, 03 Feb 2021 14:42:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=FumwaWvzHZWVNE5DDIsNdn258CZK4DlZwzfhawRHFFU=;
	b=QikB80bGAB7QLD612AqIXSoDlq//UTw7NaHdTdFsTBKZmeeHu6jVBqQIyWuDU5cdeV
	h68c1F8YF3l+BEAa+yPn1OunXGXd+/XZJiYaXzOCvwL+evRK5Tpx9PFjAinxWHr92W5a
	pfmFoi6n36PYNEAAWSWZM566ir9tA33mtNr3u2x4xW5EZHGTgFlUk7ZQGTutPkWt3StM
	BNQz+JkMvapPXacIRg8e+lqbrJIpbqgjj1XYPBCVp/Vjmov+f45Fzm4Gykr3IHonlNTK
	PABXSE4XeGZQUaeTETIB41//Bms24bsuLsIcz4b1GjwevOO2XvaxXxiYe636sha4EuuP
	s1Sg==
X-Gm-Message-State: AOAM531dTu2q/UtjtCKcsmzI4PfBA8Prog18/JWg8z+ezhTN9L7F4QEj
	2n4nbWTxOG3dgYCDBtOJlwxsItQjKxdApfFtMBNp2w==
X-Google-Smtp-Source: ABdhPJwKhpR8sbJ8ZrHXrXvTED9hh5AbNkWxJFB2AjnN5UiHsFQgc7BNpiMd7cHW6zHpZnnJ9JFHzJh6we9lf652od8=
X-Received: by 2002:a2e:3a18:: with SMTP id h24mr2987085lja.170.1612392124007; 
	Wed, 03 Feb 2021 14:42:04 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
	<CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
	<YBrTaVVfWu2R0Hgw@hirez.programming.kicks-ass.net>
	<CABWYdi2ephz57BA8bns3reMGjvs5m0hYp82+jBLZ6KD3Ba6zdQ@mail.gmail.com>
	<20210203190518.nlwghesq75enas6n@treble>
In-Reply-To: <20210203190518.nlwghesq75enas6n@treble>
From: Ivan Babrou <ivan@cloudflare.com>
Date: Wed, 3 Feb 2021 14:41:53 -0800
Message-ID: <CABWYdi1ya41Ju9SsHMtRQaFQ=s8N23D3ADn6OV6iBwWM6H8=Zw@mail.gmail.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 3, 2021 at 11:05 AM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Wed, Feb 03, 2021 at 09:46:55AM -0800, Ivan Babrou wrote:
> > > Can you pretty please not line-wrap console output? It's unreadable.
> >
> > GMail doesn't make it easy, I'll send a link to a pastebin next time.
> > Let me know if you'd like me to regenerate the decoded stack.
> >
> > > > edfd9b7838ba5e47f19ad8466d0565aba5c59bf0 is the first bad commit
> > > > commit edfd9b7838ba5e47f19ad8466d0565aba5c59bf0
> > >
> > > Not sure what tree you're on, but that's not the upstream commit.
> >
> > I mentioned that it's a rebased core-static_call-2020-10-12 tag and
> > added a link to the upstream hash right below.
> >
> > > > Author: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > > > Date:   Tue Aug 18 15:57:52 2020 +0200
> > > >
> > > >     tracepoint: Optimize using static_call()
> > > >
> > >
> > > There's a known issue with that patch, can you try:
> > >
> > >   http://lkml.kernel.org/r/20210202220121.435051654@goodmis.org
> >
> > I've tried it on top of core-static_call-2020-10-12 tag rebased on top
> > of v5.9 (to make it reproducible), and the patch did not help. Do I
> > need to apply the whole series or something else?
>
> Can you recreate with this patch, and add "unwind_debug" to the cmdline?
> It will spit out a bunch of stack data.

Here's the three I'm building:

* https://github.com/bobrik/linux/tree/ivan/static-call-5.9

It contains:

* v5.9 tag as the base
* static_call-2020-10-12 tag
* dm-crypt patches to reproduce the issue with KASAN
* x86/unwind: Add 'unwind_debug' cmdline option
* tracepoint: Fix race between tracing and removing tracepoint

The very same issue can be reproduced on 5.10.11 with no patches,
but I'm going with 5.9, since it boils down to static call changes.

Here's the decoded stack from the kernel with unwind debug enabled:

* https://gist.github.com/bobrik/ed052ac0ae44c880f3170299ad4af56b

See my first email for the exact commands that trigger this.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


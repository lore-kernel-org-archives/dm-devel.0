Return-Path: <SRS0=5DIA=HG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 903EEC433E0
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 09:15:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A864264F4E
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 09:15:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A864264F4E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-9rYgNdvlM6-iyXCbmAXMdQ-1; Thu, 04 Feb 2021 04:15:07 -0500
X-MC-Unique: 9rYgNdvlM6-iyXCbmAXMdQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B44F1020C24;
	Thu,  4 Feb 2021 09:15:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EFDBE60C6C;
	Thu,  4 Feb 2021 09:15:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BF5019968;
	Thu,  4 Feb 2021 09:15:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 113NUqef002113 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Feb 2021 18:30:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DBBE0F8855; Wed,  3 Feb 2021 23:30:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D6690F8960
	for <dm-devel@redhat.com>; Wed,  3 Feb 2021 23:30:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2718858285
	for <dm-devel@redhat.com>; Wed,  3 Feb 2021 23:30:51 +0000 (UTC)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com
	[209.85.167.54]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-600-tnoeTw5IPlKC2aPpe9k9pg-1; Wed, 03 Feb 2021 18:30:48 -0500
X-MC-Unique: tnoeTw5IPlKC2aPpe9k9pg-1
Received: by mail-lf1-f54.google.com with SMTP id b2so1803106lfq.0
	for <dm-devel@redhat.com>; Wed, 03 Feb 2021 15:30:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=hocG39X+tz3ResWtWHRihYuESyyVfrOSMJOVeII1Yr4=;
	b=Q/4HEkTo3ZC1Aovkaazww0LSrtZ4KyqFzwK1uhlJAJ4qFej42j5NkRZ1v0CZ6aMep3
	EvOLyHthKu8mafj+ytBxnFaFet+32H/vwv62FmGCTV2mpE7Env0dksYtk6triV3Jn1R6
	BtPZrG89a+XTWCkfqLTM4AxTMOotUq+gw1j7yxIE4x+mGRQcHvAAKA2zttCNotAmKByX
	dRbvXI7x9sfq62ksSfaCLY8F13slzOuWjozZv8zkdkSEQXzCb+GLGUHAsjAW7O7rm2tC
	kqd4k43YwPIQoBZhNv7mJ4EQNwqnXBQ6rYr6irvZFmiWA+gLPTegnr4WHox6Nx+s62wi
	/ZFw==
X-Gm-Message-State: AOAM532hoMXi1IINGGfrBFDvTVYM06MhyQ0Ry/zB0JhWTi2au5sG/gFt
	ZDW2YozMSCj0WcEPbtCXxhMcYuFqXwHCchOzcXiMYQ==
X-Google-Smtp-Source: ABdhPJzbFmqPihDILaKPbxSIRixPFUKsm+fHSPEx84ybzWmcQv7Bntw5LfHY0c2uhOLwPSkdaL1onJaSKOpKqElh5Uo=
X-Received: by 2002:a05:6512:3904:: with SMTP id
	a4mr2912750lfu.340.1612395046510; 
	Wed, 03 Feb 2021 15:30:46 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
	<CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
	<YBrTaVVfWu2R0Hgw@hirez.programming.kicks-ass.net>
	<CABWYdi2ephz57BA8bns3reMGjvs5m0hYp82+jBLZ6KD3Ba6zdQ@mail.gmail.com>
	<20210203190518.nlwghesq75enas6n@treble>
	<CABWYdi1ya41Ju9SsHMtRQaFQ=s8N23D3ADn6OV6iBwWM6H8=Zw@mail.gmail.com>
	<20210203232735.nw73kugja56jp4ls@treble>
In-Reply-To: <20210203232735.nw73kugja56jp4ls@treble>
From: Ivan Babrou <ivan@cloudflare.com>
Date: Wed, 3 Feb 2021 15:30:35 -0800
Message-ID: <CABWYdi1zd51Jb35taWeGC-dR9SChq-4ixvyKms3KOKgV0idfPg@mail.gmail.com>
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

On Wed, Feb 3, 2021 at 3:28 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Wed, Feb 03, 2021 at 02:41:53PM -0800, Ivan Babrou wrote:
> > On Wed, Feb 3, 2021 at 11:05 AM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > >
> > > On Wed, Feb 03, 2021 at 09:46:55AM -0800, Ivan Babrou wrote:
> > > > > Can you pretty please not line-wrap console output? It's unreadable.
> > > >
> > > > GMail doesn't make it easy, I'll send a link to a pastebin next time.
> > > > Let me know if you'd like me to regenerate the decoded stack.
> > > >
> > > > > > edfd9b7838ba5e47f19ad8466d0565aba5c59bf0 is the first bad commit
> > > > > > commit edfd9b7838ba5e47f19ad8466d0565aba5c59bf0
> > > > >
> > > > > Not sure what tree you're on, but that's not the upstream commit.
> > > >
> > > > I mentioned that it's a rebased core-static_call-2020-10-12 tag and
> > > > added a link to the upstream hash right below.
> > > >
> > > > > > Author: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > > > > > Date:   Tue Aug 18 15:57:52 2020 +0200
> > > > > >
> > > > > >     tracepoint: Optimize using static_call()
> > > > > >
> > > > >
> > > > > There's a known issue with that patch, can you try:
> > > > >
> > > > >   http://lkml.kernel.org/r/20210202220121.435051654@goodmis.org
> > > >
> > > > I've tried it on top of core-static_call-2020-10-12 tag rebased on top
> > > > of v5.9 (to make it reproducible), and the patch did not help. Do I
> > > > need to apply the whole series or something else?
> > >
> > > Can you recreate with this patch, and add "unwind_debug" to the cmdline?
> > > It will spit out a bunch of stack data.
> >
> > Here's the three I'm building:
> >
> > * https://github.com/bobrik/linux/tree/ivan/static-call-5.9
> >
> > It contains:
> >
> > * v5.9 tag as the base
> > * static_call-2020-10-12 tag
> > * dm-crypt patches to reproduce the issue with KASAN
> > * x86/unwind: Add 'unwind_debug' cmdline option
> > * tracepoint: Fix race between tracing and removing tracepoint
> >
> > The very same issue can be reproduced on 5.10.11 with no patches,
> > but I'm going with 5.9, since it boils down to static call changes.
> >
> > Here's the decoded stack from the kernel with unwind debug enabled:
> >
> > * https://gist.github.com/bobrik/ed052ac0ae44c880f3170299ad4af56b
> >
> > See my first email for the exact commands that trigger this.
>
> Thanks.  Do you happen to have the original dmesg, before running it
> through the post-processing script?

Yes, here it is:

* https://gist.github.com/bobrik/8c13e6a02555fb21cadabb74cdd6f9ab

> I assume you're using decode_stacktrace.sh?  It could use some
> improvement, it's stripping the function offset.
>
> Also spaces are getting inserted in odd places, messing the alignment.
>
> [  137.291837][    C0] ffff88809c409858: d7c4f3ce817a1700 (0xd7c4f3ce817a1700)
> [  137.291837][    C0] ffff88809c409860: 0000000000000000 (0x0)
> [  137.291839][    C0] ffff88809c409868: 00000000ffffffff (0xffffffff)
> [ 137.291841][ C0] ffff88809c409870: ffffffffa4f01a52 unwind_next_frame (arch/x86/kernel/unwind_orc.c:380 arch/x86/kernel/unwind_orc.c:553)
> [ 137.291843][ C0] ffff88809c409878: ffffffffa4f01a52 unwind_next_frame (arch/x86/kernel/unwind_orc.c:380 arch/x86/kernel/unwind_orc.c:553)
> [  137.291844][    C0] ffff88809c409880: ffff88809c409ac8 (0xffff88809c409ac8)
> [  137.291845][    C0] ffff88809c409888: 0000000000000086 (0x86)
>
> --
> Josh
>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


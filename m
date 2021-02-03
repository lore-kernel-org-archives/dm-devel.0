Return-Path: <SRS0=5DIA=HG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE0EC433DB
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 09:15:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2720A64F4E
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 09:15:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2720A64F4E
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
	bh=BqDHUiTu75wYRoumjG4PDLTX2+oN4ZRfrXKL1D5G5qg=;
	b=VZSbeP9XSMLcWytlPtSAUaiz3PAN0/LTQy+iYPa/VEp2DIfgB0OQ5oi8rxCzwwIgAmjacp
	imTXRoQtQZeZJSAR0vbc5RGG5Z8KaLyb3PhPZEVQZtBk5AHLvHa0iIOVbkB6pmmU6ZybU1
	o7uPsaWwvj71cKJdAZHeYo5I76fBDXs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-Vj8blPh9P36gdcjbMGeGJg-1; Thu, 04 Feb 2021 04:15:03 -0500
X-MC-Unique: Vj8blPh9P36gdcjbMGeGJg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB9F8804036;
	Thu,  4 Feb 2021 09:14:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CB7610016FB;
	Thu,  4 Feb 2021 09:14:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5D76E1809C90;
	Thu,  4 Feb 2021 09:14:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 113NRtoH001837 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Feb 2021 18:27:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E895F57; Wed,  3 Feb 2021 23:27:55 +0000 (UTC)
Received: from treble (ovpn-113-81.rdu2.redhat.com [10.10.113.81])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 27B245C1B4;
	Wed,  3 Feb 2021 23:27:44 +0000 (UTC)
Date: Wed, 3 Feb 2021 17:27:35 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Ivan Babrou <ivan@cloudflare.com>
Message-ID: <20210203232735.nw73kugja56jp4ls@treble>
References: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
	<CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
	<YBrTaVVfWu2R0Hgw@hirez.programming.kicks-ass.net>
	<CABWYdi2ephz57BA8bns3reMGjvs5m0hYp82+jBLZ6KD3Ba6zdQ@mail.gmail.com>
	<20210203190518.nlwghesq75enas6n@treble>
	<CABWYdi1ya41Ju9SsHMtRQaFQ=s8N23D3ADn6OV6iBwWM6H8=Zw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CABWYdi1ya41Ju9SsHMtRQaFQ=s8N23D3ADn6OV6iBwWM6H8=Zw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

On Wed, Feb 03, 2021 at 02:41:53PM -0800, Ivan Babrou wrote:
> On Wed, Feb 3, 2021 at 11:05 AM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> >
> > On Wed, Feb 03, 2021 at 09:46:55AM -0800, Ivan Babrou wrote:
> > > > Can you pretty please not line-wrap console output? It's unreadable.
> > >
> > > GMail doesn't make it easy, I'll send a link to a pastebin next time.
> > > Let me know if you'd like me to regenerate the decoded stack.
> > >
> > > > > edfd9b7838ba5e47f19ad8466d0565aba5c59bf0 is the first bad commit
> > > > > commit edfd9b7838ba5e47f19ad8466d0565aba5c59bf0
> > > >
> > > > Not sure what tree you're on, but that's not the upstream commit.
> > >
> > > I mentioned that it's a rebased core-static_call-2020-10-12 tag and
> > > added a link to the upstream hash right below.
> > >
> > > > > Author: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > > > > Date:   Tue Aug 18 15:57:52 2020 +0200
> > > > >
> > > > >     tracepoint: Optimize using static_call()
> > > > >
> > > >
> > > > There's a known issue with that patch, can you try:
> > > >
> > > >   http://lkml.kernel.org/r/20210202220121.435051654@goodmis.org
> > >
> > > I've tried it on top of core-static_call-2020-10-12 tag rebased on top
> > > of v5.9 (to make it reproducible), and the patch did not help. Do I
> > > need to apply the whole series or something else?
> >
> > Can you recreate with this patch, and add "unwind_debug" to the cmdline?
> > It will spit out a bunch of stack data.
> 
> Here's the three I'm building:
> 
> * https://github.com/bobrik/linux/tree/ivan/static-call-5.9
> 
> It contains:
> 
> * v5.9 tag as the base
> * static_call-2020-10-12 tag
> * dm-crypt patches to reproduce the issue with KASAN
> * x86/unwind: Add 'unwind_debug' cmdline option
> * tracepoint: Fix race between tracing and removing tracepoint
> 
> The very same issue can be reproduced on 5.10.11 with no patches,
> but I'm going with 5.9, since it boils down to static call changes.
> 
> Here's the decoded stack from the kernel with unwind debug enabled:
> 
> * https://gist.github.com/bobrik/ed052ac0ae44c880f3170299ad4af56b
> 
> See my first email for the exact commands that trigger this.

Thanks.  Do you happen to have the original dmesg, before running it
through the post-processing script?


I assume you're using decode_stacktrace.sh?  It could use some
improvement, it's stripping the function offset.

Also spaces are getting inserted in odd places, messing the alignment.

[  137.291837][    C0] ffff88809c409858: d7c4f3ce817a1700 (0xd7c4f3ce817a1700)
[  137.291837][    C0] ffff88809c409860: 0000000000000000 (0x0)
[  137.291839][    C0] ffff88809c409868: 00000000ffffffff (0xffffffff)
[ 137.291841][ C0] ffff88809c409870: ffffffffa4f01a52 unwind_next_frame (arch/x86/kernel/unwind_orc.c:380 arch/x86/kernel/unwind_orc.c:553)
[ 137.291843][ C0] ffff88809c409878: ffffffffa4f01a52 unwind_next_frame (arch/x86/kernel/unwind_orc.c:380 arch/x86/kernel/unwind_orc.c:553)
[  137.291844][    C0] ffff88809c409880: ffff88809c409ac8 (0xffff88809c409ac8)
[  137.291845][    C0] ffff88809c409888: 0000000000000086 (0x86)

-- 
Josh

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


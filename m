Return-Path: <SRS0=5DIA=HG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D83C433E6
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 09:14:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1456C64E34
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 09:14:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1456C64E34
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-WttNZ2YaMlOODKOIqB3HGg-1; Thu, 04 Feb 2021 04:14:49 -0500
X-MC-Unique: WttNZ2YaMlOODKOIqB3HGg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 898261020C24;
	Thu,  4 Feb 2021 09:14:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 374D960C73;
	Thu,  4 Feb 2021 09:14:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D678918095CD;
	Thu,  4 Feb 2021 09:14:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 113HlEOT026008 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Feb 2021 12:47:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id ECE01114B31E; Wed,  3 Feb 2021 17:47:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E6F8A10FD2B5
	for <dm-devel@redhat.com>; Wed,  3 Feb 2021 17:47:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FC05811E87
	for <dm-devel@redhat.com>; Wed,  3 Feb 2021 17:47:10 +0000 (UTC)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com
	[209.85.208.171]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-284-qfwY2OSMNCSgTdznfwLdsw-1; Wed, 03 Feb 2021 12:47:08 -0500
X-MC-Unique: qfwY2OSMNCSgTdznfwLdsw-1
Received: by mail-lj1-f171.google.com with SMTP id b20so85947ljo.1
	for <dm-devel@redhat.com>; Wed, 03 Feb 2021 09:47:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=0Sd7lpuzzYzAe84omnrWYz0GYPR/9/jZDwcpOZKoCos=;
	b=BVIH7qHY6zRjk0Nk552YTbcHgep+y8tqyd5Oln2gTziGANMEwpriV3txV+w6RYKmLF
	usAsvc7FsQ2EwaQ8ybmiIZvyJt3RUFRPyCtyulpJdrZFUwVEp3mLSdtMDXTpBL2H3gqA
	Ezzxz/nKJZH38xHeGU7LRvFMfPdRt0RZ5V8udw04nk9UYvdd9XcmfgZYT7gMrS97tFlO
	ms2PRiWSjOO3GB9pYCwS/E/2wc05zK0vZtgXNsSJbUueaTnAzBGNkwYclHzHxzL3ZKIk
	+Ej9zHaegwXLUu5QuRIo1chD/82DvOZGYxo7XC0b0tIlThPF8q+qSnG7nlVuRHYpHNMj
	rv7g==
X-Gm-Message-State: AOAM530FtF92xQiTnfrwmNhiZ9K+opvk/OP2Ts5j5dLe/hVEWIjuHViq
	OZMeH2s8WaXDj1FKhXNDGMfzU1iGEdIU+YcXYtr1qw==
X-Google-Smtp-Source: ABdhPJzdVb3Jed1F5NgGdDtfAd5oNibLzyOzFOWG4eVNHu9dYMCxEE44x+nn5372HQ8P/nr1dxBBfvSeiQCWg8NBeQU=
X-Received: by 2002:a2e:9cc8:: with SMTP id g8mr2376414ljj.479.1612374426835; 
	Wed, 03 Feb 2021 09:47:06 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
	<CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
	<YBrTaVVfWu2R0Hgw@hirez.programming.kicks-ass.net>
In-Reply-To: <YBrTaVVfWu2R0Hgw@hirez.programming.kicks-ass.net>
From: Ivan Babrou <ivan@cloudflare.com>
Date: Wed, 3 Feb 2021 09:46:55 -0800
Message-ID: <CABWYdi2ephz57BA8bns3reMGjvs5m0hYp82+jBLZ6KD3Ba6zdQ@mail.gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
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
X-Mailman-Approved-At: Thu, 04 Feb 2021 04:14:38 -0500
Cc: Song Liu <songliubraving@fb.com>, Mike Snitzer <snitzer@redhat.com>,
	Alexey Kardashevskiy <aik@ozlabs.ru>, Yonghong Song <yhs@fb.com>,
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
	Borislav Petkov <bp@alien8.de>, Josh Poimboeuf <jpoimboe@redhat.com>,
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

> Can you pretty please not line-wrap console output? It's unreadable.

GMail doesn't make it easy, I'll send a link to a pastebin next time.
Let me know if you'd like me to regenerate the decoded stack.

> > edfd9b7838ba5e47f19ad8466d0565aba5c59bf0 is the first bad commit
> > commit edfd9b7838ba5e47f19ad8466d0565aba5c59bf0
>
> Not sure what tree you're on, but that's not the upstream commit.

I mentioned that it's a rebased core-static_call-2020-10-12 tag and
added a link to the upstream hash right below.

> > Author: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > Date:   Tue Aug 18 15:57:52 2020 +0200
> >
> >     tracepoint: Optimize using static_call()
> >
>
> There's a known issue with that patch, can you try:
>
>   http://lkml.kernel.org/r/20210202220121.435051654@goodmis.org

I've tried it on top of core-static_call-2020-10-12 tag rebased on top
of v5.9 (to make it reproducible), and the patch did not help. Do I
need to apply the whole series or something else?

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


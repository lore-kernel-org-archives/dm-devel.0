Return-Path: <SRS0=5DIA=HG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BEE1C433DB
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 11:06:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E5F1464DE1
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 11:06:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5F1464DE1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-66wPOT2iPXuVzrN_YBWrEg-1; Thu, 04 Feb 2021 06:06:18 -0500
X-MC-Unique: 66wPOT2iPXuVzrN_YBWrEg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D837A107ACE4;
	Thu,  4 Feb 2021 11:06:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BCF8100164C;
	Thu,  4 Feb 2021 11:06:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6B81D58074;
	Thu,  4 Feb 2021 11:06:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 114B679w003918 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Feb 2021 06:06:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D4AB92026D13; Thu,  4 Feb 2021 11:06:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CECB82026D48
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 11:05:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 76193800C44
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 11:05:59 +0000 (UTC)
Received: from merlin.infradead.org (merlin.infradead.org [205.233.59.134])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-280-vYqNKCVFPV-kfWYm0oZOLA-1; Thu, 04 Feb 2021 06:05:57 -0500
X-MC-Unique: vYqNKCVFPV-kfWYm0oZOLA-1
Received: from j217100.upc-j.chello.nl ([24.132.217.100]
	helo=noisy.programming.kicks-ass.net)
	by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1l7aqj-0008Nd-U9; Thu, 04 Feb 2021 09:22:54 +0000
Received: from hirez.programming.kicks-ass.net
	(hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 385F2301A32;
	Thu,  4 Feb 2021 10:22:48 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id 15BDD213D2E27; Thu,  4 Feb 2021 10:22:48 +0100 (CET)
Date: Thu, 4 Feb 2021 10:22:48 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ivan Babrou <ivan@cloudflare.com>
Message-ID: <YBu86G1ckCckRyim@hirez.programming.kicks-ass.net>
References: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
	<CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
	<YBrTaVVfWu2R0Hgw@hirez.programming.kicks-ass.net>
	<CABWYdi2ephz57BA8bns3reMGjvs5m0hYp82+jBLZ6KD3Ba6zdQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CABWYdi2ephz57BA8bns3reMGjvs5m0hYp82+jBLZ6KD3Ba6zdQ@mail.gmail.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

Not my problem that you can't use email proper. Links go in the
bitbucket. Either its in the email or it don't exist.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


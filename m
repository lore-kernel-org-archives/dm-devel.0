Return-Path: <SRS0=6AeK=K5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6317BC47082
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 06:33:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 08DAB610CB
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 06:33:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08DAB610CB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-G07IV2A0OwSJkMmvsLZFFQ-1; Thu, 03 Jun 2021 02:33:35 -0400
X-MC-Unique: G07IV2A0OwSJkMmvsLZFFQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83CF0108BD0C;
	Thu,  3 Jun 2021 06:33:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 66047610B0;
	Thu,  3 Jun 2021 06:33:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 33504180C69B;
	Thu,  3 Jun 2021 06:33:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 152GlhQY001978 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Jun 2021 12:47:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B2487208D055; Wed,  2 Jun 2021 16:47:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AD571208DD8F
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 16:47:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 628CC10334A4
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 16:47:40 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-282-a7e8u1zPPqiz5exh8pCAVg-1; Wed, 02 Jun 2021 12:47:32 -0400
X-MC-Unique: a7e8u1zPPqiz5exh8pCAVg-1
Received: from j217100.upc-j.chello.nl ([24.132.217.100]
	helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1loU0Z-00BKKZ-9j; Wed, 02 Jun 2021 16:46:22 +0000
Received: from hirez.programming.kicks-ass.net
	(hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A2E72300091;
	Wed,  2 Jun 2021 18:46:16 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id 8A73D2016D6DD; Wed,  2 Jun 2021 18:46:16 +0200 (CEST)
Date: Wed, 2 Jun 2021 18:46:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will@kernel.org>
Message-ID: <YLe12Ba4CrvhMhFI@hirez.programming.kicks-ass.net>
References: <20210602131225.336600299@infradead.org>
	<20210602133040.334970485@infradead.org>
	<20210602145921.GB31179@willie-the-truck>
MIME-Version: 1.0
In-Reply-To: <20210602145921.GB31179@willie-the-truck>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 03 Jun 2021 02:32:49 -0400
Cc: Juri Lelli <juri.lelli@redhat.com>, Mark Rutland <mark.rutland@arm.com>,
	Pavel Machek <pavel@ucw.cz>, Mike Snitzer <snitzer@redhat.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	kgdb-bugreport@lists.sourceforge.net,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>, Ben Segall <bsegall@google.com>,
	linux-mm@kvack.org, dm-devel@redhat.com,
	Paolo Bonzini <pbonzini@redhat.com>, Zefan Li <lizefan.x@bytedance.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Joel Fernandes <joel@joelfernandes.org>, netdev@vger.kernel.org,
	Jiri Olsa <jolsa@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	kvm@vger.kernel.org, cgroups@vger.kernel.org, x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>, Mel Gorman <mgorman@suse.de>,
	Jakub Kicinski <kuba@kernel.org>, John Stultz <john.stultz@linaro.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	linux-pm@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>,
	Jason Wessel <jason.wessel@windriver.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Borislav Petkov <bp@alien8.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Waiman Long <longman@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Jens Axboe <axboe@kernel.dk>, Felipe Balbi <balbi@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Douglas Anderson <dianders@chromium.org>,
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>, rcu@vger.kernel.org,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [dm-devel] [PATCH 2/6] sched: Introduce task_is_running()
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 02, 2021 at 03:59:21PM +0100, Will Deacon wrote:
> On Wed, Jun 02, 2021 at 03:12:27PM +0200, Peter Zijlstra wrote:
> > Replace a bunch of 'p->state == TASK_RUNNING' with a new helper:
> > task_is_running(p).
> > 
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> >  arch/x86/kernel/process.c |    4 ++--
> >  block/blk-mq.c            |    2 +-
> >  include/linux/sched.h     |    2 ++
> >  kernel/locking/lockdep.c  |    2 +-
> >  kernel/rcu/tree_plugin.h  |    2 +-
> >  kernel/sched/core.c       |    6 +++---
> >  kernel/sched/stats.h      |    2 +-
> >  kernel/signal.c           |    2 +-
> >  kernel/softirq.c          |    3 +--
> >  mm/compaction.c           |    2 +-
> >  10 files changed, 14 insertions(+), 13 deletions(-)
> > 
> > --- a/arch/x86/kernel/process.c
> > +++ b/arch/x86/kernel/process.c
> > @@ -931,7 +931,7 @@ unsigned long get_wchan(struct task_stru
> >  	unsigned long start, bottom, top, sp, fp, ip, ret = 0;
> >  	int count = 0;
> >  
> > -	if (p == current || p->state == TASK_RUNNING)
> > +	if (p == current || task_is_running(p))
> 
> Looks like this one in get_wchan() has been cargo-culted across most of
> arch/ so they'll need fixing up before you rename the struct member.

Yeah, this was x86_64 allmodconfig driven, I've already got a bunch of
robot mail telling me other archs need help, I'll fix it iup.

> There's also a weird one in tools/bpf/runqslower/runqslower.bpf.c (!)

I'm tempted to let the bpf people sort their own gunk. This is not an
ABI. I so don't care breaking every script out there.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


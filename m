Return-Path: <SRS0=BzfN=LC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84FFEC4743F
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 06:29:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 156826136D
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 06:29:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 156826136D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-P55Ni9cZNK6nZyUT8vCbdA-1; Tue, 08 Jun 2021 02:29:14 -0400
X-MC-Unique: P55Ni9cZNK6nZyUT8vCbdA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFE131854E29;
	Tue,  8 Jun 2021 06:29:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 813885D9D5;
	Tue,  8 Jun 2021 06:29:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 14EED1801268;
	Tue,  8 Jun 2021 06:29:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 157BC2x6016363 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Jun 2021 07:12:02 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A326F1111C7D; Mon,  7 Jun 2021 11:12:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EE8F1111C79
	for <dm-devel@redhat.com>; Mon,  7 Jun 2021 11:12:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07F5D805C1D
	for <dm-devel@redhat.com>; Mon,  7 Jun 2021 11:12:00 +0000 (UTC)
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-431-OgrR-Ll5P9mT3UwaBp5RpQ-1; Mon, 07 Jun 2021 07:11:56 -0400
X-MC-Unique: OgrR-Ll5P9mT3UwaBp5RpQ-1
Received: from j217100.upc-j.chello.nl ([24.132.217.100]
	helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1lqD9a-004Mvt-Aj; Mon, 07 Jun 2021 11:10:53 +0000
Received: from hirez.programming.kicks-ass.net
	(hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 12A093002CA;
	Mon,  7 Jun 2021 13:10:49 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id A8BB82CF3852B; Mon,  7 Jun 2021 13:10:49 +0200 (CEST)
Date: Mon, 7 Jun 2021 13:10:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Message-ID: <YL3+ucpG/LOcO35G@hirez.programming.kicks-ass.net>
References: <20210602131225.336600299@infradead.org>
	<20210602133040.587042016@infradead.org>
	<20210607104500.sopvslejuoxwzhrs@maple.lan>
MIME-Version: 1.0
In-Reply-To: <20210607104500.sopvslejuoxwzhrs@maple.lan>
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
X-Mailman-Approved-At: Tue, 08 Jun 2021 02:28:51 -0400
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
	Davidlohr Bueso <dave@stgolabs.net>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org, x86@kernel.org,
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
Subject: Re: [dm-devel] [PATCH 6/6] sched: Change task_struct::state
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jun 07, 2021 at 11:45:00AM +0100, Daniel Thompson wrote:
> On Wed, Jun 02, 2021 at 03:12:31PM +0200, Peter Zijlstra wrote:
> > Change the type and name of task_struct::state. Drop the volatile and
> > shrink it to an 'unsigned int'. Rename it in order to find all uses
> > such that we can use READ_ONCE/WRITE_ONCE as appropriate.
> > 
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> >  ...
> >  kernel/debug/kdb/kdb_support.c |   18 +++++++------
> >  ...
> > --- a/kernel/debug/kdb/kdb_support.c
> > +++ b/kernel/debug/kdb/kdb_support.c
> > @@ -609,23 +609,25 @@ unsigned long kdb_task_state_string(cons
> >   */
> >  char kdb_task_state_char (const struct task_struct *p)
> >  {
> > -	int cpu;
> > -	char state;
> > +	unsigned int p_state;
> >  	unsigned long tmp;
> > +	char state;
> > +	int cpu;
> >  
> >  	if (!p ||
> >  	    copy_from_kernel_nofault(&tmp, (char *)p, sizeof(unsigned long)))
> >  		return 'E';
> >  
> >  	cpu = kdb_process_cpu(p);
> > -	state = (p->state == 0) ? 'R' :
> > -		(p->state < 0) ? 'U' :
> > -		(p->state & TASK_UNINTERRUPTIBLE) ? 'D' :
> > -		(p->state & TASK_STOPPED) ? 'T' :
> > -		(p->state & TASK_TRACED) ? 'C' :
> > +	p_state = READ_ONCE(p->__state);
> > +	state = (p_state == 0) ? 'R' :
> > +		(p_state < 0) ? 'U' :
> 
> Looks like the U here stands for Unreachable since this patch makes it
> more obvious that this clause is (and previously was) exactly that!
> 
> Dropping the U state would be good since I guess this will show up as a
> "new" warning in some tools. However it was a preexisting problem so with
> or without this cleaned up:
> Acked-by: Daniel Thompson <daniel.thompson@linaro.org>

Thanks!

Note that there's a second instance of this exact code in
arch/powerpc/xmon/xmon.c, with the same 'U' issue.

I'll repost this soon, as it seems I've fixed all robot failout (fingers
crossed).

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


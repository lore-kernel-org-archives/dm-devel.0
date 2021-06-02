Return-Path: <SRS0=6AeK=K5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A68C47082
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 06:34:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 137876140B
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 06:33:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 137876140B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-UblY9Co9NieKQC3gO4JAfw-1; Thu, 03 Jun 2021 02:33:28 -0400
X-MC-Unique: UblY9Co9NieKQC3gO4JAfw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EDB208042C6;
	Thu,  3 Jun 2021 06:33:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BDA65D76F;
	Thu,  3 Jun 2021 06:33:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2AB7C44A5F;
	Thu,  3 Jun 2021 06:33:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 152EcVX2002892 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Jun 2021 10:38:31 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4BDD1114B307; Wed,  2 Jun 2021 14:38:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 480CC103F279
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 14:38:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99AAA90DE2F
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 14:38:27 +0000 (UTC)
Received: from foss.arm.com (foss.arm.com [217.140.110.172]) by
	relay.mimecast.com with ESMTP id us-mta-191-W3Cs-bCFNVeZtp01ft4ZYQ-1;
	Wed, 02 Jun 2021 10:38:23 -0400
X-MC-Unique: W3Cs-bCFNVeZtp01ft4ZYQ-1
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35C8D1042;
	Wed,  2 Jun 2021 07:30:32 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.31.212])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D16593F73D;
	Wed,  2 Jun 2021 07:30:19 -0700 (PDT)
Date: Wed, 2 Jun 2021 15:30:16 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20210602143016.GE12753@C02TD0UTHF1T.local>
References: <20210602131225.336600299@infradead.org>
	<20210602133040.398289363@infradead.org>
	<1873020549.5854.1622642347895.JavaMail.zimbra@efficios.com>
	<YLeRVQbXt2hCiO8f@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
In-Reply-To: <YLeRVQbXt2hCiO8f@hirez.programming.kicks-ass.net>
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
X-Mailman-Approved-At: Thu, 03 Jun 2021 02:32:49 -0400
Cc: Juri Lelli <juri.lelli@redhat.com>, Pavel Machek <pavel@ucw.cz>,
	Mike Snitzer <snitzer@redhat.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	kgdb-bugreport@lists.sourceforge.net,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>, Ben Segall <bsegall@google.com>,
	linux-mm <linux-mm@kvack.org>, dm-devel@redhat.com,
	Paolo Bonzini <pbonzini@redhat.com>, Zefan Li <lizefan.x@bytedance.com>,
	"H. Peter Anvin" <hpa@zytor.com>, "Joel Fernandes,
	Google" <joel@joelfernandes.org>,
	netdev <netdev@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
	Alasdair Kergon <agk@redhat.com>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	KVM list <kvm@vger.kernel.org>, Will Deacon <will@kernel.org>,
	cgroups <cgroups@vger.kernel.org>, x86 <x86@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Mel Gorman <mgorman@suse.de>,
	Jakub Kicinski <kuba@kernel.org>, John Stultz <john.stultz@linaro.org>,
	paulmck <paulmck@kernel.org>, linux-pm@vger.kernel.org,
	Boqun Feng <boqun.feng@gmail.com>,
	Jason Wessel <jason.wessel@windriver.com>,
	Josh Triplett <josh@joshtriplett.org>,
	rostedt <rostedt@goodmis.org>, linux-block@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Waiman Long <longman@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, acme <acme@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Jens Axboe <axboe@kernel.dk>, Felipe Balbi <balbi@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Douglas Anderson <dianders@chromium.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-perf-users@vger.kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
	Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>,
	rcu <rcu@vger.kernel.org>, bristot <bristot@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [dm-devel] [PATCH 3/6] sched, perf,
	kvm: Fix preemption condition
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 02, 2021 at 04:10:29PM +0200, Peter Zijlstra wrote:
> On Wed, Jun 02, 2021 at 09:59:07AM -0400, Mathieu Desnoyers wrote:
> > ----- On Jun 2, 2021, at 9:12 AM, Peter Zijlstra peterz@infradead.org wrote:
> > 
> > > When ran from the sched-out path (preempt_notifier or perf_event),
> > > p->state is irrelevant to determine preemption. You can get preempted
> > > with !task_is_running() just fine.
> > > 
> > > The right indicator for preemption is if the task is still on the
> > > runqueue in the sched-out path.
> > > 
> > > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > > ---
> > > kernel/events/core.c |    7 +++----
> > > virt/kvm/kvm_main.c  |    2 +-
> > > 2 files changed, 4 insertions(+), 5 deletions(-)
> > > 
> > > --- a/kernel/events/core.c
> > > +++ b/kernel/events/core.c
> > > @@ -8568,13 +8568,12 @@ static void perf_event_switch(struct tas
> > > 		},
> > > 	};
> > > 
> > > -	if (!sched_in && task->state == TASK_RUNNING)
> > > +	if (!sched_in && current->on_rq) {
> > 
> > This changes from checking task->state to current->on_rq, but this change
> > from "task" to "current" is not described in the commit message, which is odd.
> > 
> > Are we really sure that task == current here ?
> 
> Yeah, @task == @prev == current at this point, but yes, not sure why I
> changed that... lemme change that back to task.

FWIW, with that:

Acked-by: Mark Rutland <mark.rutland@arm.com>

I have no strong feelings either way w.r.t. the whitespace cleanup. ;)

Thanks,
Mark

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=6AeK=K5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3539CC47096
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 06:33:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BABBF61263
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 06:33:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BABBF61263
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-wEJIpjnHNkyYLvfMothdkg-1; Thu, 03 Jun 2021 02:33:19 -0400
X-MC-Unique: wEJIpjnHNkyYLvfMothdkg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24F5A80362A;
	Thu,  3 Jun 2021 06:33:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 041E139A61;
	Thu,  3 Jun 2021 06:33:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CB7C044A5B;
	Thu,  3 Jun 2021 06:33:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 152ELHTo032372 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Jun 2021 10:21:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8EBA9BE5CE; Wed,  2 Jun 2021 14:21:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 89384F89ED
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 14:21:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D372B90DE3D
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 14:21:14 +0000 (UTC)
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-253-mpIyZ7WtOr6jQghEfX3OyA-1; Wed, 02 Jun 2021 10:21:10 -0400
X-MC-Unique: mpIyZ7WtOr6jQghEfX3OyA-1
Received: from j217100.upc-j.chello.nl ([24.132.217.100]
	helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1loRjL-002ucj-FS; Wed, 02 Jun 2021 14:20:30 +0000
Received: from hirez.programming.kicks-ass.net
	(hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest
	SHA256) (Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 09CFB300269;
	Wed,  2 Jun 2021 16:20:29 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id EBF7120223DBF; Wed,  2 Jun 2021 16:20:28 +0200 (CEST)
Date: Wed, 2 Jun 2021 16:20:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Message-ID: <YLeTrNDgBnAMMwEX@hirez.programming.kicks-ass.net>
References: <20210602131225.336600299@infradead.org>
	<20210602133040.587042016@infradead.org>
	<896642516.5866.1622642818225.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
In-Reply-To: <896642516.5866.1622642818225.JavaMail.zimbra@efficios.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 03 Jun 2021 02:32:49 -0400
Cc: Juri Lelli <juri.lelli@redhat.com>, Mark Rutland <mark.rutland@arm.com>,
	Pavel Machek <pavel@ucw.cz>, Mike Snitzer <snitzer@redhat.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	kgdb-bugreport <kgdb-bugreport@lists.sourceforge.net>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>, Ben Segall <bsegall@google.com>,
	linux-mm <linux-mm@kvack.org>, dm-devel <dm-devel@redhat.com>,
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
	Jakub Kicinski <kuba@kernel.org>, paulmck <paulmck@kernel.org>,
	linux-pm <linux-pm@vger.kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Jason Wessel <jason.wessel@windriver.com>,
	Josh Triplett <josh@joshtriplett.org>, rostedt <rostedt@goodmis.org>,
	linux-block <linux-block@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Borislav Petkov <bp@alien8.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Waiman Long <longman@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, acme <acme@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Jens Axboe <axboe@kernel.dk>, Felipe Balbi <balbi@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb <linux-usb@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Douglas Anderson <dianders@chromium.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-perf-users <linux-perf-users@vger.kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
	John Stultz <john.stultz@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	rcu <rcu@vger.kernel.org>, bristot <bristot@redhat.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 02, 2021 at 10:06:58AM -0400, Mathieu Desnoyers wrote:
> ----- On Jun 2, 2021, at 9:12 AM, Peter Zijlstra peterz@infradead.org wrote:

> > @@ -134,14 +134,14 @@ struct task_group;
> > 	do {							\
> > 		WARN_ON_ONCE(is_special_task_state(state_value));\
> > 		current->task_state_change = _THIS_IP_;		\
> > -		current->state = (state_value);			\
> > +		WRITE_ONCE(current->__state, (state_value));	\
> > 	} while (0)
> 
> Why not introduce set_task_state(p) and get_task_state(p) rather than sprinkle
> READ_ONCE() and WRITE_ONCE() all over the kernel ?

set_task_state() is fundamentally unsound, there's very few sites that
_set_ state on anything other than current, and those sites are super
tricky, eg. ptrace.

Having get_task_state() would seem to suggest it's actually a sane thing
to do, it's not really. Inspecting remote state is full of races, and
some of that really wants cleaning up, but that's for another day.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


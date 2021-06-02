Return-Path: <SRS0=6AeK=K5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD2DC47082
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 06:33:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9D6B761403
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 06:33:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D6B761403
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=efficios.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-qFJ-ZJ8qOKCPZ_cq8GRh5g-1; Thu, 03 Jun 2021 02:33:18 -0400
X-MC-Unique: qFJ-ZJ8qOKCPZ_cq8GRh5g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A20596DD31;
	Thu,  3 Jun 2021 06:33:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FC2510013D7;
	Thu,  3 Jun 2021 06:33:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3F9D444A5F;
	Thu,  3 Jun 2021 06:33:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 152E7Bk6031467 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Jun 2021 10:07:11 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 854AB20ED80A; Wed,  2 Jun 2021 14:07:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 80E1020ED806
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 14:07:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CEBEF182506A
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 14:07:08 +0000 (UTC)
Received: from mail.efficios.com (mail.efficios.com [167.114.26.124]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-244-CfvQnYcfP86HHgv6KYtzVQ-1; Wed, 02 Jun 2021 10:07:04 -0400
X-MC-Unique: CfvQnYcfP86HHgv6KYtzVQ-1
Received: from localhost (localhost [127.0.0.1])
	by mail.efficios.com (Postfix) with ESMTP id 33F8E302B4C;
	Wed,  2 Jun 2021 10:07:03 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
	by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id g1z0V_wT7FT6; Wed,  2 Jun 2021 10:06:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.efficios.com (Postfix) with ESMTP id 84F0C302AEF;
	Wed,  2 Jun 2021 10:06:58 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 84F0C302AEF
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
	by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id l6BO-UHNT1BK; Wed,  2 Jun 2021 10:06:58 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
	by mail.efficios.com (Postfix) with ESMTP id 548823029F3;
	Wed,  2 Jun 2021 10:06:58 -0400 (EDT)
Date: Wed, 2 Jun 2021 10:06:58 -0400 (EDT)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Message-ID: <896642516.5866.1622642818225.JavaMail.zimbra@efficios.com>
In-Reply-To: <20210602133040.587042016@infradead.org>
References: <20210602131225.336600299@infradead.org>
	<20210602133040.587042016@infradead.org>
MIME-Version: 1.0
X-Originating-IP: [167.114.26.124]
Thread-Topic: sched: Change task_struct::state
Thread-Index: DzXPoSkxk24gPNa4OEu5k5Jl7651YA==
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

----- On Jun 2, 2021, at 9:12 AM, Peter Zijlstra peterz@infradead.org wrote:

> Change the type and name of task_struct::state. Drop the volatile and
> shrink it to an 'unsigned int'. Rename it in order to find all uses
> such that we can use READ_ONCE/WRITE_ONCE as appropriate.
> 
[...]
> 
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c

[...]
> @@ -1559,7 +1560,8 @@ static int fill_psinfo(struct elf_prpsin
> 	psinfo->pr_pgrp = task_pgrp_vnr(p);
> 	psinfo->pr_sid = task_session_vnr(p);
> 
> -	i = p->state ? ffz(~p->state) + 1 : 0;
> +	state = READ_ONCE(p->__state);
> +	i = state ? ffz(~state) + 1 : 0;
> 	psinfo->pr_state = i;
> 	psinfo->pr_sname = (i > 5) ? '.' : "RSDTZW"[i];
> 	psinfo->pr_zomb = psinfo->pr_sname == 'Z';

[...]

> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -113,13 +113,13 @@ struct task_group;
> 					 __TASK_TRACED | EXIT_DEAD | EXIT_ZOMBIE | \
> 					 TASK_PARKED)
> 
> -#define task_is_running(task)		(READ_ONCE((task)->state) == TASK_RUNNING)
> +#define task_is_running(task)		(READ_ONCE((task)->__state) == TASK_RUNNING)
> 
> -#define task_is_traced(task)		((task->state & __TASK_TRACED) != 0)
> +#define task_is_traced(task)		((READ_ONCE(task->__state) & __TASK_TRACED) != 0)
> 
> -#define task_is_stopped(task)		((task->state & __TASK_STOPPED) != 0)
> +#define task_is_stopped(task)		((READ_ONCE(task->__state) & __TASK_STOPPED) !=
> 0)
> 
> -#define task_is_stopped_or_traced(task)	((task->state & (__TASK_STOPPED |
> __TASK_TRACED)) != 0)
> +#define task_is_stopped_or_traced(task)	((READ_ONCE(task->__state) &
> (__TASK_STOPPED | __TASK_TRACED)) != 0)
> 
> #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
> 
> @@ -134,14 +134,14 @@ struct task_group;
> 	do {							\
> 		WARN_ON_ONCE(is_special_task_state(state_value));\
> 		current->task_state_change = _THIS_IP_;		\
> -		current->state = (state_value);			\
> +		WRITE_ONCE(current->__state, (state_value));	\
> 	} while (0)

Why not introduce set_task_state(p) and get_task_state(p) rather than sprinkle
READ_ONCE() and WRITE_ONCE() all over the kernel ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=6AeK=K5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE34C47082
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 06:33:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 69CAA610CB
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 06:33:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69CAA610CB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-WCNC18-HMOmD5WaEXgUVYg-1; Thu, 03 Jun 2021 02:33:00 -0400
X-MC-Unique: WCNC18-HMOmD5WaEXgUVYg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68C0A803626;
	Thu,  3 Jun 2021 06:32:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DFE6100763C;
	Thu,  3 Jun 2021 06:32:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 86A53383D;
	Thu,  3 Jun 2021 06:32:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 152DoFN1030285 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Jun 2021 09:50:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BBDF0F97D7; Wed,  2 Jun 2021 13:50:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B6C60F97CC
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 13:50:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10BC2805F45
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 13:50:12 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-347-XPNZ_RbfPEu0k_sUc0gRHg-1; Wed, 02 Jun 2021 09:50:08 -0400
X-MC-Unique: XPNZ_RbfPEu0k_sUc0gRHg-1
Received: from j217100.upc-j.chello.nl ([24.132.217.100]
	helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1loQxi-00B8o7-PT; Wed, 02 Jun 2021 13:31:16 +0000
Received: from hirez.programming.kicks-ass.net
	(hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3E12D30036B;
	Wed,  2 Jun 2021 15:31:05 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
	id 9B82F2C14C596; Wed,  2 Jun 2021 15:31:04 +0200 (CEST)
Message-ID: <20210602133040.398289363@infradead.org>
User-Agent: quilt/0.66
Date: Wed, 02 Jun 2021 15:12:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
	Mel Gorman <mgorman@suse.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>
References: <20210602131225.336600299@infradead.org>
MIME-Version: 1.0
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
Cc: Mark Rutland <mark.rutland@arm.com>, Pavel Machek <pavel@ucw.cz>,
	Mike Snitzer <snitzer@redhat.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	kgdb-bugreport@lists.sourceforge.net,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>, linux-mm@kvack.org,
	dm-devel@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
	Zefan Li <lizefan.x@bytedance.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Joel Fernandes <joel@joelfernandes.org>, netdev@vger.kernel.org,
	Jiri Olsa <jolsa@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Davidlohr Bueso <dave@stgolabs.net>, kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
	x86@kernel.org, Jakub Kicinski <kuba@kernel.org>,
	John Stultz <john.stultz@linaro.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	linux-pm@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Borislav Petkov <bp@alien8.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Waiman Long <longman@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Felipe Balbi <balbi@kernel.org>, Stephen Boyd <sboyd@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Douglas Anderson <dianders@chromium.org>,
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	Jason Wessel <jason.wessel@windriver.com>, Tejun Heo <tj@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>, rcu@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
Subject: [dm-devel] [PATCH 3/6] sched,perf,kvm: Fix preemption condition
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

When ran from the sched-out path (preempt_notifier or perf_event),
p->state is irrelevant to determine preemption. You can get preempted
with !task_is_running() just fine.

The right indicator for preemption is if the task is still on the
runqueue in the sched-out path.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/events/core.c |    7 +++----
 virt/kvm/kvm_main.c  |    2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8568,13 +8568,12 @@ static void perf_event_switch(struct tas
 		},
 	};
 
-	if (!sched_in && task->state == TASK_RUNNING)
+	if (!sched_in && current->on_rq) {
 		switch_event.event_id.header.misc |=
 				PERF_RECORD_MISC_SWITCH_OUT_PREEMPT;
+	}
 
-	perf_iterate_sb(perf_event_switch_output,
-		       &switch_event,
-		       NULL);
+	perf_iterate_sb(perf_event_switch_output, &switch_event, NULL);
 }
 
 /*
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4869,7 +4869,7 @@ static void kvm_sched_out(struct preempt
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
-	if (current->state == TASK_RUNNING) {
+	if (current->on_rq) {
 		WRITE_ONCE(vcpu->preempted, true);
 		WRITE_ONCE(vcpu->ready, true);
 	}


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


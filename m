Return-Path: <SRS0=6AeK=K5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1637CC47082
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 06:33:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AD8446140C
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 06:33:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD8446140C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-Bca7xOruOWebo9nmnSfFyA-1; Thu, 03 Jun 2021 02:33:28 -0400
X-MC-Unique: Bca7xOruOWebo9nmnSfFyA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E763080DE0A;
	Thu,  3 Jun 2021 06:33:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B469B6A03A;
	Thu,  3 Jun 2021 06:33:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 729BC1813CAA;
	Thu,  3 Jun 2021 06:33:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 152EdGdG002974 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Jun 2021 10:39:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3324E208BDCE; Wed,  2 Jun 2021 14:39:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EE7A208BDF6
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 14:39:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D986010334A4
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 14:39:12 +0000 (UTC)
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-332-27OMM5cZNVm_HzAHx9GLVg-1; Wed, 02 Jun 2021 10:38:44 -0400
X-MC-Unique: 27OMM5cZNVm_HzAHx9GLVg-1
Received: from j217100.upc-j.chello.nl ([24.132.217.100]
	helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1loQxb-002tok-Ab; Wed, 02 Jun 2021 13:31:10 +0000
Received: from hirez.programming.kicks-ass.net
	(hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5345830050D;
	Wed,  2 Jun 2021 15:31:05 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
	id A55642C1AB5EA; Wed,  2 Jun 2021 15:31:04 +0200 (CEST)
Message-ID: <20210602133040.524487671@infradead.org>
User-Agent: quilt/0.66
Date: Wed, 02 Jun 2021 15:12:30 +0200
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
Subject: [dm-devel] [PATCH 5/6] sched,timer: Use __set_current_state()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/time/timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1879,7 +1879,7 @@ signed long __sched schedule_timeout(sig
 			printk(KERN_ERR "schedule_timeout: wrong timeout "
 				"value %lx\n", timeout);
 			dump_stack();
-			current->state = TASK_RUNNING;
+			__set_current_state(TASK_RUNNING);
 			goto out;
 		}
 	}


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


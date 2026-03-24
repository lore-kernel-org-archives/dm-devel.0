Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAA13FF897
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 14:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774363600; cv=none; b=HP1XDZg6QWe0j8rgq6bLwEiHstH4p2HIxA+g9R5N8+rWeREHqg3qly0XzCTpyWo71amRYYTS8PMNzTGsa/M7f0v/Rgcys4+zubMuOwlDa0iRH0zkPZ6Oj/qhCMg+/DH3OAqWAq2Ten/vr3O/eCWeLFzkuMSTVJjzkFYqMk1hdNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774363600; c=relaxed/simple;
	bh=j+ePUdlZ8doQMYmvdWcRcF6spWSaqJ04v1XCDH/z01Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=kIYLeXFhx3WQs15AbQ1CsvanVnVFvGg9covpx4jH4A2V8aIeeTAI/leHPa4mpZ9vyVkfR0BJ+W8upkEPwZs/dOPHe7zW+16HT+7AVm1Y/fZDaHVA5/u6HnRq0VlKvgg18vA/GSwKpa7arqChmLPro1WWobsZ3CBQe9kyRv2NYlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Eu0Puoym; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Eu0Puoym"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774363598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lZoD12eIWStaoG2HBYtdDLyOGvacUx0Wg/0HMejulq0=;
	b=Eu0PuoymaCrKLYHWpha6JSjs+yZcx+RdfivWRCsawMn+EFlvj/ec8W3dk71QNHT+jkiwI3
	yZsqbG+RBY5eOyTCDLv4C81LREBNQOvqHX/VU4/o8RDOcxByobMgpKJiDqwxpZ2Y1mUpnk
	dq60CLT3W3Dro6pULNTV5VgfH1czRxk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-595-0ZWjQiHDMoqfqMot9tfeRA-1; Tue,
 24 Mar 2026 10:46:34 -0400
X-MC-Unique: 0ZWjQiHDMoqfqMot9tfeRA-1
X-Mimecast-MFC-AGG-ID: 0ZWjQiHDMoqfqMot9tfeRA_1774363593
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D33E01800281;
	Tue, 24 Mar 2026 14:46:32 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 649F91800107;
	Tue, 24 Mar 2026 14:46:32 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62OEkVCw1060975
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 24 Mar 2026 10:46:31 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62OEkURJ1060974;
	Tue, 24 Mar 2026 10:46:30 -0400
Date: Tue, 24 Mar 2026 10:46:30 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH 4/4] libmultipath: TUR checker: use runner threads
Message-ID: <acKjxsBfyZg3E7k3@redhat.com>
References: <20260319221344.753790-1-mwilck@suse.com>
 <20260319221344.753790-5-mwilck@suse.com>
 <acIxXt69d6JkDtlQ@redhat.com>
 <864592419104ecd1c1e5d13b0f091dc57d04badf.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <864592419104ecd1c1e5d13b0f091dc57d04badf.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GN8rjfLEIos6vMtH7EazUlXckiG47pkG0--AMaqJ0vY_1774363593
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Mar 24, 2026 at 01:24:45PM +0100, Martin Wilck wrote:
> On Tue, 2026-03-24 at 02:38 -0400, Benjamin Marzinski wrote:
> > On Thu, Mar 19, 2026 at 11:13:44PM +0100, Martin Wilck wrote:
> > > Use the generic runners to simplify the TUR checker code.
> > > 
> > > The logic is the same as before, with one exception: the runner API
> > > does
> > > not allow to track a thread after it has been cancelled, like our
> > > current
> > > code does. The current code used this to determine when a
> > > previously
> > > cancelled thread eventually did complete. The use case for doing
> > > this in
> > > the current code was the MAX_NR_RUNNERS logic: the code waited
> > > "forever"
> > > for the "last" checker to complete. This is not possible with
> > > runners;
> > > once a runner is cancelled, it is off limits. (Waiting for a zombie
> > > thread to
> > > write to memory belonging to the main program, as the current code
> > > does,
> > > doesn't seem to be the best idea, anyway).
> > > 
> > > Therefore this patch implements a different logic for
> > > MAX_NR_RUNNERS. When
> > > nr_timeouts reaches the limit, the last checker is spawned with an
> > > infinite
> > > timeout. Like before, no new checker thread will be spawned until
> > > this last
> > > checker eventually completes. One difference to the previous code
> > > is that
> > > this last checker thread is never cancelled (after all, it never
> > > times
> > > out). But this code is meant for the case where cancellation is not
> > > effective, anyway. Another difference is that the new code will
> > > report
> > > PATH_TIMEOUT state as soon as this last thread is started rather
> > > than
> > > PATH_PENDING. That seems reasonable given that the checker
> > > previously timed
> > > out for this thread.
> > 
> > I'm not super enthused about this way of handling the misbehaving
> > threads. It's probably o.k. But what if the issue is that the checker
> > isn't completing by itself at all, but it would eventually get
> > cancelled, just not till after we timeout. In this case, we should be
> > cancelling that last runner. Admittedly, it's kinda hard to believe
> > that
> > a new runner would work correctly, while the old one still is stuck
> > needing to be cancelled, but what we had before definitely worked.
> 
> Well, not relying on a cancelled, detached zombie thread to eventually
> modify some shared memory location was a design principle of this new
> code.

We rely on cleanup handlers all over the code. Isn't this just another case
of that?

> But of course I realize that this does represent a change for those
> cases where a checker doesn't complete but can still be forced to
> return by cancellation. Is this a reasonable scenario?

Likely not. Like I said, I think that your method is probably fine.  I
just have a preference for the one that has been working without issue
for years. If my idea the design notably worse, I'm not strongly against
what you have.

> SG_IO on sd
> devices, which is what our checkers do, will go to uninterruptible
> sleep in blk_execute_rq(), and thus can't be cancelled (it _should_
> time out, though, unless the kernel misbehaves). It would be a
> different thing if we used sg devices instead...
> 
> > 
> > I don't really see why we can't continue with roughly what we had
> > before. We just need a new state for check_runner_state() to return.
> > Something like RUNNER_STOPPING. cancel_runner() would cmpxchg with
> > RUNNER_STOPPING, and not free the runner_context. In check_runner(),
> > if
> > the state was RUNNER_STOPPING or you just called cancel_runner(), you
> > would check the ctx->refcount. If it was already 1, you would release
> > the context and return RUNNER_CANCELLED. This way RUNNER_CANCELLED
> > still
> > means that the context has been freed, but it would only happen when
> > the
> > thread has ended.
> 
> That sort of logic is dangerous, IMO. I'd prefer to use only
> uatomic_sub_return() on the refcount.

I concede that it's racey. You could add a memory barrier to make in
quicker to see the results of a uatomic_sub_return() from the runner
thread, but it will always be racey to check if another thread has done
something. You might just miss the update and have to wait till the next
check. But I don't see how it's dangerous. You have a reference to the
object, so it should always be safe to check the object's state.

> >  If you want to stop paying attention to a runner in
> > RUNNER_STOPPING, you just call release_context() manually to drop
> > your
> > reference without waiting for it to finish.
> > 
> > Then, if you still have a runner in RUNNER_STOPPING after calling
> > check_runner_state() at the start of libcheck_check(), you drop your
> > reference to it if ct->nr_timeouts < MAX_NR_TIMEOUTS. Otherwise you
> > just
> > return PATH_TIMEOUT.
> > 
> > Thoughts? Like I said, I think what you have will probably be fine.
> > I just know what we had before worked.
> > 
> 
> I'll try to figure something out. No matter what I do, the API for the
> caller will get more complicated and error-prone, because it will need
> to track the lifetime of the runner's memory somehow (and if we do
> that, we might as well give up the idea of just using memcpy() to avoid
> shared memory issues).

It would still be true that when you got a RUNNER_DONE or
RUNNER_CANCELLED result from check_runner_state(), the rtx would be
invalid. Otherwise it would be valid. The only difference is that
RUNNER_STOPPING means that you have already cancelled the thread. You
can either hang onto the rtx until check_runner_state() returns
RUNNER_CANCELLED or drop your reference without waiting. But yes, the
runner code will be reading the refcount of the shared rtx.

I think that your memcpy design still will make things signficantly
simpler than the existing code, even with the code checking the refcount
of rtx. That refcount checking only comes into play when we've cancelled
the thread, at which point we don't care about the data anymore anyways.
 
> > More comments below.
> > 
> > > 
> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > >  libmultipath/checkers/tur.c | 341 +++++++++++---------------------
> > > ----
> > >  1 file changed, 103 insertions(+), 238 deletions(-)
> > > 
> > > diff --git a/libmultipath/checkers/tur.c
> > > b/libmultipath/checkers/tur.c
> > > index ba4ca68..6f22c45 100644
> > > --- a/libmultipath/checkers/tur.c
> > > +++ b/libmultipath/checkers/tur.c
> > > @@ -3,7 +3,6 @@
> > >   *
> > >   * Copyright (c) 2004 Christophe Varoqui
> > >   */
> > > -#include <stdio.h>
> > >  #include <stdlib.h>
> > >  #include <string.h>
> > >  #include <sys/types.h>
> > > @@ -17,13 +16,13 @@
> > >  #include <pthread.h>
> > >  #include <urcu.h>
> > >  #include <urcu/uatomic.h>
> > > +#include <assert.h>
> > >  
> > >  #include "checkers.h"
> > >  
> > >  #include "debug.h"
> > >  #include "sg_include.h"
> > > -#include "util.h"
> > > -#include "time-util.h"
> > > +#include "runner.h"
> > >  
> > >  #define TUR_CMD_LEN 6
> > >  #define HEAVY_CHECK_COUNT       10
> > > @@ -45,21 +44,20 @@ const char *libcheck_msgtable[] = {
> > >  	NULL,
> > >  };
> > >  
> > > -struct tur_checker_context {
> > > -	dev_t devt;
> > > -	int state;
> > > -	int running; /* uatomic access only */
> > > +struct tur_context {
> > >  	int fd;
> > > +	dev_t devt;
> > >  	unsigned int timeout;
> > > -	time_t time;
> > > -	pthread_t thread;
> > > -	pthread_mutex_t lock;
> > > -	pthread_cond_t active;
> > > -	int holders; /* uatomic access only */
> > > -	int msgid;
> > > +	int state;
> > > +	short msgid;
> > > +};
> > > +
> > > +struct tur_checker_context {
> > >  	struct checker_context ctx;
> > > +	int last_runner_state;
> > >  	unsigned int nr_timeouts;
> > > -	bool checked_state;
> > > +	struct runner_context *rtx;
> > > +	struct tur_context tcx;
> > 
> > There are lots of structures named *_context with names like *tx.
> > Perhaps we could rename the tur_context something like tur_data?
> > 
> > Also, ctx is the checker_context here, and the runner_contect in the
> > runner.c code. I think it would be easier to follow and grep if we
> > kept
> > the runner_context named rtx in both places.
> > 
> > >  };
> > >  
> > >  int libcheck_init (struct checker * c)
> > > @@ -67,48 +65,26 @@ int libcheck_init (struct checker * c)
> > >  	struct tur_checker_context *ct;
> > 
> > Also the tur_checker_context is tcc in every function but this one. I
> > think it helpful to always have the same name.
> > 
> > 
> 
> Right, I wasn't so happy about the variable naming either. I kept ct
> here because this is what it used to be. I'll try to make it more
> consistent in v2.
> 
> > >  	}
> > >  
> > > -	return tur_status;
> > > +	/* create new checker thread */
> > > +	ct->tcx.fd = c->fd;
> > > +	ct->tcx.timeout = c->timeout;
> > > +
> > > +	if (ct->nr_timeouts < MAX_NR_TIMEOUTS) {
> > > +		condlog(3, "%d:%d : starting checker with
> > > timeout",
> > > +			major(ct->tcx.devt), minor(ct->tcx.devt));
> > > +		ct->tcx.state = PATH_PENDING;
> > > +		ct->tcx.msgid = MSG_TUR_RUNNING;
> > > +		ct->rtx = get_runner(runner_callback, &ct->tcx,
> > > +				     sizeof(ct->tcx), 1000000 * c-
> > > >timeout);
> > > +	} else {
> > > +		condlog(3, "%d:%d : starting checker without
> > > timeout",
> > > +			major(ct->tcx.devt), minor(ct->tcx.devt));
> > > +		ct->tcx.state = PATH_TIMEOUT;
> > 
> > shouldn't we set ct->tcx.msgid = MSG_TUR_MSG_TUR_TIMEOUT here?
> > 
> 
> This was on purpose, but of course debatable. My thinking was this: The
> previous checker has timed out and we're just retrying, therefore
> setting PATH_TIMEOUT correctly reflects the state. But the message,
> which is mainly for the user, might as well express the fact that
> another checker is indeed currently running.

But won't ct->tcx.msgid be most likely already be set to
MSG_TUR_MSG_TUR_TIMEOUT from the previous failed runner?
check_runner_state() will update it, but the

c->msgid = ct->tcx.msgid

line just below this will use whatever happens to be in there, since we
don't set it. It seems like we should set it to something. MSG_TUR_RUNNING
works too.
 
> If we change the timeout logic, this change will be obsolete anyway.

Yep. But we still haven't decided that one way or the other.

-Ben

> Regards
> Martin


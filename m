Return-Path: <SRS0=DU+z=EK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF9C8C2D0A3
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 15:46:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5AF2A20735
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 15:46:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hv8bHrR5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5AF2A20735
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1604504807;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aQc/CB6wWAbjIBBR7lEsg0bPhjIDWu5161D4XEqUgEQ=;
	b=Hv8bHrR5zvFE6rW0hki7WYsqAMTNRTEdhs/7PHLgJTH4UTyrlA0I+rSL2ae+b4FvnqABsX
	B4VbU9uD1/ZJNEeptOJx4dFCJW+lUeTr9VRGoETxpRvv4kmjN3MT9zQZhi9asszeov5eU3
	Kj2ylVd3pRnruZXBBqah4op9GnRqtb0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-Y-2B9otMNp29Pwsx93VV_w-1; Wed, 04 Nov 2020 10:46:45 -0500
X-MC-Unique: Y-2B9otMNp29Pwsx93VV_w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60A1C186DD21;
	Wed,  4 Nov 2020 15:46:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D1816266E;
	Wed,  4 Nov 2020 15:46:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 89972180B658;
	Wed,  4 Nov 2020 15:46:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A4FkWIE025202 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 4 Nov 2020 10:46:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DB4C05DA30; Wed,  4 Nov 2020 15:46:32 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 278D25D9CC;
	Wed,  4 Nov 2020 15:46:29 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0A4FkR7p025915; 
	Wed, 4 Nov 2020 09:46:27 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0A4FkQJt025914;
	Wed, 4 Nov 2020 09:46:26 -0600
Date: Wed, 4 Nov 2020 09:46:26 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20201104154626.GC3384@octiron.msp.redhat.com>
References: <20201016104501.8700-1-mwilck@suse.com>
	<20201016104501.8700-30-mwilck@suse.com>
	<20201020022008.GK3384@octiron.msp.redhat.com>
	<b90e91621122ebfacd85a548e0ec7a9aa59865e3.camel@suse.com>
	<44a708f870a0f9a60b1adcbe37acca9a58933366.camel@suse.com>
	<20201103001103.GW3384@octiron.msp.redhat.com>
	<5e76585aaefdb34df7ff4ccad459212beb3b67fa.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <5e76585aaefdb34df7ff4ccad459212beb3b67fa.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 29/29] libmultipath: fix race between
 log_safe and log_thread_stop()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Nov 04, 2020 at 01:36:02PM +0100, Martin Wilck wrote:
> On Mon, 2020-11-02 at 18:11 -0600, Benjamin Marzinski wrote:
> > On Mon, Oct 26, 2020 at 06:24:57PM +0100, Martin Wilck wrote:
> > > On Mon, 2020-10-26 at 17:22 +0100, Martin Wilck wrote:
> > > > On Mon, 2020-10-19 at 21:20 -0500, Benjamin Marzinski wrote:
> > > > > On Fri, Oct 16, 2020 at 12:45:01PM +0200, mwilck@suse.com
> > > > > wrote:
> > > > > > From: Martin Wilck <mwilck@suse.com>
> > > > > > 
> > > > > > log_safe() could race with log_thread_stop(); simply
> > > > > > checking the value of log_thr has never been safe. By
> > > > > > converting
> > > > > > the
> > > > > > mutexes to static initializers, we avoid having to destroy
> > > > > > them,
> > > > > > and thus
> > > > > > possibly accessing a destroyed mutex in log_safe().
> > > > > > Furthermore,
> > > > > > taking
> > > > > > both the logev_lock and the logq_lock makes sure the logarea
> > > > > > isn't
> > > > > > freed
> > > > > > while we are writing to it.
> > > > > > 
> > > > > 
> > > > > I don't see any problems with this, but I also don't think it's
> > > > > necssary
> > > > > to hold the log thread lock (logev_lock), just to add a message
> > > > > to
> > > > > the
> > > > > queue. It seems like protecting the log queue is the job of
> > > > > logq_lock.
> > > > > As long as log_safe() enqueues the message before
> > > > > flush_logqueue()
> > > > > is
> > > > > called in log_thread_stop(), it should be fine. This could be
> > > > > solved
> > > > > by
> > > > > simply having a static variable in log_pthread.c named
> > > > > something
> > > > > like
> > > > > log_area_enabled, that always accessed while holding the
> > > > > logq_lock,
> > > > > and
> > > > > is set to true when the log_area is created, and set to false
> > > > > just
> > > > > before calling the flush_logqueue() in log_thread_stop().
> > > > 
> > > > If we do this, we might as well use the variable "la" itself for
> > > > that,
> > > > and make sure it's only accessed under the lock. It'd be fine,
> > > > because
> > > > la is used if and only if the log thread is active, and spare us
> > > > another variable. I had actually considered that, thought it was
> > > > too
> > > > invasive for the already big series. If you prefer this way, I
> > > > can do
> > > > it. 
> > > 
> > > OTOH, we take logev_lock in log_safe() anyway (to set
> > > log_messages_pending). I doubt that it makes a big difference if we
> > > take the two locks sequentially, or nested. The previous code
> > > actually
> > > took the logev_lock twice, before and after logq_lock. Assuming
> > > that
> > > contention is rather rare, I believe my code might actually perform
> > > better than before. 
> > > 
> > > In your previous review 
> > > https://www.redhat.com/archives/dm-devel/2020-September/msg00631.html
> > > you pointed out that you considered it important that log_safe()
> > > works
> > > even after the thread was stopped. Making this work implies that
> > > log_safe() needs to check if the thread is up. So we either have to
> > > take logev_lock twice, or take logq_lock while holding logev_lock.
> > > 
> > > Bottom line: I think my patch is correct. We could add another
> > > patch on
> > > top that moves logq_lock() into log.c, protecting the "la"
> > > variable,
> > > but the nesting would still need to be the same.
> > > 
> > > Does this make sense?
> > 
> > No. Maybe I'm just being dumb, but couldn't log safe:
> > 
> > - grab the logq_lock
> > - check if the log_area is usable. We can use la for this.
> > 	- If not, unlock, write to syslog and return
> > 	- If so, you know that flush_logqueue() hasn't been run by
> > 	  log_thread_stop() yet,
> 
> How do I know that?

oops. When I talked above about using a seperate variable,
log_area_enabled, I mentioned that you would need to set this to false
before calling flush_logqueue() in log_thread_stop(). This means that
you can't just use la for this, since you need la around for
flush_logqueue. Sorry. On the other hand, while I not a big fan of
nesting locks that don't need to be, it's not a big deal. So I'm o.k.
with your version.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> flush_logqueue() could be running, or could just
> have finished. Neither free_logarea() nor log_close() take the
> logq_lock (in the current code), so the following would be possible:
> 
>   thread A                       thread B               log thread
>   --------                       --------               ----------
>                                  
>      log_thread_stop()           log_safe()                                
>                                    under logev_lock:
>                                      observe logq_running==1
>          under logev_lock:
>            pthread_cancel
>            signal logev_cond
>                                                         <observe logev_cond/cancel>
>                                                         under logev_log:
>                                                           logq_running=0
>                                                         exit()
>          pthread_join()
>          flush_logqueue()
>             <return>
>          log_close()               under logq_lock:
>                                      test la -> ok           
>             free_logarea()
>                 FREE(la)             log_enqueue()   
>             closelog()                 access la
>                                        -> *bummer*
>  
> Even if it doesn't crash because thread B wins the race against FREE(),
> the messages written after flush_logqueue() returns will be lost.
> AFAICS, the latter would still hold if we did grab logq_lock in
> free_logarea(), but at least then we couldn't crash any more.
> (I doubt that loosing messages in this corner case really matters).
> 
> >  meaning anything you add to the log
> > 	  will get flushed by flush_logqueue, so enqueue the message
> > -unlock logq_lock and lock logev_lock
> > -signal that there are messages pending.
> > If nobody is listening on the
> >  the other side, who cares, because log_thread_stop() will still
> > flush
> >  the enqueued message
> > -unlock logev_lock
> > 
> > Am I missing something?
> 
> See above. Be invited to prove that I'm wrong :-)
> 
> What can we do about it? Of course you're right, if we keep logev_lock
> held in log_safe(), we hold this log for a longer time, and effectively
> prevent synchronous queueing and dequeuing of messages, so it's not
> ideal either.
> 
> By taking logq_log in all functions accessing "la" in log.c, we would
> avoid crashing. We might still loose some messages. Next, we could
> switch to direct logging if log_enqueue() failed because "la" has been
> freed (I'm not sure if we should also switch to direct logging if
> log_enqueue() fails for other reasons, e.g. because the ring buffer is
> full - I suppose we shouldn't).
> 
> What about that?
> 
> Regards,
> Martin
> 
> PS: One reason for the awkwardness here is the use of
> log_messages_pending under the logev_lock. I believe that
> log_messages_pending is redundant; it should be replaced
> by something like (la->empty) or (la->tail != la->head), to be tested under logq_lock. But this is subtle, I need to study the code more deeply to get it right. I see it rather as a long-term improvement.
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=x48V=EB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13DD1C4363A
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 17:29:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 912ED2223C
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 17:29:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 912ED2223C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-rWRFWcoyPaGy0-CbhtAOVQ-1; Mon, 26 Oct 2020 13:29:22 -0400
X-MC-Unique: rWRFWcoyPaGy0-CbhtAOVQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 807E61009E2D;
	Mon, 26 Oct 2020 17:29:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 504DA5B4AE;
	Mon, 26 Oct 2020 17:29:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B539D181A06C;
	Mon, 26 Oct 2020 17:29:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09QHP5bR032653 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Oct 2020 13:25:05 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 068A02166B27; Mon, 26 Oct 2020 17:25:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 025AB2166B44
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 17:25:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A723C858296
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 17:25:02 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-321-XBePnV2MO8CKtHGq65ZVNA-1;
	Mon, 26 Oct 2020 13:25:00 -0400
X-MC-Unique: XBePnV2MO8CKtHGq65ZVNA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 95720AECE;
	Mon, 26 Oct 2020 17:24:58 +0000 (UTC)
Message-ID: <44a708f870a0f9a60b1adcbe37acca9a58933366.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 26 Oct 2020 18:24:57 +0100
In-Reply-To: <b90e91621122ebfacd85a548e0ec7a9aa59865e3.camel@suse.com>
References: <20201016104501.8700-1-mwilck@suse.com>
	<20201016104501.8700-30-mwilck@suse.com>
	<20201020022008.GK3384@octiron.msp.redhat.com>
	<b90e91621122ebfacd85a548e0ec7a9aa59865e3.camel@suse.com>
User-Agent: Evolution 3.36.5
MIME-Version: 1.0
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 2020-10-26 at 17:22 +0100, Martin Wilck wrote:
> On Mon, 2020-10-19 at 21:20 -0500, Benjamin Marzinski wrote:
> > On Fri, Oct 16, 2020 at 12:45:01PM +0200, mwilck@suse.com wrote:
> > > From: Martin Wilck <mwilck@suse.com>
> > > 
> > > log_safe() could race with log_thread_stop(); simply
> > > checking the value of log_thr has never been safe. By converting
> > > the
> > > mutexes to static initializers, we avoid having to destroy them,
> > > and thus
> > > possibly accessing a destroyed mutex in log_safe(). Furthermore,
> > > taking
> > > both the logev_lock and the logq_lock makes sure the logarea
> > > isn't
> > > freed
> > > while we are writing to it.
> > > 
> > 
> > I don't see any problems with this, but I also don't think it's
> > necssary
> > to hold the log thread lock (logev_lock), just to add a message to
> > the
> > queue. It seems like protecting the log queue is the job of
> > logq_lock.
> > As long as log_safe() enqueues the message before flush_logqueue()
> > is
> > called in log_thread_stop(), it should be fine. This could be
> > solved
> > by
> > simply having a static variable in log_pthread.c named something
> > like
> > log_area_enabled, that always accessed while holding the logq_lock,
> > and
> > is set to true when the log_area is created, and set to false just
> > before calling the flush_logqueue() in log_thread_stop().
> 
> If we do this, we might as well use the variable "la" itself for
> that,
> and make sure it's only accessed under the lock. It'd be fine,
> because
> la is used if and only if the log thread is active, and spare us
> another variable. I had actually considered that, thought it was too
> invasive for the already big series. If you prefer this way, I can do
> it. 

OTOH, we take logev_lock in log_safe() anyway (to set
log_messages_pending). I doubt that it makes a big difference if we
take the two locks sequentially, or nested. The previous code actually
took the logev_lock twice, before and after logq_lock. Assuming that
contention is rather rare, I believe my code might actually perform
better than before. 

In your previous review 
https://www.redhat.com/archives/dm-devel/2020-September/msg00631.html
you pointed out that you considered it important that log_safe() works
even after the thread was stopped. Making this work implies that
log_safe() needs to check if the thread is up. So we either have to
take logev_lock twice, or take logq_lock while holding logev_lock.

Bottom line: I think my patch is correct. We could add another patch on
top that moves logq_lock() into log.c, protecting the "la" variable,
but the nesting would still need to be the same.

Does this make sense?
     
Regards,
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


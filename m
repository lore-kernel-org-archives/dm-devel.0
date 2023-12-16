Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1B81E485
	for <dm-devel@lists.linux.dev>; Sat, 16 Dec 2023 02:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G8l0paKq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702694952;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DCnDRP2MlllpQcRvxedUcxP0QcrJlBPbqopMEFVU1g0=;
	b=G8l0paKqsvngXwucJCGc5blPmRtr7jxSkwy6b1+OLFxGBbgTLDfN7pOuLyC1LO5Hq+x2oK
	0nosnaoF2+fEwKnvVrn5rG1hg4pxZ/8zsPH+QMLRlrUjUZDVtmuJ7DD1k786id0/FjvS6T
	IsT1cZN+KdSQpxVgyADdxg3PcF6PQEU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-_-ar4LIzOHaMNTZCyz9RKA-1; Fri, 15 Dec 2023 21:49:09 -0500
X-MC-Unique: _-ar4LIzOHaMNTZCyz9RKA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0B7785CBA4;
	Sat, 16 Dec 2023 02:49:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 942133C25;
	Sat, 16 Dec 2023 02:49:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 3BG2n85m677583
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 Dec 2023 21:49:08 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 3BG2n8o2677582;
	Fri, 15 Dec 2023 21:49:08 -0500
Date: Fri, 15 Dec 2023 21:49:08 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2 5/5] multipathd: force setting dm state when
 disabling/restoring queueing
Message-ID: <ZX0QJIrOQU6RKaAp@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231205235704.355125-1-bmarzins@redhat.com>
 <20231205235704.355125-6-bmarzins@redhat.com>
 <0e0dcba49d56b71a7584efb2273be1e9d0606af2.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <0e0dcba49d56b71a7584efb2273be1e9d0606af2.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Dec 14, 2023 at 05:15:20PM +0100, Martin Wilck wrote:
> On Tue, 2023-12-05 at 18:57 -0500, Benjamin Marzinski wrote:
> > Currently, the interactive commands to disable and restore queueing
> > call
> > set_no_path_retry() without first re-reading the device table. This
> > means that the value of mpp->features might not be current, which
> > means
> > that set_no_path_retry() might not tell device-mapper to change the
> > queue_if_no_path state when it should have.
> > 
> > Instead of making these commands do extra work to re-read the device
> > table, simply make them always tell dm to update the queue_if_no_path
> > state, regardless of the current state. There is no harm in telling
> > dm
> > to set the state to its current value.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> I am still not convinced, as this goes against the spirit of keeping
> the no_path_retry setting consistently in a single place. Why don't we
> rather make sure that our "features" string correctly matches the
> kernel settings (ignoring possible attempts to bypass multipathd)?
> 
> The code snippet I sent in reply to your 1/5 patch should achieve this
> for map reloading. Queueing can only changed by (re)loading, or by
> sending dm messages. Thus AFAICS it should be sufficient to add calls
> to add_feature("queue_if_no_path") and
> remove_feature("queue_if_no_path") to dm_queue_if_no_path(). Am I
> overlooking something?
> 
> Wrt "there is no harm in telling dm to set the state to its current
> value", the kernel doesn't seem to check whether the new and current
> value are the same. It always takes a spinlock and set some flags in
> the dm device. So the ioctl is not a zero-cost operation.

fair enough. I can replace this with a patch to keep mpp->features in
sync with what multipathd has done to the device.
 
> Apart from these general doubts, I have some more remarks below.
> 
> Before 6071176 ("libmultipath: drop mpp->nr_active field"), which
> introduced the call to set_no_path_retry() from cli_restore_queueing(),
> we also reset mpp->retry_tick, which your new code does not. (That was
> actually part of the motivation to use set_no_path_retry() rather than
> direct calls to dm_queue_if_no_path(), IIRC).
> 
> The term "restorequeuing" suggests that it's somehow reset to a
> previously saved value, which is not the case. We should mention in the
> man page that "restorequeuing" actually just enables queueing (for maps
> that are configured to queue). Perhaps we should also add
> "enablequeueing" as an alias for "restorequeueing".

I don't like the name "enablequeueing". "disablequeueing" turns queueing
off regardless of the device's setting. "enablequeueing" sound like it
could turn queueing on regardless of the device's setting. If you'd like,
we could add code to restore queueing to stop queueing if we shouldn't
be, but I'm not sure how that could happen, so it seems unnecessary,
unless there's some way that this could happen that I'm not thinking
about. I'm fine with updating the man page to mention that
"restorequeueing" will just reset no_path_retry to the configured
setting and reenable queueing if necessary.

> > ---
> >  multipathd/cli_handlers.c | 25 +++++++++----------------
> >  1 file changed, 9 insertions(+), 16 deletions(-)
> > 
> > diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> > index b1dff202..758b571b 100644
> > --- a/multipathd/cli_handlers.c
> > +++ b/multipathd/cli_handlers.c
> > @@ -934,16 +934,9 @@ cli_restore_queueing(void *v, struct strbuf
> > *reply, void *data)
> >  	select_no_path_retry(conf, mpp);
> >  	pthread_cleanup_pop(1);
> >  
> > -	/*
> > -	 * Don't call set_no_path_retry() for the NO_PATH_RETRY_FAIL
> > case.
> > -	 * That would disable queueing when "restorequeueing" is
> > called,
> > -	 * and the code never behaved that way. Users might not
> > expect it.
> > -	 * In almost all cases, queueing will be disabled anyway
> > when we
> > -	 * are here.
> > -	 */
> > -	if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
> > -	    mpp->no_path_retry != NO_PATH_RETRY_FAIL)
> > -		set_no_path_retry(mpp);
> > +	if (mpp->no_path_retry == NO_PATH_RETRY_QUEUE ||
> > +	    (mpp->no_path_retry > 0 && count_active_paths(mpp) > 0))
> > +		dm_queue_if_no_path(mpp->alias, 1);
> >  
> >  	return 0;
> >  }
> > @@ -962,10 +955,10 @@ cli_restore_all_queueing(void *v, struct strbuf
> > *reply, void *data)
> >  		pthread_cleanup_push(put_multipath_config, conf);
> >  		select_no_path_retry(conf, mpp);
> >  		pthread_cleanup_pop(1);
> > -		/* See comment in cli_restore_queueing() */
> > -		if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
> > -		    mpp->no_path_retry != NO_PATH_RETRY_FAIL)
> > -			set_no_path_retry(mpp);
> > +
> > +		if (mpp->no_path_retry == NO_PATH_RETRY_QUEUE ||
> > +		    (mpp->no_path_retry > 0 &&
> > count_active_paths(mpp) > 0))
> > +			dm_queue_if_no_path(mpp->alias, 1);
> 
> What about the case when there are no active paths, no pending paths,
> mpp->in_recovery and mpp->retry_tick > 0?

I guess I always sort of assumed the the restore queueing commands would
get called after the disablequeueing commands. In that case, retry_tick
can't be greater than 0. But if the plan is to keep mpp->features in
sync, and we go back to calling set_no_path_retry() here, we still won't
enable queueing it the state you mention.  I would argue that there's
not much point in doing so. We don't have paths, and we already were
failing back IO, so anything that was sending IO will already have seen
failures. There doesn't seem much point in turning it back on now.
Besides how would we even get into this state? I suppose something
outside of multipathd could have turned off queueing.

I was planning on just going back to set_no_path_retry() if we keep
mpp->features in sync, unless you object.

-Ben

> Regards,
> Martin
> 


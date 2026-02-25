Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8482239099
	for <dm-devel@lists.linux.dev>; Wed, 25 Feb 2026 20:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772052090; cv=none; b=bqaiJXM0B80zRhJvaydhmTp5Qv+Pwzjh67LlZTbZ3M1NJ4rWLxcxvft9jFqos9OYlLv/RdggQIZOljia934nZJvLHR4E4r/+NjbfbDWqfaRQLq6o7srZSG8opRseqHjqeNv8Ap0/SCMOyA54yGLqdWvyUxsWIpeNlO7WXZBOZ2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772052090; c=relaxed/simple;
	bh=RekEnQHlwAEeu9PbJ47DVdpcnNOMLV9uJ0b8vvTn4A4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=RPCgtXuElxBJ2bAFM04R9Oi3n0BlthuAcO16PkmmThY9ZaNFIEhd+Gm0GgfNA0TcXpKd533INouZpNrQMVRpTcbQ9qjK/GVSJhGPliHuoZQAo3tXH85k1WGJW1T5gvxQ73QR1PWP6PAuFo9F7fCR7V0OVwDzRkZeEIXkV0ypR9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fen8rAr/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fen8rAr/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772052087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yGWvavreEfpe1xfPn0ELIbYScWHYo5/OOyx5ON7pDnk=;
	b=fen8rAr/nTQ+SH72CVtrEaW/WDYAbVIF9E4tWDDyI/tjhndXmexXZVu+PpPcR29CyysJOY
	ZURZO2VeU9AoeYrLLqQPuJhE5Gucu7QB/03JX4AFb5To956+w7PE5HI5BjGw5twm8vG+DY
	Ot+8MjHRGoarqJnHLFHgEphab8p7IVg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-286-QqzWte0-PL-jirqxu4RKoQ-1; Wed,
 25 Feb 2026 15:41:26 -0500
X-MC-Unique: QqzWte0-PL-jirqxu4RKoQ-1
X-Mimecast-MFC-AGG-ID: QqzWte0-PL-jirqxu4RKoQ_1772052085
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B3091956059;
	Wed, 25 Feb 2026 20:41:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A4CB21800465;
	Wed, 25 Feb 2026 20:41:24 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 61PKfN6Z1669388
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 25 Feb 2026 15:41:23 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 61PKfN9V1669387;
	Wed, 25 Feb 2026 15:41:23 -0500
Date: Wed, 25 Feb 2026 15:41:23 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH 0/1] checkers: fix race in async TUR and ALUA result
 collection
Message-ID: <aZ9ec_ce8dCCBzR0@redhat.com>
References: <20260224010058.35337-1-brian@purestorage.com>
 <d9355e67dc64b7af940f6b8e6845d0f37565dd34.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <d9355e67dc64b7af940f6b8e6845d0f37565dd34.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: d5vBYF3dYu4oMuEGxpfRCmBUbkQrWGoNk0HV255OMos_1772052085
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Feb 24, 2026 at 02:26:22PM +0100, Martin Wilck wrote:
> Hi Brian,
> 
> On Mon, 2026-02-23 at 17:00 -0800, Brian Bunker wrote:
> > Fix a race condition in libcheck_check() for both the TUR and ALUA
> > async
> > checkers where a completed result could be missed, returning
> > PATH_PENDING
> > unnecessarily.
> 
> First of all, you should have cc'd the dm-devel mailing list.
> 
> Second, you call this a race condition, but what negative effect does
> it actually have? AFAIU this "race condition" just delays returning the
> new checker state by a single tick (i.e. 1 second), which is a rather
> benign problem for a race, and generally not a big problem for
> multipath, where paths can be offline for much longer periods of time.
> 
> Finally, before going into any detail, I am highly reluctant to changes
> in this area. Ben and I have fought with deadlocks and races in corner
> cases for a long time, and we seem to have solved it for good; at least
> we haven't seen any more bugs in this area for quite some time. For a
> change like this, figuring out possible side effects for all possible
> cases by code inspection alone is extremely hard. I'd rather not risk a
> regression just to detect a status change 1 second earlier than we
> currently do, in rare cases.

I pretty much agree with Martin here. I do think this is likely safe,
but I don't think this is really a race. We don't return the status of
the thread until the thread completes, and the thread signals its
completion by clearing ct->running. That's the same definition of
successful thread completion that we use for deciding to kill the
thread, and I don't see why it's not a valid one.

Yes we can get the thread result slightly before the thread has
completed. But by trusting that the thread will complete once pp->msgid
has changed, we are giving up the ability to kill it if it does hang
later, for instance in that condlog() call. On systemd systems, this is
just some stdio print functions, but on non-systemd systems, this uses
its own pthread locking, and could legitimately hang (although the
argument certainly can be made that if this is hanging, multipathd has
bigger problems to worry about than an extra tur checker thread lying
around).  
 
> > 
> > Race window
> > -----------
> > 
> > In libcheck_thread() / alua_thread():
> > 
> >     pthread_mutex_lock(&ct->lock);
> >     ct->state = state;
> >     ct->msgid = msgid;
> >     pthread_cond_signal(&ct->active);
> >     pthread_mutex_unlock(&ct->lock);
> >     /* <-- race window here --> */
> >     uatomic_set(&ct->running, 0);
> > 
> 
> You seem to be looking at old code. The code I am seeing has this:
> 
>        running = uatomic_xchg(&ct->running, 0);
>        if (!running)
>                pause();
> 
> Anyway, I think we had very good reasons to set the running state after
> releasing the lock. I would need to dig deeper into the history in
> order to figure out exactly why we did it this way. It probably has
> something to do with the actual fatal races that we observed between
> checkers timing out / being cancelled and finishing.
> 
> 
> > When libcheck_check() observes ct->running != 0 during this window,
> > the
> > result is already available under lock, but the previous code could
> > fail
> > to collect it.
> > 
> > Why the old check was broken
> > ----------------------------
> > 
> > The ALUA checker used:
> > 
> >     if (ct->state != PATH_PENDING || ct->msgid != MSG_ALUA_RUNNING)
> > 
> > This conflated two different meanings of PATH_PENDING:
> > 1. Thread still in progress (no result yet)
> > 2. ALUA state is transitioning (valid completed result with
> >    MSG_ALUA_TRANSITIONING)
> 
> True, but what's the actual problem with this? In both cases, the
> checker is indeed not yet able to figure out if the path is usable,
> which is what CHECKER_PENDING means.

This is where I'm stuck too. If there is a legitimate problem with the
current code, then that would certainly weigh against our caution here.
But AFAICS, this is just multipathd checking the thread and seeing that
it hasn't completed yet (to multipathd's definition of completed), and
waiting a second to recheck.

-Ben 
 
> 
> > 
> > The TUR checker had similar issues since PATH_PENDING with
> > MSG_TUR_TRANSITIONING is a valid result.
> > 
> > The fix
> > -------
> > 
> > Check ct->msgid alone under lock. The msgid is set to MSG_*_RUNNING
> > only
> > at async check start and atomically updated with state when complete:
> > 
> >     if (ct->msgid != MSG_TUR_RUNNING) {
> >         tur_status = ct->state;
> >         c->msgid = ct->msgid;
> >         ct->thread = 0;
> >     }
> 
> You probably realize that with this change, you basically imply that
> the test for ct->running is superfluous. If this was true, we could
> actually just skip it and solely rely on ct->msgid. What you're
> basically saying is that ct->running is meaningless. But it isn't. It
> means that the thread is "dead", which it isn't as long as holds the
> mutex.
> 
> I'll wait for Ben's opinion, but I am inclined to nack this, sorry.
> 
> Martin


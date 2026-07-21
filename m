Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB2846AA68
	for <dm-devel@lists.linux.dev>; Tue, 21 Jul 2026 15:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647886; cv=none; b=n6TMTXD2C1oXN8CXSBj8wA8Y5uEBCx78xo8bvnpno+S7+cVF++v4b+sqSBEoGERZNLvkQGHVF9TadPpWhQkDNHEomMQj8F3M+j+4BinBbBa9249vQe0v44zkIwtklzZHviis3+nyQqfUTET5NgwnT5Y/u6OoLyUIpz3xZiUS0pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647886; c=relaxed/simple;
	bh=hchR9EVcxW21gMkiXnW9tA1x1a0D/N5d8Dh2+9JgZAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=b9ak2rWW1kgeD5ZPltsAY48qJfEaB9vVP9nnZ/Z/icjXTk+VgdwGv2fLO4NjpWMl9xAxvvBPGLRWml31H2ML88I21mB/MZUXYW7TN5xcLs1BPbg20+YK9JgLIH+E1J+nkHw5//lZ/h0rjDFDjDTMhiPmL9gTaSPU7g/wicyR5mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VYwSPD0U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VYwSPD0U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784647883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4C5F7FU3DZt1zDK2zIvQtM4pSjYHZjmMiursaGd0HZ4=;
	b=VYwSPD0U4fa9Odhtcd9hCw8bAYDewXqFg5S1hZOsg31TmOcLrOk5RGyVLwAOGsTpVbxJDN
	zG4FzLxYa+AKjTyeoZK/BOWRUSC20n3DmaNMMD5UIZEwejWEFE162mAs2Ur6PkqWBRge+1
	rgTJTzOYv1W72HcnkQ9CNzcyNvd1joc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-342-Mljdbwl0OpqSklvVT0UMkw-1; Tue,
 21 Jul 2026 11:31:20 -0400
X-MC-Unique: Mljdbwl0OpqSklvVT0UMkw-1
X-Mimecast-MFC-AGG-ID: Mljdbwl0OpqSklvVT0UMkw_1784647879
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B3DE31955BCE;
	Tue, 21 Jul 2026 15:31:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 789241955F7D;
	Tue, 21 Jul 2026 15:31:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 66LFVHNx2491754
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 21 Jul 2026 11:31:17 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 66LFVGoF2491753;
	Tue, 21 Jul 2026 11:31:16 -0400
Date: Tue, 21 Jul 2026 11:31:16 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>,
        Cykang <cykang4830@gmail.com>
Subject: Re: [PATCH] libmpathpersist: fix self-preemption when key has no
 active reservation
Message-ID: <al-QxPjUZVgUdvjI@redhat.com>
References: <20260720215200.2464152-1-bmarzins@redhat.com>
 <7ff8a06cebaeea6d49c27044be2b3e4c66b9eda1.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <7ff8a06cebaeea6d49c27044be2b3e4c66b9eda1.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1zzFvIU-9x9TGzbDTg_g9WP1h9WfD3U8ctMJPdd2fv4_1784647879
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jul 21, 2026 at 09:43:44AM +0200, Martin Wilck wrote:
> On Mon, 2026-07-20 at 17:52 -0400, Benjamin Marzinski wrote:
> > From: Cykang <cykang4830@gmail.com>
> > 
> > According to the SCSI-3 Persistent Reservations specification, when a
> > self-preemption is performed with a key that does not currently hold
> > an active reservation, the operation should be treated as an
> > unregister
> > and should not fail.
> > 
> > The current code in do_mpath_persistent_reserve_out() does not check
> > whether the preempting key has a reservation before invoking the
> > self-preemption path. It unconditionally calls preempt_self() and
> > re-registers the key on the local paths, even when the key has no
> > reservation. This violates the SCSI-3 PR spec and can lead to
> > incorrect reservation states.
> > 
> > This patch moves the self-preemption check inside the conditional
> > block so that it only executes when the key matches, but does not
> > bypass the general preemption path for keys without a reservation.
> > With this change, the code will fall through to the common PR_OUT
> > handling (e.g., MPATH_PROUT_RES_SA or CLEAR_SA) when the key is not
> > reserved, allowing the storage target to properly process the
> > operation as an unregister.
> > 
> > Signed-off-by: Cykang <cykang4830@gmail.com>
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmpathpersist/mpath_persist_int.c | 22 ++++++++++++++++------
> >  1 file changed, 16 insertions(+), 6 deletions(-)
> > 
> > diff --git a/libmpathpersist/mpath_persist_int.c
> > b/libmpathpersist/mpath_persist_int.c
> > index 3091c5c2..6ca3b97d 100644
> > --- a/libmpathpersist/mpath_persist_int.c
> > +++ b/libmpathpersist/mpath_persist_int.c
> > @@ -841,6 +841,7 @@ int do_mpath_persistent_reserve_out(vector curmp,
> > vector pathvec, int fd,
> >  	bool unregistering, preempting_reservation = false;
> >  	bool updated_prkey = false;
> >  	bool failed_paths = false;
> > +	bool self_preempt_unreg = false;
> >  
> >  	ret = mpath_get_map(curmp, fd, &mpp);
> >  	if (ret != MPATH_PR_SUCCESS)
> > @@ -961,13 +962,20 @@ int do_mpath_persistent_reserve_out(vector
> > curmp, vector pathvec, int fd,
> >  						  rq_type, noisy);
> >  				break;
> >  			}
> > +			/* if we are preempting ourself */
> > +			if (memcmp(paramp->sa_key, paramp->key, 8)
> > == 0) {
> > +				ret = preempt_self(mpp, rq_servact,
> > rq_scope,
> > +						   rq_type, noisy,
> > PREE_WORK_NONE);
> > +				break;
> > +			}
> > +		} else if (memcmp(paramp->sa_key, paramp->key, 8) ==
> > 0) {
> > +			/*
> > +			 * We are self-preempting, but we don't hold
> > the
> > +			 * reservation. This will unregister the
> > device
> 
> key and sa_key are just parameters entered by the caller. How do you
> know, without calling check_holding_reservation(), whether or not we
> currently hold a reservation?

In the "if" statement for this "else", we call
reservation_key_matches(), so we know that nobody is holding a
reservation with "sa_key". Well... no, actually we don't.

reservation_key_matches() could return YNU_UNDEF. In that case who knows
what's going on with the reservation. Perhaps in that case, we check if
we need to do any self preemption (sa_key equals 0 or key). If so, we
just fail, since a failure seems better than silently doing the wrong
thing (either re-registering when we're not supposed to, or not
re-registering when we are supposed to). The most likely reason why
reservation_key_matches() returns YNU_UNDEF is that there are no usable
paths, so we would fail sending the PREEMPT command anyways.

If we don't need to do any self-preemption work, we might as well
attempt to send the command, since it can't hurt. But I'm open to being
convinced that the correct answer is just to always fail if
reservation_key_matches() returns YNU_UNDEF, on the grounds that this
code is complex enough without adding yet another special case
workaround, that is itself likely to fail, since the paths are likely
all down.

-Ben
 
> Regards,
> Martin
> 
> -- 
> Dr. Martin Wilck <mwilck@suse.com>
> SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 Nürnberg,
> Germany
> Geschäftsführer: Jochen Jaser, Andrew McDonald (HRB 36809,AG Nürnberg)


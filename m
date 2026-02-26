Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49A82D7DE7
	for <dm-devel@lists.linux.dev>; Thu, 26 Feb 2026 18:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772131713; cv=none; b=qizxmKc3W86fweHWD/9HXJrCF04OclftGWutXms/674vn/sYN2KgD/NqZpJ+WsmkSjtx+tMf/hWwRhcU9hYklmFeA3Mq5MhXLEFySOxgMwUvDh0aTmIk/BJtTIQZZhHq44a2XF8+CYZG202smNjUzbTs3wWs8u6w4AWN10h3tZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772131713; c=relaxed/simple;
	bh=xHeejQQ+cM7Iy2BOy0AMRSK1sesZBvDSgSw6xqSD9s4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Baad/E4sQpP7qa0pIe6cscQv9GHnS57E/m2Vat9yHtE4Po9gLyX5Xyw4jo1bG2Rxo8yfeK0g1YpDS+P4tyBsUduRIdfUA80c9LEFc92CX3Nlu/yZctZkZXnIQMJXoAEnTbIwYFDzR/7ou3zC0aoeNdoImombWDfFlqEuUn6AjUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PQ4G+HFV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PQ4G+HFV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772131710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K2WZXDs0HItit6i2KadtmDPrKZ0iDFDXIMIdbsXNdh0=;
	b=PQ4G+HFVIxtCgwk5wyO43zIMC6cNNv1ycAEacnSZXJkeDjSt2HI8A/9ruoRGnDeyHu54wn
	56bWyNg10r41c+oVVe0Eabl9h7wI2jCFpgv8ixtw5u36UyyHpx2EyCRicIE9KiXyBtLptx
	xunhMZKB8T46GKaAqUzbeA1wx0/kn3g=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-21-hx7rnFTNOoeq4pLTM4UYVQ-1; Thu,
 26 Feb 2026 13:48:29 -0500
X-MC-Unique: hx7rnFTNOoeq4pLTM4UYVQ-1
X-Mimecast-MFC-AGG-ID: hx7rnFTNOoeq4pLTM4UYVQ_1772131708
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 612F619560AF;
	Thu, 26 Feb 2026 18:48:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F06AF1956053;
	Thu, 26 Feb 2026 18:48:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 61QImQNZ1703751
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 13:48:26 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 61QImQSk1703750;
	Thu, 26 Feb 2026 13:48:26 -0500
Date: Thu, 26 Feb 2026 13:48:26 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH 0/1] checkers: fix race in async TUR and ALUA result
 collection
Message-ID: <aaCVelI_vQZEBihM@redhat.com>
References: <20260224010058.35337-1-brian@purestorage.com>
 <d9355e67dc64b7af940f6b8e6845d0f37565dd34.camel@suse.com>
 <aZ9ec_ce8dCCBzR0@redhat.com>
 <d223eb7cb4088d672b0312d929fa7d2c0e723875.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <d223eb7cb4088d672b0312d929fa7d2c0e723875.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dYGN6ZQZ0QihyjPqYy-X_C2MDqPnNr7MQj7LbbHHLFU_1772131708
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Feb 25, 2026 at 11:00:44PM +0100, Martin Wilck wrote:
> On Wed, 2026-02-25 at 15:41 -0500, Benjamin Marzinski wrote:
> > 
> > I pretty much agree with Martin here. I do think this is likely safe,
> > but I don't think this is really a race. We don't return the status
> > of
> > the thread until the thread completes, and the thread signals its
> > completion by clearing ct->running. That's the same definition of
> > successful thread completion that we use for deciding to kill the
> > thread, and I don't see why it's not a valid one.
> > 
> > Yes we can get the thread result slightly before the thread has
> > completed. But by trusting that the thread will complete once pp-
> > >msgid
> > has changed, we are giving up the ability to kill it if it does hang
> > later, for instance in that condlog() call. On systemd systems, this
> > is
> > just some stdio print functions, but on non-systemd systems, this
> > uses
> > its own pthread locking, and could legitimately hang (although the
> > argument certainly can be made that if this is hanging, multipathd
> > has
> > bigger problems to worry about than an extra tur checker thread lying
> > around).  
> 
> After some further pondering, I wonder if we could do this:
> 
> --- a/libmultipath/checkers/tur.c
> +++ b/libmultipath/checkers/tur.c
> @@ -267,6 +267,7 @@ void *libcheck_thread(struct checker_context *ctx)
>         struct tur_checker_context *ct =
>                 container_of(ctx, struct tur_checker_context, ctx);
>         int state, running;
> +       dev_t devt;
>         short msgid;
>  
>         /* This thread can be canceled, so setup clean up */
> @@ -284,17 +285,17 @@ void *libcheck_thread(struct checker_context
> *ctx)
>         ct->state = state;
>         ct->msgid = msgid;
>         pthread_cond_signal(&ct->active);
> +       running = uatomic_xchg(&ct->running, 0);
>         pthread_mutex_unlock(&ct->lock);
>  
> -       condlog(4, "%d:%d : tur checker finished, state %s", major(ct-
> >devt),
> -               minor(ct->devt), checker_state_name(state));
> -
> -       running = uatomic_xchg(&ct->running, 0);
> +       devt = ct->devt;
>         if (!running)
>                 pause();
>  
>         tur_thread_cleanup_pop(ct);
>  
> +       condlog(4, "%d:%d : tur checker finished, state %s",
> major(devt),
> +               minor(devt), checker_state_name(state));
>         return ((void *)0);
>  }
>  
> @@ -356,7 +357,7 @@ int libcheck_check(struct checker * c)
>                                 pthread_mutex_unlock(&ct->lock);
>                         }
>                         ct->thread = 0;
> -               } else if (uatomic_read(&ct->running) != 0) {
> +               } else if (uatomic_add_return(&ct->running, 0) != 0) {
>                         condlog(3, "%d:%d : tur checker not finished",
>                                 major(ct->devt), minor(ct->devt));
>                         tur_status = PATH_PENDING;
> 
> 
> This way the thread would "lie" about itself being not running any more
> by setting ct->running to 0 before releasing the lock. AFAICS, in the
> worst case, this can cause the main thread not to cancel it even though
> it has timed out. But at this point it has already passed the point at
> which it's most likely to hang. The only point at which it could still
> block is the condlog(). By releasing ct before calling condlog() we can
> make sure that even if the thread now blocks, it can't prevent freeing
> of ct any more. We can basically forget about it at this point.
> 
> Replacing the uatomic_read() by a uatomic_add_return(..., 0) is a hack
> that adds a memory barrier, which, together with the mutex in
> libcheck_thread(), should make sure that the values of ct->running and
> ct->msgid are consistent at this point in libcheck_check().
> 
> Together, these changes should fix Brian's issue.
> 
> The added memory barrier might make libcheck_check() a bit slower. I'm
> not sure whether the difference would be noticeable. I'm not sure why
> we didn't use a barrier there to begin with, perhaps to make this check
> as light-weight as possible. The uatomic_read has been added in c3a839c
> ("libmultipath: cleanup tur locking").
> 
> I'm still undecided if it's worth changing this code in order to
> reinstate some paths 1s earlier in certain sitautions.
> 
> Thoughts?

I don't see any problems with this. But I also didn't see any real
problems with Brian's version (although this version does remove most of
my theoretic issues. Like I said before. If we hang in the condlog,
we've got bigger problems than a stray checker thread). If we do this,
we should probably document the uatomic_add_return() call, or just use
cmm_smp_mb() directly. But I still not sure what we get out of this,
other than a very slight chance to finish the checker a second sooner. I
don't think that really makes a difference, but I don't really see much
risk in the patch either, so I guess I'm fine either way.

-Ben

> 
> Martin


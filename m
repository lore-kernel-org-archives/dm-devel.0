Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164AA3EF643
	for <dm-devel@lists.linux.dev>; Wed, 27 May 2026 10:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779876690; cv=none; b=IvOAFx3Pi+sVKL92A3k9vgr6uhmxU2YtwLbQfSF2en0hBR8fjAZT3z9rCQi5Le9KsBmCtfdMjMC6qvZGigP4IQP9uUuUlzFLBOGuRshnBHgNwCvHN54Ir5cuQy5fW5aURdi9UfH7QzYqN7VWw07+j1Ds7cz6tVbsGYm5YslBEb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779876690; c=relaxed/simple;
	bh=2McuH50RSR4xlnaqf6KkktbqZDDhUAfD4hS19kceYt0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Wotnc4nu2ZQuUGrRySYGEkyK/q8wpPcI67HCX4x0Ro5ihLVvtEwpPQFHbXFZ0aKDdyu5PJlPpSWAI/O+qIduSHH5DIUaBGypO4SIy6PEFOVYh07hEPw3t4v8JKb4kWj4IluebiqzrsUeeT5oIo2IBabjg/OFCuurFQeFbZA7bas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=G1VUkTWe; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PtLfbQAX; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="G1VUkTWe";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PtLfbQAX"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F09B266E27;
	Wed, 27 May 2026 10:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779876680; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dnayMlCxb0oK0G+pttWYQRMhbBda9rggLR9PfJsHHyU=;
	b=G1VUkTWelhbSUzvyr1fTUGrIfilmKVfQFmmV2rusiboqYPJXfOgs3MthkBITLGsFYgo6kr
	cxrXrAbCqqs3RNfEiXl7L+It/fmqlzcaQmyQoD9+Od/gF/5ie1oy8g5m0hJ7W3quw1SQz6
	6lazbLPKImZjoc4LxoyYI4gC9ymZFUs=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=PtLfbQAX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779876679; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dnayMlCxb0oK0G+pttWYQRMhbBda9rggLR9PfJsHHyU=;
	b=PtLfbQAX91Yu/A0mGeOr5OdTj8R6fTBleGqDPc+nGSilcWXfjrefKt4O+VR2Q5Ze8QKmj2
	wezPW2sjSzu9GnzfCpx8ku3EdnxYJALpRdRZu7bnmN7rX44FV6VHsjVi/Pt/ahKwogE0hJ
	y8WjEIvq5wnYg+hFF/QBxXHie9wcz08=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C625A5A796;
	Wed, 27 May 2026 10:11:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id p0BJL0fDFmoEWwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 27 May 2026 10:11:19 +0000
Message-ID: <f4188f6ac60be14ca4ee325f776a89184e7ef01a.camel@suse.com>
Subject: Re: [PATCH v2 09/19] libmpathutil: runner: use shared_ptr
From: Martin Wilck <mwilck@suse.com>
To: Hannes Reinecke <hare@suse.de>, Christophe Varoqui	
 <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>,
  Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Wed, 27 May 2026 12:11:19 +0200
In-Reply-To: <5cb00fa3-159b-4463-9599-55c7f8ba702f@suse.de>
References: <20260522164415.846589-1-mwilck@suse.com>
	 <20260522164415.846589-10-mwilck@suse.com>
	 <5cb00fa3-159b-4463-9599-55c7f8ba702f@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: F09B266E27
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]

On Wed, 2026-05-27 at 11:40 +0200, Hannes Reinecke wrote:
> On 5/22/26 18:44, Martin Wilck wrote:
> > Use shared_ptr to track the runner_context refcount.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =C2=A0 libmpathutil/runner.c | 30 +++++++++---------------------
> > =C2=A0 1 file changed, 9 insertions(+), 21 deletions(-)
> >=20
> > diff --git a/libmpathutil/runner.c b/libmpathutil/runner.c
> > index 8c6d6b9..56abd03 100644
> > --- a/libmpathutil/runner.c
> > +++ b/libmpathutil/runner.c
> > @@ -30,7 +30,6 @@ const char *runner_state_name(int state)
> > =C2=A0 }
> > =C2=A0=20
> > =C2=A0 struct runner_context {
> > -	int refcount;
> > =C2=A0=C2=A0	int status;
> > =C2=A0=C2=A0	struct timespec deadline;
> > =C2=A0=C2=A0	pthread_t thr;
> > @@ -39,17 +38,6 @@ struct runner_context {
> > =C2=A0=C2=A0	char __attribute__((aligned(sizeof(void *)))) data[];
> > =C2=A0 };
> > =C2=A0=20
> > -static void release_context(struct runner_context *rctx)
> > -{
> > -	int n;
> > -
> > -	n =3D uatomic_sub_return(&rctx->refcount, 1);
> > -	assert(n >=3D 0);
> > -
> > -	if (n =3D=3D 0)
> > -		free(rctx);
> > -}
> > -
> > =C2=A0 static void cleanup_context(struct runner_context **prctx)
> > =C2=A0 {
> > =C2=A0=C2=A0	struct runner_context *rctx =3D *prctx;
> > @@ -65,7 +53,7 @@ static void cleanup_context(struct runner_context
> > **prctx)
> > =C2=A0=C2=A0			"%s: runner %p finished in state '%s'",
> > __func__, rctx,
> > =C2=A0=C2=A0			runner_state_name(st));
> > =C2=A0=C2=A0	}
> > -	release_context(rctx);
> > +	put_shared_ptr(rctx);
> > =C2=A0 }
> > =C2=A0=20
> > =C2=A0 static void *runner_thread(void *arg)
> > @@ -147,7 +135,7 @@ repeat:
> > =C2=A0 void release_runner(struct runner_context *rctx)
> > =C2=A0 {
> > =C2=A0=C2=A0	cancel_runner(rctx);
> > -	release_context(rctx);
> > +	put_shared_ptr(rctx);
> > =C2=A0 }
> > =C2=A0=20
> > =C2=A0 int check_runner(struct runner_context *rctx, void *data,
> > unsigned int size)
> > @@ -195,17 +183,17 @@ struct runner_context *get_runner(runner_func
> > func, void *data,
> > =C2=A0=C2=A0		return NULL;
> > =C2=A0=C2=A0	}
> > =C2=A0=20
> > -	rctx =3D malloc(sizeof(*rctx) + size);
> > +	rctx =3D alloc_shared_ptr(sizeof(*rctx) + size, NULL);
> > =C2=A0=C2=A0	if (!rctx)
> > =C2=A0=C2=A0		return NULL;
> > =C2=A0=20
> > =C2=A0=C2=A0	rctx->func =3D func;
> > =C2=A0=C2=A0	/*
> > -	 * We have to set the refcount to 2 here. The runner
> > thread may be
> > -	 * cancelled before it even had the chance to increase the
> > refcount,
> > -	 * which could result in a use-after-free in
> > cleanup_context().
> > +	 * Take an additional reference here. The runner thread
> > may be
> > +	 * cancelled before it even had the chance to take a
> > reference, which
> > +	 * could result in a use-after-free in cleanup_context().
> > =C2=A0=C2=A0	 */
> > -	uatomic_set(&rctx->refcount, 2);
> > +	get_shared_ptr(rctx);
> > =C2=A0=C2=A0	uatomic_set(&rctx->status, RUNNER_IDLE);
> > =C2=A0=C2=A0	memcpy(rctx->data, data, size);
> > =C2=A0=20
> > @@ -222,8 +210,8 @@ struct runner_context *get_runner(runner_func
> > func, void *data,
> > =C2=A0=20
> > =C2=A0=C2=A0	if (rc) {
> > =C2=A0=C2=A0		condlog(1, "%s: pthread_create(): %s", __func__,
> > strerror(rc));
> > -		uatomic_dec(&rctx->refcount);
> > -		release_context(rctx);
> > +		put_shared_ptr(rctx);
> > +		put_shared_ptr(rctx);
> > =C2=A0=C2=A0		return NULL;
> > =C2=A0=C2=A0	}
> > =C2=A0=C2=A0	return rctx;
>=20
> Hmm. While I fully get the idea why one would want to use refcounted=20
> objects, there really is only one snag: this is multipath.
> We really, _really_, should make sure the daemon can execute even if
> the root filesystem is not available.
> So if we start dropping the reference for the checker (eg if the last
> path drops and the checker is no longer used), we might end up
> freeing
> the memory (and dropping the modules altogether).

I am pretty sure that we handle this correctly. The current patch set=20
doesn't change anything in this respect, except translating the hard-
coded refcounting into the shared_ptr framework.

> But if the path comes back we need to reinstate the checker, which
> not
> only requires additional memory (which might need a recursion into
> the
> filesystem to get free pages) but we also might need to read the
> checker
> module from disk (again). So plenty of opportunity to deaslock
> waithing
> for the disk be become readable.

In checker_get(), we call add_checker_class() if the class is not yet
loaded, which will take one ref on the class, and then get_shared_ptr()
for every path (including the one for which add_checker_class() had
been called), which means we have (number of paths + 1) references on
the class, and will only drop the last ref when multipathd calls
cleanup_checkers() during exit.

Therefore I don't think it's possible that we unload the shared library
prematurely, and have to reload it later.

Regards
Martin

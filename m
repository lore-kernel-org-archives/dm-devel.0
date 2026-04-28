Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F253FB067
	for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 10:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777373262; cv=none; b=g6cXTfnSiEporHKJYCWmeOodn1qdwZEFtzOiJpadV8Fyk4xYD2Gh95qeLTZyM11j42sbo+sT5T471EEogFfIyR6QKSpSeG3dL0tXAi0SdPpy7jGSG/MsYAN5cKQ54zwTwWRUoXTmQDYzHhlSkT4l2psB5jI8X/FiqbZ6hOJoF18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777373262; c=relaxed/simple;
	bh=O918bV/K5sjnS+3JttgF+Qh2bG/r0wFplRTCZRJyLoQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mCpIh/Eum3whb+ZNWz0keoSitqqmYSFG0VXe/KNMoOTPIQOAqI8HiKQubrDssrYni/J5wR6FEgWYfYGAhdeC3BCaK9oRY84HKF6yBkNEL91sODN0tdGEnYeyktfePRQDdISvEtRWAepKXrpt8Vc8PG9BekI7+jPOqmBRHUSHkRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=e1hfddos; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=e1hfddos; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="e1hfddos";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="e1hfddos"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5F0885BCC9;
	Tue, 28 Apr 2026 10:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777373259; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q6Yk8eSjxwV88kLh3rCkK5htFAvx05lt+TH1xVWdj6E=;
	b=e1hfddosD4Q0KUoX3OaNTTr1jMycygSwl+NGhP1GIXHrTx1c3Uvz266QOvCRrl2+8VsMAF
	tGNZlihaDFI2h6eZYket/qcZbDVQWN6pHc+oc6GkDKyNUbsYQK3oANzvBF5XOXDTwy4C4J
	7dto6112vCveUMSN9fNX9zEh3/88qp4=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777373259; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q6Yk8eSjxwV88kLh3rCkK5htFAvx05lt+TH1xVWdj6E=;
	b=e1hfddosD4Q0KUoX3OaNTTr1jMycygSwl+NGhP1GIXHrTx1c3Uvz266QOvCRrl2+8VsMAF
	tGNZlihaDFI2h6eZYket/qcZbDVQWN6pHc+oc6GkDKyNUbsYQK3oANzvBF5XOXDTwy4C4J
	7dto6112vCveUMSN9fNX9zEh3/88qp4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3EF03593B0;
	Tue, 28 Apr 2026 10:47:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LAlKDkuQ8GkJQwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 28 Apr 2026 10:47:39 +0000
Message-ID: <6318cdc91d7531b29b9565395dc8a17c09e1127f.camel@suse.com>
Subject: Re: [PATCH v2 2/5] libmpathutil: add generic implementation for
 checker thread runners
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, Brian Bunker
	 <brian@purestorage.com>, dm-devel@lists.linux.dev
Date: Tue, 28 Apr 2026 12:47:38 +0200
In-Reply-To: <ae_9U_JAoiihraT4@redhat.com>
References: <20260423204446.472642-1-mwilck@suse.com>
	 <20260423204446.472642-3-mwilck@suse.com> <ae_9U_JAoiihraT4@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.987];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

Hi Ben,

On Mon, 2026-04-27 at 20:20 -0400, Benjamin Marzinski wrote:
> On Thu, Apr 23, 2026 at 10:44:43PM +0200, Martin Wilck wrote:
> > This code adds a generic, abstract implementation of the kind of
> > threads we
> > need for checkers: detached threads that may time out. The design
> > is such
> > that these threads never access any memory of the calling program,
> > simplifying the management of lifetimes of objects.
> >=20
> > See the documentation of the API in "runner.h".
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =C2=A0libmpathutil/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +-
> > =C2=A0libmpathutil/libmpathutil.version |=C2=A0=C2=A0 7 +-
> > =C2=A0libmpathutil/runner.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 221
> > ++++++++++++++++++++++++++++++
> > =C2=A0libmpathutil/runner.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 102 ++++++++++++++
> > =C2=A04 files changed, 330 insertions(+), 2 deletions(-)
> > =C2=A0create mode 100644 libmpathutil/runner.c
> > =C2=A0create mode 100644 libmpathutil/runner.h
> >=20
> >=20
[...]
> > diff --git a/libmpathutil/runner.c b/libmpathutil/runner.c
> > new file mode 100644
> > index 0000000..f5c5482
> > --- /dev/null
> > +++ b/libmpathutil/runner.c
[...]
> > +static void *runner_thread(void *arg)
> > +{
> > +	int st, refcount;
> > +	/*
> > +	 * The cleanup function makes sure memory is freed if the
> > thread is
> > +	 * cancelled (-fexceptions).
> > +	 */
> > +	struct runner_context *rctx
> > __attribute__((cleanup(cleanup_context))) =3D arg;
> > +
> > +	refcount =3D uatomic_add_return(&rctx->refcount, 1);
> > +	assert(refcount =3D=3D 2);
> > +
> > +	st =3D uatomic_cmpxchg(&rctx->status, RUNNER_IDLE,
> > RUNNER_RUNNING);
> > +	/*
> > +	 * The thread has already been cancelled before it was
> > even started.
> > +	 * In this case, cancel_runner() doesn't release the
> > context.
> > +	 * Do it here. See comments for RUNNER_IDLE in
> > cancel_runner().
> > +	 */
>=20
> I'm confused about this, and AFAICS, it doesn't appear to be true. If
> you call check_runner() and it returns RUNNER_CANCELLED, you have no
> idea if the runner was previously in RUNNER_IDLE, which means that
> you
> cannot touch the context anymore, or if the runner was in
> RUNNER_RUNNING, in which case it's your job to release the context.
> In the TUR checker, check_runner_state() just calls release_runner(),
> which will cause a UAF error if the runner was in RUNNER_IDLE before
> it got cancelled.

Right, good catch, thanks for finding it. This was a remnant of the
previous code, where the caller didn't have to release the context
after RUNNER_CANCELLED.=C2=A0

Releasing the context here is just wrong, I'll drop the line.

I had expected my tests to capture an UAF like this, but I made a dumb
mistake: I used a timeout of 0 in my test code, which means "infinite"
timeout for the runner, and thus my first test case, which was intended
to capture thus this kind of issue, was ineffective. I will change my
test program now to use 1us timeout if "-t 0" is specified. I will also
add a compile-time option to artificially delay thread startup in order
to test this.

> It seems to me that the correct way to do this would be to set
> rctx->refcount to 2 before creating the runner thread, and not even
> have
> a RUNNER_IDLE state.=C2=A0

Correct, too. I was totally na=C3=AFve to rely on the thread itself
increasing the refcount if I allow the thread to be cancelled before
it even starts :-/

However, I think I'll keep RUNNER_IDLE state around. It doesn't hurt
and it provides possible insight into whether or not the runner
function was actually called.

> Perhaps I'm just being stupid, but I don't see the
> necessity. If you set a thread to deferred cancellation, I don't
> believe
> it can get cancelled between when you create it, and when it hits
> it's
> first cancellation point, so you shouldn't have to worry about
> getting
> cancelled before the runner's cleanup_context handler isset up. I'm
> pretty sure that if the thread gets created successfully, it should
> always drop its reference count when it exits, regardless of if/when
> it
> gets cancelled. And if you fail to create the thread, you can just
> drop
> the refcount back to 1 before calling release_context() in
> get_runner().

I believe that it's possible for pthread_create() to succeed and the
program to terminate before the thread is started. In which case the
thread's cleanup code won't be set up, and the context won't be freed.
But we explicitly don't want to wait for these threads, so I think
that's a cosmetic problem in a corner case that we don't need to bother
with.

Thanks,
Martin

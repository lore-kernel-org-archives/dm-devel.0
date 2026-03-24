Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609F63F7AAD
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 12:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774355090; cv=none; b=eCFjJPBKvhyanG7Ozgm1Y0mLnBJs5tYzueOAoKemvBJN6K8+b871rYK631IeAPefVIJ1D6lMNrc2/QCG7VPWWToqlS+2Os96xISPp8G4w8dX0uo4uA/agae0njuB8aTu5uweiSiMOroMN6X+olFFJqxlM4kmdRjmgHCaJGV1Hs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774355090; c=relaxed/simple;
	bh=iqGWOF58rB7jnra/nYEyur0MwQge0NGF2qbTDZoCXiw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Pocdvn7QfBiIVv376H+OJegAW0v42U3TVlH99kQ1irZVlFXCwSMg5P90ppUjvlwC7IJPFQkBLnlHNUuCHhlzLf09aM8fOj7WHrzvXqfMOX3X8StvOKoV2rm8qCs6IQvL1qRdplBqcC34X73NNW5pZKIFVJINi+1wQ5WvbHMsMSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DLyp6bGu; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DLyp6bGu; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DLyp6bGu";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DLyp6bGu"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8F7195BD26;
	Tue, 24 Mar 2026 12:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774355086; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IXPSkFBYnPcqoGdhZxxS+cU27syAF3vX2tsBfH08Ahc=;
	b=DLyp6bGutL7NF1KsugwJaMo3N52heb+hewyOol7x8yaYW4c5pi++zeeMaEk/StyIxDFWBS
	SEvxTnYy4BLOmHxzK29WV8GUPAdjKsm+27oEH1l3s8R4UabmW8rA8Hu5VQ2ZdBhkk6XIko
	P262qzE2KxfsA1SnytJsDdMUK2QM53w=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=DLyp6bGu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774355086; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IXPSkFBYnPcqoGdhZxxS+cU27syAF3vX2tsBfH08Ahc=;
	b=DLyp6bGutL7NF1KsugwJaMo3N52heb+hewyOol7x8yaYW4c5pi++zeeMaEk/StyIxDFWBS
	SEvxTnYy4BLOmHxzK29WV8GUPAdjKsm+27oEH1l3s8R4UabmW8rA8Hu5VQ2ZdBhkk6XIko
	P262qzE2KxfsA1SnytJsDdMUK2QM53w=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6DB9B43E2E;
	Tue, 24 Mar 2026 12:24:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Vs6jGY6CwmnSZgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 24 Mar 2026 12:24:46 +0000
Message-ID: <864592419104ecd1c1e5d13b0f091dc57d04badf.camel@suse.com>
Subject: Re: [PATCH 4/4] libmultipath: TUR checker: use runner threads
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, Brian Bunker
	 <brian@purestorage.com>, dm-devel@lists.linux.dev
Date: Tue, 24 Mar 2026 13:24:45 +0100
In-Reply-To: <acIxXt69d6JkDtlQ@redhat.com>
References: <20260319221344.753790-1-mwilck@suse.com>
	 <20260319221344.753790-5-mwilck@suse.com> <acIxXt69d6JkDtlQ@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	URIBL_BLOCKED(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 8F7195BD26

On Tue, 2026-03-24 at 02:38 -0400, Benjamin Marzinski wrote:
> On Thu, Mar 19, 2026 at 11:13:44PM +0100, Martin Wilck wrote:
> > Use the generic runners to simplify the TUR checker code.
> >=20
> > The logic is the same as before, with one exception: the runner API
> > does
> > not allow to track a thread after it has been cancelled, like our
> > current
> > code does. The current code used this to determine when a
> > previously
> > cancelled thread eventually did complete. The use case for doing
> > this in
> > the current code was the MAX_NR_RUNNERS logic: the code waited
> > "forever"
> > for the "last" checker to complete. This is not possible with
> > runners;
> > once a runner is cancelled, it is off limits. (Waiting for a zombie
> > thread to
> > write to memory belonging to the main program, as the current code
> > does,
> > doesn't seem to be the best idea, anyway).
> >=20
> > Therefore this patch implements a different logic for
> > MAX_NR_RUNNERS. When
> > nr_timeouts reaches the limit, the last checker is spawned with an
> > infinite
> > timeout. Like before, no new checker thread will be spawned until
> > this last
> > checker eventually completes. One difference to the previous code
> > is that
> > this last checker thread is never cancelled (after all, it never
> > times
> > out). But this code is meant for the case where cancellation is not
> > effective, anyway. Another difference is that the new code will
> > report
> > PATH_TIMEOUT state as soon as this last thread is started rather
> > than
> > PATH_PENDING. That seems reasonable given that the checker
> > previously timed
> > out for this thread.
>=20
> I'm not super enthused about this way of handling the misbehaving
> threads. It's probably o.k. But what if the issue is that the checker
> isn't completing by itself at all, but it would eventually get
> cancelled, just not till after we timeout. In this case, we should be
> cancelling that last runner. Admittedly, it's kinda hard to believe
> that
> a new runner would work correctly, while the old one still is stuck
> needing to be cancelled, but what we had before definitely worked.

Well, not relying on a cancelled, detached zombie thread to eventually
modify some shared memory location was a design principle of this new
code.

But of course I realize that this does represent a change for those
cases where a checker doesn't complete but can still be forced to
return by cancellation. Is this a reasonable scenario? SG_IO on sd
devices, which is what our checkers do, will go to uninterruptible
sleep in blk_execute_rq(), and thus can't be cancelled (it _should_
time out, though, unless the kernel misbehaves). It would be a
different thing if we used sg devices instead...

>=20
> I don't really see why we can't continue with roughly what we had
> before. We just need a new state for check_runner_state() to return.
> Something like RUNNER_STOPPING. cancel_runner() would cmpxchg with
> RUNNER_STOPPING, and not free the runner_context. In check_runner(),
> if
> the state was RUNNER_STOPPING or you just called cancel_runner(), you
> would check the ctx->refcount. If it was already 1, you would release
> the context and return RUNNER_CANCELLED. This way RUNNER_CANCELLED
> still
> means that the context has been freed, but it would only happen when
> the
> thread has ended.

That sort of logic is dangerous, IMO. I'd prefer to use only
uatomic_sub_return() on the refcount.

>  If you want to stop paying attention to a runner in
> RUNNER_STOPPING, you just call release_context() manually to drop
> your
> reference without waiting for it to finish.
>=20
> Then, if you still have a runner in RUNNER_STOPPING after calling
> check_runner_state() at the start of libcheck_check(), you drop your
> reference to it if ct->nr_timeouts < MAX_NR_TIMEOUTS. Otherwise you
> just
> return PATH_TIMEOUT.
>=20
> Thoughts? Like I said, I think what you have will probably be fine.
> I just know what we had before worked.
>=20

I'll try to figure something out. No matter what I do, the API for the
caller will get more complicated and error-prone, because it will need
to track the lifetime of the runner's memory somehow (and if we do
that, we might as well give up the idea of just using memcpy() to avoid
shared memory issues).

> More comments below.
>=20
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =C2=A0libmultipath/checkers/tur.c | 341 +++++++++++--------------------=
-
> > ----
> > =C2=A01 file changed, 103 insertions(+), 238 deletions(-)
> >=20
> > diff --git a/libmultipath/checkers/tur.c
> > b/libmultipath/checkers/tur.c
> > index ba4ca68..6f22c45 100644
> > --- a/libmultipath/checkers/tur.c
> > +++ b/libmultipath/checkers/tur.c
> > @@ -3,7 +3,6 @@
> > =C2=A0 *
> > =C2=A0 * Copyright (c) 2004 Christophe Varoqui
> > =C2=A0 */
> > -#include <stdio.h>
> > =C2=A0#include <stdlib.h>
> > =C2=A0#include <string.h>
> > =C2=A0#include <sys/types.h>
> > @@ -17,13 +16,13 @@
> > =C2=A0#include <pthread.h>
> > =C2=A0#include <urcu.h>
> > =C2=A0#include <urcu/uatomic.h>
> > +#include <assert.h>
> > =C2=A0
> > =C2=A0#include "checkers.h"
> > =C2=A0
> > =C2=A0#include "debug.h"
> > =C2=A0#include "sg_include.h"
> > -#include "util.h"
> > -#include "time-util.h"
> > +#include "runner.h"
> > =C2=A0
> > =C2=A0#define TUR_CMD_LEN 6
> > =C2=A0#define HEAVY_CHECK_COUNT=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 10
> > @@ -45,21 +44,20 @@ const char *libcheck_msgtable[] =3D {
> > =C2=A0	NULL,
> > =C2=A0};
> > =C2=A0
> > -struct tur_checker_context {
> > -	dev_t devt;
> > -	int state;
> > -	int running; /* uatomic access only */
> > +struct tur_context {
> > =C2=A0	int fd;
> > +	dev_t devt;
> > =C2=A0	unsigned int timeout;
> > -	time_t time;
> > -	pthread_t thread;
> > -	pthread_mutex_t lock;
> > -	pthread_cond_t active;
> > -	int holders; /* uatomic access only */
> > -	int msgid;
> > +	int state;
> > +	short msgid;
> > +};
> > +
> > +struct tur_checker_context {
> > =C2=A0	struct checker_context ctx;
> > +	int last_runner_state;
> > =C2=A0	unsigned int nr_timeouts;
> > -	bool checked_state;
> > +	struct runner_context *rtx;
> > +	struct tur_context tcx;
>=20
> There are lots of structures named *_context with names like *tx.
> Perhaps we could rename the tur_context something like tur_data?
>=20
> Also, ctx is the checker_context here, and the runner_contect in the
> runner.c code. I think it would be easier to follow and grep if we
> kept
> the runner_context named rtx in both places.
>=20
> > =C2=A0};
> > =C2=A0
> > =C2=A0int libcheck_init (struct checker * c)
> > @@ -67,48 +65,26 @@ int libcheck_init (struct checker * c)
> > =C2=A0	struct tur_checker_context *ct;
>=20
> Also the tur_checker_context is tcc in every function but this one. I
> think it helpful to always have the same name.
>=20
>=20

Right, I wasn't so happy about the variable naming either. I kept ct
here because this is what it used to be. I'll try to make it more
consistent in v2.

> > =C2=A0	}
> > =C2=A0
> > -	return tur_status;
> > +	/* create new checker thread */
> > +	ct->tcx.fd =3D c->fd;
> > +	ct->tcx.timeout =3D c->timeout;
> > +
> > +	if (ct->nr_timeouts < MAX_NR_TIMEOUTS) {
> > +		condlog(3, "%d:%d : starting checker with
> > timeout",
> > +			major(ct->tcx.devt), minor(ct->tcx.devt));
> > +		ct->tcx.state =3D PATH_PENDING;
> > +		ct->tcx.msgid =3D MSG_TUR_RUNNING;
> > +		ct->rtx =3D get_runner(runner_callback, &ct->tcx,
> > +				=C2=A0=C2=A0=C2=A0=C2=A0 sizeof(ct->tcx), 1000000 * c-
> > >timeout);
> > +	} else {
> > +		condlog(3, "%d:%d : starting checker without
> > timeout",
> > +			major(ct->tcx.devt), minor(ct->tcx.devt));
> > +		ct->tcx.state =3D PATH_TIMEOUT;
>=20
> shouldn't we set ct->tcx.msgid =3D MSG_TUR_MSG_TUR_TIMEOUT here?
>=20

This was on purpose, but of course debatable. My thinking was this: The
previous checker has timed out and we're just retrying, therefore
setting PATH_TIMEOUT correctly reflects the state. But the message,
which is mainly for the user, might as well express the fact that
another checker is indeed currently running.

If we change the timeout logic, this change will be obsolete anyway.

Regards
Martin

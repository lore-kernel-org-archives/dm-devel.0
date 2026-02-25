Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153ED3176E0
	for <dm-devel@lists.linux.dev>; Wed, 25 Feb 2026 22:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772056848; cv=none; b=PDSXueLu03X014SJhvT0GgyvhHX13awSnF8eZbMSu0qQLYz/ln/RQKQJLD/iTbv0zEOlCRICg5XVcmERHS5YuRV04YzYw4YqvknArXv4tW8S+1qnrUiu5Lv2EQh4HDJo6QXrhEngN6th5I/q6A9thY89bjCEbXjPJC1lzGT5XTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772056848; c=relaxed/simple;
	bh=HggH2ESMnuwfbVHxKbswX/liDq9ImPnUAby6G7qHaF8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZzyVYXTHU/lUIPThQnIRZVKlnkVJZivuLavdCJJlQM5ZAO66Al2rEta4Bko2X43WFcNM6dQzoXBv9c8+rlbo5x9UYO4Jkf3w4cwJD3HH6AVEPgNBoEVWvdKUUuRB413k+fTzINzswp39kZ5R3YadcJswpJMZXr/Uuec0M7JQixM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kMVwOgdG; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kMVwOgdG; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kMVwOgdG";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kMVwOgdG"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 351B35BE10;
	Wed, 25 Feb 2026 22:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1772056845; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KSffuIPzEzXz7tTRH9rHFMXERV+ZrJtB9vNgz8HlXio=;
	b=kMVwOgdGersmC5mSMhxgyAkAy2Q9NdMxCFPpWnwhstuE2URqJWo3sduC9S569lPAoQaaQW
	kbPVZOxyeYsF7CqpkMkRdAjuTztqJre2HRsN82e3Jc06GT3toSJ5B32C94MXhcjtBnwWL9
	bwoQGdS77G1ClGyqH4h1vdX9uFIL22o=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1772056845; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KSffuIPzEzXz7tTRH9rHFMXERV+ZrJtB9vNgz8HlXio=;
	b=kMVwOgdGersmC5mSMhxgyAkAy2Q9NdMxCFPpWnwhstuE2URqJWo3sduC9S569lPAoQaaQW
	kbPVZOxyeYsF7CqpkMkRdAjuTztqJre2HRsN82e3Jc06GT3toSJ5B32C94MXhcjtBnwWL9
	bwoQGdS77G1ClGyqH4h1vdX9uFIL22o=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0D6C93EA65;
	Wed, 25 Feb 2026 22:00:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dHspAg1xn2nhKAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 25 Feb 2026 22:00:45 +0000
Message-ID: <d223eb7cb4088d672b0312d929fa7d2c0e723875.camel@suse.com>
Subject: Re: [PATCH 0/1] checkers: fix race in async TUR and ALUA result
 collection
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev
Date: Wed, 25 Feb 2026 23:00:44 +0100
In-Reply-To: <aZ9ec_ce8dCCBzR0@redhat.com>
References: <20260224010058.35337-1-brian@purestorage.com>
	 <d9355e67dc64b7af940f6b8e6845d0f37565dd34.camel@suse.com>
	 <aZ9ec_ce8dCCBzR0@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On Wed, 2026-02-25 at 15:41 -0500, Benjamin Marzinski wrote:
>=20
> I pretty much agree with Martin here. I do think this is likely safe,
> but I don't think this is really a race. We don't return the status
> of
> the thread until the thread completes, and the thread signals its
> completion by clearing ct->running. That's the same definition of
> successful thread completion that we use for deciding to kill the
> thread, and I don't see why it's not a valid one.
>=20
> Yes we can get the thread result slightly before the thread has
> completed. But by trusting that the thread will complete once pp-
> >msgid
> has changed, we are giving up the ability to kill it if it does hang
> later, for instance in that condlog() call. On systemd systems, this
> is
> just some stdio print functions, but on non-systemd systems, this
> uses
> its own pthread locking, and could legitimately hang (although the
> argument certainly can be made that if this is hanging, multipathd
> has
> bigger problems to worry about than an extra tur checker thread lying
> around).=C2=A0=20

After some further pondering, I wonder if we could do this:

--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -267,6 +267,7 @@ void *libcheck_thread(struct checker_context *ctx)
        struct tur_checker_context *ct =3D
                container_of(ctx, struct tur_checker_context, ctx);
        int state, running;
+       dev_t devt;
        short msgid;
=20
        /* This thread can be canceled, so setup clean up */
@@ -284,17 +285,17 @@ void *libcheck_thread(struct checker_context
*ctx)
        ct->state =3D state;
        ct->msgid =3D msgid;
        pthread_cond_signal(&ct->active);
+       running =3D uatomic_xchg(&ct->running, 0);
        pthread_mutex_unlock(&ct->lock);
=20
-       condlog(4, "%d:%d : tur checker finished, state %s", major(ct-
>devt),
-               minor(ct->devt), checker_state_name(state));
-
-       running =3D uatomic_xchg(&ct->running, 0);
+       devt =3D ct->devt;
        if (!running)
                pause();
=20
        tur_thread_cleanup_pop(ct);
=20
+       condlog(4, "%d:%d : tur checker finished, state %s",
major(devt),
+               minor(devt), checker_state_name(state));
        return ((void *)0);
 }
=20
@@ -356,7 +357,7 @@ int libcheck_check(struct checker * c)
                                pthread_mutex_unlock(&ct->lock);
                        }
                        ct->thread =3D 0;
-               } else if (uatomic_read(&ct->running) !=3D 0) {
+               } else if (uatomic_add_return(&ct->running, 0) !=3D 0) {
                        condlog(3, "%d:%d : tur checker not finished",
                                major(ct->devt), minor(ct->devt));
                        tur_status =3D PATH_PENDING;


This way the thread would "lie" about itself being not running any more
by setting ct->running to 0 before releasing the lock.=C2=A0AFAICS, in the
worst case, this can cause the main thread not to cancel it even though
it has timed out. But at this point it has already passed the point at
which it's most likely to hang. The only point at which it could still
block is the condlog(). By releasing ct before calling condlog() we can
make sure that even if the thread now blocks, it can't prevent freeing
of ct any more. We can basically forget about it at this point.

Replacing the uatomic_read() by a uatomic_add_return(..., 0) is a hack
that adds a memory barrier, which, together with the mutex in
libcheck_thread(), should make sure that the values of ct->running and
ct->msgid are consistent at this point in libcheck_check().

Together, these changes should fix Brian's issue.

The added memory barrier might make libcheck_check() a bit slower. I'm
not sure whether the difference would be noticeable. I'm not sure why
we didn't use a barrier there to begin with, perhaps to make this check
as light-weight as possible. The uatomic_read has been added in c3a839c
("libmultipath: cleanup tur locking").

I'm still undecided if it's worth changing this code in order to
reinstate some paths 1s earlier in certain sitautions.

Thoughts?

Martin

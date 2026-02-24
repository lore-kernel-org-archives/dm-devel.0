Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FBD39E16A
	for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 13:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771939588; cv=none; b=c53w3BUiGWFWj80Tv5XYS+7EmlAOa249Fv+vx51PF8CjjJNPFqPjuLcCq+oWrYzbyh4IYvYauEcRl175Pd7disPVgQLq/PUm7mDdbK0dixpnLh9Gado5xRA8Rbe577jETf6bz5xVEhDVcC+9Ee56Z5hte1fwt8dftLmVQO8gBYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771939588; c=relaxed/simple;
	bh=f2hOyaUiwyM+L9e7NV9Q0Zj8nAujqLtmGF1uHjfHWwg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TjQYjnTWEQ9i8UDSNTnYaQqfksdEG0NIQ6jr+KHGFR5jgtR8arbGHOEpEfY8U1CyhNts7P3olmEbSReQ1wcFi8dRjMnM58McWpgkwNRxN+sTY7/2zy8lKnrIKvfML0Ej0rhpHcaC+8yF9sQATb/9MZ/cTS3OqsVzU3rc4FO152s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=lAl/ixpa; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=lAl/ixpa; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="lAl/ixpa";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="lAl/ixpa"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9B89A5BCD9;
	Tue, 24 Feb 2026 13:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771939583; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4J53injnWYa//bcmtv1ePdUrXmZme0ogyWX73sft3IQ=;
	b=lAl/ixpav1bNhAXqPohtGgJFsfb8Bk1za71xP/sG0jiJf9xw4VICo3BSRYz7HX8KmuFlmO
	WJlGpBh9jmwJu1XIaKoUqA5+XnV457RKrsNZzksoGVZLWKLZnDnOo0c6/gRSVkFn0MTo4a
	Nb2tJdgGnQeYbV2Fkc5TLpf/X1WMmBg=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="lAl/ixpa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771939583; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4J53injnWYa//bcmtv1ePdUrXmZme0ogyWX73sft3IQ=;
	b=lAl/ixpav1bNhAXqPohtGgJFsfb8Bk1za71xP/sG0jiJf9xw4VICo3BSRYz7HX8KmuFlmO
	WJlGpBh9jmwJu1XIaKoUqA5+XnV457RKrsNZzksoGVZLWKLZnDnOo0c6/gRSVkFn0MTo4a
	Nb2tJdgGnQeYbV2Fkc5TLpf/X1WMmBg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7514D3EA68;
	Tue, 24 Feb 2026 13:26:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BZN8G/+mnWnuBwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 24 Feb 2026 13:26:23 +0000
Message-ID: <d9355e67dc64b7af940f6b8e6845d0f37565dd34.camel@suse.com>
Subject: Re: [PATCH 0/1] checkers: fix race in async TUR and ALUA result
 collection
From: Martin Wilck <mwilck@suse.com>
To: Brian Bunker <brian@purestorage.com>, bmarzins@redhat.com
Cc: dm-devel@lists.linux.dev
Date: Tue, 24 Feb 2026 14:26:22 +0100
In-Reply-To: <20260224010058.35337-1-brian@purestorage.com>
References: <20260224010058.35337-1-brian@purestorage.com>
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
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 9B89A5BCD9

Hi Brian,

On Mon, 2026-02-23 at 17:00 -0800, Brian Bunker wrote:
> Fix a race condition in libcheck_check() for both the TUR and ALUA
> async
> checkers where a completed result could be missed, returning
> PATH_PENDING
> unnecessarily.

First of all, you should have cc'd the dm-devel mailing list.

Second, you call this a race condition, but what negative effect does
it actually have? AFAIU this "race condition" just delays returning the
new checker state by a single tick (i.e. 1 second), which is a rather
benign problem for a race, and generally not a big problem for
multipath, where paths can be offline for much longer periods of time.

Finally, before going into any detail, I am highly reluctant to changes
in this area. Ben and I have fought with deadlocks and races in corner
cases for a long time, and we seem to have solved it for good; at least
we haven't seen any more bugs in this area for quite some time. For a
change like this, figuring out possible side effects for all possible
cases by code inspection alone is extremely hard. I'd rather not risk a
regression just to detect a status change 1 second earlier than we
currently do, in rare cases.

>=20
> Race window
> -----------
>=20
> In libcheck_thread() / alua_thread():
>=20
> =C2=A0=C2=A0=C2=A0 pthread_mutex_lock(&ct->lock);
> =C2=A0=C2=A0=C2=A0 ct->state =3D state;
> =C2=A0=C2=A0=C2=A0 ct->msgid =3D msgid;
> =C2=A0=C2=A0=C2=A0 pthread_cond_signal(&ct->active);
> =C2=A0=C2=A0=C2=A0 pthread_mutex_unlock(&ct->lock);
> =C2=A0=C2=A0=C2=A0 /* <-- race window here --> */
> =C2=A0=C2=A0=C2=A0 uatomic_set(&ct->running, 0);
>=20

You seem to be looking at old code. The code I am seeing has this:

       running =3D uatomic_xchg(&ct->running, 0);
       if (!running)
               pause();

Anyway, I think we had very good reasons to set the running state after
releasing the lock. I would need to dig deeper into the history in
order to figure out exactly why we did it this way. It probably has
something to do with the actual fatal races that we observed between
checkers timing out / being cancelled and finishing.


> When libcheck_check() observes ct->running !=3D 0 during this window,
> the
> result is already available under lock, but the previous code could
> fail
> to collect it.
>=20
> Why the old check was broken
> ----------------------------
>=20
> The ALUA checker used:
>=20
> =C2=A0=C2=A0=C2=A0 if (ct->state !=3D PATH_PENDING || ct->msgid !=3D MSG_=
ALUA_RUNNING)
>=20
> This conflated two different meanings of PATH_PENDING:
> 1. Thread still in progress (no result yet)
> 2. ALUA state is transitioning (valid completed result with
> =C2=A0=C2=A0 MSG_ALUA_TRANSITIONING)

True, but what's the actual problem with this? In both cases, the
checker is indeed not yet able to figure out if the path is usable,
which is what CHECKER_PENDING means.


>=20
> The TUR checker had similar issues since PATH_PENDING with
> MSG_TUR_TRANSITIONING is a valid result.
>=20
> The fix
> -------
>=20
> Check ct->msgid alone under lock. The msgid is set to MSG_*_RUNNING
> only
> at async check start and atomically updated with state when complete:
>=20
> =C2=A0=C2=A0=C2=A0 if (ct->msgid !=3D MSG_TUR_RUNNING) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tur_status =3D ct->state;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 c->msgid =3D ct->msgid;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ct->thread =3D 0;
> =C2=A0=C2=A0=C2=A0 }

You probably realize that with this change, you basically imply that
the test for ct->running is superfluous. If this was true, we could
actually just skip it and solely rely on ct->msgid. What you're
basically saying is that ct->running is meaningless. But it isn't. It
means that the thread is "dead", which it isn't as long as holds the
mutex.

I'll wait for Ben's opinion, but I am inclined to nack this, sorry.

Martin

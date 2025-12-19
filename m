Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189A82DC781
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 08:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766131615; cv=none; b=UcRdm17S8OUt7AVe4uTnbvV7aEks80mdOXwO8zNl52ngBU0ONl+yHEX/C8LIfx5+mDpTYdn32oJ5WLXM9EDjK41mq1tEEiC6SOlsfwkm1WVWc+qizBdXfmkOrXF3GpBPncrrgloyVTLYI+YpdE9gfkkNhuQQsuZ23rUiu4CBMbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766131615; c=relaxed/simple;
	bh=lO5pigXPZOvUWlY01gkGGivy6q0KDLIn+0WZyMkdDP0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ES0M6DkX0nHOX/bogiTuM3x0ADjqNU/uyvrHnyMuixrcvL2IsAwvZelJNQ4opOieWKRHooZuB0V9+d3BA5qWbX/KD28zBW1duFLRxFaCKzef7GUtjDET0xM7Ii6PKMwKveGY1m6CPt2nxoy3P95yCm+BZsFu59KRXuWdNcBNcn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=CpB87cU/; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UOqFJZZd; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="CpB87cU/";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UOqFJZZd"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EB2875BD14;
	Fri, 19 Dec 2025 08:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1766131611; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lO5pigXPZOvUWlY01gkGGivy6q0KDLIn+0WZyMkdDP0=;
	b=CpB87cU/ordUBe5qGXjijX5w0Me7EhmRjctvW+g+NujQqX8ZeMrdof1pqJzYVlMLNZ2YqM
	ZSrPb69zrQvWby0qenG1cZoLksnS1u7wijbGLUOzfKoJL1Dl7qdzuEwDRAnTwgd3Wg4zli
	YeO8L7eMpdbd1AWxgBNIB/VQ0cyzj/c=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=UOqFJZZd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1766131610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lO5pigXPZOvUWlY01gkGGivy6q0KDLIn+0WZyMkdDP0=;
	b=UOqFJZZdVI0sEHYdZ5Y3b9g3nAjzyd5+snrRrvUEAuc/KLVv/uDHrdKHJYFdBdWlWykEZE
	1Aqr4yClUO4weU4NLcs0gB1TrxeWD7p6ca1giNicmtk27yY4cc/D1OCFYvDvqCVrSbqrP0
	Aq9S3xdR6AIxFJpARY3m07JgoDuhiYc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CF32F3EA63;
	Fri, 19 Dec 2025 08:06:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mNN+MZkHRWlqcwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 19 Dec 2025 08:06:49 +0000
Message-ID: <af00ff3e05b643a9ed41e23a9f0ba4553d6c2e4b.camel@suse.com>
Subject: Re: [PATCH 18/21] libmpathutil: add wrapper code for libudev
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Fri, 19 Dec 2025 09:06:49 +0100
In-Reply-To: <aUSedLFHsg6xRGRR@redhat.com>
References: <20251217212113.234959-1-mwilck@suse.com>
	 <20251217212113.234959-19-mwilck@suse.com> <aUSedLFHsg6xRGRR@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
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
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.com:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Queue-Id: EB2875BD14
X-Spam-Flag: NO
X-Spam-Score: -4.51

Hi Ben,

On Thu, 2025-12-18 at 19:38 -0500, Benjamin Marzinski wrote:
> On Wed, Dec 17, 2025 at 10:21:10PM +0100, Martin Wilck wrote:
> > The libudev documentation [1] states that libudev is not thread-
> > safe and
> > shouldn't be used from multithreaded programs. While the man page
> > also
> > states that using libudev in multithreaded programs is unsafe even
> > if
> > locking is used, there's not much else we can do in multipath-tools
> > to
> > mitigate the problem, as we are using libudev in multiple threads
> > all over
> > the place.
>=20
> Ugh. I'm a little confused on what exactly could go wrong. Do you
> know
> what they are concerned with, that locking cannot fix?=C2=A0

No. I've asked our SUSE systemd experts but they didn't know either.
The man page mentions the use of setenv()/getenv(), but I don't think
that matters for us.

> It sounds like
> the functions themselves are safe to call from multiple threads, as
> long
> as they are working on separate data. If they were manipulating
> global
> state that wouldn't be true.

They aren't working on completely separate data, that's the problem. We
only have one "struct udev", which provides the context for the entire
operation of libudev in our code. The udev_device structs we use are
created from that object and link to it internally. Individual
udev_device structs are linked together e.g. through parent
releationships. That's why devices obtained by udev_device_get_parent()
et al. don't need to be unref()'d; they're referenced by their children
and supposed to be freed together with the last child.

As the udev operations are opaque, we can't make any assumptions about
which of the libudev funtions allocate memory, or modify shared data
structures otherwise. Some properties are fetched "lazily", when the
user actually needs them, and then cached in libudev. The 2-layer
architecture with udev_device being actually a shallow wrapper around
sd_device etc. doesn't make it easier to assess the code flow inside
the systemd libraries.

These issues should be fixed by serializing the libudev accesses with a
mutex. I agree with you that I don't understand what could still go
wrong if that's done.

In theory we could have separate "struct udev" devices per thread, but
keeping these in sync with each other would be a nightmare. We could
rather give up running multithreaded altogether.

>=20
> > Add wrapper code that wraps all calls to libudev in a critical
> > section
> > holding a specific mutex.
> >=20
> > [1] https://man7.org/linux/man-pages/man3/libudev.3.html
>=20
> I assume that there must be times when use call a udev outside of the
> vecs lock. Did you check how often that is? Not that would be great
> to
> pile even more work on the vecs lock.

I wouldn't want to do that. Even if we could create a comprehensive
assessment now, it could become incorrect any time just by adding an
innocent libudev call somewhere. Also, I wouldn't want to overload the
vecs lock further. This code is ugly, but I am pretty sure that the
mutex operations will be light-weight. The mutex is always at the
bottom of our call stack, so no ABBA deadlock is possibe.

I started out by just wrapping some libudev calls, but I soon realized
that we can't do that without making assumptions about libudev's inner
workings, which we shouldn't (see above).

That said, I agree that it's unclear if this is really worth the
effort. I did it because I was hoping to fix the memory leak issue #129
with it. But that attempt was unsuccessful. So we have no evidence that
this serialization fixes any actual issue. multipathd has been using
libudev from multi-theaded context for 20 years, and we have never
encountered a problem that was caused by that (or if we did, we didn't
realize). At least in theory, the mutex could cause a deadlock or
noticeable delay if some libudev operation blocks or crashes, so the
change is not without risk.=C2=A0

So, consider this part of the patch set an RFC.

OTOH, the libudev man page is pretty clear about being not thread-safe.

> Also, git flagged some whitespace errors.

Ups, will fix.

Thanks,
Martin

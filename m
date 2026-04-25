Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1D04C97
	for <dm-devel@lists.linux.dev>; Sat, 25 Apr 2026 19:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777145175; cv=none; b=HUPwvb3I4a2jHlcKSX3VGJWB0TmSthaNzbLOrBAIVjojVwxlRUn2WToxFZtQOBbT9EkVPnXkllnniFIB17nuLphP4/lN94CcnqfFL08IZ3eyh/Ck72jOPEVlFmQxVDZMM0cfqFcJeLG2SO5MZ/pMTejCv2Cu+5k3Y7qRtwGfXik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777145175; c=relaxed/simple;
	bh=guN2tsyK91tBx/iQTlAiFEB3mHeUnUGyiZFd/WHy4FU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=u/DdgDjJjHjD90OHgcOZEge0nm6qTvtVKebNI7Z7I2piZdU+LaYoAZGhDZwKWQDMLZbf7fF7Lf0qyZB97DQcmi59ossLLwXzR6Np6fiUYh7TAI08pLQur97Ngr6GpGK+9Vsp/E78S1aI9ySZiA7EvDoO7R6Uu0PbysxcsfE6Kpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Xoau6xiv; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Xoau6xiv; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Xoau6xiv";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Xoau6xiv"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 882E05BD32;
	Sat, 25 Apr 2026 19:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777145171; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=guN2tsyK91tBx/iQTlAiFEB3mHeUnUGyiZFd/WHy4FU=;
	b=Xoau6xiv+gSwr2AbZ9WqYs8d9dJpGDGM8CMaXdqH1TKkVftKnclCUDEbRV9F4Rh8C4xIcP
	CgLNdcOmnVZnI4vbwx0s4wVAKTnUHj/sEQkkMaIEV+U8+i9Z2GNLC8zIJSG3HVWI5Un4Bg
	3PTUaVFzx59f7uXOqhnOT4v7esE6wEM=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Xoau6xiv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777145171; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=guN2tsyK91tBx/iQTlAiFEB3mHeUnUGyiZFd/WHy4FU=;
	b=Xoau6xiv+gSwr2AbZ9WqYs8d9dJpGDGM8CMaXdqH1TKkVftKnclCUDEbRV9F4Rh8C4xIcP
	CgLNdcOmnVZnI4vbwx0s4wVAKTnUHj/sEQkkMaIEV+U8+i9Z2GNLC8zIJSG3HVWI5Un4Bg
	3PTUaVFzx59f7uXOqhnOT4v7esE6wEM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 67412593A6;
	Sat, 25 Apr 2026 19:26:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id y2oUGFMV7WnbZQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Sat, 25 Apr 2026 19:26:11 +0000
Message-ID: <78bcf0d1b38d650d80292fd184725f9b1b47ecef.camel@suse.com>
Subject: Re: [PATCH 1/2] checkers: add alua path checker and async checker
 framework
From: Martin Wilck <mwilck@suse.com>
To: Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com, Krishna Kant <krishna.kant@purestorage.com>
Date: Sat, 25 Apr 2026 21:26:10 +0200
In-Reply-To: <b2f1700d804f5f254dd614ba09746534ea0d0a22.camel@suse.com>
References: <20260325151940.18928-1-brian@purestorage.com>
		 <20260325151940.18928-2-brian@purestorage.com>
	 <b2f1700d804f5f254dd614ba09746534ea0d0a22.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 882E05BD32

Brian,

On Sat, 2026-04-25 at 19:16 +0200, Martin Wilck wrote:
>=20
> I just had another look at this patch as I'm working on the checkers
> myself, and I have to say that this is something you absolutely
> cannot
> do, especially not when the checker thread is supposed to run
> asynchronously. There's a reason that we pass "struct checker *" to
> the
> checker threads and not "struct path *", and the code above is a hack
> to work around this design decision.
>=20
> When you write a checker, you need to think carefully what
> information
> you actually need, and copy that from "struct path" to the checker
> context. Currently, for all checkers except emc_clariion, nothing is
> needed except pp->fd and pp->timeout. I understand that the alua
> checker needs more context, but that doesn't mean you can simply pass
> the entire data structure to the checker, and I believe that an=C2=A0 ALU=
A
> can be written so that it needs just a few more fields (if any).

Unless I am mistaken, the only additional property that we need for
ALUA is the tpg_id. We need to refactor our inquiry and rtpg code such
that it takes only the parameters that are needed (fd, timeout, and
tpg_id). It would then be possible to call these functions from
checkers with limited context, without the hack to pass "struct path *"
to the checkers.

The tpg_id of a path will change very rarely, if at all (and we
currently do not handle possible changes of the tpg_id in a clever
way). We determine the tpg_id() in detect_alua(), and on every call of
the alua prioritizer, which is too often, IMO. The kernel re-fetches
the tpg only if a LUN is rescanned. For a first attempt of an alua
checker, we could simply pass pp->tpg_id to the checker.

We might as well try to get the ALUA state from sysfs in order to avoid
sending extra RTPGs (see Hannes' previous reply), in which case we'd t
need the dev_t to determine the sysfs directory.

Regards
Martin

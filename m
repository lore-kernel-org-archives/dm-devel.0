Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D53526E6F3
	for <dm-devel@lists.linux.dev>; Wed,  4 Mar 2026 21:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772658945; cv=none; b=dgpuhm/HSgOqQaeaZEvpf+MgnI9sYdpy94jx8BcnTex0dUmlRI7rxogSNsi9SmSVI7dVbw2R8H6xKBV/KoA346JqWbmcNNhkd65EFskQIM2qHqbVQdAjgmSn6jZj9S6bsiiy+V3rPDaW9f09kR9LSjWVNpguviLSgBdCvAgraiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772658945; c=relaxed/simple;
	bh=QG+M1bC481gYhM0lQpZafbW1LpyhmHX5+BCXx2pWzo4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QNeGxIBa5g5bZxE0I7HHhZ5gmurOMO/wQP0pTnUDR09/eIS9H5mXM6BsWNgOXsagIdLjBa3ifCItAGd5YEbbBYeptij3WNQY5R6vqJrVA0UFqsToSWVV05GapKx4uQgPBqDjxOF4HwZaqzXu/HV5js1YWI2mOpL+O4C9q+/MpMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=iD6bKDEn; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=iD6bKDEn; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iD6bKDEn";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iD6bKDEn"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4C00C3E6C5;
	Wed,  4 Mar 2026 21:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1772658942; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QG+M1bC481gYhM0lQpZafbW1LpyhmHX5+BCXx2pWzo4=;
	b=iD6bKDEnNhctNHEdSSdrjJ9x/WPDCX1ifm43tKx3JtNp527EZzE1hvw6YUZ2duZkKPGUHn
	HEppKnM4RdeLe0x1YNHqQL+pyqDxPSJB+cjigrs8By0Exf9QEW6BxPLBWYA7RJyu96NiAp
	APtHjhTnhOJKRscblNG0AA90xp3kme0=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1772658942; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QG+M1bC481gYhM0lQpZafbW1LpyhmHX5+BCXx2pWzo4=;
	b=iD6bKDEnNhctNHEdSSdrjJ9x/WPDCX1ifm43tKx3JtNp527EZzE1hvw6YUZ2duZkKPGUHn
	HEppKnM4RdeLe0x1YNHqQL+pyqDxPSJB+cjigrs8By0Exf9QEW6BxPLBWYA7RJyu96NiAp
	APtHjhTnhOJKRscblNG0AA90xp3kme0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3006F3EA69;
	Wed,  4 Mar 2026 21:15:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4PemCv6gqGmsPAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 04 Mar 2026 21:15:42 +0000
Message-ID: <14505bfbb6aa466f0ebfdfaf7cc5f3fbe9d25f5a.camel@suse.com>
Subject: Re: [PATCH 0/1] checkers: fix race in async TUR and ALUA result
 collection
From: Martin Wilck <mwilck@suse.com>
To: Brian Bunker <brian@purestorage.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Date: Wed, 04 Mar 2026 22:15:41 +0100
In-Reply-To: <CAHZQxyLzqG-N5jOOrODL-O+RRLmwHiNO1wSUGC=gvYpVkQTbnA@mail.gmail.com>
References: <20260224010058.35337-1-brian@purestorage.com>
	 <d9355e67dc64b7af940f6b8e6845d0f37565dd34.camel@suse.com>
	 <aZ9ec_ce8dCCBzR0@redhat.com>
	 <d223eb7cb4088d672b0312d929fa7d2c0e723875.camel@suse.com>
	 <aaCVelI_vQZEBihM@redhat.com>
	 <2ae78a2af1cc187a0cee9f0660e31fbd7cc79cd9.camel@suse.com>
	 <CAHZQxyLzqG-N5jOOrODL-O+RRLmwHiNO1wSUGC=gvYpVkQTbnA@mail.gmail.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid]
X-Spam-Flag: NO

On Wed, 2026-03-04 at 09:38 -0800, Brian Bunker wrote:
> Ben and Martin,
>=20
> Sorry for the delayed response. I sent this to you both initially
> instead of
> to the list because I thought you might have some insight into the
> issue.
> I have an 'alua' checker that I will post where I found this issue. I
> didn't actually
> find it in the 'tur' checker but I could see it is prone to the same
> issue. I have a
> test I created to show the issue called test_tur.c. I will send this
> too if it helps.
> The problem when I didn't use this patch was that my checker the
> entire
> checker thread would stall. It didn't just correct itself. Until
> other
> paths failed
> the checker thread was deadlocked somehow.
>=20
> In the 'tur' checker without this change, the 'running !=3D 0' will
> lead
> to PATH_PENDING
> and MSG_TUR_RUNNING without looking at what those actual values are.
> It might actually
> be finished, but running hasn't changed to 0 yet, and ct->thread is
> not
> 0 on returning. I am not sure what extra conditions were true when my
> checker
> thread deadlocks, but with this change the deadlock never happens.
>=20

This is a stronger reason to make a change than 1 second gaine21:40
multipatd for a path reinstantiation. IIRC you made an analogous change
to the one you sent us for the TUR checker for your ALUA checker, and
that solved the deadlock issue for you? It's hard for me to understand
with the TUR checker coded in my mind. My guess is that your checker
does not work exactly like the TUR checker, and that you have some
general other issue. But again, without examining the new checker very
carefully and possibly testing, it's impossible to tell.

Could you try the approach I sent in my other email instead of yours,
and see if it makes a difference?

In general, I'm not surprised that you saw deadlocks when trying to
write a new checker. As I said previously, we've had our share of them
in the past with the TUR checker. This isn't easy to get right.

I suggest that you leave the TUR patch aside for now, make your checker
work, and send patches for review. Maybe when we see the code we will
be able to understand better what's going on.

Regards
Martin

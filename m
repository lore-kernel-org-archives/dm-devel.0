Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EDF25FA05
	for <dm-devel@lists.linux.dev>; Fri, 27 Feb 2026 08:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772181415; cv=none; b=mGfk5SsuhbcUMrkFumBGhtA2L9f+smmciXzlldJYBbrLnUgS6XcP9GCz9PkGRFsg7jCyQomzjdT8/BrimgaVw15TnyGrAh0r99B0+n8wPZBPC4QPadMDr9hyotcY1gZ0AuHxnm8aeZOhon5E1Yrgm7/Gesohuvqvww/TIli35d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772181415; c=relaxed/simple;
	bh=dZjfB4sray2TsGcDivIWIeRpP8j6H1ey2Uz5GeHMO1s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TgWeqbrNBbEDkjQHF0q0QYOJ7t7I4ohs/uqRZoOY5Mysoe0fcHGAfkO2ER7P4fEQOdm3YQsa7c1UqSWmGNo7jTtCQukOuZh1etIqy2irNw7K6bwmVKE+SNWastaTBaMlKic0rG2EAEfa+uM+0Jz7ebgVgQLcutqXaQi7/SXbFI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=s7NFdRrZ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LajQScQv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="s7NFdRrZ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LajQScQv"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EA3C14D73D;
	Fri, 27 Feb 2026 08:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1772181412; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gb3HTdedytHi7XLDFyzbPwwKzinG/zF0lcuSsAqdWYA=;
	b=s7NFdRrZ6fcBLTnEskYavVbkhSdrI3p6trZY8u9WPGrzwTHz41R5rKcboVLk0LhwSVoNRF
	G6WjgMYHkkanRjAXM9dRD7kp+vuQawD9Sd+Xb4t6YYdrFPUGUnVFm+dh5J4vRwJBjmvjk9
	ih12/Zvq/+EQb/byS2nz3Gf7x60bd9Q=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1772181411; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gb3HTdedytHi7XLDFyzbPwwKzinG/zF0lcuSsAqdWYA=;
	b=LajQScQvCUmY0avM8+Y9eYeznxioBdqGgge4WBMqYGsH5dQJLaWLOPweRRvgYO2vks1WtM
	4cORsvuqDbKWwn6GTKCSoLS3teWxsa48ywS0wkKHQkvX+d8tbNr6CnVe0HNNRxuvoqEy/n
	a7qJU8HBO9UjKC/RfyIoJMkfKGc8ALA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CFBF43EA69;
	Fri, 27 Feb 2026 08:36:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id E3aaMaNXoWl+ZAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 27 Feb 2026 08:36:51 +0000
Message-ID: <2ae78a2af1cc187a0cee9f0660e31fbd7cc79cd9.camel@suse.com>
Subject: Re: [PATCH 0/1] checkers: fix race in async TUR and ALUA result
 collection
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev
Date: Fri, 27 Feb 2026 09:36:51 +0100
In-Reply-To: <aaCVelI_vQZEBihM@redhat.com>
References: <20260224010058.35337-1-brian@purestorage.com>
	 <d9355e67dc64b7af940f6b8e6845d0f37565dd34.camel@suse.com>
	 <aZ9ec_ce8dCCBzR0@redhat.com>
	 <d223eb7cb4088d672b0312d929fa7d2c0e723875.camel@suse.com>
	 <aaCVelI_vQZEBihM@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On Thu, 2026-02-26 at 13:48 -0500, Benjamin Marzinski wrote:
> On Wed, Feb 25, 2026 at 11:00:44PM +0100, Martin Wilck wrote:
> >=20
> > I'm still undecided if it's worth changing this code in order to
> > reinstate some paths 1s earlier in certain sitautions.
> >=20
> > Thoughts?
>=20
> I don't see any problems with this. But I also didn't see any real
> problems with Brian's version (although this version does remove most
> of
> my theoretic issues. Like I said before. If we hang in the condlog,
> we've got bigger problems than a stray checker thread). If we do
> this,
> we should probably document the uatomic_add_return() call,

Of course, this was not an official patch submission, just an idea how
we might improve this code. It's not exactly the same thing; Brian's
patch meant simply ignoring ct->running, while mine would make the ct-
>running check reliable, albeit with changed semantics.

>  or just use
> cmm_smp_mb() directly. But I still not sure what we get out of this,
> other than a very slight chance to finish the checker a second
> sooner.

Yes. But it's also a fact that the simple atomic_read() test in the
current code isn't reliable. It can well return true when ct->running
has already been set to false. I guess the implementation tends to be
as light-weight as possible, avoiding a memory barrier (or taking a
lock with the side effect of a memory barrier) in the "fast path". That
comes with the price that we may miss an already finished checker
thread.

> don't think that really makes a difference, but I don't really see
> much
> risk in the patch either, so I guess I'm fine either way.

If the risk was truly zero, I would agree. But experience tells that
it's very easy to get these things wrong for corner cases, and I tend
to want to avoid even a minimal risk just for "very slight chance to
finish the checker a second sooner", as you've expressed it very
nicely.

@Brian, feel free to try to convince us otherwise. It might be helpful
if we understood your use case better.

Martin

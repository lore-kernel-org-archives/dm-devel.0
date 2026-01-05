Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D683043BE
	for <dm-devel@lists.linux.dev>; Mon,  5 Jan 2026 14:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767623936; cv=none; b=RNz2Av5BYm8XA1491WjbGb9X75z2xoPXFfxFWB9iGXQiyC0o/L6Bs9iMrCHJ3Qab2dKAD6/Ccyo76m+8a4N7Lh5daO9ygti1w01NRavLU7LlNhAyetiX6YiwLV7BCk3zQziqAtwwtW43umu9XPWBs0z7Jx3RjMMX4F/00w1Homc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767623936; c=relaxed/simple;
	bh=OxkGUs1oyQ+R9GP10Gl5PpzkuzZbNA2tux+B6TE20ak=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UVB+xu6xx/aGmH45Nbay0tw5fapvUCcjNieKUzyssHj4HS4xxv3zf/qzJvMArF/RQPtMIyT5K6T86zkpHJ/CXO451WEjx/sNJUQgbQbexzsi4myvUDjAkjoTMiwj2lUXYFkwjrXpPSO51/Dg6XVaix3vvkXBA97/VTBVQWwkCnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Xt/Mytln; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Xt/Mytln; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Xt/Mytln";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Xt/Mytln"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 962745BD95;
	Mon,  5 Jan 2026 14:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1767623931; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OxkGUs1oyQ+R9GP10Gl5PpzkuzZbNA2tux+B6TE20ak=;
	b=Xt/MytlnZRsD4fNC4EhEdGGoUXJX6Q8BPx7gRS4z2w4z41XMxMyXoKmG9YL9WOnQrC2r00
	KJ8KqNYqew4Ze1blSmdszs/9y1FC64zVcIFfQMPmtFszdAoxPuXvaAG0fJ66XP0Vpdwk95
	jyVA+Pr5o3eS4rDLubhuNtC50FLksbA=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="Xt/Mytln"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1767623931; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OxkGUs1oyQ+R9GP10Gl5PpzkuzZbNA2tux+B6TE20ak=;
	b=Xt/MytlnZRsD4fNC4EhEdGGoUXJX6Q8BPx7gRS4z2w4z41XMxMyXoKmG9YL9WOnQrC2r00
	KJ8KqNYqew4Ze1blSmdszs/9y1FC64zVcIFfQMPmtFszdAoxPuXvaAG0fJ66XP0Vpdwk95
	jyVA+Pr5o3eS4rDLubhuNtC50FLksbA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7B8963EA63;
	Mon,  5 Jan 2026 14:38:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HvMeHfvMW2kVCQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 05 Jan 2026 14:38:51 +0000
Message-ID: <b5761d8608124827df8a2c3746e55493aad9e4b5.camel@suse.com>
Subject: Re: [PATCH v2 13/26] multipath: free paths through pathvec in
 check_usable_paths()
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Mon, 05 Jan 2026 15:38:51 +0100
In-Reply-To: <aUYj2RFgD81maXre@redhat.com>
References: <20251219144108.237928-1-mwilck@suse.com>
	 <20251219144108.237928-14-mwilck@suse.com> <aUYj2RFgD81maXre@redhat.com>
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
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Queue-Id: 962745BD95
X-Spam-Flag: NO
X-Spam-Score: -4.51

On Fri, 2025-12-19 at 23:19 -0500, Benjamin Marzinski wrote:
> On Fri, Dec 19, 2025 at 03:40:55PM +0100, Martin Wilck wrote:
> > Paths belong to the pathvec and should be freed from it.
> > Use cleanup_multipath() instead of cleanup_multipath_and_paths(),
> > and free the paths via the pathvec instead.
> >=20
>=20
> I don't know if this matters, but until you stop free_multipaths()
> from
> clearing pp->mpp in patch 15/26, this will temporarily cause UAF
> errors,
> since you free the paths from the pathvec first, and then attempt to
> reset their pp->mpp value in free_multipaths() later.
>=20
> You could avoid the temporary problem by moving the pathvec
> definition
> before the mpp definition, since cleanup functions are run in reverse
> order of their declaration.
>=20
> But after applying patch 15/26, this is fine, so
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

Thanks for pointing this out. I will move 13 after 14, 15.

Martin

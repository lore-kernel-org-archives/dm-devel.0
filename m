Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D357F9E8
	for <dm-devel@lists.linux.dev>; Sat, 19 Jul 2025 12:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752928590; cv=none; b=bPleQvOI36KHo9fAAd7IMDkfZMygXzsAWJSw5ELNTT7PPMatzaQKQxFeZdc8rUkbckl/ogXxL+CYbdOJkFo+l741m9/R5F95WL0IXLkEZmEVJW4meKTgqQRXASoHfq/orE7QWlQATGrbfABXxHCtFma9s/+NuFiYqE0J3RRzBEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752928590; c=relaxed/simple;
	bh=+NkniJyGclh1BYCT5mLiytY3Lvljeh3VUUyk9cZ4Bd8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ce8gQgFddAGIO3WrXMObTgaNAXiLGdbH7nLY5pvNHlIQNxCqJQ6Ew7R4Li1JY60jpAEOyBXwv/ip5nviAmopharp0fZ2kQstMZZaAXdKCun5BuIuklQXqHUhLZdWTQkUZllgbq82BuI3W2XWECwcNGRs2Guhg4EKyzrgauUhB/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=M5+mQXkC; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dikt135d; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="M5+mQXkC";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dikt135d"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EE8E11F457;
	Sat, 19 Jul 2025 12:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1752928580; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+NkniJyGclh1BYCT5mLiytY3Lvljeh3VUUyk9cZ4Bd8=;
	b=M5+mQXkC00+0uCpvOxU4jOyxPD+vIDTMzdXvP3AU21dg5Vf+83kjo7yIvmNyx4Y3CMj0D0
	zFufLxSuTKaLW9n3GI2jHB0ICEiR8XMsC1NXVbIR2BejkFLqRysTv5GBBKRkpu6eoqE1yC
	PN9/hee0wKxNW2AOToOe9H0Dd+qIiFc=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=dikt135d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1752928579; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+NkniJyGclh1BYCT5mLiytY3Lvljeh3VUUyk9cZ4Bd8=;
	b=dikt135dj7YNz3Gqv46Tt0HXLmLo5p23K6ucd1qi0XIxoCmv+jxwanFlnXDl1+6rh7nvRT
	1HndJjXivYNthosUbwbAxjzmopqMne0cHCnu1vCC1mCA9eJXcFXPtS1Jsg7xfUP38DyaeX
	vqjZ0UXknbhREP7AasGROdaIQaBq2/g=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CAB26136A8;
	Sat, 19 Jul 2025 12:36:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CFLxL0ORe2hjcwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Sat, 19 Jul 2025 12:36:19 +0000
Message-ID: <6a471dd066c3297a2b1fa11631cb4e69bc91876e.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: fix licence identifier
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Sat, 19 Jul 2025 14:36:18 +0200
In-Reply-To: <20250630215213.86166-1-xose.vazquez@gmail.com>
References: <20250630215213.86166-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,linux.dev:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: EE8E11F457
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01

On Mon, 2025-06-30 at 23:52 +0200, Xose Vazquez Perez wrote:
> Also location and SLI tag: https://spdx.org/licenses/
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =C2=A0libmpathcmd/mpath_fill_sockaddr.c | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/libmpathcmd/mpath_fill_sockaddr.c
> b/libmpathcmd/mpath_fill_sockaddr.c
> index 750ef3ee..61ef377b 100644
> --- a/libmpathcmd/mpath_fill_sockaddr.c
> +++ b/libmpathcmd/mpath_fill_sockaddr.c
> @@ -1,6 +1,6 @@
> +// SPDX-License-Identifier: LGPL-2.1-or-later
> =C2=A0/*
> =C2=A0 * Copyright (c) 2025 SUSE LLC
> - * SPDX-license-identifier: LGPL-2.1-or-newer
> =C2=A0 */
> =C2=A0
> =C2=A0static size_t mpath_fill_sockaddr__(struct sockaddr_un *addr, const
> char *name)

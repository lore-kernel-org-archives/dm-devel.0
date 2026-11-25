Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795627386;
	b=wnTZmB7lh65mtSkhL68LMYN1LeIHyWIlJKgEnfSaoq4ZrDTKd8ntMP/g1lTcYEdfImXe
	 0gYuGbnGhu3grh4RnaH7YV9Zs6VvO452Zh2V3xlFb84Qoij5mzEGkZI/8yKjdF6Cdn3Av
	 ddjKKkOugu3NizSFaioiC0CGAwBAVgsSCe2GDRtDfNgRSWVBAEcj+s8M/BedWyD2soNOV
	 5FGbOECln5rthS3KlZqMw1tHiMjwCjMACX9vrA2cLKqdK8GdNtRHBpe7Jr5USPsS1caCt
	 5Qd6cRna/WnCTunS2figEHFukGVwEpVTUJup8wbIonNBCQkOSC8KPsqDL4kabo9ZlxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795627386;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version:
	 X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=989ddLjt6c/rLezq/3/JHFBbDjpPc3LzU/2sMTxtg6U=;
	b=CIP4PtnT2iYjsIyf4dwq4HATfokawC5iybuF/IuugKBg/dYe6JeivAlhfBbshsY96brs
	 AKT5IKn5eTWCaHq58YQ18IwbU5TP7tqU0xWh8AuNn/Z2RHyTzM8ntQ3YWKJlTEn7sxs6H
	 UO5t4ji4Sgv6I9GVDXHmQI6Xo91J1vQQB74opr0y4XNcT/HjIOvaXyaOw/u0KR/H3rM+N
	 oELZ1WJi+XO1OjaJTUDQQkLGSBJsE7NtJj6kS6U8XeovmeniQoWJk8F0hY2iQYGCBSiFJ
	 Qt/dU2xOJMYKl65lGfC9ZZM1gRkyS32IHg9GaiBlo2hGI08MGF+uF5aWZ6V93sjQxkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=b7OSIYeO;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Ekj6Nmwi;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05406606A327
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 17:23:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05406606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=b7OSIYeO;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Ekj6Nmwi
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6D4B622451;
	Wed, 25 Nov 2026 17:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795627384; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=989ddLjt6c/rLezq/3/JHFBbDjpPc3LzU/2sMTxtg6U=;
	b=b7OSIYeOih6tEcg7teL4ab0/qfRapKiNWFsAwUqcBlQe6WMjSPQ4oslfxFy4LEISJWwe79
	OeKvQ1HgAjJtuezKVkQDODS4cXKihXMcPjRVumKdOM6fsS3M5kl0pPllXwSRBmb8Gy6fsK
	yyfIzK3Mz1+mVVRspAm1i13M0HGjY+0=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795627383; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=989ddLjt6c/rLezq/3/JHFBbDjpPc3LzU/2sMTxtg6U=;
	b=Ekj6NmwiUcEz54sfLyAPYEay4QBhJd60I7jfgjArwvvxyRGHc7jsr29BLlLHiW6ruafrXb
	ILIAN59Z1SxC2sGebW53RN/DNUnFC5ddp3+gWBPWKcS3xox4BaEs1CDsNU6565fJ8vMv4S
	Gl74ok01+Ui23EwC7U4cPEH/SQnXC3A=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 08E1E134E8;
	Wed, 25 Nov 2026 17:23:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id smavNnYZB2vaHAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 25 Nov 2026 17:23:03 +0000
Message-ID: <8b4ea279ac2533e66eccd31e49af8bdb9a79ccb9.camel@suse.com>
Subject: Re: [PATCH 5/7] multipath-tools: multipathc: print version string
 on startup
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Wed, 25 Nov 2026 18:23:01 +0100
In-Reply-To: <206823f9-af78-4838-bd42-dd5e7b2c8093@gmail.com>
References: <20261125102605.82009-1-xose.vazquez@gmail.com>
	 <20261125102605.82009-6-xose.vazquez@gmail.com>
	 <e187be141dc1e65cb643fc5ba77c4a1cff536f99.camel@suse.com>
	 <206823f9-af78-4838-bd42-dd5e7b2c8093@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.62.1 
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.80

On Wed, 2026-11-25 at 13:58 +0100, Xose Vazquez Perez wrote:
> On 11/25/26 12:42 PM, Martin Wilck wrote:
>=20
> > What for? I'd prefer multipathd not to be chatty, and I fail to see
> > the
> > benefit of this unsolicited output.
> >=20
> > It would be nice to have a "show version" command that would print
> > not
> > only the multipath-tools version but also the versions of relevant
> > other componenents (libdm, kernel dm, kernel mpath). But that's a
> > different thing.
> Since the "help" command isn't implemented either, even though it's
> documented in the multipathc man page, this is a quick way to show
> which version is running.

I don't want this startup message, sorry. multipathc may be used in
scripts which I don't want to confuse with stderr output which will
be pointless in 90% of cases.

Implementtation of "help" would of course be a welcome addition.

Regards,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)

Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3578B336EEE
	for <dm-devel@lists.linux.dev>; Thu, 27 Nov 2025 15:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764257625; cv=none; b=EmcevS+KERnBCreaZMxCPlRd9K+UVMr5Rwb1kOq3wo2LmYAgxU7GpaBqj0DJwPtzXpR6Kck1cBvlk+2pK9pJMNqLXEIr4ElpktW0CX7yVKDu/AGR49DtLjE1l/DKE1b/Et4gSnntGpNadMabOIrpWvlxogPJI0jw3xEQpjSUJNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764257625; c=relaxed/simple;
	bh=uiIjsKGMmWN0y/1P7plMPI3d3T+Me3MsvqwQwj9IXrU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rmRK1+JkHaB3l5Fx1LFeCvQXFVB6S1q24nKAAW2ZCWaoY5W0Iu2mDNIzwQh9h7w5N6RSnsiCfFH83EMKFI7GM1JUW5rQYqFnXRtzqsHoD5abT/tvBAxYH11VHlQXqSyxfJrHu01TM2tkmx/+tdNOyPiR/0kt1B4r2G1t2kOIvts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Ki3h2/IA; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Ki3h2/IA; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Ki3h2/IA";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Ki3h2/IA"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BA98E336AF;
	Thu, 27 Nov 2025 15:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764257619; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yZucJEdC0T1v0DnEI/LTTOtKkMO1/K01U0yco73V3cU=;
	b=Ki3h2/IA7jSnLNWhlkYYImotSGdGwfF4stXsVMCBYszoJ71FXEEgwxYRnJKoa3z1XNtICv
	p2r51Mzn6pN7hh9NKvds7ZQycKO/HsKkqMZCmw5cRIywfi/LhQvYSh2WU7pVI6NYkm5XEB
	MsfXeDLlUAUsqnCgblxx5AAQ/C5hS6w=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="Ki3h2/IA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764257619; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yZucJEdC0T1v0DnEI/LTTOtKkMO1/K01U0yco73V3cU=;
	b=Ki3h2/IA7jSnLNWhlkYYImotSGdGwfF4stXsVMCBYszoJ71FXEEgwxYRnJKoa3z1XNtICv
	p2r51Mzn6pN7hh9NKvds7ZQycKO/HsKkqMZCmw5cRIywfi/LhQvYSh2WU7pVI6NYkm5XEB
	MsfXeDLlUAUsqnCgblxx5AAQ/C5hS6w=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9E0463EA63;
	Thu, 27 Nov 2025 15:33:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dPp8JVNvKGlaTAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 27 Nov 2025 15:33:39 +0000
Message-ID: <6c5f76b5888016c537f0c27082ae1e8da4bb49ca.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: identify more Storwize models
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Thu, 27 Nov 2025 16:33:39 +0100
In-Reply-To: <20251116142020.346811-1-xose.vazquez@gmail.com>
References: <20251116142020.346811-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:dkim,suse.com:email,opensvc.com:email]
X-Spam-Level: 
X-Spam-Score: -3.01
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: BA98E336AF
X-Rspamd-Action: no action
X-Spam-Flag: NO

On Sun, 2025-11-16 at 15:20 +0100, Xose Vazquez Perez wrote:
> multipath is also supported by V3500 and V3700
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


> ---
> =C2=A0libmultipath/hwtable.c | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 92523042..23187a83 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -682,7 +682,7 @@ static struct hwentry default_hw[] =3D {
> =C2=A0		.pgfailback=C2=A0=C2=A0=C2=A0 =3D -FAILBACK_IMMEDIATE,
> =C2=A0	},
> =C2=A0	{
> -		// Storwize V5000/V7000 lines / SAN Volume
> Controller (SVC)
> +		// Storwize V3x00/V5000/V7000 lines / SAN Volume
> Controller (SVC)
> =C2=A0		// Flex System V7000 / FlashSystem V840/V9000 and
> 5x00/7x00/9x00/Cx00
> =C2=A0		.vendor=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "IBM",
> =C2=A0		.product=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "^2145",

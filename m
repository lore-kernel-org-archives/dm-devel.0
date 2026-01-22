Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B3F322B63
	for <dm-devel@lists.linux.dev>; Thu, 22 Jan 2026 22:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769121645; cv=none; b=O62CO++hhgAd6gJJGh/CC/LZ0Ys7ZdLXYXsbXzcWKqdM2Jmplp5BIwoC3uJK5wHnxgvahd/88/hwjeHfvjT4xDei66iDoaf1+xn4W34/ReWeXUOPWdqtSsq/Vf9ZLAnc2+0nGOA9M+U0v5wk4IaZLDaxMgNc3aNEgiNS9k6HuSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769121645; c=relaxed/simple;
	bh=6EBQZwFNBxuwr9URHqPtBXZvr83nvCgtsLd8awcVEDY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qXAhALAbRHuueNLxSB6o7g4cScV5mdCDny3FaQOcNy85mCeBQOn3JSSXHCsU36atZwxFioxiwC45HoGCH7J0aHJWzahJ/WTHs/8puiF3c1OxJeo1l7TrpTQ0Ht+n9dzkclaeBL+RhoFkQ7QIP0A66AzvvwlVDHISVnLFxDQyjT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dEK33Lke; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gamCxSRL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dEK33Lke";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gamCxSRL"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8F1ED3378A;
	Thu, 22 Jan 2026 22:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1769121635; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hqki2Yf/WKFnb52B7ilx0ibPsLnqfN6MPq9+F4Uu4C8=;
	b=dEK33LkeT8rQ8yTeIj/J83+lGLLQpS1Lhlc9UdniDzhPix4MW4FX6JxoKUBAIWUNdHinaW
	xGXZYnT0wzxB6sSoSN5BkP2xgeLNU69iYZC1zrOOIaVVFGeKAPYhjpU/w+SXlTBcokxWqr
	33gDy5OyUix3AomUYoqyDmdrc4zOYNE=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1769121634; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hqki2Yf/WKFnb52B7ilx0ibPsLnqfN6MPq9+F4Uu4C8=;
	b=gamCxSRL8On0n9fyW0OxUoVCsaRUziRvYz6esnDjfxQAaazkNJc5BZlsM6YjU+jGJf5sGP
	RF2Ds1cdUKzZcg72EPiugPqzzntFe0GMZFbBXWh4WBP3IktvTQ56G+i5Cdg6cNeGnu4AS7
	fq6DjQwPv3Av0MOx9T6KkiqB2gnSreQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 662191395E;
	Thu, 22 Jan 2026 22:40:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7TfdF2KncmmRdgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 22 Jan 2026 22:40:34 +0000
Message-ID: <b4e7960799a46832ac07e344d11f33f9ad15e2fe.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: add FUJITSU ETERNUS VX710/VX740 to
 hwtable
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Thu, 22 Jan 2026 23:40:33 +0100
In-Reply-To: <20260122211918.317844-1-xose.vazquez@gmail.com>
References: <20260122211918.317844-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email]
X-Spam-Level: 
X-Spam-Flag: NO

On Thu, 2026-01-22 at 22:19 +0100, Xose Vazquez Perez wrote:
> Config on pag. #8:
> https://www.fsastech.com/ja-jp/products/storage/assets-a/manual/afa-disk/=
p3am-3912.pdf
> PR: https://pr.fujitsu.com/jp/news/2012/05/9-2.html
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

This one is ancient, too, and probably long out of support. But unlike
the NEC array, the document you digged up is specific and clearly
states the vendor-recommended options. So

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =C2=A0libmultipath/hwtable.c | 7 +++++++
> =C2=A01 file changed, 7 insertions(+)
>=20
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 23c54933..c2192524 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -471,6 +471,13 @@ static struct hwentry default_hw[] =3D {
> =C2=A0		.pgfailback=C2=A0=C2=A0=C2=A0 =3D -FAILBACK_IMMEDIATE,
> =C2=A0		.no_path_retry =3D 30,
> =C2=A0	},
> +	{
> +		// ETERNUS VX700 series
> +		.vendor=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "FUJITSU",
> +		.product=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "ETERNUS_VX700",
> +		.pgpolicy=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D MULTIBUS,
> +		.no_path_retry =3D 120,
> +	},
> =C2=A0	/*
> =C2=A0	 * Hitachi Vantara
> =C2=A0	 *

Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F07F1DE89D
	for <dm-devel@lists.linux.dev>; Tue, 18 Mar 2025 19:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742327459; cv=none; b=UQqjDekOw3TWqIOFm9MPK9Efpa5xKIW4DoOwUNj3mr3PhrgQhulSZsSLlShXEm8n9vAlf/Cdx4cn4mMrLLkl/pFoT+VhjJYuGAdP9Ient5vEqpj4v3m6cCOB0NxRSukJ5ql9Dln9rA2sBAgSq275ypqWvxYQVDNxt6KrNepaWRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742327459; c=relaxed/simple;
	bh=D9bvtRjr/cxKNKTSw1sRNWdXrtONtgKsjzvttGAO6D0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RDi0dYq4qH3KSE+9m3YGIlyHIKQkNVSrGy2WIMS6ZYA+IvNGJpzbhINFfuUf9jh2/GSqdOKcN5WBxe4swojAW0rJaEVH7w3yyAJ55gAxYrqUBwJDiCZepmSUYhthqNPoagsGhy8l9IRzChGmAjoUVEpB0ENAb+qOKuCIhJ/47gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kiTvYt+M; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kiTvYt+M; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kiTvYt+M";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kiTvYt+M"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 074A71F7AF;
	Tue, 18 Mar 2025 19:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1742327452; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7iO55H1tmU4xY5hgtmrmlIxVKZRyEB0FBqETdW1l+0E=;
	b=kiTvYt+MDg+r+WqZS2s5efleUAleVpl2VSQEPIDczRMBYnkymJ3e8fhgvpCOJzpZFOYPJ+
	e1CCBLLrz0eukTv0fV4/KnMPm0GN3H+fHHuc4VmFnEF0wQsabguwP4KO3kmug0xEta30aG
	0Kl07KnEokCSjDitcXtJUHuxPI3Y4OI=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=kiTvYt+M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1742327452; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7iO55H1tmU4xY5hgtmrmlIxVKZRyEB0FBqETdW1l+0E=;
	b=kiTvYt+MDg+r+WqZS2s5efleUAleVpl2VSQEPIDczRMBYnkymJ3e8fhgvpCOJzpZFOYPJ+
	e1CCBLLrz0eukTv0fV4/KnMPm0GN3H+fHHuc4VmFnEF0wQsabguwP4KO3kmug0xEta30aG
	0Kl07KnEokCSjDitcXtJUHuxPI3Y4OI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C654D139D2;
	Tue, 18 Mar 2025 19:50:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id G7UyLpvO2WePcQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 18 Mar 2025 19:50:51 +0000
Message-ID: <e2ab0e3c11621a0e04ae5536049825da48843e7c.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: identify more arrays under IBM/2145 ID
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Tue, 18 Mar 2025 20:50:51 +0100
In-Reply-To: <20250313071751.345627-1-xose.vazquez@gmail.com>
References: <20250313071751.345627-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 074A71F7AF
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_RCPT(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,suse.com:email,suse.com:dkim,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Flag: NO

On Thu, 2025-03-13 at 08:17 +0100, Xose Vazquez Perez wrote:
> Add IBM Storage FlashSystem C200:
> https://www.ibm.com/docs/en/flashsystem-c200/8.7.x_cd?topic=3Dsystem-sett=
ings-linux-hosts
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =C2=A0libmultipath/hwtable.c | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index f8cf3fa9..8001d5be 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -659,7 +659,7 @@ static struct hwentry default_hw[] =3D {
> =C2=A0	},
> =C2=A0	{
> =C2=A0		// Storwize V5000/V7000 lines / SAN Volume
> Controller (SVC)
> -		// Flex System V7000 / FlashSystem V840/V9000 and
> 5x00/7x00/9x00
> +		// Flex System V7000 / FlashSystem V840/V9000 and
> 5x00/7x00/9x00/Cx00
> =C2=A0		.vendor=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "IBM",
> =C2=A0		.product=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "^2145",
> =C2=A0		.no_path_retry =3D NO_PATH_RETRY_QUEUE,


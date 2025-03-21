Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C5B1DE3CE
	for <dm-devel@lists.linux.dev>; Fri, 21 Mar 2025 10:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742554353; cv=none; b=V++A+gG1eqTnQuTem0+dlP2IO/CamMPw7+8ZSZjle5lrsxda/H9HORMdg4/llqvcbmrwgiJ7NkpcflXKtoh2FjLD56CBOfPzSSAEmTHKNVuArRI05U5D03lCDlrYmIhY9kSrxyAOhzmjJ9Ox7ihpVa99NOL19c2aanuECNDDtgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742554353; c=relaxed/simple;
	bh=f0G8oemWfOmvAVBm+f/CRO1TO5BR5H3eYCXdyMJ10hs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KcW0P+EJItsBBKHIyJRawqR6Rx4OgexoIz1tbHZAAdtNZ9dn2TNfxoU7en96g0gjr9tx+skFkhf+Hs8Ym5jNotE2fr1cKQ6qm3alozeMr/XttiQCMU9tfVp+s4tPq0qVlGUotkXx/NZd+Sqf49c7xonBOoXIFB8kYK1OBPAkeO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=NUgyaA3l; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=s+zH1zX2; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NUgyaA3l";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="s+zH1zX2"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 83C271F7BC;
	Fri, 21 Mar 2025 10:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1742554343; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L70BGqYu1iDjZ0nOSDBP1mI/59g94DjyDZvQvc3U+As=;
	b=NUgyaA3lz2MHyDqzB7d3ERUeIruv5AsZjeFl8D+bzgMhOhHceKWBOqejA5TiUzGmAC/QXe
	ylCED+lkXIs6p+dDpOIlE+7idfwU7QPd7aODiOF6/fLVKajlnwL7iNyisPN6z4PrHagZeN
	kb5wc8Fb9Wl50GNLdxsPPu0wez+0Ra8=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1742554342; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L70BGqYu1iDjZ0nOSDBP1mI/59g94DjyDZvQvc3U+As=;
	b=s+zH1zX2Up+KT0XEEHirT/0JvgxRNYbi38AAoUeCCBX5LaZ39Z4zA7+OoFzncoBoBdLgSH
	K5Liks6T91MzbArE8p7erPZBA5Z8kibkBlMrHm7ZG8b8Ke6AcIg5zjRibmxvF4bUxtORiK
	3zmw0wKpDSkyx8XTZ1H+y967tD0gMWY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 563AF13A2C;
	Fri, 21 Mar 2025 10:52:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iU4vE+ZE3Wf+NQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 21 Mar 2025 10:52:22 +0000
Message-ID: <3c601bea9fdb45b7a284faa9023eef33de014e9b.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: remove checker from Huawei OceanStor
 NVMe
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Fri, 21 Mar 2025 11:52:21 +0100
In-Reply-To: <20250321084649.16093-1-xose.vazquez@gmail.com>
References: <20250321084649.16093-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,opensvc.com:email,linux.dev:email,suse.com:email,suse.com:mid]
X-Spam-Score: -2.80
X-Spam-Flag: NO

On Fri, 2025-03-21 at 09:46 +0100, Xose Vazquez Perez wrote:
> A keep alive timer is implemented in the NVMe-oF protocol by default,
> which acts like a path checker.
> Therefore, change path_checker to default, "none" for NVMe arrays.

I'm not sure about this. NVMe keep-alive will check the connection to
the NVMe controller, while our path checker is designed to check the
availability of a given NVMe namespace, which is only almost the same.=C2=
=A0

With the "none" checker, multipathd will simply trust the sysfs state.
We have seen issues in the past (e.g. with the LIO target) where even
use of the TUR checker resulted in paths being reinstated by multipathd
even though they weren't actually usable, causing them to toggle back
and forth between UP and DOWN state. I can imagine this happening for
NVMe, too.

Does it do any harm to keep the directio checker enabled for NVMe as an
extra safety guard?

Most people will be using native kernel multipath for NMVe these days.
I consider dm-multipath on NVMe as a feature in maintenance mode, and
I'd prefer applying only necessary bug fixes in the area.

Thanks,
Martin

>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> =C2=A0libmultipath/hwtable.c | 1 -
> =C2=A01 file changed, 1 deletion(-)
>=20
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index cf39a50d..862bfdaa 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -1100,7 +1100,6 @@ static struct hwentry default_hw[] =3D {
> =C2=A0		/* OceanStor NVMe */
> =C2=A0		.vendor=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "NVM[eE]",
> =C2=A0		.product=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "Huawei-XSG1",
> -		.checker_name=C2=A0 =3D DIRECTIO,
> =C2=A0		.no_path_retry =3D 12,
> =C2=A0	},
> =C2=A0	/*


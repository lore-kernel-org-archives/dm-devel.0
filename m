Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446025;
	b=jvxVR8bHLb2iT/Yys+iqHoqrwoCRZ/AViCPUdhePwqfx07dIwbA+hUfrimenIZlRtteW
	 n3AE+hI2nhUf43c4WxSpLgJLr0nBK84MpRVKtrUQ5I3G5AOFRPASmCCErTo5MYi7Ew+Re
	 mt/58wUdywc6re9DA2jBGcQZG7Si6Z+BWW6X9Sb8sRWY6nOgcAp2BNOWBIk0QNhbY94kZ
	 PS7y1dafI1zJRaEN8cW7d9tH7TYnGQFNF8okeiq8lYxrx7K0jCHvf5pxyrGNsBAbQW/wN
	 kXrdCM07meaUX+fZRJMMFaIYq2jPMz+pZalf6EqEpkBBqQwBpPBBNPRYvBvfu6pj7DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446025;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version:
	 X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=eeq4tK45cXaiQaFQ6aPxPAfpHLqaxKYlS8sqeCXSBTc=;
	b=VLGsFCOpKT75e2W1IWbGgaJ8Z0zKtEX06EHLxnTwbp+KW7WIjOdppq/Vf8KCVqLo2uKy
	 SiqA7K/2jm2lUjVS7iBooXq1MLUAjgJJlZijkjE2kv8kFnosJFosgqbx064qTk1LFojaH
	 IBTs+AjGd21UsUwFFMmvg5cdmH36q2bOZ0534wlQmxv3ZqsCR5NBhPCdZ9I1S/xhLoeeM
	 QqaJ3I8tIZAh542o5AhKY4PGfa2xgPsSCLaFcDoKdt+gcIwvNxl1Y8Phi8s3ifF9CV8h0
	 y7lSCSHqvXEQ9C4GoqLxFzx5OkXdOvkDG0fAd1R1mOPtXxy8h0aauNa0ppLtS/Vg1CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=c6U4JhUZ;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=H7bAVPkv;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A2A606A31E
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 15:00:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30A2A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=c6U4JhUZ;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=H7bAVPkv
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 31A0E1F84D;
	Mon, 23 Nov 2026 15:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795446023; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eeq4tK45cXaiQaFQ6aPxPAfpHLqaxKYlS8sqeCXSBTc=;
	b=c6U4JhUZiJzSO5asV5JPLG2fFlvue5QAUQ/kcRRI1CYRMJluSHAk62SQP7zEPXaCOfR6lj
	+ZNujBHhdKPKSpK6Vo9dW4/urgMmEy04fGuUQhtH1F51/ItLl3D69Sf5209IodS4PCGmgR
	cU7FpG02g3L8KpkT1gQkb/YZw9vUU/A=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795446022; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eeq4tK45cXaiQaFQ6aPxPAfpHLqaxKYlS8sqeCXSBTc=;
	b=H7bAVPkv6TCgFvjqYw++HiLHVwkhjyfiFEYmaNZQEEuv1+vTRWAnBZlF93CPi8+wnKET85
	aMjxryg+cxyOxQrGjEsEaIgzWDcocS1ENhQ50amAORry08szgT9bmi3rANn6Ok9nN+02ag
	ZLi1O7jVdH+zGi6uxBl3AYdlZATrwJA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E553413510;
	Mon, 23 Nov 2026 15:00:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sxnHLAVVBGt+ewAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 23 Nov 2026 15:00:21 +0000
Message-ID: <16d621bce8b1e5f027f07a8b235be0d1f6f05796.camel@suse.com>
Subject: Re: [PATCH RESEND 03/13] multipath-tools: hwtable: add FUJITSU
 ETERNUS VX710/VX740
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Mon, 23 Nov 2026 16:00:21 +0100
In-Reply-To: <20261113125549.504780-4-xose.vazquez@gmail.com>
References: <20261113125549.504780-1-xose.vazquez@gmail.com>
	 <20261113125549.504780-4-xose.vazquez@gmail.com>
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
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[fsastech.com:url,linux.dev:email,imap1.dmz-prg2.suse.org:helo,opensvc.com:email,suse.com:email,fujitsu.com:url]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

On Fri, 2026-11-13 at 13:55 +0100, Xose Vazquez Perez wrote:
> Config on page 8:
> https://www.fsastech.com/ja-jp/products/storage/assets-a/manual/afa-disk/=
p3am-3912.pdf
> PR: https://pr.fujitsu.com/jp/news/2012/05/9-2.html
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> =C2=A0libmultipath/hwtable.c | 7 +++++++
> =C2=A01 file changed, 7 insertions(+)
>=20
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 8ad3539e..6371a626 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -468,6 +468,13 @@ static struct hwentry default_hw[] =3D {
> =C2=A0=09=09.pgfailback=C2=A0=C2=A0=C2=A0 =3D -FAILBACK_IMMEDIATE,
> =C2=A0=09=09.no_path_retry =3D 30,
> =C2=A0=09},
> +=09{
> +=09=09// ETERNUS VX700 series
> +=09=09.vendor=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "FUJITSU",
> +=09=09.product=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "ETERNUS_VX700",
> +=09=09.pgpolicy=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D MULTIBUS,
> +=09=09.no_path_retry =3D 120,
> +=09},

I see this in the manual (my Japanese being a bit rusty), but are you
certain that the VX700 has no ALUA support? If it does, it's at least
misleading to set pgpolicy to MULTIBUS here, as this will be overridden
by ALUA auto-detection.

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)

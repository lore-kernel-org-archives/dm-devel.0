Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440D3303C86
	for <dm-devel@lists.linux.dev>; Thu, 22 Jan 2026 22:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769121547; cv=none; b=h69g+tSYYISjrdo4lIglsytOLt9iRdCkRi0PDrvDATxQOub2lKn3MTSnKKHGKkHlVT9oFtsoOroHDRcOZNVREcknCnYqKKJyMlDHXjyuPvWErusxagTcfGbHT3nR9oiPg2rjQILdU8BkCPcOQNsYkcHwuwVLcm1t11l+cvx2AEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769121547; c=relaxed/simple;
	bh=FSO7Ql0K2jDV/fqjccH8DsaI9+QUtI7Odct8DNGREhY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SH+SxALVLPOjpMzR5ZLdQcMksS91l9/Dxwg49Bjpq3yMBz4OZ0N/AbHUC7B6z0k8ezFsJZLpdaHDPvZ8H+l8UWsHHDOuV+oC6IDphSEiWGQwqzq5usT4TBygxH6ciyBKoEXyo9Y2RH+2b3nykPgr7CUBOW/DZsWh1MU9325obGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GZ+1oUlS; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GZ+1oUlS; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GZ+1oUlS";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GZ+1oUlS"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8271433789;
	Thu, 22 Jan 2026 22:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1769121539; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+HlcpNNa+Fy9jEYtSV4YvD7ZJ1hYW8OQnzgq1kRwm1w=;
	b=GZ+1oUlSyIxDtWw2YHVcNnx89s29C0kjhtJkmFyeowoSeHe2s8whK3umroqMe0I2Yq4oCl
	++Emmnwv9qMtFRqhD+GD3zSPMwu3x+gH5BqYMq93GnM89NIkjGONjH/+GFbmh+sgCUA8DP
	RjF1Onezw/rBd3/TxB4cWmpDKUX7YbA=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1769121539; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+HlcpNNa+Fy9jEYtSV4YvD7ZJ1hYW8OQnzgq1kRwm1w=;
	b=GZ+1oUlSyIxDtWw2YHVcNnx89s29C0kjhtJkmFyeowoSeHe2s8whK3umroqMe0I2Yq4oCl
	++Emmnwv9qMtFRqhD+GD3zSPMwu3x+gH5BqYMq93GnM89NIkjGONjH/+GFbmh+sgCUA8DP
	RjF1Onezw/rBd3/TxB4cWmpDKUX7YbA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5062F1395E;
	Thu, 22 Jan 2026 22:38:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ojkKEgOncmkrdQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 22 Jan 2026 22:38:59 +0000
Message-ID: <f8ac0fb7f1582371dfeafb381f19a173c7ce1fce.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: add NEC iStorage to hwtable
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Mike Christie <michael.christie@oracle.com>, Benjamin Marzinski	
 <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>,
  DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Thu, 22 Jan 2026 23:38:58 +0100
In-Reply-To: <20260122212939.321161-1-xose.vazquez@gmail.com>
References: <20260122212939.321161-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

On Thu, 2026-01-22 at 22:29 +0100, Xose Vazquez Perez wrote:
> Info from https://marc.info/?l=3Dlinux-kernel&m=3D122123037102604=C2=A0:
>=20
> "Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> [...]
> Some basic function/performance testings are done with NEC iStorage
> (active-active multipath)..."

Thanks... so, you inferred the settings just from the "active-active"?=20
That might be correct, but it's hard to say with confidence after 15+
years.

Nobody has complained about this device not being in our HW table.
I admire your detective skills, but I don't think that adding it now,
guessing the parameters, makes much sense.

Regards,
Martin

>=20
> Added to BLIST in:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D12427d99489966185dc12a0b6f725d682a3277ca
>=20
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> =C2=A0libmultipath/hwtable.c | 7 +++++++
> =C2=A01 file changed, 7 insertions(+)
>=20
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 23c54933..4fc245a4 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -872,6 +872,13 @@ static struct hwentry default_hw[] =3D {
> =C2=A0		.pgfailback=C2=A0=C2=A0=C2=A0 =3D -FAILBACK_IMMEDIATE,
> =C2=A0		.prio_name=C2=A0=C2=A0=C2=A0=C2=A0 =3D PRIO_ALUA,
> =C2=A0	},
> +	{
> +		 // iStorage series
> +		.vendor=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "NEC",
> +		.product=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "iStorage",
> +		.pgpolicy=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D MULTIBUS,
> +		.no_path_retry =3D 30,
> +	},
> =C2=A0	/*
> =C2=A0	 * Oracle
> =C2=A0	 */

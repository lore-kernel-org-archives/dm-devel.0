Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572222AC17
	for <dm-devel@lists.linux.dev>; Fri,  9 May 2025 14:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746799709; cv=none; b=uCn+kJ/PGIbicSRx3O/JvJKP4g/TbwuQnKK88HFEIVNW8fh26VjMdG1CVD62P38eO2dzS9LH7OuYU/K154Y2r7iFXYHE+QAFIdEpXkVIwEdn6M/fQbfxjWVEkW0cMRYDzml2DEzN3uBH/pjUZ2jP3cAlnW50DTwImuwVMwsHZ74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746799709; c=relaxed/simple;
	bh=TrJVjyYWrcM8W85KJcWLYymtyMA8GZScxiQRUKB3mdY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Xun+ObtVbzubrFImNpvHL2yFhAYd41kPq1uVcuTtNBM50pvJgLLDVc+S+m7YKrZ165fsDbY2+JWDnEIa+LwX5Ymjq6uTOP68x47+9c1cN1toaOm0VEo/OZkQi2Vg4hGDcK4fTEeMHiLJ9FyeHyRkjmp9Aebf7+KIM88rxCPaoj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HbdRyD9F; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OzoqUsuA; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HbdRyD9F";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OzoqUsuA"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 377111F38A;
	Fri,  9 May 2025 14:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1746799705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FznH2d3CssSuIvZrnbelbNsWzxDuIHXnFjbVL+VrU3E=;
	b=HbdRyD9Fa9cdbwiVz/vZwvcMAYV2CgDw6+bQCiw+AiddekdGw9O99Vv7cS0zSe1LCrPvDv
	nj2XxaN2gH8kWEHLtuDxxZdJ5Aa2k5/mgRzIU4E9JxQ5O4DCeHW6813Py3CUF+gzE5Zylz
	F8sZksqfZuWyyrAgsM3WcgiTan5iqjU=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=OzoqUsuA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1746799704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FznH2d3CssSuIvZrnbelbNsWzxDuIHXnFjbVL+VrU3E=;
	b=OzoqUsuA4fvYCQAA/KJGslcvmSBAdwzy2YeqlOtHbeXnDrsxZUiNXpyzDdrepgyxrUxGQh
	lV0FlwZ/AOP/ZQX739hTmM35v+jEhHJpEXREZUWVf8LH4fZPQWwEIMI8h3UMkqukzgGy7T
	SufNzGZHyhpmJ5NrZRe/NcyEk3Nl3WU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F17E31399F;
	Fri,  9 May 2025 14:08:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dlRZOVcMHmhqRgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 09 May 2025 14:08:23 +0000
Message-ID: <085c156c31fcd2fc5da4e889642bd6186c677a7c.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: replace round-robin path selector with
 the default for NFINIDAT/InfiniBox
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, arnony@infinidat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>, 
 John Meneghini <jmeneghi@redhat.com>
Date: Fri, 09 May 2025 16:08:23 +0200
In-Reply-To: <20250509134459.226640-1-xose.vazquez@gmail.com>
References: <20250509134459.226640-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 377111F38A
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FREEMAIL_TO(0.00)[gmail.com,infinidat.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,infinidat.com:email,marc.info:url,opensvc.com:email,suse.com:email,suse.com:dkim,suse.com:mid]
X-Rspamd-Action: no action

On Fri, 2025-05-09 at 15:44 +0200, Xose Vazquez Perez wrote:
> round-robin is a basic selector, and only works well under ideal
> conditions,
>=20
> A nvme benchmark, round-robin vs queue-depth, shows how bad it is:
> https://marc.info/?l=3Dlinux-kernel&m=3D171931850925572
> https://marc.info/?l=3Dlinux-kernel&m=3D171931852025575
> https://github.com/johnmeneghini/iopolicy/?tab=3Dreadme-ov-file#sample-da=
ta
> https://people.redhat.com/jmeneghi/ALPSS_2023/NVMe_QD_Multipathing.pdf

All these are about native nvme multipath. None is about dm-multipath.

> The same happens for scsi.

Please support this claim with actual numbers. I'm not saying that it's
wrong (it makes sense that John's argument=C2=A0"the round-robin path
selector is inefficient in cases where there is a difference in latency
between paths" applies to all implementations), but you can't present
numbers for one technology and simply apply them to a different
technology without providing any evidence for the latter.

I'd accept this statement in a weaker form, like "It is reasonable to
assume that the same effects would be measured with dm-multipath over
SCSI devices, too".

>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> Should global keywords be banned in the devices section, or deleted
> from hwtable ???
> dev_loss
> fast_io_fail
> max_sectors_kb
> ...
>=20
> They interfere when two, or more, different arrays are connected to
> the same host.
> ---
> =C2=A0libmultipath/hwtable.c | 4 ----
> =C2=A01 file changed, 4 deletions(-)
>=20
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 081d119c..3ade3669 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -1125,11 +1125,7 @@ static struct hwentry default_hw[] =3D {
> =C2=A0		.pgpolicy=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D GROUP_BY_PRIO,
> =C2=A0		.pgfailback=C2=A0=C2=A0=C2=A0 =3D 30,
> =C2=A0		.prio_name=C2=A0=C2=A0=C2=A0=C2=A0 =3D PRIO_ALUA,
> -		.selector=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "round-robin 0",
> -		.rr_weight=C2=A0=C2=A0=C2=A0=C2=A0 =3D RR_WEIGHT_PRIO,
> =C2=A0		.no_path_retry =3D NO_PATH_RETRY_FAIL,
> -		.minio=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D 1,
> -		.minio_rq=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D 1,
> =C2=A0		.fast_io_fail=C2=A0 =3D 15,
> =C2=A0	},
> =C2=A0	/*

This code is from 55da608 ("libmultipath: update INFINIDAT builtin
config"), signed-off by=C2=A0arnony@infinidat.com. We usually don't change
defaults from explicit vendor recommendations without consent from the
vendor. I've added Arnon to cc, maybe he wants to comment on your
suggestion.

Regards,
Martin

Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CFF3BD225
	for <dm-devel@lists.linux.dev>; Tue,  6 Oct 2026 21:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320851; cv=none; b=nEMQIF9qYJ9GiCeNdwUuc4BZclKwccKlxzuvi7OAcuXXd3ajT93oeXzkujZPv8MI6mS1GWTbCdgKdvcRDjxNWqhVlbvgt+Wdw2XTHYLXtWJhI2Nux+rq/otGN39/m+yj4+UxCdsooQx1AxUCxt6BD9xZjgBBV9dNCfN+TA6TMg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320851; c=relaxed/simple;
	bh=BROZZRG7mITiDvpJplzGqFlH/SLG0e+SNz2NkcRK91A=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VJaRAdalIOUweazoWNHK7pG+D26HHAWaFcY5/RByhvLT6OHeMcO5bAAPX8BAaxtMKjg3F8IqY4yqw5aSTt9xMMuB3KN1OCvIS1niksgxn0LzT5kp2kGmkNUSVSfFborfrrzZPwsWI1zqJ6AUeMBhOxh7z05FdOkYWIkCe6BVqc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=AXHYWJ7G; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Q7NqJqUg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="AXHYWJ7G";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Q7NqJqUg"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E82F81F796;
	Tue,  6 Oct 2026 21:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791320844; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g5UH7eSj9P2yKMoAaJ4jhE67tr7g8Y8TqfA1NIXXj8I=;
	b=AXHYWJ7G09bbNF4w6mjUYW7yGsHCBcpSsniQrkxd7YTKO11Lcs4raOt2RvlEacnVzJWqvi
	xDbcoIQdHDpzN/roM9X8UvErmBFyNq1jumgDcJ2At/F6SfCLG8mgsgk8nNOnNs9Tw3ZQQb
	1OmLU5syZCr9B9faz0K0gyS8AkHBmgA=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Q7NqJqUg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791320839; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g5UH7eSj9P2yKMoAaJ4jhE67tr7g8Y8TqfA1NIXXj8I=;
	b=Q7NqJqUggHW+AgTJoQaAgTHeiqHkYJh3nhb2ZqzppSrQDSHAtXsG1PKqftfaQQ4zwvcQ1P
	dB2DWEHTT/lpL2v82V+3KLd0Fi/7/CbchqYTLjGwMarF8Wn62pUpQ0XA79KPY3C8VfMdNM
	W0fV4aguTG6hvC6EV84E0mjQk7pLOs8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AE2F2137AC;
	Tue,  6 Oct 2026 21:07:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hLLkIAdjxWoEUwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 06 Oct 2026 21:07:19 +0000
Message-ID: <ea3d358c00cad3559658023d6bc98937c265218b.camel@suse.com>
Subject: Re: [PATCH 2/2] libmultipath: dm_flush_map__: retry the resume
 after a failed remove
From: Martin Wilck <mwilck@suse.com>
To: Suresh Thelkar <suresh.thelkar@yahoo.com>, dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Date: Tue, 06 Oct 2026 23:07:19 +0200
In-Reply-To: <20261005045726.71858-3-suresh.thelkar@yahoo.com>
References: <20261005045726.71858-1-suresh.thelkar@yahoo.com>
	 <20261005045726.71858-3-suresh.thelkar@yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E82F81F796
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_TO(0.00)[yahoo.com,lists.linux.dev];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[yahoo.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:email,suse.com:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On Mon, 2026-10-05 at 04:57 +0000, Suresh Thelkar wrote:
> After a failed DM_DEVICE_REMOVE the map was suspended earlier in
> dm_flush_map__(), and the recovery path issued a single fire-and-
> forget
> DM_DEVICE_RESUME whose result was ignored. If that resume ioctl
> failed
> (possible under an ioctl storm) the map stayed suspended, which
> wedges
> any later task in uninterruptible D state and, because sync() walks
> every block device, hangs I/O node-wide until reboot.
>=20
> Since the map is known to have been suspended at the start of the
> loop,
> the DM_DEVICE_RESUME return value is authoritative. Simply retry the
> resume once if the ioctl fails, so a transient failure does not leave
> the map suspended. The remove is still retried by the enclosing loop
> when retries are requested.
>=20
> Signed-off-by: Suresh Thelkar <suresh.thelkar@yahoo.com>
> ---
> =C2=A0libmultipath/devmapper.c | 10 ++++++----
> =C2=A01 file changed, 6 insertions(+), 4 deletions(-)
>=20
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index a5570a85..bea7e804 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -1062,10 +1062,12 @@ int dm_flush_map__ (const char *mapname, int
> flags, int retries)
> =C2=A0			else
> =C2=A0				condlog(2, "failed to remove
> multipath map %s",
> =C2=A0					mapname);
> -			if ((flags & DMFL_SUSPEND) &&
> queue_if_no_path !=3D -1) {
> -
> 				dm_simplecmd_noflush(DM_DEVICE_RESUME,
> -						=C2=A0=C2=A0=C2=A0=C2=A0 mapname,
> udev_flags);
> -			}
> +			/* The map was suspended above; resume it so
> a failed
> +			 * remove does not leave it suspended. Retry
> once if the
> +			 * resume ioctl itself fails. */
> +			if ((flags & DMFL_SUSPEND) &&
> queue_if_no_path !=3D -1 &&
> +			=C2=A0=C2=A0=C2=A0 !dm_simplecmd_noflush(DM_DEVICE_RESUME,
> mapname, udev_flags))
> +				dm_simplecmd_noflush(DM_DEVICE_RESUM
> E, mapname, udev_flags);

Have you tested this, and have you observed cases where it actually
helped to resume a device after the first DM_DEVICE_RESUME had failed?

Would it increase the chances to resume the device if we wait a few
fractions of a second before retrying?=20

Regards
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)

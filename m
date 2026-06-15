Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6832FF67E
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 08:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781511344; cv=none; b=IdupPdDCFdyq+R/x2asf7Ya+bipUKaLRndFIrxujyU5DGB0w58eiFQPTAO1O/VF0whz8PwtuGlstyaFy3pB9Yp5Ysf31fSL3jAwlnMXciPcdbXLvXVQmPen6FOcEwuT79GhqKLlmt4rFi/CBhYMOLnb+5zN5tkcmRTHzRYyu7wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781511344; c=relaxed/simple;
	bh=wGHPzdmjocnKHzRa5ralO3tsMcwAKQpQJYOhXQzVqYo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TyUKuGe6MTxKMDyIJP01A70q+mSZQzXl4Zb46Gu9irb0viMrqu13GaeuCu6hNQtpFAlQ1HwMsAiM2F3i+iE04Qx7gq8Ll5ioLdQF3LLgWlIoemIElV7DjLzh369kYqjm5p95Ti10xXRy/PzfiX1r0O0bkwu1fVsdKKWRSKzN3LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Q8T85no2; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Q8T85no2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Q8T85no2";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Q8T85no2"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BAA756BE5D;
	Mon, 15 Jun 2026 08:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781511340; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wGHPzdmjocnKHzRa5ralO3tsMcwAKQpQJYOhXQzVqYo=;
	b=Q8T85no2wgnR1Gn7fo20Joc0Gn9SdwQh+/2xPx5j4tuWQW1xpeJ7y4DXkSQk6M1HODMWbD
	npP15KiJYgRpz4yyv6otY8u9Bw1r7WIK1tsBKW3RPCVY0SAh5PI1Hq2n7IYOeHzirEFgj4
	JUbawnIKp+fg9xsQta51dXIKvnq5U6U=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781511340; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wGHPzdmjocnKHzRa5ralO3tsMcwAKQpQJYOhXQzVqYo=;
	b=Q8T85no2wgnR1Gn7fo20Joc0Gn9SdwQh+/2xPx5j4tuWQW1xpeJ7y4DXkSQk6M1HODMWbD
	npP15KiJYgRpz4yyv6otY8u9Bw1r7WIK1tsBKW3RPCVY0SAh5PI1Hq2n7IYOeHzirEFgj4
	JUbawnIKp+fg9xsQta51dXIKvnq5U6U=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9968A779A7;
	Mon, 15 Jun 2026 08:15:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w1FbJKy0L2ofcwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 15 Jun 2026 08:15:40 +0000
Message-ID: <0c793aacfa560f76d2e5e4b34ad453d2b05cbbad.camel@suse.com>
Subject: Re: [PATCH 4/5] multipath-tools: clarify user_friendly_names prefix
 behavior in multipath.conf.5
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Mon, 15 Jun 2026 10:15:40 +0200
In-Reply-To: <20260613131002.144263-5-xose.vazquez@gmail.com>
References: <20260613131002.144263-1-xose.vazquez@gmail.com>
	 <20260613131002.144263-5-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid]
X-Spam-Level: 
X-Spam-Score: -2.80

On Sat, 2026-06-13 at 15:09 +0200, Xose Vazquez Perez wrote:
> Clarify that the alias prefix depends on the alias_prefix setting.
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> =C2=A0multipath/multipath.conf.5.in | 10 ++++++----
> =C2=A01 file changed, 6 insertions(+), 4 deletions(-)
>=20
> diff --git a/multipath/multipath.conf.5.in
> b/multipath/multipath.conf.5.in
> index 9289b244..74447f8c 100644
> --- a/multipath/multipath.conf.5.in
> +++ b/multipath/multipath.conf.5.in
> @@ -704,11 +704,13 @@ The default is: \fBunused\fR
> =C2=A0.B user_friendly_names
> =C2=A0If set to
> =C2=A0.I yes
> -, using the bindings file \fI@STATE_DIR@/bindings\fR to assign a
> persistent
> -and unique alias to the multipath, in the form of mpath<n>. If set
> to
> +, the bindings file \fI@STATE_DIR@/bindings\fR is used to assign a
> persistent
> +and unique alias to the multipath, in the form of \fIprefix\fR<n>
> (where
> +\fIprefix\fR is defined by \fIalias_prefix\fR; by default
> \IBmpath<n>\fR).

I think this should be "\fImpath\fR".

Martin

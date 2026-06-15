Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578AD28C869
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 08:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781511422; cv=none; b=DOkahnm4FQTCpV3u+zgLDXGGXwyvrtf72c+hu/252gNdzGSrktApgUyw3InhbgiZQ/jIJkkS15WLEvgJVWE4zXj1HA51cGLm00WnivPojWSB2C2e5KbHKe46xt45rVHzrmsGfSKPmYl2On0GSdK0VNDfL5Byg8aWuG4eEYxlc6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781511422; c=relaxed/simple;
	bh=m+k9sGvFRHtY2D7ixWN/lqiDm/t1J7HbkTavX3D0WNU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DddQ3v4REMO3IRoXKICFRSVkVGUIVhhXZZiA0wNaH8noALKQsg/GuHf7Z+HcQkvvMMh5WBQV1VV6JaX0Oumi9pWIZV7e/OdXl9HXupXGwa6WQ+S4L+oDOXOvRszDOmf9PUfuLs75Sj1KXpxau6UiY1EDlBM0zft5i5mSF6ITD48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gTkyyCNw; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gTkyyCNw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gTkyyCNw";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gTkyyCNw"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6D0A575F19;
	Mon, 15 Jun 2026 08:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781511419; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m+k9sGvFRHtY2D7ixWN/lqiDm/t1J7HbkTavX3D0WNU=;
	b=gTkyyCNwy68eqT9Kn3bobNKMpF6pPeBXx6NFQBCSu0VS1xamQj5OEPUDzKJ/gjhoEswDeM
	laLBXNYPO7iJyK8ssjSAQmkxKmcpPONiG7wT63vcwb/1NxkBEqnDkjGuKVoOw5TZbhhTf+
	WmNUyPCGeqEv1n/NZdazEDpkfjPLJYE=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781511419; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m+k9sGvFRHtY2D7ixWN/lqiDm/t1J7HbkTavX3D0WNU=;
	b=gTkyyCNwy68eqT9Kn3bobNKMpF6pPeBXx6NFQBCSu0VS1xamQj5OEPUDzKJ/gjhoEswDeM
	laLBXNYPO7iJyK8ssjSAQmkxKmcpPONiG7wT63vcwb/1NxkBEqnDkjGuKVoOw5TZbhhTf+
	WmNUyPCGeqEv1n/NZdazEDpkfjPLJYE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D8DE779A7;
	Mon, 15 Jun 2026 08:16:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HGDWEfu0L2r7dAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 15 Jun 2026 08:16:59 +0000
Message-ID: <7c28dd835abebb6f9e4ff69159e417cac323409f.camel@suse.com>
Subject: Re: [PATCH 2/5] multipath-tools: clarify path selector descriptions
 in multipath.conf.5
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Mon, 15 Jun 2026 10:16:58 +0200
In-Reply-To: <20260613131002.144263-3-xose.vazquez@gmail.com>
References: <20260613131002.144263-1-xose.vazquez@gmail.com>
	 <20260613131002.144263-3-xose.vazquez@gmail.com>
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
X-Spam-Score: -2.80
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

On Sat, 2026-06-13 at 15:09 +0200, Xose Vazquez Perez wrote:
> Selectors operate on the next individual I/O request rather
> than a "bunch" of I/O.

This patch doesn't apply cleanly to any of my branches (master, queue,
tip).

>=20
> Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> =C2=A0multipath/multipath.conf.5.in | 12 +++++-------
> =C2=A01 file changed, 5 insertions(+), 7 deletions(-)
>=20
> diff --git a/multipath/multipath.conf.5.in
> b/multipath/multipath.conf.5.in
> index 422ab120..287441bd 100644
> --- a/multipath/multipath.conf.5.in
> +++ b/multipath/multipath.conf.5.in
> @@ -2,7 +2,7 @@
> =C2=A0.\" Update the date below if you make any significant change.
> =C2=A0.\" ---------------------------------------------------------------=
-
> ------------
> =C2=A0.
> -.TH MULTIPATH.CONF 5 2026-05-27 Linux
> +.TH MULTIPATH.CONF 5 2026-06-13 Linux
> =C2=A0.
> =C2=A0.
> =C2=A0.\" ---------------------------------------------------------------=
-
> ------------
> @@ -193,20 +193,18 @@ kernel multipath target:
> =C2=A0.RS
> =C2=A0.TP
> =C2=A0.I "round-robin 0"
> -Choose the path for the next bunch of I/O by looping through every
> path in the
> -path group, sending \fBthe same number of I/O requests\fR to each
> path.
> -
> +Choose the path for the next I/O request by \fBcycling through the
> path group\fR.

I think "group" should be replaced by "groups" here.

Martin

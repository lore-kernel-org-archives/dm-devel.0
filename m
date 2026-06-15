Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D3D3BD246
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 08:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781511508; cv=none; b=fSZUMcjDk571x3WZ2WU79EMp8f9DWbrrrCNXEPLELnZiTprmLwpaMygTsIVAfJiBRYyyd0qIq7xeUo5lnE0sNudc1vBySuvI2AQ7t+1eJjVCR+WvqWlmW1MoF6GJro3aNw3SOfaf6DMjTS7K764JOZbRxni5giWaheUxV37hp3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781511508; c=relaxed/simple;
	bh=m+k9sGvFRHtY2D7ixWN/lqiDm/t1J7HbkTavX3D0WNU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iXxdzeuVLMjAZrEBP/RFTd/sLVGzkkoJfolcT9FnFnNyQZgANcy/hv8xqN+5DZoVsOy8aJXeLgWHOqHGxUSysyB1tYONRsf+YHh5MGNIexG0mGUXV6THoJc8Lujneqh/yMae2pc8MkGNW0mjtV/9K7Q7MSrVMt6KPL54ANMXd2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KcgGcQn5; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=vH/LjLDz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KcgGcQn5";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="vH/LjLDz"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C581A75E30;
	Mon, 15 Jun 2026 08:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781511505; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m+k9sGvFRHtY2D7ixWN/lqiDm/t1J7HbkTavX3D0WNU=;
	b=KcgGcQn5oQM31MHoXX7i2FCDrL6ZiDcyi9ZXIne3dr5okAzdGx0M7nvKU3b81n1OD1EDGA
	FB/s/agW7xUGiWPwYA4R2vdab/9Bb7ghNOdT0dog+C9P+zV5TpuGwMMjudc++gEJwLSu1y
	p+RRjnhH342O3vguFCWKluSJ2ftc5Vo=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="vH/LjLDz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781511504; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m+k9sGvFRHtY2D7ixWN/lqiDm/t1J7HbkTavX3D0WNU=;
	b=vH/LjLDzYWLbJzwmvOeW25pxaWg45lyhdO4G7PXIVYb+FzXpsxCg5i5MfOkCvpZVQJNtUS
	I12ZcHS6Nb4ZbNJiJgiKtJfdsVztaSQ+0RNXkfJT0wb3zmx7vVBMa3qPwJD6fqvXCgB3mw
	TI/nCmOjHtfaK+BsFZXy5qR/+whD4eM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A5A86779A7;
	Mon, 15 Jun 2026 08:18:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QbxeJ1C1L2rtdQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 15 Jun 2026 08:18:24 +0000
Message-ID: <20b365e93e2f863ec3c9109925dc9322582f0862.camel@suse.com>
Subject: Re: [PATCH 2/5] multipath-tools: clarify path selector descriptions
 in multipath.conf.5
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Mon, 15 Jun 2026 10:18:24 +0200
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
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: C581A75E30
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

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

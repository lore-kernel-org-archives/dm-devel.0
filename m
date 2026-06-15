Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922473DA5C0
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 09:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781514947; cv=none; b=Kw7iAdDxLndGZI3XNpnX+33t0ndmnUNV7bxt8II3fbOpOrOaDQyC5sQiHe/tk9tu8IPN1eydMSILIFCHEBzRZ5EmAu/D4R9kql+Alx/fgYw9CSppRmc90Nu+5bhoxALvaSgHnq18YMj6t1SIaJ+XKV5oBiVR1hApRGPIZ0p98Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781514947; c=relaxed/simple;
	bh=Ua7pfzG1rTPXriIVjaWWrv0mUyeUxIThyP5KXFLdMAY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ujyXE3q7xcs+KIcK4xI4ifljOw/UR6+jCDYzU1lmiXu6MRxxqZP+a7CE7CHU0IG6g2yihdJLrra9esmoSqAdTWztp/sFCnj1GoBZVlAWRPg6FTZuaGS+J/61kVGBEE33RNWH65nIGzMAIG8MzBaqCmue64LuDCvggC0IdSQn39A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=CmhvU5DM; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=CmhvU5DM; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="CmhvU5DM";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="CmhvU5DM"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9F2BE75A12;
	Mon, 15 Jun 2026 09:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781514941; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ua7pfzG1rTPXriIVjaWWrv0mUyeUxIThyP5KXFLdMAY=;
	b=CmhvU5DMTqt0hMgfTh5epG1I+jRwW9CtmVedF7X6ldcbyYc2QUaUz5N3lvxAgdDqMKTA9l
	EE5MEhq0Uq6aMJme1cE2f1nfwOsj+7Htg4ZPTuxLrq6VqaCduWGDwganZZO2eotQ+Nm1Ak
	ujSCzvU9XXWPXQYtvi56SFeDdVgbdpA=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=CmhvU5DM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781514941; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ua7pfzG1rTPXriIVjaWWrv0mUyeUxIThyP5KXFLdMAY=;
	b=CmhvU5DMTqt0hMgfTh5epG1I+jRwW9CtmVedF7X6ldcbyYc2QUaUz5N3lvxAgdDqMKTA9l
	EE5MEhq0Uq6aMJme1cE2f1nfwOsj+7Htg4ZPTuxLrq6VqaCduWGDwganZZO2eotQ+Nm1Ak
	ujSCzvU9XXWPXQYtvi56SFeDdVgbdpA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7F7BE779A7;
	Mon, 15 Jun 2026 09:15:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qUEJHr3CL2qtMQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 15 Jun 2026 09:15:41 +0000
Message-ID: <43b7869e56668aff117cc376dea71855f73b70fa.camel@suse.com>
Subject: Re: [PATCH 2/5] multipath-tools: clarify path selector descriptions
 in multipath.conf.5
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Mon, 15 Jun 2026 11:15:41 +0200
In-Reply-To: <994b66b1-68fb-4dd6-90e4-8fcd6f894f62@gmail.com>
References: <20260613131002.144263-1-xose.vazquez@gmail.com>
	 <20260613131002.144263-3-xose.vazquez@gmail.com>
	 <7c28dd835abebb6f9e4ff69159e417cac323409f.camel@suse.com>
	 <994b66b1-68fb-4dd6-90e4-8fcd6f894f62@gmail.com>
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
X-Rspamd-Queue-Id: 9F2BE75A12
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
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Mon, 2026-06-15 at 10:26 +0200, Xose Vazquez Perez wrote:
> On 6/15/26 10:16 AM, Martin Wilck wrote:
>=20
> > On Sat, 2026-06-13 at 15:09 +0200, Xose Vazquez Perez wrote:
> > > Selectors operate on the next individual I/O request rather
> > > than a "bunch" of I/O.
> >=20
> > This patch doesn't apply cleanly to any of my branches (master,
> > queue,
> > tip).
> That quote is from the patch series I sent earlier. You might have
> missed it:
>=20
> Xose Vazquez Perez (3):
> =C2=A0=C2=A0 multipath-tools: delete obsolete information from multipath.=
conf.5
> =C2=A0=C2=A0 multipath-tools: remove explicit width from .TP macros in
> multipath.conf.5
> =C2=A0=C2=A0 multipath-tools: remove explicit widths from macros in the
> remaining man pages

I was about to apply this (5-part) series to the queue branch. But I do
have an issue with the other series, as I just wrote, so I'm postponing
this again. I would like to ask you to send a consolidated series. But
first I guess we need to reach consensus what to do with the rr_minio
patch.

Martin

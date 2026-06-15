Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9273090D5
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 17:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781543298; cv=none; b=HHHuaAasd2zdj8tP3Fcd3MLnYn7zx4Ey2UWQDoPP4qiQ9ds2yMAEq1sSacKE/ycr7UidXo9dI3hWSKYKTHuRODN6R5NAJioaRGVbS71S1NOnq8SKPildh307f4TyPNtCtLIr5EjkzIb5y6NTnHtZYWqacAtvwCFIm+iWBrkNk0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781543298; c=relaxed/simple;
	bh=qeC/J00JdcDzovS1SmtCpCHJY6y3wehrR6DRT34AjIk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YurQ5RpwG4JqCpQfqX851F1qnlUwSB1pfpAR+rIaGLngN9zSbfbj6LRE8+H4aM+KvdVF4XYAey6th9XJtFfCM36qYo2OhEKLvcNtnkfc+rZj2ZYSbZflMptVltQF0v15U06RKO3flEHj0lbBfn08CXkxZN9oN9KU/XyB3pUrZQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=uth0cWOV; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=rCwIimAm; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="uth0cWOV";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="rCwIimAm"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ED3E175A46;
	Mon, 15 Jun 2026 17:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781543295; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qeC/J00JdcDzovS1SmtCpCHJY6y3wehrR6DRT34AjIk=;
	b=uth0cWOVZQIixXzBx7n6bp6h978uB3ZGjN9zl+zUDQS7Eju5c9kWPhZAQ3/f6Vjy4I2R42
	Vi8by8c1mljQkJHGsXBUyURx9fl9Xri8MGhU6jIR1DTT20njMj3XLhqBebfRVIn01L0Xat
	hSsuS6O5O15U5FAreBt4e/c9igzmTSs=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=rCwIimAm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781543293; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qeC/J00JdcDzovS1SmtCpCHJY6y3wehrR6DRT34AjIk=;
	b=rCwIimAm4QJ+e/z39OcGKG7uEwCM0gXZdMddniMR1xGYy7mx0yejdCz84DsEnQmz36GcH+
	mpzPzQnyeRwxnLPNGarfYSCvF6n1CYodZnSKPKcwjBxyZEAl7OxhfSdfdfL0tg6znqTQk4
	V6iBsQDTKtDtCMVJEY54NrFqcFy5INM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CCC5D779A7;
	Mon, 15 Jun 2026 17:08:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QlbhMH0xMGoVDQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 15 Jun 2026 17:08:13 +0000
Message-ID: <726723c6be4eabfddc2499a6a555d066b35429ce.camel@suse.com>
Subject: Re: [PATCH 2/5] multipath-tools: clarify path selector descriptions
 in multipath.conf.5
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Mon, 15 Jun 2026 19:08:13 +0200
In-Reply-To: <8a34e0aa-d9ee-4f1b-bb02-7464b56566fc@gmail.com>
References: <20260613131002.144263-1-xose.vazquez@gmail.com>
	 <20260613131002.144263-3-xose.vazquez@gmail.com>
	 <7c28dd835abebb6f9e4ff69159e417cac323409f.camel@suse.com>
	 <994b66b1-68fb-4dd6-90e4-8fcd6f894f62@gmail.com>
	 <43b7869e56668aff117cc376dea71855f73b70fa.camel@suse.com>
	 <8a34e0aa-d9ee-4f1b-bb02-7464b56566fc@gmail.com>
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
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: ED3E175A46
X-Spam-Score: -3.01

On Mon, 2026-06-15 at 18:44 +0200, Xose Vazquez Perez wrote:
> On 6/15/26 11:15 AM, Martin Wilck wrote:
>=20
> > On Mon, 2026-06-15 at 10:26 +0200, Xose Vazquez Perez wrote:
> > > On 6/15/26 10:16 AM, Martin Wilck wrote:
> > >=20
> > > > On Sat, 2026-06-13 at 15:09 +0200, Xose Vazquez Perez wrote:
> > > > > Selectors operate on the next individual I/O request rather
> > > > > than a "bunch" of I/O.
> > > >=20
> > > > This patch doesn't apply cleanly to any of my branches (master,
> > > > queue,
> > > > tip).
> > > That quote is from the patch series I sent earlier. You might
> > > have
> > > missed it:
> > >=20
> > > Xose Vazquez Perez (3):
> > > =C2=A0=C2=A0=C2=A0 multipath-tools: delete obsolete information from
> > > multipath.conf.5
> > > =C2=A0=C2=A0=C2=A0 multipath-tools: remove explicit width from .TP ma=
cros in
> > > multipath.conf.5
> > > =C2=A0=C2=A0=C2=A0 multipath-tools: remove explicit widths from macro=
s in the
> > > remaining man pages
> >=20
> > I was about to apply this (5-part) series to the queue branch. But
> > I do
> > have an issue with the other series, as I just wrote, so I'm
> > postponing
> > this again. I would like to ask you to send a consolidated series.
> > But
> > first I guess we need to reach consensus what to do with the
> > rr_minio
> > patch.
> With git 2.54.0 and a clean environment (no ~/.gitconfig), all
> parches
> apply cleanly on my end over the queue branch:

It didn't for me this morning, but I can handle that. But I'd
appreciate a clean, complete series with all the man page fixes.

Please see Ben's latest reply. He is working on a patch that keeps
rr_min_io, and removes rr_min_io_rq and rr_weight. The man page should
reflect this correctly.

Regards
Martin

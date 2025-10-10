Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F53F54654
	for <dm-devel@lists.linux.dev>; Fri, 10 Oct 2025 11:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760095205; cv=none; b=pJwO5oX+L5/VoHXsyOXzKYXo2N6gxU7Ed+ivG4qgyc+0BqHj3fscyeuVV1Nw43fcEa1Pv2zfrCfM1hYCqMU9JicIU6gaYx9suGZmR6dXGBUNEzUcBlPpCGuaLqkDDrIQI7+rIuTM/E3Ur9onGA6BN7p9K39ZsY2yDylf2kUkrNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760095205; c=relaxed/simple;
	bh=73C9m8KCTRM8DtSgruvVqUSBJxWX3WQ+4fnih3slV9E=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=L3zoyGYSPQZyaWlNvV92VWcub/Hmg7X9FFWTakPR0oRMOsTql7mta0Oq6Hv2+XjuaxaPoPIrFskJAiSEwywslWMQwBsJyZLQvCIFpW/JsiRyh+1m+UclFdAtNMdrgLhvuA842bomykFH2Q7yy2ima5AJqwzVdublC8ybk5uCSgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gD32aUij; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gD32aUij; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gD32aUij";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gD32aUij"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 943AB1F822;
	Fri, 10 Oct 2025 11:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1760095201; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=73C9m8KCTRM8DtSgruvVqUSBJxWX3WQ+4fnih3slV9E=;
	b=gD32aUijS+abeYiQmlPssNQPvgZMBslLg6k2V4b+CVSowkbBfSvBDOg2OCSAVaMTqGDSYy
	PSxJkskdpQ4yAQ8kFr1eaLriJ9HVHixaiFTruZpL/3q5DSKr0LfVgoVTzrI0NcnHxFa8CR
	AIDtw8MhefBxprR717TkjnX1D9NAG5I=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=gD32aUij
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1760095201; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=73C9m8KCTRM8DtSgruvVqUSBJxWX3WQ+4fnih3slV9E=;
	b=gD32aUijS+abeYiQmlPssNQPvgZMBslLg6k2V4b+CVSowkbBfSvBDOg2OCSAVaMTqGDSYy
	PSxJkskdpQ4yAQ8kFr1eaLriJ9HVHixaiFTruZpL/3q5DSKr0LfVgoVTzrI0NcnHxFa8CR
	AIDtw8MhefBxprR717TkjnX1D9NAG5I=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7440B1375D;
	Fri, 10 Oct 2025 11:20:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EBg7G+Hr6GixXwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 10 Oct 2025 11:20:01 +0000
Message-ID: <0580f369a7102ae07aaa2c23fd4bd9165cbafd35.camel@suse.com>
Subject: Re: [PATCH 1/2] multipath-tools: fix mandoc errors in man pages
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Fri, 10 Oct 2025 13:20:00 +0200
In-Reply-To: <20251010092211.57426-1-xose.vazquez@gmail.com>
References: <20251010092211.57426-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 943AB1F822
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FREEMAIL_TO(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

On Fri, 2025-10-10 at 11:22 +0200, Xose Vazquez Perez wrote:
> Output of: mandoc -W all -T lint man_page.X | grep -v "STYLE: input
> text line longer than 80 bytes"
>=20
> mandoc: ./libmpathpersist/mpath_persistent_reserve_in.3:26:2:
> WARNING: skipping paragraph macro: PP empty
>=20
> mandoc: ./libmpathpersist/mpath_persistent_reserve_out.3:26:2:
> WARNING: skipping paragraph macro: PP empty
>=20
> mandoc: ./mpathpersist/mpathpersist.8.in:176:2: WARNING: skipping
> paragraph macro: PP after SH
> mandoc: ./mpathpersist/mpathpersist.8.in:219:2: WARNING: skipping
> paragraph macro: PP after SH
>=20
> mandoc: ./multipath/multipath.conf.5.in:93:2: WARNING: skipping
> paragraph macro: PP empty
> mandoc: ./multipath/multipath.conf.5.in:134:2: ERROR: skipping end of
> block that is not open: RE
> mandoc: ./multipath/multipath.conf.5.in:134:2: WARNING: skipping
> paragraph macro: br at the end of SH
> mandoc: ./multipath/multipath.conf.5.in:135:2: WARNING: skipping
> paragraph macro: PP empty
> mandoc: ./multipath/multipath.conf.5.in:1311:2: ERROR: skipping end
> of block that is not open: RE
> mandoc: ./multipath/multipath.conf.5.in:1610:2: WARNING: skipping
> paragraph macro: PP empty
> mandoc: ./multipath/multipath.conf.5.in:1807:2: WARNING: skipping
> paragraph macro: PP empty
> mandoc: ./multipath/multipath.conf.5.in:2020:2: ERROR: skipping end
> of block that is not open: RE
>=20
> mandoc: ./multipathd/multipathc.8:23:15: STYLE: whitespace at end of
> input line
>=20
> mandoc: ./multipathd/multipathd.8.in:571:2: WARNING: skipping
> paragraph macro: PP empty
> mandoc: ./multipathd/multipathd.8.in:691:2: ERROR: skipping end of
> block that is not open: RE
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Are these just warnings, or does mandoc render our pages incorrectly or
in a way that they aren't properly readable?

I confess that I haven't had a closer look at mandoc so far, which
appears to be mostly a BSD thing. Are there any Linux distributions
that have switched from man/groff to mandoc? I found [1], from which I
gather that mandoc mostly support he mdoc format, which is not what our
man pages are written in (ours are plain man): "... and only documents
authored with mdoc are guaranteed to render consistently and correctly
on BSD-derived platforms".

I tend to think that man/groff defines the standard that we adhere to.
AFAICS groff does not spit out any warnings except for some long lines
("cannot adjust line"). Have you double-checked that the WARNINGS and
ERRORs above are actually caused by errors in our pages (in the sense
that our pages don't conform with the man document format)? If yes, I
wonder why groff doesn't complain about them.

Anyway, while I believe keeping the man pages in good shape is
important, we should agree on a single tool to do the syntax checking,
and that tool should probably be groff.

I believe our man pages have more serious issues; for example, we use
so deep indentation in multipath.conf.5 that the page is hardly
readable on narrow terminals.

Martin

[1] https://unix.stackexchange.com/questions/391399/what-is-the-difference-=
between-the-mdoc-macro-set-for-troff-and-the-plain-man-ma

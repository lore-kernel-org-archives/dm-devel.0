Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEDF3242BD
	for <dm-devel@lists.linux.dev>; Fri,  5 Dec 2025 09:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764927067; cv=none; b=tKgbvkdwO1nCwOBA8nkB60nMyXVoxE2bQOqpwULyf1T0YMbFL+xaezqM0cxaiFuG63AK9X40zcxZgMZ94Y9+Qi2soEwr8jgIXny8rIzZoNXZkxfrIBy3fpcBK3Ib3V+cpNLhsLJMkRFbrnMxw7CLrG7QHLtvv64juS0FjNY8zeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764927067; c=relaxed/simple;
	bh=35Dop07KO1/5eiDd7xnZaRrtsydii9l/CNpS9LvIx4k=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eEa0i/5/sh/RmKROvvFQwQ64egmvySzM98XUXXIk8C2HnQ51GQm6vqjvwR2e8/mUR+7JFAtyRhMUOIqUh5ZfNwOPIIEJkZr6NcAn87mw3VhXavkgHnVNUY05qSLwEz+sZh9ZIbb+NQtkOdey+0zQYOR6repcTNCF77UbMMupYZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=FCpnp1mW; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=FCpnp1mW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FCpnp1mW";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FCpnp1mW"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 78979336D3;
	Fri,  5 Dec 2025 09:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764927051; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=35Dop07KO1/5eiDd7xnZaRrtsydii9l/CNpS9LvIx4k=;
	b=FCpnp1mW4J+IABlzfziiIRdkzvTarXCptZ94QI8H/ad3EqSoWvV9Y7rrCP0DRePgLMMJxG
	gKgkGwr45Px+y6rmvpP6OwvPJ7c17scQbSbb39r5XiswgROt6oPxs/scyoKxdWpzO7b90O
	yiggSuMe5/irQbMQteQmZXJgyMeVcG4=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=FCpnp1mW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764927051; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=35Dop07KO1/5eiDd7xnZaRrtsydii9l/CNpS9LvIx4k=;
	b=FCpnp1mW4J+IABlzfziiIRdkzvTarXCptZ94QI8H/ad3EqSoWvV9Y7rrCP0DRePgLMMJxG
	gKgkGwr45Px+y6rmvpP6OwvPJ7c17scQbSbb39r5XiswgROt6oPxs/scyoKxdWpzO7b90O
	yiggSuMe5/irQbMQteQmZXJgyMeVcG4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 565373EA63;
	Fri,  5 Dec 2025 09:30:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tTkAFEumMml9cgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 05 Dec 2025 09:30:51 +0000
Message-ID: <e8845dc35f86316f72a07b7c35b5b05c3eb33c54.camel@suse.com>
Subject: Re: [PATCH v2] multipathd: Dont pthread_join twice
From: Martin Wilck <mwilck@suse.com>
To: Itxaka <itxakaserrano@gmail.com>, dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com, Itxaka <itxaka@kairos.io>
Date: Fri, 05 Dec 2025 10:30:50 +0100
In-Reply-To: <20251205082806.3649593-1-itxaka@kairos.io>
References: <20251205082806.3649593-1-itxaka@kairos.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 78979336D3
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_TO(0.00)[gmail.com,lists.linux.dev];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

On Fri, 2025-12-05 at 09:28 +0100, Itxaka wrote:
> Currently it seems that urcu would already call pthread_join when
> calling call_rcu_data_free since a couple of years ago (since version
> v0.14.0)[0] so calling pthread_join on the just released one is
> problematic under musl systems. It seems like under glibc this has
> several checks in place before trying to dereference the thread but
> under musl it has nothing in place to validate so this causes a
> coredump
> on program shutdown.
>=20
> This is currently present in all version when compiled under musl,
> running multipathd -d and sending a SIGTERM to it, you can see the
> coredump happening at this point in the code.
>=20
> The patch runs only the old behaviour in urcu older than 0.14.0 to
> maintain the same bahaviour. In higher versions its not neccesary so
> we
> skip it.
>=20
> [0]
> https://github.com/urcu/userspace-rcu/commit/1cf55ba47342156cdf25335264b9=
774a16e0bb2d
>=20
> Signed-off-by: Itxaka <itxaka@kairos.io>

Reviewed-by: Martin Wilck <mwilck@suse.com>

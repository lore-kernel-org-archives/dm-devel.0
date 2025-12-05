Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00224625
	for <dm-devel@lists.linux.dev>; Fri,  5 Dec 2025 00:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764893034; cv=none; b=r5TytPzhBj0ZJZz+HFGG06ENtzFUM3LTLGN7m1YFHEPUAs5BK+M3dyTaP6cVVDSVoKQnJeifGFITanA2X2PuVv78b8ynIHtatFq/lAtOYbu/AGJCfW5Oix7hDTXl7e4Vtec8zidJDHC2nQLsZ3/flc7Nj3+tJrY/DuE0ttMe0js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764893034; c=relaxed/simple;
	bh=Zkdxa3DWeIY007Bh0K6ciyMBKOQf0h1nlnpbc98TiJ4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q/aWzg4h4AuNmE8KYyUvwVg8NA6tj9SDOiGMqEPLQJwxs866WMy5dPI1GyvuMQvTvUU0/ukaV1v9krrsudmkGNMY4lQ4+C2+nnK7m+kvWWopF6Qw2NjDEHt5R2izecnthgM/tZZ2EVnXUw+AWavcMUYfaUxhdC1S1G6zRplup2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=IRe56zxg; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=QYGUJrvz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="IRe56zxg";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QYGUJrvz"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9DF2033693;
	Fri,  5 Dec 2025 00:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764893029; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zkdxa3DWeIY007Bh0K6ciyMBKOQf0h1nlnpbc98TiJ4=;
	b=IRe56zxgCMN5ZuFQ7mYgJJOi6FAxwuQjtymljMPkR64Ozr+obagpcFAfGGHfq8BjXc9YtJ
	JdkSTUpoZ64+8XNuEHTWk5TxGUpm8akUhIALJso0DbD1uEael4F3Rj23nY0u4HD6e0xzJb
	IQX7zJEGw7dbbUqEVLRKLDFf8qed444=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=QYGUJrvz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764893028; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zkdxa3DWeIY007Bh0K6ciyMBKOQf0h1nlnpbc98TiJ4=;
	b=QYGUJrvzXkof9E9EQeO3dNv510QVcBO23MsW7qt0iafCygXpUcewpWuoED5ZrfpckN9F8w
	w0E/Puxl4J4Duc9+byMdoWcKdnLkOJBvUuQl1YDNZSp78WhBGS58ubgdHcDSQs3YayxQrP
	uSgpe+b7KdUDhFlvP2Dbkn+ChgEr15g=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 797193EA63;
	Fri,  5 Dec 2025 00:03:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id y3eGHGQhMmnAdgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 05 Dec 2025 00:03:48 +0000
Message-ID: <1bd6b84b0391dad35ed1c56eee3f6ac04ea98a61.camel@suse.com>
Subject: Re: [PATCH multipathd] Dont pthread_join twice
From: Martin Wilck <mwilck@suse.com>
To: Itxaka <itxakaserrano@gmail.com>, dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com, Itxaka <itxaka@kairos.io>
Date: Fri, 05 Dec 2025 01:03:47 +0100
In-Reply-To: <20251204213147.3625104-1-itxaka@kairos.io>
References: <20251204213147.3625104-1-itxaka@kairos.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_TO(0.00)[gmail.com,lists.linux.dev];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Queue-Id: 9DF2033693
X-Spam-Flag: NO
X-Spam-Score: -4.51

On Thu, 2025-12-04 at 22:31 +0100, Itxaka wrote:
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
> The patch just removes this uneeded extra call
>=20
> [0]
> https://github.com/urcu/userspace-rcu/commit/1cf55ba47342156cdf25335264b9=
774a16e0bb2d
>=20

Thanks! This looks ok to me.

But this change you linked has been introduced in urcu 0.14.0, so we'll
need a patch that depends on the urcu version.

Martin

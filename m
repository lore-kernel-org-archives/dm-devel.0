Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71E01E9B08
	for <dm-devel@lists.linux.dev>; Wed, 30 Apr 2025 07:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745998672; cv=none; b=t0Auh9PrwYzKiHg/yUTTjG+VhsrLyZCtqSFmMp+8zal9HdtPskpTAZnDupFWZNJK6Z4w32u1Cqb7yj/m2QSmqRd0Fsc2txzp4Fqd1QuO62U+g7qH5OPEQ+Yk6Bm89L1oRYvrEwjsocNLSnP1ZJC2akut0PBCAg/NNNU29pU/obo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745998672; c=relaxed/simple;
	bh=w72roDlRb+jQTHBtUXH8ij6jS1O8e4Uqypjl4SFtvtY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=F2mpdWvP4Qwwv0ftiwVcw1/uBSzj12CMoxOf/NfycMuZo1gv318AUxpVzYDqOOzHcLQH0tb/xRMC9uXOy8RnMZrnWN6dRHW/IPCTfI5HlskIo/gaKvIBK7h/ZRNq2gVl55Fspe/RMv9KJ7oaixhLg8OpUH6KeWUPEehVjbqJCYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=msduThHT; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=msduThHT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="msduThHT";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="msduThHT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B9B8D21274;
	Wed, 30 Apr 2025 07:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1745998667; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w72roDlRb+jQTHBtUXH8ij6jS1O8e4Uqypjl4SFtvtY=;
	b=msduThHTXuBTrJ6MyUjGjqYR9pxdlzDqZkmLd3P19gDA2stDCrayAp12Jj8BK0CuShMCwz
	hDnubnmYfo05M+nbTyxHgi+5ttg9JmFyfke7fKnrXEds2JZrTtHc30LuJvcE3eO+7PglMS
	aSke9QP0FNaxkkpQ0H7i7W3g2ZPRwoU=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1745998667; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w72roDlRb+jQTHBtUXH8ij6jS1O8e4Uqypjl4SFtvtY=;
	b=msduThHTXuBTrJ6MyUjGjqYR9pxdlzDqZkmLd3P19gDA2stDCrayAp12Jj8BK0CuShMCwz
	hDnubnmYfo05M+nbTyxHgi+5ttg9JmFyfke7fKnrXEds2JZrTtHc30LuJvcE3eO+7PglMS
	aSke9QP0FNaxkkpQ0H7i7W3g2ZPRwoU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8E268139E7;
	Wed, 30 Apr 2025 07:37:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iAwRIUvTEWgcfwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 30 Apr 2025 07:37:47 +0000
Message-ID: <9cd5d0846fdd9707b1fc84e574608383b11b84e2.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: replace dead url
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Wed, 30 Apr 2025 09:37:46 +0200
In-Reply-To: <20250427091237.218458-1-xose.vazquez@gmail.com>
References: <20250427091237.218458-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -2.80
X-Spam-Flag: NO

On Sun, 2025-04-27 at 11:12 +0200, Xose Vazquez Perez wrote:
> Original url at Wayback Machine:
> https://web.archive.org/web/20230820174630/https://listman.redhat.com/arc=
hives/dm-devel/2017-September/msg00326.html
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> Should this code be replaced with DETECT_CHECKER_OFF in hwtable ???

No, let's just keep it as is. The check_rdac() code uses a vendor-
specific VPD page to check for RDAC features, which is not the same as
hard-coded values in the hwtable based on vendor and product.

I'd rather not risk regressions for a minor code simplification.

Regards
Martin

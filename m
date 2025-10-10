Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB58B238171
	for <dm-devel@lists.linux.dev>; Fri, 10 Oct 2025 09:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760088225; cv=none; b=Kw43bebGTU+npcyM8BYnVIlXwNNMJEFlZVN+Ve6VKzbNk5f7wxNterP+lwTtK5Z1Hm3SQO7FKs0pFoqUpLCNPaLlQsqyfib967wseCKO3lEc9P/R6jVgfa6gVRYDPF4MT/mpWolFuk8eevmQ6m8pBcSjKj/bALT4NPAj+Z4k0TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760088225; c=relaxed/simple;
	bh=80cSl6WLnIDgmk7nk97BKMcUP5a5qgH1Osl1UeO1R/M=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=urncETcZtOimM1xGMu10s3HaKUSePJqlYwRLyWTJNKRVWE4D0JQ4FBOH/xJAlDsE0eg3fPLKHEy23OgssgDfysfWXPESK+nR2O1D3TglhHNUHd3QZGb6d3KrBF98MvblonmQQxq43O1XifIaaiLTpiMbePIYOgmkcxypUJvJuZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RwDuDczQ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZCWlJM0T; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RwDuDczQ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZCWlJM0T"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EE85F1F393;
	Fri, 10 Oct 2025 09:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1760088222; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5SIAekBBOYUo+5eRdztJ2ECo0oWKXtIh6DdmvZq7JLY=;
	b=RwDuDczQtlplijL8LIHQNNL7Wn8uh5fUiriHObPIbw9XXVJAIK++UG14l+jyPRdcYWgyGw
	R2twdIZ6yKQ9Vrwo3Bb4B1HJjELv3JFop0/rWomWVcj5x9e4WSscXlBpFo1HNy6jkGiOqA
	BkEni9zteHXa5JOpsorwGFpCWeOi/0k=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1760088221; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5SIAekBBOYUo+5eRdztJ2ECo0oWKXtIh6DdmvZq7JLY=;
	b=ZCWlJM0TB1U3iZgKkrVKnw7egJUiPgJfZgX3ga1JmT12qOr1z/n7/EIlSWVdcKuDnweGLQ
	JZ964ZNoAZF+eKlB5pV51X7pKcJQpDVEq5b6uqmBgD1CJMpW1+9a1N9LEJuh2usBlFHY4K
	wiM3rtJR2GSvQyYLG9RGEMKk1LVwTCg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C46401375D;
	Fri, 10 Oct 2025 09:23:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id il/JLp3Q6GjCbQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 10 Oct 2025 09:23:41 +0000
Message-ID: <515e1af3312710d17fa5f4a3ab11ff4b7a244eaa.camel@suse.com>
Subject: Re: [PATCH] dm: Fix deadlock when reloading a multipath table
From: Martin Wilck <mwilck@suse.com>
To: Bart Van Assche <bvanassche@acm.org>, Benjamin Marzinski
	 <bmarzins@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer
	 <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org
Date: Fri, 10 Oct 2025 11:23:41 +0200
In-Reply-To: <033ca444-4c68-4a4f-bc2b-32232e80e848@acm.org>
References: <20251009030431.2895495-1-bmarzins@redhat.com>
	 <ed792d72a1ca47937631af6e12098d9a20626bcf.camel@suse.com>
	 <033ca444-4c68-4a4f-bc2b-32232e80e848@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30

Hi Bart,

On Thu, 2025-10-09 at 16:29 -0700, Bart Van Assche wrote:
> On 10/9/25 2:57 AM, Martin Wilck wrote:
> > In general, I'm wondering whether we need a more generic solution
> > to
> > this problem. Therefore I've added linux-block to cc.
> >=20
> > The way I see it, if a device has queued IO without any means to
> > perform the IO, it can't be frozen. We'd either need to fail all
> > queued
> > IO in this case, or refuse attempts to freeze the queue.
>=20
> If a device has queued I/O and the I/O can't make progress then it
> isn't
> necessary to call blk_mq_freeze_queue(), isn't it?=C2=A0

Good point. Even if the queue limits were changed while the IO was in
the queue,  they'd be re-checked in blk_insert_cloned_request(). That
might cause IO failures, but if you modify queue limits while IO is in
flight, that's part of the risk, I suppose.

> See also "[PATCH 0/3]=20
> Fix a deadlock related to modifying queue attributes"
> (
> https://lore.kernel.org/linux-block/20250702182430.3764163-1-bvanassche@a=
cm.org
> /).
>=20
> BTW, that patch series is not upstream. I apply it manually every
> time
> before I run blktests.

Will you make another attempt to get it merged?

Martin

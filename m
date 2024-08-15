Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8102AF12
	for <dm-devel@lists.linux.dev>; Thu, 15 Aug 2024 16:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723738906; cv=none; b=Pj7NDTaZtBTIvDUqqguOM49GoLWqpyQ0UcqxQrJop1Wdh9/i8eY5p9JGfHXK0yRVYDpmhWzxCNShXDclY8Lc//ZpJFGWnNU5abab3kb/HMk0gqFU/nsX79hgmbyYBbHYnofbuFIHhHc5MHE+89mtQfsL1t0mlpu3NVfhWrcYeG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723738906; c=relaxed/simple;
	bh=9etfun8c8JgzSSXJJ/y2KCCwsMJZGhYNfuzdrDKaFbk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q/I+uj6pQ3Jmubsa3oFOeF3TMNSSEAXTwbVsaQZGGfd/Xq7Ch8w8WM32YImDvdzKSgh/uRsbZELLLkpDzLMrSxr3wGsyJgonMgK7/jv2tmfi4yp0G9ofg328hRHjaLmSIeG29x4vrv1ZCvpbFK3bE5oAWU4qBRHpsidJ3zudcW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hULaVexb; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hULaVexb; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hULaVexb";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hULaVexb"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 65E8720039;
	Thu, 15 Aug 2024 16:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1723738902; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9etfun8c8JgzSSXJJ/y2KCCwsMJZGhYNfuzdrDKaFbk=;
	b=hULaVexbnc5gQcu5I2n5ZRmcTY6JzjUvwPbWVqhcCU+XFJ16p4z5ac1HI16b258JsNKh3m
	kUxi0W30dlbznRZZrMm1RAxWiXDoPqCgu5W9kgtGXxm7CeyO2yzUsSkzuOhG+mof3X8m6S
	JJT0i8dJeRTsVdJxtsJ2i6rjf++HMaI=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=hULaVexb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1723738902; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9etfun8c8JgzSSXJJ/y2KCCwsMJZGhYNfuzdrDKaFbk=;
	b=hULaVexbnc5gQcu5I2n5ZRmcTY6JzjUvwPbWVqhcCU+XFJ16p4z5ac1HI16b258JsNKh3m
	kUxi0W30dlbznRZZrMm1RAxWiXDoPqCgu5W9kgtGXxm7CeyO2yzUsSkzuOhG+mof3X8m6S
	JJT0i8dJeRTsVdJxtsJ2i6rjf++HMaI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 373441342D;
	Thu, 15 Aug 2024 16:21:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fMaLCxYrvmZ1HgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 15 Aug 2024 16:21:42 +0000
Message-ID: <a16027a4fb29aaf0f86c043d6644f31926543de2.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: update info about path_grouping_policy
 in the man page
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Thu, 15 Aug 2024 18:21:41 +0200
In-Reply-To: <20240815152358.233091-1-xose.vazquez@gmail.com>
References: <20240815152358.233091-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.81 / 50.00];
	BAYES_HAM(-2.80)[99.15%];
	DWL_DNSWL_MED(-2.00)[suse.com:dkim];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,suse.com:email,linux.dev:email]
X-Rspamd-Queue-Id: 65E8720039
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spam-Score: -4.81

On Thu, 2024-08-15 at 17:23 +0200, Xose Vazquez Perez wrote:
> It's hardware dependent.
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


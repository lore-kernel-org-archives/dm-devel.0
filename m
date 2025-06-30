Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846E228F531
	for <dm-devel@lists.linux.dev>; Mon, 30 Jun 2025 15:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751297690; cv=none; b=ps6+2EcUTyVT1EADj5neXNNk1xcaVKnP4l68qHoGPw3eOjJTSm2UuJ73IQk6ai2qtPYgK3qs3sClUNJTe2HPqi3FDCpQcNCMNDIPmzgHC5nhSzkexP/2O2i2PVj4eC24EOGOnlhl+pql4iW/34C0DAhG7XeqiYhK8WY0whcRByY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751297690; c=relaxed/simple;
	bh=MW1Gne1Zwi8y4oD60txAi7ElrC6nlqtAiai4A8jL9PM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jduLpYmJOXiR9KFaI11IkMgR+UTob2MYnfQeO/zhjiOSwomApd92n/+OOz9qX6vCxe6DJNorhw06esq351h4EDt1lDbI701TXl1vjD4BERJYofrhlvS69AMy2cSOLb/5lXgpKVCog7UFD2otnGWUE6hopWMs16lywGH9EeN0HyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=QB3Edjnc; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=QB3Edjnc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QB3Edjnc";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QB3Edjnc"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 740581F444;
	Mon, 30 Jun 2025 15:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1751297686; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MW1Gne1Zwi8y4oD60txAi7ElrC6nlqtAiai4A8jL9PM=;
	b=QB3EdjncRe/xML1KP4+BlMHUB6b63kFJJsnLdk6jeDMPHt9BQ76ShqoozBHO8Leu9KBrMr
	qZRm2Azm6UMFvMtQVavqGMzBLeOjX/OUL5Mwb6+T0Ml/7mhbYc/hQBZFQidwZGPzz4bSS6
	uZ8ARR9r75I+r8HgRI12I72RUeerb3U=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=QB3Edjnc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1751297686; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MW1Gne1Zwi8y4oD60txAi7ElrC6nlqtAiai4A8jL9PM=;
	b=QB3EdjncRe/xML1KP4+BlMHUB6b63kFJJsnLdk6jeDMPHt9BQ76ShqoozBHO8Leu9KBrMr
	qZRm2Azm6UMFvMtQVavqGMzBLeOjX/OUL5Mwb6+T0Ml/7mhbYc/hQBZFQidwZGPzz4bSS6
	uZ8ARR9r75I+r8HgRI12I72RUeerb3U=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4435213983;
	Mon, 30 Jun 2025 15:34:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sLc6D5auYmiECAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 30 Jun 2025 15:34:46 +0000
Message-ID: <f117058d6b87c00ac0c37e83ca1a977a582e903f.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: replace FSF licences boilerplate with
 a SPDX-License-Identifier
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>, Benjamin Marzinski
 <bmarzins@redhat.com>,  Christophe Varoqui
 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Mon, 30 Jun 2025 17:34:45 +0200
In-Reply-To: <20250624125506.7708-1-xose.vazquez@gmail.com>
References: <20250624125506.7708-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email]
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 740581F444
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: -3.01

On Tue, 2025-06-24 at 14:55 +0200, Xose Vazquez Perez wrote:
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

Thanks!

> ---
> Missing:
>=20
> util.c: maybe GPL-2.0-or-later ???
> libmpathutil/util.c: * License: LGPL-2.1-or-later
> libmpathutil/util.c: * Code copied from busybox (GPLv2 or later)
>=20
> ambiguous, only "GPL" !!!
> libmultipath/prioritizers/alua.c: * This file is released under the
> GPL.
> libmultipath/prioritizers/alua_rtpg.c: * This file is released under
> the GPL.
> libmultipath/prioritizers/alua_rtpg.h: * This file is released under
> the GPL.
> libmultipath/prioritizers/alua_spc3.h: * This file is released under
> the GPL.
> libmultipath/prioritizers/hds.c: * This file is released under the
> GPL.
> libmultipath/prioritizers/weightedpath.c: *=C2=A0 This file is released
> under the GPL

Please check my previous assessment again [1]:

IMO "GPL" without version should be interpreted as "any version of the
GPL". As these parts of the code are combined with other code that's
licensed under GPL-2.0-only or GPL-2.0-or-later, we should assume that
the respective stricter variant applies to the combination(s).

The "default" license of the multipath-tools project is assumed to be
the license of the first files that were added to Greg KH's udev.git
repo [2], which was LGPL 2.0. We're assuming that files that don't
include an explicit license statement inherit the LGPL-2.0 license from
this first commit in the project.

As you noted, libmpathutil/util.c includes code snippets that
were originally released with different licenses (albeit compatible
ones). We should thus assume that the file itself is under the
strictest of these licenses, which is GPL-2.0-or-later, AFAICS.

However, while I think these interpretations are plausible, I Am Not A
Layer and I wouldn't want to add license headers to files that
currently don't have one. I appreciate that your patch doesn't attempt
to do that.

Regards,
Martin

[1] https://lore.kernel.org/dm-devel/1523313462.3525.65.camel@suse.com/
[2] https://git.kernel.org/pub/scm/linux/hotplug/udev.git/commit/?id=3D04a0=
91d47e32d6480b99424e41db093b013dfaf5

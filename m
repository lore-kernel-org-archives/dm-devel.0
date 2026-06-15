Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C73B145B3F
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 07:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781509485; cv=none; b=T47OHooOKBnHD+50HV77b00KrXbLyk30djyD+yLdlEzZAwxDIhXAfrNOg2PNjRyZpGPTIZlPwNABnwa9Rz7Tt6QkZ42GZfBqroxCgfF3zzE4LZzyii7SrksMk5CZJy+UR9dK67in6v+SkfEw0M04PM7kLFrlZleA6IFMIZQtgaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781509485; c=relaxed/simple;
	bh=edE4JfFhPDq90C75l+9esTpO7KNEuH+6alaEGg2LaJY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BUXMguAazpbXtWc09iZGyLMcsClsg6ZSdPQkaCa27hXvk/g1LsTdWncKNdDeNk8XLZIn4YVXd0XTNaA5OiKptnK07JUh+CX6N/fo2GPyq+s9nt8JDniV5HlWEXYqo06yGslErlgNCmfu42bfJSCfxltFlGl5TibPcBeBHCEOKKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=CC6Mh7WK; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=CC6Mh7WK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="CC6Mh7WK";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="CC6Mh7WK"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B862A6BE24;
	Mon, 15 Jun 2026 07:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781509482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=edE4JfFhPDq90C75l+9esTpO7KNEuH+6alaEGg2LaJY=;
	b=CC6Mh7WKWi+o2KOdaGqD1cNidU4KEUsiJfiHp6jsn9Sve1Hg47d4qTkIVmGoGxEknSDGrY
	SL/1HSN9+35ZSmSJZlopI/354glVuSEZTCw0h5kArSyD0aFynYjkggeV/ZaihoJ8Ab5bn3
	NJwzfb6jva00j36qY+5yoDmW9p15dd8=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=CC6Mh7WK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781509482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=edE4JfFhPDq90C75l+9esTpO7KNEuH+6alaEGg2LaJY=;
	b=CC6Mh7WKWi+o2KOdaGqD1cNidU4KEUsiJfiHp6jsn9Sve1Hg47d4qTkIVmGoGxEknSDGrY
	SL/1HSN9+35ZSmSJZlopI/354glVuSEZTCw0h5kArSyD0aFynYjkggeV/ZaihoJ8Ab5bn3
	NJwzfb6jva00j36qY+5yoDmW9p15dd8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 993C0779A9;
	Mon, 15 Jun 2026 07:44:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id j4EyJGqtL2qsVAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 15 Jun 2026 07:44:42 +0000
Message-ID: <5095a0f03c46aa23e74d9339e7952b95df20a166.camel@suse.com>
Subject: Re: [PATCH 1/2] multipath-tools: fix mandoc errors in man pages
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Mon, 15 Jun 2026 09:44:42 +0200
In-Reply-To: <3219982c-58f9-4b04-b5a5-774ac61382ef@gmail.com>
References: <20251010092211.57426-1-xose.vazquez@gmail.com>
	 <0580f369a7102ae07aaa2c23fd4bd9165cbafd35.camel@suse.com>
	 <3219982c-58f9-4b04-b5a5-774ac61382ef@gmail.com>
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
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.com:dkim];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: B862A6BE24
X-Spam-Score: -3.01

On Sat, 2026-06-13 at 14:04 +0200, Xose Vazquez Perez wrote:
>=20
> groff/man focus on rendering text, not auditing code. They are
> permissive
> by design and handle invalid syntax more gracefully.
>=20
> mandoc focuses on structure. It parses the code into an Abstract
> Syntax
> Tree (AST) rather than just drawing text characters. That is why it
> is
> stricter than groff/man.
>=20
> I will address this and send the updates in a new patch series.

Great, thanks. I was looking forward to a v2 for your last set [1]
anyway, that's why I haven't responded yet.

Regards
Martin

[1] https://lore.kernel.org/dm-devel/20260607103831.336833-2-xose.vazquez@g=
mail.com/

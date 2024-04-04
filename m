Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5666F127B7E
	for <dm-devel@lists.linux.dev>; Thu,  4 Apr 2024 13:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712238353; cv=none; b=pxWWUQF+84tWdHGPz9DoTs9McS3MqkZqoE3z1d/LN172tSkXt/bES4VliSnswQnKt0uNoqwCLpNMBI3GJqmga2xS+aVrYbi0WSYTV9r8P9FkDMcLUPZHDbN9TQmDdoZF5g4BD0uU4ly4K/E543pnFhiUlu5yi0+/L0PnT/XfytU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712238353; c=relaxed/simple;
	bh=Nb1xGFU4z4S4a5lkQWJ6MnQgiNnOSeZGRrVZ6nOqzAE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sBXlHQY9kssR6KKl4M7pWkr7gxnTLWVEWYSh8/NWOBrKQRDSnA5Bdmfq3XbvBwSrmBnKx12zUyyIxRrhhZkHlHWoftj8ZESR/ZHtuik4I69jcAPCvps+QYskmPw/zoCykKbbh6OTVdhzFfIP1Pd/JwccUZD5coEbKasZ258pUUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KJ5kMtif; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KJ5kMtif; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KJ5kMtif";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KJ5kMtif"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5E88D5D9FA;
	Thu,  4 Apr 2024 13:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1712238349; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nb1xGFU4z4S4a5lkQWJ6MnQgiNnOSeZGRrVZ6nOqzAE=;
	b=KJ5kMtifgEeLBbFV9RdQ24ZLy7dz+Zua5JHo2lBhuqx7UoXeMzAnMneaoy7ZFJliU0GOV6
	P4hVA4vL6aheWYi6EH+o2oOMRPaEdEdLSIkOpfqRSBkiFKOaT2701udpiLpAiDRAx28Ka+
	amGf8alqrNyVDr/bhoyVmEB+X3+ZZSI=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=KJ5kMtif
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1712238349; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nb1xGFU4z4S4a5lkQWJ6MnQgiNnOSeZGRrVZ6nOqzAE=;
	b=KJ5kMtifgEeLBbFV9RdQ24ZLy7dz+Zua5JHo2lBhuqx7UoXeMzAnMneaoy7ZFJliU0GOV6
	P4hVA4vL6aheWYi6EH+o2oOMRPaEdEdLSIkOpfqRSBkiFKOaT2701udpiLpAiDRAx28Ka+
	amGf8alqrNyVDr/bhoyVmEB+X3+ZZSI=
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 2C6E2139E8;
	Thu,  4 Apr 2024 13:45:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id OsEJCQ2vDmaleQAAn2gu4w
	(envelope-from <mwilck@suse.com>); Thu, 04 Apr 2024 13:45:49 +0000
Message-ID: <b36253022cf3c1fe9bda46c606c2f25a904a4711.camel@suse.com>
Subject: Re: [PATCH 04/11] 11-dm-mpath.rules: adapt MPATH_DEVICE_READY=0
 logic to 10-dm.rules update
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>
Date: Thu, 04 Apr 2024 15:45:44 +0200
In-Reply-To: <ZgNJfL9ULHJpCzAH@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240324211301.7200-1-mwilck@suse.com>
	 <20240324211301.7200-5-mwilck@suse.com>
	 <ZgNJfL9ULHJpCzAH@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Spamd-Result: default: False [-2.52 / 50.00];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	DWL_DNSWL_LOW(-1.00)[suse.com:dkim];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	BAYES_HAM(-0.01)[49.97%];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:98:from];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap2.dmz-prg2.suse.org:helo,imap2.dmz-prg2.suse.org:rdns,suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 5E88D5D9FA
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -2.52

On Tue, 2024-03-26 at 18:17 -0400, Benjamin Marzinski wrote:
> On Sun, Mar 24, 2024 at 10:12:54PM +0100, Martin Wilck wrote:
> >=20
> > +ENV{DM_UDEV_RULES_VSN}!=3D"3",
>=20
> Can't we do something like:
>=20
> ENV{DM_UDEV_RULES_VSN}=3D=3D"1|2",
>=20
> instead, that wouldn't break on future version number bumps.
>=20

Excellent idea, thanks!

Martin


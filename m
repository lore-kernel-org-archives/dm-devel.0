Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9414D2EE4
	for <dm-devel@lists.linux.dev>; Fri,  5 Jun 2026 11:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780658241; cv=none; b=opjjN86yAV3dIOQSw2BnMscQw4ZepkI2oCFop90vbNSPeP25klu2DdyV1iR+p0BqDABb4u91MLULiRG+IVRysarr67Pk8H495Rg9cepagudYQ84YjKnKZPi9lpGBIubT9S5RLScosjeS+sF1QCJwl6LNSr9EQvSuLilP5UzJ2No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780658241; c=relaxed/simple;
	bh=tOXgW9ItYHoFoAb6lJ+41HVHHFjG5Jl8H04eQ2nGvvc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mo0h7v/GcxjX4bx+9jG9Dq8FoAHREZidTQrh4TDHdzRziF0jM7o/fb9Y4M9WSyeI81d18itKqMdshysKemODXka5v3NloRlAKBg5XbaMAevxwhRPPYtOEBrMP3kVObNvHWVl+9Cg4zid+JN0w/thQLuqglBPZPD8ZNywkXrZVRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RVyV5k5K; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RVyV5k5K; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RVyV5k5K";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RVyV5k5K"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 13D476B251;
	Fri,  5 Jun 2026 11:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780658238; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tOXgW9ItYHoFoAb6lJ+41HVHHFjG5Jl8H04eQ2nGvvc=;
	b=RVyV5k5KqdvMt02yGqHSTbMVAYtkYK6j1Sa7mXCDhV4ZFktj5f6eGz1tIFRjycsskoYN0i
	P8hRVy4KJX6xk1hL87v1JnQbMKHudj7mgUUWB5W6izDR8aokkm2pMhcAkfW/rhOCC6Irti
	F7ZeOxO+RHhU7NcTeVpwTwi77eur+Pk=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780658238; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tOXgW9ItYHoFoAb6lJ+41HVHHFjG5Jl8H04eQ2nGvvc=;
	b=RVyV5k5KqdvMt02yGqHSTbMVAYtkYK6j1Sa7mXCDhV4ZFktj5f6eGz1tIFRjycsskoYN0i
	P8hRVy4KJX6xk1hL87v1JnQbMKHudj7mgUUWB5W6izDR8aokkm2pMhcAkfW/rhOCC6Irti
	F7ZeOxO+RHhU7NcTeVpwTwi77eur+Pk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E74B4779A9;
	Fri,  5 Jun 2026 11:17:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3YBmNz2wImrIEQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 05 Jun 2026 11:17:17 +0000
Message-ID: <ec4309f164e69118035bd684318ee12d2ebec530.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: align ALUA state strings with kernel
 scsi_sysfs
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Fri, 05 Jun 2026 13:17:17 +0200
In-Reply-To: <20260531103828.23549-1-xose.vazquez@gmail.com>
References: <20260531103828.23549-1-xose.vazquez@gmail.com>
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
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[opensvc.com:email,linux.dev:email,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -2.80

On Sun, 2026-05-31 at 12:38 +0200, Xose Vazquez Perez wrote:
> Update ALUA asymmetric access state descriptions in the prioritizer
> to
> match the shorter names defined in the SCSI kernel subsystem:
>=20
> =C2=A0=C2=A0 $ grep=C2=A0 "{ SCSI_ACCESS_STATE_"=C2=A0 linux/drivers/scsi=
/scsi_sysfs.c=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 { SCSI_ACCESS_STATE_OPTIMAL, "=
active/optimized" },
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 { SCSI_ACCESS_STATE_ACTIVE, "a=
ctive/non-optimized" },
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 { SCSI_ACCESS_STATE_STANDBY, "=
standby" },
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 { SCSI_ACCESS_STATE_UNAVAILABL=
E, "unavailable" },
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 { SCSI_ACCESS_STATE_LBA, "lba-=
dependent" },
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 { SCSI_ACCESS_STATE_OFFLINE, "=
offline" },
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 { SCSI_ACCESS_STATE_TRANSITION=
ING, "transitioning" },
>=20
> This unifies diagnostic strings across the stack and replaces the
> misleading
> "ARRAY BUG: invalid TPGs state!" message with the standard SPC
> "reserved"
> designation. These codes are explicitly reserved for future standard
> definitions rather than being treated as malformed states.
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

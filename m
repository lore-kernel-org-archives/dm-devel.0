Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBA93F1672
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 07:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791357764; cv=none; b=qi33eU3qsqLB0ryEuWZwW4kY0BAnJq3yfHuIGHBTeAbMhgzqJKwjMVdb/UC0+/GmOv4a41VV5JSVhDifZKlZvIGQKsxSDp8elyKBSj9aOo3p2Bwo4SEjkAH32cAGPcM1ZWzC371pPXCTLH67D4uYF13eCaG+GrW0C/EyayKgPfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791357764; c=relaxed/simple;
	bh=cU/sDkT6FhX7LwFB/nb+bRcgl3aOvyk8nBVyO+RWHwg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Lflea+GQ3MjH92tTH2P6ziCKz8LpC7JGCdM6dzMsC/49gHQ1/UAer3bVHVPIzyhwvJi9PUZNPNSpnQpmq8b37wAikN17xBBZ82BgFIq/TbUnMldpuh3yEYRFZfbc0V3m9opuzvTVDnMMDYYpcSwWycrDkkAlmqhtNUfz9YfaT34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=IrERPDdO; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=tc2fYT3S; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="IrERPDdO";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="tc2fYT3S"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 144221F45A;
	Wed,  7 Oct 2026 07:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791357757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cU/sDkT6FhX7LwFB/nb+bRcgl3aOvyk8nBVyO+RWHwg=;
	b=IrERPDdOdoCJCoPQlg0pS66H3CnUi8ctdged7aa2AXKZns1H5PjPFb6UGBlptJpD4WoOAG
	bwSwOeyexWfdY65dKD67DrBLUbtmmR0yDlhrWTrtu98RoInH58hVM5W6ICvk+HT6omr84D
	keLXPBL1O8Fzu5k8aLaRmAQ9J02bfTo=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=tc2fYT3S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791357753; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cU/sDkT6FhX7LwFB/nb+bRcgl3aOvyk8nBVyO+RWHwg=;
	b=tc2fYT3SIXXqs9yCeo7O57r+slfW/5aHXuJEWStNmEoNbK1Sf6fMylcD7Xh6o/WV3KN21a
	FHVaDGsTWnUUgk2HgTXoZ3YoRlb7FVbz5xqqToteed0kSlv3HvIv9W01VKJuINoPUtJ2E1
	BNS/HDY8QsYYb8T6AB25j0r11ID/sUg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AB41913354;
	Wed,  7 Oct 2026 07:22:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id m1y7HzjzxWrYegAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 07 Oct 2026 07:22:32 +0000
Message-ID: <445963a857738a314bbc580c614e54b05a56786b.camel@suse.com>
Subject: Re: [PATCH 2/2] libmultipath: dm_flush_map__: retry the resume
 after a failed remove
From: Martin Wilck <mwilck@suse.com>
To: Suresh Thelkar <suresh.thelkar@yahoo.com>, dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 07 Oct 2026 09:22:32 +0200
In-Reply-To: <20261007071602.97962-1-suresh.thelkar@yahoo.com>
References: <20261005045726.71858-1-suresh.thelkar@yahoo.com>
	 <20261005045726.71858-3-suresh.thelkar@yahoo.com>
	 <ea3d358c00cad3559658023d6bc98937c265218b.camel@suse.com>
	 <20261007071602.97962-1-suresh.thelkar@yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_TO(0.00)[yahoo.com,lists.linux.dev];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[yahoo.com];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:email,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 144221F45A
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Wed, 2026-10-07 at 07:16 +0000, Suresh Thelkar wrote:
> On Tue, 2026-10-06 at 23:07 +0200, Martin Wilck wrote:
> > Have you tested this, and have you observed cases where it actually
> > helped to resume a device after the first DM_DEVICE_RESUME had
> > failed?
> >=20
> > Would it increase the chances to resume the device if we wait a few
> > fractions of a second before retrying?
>=20
> Thanks Martin, you're right to push on this.
>=20
> Our fault injector was written to reproduce the exact sequence we
> observed in the field: DM_DEVICE_REMOVE returned -EBUSY, and the
> following status query then failed. So the injector deliberately
> forces
> just those two -- DM_DEV_REMOVE -> EBUSY and the next DM_TABLE_STATUS
> ->
> error -- which is what drives dm_is_mpath() to return -1. It does not
> force DM_DEVICE_RESUME to fail, so the retry branch added in 2/2 was
> never actually exercised.

Have you ever found out what the exact reason for the DM_TABLE_STATUS
failure was? What was the return code of the kernel / device-mapper?
Can we perhaps make dm_is_mpath() smarter?

> As a result I can't claim to have observed the second resume help.
> The
> extra retry was purely defensive, in case the resume ioctl itself
> failed, and I agree an immediate identical retry with no delay
> wouldn't
> add much. On this no-table-swap resume the realistic failures (-
> EINVAL
> "not suspended", -ENXIO "gone") already mean the map isn't left
> suspended, so neither a retry nor a short delay buys much.
> 09:17 multip
> So I'll drop 2/2. Patch 1/2 is the real fix for the problem we hit in
> our environment. If it's useful, I can add a condlog(1, ...) warning
> when the resume ioctl fails, so a leaked suspend is at least visible
> in
> the logs -- would that address your concern?

Yes, that makes sense. We should see this in the logs.

> If you agree, should I resend patch 1/2 on its own as a v2 (with 2/2
> dropped)? Please confirm.

Yes, please resend a final version. It's up to you whether you keep two
commits or squash them into one.

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)

Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4951E5215
	for <dm-devel@lists.linux.dev>; Thu,  8 May 2025 13:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746712324; cv=none; b=FlljiGWlq5Temg+HcMM7apPEy8vNylz15t7HK4S5Ucnio/RY9W5EUNXLG0TpUo5aoXzDIWqTxr1DRhAkhW6cXavVOhAmc3MyCJIR326lkmE8RYtl79C+GrHhzr0ImkMV1TjsT6UDUHfsTtPnegrCu9AgK0mkUR3uxKK2yhsBPXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746712324; c=relaxed/simple;
	bh=A6cXM0OYInR03fp+Wpri2dLtkqD7DN0Lrk54dKtajiY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JmQbR7pJIoCAmUKFAz7NIWYWayz2JNT2WBAECjdfRwadqPsFUY1rYD+ZOp+w9Z7NapH24iUKO/kDDO2OA8G9Z5KtNA8LCiF0CrPizMS8Ykg0klFrV2X8E8yNQv7ItMtb9JdiIvkPDw4Ppl4/qsLS84kwipcl0zSMaCf1S+e8BRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Gsc3fiSd; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KqPGj3jH; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Gsc3fiSd";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KqPGj3jH"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B29C0211ED;
	Thu,  8 May 2025 13:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1746712321; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A6cXM0OYInR03fp+Wpri2dLtkqD7DN0Lrk54dKtajiY=;
	b=Gsc3fiSd/BKuZQ4guwg7LMGqU8YEOJAmiT1yz3kA70qiIxh+n+44Bc870ByEnMdFnfYA7u
	3vDmlbWcTJ3/H0dZyvnByqgaeywxRP4UPx2a13ssAxHU0+cMI7FPTLOhgTpFE0PEtOffMz
	6GokkwsnEJNdM1+Zq0URW0GXCkyT1dk=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=KqPGj3jH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1746712320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A6cXM0OYInR03fp+Wpri2dLtkqD7DN0Lrk54dKtajiY=;
	b=KqPGj3jH7XEXwoiAndxan8mPxq276leGp/v0yeU9KOIF60nodXcydmZYsftrCTtRPam0jA
	pqIKGASptNk2ZfOc+Oj4tRmGTz/vjyCE1+bzJUQInGy0rPfuemu1PYH/Gme8Q3TyAeANPK
	cN6BeP9b41rH/yBTb4UFxA2Ekdy5Vco=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7659413712;
	Thu,  8 May 2025 13:52:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id v6hhGwC3HGiJPwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 08 May 2025 13:52:00 +0000
Message-ID: <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
From: Martin Wilck <mwilck@suse.com>
To: Kevin Wolf <kwolf@redhat.com>, dm-devel@lists.linux.dev
Cc: hreitz@redhat.com, mpatocka@redhat.com, snitzer@kernel.org, 
	bmarzins@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 08 May 2025 15:51:59 +0200
In-Reply-To: <20250429165018.112999-1-kwolf@redhat.com>
References: <20250429165018.112999-1-kwolf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: B29C0211ED
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action

Hello Kevin,

[I'm sorry for the previous email. It seems that I clicked "send" in
the wrong window].

On Tue, 2025-04-29 at 18:50 +0200, Kevin Wolf wrote:
> Multipath cannot directly provide failover for ioctls in the kernel
> because it doesn't know what each ioctl means and which result could
> indicate a path error. Userspace generally knows what the ioctl it
> issued means and if it might be a path error, but neither does it
> know
> which path the ioctl took nor does it necessarily have the privileges
> to
> fail a path using the control device.

Thanks for this effort.

I have some remarks about your approach. The most important one is that
the DM_MPATH_PROBE_PATHS_CMD ioctl appears to be a dangerous command.
It sends IO to possibly broken paths and waits for it to complete. In
the common error case of a device not responding, this might cause the
code to hang for a long time in the kernel ioctl code path, in
uninterruptible sleep (note that these probing commands will be queued
after other possibly hanging IO). In the past=C2=A0we have put a lot of
effort into other code paths in multipath-tools and elsewhere to avoid
this kind of hang to the extent possible. It seems to me that your set
re-introduces this risk.

Apart from that, minor observations are that in patch 2/2 you don't
check whether the map is in queueing state, and I don't quite
understand why you only check paths in the map's active path group
without attempting a PG failover in the case where all paths in the
current PG fail.

I am wondering whether the DM_MPATH_PROBE_PATHS_CMD ioctl is necessary
at all. Rather than triggering explicit path probing, you could have
dm-mpath "handle" IO errors by failing the active path for "path
errors". That would be similar to my patch set from 2021 [1], but it
would avoid the extra IO and thus the additional risk of hanging in the
kernel.

Contrary to my set, you wouldn't attempt retries in the kernel, but
leave this part to qemu instead, like in the current set. That would
avoid Christoph's main criticism that "Failing over SG_IO does not make
sense" [2].

Doing the failover in qemu has the general disadvantage that qemu has
no notion about the number of available and/or healthy paths; it can
thus only guess the reasonable number of retries for any given I/O. But
that's unavoidable, given that the idea to do kernel-level failover on
SG_IO is rejected.

Please let me know your thoughts.

Best Regards
Martin

[1] https://lore.kernel.org/all/20210628151558.2289-1-mwilck@suse.com/
[2] https://lore.kernel.org/all/20210701075629.GA25768@lst.de/



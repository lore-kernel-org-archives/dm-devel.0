Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C2D1FBE9E
	for <dm-devel@lists.linux.dev>; Tue,  4 Mar 2025 20:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741119977; cv=none; b=lgSyrPBBT7uOYsRa/UjCeU3aKYslqlDx8HWMi5kVCVACBQb5/Xv5TWjMcwpesqdBSkLxF+uXvdFscYu9ruNwr3UFd7YAjUPZ0sYGLV7n1W4QD+ZpvV8ov8CHgIme3MMt98LgI7EwNg+I/IKIL5DofosRS82KDrw565w+YwJDvMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741119977; c=relaxed/simple;
	bh=BviROr3KRpR0Tg4fOK5Knh9TG5SqmGd9yNXKDWLSsWM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=F5c2nuxTMxm+wMsierDm+y5IOSp3Gc1AEc0zKnY1cg0PVeId6OcFW4LqpRVDiaFwf3OiRoL0ZlqygFqSZncXE/U2h68CA4Wzk8Lg3L/83DDzSuYUYMFrLGsNuiH58cG/7+EtYXmP7l7/yPldNxFfLyE6qIBSIxqjG1zOQsXSFEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=BOC8nL8I; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=BOC8nL8I; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BOC8nL8I";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BOC8nL8I"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1D45721163;
	Tue,  4 Mar 2025 20:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1741119973; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BviROr3KRpR0Tg4fOK5Knh9TG5SqmGd9yNXKDWLSsWM=;
	b=BOC8nL8Iy/+XV6iQXr5s7isDafsHfQazDqYKXfTiZpVlZ3h2X22q7r2CUON7qTZGOwoVtA
	ZqFhch0+PMmxL9LX7EsT4ClATA2IqzlfnDg4Tya0+jfcxfb0iSVPbQtIz+PM0Jh/o41/8F
	xxy81q4pByqhVaJH8ia2LAxM8TJeIxo=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=BOC8nL8I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1741119973; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BviROr3KRpR0Tg4fOK5Knh9TG5SqmGd9yNXKDWLSsWM=;
	b=BOC8nL8Iy/+XV6iQXr5s7isDafsHfQazDqYKXfTiZpVlZ3h2X22q7r2CUON7qTZGOwoVtA
	ZqFhch0+PMmxL9LX7EsT4ClATA2IqzlfnDg4Tya0+jfcxfb0iSVPbQtIz+PM0Jh/o41/8F
	xxy81q4pByqhVaJH8ia2LAxM8TJeIxo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EA0E21393C;
	Tue,  4 Mar 2025 20:26:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DUGKN+Rhx2eMHgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 04 Mar 2025 20:26:12 +0000
Message-ID: <01c2cfdcad91bbdb37f89023887c5939db2066e6.camel@suse.com>
Subject: Re: [PATCH] multipathd: fix hang during shutdown with queuing maps
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Tue, 04 Mar 2025 21:26:12 +0100
In-Reply-To: <Z8YGC5oP9zFM79DC@redhat.com>
References: <20250227174104.206721-1-mwilck@suse.com>
	 <Z8YGC5oP9zFM79DC@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 1D45721163
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Mon, 2025-03-03 at 14:42 -0500, Benjamin Marzinski wrote:
> On Thu, Feb 27, 2025 at 06:41:04PM +0100, Martin Wilck wrote:
> > Since c9689b6 ("multipathd: Remove dependency on
> > systemd-udev-settle.service"), multipathd.service starts very early
> > during
> > boot, which in systemd's service ordering logic means that it is
> > stopped
> > late. While this is generally a good thing, it means that, when
> > systemd
> > unmounts file systems and tears down the block device stack,
> > multipathd
> > is still running. Therefore our "queue_without_daemon" logic, which
> > disables
> > queuing when multipathd exits, isn't effective yet. If there are
> > any
> > multipath maps that are in queueing state at this point in time,
> > the system
> > may hang indefinitely.
> >=20
> > To fix that, add a new service which starts later (and thus stops
> > earlier) and
> > disables queueing on all multipath maps during shutdown. Similar to
> > lvm2's
> > blk-availability.service, the service does nothing when started.
> >=20
> > Fixes: c9689b6 ("multipathd: Remove dependency on systemd-udev-
> > settle.service")
>=20
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

Thanks - do you reckon this is suitable for the stable tree?
There is not much of a regression risk, but it requires shipping
another file, so it's non-trivial for packagers.

Personally I'm inclined to add it to stable (also because I'll need to
backport it anyway).

Martin


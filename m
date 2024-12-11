Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266682594B5
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 20:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733949225; cv=none; b=PTMGnXnEyXmCBNi6LOYA0L3i4LUwXZr1VKCXO0zVylGJ/3l9gZtf/ERHzvSUNW5oVI3EGCZUD2/BRkwlqkzwWK7P11Q+u21w8MhthY1QstdvzDqfna27af0ksUhFZBPl4rVkWcbcIEk9dne4D+1CpqmWFFOXq3iYC/dCW3eg8f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733949225; c=relaxed/simple;
	bh=ZP6iKP0SngQJHQAGYjhsyO/59iXlaL6uMHrVmkRZvf4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=poK+2LNYJ5C8Lpyef/jH1/p6gFCyIIXXSuXN0FXr8C7p+J4dQR9I9QVdgCcOHXnBOhCbTISfOsO/0jWGx6qaJzC7cushgYrYM05QKLlfK8VU3M6QO1+ePQTxaujWHiS+/Z+YVhgYssJXb73ctw2ccwnSKW7XVqoH6xZaWhkxl3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RXRjJXBs; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RXRjJXBs; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RXRjJXBs";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RXRjJXBs"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5195A1F38D;
	Wed, 11 Dec 2024 20:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1733949221; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZP6iKP0SngQJHQAGYjhsyO/59iXlaL6uMHrVmkRZvf4=;
	b=RXRjJXBsAtaLHwtkpf+po41CDQ49mIGCBOiOewW9S9jVwUTCRLQf4jPxob4I02AaDwkcat
	+skEeFzJJ4/BnXnoxtuRe5JDP1MbyOZzmLJq01/3nj69xlibhlwkHCVV6uZA108IgdM0q8
	+QBKlzvQ8IBhxDf86r8UpUKQyiB3dEo=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1733949221; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZP6iKP0SngQJHQAGYjhsyO/59iXlaL6uMHrVmkRZvf4=;
	b=RXRjJXBsAtaLHwtkpf+po41CDQ49mIGCBOiOewW9S9jVwUTCRLQf4jPxob4I02AaDwkcat
	+skEeFzJJ4/BnXnoxtuRe5JDP1MbyOZzmLJq01/3nj69xlibhlwkHCVV6uZA108IgdM0q8
	+QBKlzvQ8IBhxDf86r8UpUKQyiB3dEo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2ABB713927;
	Wed, 11 Dec 2024 20:33:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ejjVCCX3WWeGHwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 11 Dec 2024 20:33:41 +0000
Message-ID: <422fff82ad35293d9406ec07820ddad5b122d1f6.camel@suse.com>
Subject: Re: [PATCH 03/13] multipathd: allow map removal in do_sync_mpp()
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Wed, 11 Dec 2024 21:33:40 +0100
In-Reply-To: <30fccbf041abd3af27f0228b51df431a2ca8438a.camel@suse.com>
References: <20241206233617.382200-1-mwilck@suse.com>
		 <20241206233617.382200-4-mwilck@suse.com> <Z1jPMVejcI61qP9z@redhat.com>
		 <ee6fcbda31fd1f13969653782417fbed748f5bc7.camel@suse.com>
		 <Z1nHUk8o3_qqPwED@redhat.com>
	 <30fccbf041abd3af27f0228b51df431a2ca8438a.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

On Wed, 2024-12-11 at 21:20 +0100, Martin Wilck wrote:
> On Wed, 2024-12-11 at 12:09 -0500, Benjamin Marzinski wrote:
>=20
>=20
> > I'm not actually worried about the kernel so much as libdevmapper.
> > It
> > is
> > not designed for multi-threaded processes, and that has bitten us
> > in
> > the
> > past. For intance, it's why we don't delete devices in
> > dmevent_loop()
> > on
> > libdevmapper errors. dm_get_events() just waits and retries if
> > getting
> > the device list fails, and for each device, it calls dm_is_mpath
> > and
> > will only delete a device on DM_IS_MPATH_NO, which is what I
> > suggested
> > for the cleanup function.
> >=20
> > I'm pretty sure we've handled all of the known issues here, with
> > fixes
> > like:
> > 02d4bf07 ("libmultipath: protect racy libdevmapper calls with a
> > mutex")
> > 34e01d2f ("multipath-tools: don't call dm_lib_release() any more")
> >=20
> > I'd rather not risk having missed some issue that could cause a
> > temporary error in a function that we call every couple of seconds
> > (almost always unnecessarily).
>=20
> Ok, getting it. I thought that an error in DM_TABLE_STATUS must
> almost
> neccessarily mean -ENXIO (from the kernel pov), which would mean that
> some external entity removed the device, and that we should act as if
> someone had used the "remove map" CLI command. But I didn't think
> about
> libdevmapper.

But will libdevmapper return ENXIO if it's somehow interally confused?
I don't think so. I believe that if we see this error code, removing
the map is the right thing to do.

I consider adding a patch on top of the v4 series that does this.=C2=A0
If you reject it, fine :-)

Regards,
Martin


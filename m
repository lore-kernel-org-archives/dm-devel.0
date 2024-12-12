Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288E54F218
	for <dm-devel@lists.linux.dev>; Thu, 12 Dec 2024 17:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023927; cv=none; b=E46XtdfItaa3430u1ij10SgxpqxhBliD8Vq5yK4PTwIoBpeo9lX6Wkg6cXRPJ52uSf2G2Z2BXujvn6TJPGINFsOCNGnXYZHLmu0I+JWFfrzNln87zUym55aBUS5vWdnlRS0cXSvLioi5zQgX4KOXI+12F5FCEq19ijdnjTNO8WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023927; c=relaxed/simple;
	bh=3RCLzg6r/fYVbLz8vLDP1O39tbXujEu2qNXmR2X2l8E=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c/s6Ma51yV1vnudWojWtZpdffXnwwpW8LXx0A/XoJFgFHaSTQRzTRQbQGkVJ+TEEyL+4LQZgn4Tvrdmc0ioOKZBpy4M8iaC0kFHh+O9KqJDcQedx2kB05nrZlboKG7SwKdUVM+UaY1OEMqW/TIlGaH3UfZr5AV7HE+gmSXFN5K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XeBxYMhT; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XeBxYMhT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XeBxYMhT";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XeBxYMhT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A36AB21179;
	Thu, 12 Dec 2024 17:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1734023920; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3RCLzg6r/fYVbLz8vLDP1O39tbXujEu2qNXmR2X2l8E=;
	b=XeBxYMhT3jYscp3rEIjmZpeegZMIY145XRxxvLL4pO2M9GF3doVmX/E29CS6Xao04iCqsT
	5EmT5whWh8Ds4Vt0b/sL1Q90TBZbGruNsHUYrzL2fBK9rFzC1T9ERPVgVWik0KqwaWWF9w
	lPEIRCQJPM3p1MsKnVUOGmn6RQLnU1M=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1734023920; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3RCLzg6r/fYVbLz8vLDP1O39tbXujEu2qNXmR2X2l8E=;
	b=XeBxYMhT3jYscp3rEIjmZpeegZMIY145XRxxvLL4pO2M9GF3doVmX/E29CS6Xao04iCqsT
	5EmT5whWh8Ds4Vt0b/sL1Q90TBZbGruNsHUYrzL2fBK9rFzC1T9ERPVgVWik0KqwaWWF9w
	lPEIRCQJPM3p1MsKnVUOGmn6RQLnU1M=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7D48A13508;
	Thu, 12 Dec 2024 17:18:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TMjnHPAaW2diJAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 12 Dec 2024 17:18:40 +0000
Message-ID: <2920c30528493029653ab01c2cdd56d5b0736a28.camel@suse.com>
Subject: Re: [PATCH 03/13] multipathd: allow map removal in do_sync_mpp()
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Thu, 12 Dec 2024 18:18:40 +0100
In-Reply-To: <Z1sZh1WLCucwL61e@redhat.com>
References: <20241206233617.382200-1-mwilck@suse.com>
	 <20241206233617.382200-4-mwilck@suse.com> <Z1jPMVejcI61qP9z@redhat.com>
	 <ee6fcbda31fd1f13969653782417fbed748f5bc7.camel@suse.com>
	 <Z1nHUk8o3_qqPwED@redhat.com>
	 <30fccbf041abd3af27f0228b51df431a2ca8438a.camel@suse.com>
	 <422fff82ad35293d9406ec07820ddad5b122d1f6.camel@suse.com>
	 <Z1sZh1WLCucwL61e@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
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
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On Thu, 2024-12-12 at 12:12 -0500, Benjamin Marzinski wrote:
> On Wed, Dec 11, 2024 at 09:33:40PM +0100, Martin Wilck wrote:
> > On Wed, 2024-12-11 at 21:20 +0100, Martin Wilck wrote:
> > > On Wed, 2024-12-11 at 12:09 -0500, Benjamin Marzinski wrote:
> > >=20
> > >=20
> > > > I'm not actually worried about the kernel so much as
> > > > libdevmapper.
> > > > It
> > > > is
> > > > not designed for multi-threaded processes, and that has bitten
> > > > us
> > > > in
> > > > the
> > > > past. For intance, it's why we don't delete devices in
> > > > dmevent_loop()
> > > > on
> > > > libdevmapper errors. dm_get_events() just waits and retries if
> > > > getting
> > > > the device list fails, and for each device, it calls
> > > > dm_is_mpath
> > > > and
> > > > will only delete a device on DM_IS_MPATH_NO, which is what I
> > > > suggested
> > > > for the cleanup function.
> > > >=20
> > > > I'm pretty sure we've handled all of the known issues here,
> > > > with
> > > > fixes
> > > > like:
> > > > 02d4bf07 ("libmultipath: protect racy libdevmapper calls with a
> > > > mutex")
> > > > 34e01d2f ("multipath-tools: don't call dm_lib_release() any
> > > > more")
> > > >=20
> > > > I'd rather not risk having missed some issue that could cause a
> > > > temporary error in a function that we call every couple of
> > > > seconds
> > > > (almost always unnecessarily).
> > >=20
> > > Ok, getting it. I thought that an error in DM_TABLE_STATUS must
> > > almost
> > > neccessarily mean -ENXIO (from the kernel pov), which would mean
> > > that
> > > some external entity removed the device, and that we should act
> > > as if
> > > someone had used the "remove map" CLI command. But I didn't think
> > > about
> > > libdevmapper.
> >=20
> > But will libdevmapper return ENXIO if it's somehow interally
> > confused?
> > I don't think so. I believe that if we see this error code,
> > removing
> > the map is the right thing to do.
>=20
> I don't think that shouldn't ever happen.
>=20
> https://github.com/lvmteam/lvm2/blob/928b8e9c6eaf871b3405b91c64eac5ea854f=
2572/device_mapper/ioctl/libdm-iface.c#L2100
>=20
> If libdevmapper gets an ENXIO from the kernel, it ends up setting
> dmi.exists to 0 instead of returning the error.

I meant the kernel ioctl return code. Sorry for being unclear.

From the the point of view of libmultipath, it doesn't matter.
libmp_mapinfo tests for ENXIO and dmi.exists, and returns DMP_NOT_FOUND
in both cases.

Martin


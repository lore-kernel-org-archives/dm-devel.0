Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794002302;
	b=3q69QONgnL5DsyadZa+bO3rKLNV13neRL5BmfiI7tEscMcZ2CTLiWxucEHxOu5qHjjb3
	 9Aa5pPyhzrUH5F/xeeft+ToheNA1HtkeJBziQ01FUMqnM4U2f7uxMV/oNfQtn6ufnzLC1
	 /hzzmWfZ4C4slUIK50Qsg22pTmewOaDXoDwgQzMBpbkEHGgqrokKtQstaQlaPJWXP1T2k
	 ayb4ZxLOhMRHBphZoQn2kFC5KZw6rOE5OD4EQ1CAME9uICY5o+Uzis3b4wypxBO4Vtilg
	 nCKkvGFCDDdpM2C+g/iaEXKVtwRPzo6D4VnZpgS3nLdhD6OOgzo8f24LWy8d8W40zlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794002302;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version:
	 X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=5HJyrN/BBi3gNk8FAFwHPJNpbqkUBna5On8qSqeBHWQ=;
	b=Aye0RXaIdfsayybrI1iBKsVnh4+Q8GsHskdw7pcOyCmcZ7Wqhgn6q1osXaVQiweiS+R6
	 d6RnxUOfX1/8OEXcrjK4hXKya1jjTAyhOhIEcmED7FIylVRq4bBOy/FHTTe7IrdCMJh7P
	 ZE0Z/YlVWqNvB2eUFs10ILtshYv1gEbzeemdqnwJtEt0GJR4gC4PkoYhHhuALL2lf4h6P
	 DZc25hgr7s4YTAy1sVa8dGAUHGV6pKqb3AM2UHTXXcU7hIiiSBHWBEYVg+Qbc07kmL4Zf
	 eg5w2cvNzTqvFJzdunmTCC34o9ZYOlI2pAnWeDkaA+ba1tf/UBOBERsjv5QihNdKyDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="ZX//BVmM";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="ZX//BVmM";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DBA606A326
	for <dm-devel@lists.linux.dev>; Fri,  6 Nov 2026 21:58:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14DBA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ZX//BVmM;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ZX//BVmM
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 052511F441;
	Fri,  6 Nov 2026 21:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794002300; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5HJyrN/BBi3gNk8FAFwHPJNpbqkUBna5On8qSqeBHWQ=;
	b=ZX//BVmMcSNx1SXp4IvpewheSlUU/CXn6Ntq8Ebl2fskr5R/t/NxOQ45F7+uQXfCyf2LPp
	5qRFD2pIp6DGk8E+c9cBbH8i0svSlMqRMfCbN0sDmbCgf/d/KIOol38oH2NHiUuhozRbV0
	Me3i/xHwPiLAI52Y0GxturblI0dN/yA=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="ZX//BVmM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794002300; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5HJyrN/BBi3gNk8FAFwHPJNpbqkUBna5On8qSqeBHWQ=;
	b=ZX//BVmMcSNx1SXp4IvpewheSlUU/CXn6Ntq8Ebl2fskr5R/t/NxOQ45F7+uQXfCyf2LPp
	5qRFD2pIp6DGk8E+c9cBbH8i0svSlMqRMfCbN0sDmbCgf/d/KIOol38oH2NHiUuhozRbV0
	Me3i/xHwPiLAI52Y0GxturblI0dN/yA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 93CEA134E9;
	Fri,  6 Nov 2026 21:58:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9JdeGntN7mqgQQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 06 Nov 2026 21:58:19 +0000
Message-ID: <fd50c6e579193250a3554d78f3afb3d2599708b6.camel@suse.com>
Subject: Re: [PATCH v1 1/1] multipathd: verify udev WWIDs with the device
 before moving paths
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Brian Bunker
	 <brian@purestorage.com>
Cc: dm-devel@lists.linux.dev, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Date: Fri, 06 Nov 2026 22:58:18 +0100
In-Reply-To: <auO6S56Jdjpxh8Bh@redhat.com>
References: <20261029175727.25457-1-brian@purestorage.com>
	 <20261029175727.25457-2-brian@purestorage.com>
	 <auO6S56Jdjpxh8Bh@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.62.1 
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Rspamd-Queue-Id: 052511F441
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-13.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email]
X-Spam-Score: -13.51

On Thu, 2026-10-29 at 17:27 -0400, Benjamin Marzinski wrote:
> On Thu, Oct 29, 2026 at 10:57:27AM -0700, Brian Bunker wrote:
> > multipathd takes a path's WWID from udev. When a change uevent
> > reports
> > a different WWID, uev_update_path() removes the path from its map
> > and
> > re-adds it through uev_add_path(), which places it in whatever map
> > owns
> > the new WWID. Nothing checks the new value against the device
> > itself;
> > recheck_wwid only covers paths coming back up in the checker and
> > "multipathd add path". If udev reports the wrong WWID, or the
> > uevent is
> > stale by the time it is processed, the path goes into the map of a
> > different LUN and I/O for one LUN is silently sent to another.
> >=20
> > Use SG_IO to read VPD page 0x83 from the device in two places, for
> > paths where can_recheck_wwid() is true:
> >=20
> > - In uev_update_path(), if the device still reports the cached
> > WWID,
> > =C2=A0 ignore the udev value and leave the path where it is.
> >=20
> > - In ev_add_path(), refuse to add a path whose WWID the device
> > doesn't
> > =C2=A0 confirm. The path is orphaned, its WWID is cleared and it is
> > marked
> > =C2=A0 INIT_MISSING_UDEV, so the checker retriggers udev (bounded by
> > =C2=A0 retrigger_tries) and the path is re-added from fresh data.
> >=20
> > ev_add_path() is the common point for uevent, CLI and checker adds,
> > so
> > the second check holds even when the udev data is stale by the time
> > it
> > is used. If the SG_IO read fails, behavior is unchanged.
> >=20
> > Split the SG_IO read out of check_path_wwid_change() into
> > get_sgio_wwid() so all three checks share it.
>=20
> The code all looks good to me. I must admit, I'm a little paranoid
> about
> forcing perfectly normal ev_add_path() calls to double-check the
> wwid.
> Currently, that only happens if you enable "recheck_wwid", or if
> something is going wrong with initializing the path. The issue is
> that
> scsi devices can have multiple wwids, and the multipath code has to
> be
> in sync with the code that udev runs to the wwid, otherwise they can
> be
> different. I don't think these functions differ. I know I've checked
> them in the past. But unless there is a problem getting the wwid from
> udev or someone turns on recheck_wwid (I don't know how common that
> is)
> paths don't ever run this code.=20
>=20
> We could avoid this by hijacking the need_do_map argument to
> uev_add_path() and ev_add_path(). If, instead of just being 0 or 1,
> it
> could also be a third value for reinits (we should probably use an
> enum
> in this case), we could only double-check the wwid on reinits, which
> only happen when there is an issue getting the wwid from udev.
>=20
> Thoughts? Am I just being paranoid here?

Sorry for jumping onto this thread late, I was out of office and then
busy. I don't think you're paranoid.

Our primary source of the WWID is udev, by design, and udev rules are
modifiable by users, also by design. The algorithm we implemented in
parse_vpd_pg83() mimics the default logic in the rules shipped by
systemd/udev and sg3_utils, respectively, if and only if all udev rules
and configuration settings (e.g. uid_attribute) have default values.
For that reason, we use get_vpd_sgio() only as the fallback if udev
fails, and that's really a last resort measure.

This design can of course be debated. The udev-based design was created
a long time ago, when there were less useful sysfs attributes to rely
on. It's certainly showing its age, be it only by the historic variable
name ID_SERIAL. udev rules read VPD pages from sysfs rather than from
the devices themselves, which might return stale data in certain
situations. But we have moved from explicit SG_IO to cached kernel data
for a reason - SG_IO ioctls may hang, and are thus best avoided if
possible.=20

OTOH, to a certain extent we have to rely on udev. We do rely on it for
a lot of information that we retrieve about devices. If we can't trust
udev, we need to re-write a large part of multipath-tools (and
honestly, I would be clueless what we can trust if we can't trust udev.
Can we trust the kernel?).

Anyway, if we deliberately mix udev, sysfs, and SG_IO methods to
retrieve the WWID, we are on a very dangerous path.

I'll look at the v2 now.

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)

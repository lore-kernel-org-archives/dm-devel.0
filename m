Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794425724;
	b=MNuRhFwHNa1bDDpStvlBhsL9Ne9K72MCYlPfqfy51DVlC2LqtSkEhXQAKt9sShaxGUIo
	 O8hKTYP/qbsQHymKP1DG0EUW4ABtfH8Q1HiUXJfyl0jY1nPZUVN+xgWFSK6f0nXv6D1wq
	 aD0XEV0hyAZpJ2MrTedZoxJH3HiTGbuVsr7HTwno5ujC/Wjif1IT8hd5GaxnZHT8T00TX
	 PG7Gt1YfIRo40ugZirT/Tb5QNiMBtm6cxzuzqjYlgG6+fq0VeF+pPU54s2owN1wkAvoDh
	 F9H5QURWIu56pfpYRP6Q0rsAOdTUOsh+liAPlaCpooilM7PbzMJgZgL/C7rIZt0EmGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794425724;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version:
	 X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=k0UAmbIiZbbTKAyEM+7eHiG7XyzA7pRau+rqhYRSWMQ=;
	b=ytZJ/JIlcpwW/8Gb5R2+O9Of4/Ar2G8nwAR2ZvZNB6VSHIe6EUZcu72QhYjsmpA7kemt
	 Qf+kKjr+ulRu2XF/I9UGiZIO+EuJBPh9YPqt3ghexBLUJZSl8CDYsbFt1e6dpsgFrhm6O
	 qer2gkztJ4NVblGZf329CFfs6Vy8JGCPriDNYgaJJ+3lyDz+H2+eLSqpGgZtZ6edwEMbZ
	 2q8+TSL01J4fDoa25npSUEFngId+Bwt4AkAoNW9nL0K0k10/K5EDRehgspfHCzypNYj2i
	 LpxCiNHbjCTfMBiEtX95PyJLtKRS8KEuxAx9yHiRM6nY9UuI+pooX19iixgMcN9CuWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pnAGHBBz;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pnAGHBBz;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED52606A31C
	for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 19:35:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5ED52606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pnAGHBBz;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pnAGHBBz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9361E21DEF;
	Wed, 11 Nov 2026 19:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794425721; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k0UAmbIiZbbTKAyEM+7eHiG7XyzA7pRau+rqhYRSWMQ=;
	b=pnAGHBBzeTBWYP0YAEsQ9qk8MJeNRC7jZX/vPs5Wx4iNxFoop4nFhnW7kSPdN01kB2rJ5l
	kWCSrjBvmyM3rgAHvv+hiHmnL9VJo8LluKrCVLsplXO/cMbCqqEJ2e5QVZ9Eyw/HJLq4hz
	QVq2F7wAL4YyiEWMhXsRJu07x0O66pM=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794425721; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k0UAmbIiZbbTKAyEM+7eHiG7XyzA7pRau+rqhYRSWMQ=;
	b=pnAGHBBzeTBWYP0YAEsQ9qk8MJeNRC7jZX/vPs5Wx4iNxFoop4nFhnW7kSPdN01kB2rJ5l
	kWCSrjBvmyM3rgAHvv+hiHmnL9VJo8LluKrCVLsplXO/cMbCqqEJ2e5QVZ9Eyw/HJLq4hz
	QVq2F7wAL4YyiEWMhXsRJu07x0O66pM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B0F21339F;
	Wed, 11 Nov 2026 19:35:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hgPaDHnD9GrqRQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 11 Nov 2026 19:35:21 +0000
Message-ID: <cad66f75079fe0a89150e304d753527f140c67d9.camel@suse.com>
Subject: Re: [PATCH v3 0/1] multipathd: check re-added paths' WWIDs against
 sysfs
From: Martin Wilck <mwilck@suse.com>
To: Brian Bunker <brian@purestorage.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, dm-devel@lists.linux.dev
Date: Wed, 11 Nov 2026 20:35:20 +0100
In-Reply-To: <20261111174259.41911-1-brian@purestorage.com>
References: <214d18ebabeca8318352dfa5456bc5b37cdefdeb.camel@suse.com>
	 <20261111174259.41911-1-brian@purestorage.com>
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
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-13.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.30

On Wed, 2026-11-11 at 09:42 -0800, Brian Bunker wrote:
> On Tue, 2026-11-10, Martin Wilck wrote:
>=20
>=20
> > IMO, if we can't trust the reply of the storage array, all bets are
> > off. Why would the reply that multipathd obtains directly be more
> > trustworthy than what scsi_id had got?
>=20
> It isn't more trustworthy, it's newer. The sequence on the host was:

Right, but "newer" doesn't mean "more accurate".=C2=A0You write below that
there is no indication that anything actually changed, so time
shouldn't be a factor. If a wrong VPD reply is possible once, it can
also occur multiple times. If it's just an unlikely failure, a purely
stochastical thing, it would help to simply repeat the same request; if
the probability for error is 1e-4, the probability for two errors in
succession would be 1e-8. However we don't know if it's stochastical.

>=20
> =C2=A0 09:26:34.808=C2=A0 udev change event for sdq; ID_SERIAL is verify1=
's
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 WWID
> =C2=A0 09:26:34.833=C2=A0 uev_update_path() sees the change and calls
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 ev_remove_path(); the reload of verify3's map then
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 blocks in the resume until in-flight I/O drains
> =C2=A0 09:26:39.221=C2=A0 the reload completes; sdq is freed
> =C2=A0 09:26:39.235=C2=A0 uev_update_path() calls uev_add_path() with the=
 same
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 uevent, and sdq goes into verify1's map
> =C2=A0 09:26:39.379=C2=A0 next change event for sdq; ID_SERIAL is verify3=
's
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 WWID again
>=20
> So the add acted on an answer that was 4.4 seconds old. An INQUIRY at
> the time of the add would have reflected what the device said then,
> and the one 140 ms later was correct. The check doesn't help against
> storage that keeps giving the wrong answer. It stops multipathd from
> moving a path into another LUN's map on an old answer.

Well you keep telling me that newer =3D=3D better. Maybe you are right. We
can neither prove nor disprove that with the material we have.

> > One possible case for a WWID change is that a
> > a Linux SCSI disk is removed, and another disk is added later,
> > taking
> > over the previous device's dev_t.
> [...]
> > This sounds as if the WWID of sdq was that of "verify3", then
> > "verify1", and then "verify3" again.
>=20
> That's what happened, and it wasn't a remove and add. The kernel log
> shows no SCSI device removed or added in that window, and sdq stayed
> 2:0:0:8 (65:0) throughout. Only that one udev event carried the wrong
> WWID.

Weird. Gamma radiation maybe? ;-)

> > Question about your test: Apparently the problem is reproducible,
> > otherwise you wouldn't be able to verify your patch. But you said
> > "we
> > have no packet capture".
>=20
> I should have been clearer: we've seen it once. We haven't reproduced
> it. We've been running a v1-style patch on our test initiators since,

If it was my choice, I'd prefer repeating the test with the unpatched
code, but additional debugging instrumentation, in the hope to obtain
more insight into what actually happened.

> and it hasn't recurred, but at this rate that doesn't tell us much.

I'd go one step further and say that it tells us nothing at all. You
would need to be able to reproduce the issue in a well-defined time
frame in order to do a test that gives at least some confidence that
your patch fixed it.

However from the time line you provided, it makes sense that your patch
would have been effective in the error case.

Regards,
Martin

> We've also changed our test tool to open the devices read-only, which
> removes the flood of change events that made the window likely in the
> first place. I'd like to get a capture, but I can't promise we'll
> reproduce it.



>=20
> > With this in mind, I suggest that you go back to v2 and SG_IO.
> [...]
> > I further suggest that you make this code
> > path conditional on "recheck_wwid".
>=20
> Will do; Ben suggested the same. v4 does the SG_IO check only on
> PATH_ADD_REINIT, only when recheck_wwid is set, and drops the
> uev_update_path() check from v2.
>=20
> > In the long run, we may want to redesign our WWID detection. We do
> > have
> > a general framework for asynchronous jobs now. Thus we actually
> > could
> > run asynchronous VPD inquries.
>=20
> That sounds like the right direction, and I'd be glad to help with
> it.
>=20
> Brian

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)

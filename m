Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794608796;
	b=toXBla3J6U3gVLEj677CyNy2LSOIaTj3ucFoMTeM1noWmNlNg/yy7WThTCVua53eYCNN
	 O1GL63PUEZ8QRBHTox6xM46SdeaFdheKcN3DwnMnujWqUKNkLLPSoaUuLGx9dsbRfwbmO
	 K2WDIUQSx4LRkbWrcsNIak+ZZ92AYruN2mQ5vvnnsM/qUXQwUNj02S3KvDBXehtPH6ibn
	 tMrsWgIUmG9y1obVAu2wotV4Z5KSk2+l1GSbaC+FSg0LfJ/MF85CraGgX5mwSJeD/3Ww0
	 /OUatmfVBzMcLFxrLc86wAqPmI+CL3/4Lrkn5BoKGvXg8YZom/wh/Psi20/n4+mHzbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794608796;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version:
	 X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=2MN2pL+mY1GfN83nmWl+mLg8iu7jU/0e3ZpLrxEM7OQ=;
	b=kM5DLxeq0hGxbDEHfSxmiH8QKA7RAahJFn/DnrYnHCgJHcknYVH29Qu28REnyTdeAfpA
	 XZOgBZp7iUG2oXGV+8pJhIUGqNJBtt6CpTcCeoi4WTuNph9H7CCD31hwvysDywNMO8QHg
	 PFq4BUmSl98b0O+Ui1jeS0BnU4l9S+30usZePiiCcL62izMJZVcrArlErMPqqSMo3+L05
	 248A2exWbcwAcp668zYvmkbuOpJ3AFBrJ/8klkQG/f9FycNu9blM+aR59CLVtdviO2PdE
	 ORR4D6Tgs0E6EiwhCsqDomiuMGmck9ZegQwHLwPFGL41YP+FcGishe7tHbx32CslNTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=fNDcAvpy;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=F9s1jsOw;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665CB606A335
	for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 22:26:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 665CB606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=fNDcAvpy;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=F9s1jsOw
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 66DB61FB63;
	Fri, 13 Nov 2026 22:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794608793; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2MN2pL+mY1GfN83nmWl+mLg8iu7jU/0e3ZpLrxEM7OQ=;
	b=fNDcAvpy4lRiM4pFqEnkJ5HiYOcQU2faX4KD+Jp5pR5DC2+Gh6rCoyxLCAuFZi3ZNkHBkV
	9ZIcvU0A8JEGk8uQwjtihTHu1MzeWcV7Xy9qQQf5C9peGnxS0CjAm1xHnIGKftuu2pTIdf
	BLKF0zmx3Ow6ne8j87YBOyAbJQZTLZY=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=F9s1jsOw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794608792; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2MN2pL+mY1GfN83nmWl+mLg8iu7jU/0e3ZpLrxEM7OQ=;
	b=F9s1jsOw7K/BD9Y8HgRi9DagN75UJl+kTzzD3ujM5lZoaxrhoO5JWq5lVQ0bY06y15c4zk
	sniWAJTOlA1uIXxXtiIXCJFHDmD/5UcbLBUV2S0WSHicLBYYuECUyiE85+F8BWSFXsEOJj
	Ci3LYY5VR87ft8OrZAM4+WRsN2U7Bhk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 247831344A;
	Fri, 13 Nov 2026 22:26:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id H/6BAZiO92qnWQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 13 Nov 2026 22:26:32 +0000
Message-ID: <e246cb25f06744a1610ee1d78e033d6ecb17a31d.camel@suse.com>
Subject: Re: udev / multipath-tools: WWID determination with SG_IO vs. sysfs
From: Martin Wilck <mwilck@suse.com>
To: Brian Bunker <brian@purestorage.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke
 <hare@suse.com>,  Christophe Varoqui <christophe.varoqui@opensvc.com>,
 dm-devel@lists.linux.dev
Date: Fri, 13 Nov 2026 23:26:31 +0100
In-Reply-To: <20261113194358.35028-1-brian@purestorage.com>
References: <20261109185556.27139-1-brian@purestorage.com>
	 <214d18ebabeca8318352dfa5456bc5b37cdefdeb.camel@suse.com>
	 <20261111174259.41911-1-brian@purestorage.com>
	 <cad66f75079fe0a89150e304d753527f140c67d9.camel@suse.com>
	 <20261111230535.12947-1-brian@purestorage.com>
	 <83f73b9cb1506eb80220759e3e0aae18648f80c4.camel@suse.com>
	 <20261113194358.35028-1-brian@purestorage.com>
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
X-Spamd-Result: default: False [-13.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:dkim];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 66DB61FB63

On Fri, 2026-11-13 at 11:43 -0800, Brian Bunker wrote:
> Martin, Ben, Hannes,
>=20
> The problem case is user error: reusing the LUN number before that
> cleanup has finished. Cleanup is asynchronous, and the array can't
> wait
> on it. The sequence is:
>=20
> =C2=A01. Volume A is disconnected from a LUN.
> =C2=A02. Before the host has removed the old devices, volume B is
> connected
> =C2=A0=C2=A0=C2=A0 at the same LUN number.
> =C2=A03. The array sends 3f/0e as usual, and the rescan runs. The sd
> devices
> =C2=A0=C2=A0=C2=A0 for that H:C:T:L still exist, so there is nothing to a=
dd.

Why does this happen after 2.)? Wouldn't the array send 3f/0e
immediately after 1.)? If your "purge" functionality was active in
multipathd, and/or if the libstoragemgmt udev rules were enabled, the
SCSI device would be deleted. With "purge", the block device would be
deleted, too, or at least orphaned by multipathd. This should happen
even if the host still had some file systems on the old LUN mounted or
otherwise used (even though that would be an obvious user mistake).


> =C2=A04. The previously disconnected paths come back, now serving volume
> B,
> =C2=A0=C2=A0=C2=A0 under a map built for volume A.
>=20
> The UA and the rescan don't help here, and no per-LUN 3f/03 is sent
> for
> those paths. That is the PURE-503945 case. It is the "something
> changed
> behind the initiator's back" scenario, and recheck_wwid detects it.
> purge_disconnected is meant to remove the stale paths before this can
> happen.
>=20
> > Thinking about this, it might make sense to switch from sysfs to
> > SG_IO
> > in udev rules if we observe a 3f/0e or 29/xx UA.
>=20
> =C2=A0- On Purity, sysfs VPD can be stale for these resurrected paths. Th=
e
> =C2=A0=C2=A0 kernel refresh depends on 3f/03, which isn't sent.
> =C2=A0- Using SG_IO after a 3f/0e or 29/xx UA is reasonable. On Purity it
> =C2=A0=C2=A0 would trigger on a path-level event that lands on an unrelat=
ed
> LUN.
> =C2=A0=C2=A0 So udev or multipathd can't rely on the event arriving on th=
e LUN
> =C2=A0=C2=A0 that changed.

Right. We'd basically have to rescan every device. Unfortunately,=C2=A0

1) writing to "rescan" updates the sysfs VPDs, but generates no uevent;
2) writing to /sys/host/scsi_host/host$X/scan (this is what "scan-scsi-
target" does) neither updates VPDs nor generates uevents;
3) the "inquiry" sysfs attribute is never updated, unless the LUN is
deleted and re-added.

I believe 1) and 2) could be fixed in a relatively simple way. 3) is a
problem, bug I guess we could live with it.

> =C2=A0- That favors verifying the WWID with SG_IO when a path is re-added=
,
> =C2=A0=C2=A0 as the patch does, rather than trusting sysfs or waiting for=
 a
> =C2=A0=C2=A0 per-LUN signal. recheck_wwid is a safety net for an operator
> mistake
> =C2=A0=C2=A0 that the array can't prevent. It isn't compensating for a no=
rmal
> =C2=A0=C2=A0 discovery gap, so the extra SG_IO is only exercised in the e=
rror
> =C2=A0=C2=A0 case.
>=20
> > Brian's patch would add more such ioctls and thus increase the
> > likelihood of observing a stall. To be observed.
>=20
> On stalls, I'm not aware of Purity stalling INQUIRY or VPD requests
> on
> healthy paths.

While you can speak for Purity only ;-) I suppose most storage arrays
would try to respond to INQUIRY quickly. But other things can happen.
Queues may be full, network timeouts may occur, and fabrics may be
overloaded.


Regards
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)

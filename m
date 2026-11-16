Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794867390;
	b=YmRe69B8m2wJcfiedk8mPrE+NC8hHbB05dUyTQRnQa2CQVFTU4l4kZnuOoix6G/eiAz7
	 1z+GJSWSPPtatN8GyO65oMhnIWenFEVDyeVd46Op3xyZEOUnecuRGwbN/py5qHaz/D78V
	 9Ju38KZGIWaXYkiM0BzUgQT9OuLz1r54/M6lk6ZXlcJmCFLwoXIKKHut8EAYD/qOA9glv
	 3jzQpmZ1GOndDa38NVjAYl70TD0wBc1ud4DxB+609F8lrzxBcr++toAEWpjrjpjgm02FS
	 LV+IyQMD4SSWinmArPf4NAel57uSOszUaK/uPX/Z/Zfn5sNDrEDRCbXjxaBjpc2g+pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794867390;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version:
	 X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=eWp4l2dRhYgjEDNq09g6ZZuF+6Bfwa/PVtwvHm3Kw6U=;
	b=j6TcLrA5DDigKPFJlbog8LdRdtXQlzfjviUzH30TufUdMGKYLVo8P6+j0sathmWw+4pe
	 3jePmLNS1Lgg3lk19R/jkFgLGf6yIE6rW2TRpR4XnyNLQ6ZaIsbk68n5nqj4WNWPPXVZX
	 z4WTimW+u0QFf+FHgWjpp7r1Hqk2xfylzQM1t4gKvMx51MHMniIMtXOQAvhbpNHnYmZIY
	 ZiZ6WYjdimZIpXdvCb2j3xOamBV9NRPjbopmiEGUHwOPMG94H+Z/9+D+eDqEXL8cuNlua
	 n6ecNissafMlMTmgQ6jYg8bDxKc1DPz9nObppIS7tfMkK43s5X9JfTbXQXZu3LTCSxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=kYvdHbu+;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=dHXivgM8;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB168606A31C
	for <dm-devel@lists.linux.dev>; Mon, 16 Nov 2026 22:16:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB168606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=kYvdHbu+;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=dHXivgM8
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DA2F52230A;
	Mon, 16 Nov 2026 22:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794867388; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eWp4l2dRhYgjEDNq09g6ZZuF+6Bfwa/PVtwvHm3Kw6U=;
	b=kYvdHbu+y7fgk7BRmmVQ1GJcZpG++gnjpLlIMDXvtC18P9tZORYUNj8W7d0agA5cjdvmCv
	CfiH5EgXcOW79z7QlGdlzeyKqc8KUrhPtG7IPyHGGbDNp45y2FCu/ENPX8TnUuIklnUBGn
	qPlcpVxGvjMwmV8jg6Ck0ptJGGrZhGA=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794867386; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eWp4l2dRhYgjEDNq09g6ZZuF+6Bfwa/PVtwvHm3Kw6U=;
	b=dHXivgM8IBAjQ7Eg7KPBJmoS2qtIrucgm+Rn8x3tXhJodikCdOfa/E2dWl9EsfgVOSkyD9
	eXHi9Ldwqtq5hSCVcYB6cB5NrbqXg3cC6+SlAbWu2p6zH2Y8RF8GsL+XOwQVDVGrdtGbpV
	NmmXe2uHuT/RZgnSr043rePpnNVjUUE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 92E2913408;
	Mon, 16 Nov 2026 22:16:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3RHjGrqA+2qAVQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 16 Nov 2026 22:16:26 +0000
Message-ID: <d372e820111fc6e5739c276ce8797382f9f4947f.camel@suse.com>
Subject: Re: udev / multipath-tools: WWID determination with SG_IO vs. sysfs
From: Martin Wilck <mwilck@suse.com>
To: Brian Bunker <brian@purestorage.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke
 <hare@suse.com>,  Christophe Varoqui <christophe.varoqui@opensvc.com>,
 dm-devel@lists.linux.dev
Date: Mon, 16 Nov 2026 23:16:26 +0100
In-Reply-To: <20261116183901.23474-1-brian@purestorage.com>
References: <20261109185556.27139-1-brian@purestorage.com>
	 <214d18ebabeca8318352dfa5456bc5b37cdefdeb.camel@suse.com>
	 <20261111174259.41911-1-brian@purestorage.com>
	 <cad66f75079fe0a89150e304d753527f140c67d9.camel@suse.com>
	 <20261111230535.12947-1-brian@purestorage.com>
	 <83f73b9cb1506eb80220759e3e0aae18648f80c4.camel@suse.com>
	 <20261113194358.35028-1-brian@purestorage.com>
	 <e246cb25f06744a1610ee1d78e033d6ecb17a31d.camel@suse.com>
	 <20261116183901.23474-1-brian@purestorage.com>
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
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.30

On Mon, 2026-11-16 at 10:39 -0800, Brian Bunker wrote:
> On Fri, 2026-11-13, Martin Wilck wrote:
> > > 3. The array sends 3f/0e as usual, and the rescan runs. The sd
> > > =C2=A0=C2=A0 devices for that H:C:T:L still exist, so there is nothin=
g to
> > > add.
> >=20
> > Why does this happen after 2.)? Wouldn't the array send 3f/0e
> > immediately after 1.)? If your "purge" functionality was active in
> > multipathd, and/or if the libstoragemgmt udev rules were enabled,
> > the
> > SCSI device would be deleted.
>=20
> Yes, the array sends 3f/0e after 1 as well. My sequence was wrong to
> show it only after 2.
>=20
> That UA doesn't lead to cleanup, though. The libstorage-mgmt rule
> only
> adds devices for new LUNs and never removes any, so after step 1 the
> SCSI device is still there.

Yeah, the libstorage-mgmt rule is very simplistic. It only writes to
the "scan" sysfs attribute, which keeps the existing SCSI devices in
place. As I wrote before, it also does not do a rescan.

I think we could improve on that.

> Purge is driven by the checker. It acts only when a checker run
> observes the disconnected state. If volume B is connected at the same
> LUN number before the next checker run, the checker never sees the
> LUN
> gone. It sees a healthy path that now reports a different WWID. The
> array can't prevent that, because the host-side cleanup is
> asynchronous
> and tied to checker intervals.

Right.

>=20
> I agree that it is a user mistake. Within that window, comparing the
> WWID against the device is the only check, and that is what
> recheck_wwid does.
>=20
> > 1) writing to "rescan" updates the sysfs VPDs, but generates no
> > uevent;
> > 2) writing to /sys/host/scsi_host/host$X/scan (this is what
> > "scan-scsi-target" does) neither updates VPDs nor generates
> > uevents;
> [...]
>=20
> That matches what we see: the UA-triggered scan adds devices but
> doesn't refresh VPD for existing ones. For a reused LUN number, sysfs
> VPD stays stale until something rescans that device. Fixing 1) and 2)
> would help the udev side. Until then, SG_IO is the reliable check in
> multipathd.
>=20
> > While you can speak for Purity only ;-) I suppose most storage
> > arrays
> > would try to respond to INQUIRY quickly. But other things can
> > happen.
> > Queues may be full, network timeouts may occur, and fabrics may be
> > overloaded.
>=20
> Agreed, and that is why I'm happy with Ben's suggestion to run the
> check
> only on paths that are up.

Ok.

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)

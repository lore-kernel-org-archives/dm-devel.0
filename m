Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794867547;
	b=DMBvUYbaSLCjeUhKoYkLtGvIjQ/DygfBGDLRtHyg+9xYUoITrvUGrlD6nCru9rbXtAhy
	 zxKmDtm5RG+dg876vOGSGEccdxPu7H3SdHRlEwu9dGUTW1jZIHBxYEMFf7/2yzVXKbXxh
	 T2Lx9BQOcX5irk+xJL6OuHqiDOjHvQ9RfuMunR/RycLGxT3VJLh/hhYCVfxluqAxVIU5J
	 TLFsMsQ5LZby57UB17bhy8bgBWZ0r4e9XCZKB7bTTJVnUfbs50h9np3y6gsrj58eBZsXZ
	 neyZV3eCvYhuYiLBMqF0rAGlWlpbzMa4KjuvTcgW8stVL9xYqfoqjMLskzKk8Im4Ocg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794867547;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version:
	 X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=nf/fQJkPXGPTbj3vLN0byaMiLogY7MBa4VhcUmogGwk=;
	b=okc/RyfHp2+beJmklNapGe29EH8RPCBMgBYH8vt9s/orTuaa/2ECd7ZkFQNjh0hjamfm
	 4XtVEjP9imXk69vePMsGxjAVssBYgOiEw+oWHNvI0V8TsZGA2g2mjJWaT2Mkaj0hO2ERI
	 L+UCm2bqnxwp8qH66JP8enn8czoDE9cIslO4LvAAA7WmipUSTsv7ji/pZXgiE84j+WLDX
	 88luiRfg11+eNv0uzVCm6R8kGOS7rruNF26UT9TMHFqQM2nbTcDPn4RBCHk5IvUx8Vd52
	 KlQf84zo6KvGnjUTHpzl+g1yT62xLmxiC9cVbJJREQjPGwuWMP0a/3eN0TPHOTOltpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=QNEnXRMm;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=QNEnXRMm;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD26606A31C
	for <dm-devel@lists.linux.dev>; Mon, 16 Nov 2026 22:19:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BD26606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=QNEnXRMm;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=QNEnXRMm
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C472E1F790;
	Mon, 16 Nov 2026 22:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794867544; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nf/fQJkPXGPTbj3vLN0byaMiLogY7MBa4VhcUmogGwk=;
	b=QNEnXRMmHJXqEVzYc4k/gCfVjIhseuVvNfBvIoSZOEXKO5K6i+5PwPOjjJ+nWRcF3fNk/+
	9WCXqXgWbdkWWl1LGGbY+U9hUtcNanxNto92Q4U7k83VZfcnT+G5MEi51XTtq/4pF8PTaF
	y5mFopy4fNsLfJOtrAsjqLxfm3JtTZk=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=QNEnXRMm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794867544; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nf/fQJkPXGPTbj3vLN0byaMiLogY7MBa4VhcUmogGwk=;
	b=QNEnXRMmHJXqEVzYc4k/gCfVjIhseuVvNfBvIoSZOEXKO5K6i+5PwPOjjJ+nWRcF3fNk/+
	9WCXqXgWbdkWWl1LGGbY+U9hUtcNanxNto92Q4U7k83VZfcnT+G5MEi51XTtq/4pF8PTaF
	y5mFopy4fNsLfJOtrAsjqLxfm3JtTZk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 845751334C;
	Mon, 16 Nov 2026 22:19:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +xpXF1iB+2pFWAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 16 Nov 2026 22:19:04 +0000
Message-ID: <e4288e6567770a818351dd46ff7a35058aad02ef.camel@suse.com>
Subject: Re: [PATCH v4 1/1] multipathd: recheck WWIDs of re-added paths with
 the device
From: Martin Wilck <mwilck@suse.com>
To: Brian Bunker <brian@purestorage.com>, Benjamin Marzinski
	 <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Mon, 16 Nov 2026 23:19:04 +0100
In-Reply-To: <20261116184308.24727-1-brian@purestorage.com>
References: <20261111181642.51912-1-brian@purestorage.com>
	 <20261111181642.51912-2-brian@purestorage.com>
	 <179452227264.147392.9708937185980533136.b4-review@b4>
	 <avdQNjzddtu7o18n@redhat.com>
	 <9259d20188a042cb280bad95f8be9783d1b9c1fd.camel@suse.com>
	 <20261116184308.24727-1-brian@purestorage.com>
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
X-Rspamd-Queue-Id: C472E1F790
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
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	URIBL_BLOCKED(0.00)[suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -13.51

On Mon, 2026-11-16 at 10:43 -0800, Brian Bunker wrote:
> Martin, Ben,
>=20
> Before I post a v5, here is where I stand on the open points, so we
> can
> agree on a direction first.
>=20
> On Fri, 2026-11-13, Martin Wilck wrote:
> > We need to trust udev at some point, don't we?
>=20
> Yes, and checking once is intentional: the check is meant to catch a
> stale or wrong uevent, and the retriggered event carries fresh data.
>=20
> In the code, uev_update_path() sets needs_reinit in two places: for
> INIT_REQUESTED_UDEV, and for a changed udev WWID. I would pass
> PATH_ADD_REINIT only from the changed-WWID branch. The retriggered
> event
> then takes the normal path and trusts udev. No new init states or
> flags
> are needed, and a persistently wrong ID_SERIAL can't cause repeated
> checks.
>=20
> > Yet another possibility is to introduce a new mode where we just
> > never
> > trust udev.
>=20
> I would keep that out of this patch.

Of course, that would be a major refactoring.

> It would add SG_IO calls to every
> event, which is the stall risk you raised, and it deserves its own
> discussion and data. It could become a value of recheck_wwid later.
>=20
> > In my mind, a changed WWID followed by a failure to obtain the WWID
> > from the device shows that something is really fishy about the path
> > in question.
>=20
> For this patch I side with Ben: if the check fails, trust what udev
> gave
> us. A failed SG_IO on a path suggests the path is unhealthy, and
> recheck_wwid will recheck it when it comes back up. Allowing a
> fallback
> to SG_IO in get_uid() when udev fails seems reasonable to me as a
> separate change.
>=20
> > I suppose we could rescan asynchronously in this case.
>=20
> I support that as a follow-up.

Yes, that needs more thought. I didn't mean to say you should add it.

>  On Purity, scan-scsi-target doesn't
> refresh VPD for existing devices, so an explicit rescan is the only
> way
> to correct stale sysfs data. I would rather not add it to this patch,
> because it touches the regular changed-WWID path in
> uev_update_path().
>=20
> So for v5 I plan to:
>=20
> =C2=A0- lower the log level of the new message to 2 or 3,
> =C2=A0- set pp->tick =3D conf->retrigger_delay, as pathinfo() does,
> =C2=A0- limit the check to paths that are up, as Ben suggested,
> =C2=A0- pass PATH_ADD_REINIT only from the changed-WWID branch.
>=20
> Does that match what you have in mind?

I am fine with this plan. Thanks for your patience!

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)

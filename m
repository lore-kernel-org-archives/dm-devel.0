Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D03C3EA93
	for <dm-devel@lists.linux.dev>; Wed, 31 Jan 2024 20:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706731949; cv=none; b=o2gL9R5MBBjZuGTkG/X08eohRvJGrs3JeAkKE91n3183HvL9VKIhyFhxVApoGZVg/kAzG8ymiYjUN8gnmjU/oa1Fw10IjdSZGrgKU5lfdcuovI4qZP4OmRoEh0H9Wgl6Ujeej+XV+qy4uLscBtq4K7ASD8Z4gYQr1VBVxEm2GTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706731949; c=relaxed/simple;
	bh=1wQJhci+ISyoVwZzqwRP1Jr0KinlsVcnZVY9hk3msMA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HZDZEf4y2mg4z2CzK+OXuEgJDhPqlsuwGggBtqcSzNFGNxSb0hT0/7Vt1hfQ5tbJk4QUyFBAoILlUa7xRorMJ6Ui18VHA/I6gZdO52pgp0wtpmPPA5DVC308L8dvxdBjQubpVSYjxWY0zlNyvusvZip4McKUOiVp6e2M1tJUuL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KVgOeQu9; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VVdcNCzJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KVgOeQu9";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VVdcNCzJ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C89B122061;
	Wed, 31 Jan 2024 20:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1706731945; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dWwhShJ9kuiCjSs5Ixfk1wvHZhlipyxQgCbsmkY3Lfk=;
	b=KVgOeQu98geReKAfXsKg9E539g9+Hkd1xiqxrHDqjHOuZ7C41FSDTOANrUkPFwPvYbkLxi
	pummnRd7BWPtO9cmqOv2fmh91DbZUQgG1MJ2zLBpwn3evjEgkpILyumrsuigmkiPwlIjQx
	gUoj8/8A2KB1GkjWoWXatQRkLwVxgK4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1706731944; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dWwhShJ9kuiCjSs5Ixfk1wvHZhlipyxQgCbsmkY3Lfk=;
	b=VVdcNCzJZSIj7DhJrQIOTAbQ1oApJAcb75seQ+DVxl37fKWR9hYEUdbw29nOf078f/YFTJ
	OIP46cGtl+wn1mLRTG+vRbR2ekwChMxGmerkw3eIDN5aL88f46tgZvpdGUp+FZCnKQk0uo
	mAvRqZr6R6Oh9LbOePQFYH4moBJW8tQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8C1E2139B1;
	Wed, 31 Jan 2024 20:12:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PHKfH6ipumUeXwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 31 Jan 2024 20:12:24 +0000
Message-ID: <cae20ba154c77d7ba99f8eab0b47b93d76a9c953.camel@suse.com>
Subject: Re: [PATCH] multipathd: the sysfs prioritizer can return stale data
From: Martin Wilck <mwilck@suse.com>
To: Brian Bunker <brian@purestorage.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev, 
	Seamus Connor <sconnor@purestorage.com>
Date: Wed, 31 Jan 2024 21:12:23 +0100
In-Reply-To: <9F411A14-251E-42B3-BF1B-7EAFE860B6CF@purestorage.com>
References: <20240124020007.25259-1-brian@purestorage.com>
	 <ZbkmuqWetsaOPMkC@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
	 <4dd466445f477e1991267edf30b16364af021f53.camel@suse.com>
	 <22BFA8ED-7AA4-41C4-9253-3B2846301BFF@purestorage.com>
	 <2f0e15e5672f3d9f665491b40cfdada4cd9c36c2.camel@suse.com>
	 <9F411A14-251E-42B3-BF1B-7EAFE860B6CF@purestorage.com>
Autocrypt: addr=mwilck@suse.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=VVdcNCzJ
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-6.51 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[4];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 DWL_DNSWL_MED(-2.00)[suse.com:dkim];
	 BAYES_HAM(-3.00)[100.00%];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.com:s=susede1];
	 DKIM_TRACE(0.00)[suse.com:+];
	 MX_GOOD(-0.01)[];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Score: -6.51
X-Rspamd-Queue-Id: C89B122061
X-Spam-Flag: NO

Hi Brian,

On Wed, 2024-01-31 at 09:45 -0800, Brian Bunker wrote:
>=20
>=20
> > On Jan 31, 2024, at 2:19=E2=80=AFAM, Martin Wilck <mwilck@suse.com> wro=
te:
> >=20
> > Hi Brian,
> >=20
> > On Tue, 2024-01-30 at 10:43 -0800, Brian Bunker wrote:
> > > >=20
> > > > A full rescan shouldn't be necessary. All that's needed is that
> > > > the
> > > > kernel issue another RTPG. AFAICS that should happen as soon as
> > > > the
> > > > target responds to any command with a sense key of UNIT
> > > > ATTENTION
> > > > with
> > > > ASC=3D0x2a and ascq=3D6 or 7 (ALUA state change, ALUA state
> > > > transition
> > > > failed).
> > > >=20
> > > > @Brian, does your storage unit not do this? If so, I suggest we
> > > > disable
> > > > the sysfs prioritizer for pure storage.
> > > >=20
> > > > Otherwise, as far as multipathd is concerned, when a path is
> > > > reinstated, it should be sufficient to send any IO command to
> > > > trigger
> > > > an RTPG. Or am I missing something here?
> > > >=20
> > > > Martin
> > >=20
> > > Martin,
> > >=20
> > > What I am gaining with the rescan is exactly that. You are
> > > correct
> > > the ALUA device handler the kernel has to send an RTPG to the
> > > target.
> > >=20
> > > We do set a unit attention to have the initiator paths go into
> > > the
> > > ANO state before we reboot leading to the path loss, but we do
> > > not
> > > set a unit attention when the paths come back up.
> > >=20
> > > We have relied on the initiator=E2=80=99s polling to pick up the ALUA
> > > state
> > > change which they always have in the past and the =E2=80=98alua=E2=80=
=99
> > > prioritizer
> > > still will. For us to add a unit attention would work, but there
> > > are
> > > couple of issues with that.
> > >=20
> > > 1. Unit attentions may not get back to the initiator. It is not
> > > guaranteed.
> >=20
> > That's news for me. If that happens, wouldn't it mean that the
> > initiator sees a timeout (no response) to some command, IOW that
> > there's still something very wrong with this I_T nexus?
> Probably. My point is just that any individual response could be lost
> wherever and there is no burden on the target to ensure the initiator
> got the unit attention.

Right. In the specific case of the ALUA-related UAs that we've been
discussing, the storage *might* implement a logic to repeat responding
with UA until an RTPG is received. But that may have  unwanted side
effects; I haven't thought it through.

> >=20
> > > 2. Paths could take a very long time to come back. We might not
> > > get
> > > these paths back for a very long time. Sometimes it is just a
> > > reboot.
> > > Other times it is a hardware replacement. It is possible for us
> > > to
> > > keep this state forever and post when when that I_T nexus returns
> > > but
> > > we haven=E2=80=99t had to.
> >=20
> > No offense, that sounds somewhat lazy ;-) Note that it's also kind
> > of
> > dangerous. You are hiding the state change from the initiator. If
> > the
> > Linux kernel decided to use the access_state device attribute for
> > anything else but feeding the sysfs attribute, things might go
> > badly
> > wrong.
> That is fair. We definitely could do better here. In general, that
> unit
> attention coming out of the preferred state didn=E2=80=99t buy us any spe=
ed.
> Those non-preferred paths weren=E2=80=99t serving I/O so the first I/O th=
at
> would pick up the unit attention on those paths would be the path
> checker. The same run of the path checker picked up the new ALUA
> state. When going into the preferred state, there is read and write
> I/O which means those unit attentions are picked up very quickly and
> the ALUA state change is picked up in the kernel before the checker
> runs again.
>=20
> Have you ever considered a checker of RTPG as opposed to TUR?
> That would seeming solve a lot of this too since you would be getting
> path state and priority in the same trip.

Interesting idea. AFAICT, noone has thought about it so far. In the
past I've invested some thought in tieing  checker and prioritizer more
closely together. Unfortunately, the current multipathd architecture
treats them as entirely separate, which makes it complicated to achieve
this.

> >=20
> > > If we did post the unit attention, everything works as expected.
> > > I
> > > have verified this, but I would also hope that the polling of the
> > > checkers would also unstick my stale ALUA state and we won=E2=80=99t =
have
> > > to.
> > >=20
> > > I put this rescan_path inline to show the problem and the fix. I
> > > wasn=E2=80=99t sure the =E2=80=98right=E2=80=99 place to put it. I ge=
t that it would be
> > > better not to block on this. It should be possible to put this in
> > > a
> > > thread so that it does not. The other caller of rescan_path I
> > > guess
> > > is also doing the same thing when it is handling the wwid change.
> >=20
> > That's true and not optimal, but wwid changes are rare events and
> > an
> > error condition in its own right. Patches converting moving
> > rescan_path() into a thread would receive sympathetic reviews :-)
> > The big benefit of the sysfs prioritizer is that it never blocks,
> > without needing pthreads complexity.
> >=20
> > Btw, I think you'd need to wait for the RTPG to finish after
> > triggering
> > the rescan, if you want to obtain the right priority (alua_rescan()
> > ->
> > alua_initialize() -> alua_check_vpd() will only queue an RTPG and
> > not
> > wait for the result).
> For our purposes we didn=E2=80=99t really need to wait for the rescan. As
> long as
> it happened. The next time the checker ran it would pick it up. These
> paths
> returning for us are redundant paths. We want them back as soon as
> possible
> but we have other paths that can serve I/O while waiting for the HA
> paths.
>=20
> I can create a patch in the sysfs prioritizer to do the rescan_path
> in a thread
> that the checker and priority run doesn=E2=80=99t wait on. Would that be =
well
> received
> or I am better served by either posting a unit attention or just
> using detect_prio
> set to no and leaving the =E2=80=99sysfs=E2=80=99 prioritizer alone?

I am not sure. Like I said, the beauty of the sysfs prioritizer is that
it doesn't do any IO. rescanning a device from this prioritizer
basically voids this benefit. You might as well just use alua.
As I said, we do it for RDAC as well.

But if you want to invest more effort, feel free to submit patches ;-)
You can do this any time on top of the hwtable change.

> > Unfortunately, the kernel has no API for manually triggering an
> > update
> > of the access_state. I believe that would be useful elsewhere, too.
> > We
> > can consider adding it, but it won't help with current kernels.
> >=20
> > IMO the best option for your storage arrays would is to force using
> > the
> > alua prioritizer rather than the sysfs one. You are not alone,
> > we're
> > doing this for RDAC already (see check_rdac() call in
> > detect_prio()).
> > This can be configured in multipath.conf right now by setting
> > "detect_prio no" and "prio alua", and we can make it the default
> > for
> > your storage with a trivial patch for hwtable.c.
> This is what we are doing now in our recommended configuration. I
> will
> probably add a patch for our hw table entry soon. It is a bit strange
> to
> me still that detect_prio would mean replace the one that I am
> explicitly
> stating in the device section. To me detect_prio would be if I didn=E2=80=
=99t
> provide one and wanted multipath to choose for me.

True. The design of the "detect_prio" option is awkward and confusing.
It happens all the time that people set "prio" and wonder why the
setting isn't applied. Or worse, they think it is applied but it's not.
I think the original idea was to use ALUA whenever supported, even if
historically the hwtable contained something else for a given storage.
It has been this way for a long time, I don't think we can change the
semantics easily.

Regards
Martin

> >=20
> > Regards
> > Martin
> >=20
> Thanks,
> Brian
>=20


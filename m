Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794868076;
	b=uJ9nvybXbVgjCij7E/LwhV7hNFzhbop/5eKhv/CWEWDZRM9NVVkPPZMnm+9ygePi8/pW
	 eWH2YrmvtUCllgXyLd2DYjaFCMcM5U0vzAHYpWLqQ2B2tufnKrRCZw7OTuDTZAYSh0ikS
	 bka5E/y4Yy+rzm42lYcE1XzgaQjWzE/tUZ6AXWGYaLwRjezBB0sIl/iWZwJ/GjKf4Nvny
	 RyNetvCB8h7NBcDRRE34+qLeBpZ+Ag90dMwF91KXzN+F90t07E1n1PG/cwICgS4+XyYYs
	 95CdhA2TKXlQdwmjRf9l96DwS9aOpQQKebmIIn1+WKITfmlzRWpYoZ0AKpglmMGvaaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794868076;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version:
	 X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=lU6E3cQ0M3/qoqi1WznKgzxDzoIK6euoJWfqeTh0fBI=;
	b=OEIp3CVI2ZUz+WWqxEEPo4RsdAYeladJwEQcnM7sJznJU4iMG0hkaxwD3s29IzVbhyBG
	 sdhySjk52cOulYe44sKj3fOjhd4fNQ2VzWyfgbrk5Z0DDzM4sFQGKmKRYUW5M+2B0VYKs
	 FlEQ6vqcwAtJvRAJWQ20v4u1S0Qwdz61V0UWrKwq3NsEiJ0KyVEfFjrK2ILWwbTy6U9/A
	 Y94ZdrHgtfxNKaY4teCQjy6dvh+e9dNyOSMwUOC9kJyUvQynEZcpI8Lwt6+8S+bNkcfcE
	 7qfZpvGboB5CbIj+2kxbn/HlCZMpYFqxHrRyDRtNPxNcWQfIdylI3XsXRD4aUSC12YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=GprXpXpg;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=GprXpXpg;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AE8606A889
	for <dm-devel@lists.linux.dev>; Mon, 16 Nov 2026 22:27:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80AE8606A889
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=GprXpXpg;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=GprXpXpg
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8E74222344;
	Mon, 16 Nov 2026 22:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794868072; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lU6E3cQ0M3/qoqi1WznKgzxDzoIK6euoJWfqeTh0fBI=;
	b=GprXpXpgvKtYOv14YuDz5l9KzsTk/Zyqd7Iv2kqRTPBBr5O5Sfa1rcvcKifSNolIUaMt5v
	WV5mkk+pVXGZl425T1KZaWC+P+rj+ZGOlItgcvFGFTO6qEf4ikUi1O8KGHoS+hlMWGlIPm
	5RMPSXEWnfJp1Fb2lzT4fgnSb91EkYk=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=GprXpXpg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794868072; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lU6E3cQ0M3/qoqi1WznKgzxDzoIK6euoJWfqeTh0fBI=;
	b=GprXpXpgvKtYOv14YuDz5l9KzsTk/Zyqd7Iv2kqRTPBBr5O5Sfa1rcvcKifSNolIUaMt5v
	WV5mkk+pVXGZl425T1KZaWC+P+rj+ZGOlItgcvFGFTO6qEf4ikUi1O8KGHoS+hlMWGlIPm
	5RMPSXEWnfJp1Fb2lzT4fgnSb91EkYk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4DD181334C;
	Mon, 16 Nov 2026 22:27:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iA5dCWiD+2ouYQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 16 Nov 2026 22:27:52 +0000
Message-ID: <1a6a0493ef4f510a047647db2385cf89f7424b68.camel@suse.com>
Subject: Re: [PATCH v4 1/1] multipathd: recheck WWIDs of re-added paths with
 the device
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Brian Bunker <brian@purestorage.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, dm-devel@lists.linux.dev
Date: Mon, 16 Nov 2026 23:27:51 +0100
In-Reply-To: <avtdexYN1B3pJLmL@redhat.com>
References: <20261111181642.51912-1-brian@purestorage.com>
	 <20261111181642.51912-2-brian@purestorage.com>
	 <179452227264.147392.9708937185980533136.b4-review@b4>
	 <avdQNjzddtu7o18n@redhat.com>
	 <9259d20188a042cb280bad95f8be9783d1b9c1fd.camel@suse.com>
	 <avtdexYN1B3pJLmL@redhat.com>
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
	URIBL_BLOCKED(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 8E74222344

On Mon, 2026-11-16 at 14:46 -0500, Benjamin Marzinski wrote:
> On Fri, Nov 13, 2026 at 09:52:23PM +0100, Martin Wilck wrote:
> > On Fri, 2026-11-13 at 13:00 -0500, Benjamin Marzinski wrote:
> > > On Thu, Nov 12, 2026 at 11:24:32PM +0100, Martin Wilck wrote:
> > > >=20
> > > > > =C2=A0=09}
> > > > > +=09/*
> > > > > +=09 * This path is being re-added because its udev data
> > > > > was
> > > > > missing or
> > > > > +=09 * changed. The uevent may have been queued long
> > > > > before
> > > > > we got here,
> > > > > +=09 * and adding a path to the map of a different LUN
> > > > > corrupts data. If
> > > > > +=09 * recheck_wwid is set, confirm the WWID with the
> > > > > device
> > > > > first. On a
> > > > > +=09 * mismatch, leave the path out and let the checker
> > > > > retrigger udev
> > > > > +=09 * to get a fresh WWID.
> > > > > +=09 */
> > > > > +=09if (mode =3D=3D PATH_ADD_REINIT && pp->recheck_wwid =3D=3D
> > > > > RECHECK_WWID_ON &&
> > > > > +=09=C2=A0=C2=A0=C2=A0 check_path_wwid_change(pp)) {
> > > >=20
> > > > check_path_wwid_change() returns false when it fails, is it
> > > > correct
> > > > to keep the
> > > > path in that case? IMHO we should treat this like the
> > > > strlen(pp-
> > > > > wwid) =3D=3D 0 case
> > > > above.
> > >=20
> > > Not sure I agree with this. It's a paranoia check. If it fails, I
> > > don't
> > > have a problem with just trusting the data that was given to us.
> > > I'm
> > > willing to be convinced otherwise, however.
> >=20
> > In my mind, a changed WWID followed by a failure to obtain the WWID
> > from the device shows that something is really fishy about the path
> > in
> > question.
> >=20
> > Moreover:=C2=A0
> >=20
> > I realize that uev_update_path() calls get_uid() with
> > allow_fallback=3D0.
> > This goes back to your commit ffaf947 ("multipathd: Don't use
> > fallback
> > code after getting wwid"), where the rationale you provided was=20
> >=20
> > > once the
> > > devices are set up, udev is the definitive source of this
> > > information
> > > ...
> > > Working under the assumption that udev will either never give us
> > > this
> > > information, or that it usually will.=20
> >=20
> > We have given up this assumption, at least partly. In view of the
> > late
> > discussions, it seems reasonable to me to allow fallback to SG_IO
> > if
> > udev failed, at least if pp->wwid was non-zero before.
> >=20
> > Then, if the fallback failed, the situation would really be almost
> > identical to the failing paranoia check.
>=20
> I wrote my objection assuming that this code would also be called
> when
> when we simply hadn't gotten the WWID on the first uevent. If we
> retrigger a uevent and then get the WWID, but the SG_IO fails, we
> could
> end up not creating the multipath device at all, despite the the path
> existing with a WWID (albeit with some issues). Perhaps that's the
> correct answer for an obviously flakey device. If this code was only
> run
> when we got a wwid before and then it changed, then requiring a
> matching
> WWID from the device seems much more reasonable.=20
> =C2=A0
> > >=20
> > > makes sense.
> > >=20
> > > > But more generally: as this indicates a possible mismatch
> > > > between
> > > > kernel and device
> > > > state, should we handle this similar to=C2=A0
> > > > handle_path_wwid_change()
> > > > instead,
> > > > i.e. also call rescan_path()? I guess that would need to be
> > > > done in
> > > > uev_update_path(),
> > > > i.e. it would touch the regular "wwid changed in uevent" path.
> > >=20
> > > Is this not another place were we are opening ourselves up for
> > > commands
> > > blocking? If we want to do a rescan and it can block, it makes
> > > more
> > > sense to do it only if recheck_wwids is set, and we know that the
> > > path
> > > is up.=20
> > >=20
> >=20
> > Right, I didn't consider that rescan_path() may block. But still,
> > why
> > do we need to rescan in handle_path_wwid_change(), but not here?=C2=A0
> >=20
> > AFAICS, the likelihood that the kernel is using stale information
> > is
> > quite high when we handle this situation. I'm not sure if testing
> > whether the path is up makes much sense. There are many situations
> > in
> > which the path would be down, but rescan/inquiry would still work.
> > The
> > only thing that would really hurt us are timeouts during the
> > kernel's
> > probing procedure, but I am not aware of an easy way to predict
> > whether
> > that will happen.
> >=20
> > I suppose we could rescan asynchronously in this case. After all,
> > we
> > already have obtained the real WWID from the device, therefore we
> > don't
> > need to wait for the rescan to finish.
>=20
> I'm not against the rescan, I just thought it made more sense in
> ev_add_path(), although running it asynchronously works too.

For now, doing it in ev_add_path() is fine. It's conditional on the
recheck_wwid option, anyway.


> > > > >=20
> > > > > +=09}
> > > > > =C2=A0=09mpp =3D find_mp_by_wwid(vecs->mpvec, pp->wwid);
> > > > > =C2=A0=09if (mpp && pp->size && mpp->size !=3D pp->size) {
> > > > > =C2=A0=09=09condlog(0, "%s: failed to add new path %s,
> > > > > device size mismatch", mpp->alias, pp->dev);
> > > > > @@ -1375,7 +1390,7 @@ rescan:
> > > > > =C2=A0=09if (ro =3D=3D 1)
> > > > > =C2=A0=09=09mpp->force_readonly =3D 1;
> > > > > =C2=A0
> > > > > -=09if (!need_do_map)
> > > > > +=09if (mode =3D=3D PATH_ADD_NO_MAP)
> > > > > =C2=A0=09=09return 0;
> > > > > =C2=A0
> > > > > =C2=A0=09if (!dm_map_present(mpp->alias)) {
> > > > > @@ -1789,7 +1804,7 @@ out:
> > > > > =C2=A0=09}
> > > > > =C2=A0=09/* pp->initialized must not be INIT_PARTIAL if
> > > > > needs_reinit is set */
> > > > > =C2=A0=09if (needs_reinit)
> > > > > -=09=09retval =3D uev_add_path(uev, vecs, 1);
> > > > > +=09=09retval =3D uev_add_path(uev, vecs,
> > > > > PATH_ADD_REINIT);
> > > >=20
> > > > Is it correct to take this branch also if needs_reinit is set
> > > > because
> > > > INIT_REQUESTED_UDEV was set? I don't think so.
> > >=20
> > > This is a little tricky. I agree that we don't need to add the
> > > extra
> > > layer of paranoid checking when the path never got a wwid. In
> > > that
> > > case,
> > > what most likely what happened is that the udev worker thread
> > > timed
> > > out
> > > on the previous uevent, so we couldn't get the WWID from uevent
> > > variables. However, if we don't recheck on INIT_REQUESTED_UDEV,
> > > then
> > > we
> > > can get into a situation where:
> > > 1. uev_update_path() notices that the wwid has changed
> > > 2. ev_add_path() confirms that the wwid we got from udev doesn't
> > > match
> > > =C2=A0=C2=A0 the wwid we get directly asking the device
> > > 3. We trigger a new uevent
> > > 4. We blindly trust udev's wwid.
> >=20
> > We need to trust udev at some point, don't we? Assume
> >=20
> > 4. we double check again=C2=A0
> > 5. ev_add_path() confirms that the wwid we got from udev doesn't
> > match
> > 6. goto 3=C2=A0
> >=20
> > At least we'd need to avoid getting stuck in a loop.
>=20
> This will only loop for retrigger_tries. Then it will give up and
> trust
> udev without double-checking. Athough we never reset pp->retriggers
> once
> we have a reasonable WWID, so we only get retrigger_tries for the
> entire
> lifetime of the path. It seems like the retries when we couldn't get
> a
> WWID from udev are different than the retries when the WWIDs don't
> match.

Right, I forgot about retrigger_tries. Thanks for the correction.

About the different types of retrigger_tries - yes, we use the same
counter, and actually the entire "retrigger" logic, for two different
things now. I don't see an issue with resetting retrigger_tries once
the issues with path's WWID are sorted out, in both cases.

> =C2=A0
> > AFAICS there are 2 reasons to do the SG_IO check:
> >=20
> > 1) vpd info from sysfs may be stale (affects SUSE only)
> > 2) something changed between the VPD detection in udev rules and
> > our
> > event handling
> >=20
> > Then there is
> >=20
> > 3) a bug e.g. in an udev rule causes ID_SERIAL to be consistently
> > wrong.
> >=20
> > Case 1) would be fixed triggering a rescan (see above). In case 2),
> > it
> > makes a certain amount of sense to trust udev the next time. Case
> > 3)
> > would cause an infinite loop if we keep double-checking.
> >=20
> > > Perhaps we need more initialization states or a path device flag
> > > to
> > > distinguish between the two cases (never having gotten a WWID, or
> > > having
> > > our WWID . Or we can decide that we are o.k. with extra checking
> > > whenever something goes wrong with getting the wwid from udev
> > > (when
> > > you
> > > have recheck_wwid set). Or am I misunderstanding something about
> > > why
> > > doing this is wrong? Are we intentionally only double-checking
> > > once
> > > here?
> >=20
> > I don't like the idea of checking the first time around very much,
> > but
> > I agree it isn't a big deal. OTOH, see above.
>=20
> If it's fine to only do one double-check before trusting udev, then
> PATH_ADD_REINIT is just for that one recheck, and what to do in that
> case is less ambiguous.
> =C2=A0
> > Yet another possibility is to introduce a new mode where we just
> > never
> > trust udev. That'd be a 180" turn, but it might be worth trying.
> > The longer we discuss this, the more attractive it seems to me.
> > Rather
> > than guessing whether or not we can trust udev, just use a "zero
> > trust"
> > model :-)
>=20
> I wouldn't be against it. Device WWIDs could potentially switch
> between
> modes. But as long as users know that they would need to be careful
> when
> switching modes, that should be fine. Were you thinking of always
> getting the wwid through SG_IO, or were you thinking of using
> something
> like sysfs that could still potentially give you a stale value?

I had SG_IO in mind, but I haven't thought it through. That would be
large change, so we might as well provide both options.


Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)

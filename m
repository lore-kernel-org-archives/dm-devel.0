Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794603147;
	b=RnashhozYEYJ1NkHfYQpgy+bc5u9O/cZ5FZZ0G32yke/nfyRaZkdnWZNCJnQVw8epbyu
	 LCGdj4pX18w8UtwCdtz3/pX8DJJSmguwG5HzFpUSLMKwPojBekqqxdwq2eXNu5pd3iLtm
	 aC6lFDqhvJOtNM6OAlQTfZ0lrI4kdGEj0YRAcPZuKpBn8nnn6zEFxXtueKcqXqGdXFLoT
	 YRPsfNXDlJvHtx4FeRc4qwOmVUxXg940YRAINTInbcwzM1JcxbbFUUpPok/TuVt4GKB0/
	 s4isQVaFhdI8jE/hZyoJmhToubc2sjc6a2I/GacSlpLhDYDT2xFqbjxL9wmp/RCdpWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794603147;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version:
	 X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=EABz54xQqJuMDLrv9lPSJUVRj0pOkiR/MgunesRcFhY=;
	b=xl0tHqnIIoU+Jz5lYVar8eGNQRBgynGWghyXGncCZmvPxAdX8uBpBI0Cch8YUUJaPefx
	 5kDpYCKX7PXrEop1cviXd7l8ZfC530lSxMLf7wP9u017RXlvdj+ciB4ZvKAUSvYTPl8AL
	 aDjE/GhIw4BUs7Y65ujUuK7+EaJbMBjPL1dSOqi8PqooAvLtPeGtHetriSsFni8SFEz01
	 4xyzfxsZXweHqu9qMn9RoqNcInLzCnr2Qogd4Mvk+pvrxb1gu3H6F/YpL+1I0hZQINlHC
	 nBrM0cyEcoJ6wLnCW191u7pL+91SYCT4/hvgEP/ZgtD+ocRyIJIC1XQBHxeIOdNsuVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="ldhYJw//";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="ldhYJw//";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C81606A333
	for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 20:52:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61C81606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ldhYJw//;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ldhYJw//
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5A6941F84D;
	Fri, 13 Nov 2026 20:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794603144; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EABz54xQqJuMDLrv9lPSJUVRj0pOkiR/MgunesRcFhY=;
	b=ldhYJw//ZHSTGDazSbPobbEZYHtFCGkoj3PKGOLqWJliiHMQU9ywpBhx+fUUi1oirik371
	E4GPF9zIQpREdxPiw3At2XqHekZhNRvmkalQFglOQE9HOeGetgk4GfidCipBYn5f9Y7UJg
	rrdFfkptha1hDdr2z2N4Y73867AlKeI=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="ldhYJw//"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794603144; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EABz54xQqJuMDLrv9lPSJUVRj0pOkiR/MgunesRcFhY=;
	b=ldhYJw//ZHSTGDazSbPobbEZYHtFCGkoj3PKGOLqWJliiHMQU9ywpBhx+fUUi1oirik371
	E4GPF9zIQpREdxPiw3At2XqHekZhNRvmkalQFglOQE9HOeGetgk4GfidCipBYn5f9Y7UJg
	rrdFfkptha1hDdr2z2N4Y73867AlKeI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E6C7113485;
	Fri, 13 Nov 2026 20:52:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wmcFLod492pAewAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 13 Nov 2026 20:52:23 +0000
Message-ID: <9259d20188a042cb280bad95f8be9783d1b9c1fd.camel@suse.com>
Subject: Re: [PATCH v4 1/1] multipathd: recheck WWIDs of re-added paths with
 the device
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Brian Bunker <brian@purestorage.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, dm-devel@lists.linux.dev
Date: Fri, 13 Nov 2026 21:52:23 +0100
In-Reply-To: <avdQNjzddtu7o18n@redhat.com>
References: <20261111181642.51912-1-brian@purestorage.com>
	 <20261111181642.51912-2-brian@purestorage.com>
	 <179452227264.147392.9708937185980533136.b4-review@b4>
	 <avdQNjzddtu7o18n@redhat.com>
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
X-Rspamd-Queue-Id: 5A6941F84D
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
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,purestorage.com:email];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.51

On Fri, 2026-11-13 at 13:00 -0500, Benjamin Marzinski wrote:
> On Thu, Nov 12, 2026 at 11:24:32PM +0100, Martin Wilck wrote:
> > > Document the new case under recheck_wwid in multipath.conf(5).
> >=20
> > As Ben pointed out in his previous email:
> >=20
> >=20
> > It may make sense to convert the "recheck_wwid" option from a
> > boolean
> > to a multi-value option, to make it possible to choose between the
> > old
> > and new behavior.
> >=20
> > @Ben, what do you think?
>=20
> Like I mentioned in that other email thread, I think limiting this to
> only run on paths that are up will make it no more risky than
> recheck_wwid already is. recheck_wwid exists because people are
> worried
> that their device my change wwid unexpectedly. We could have multiple
> levels of worry, but I'm not sure we need to give users such fine
> grained control, and this check only gets tripped when something
> already
> went wrong.
>=20

Ok, fair.

> more comments below.
>=20
> >=20
> > >=20
> > > Signed-off-by: Brian Bunker <brian@purestorage.com>
> >=20
> > I still have some more comments, see below.
> > (In case you wonder: I used AI to assist with this review).
> >=20
> > > =C2=A0=09}
> > > +=09/*
> > > +=09 * This path is being re-added because its udev data was
> > > missing or
> > > +=09 * changed. The uevent may have been queued long before
> > > we got here,
> > > +=09 * and adding a path to the map of a different LUN
> > > corrupts data. If
> > > +=09 * recheck_wwid is set, confirm the WWID with the device
> > > first. On a
> > > +=09 * mismatch, leave the path out and let the checker
> > > retrigger udev
> > > +=09 * to get a fresh WWID.
> > > +=09 */
> > > +=09if (mode =3D=3D PATH_ADD_REINIT && pp->recheck_wwid =3D=3D
> > > RECHECK_WWID_ON &&
> > > +=09=C2=A0=C2=A0=C2=A0 check_path_wwid_change(pp)) {
> >=20
> > check_path_wwid_change() returns false when it fails, is it correct
> > to keep the
> > path in that case? IMHO we should treat this like the strlen(pp-
> > >wwid) =3D=3D 0 case
> > above.
>=20
> Not sure I agree with this. It's a paranoia check. If it fails, I
> don't
> have a problem with just trusting the data that was given to us. I'm
> willing to be convinced otherwise, however.

In my mind, a changed WWID followed by a failure to obtain the WWID
from the device shows that something is really fishy about the path in
question.

Moreover:=C2=A0

I realize that uev_update_path() calls get_uid() with allow_fallback=3D0.
This goes back to your commit ffaf947 ("multipathd: Don't use fallback
code after getting wwid"), where the rationale you provided was=20

> once the
> devices are set up, udev is the definitive source of this information
> ...
> Working under the assumption that udev will either never give us this
> information, or that it usually will.=20

We have given up this assumption, at least partly. In view of the late
discussions, it seems reasonable to me to allow fallback to SG_IO if
udev failed, at least if pp->wwid was non-zero before.

Then, if the fallback failed, the situation would really be almost
identical to the failing paranoia check.

>=20
> makes sense.
>=20
> > But more generally: as this indicates a possible mismatch between
> > kernel and device
> > state, should we handle this similar to=C2=A0 handle_path_wwid_change()
> > instead,
> > i.e. also call rescan_path()? I guess that would need to be done in
> > uev_update_path(),
> > i.e. it would touch the regular "wwid changed in uevent" path.
>=20
> Is this not another place were we are opening ourselves up for
> commands
> blocking? If we want to do a rescan and it can block, it makes more
> sense to do it only if recheck_wwids is set, and we know that the
> path
> is up.=20
>=20

Right, I didn't consider that rescan_path() may block. But still, why
do we need to rescan in handle_path_wwid_change(), but not here?=C2=A0

AFAICS, the likelihood that the kernel is using stale information is
quite high when we handle this situation. I'm not sure if testing
whether the path is up makes much sense. There are many situations in
which the path would be down, but rescan/inquiry would still work. The
only thing that would really hurt us are timeouts during the kernel's
probing procedure, but I am not aware of an easy way to predict whether
that will happen.

I suppose we could rescan asynchronously in this case. After all, we
already have obtained the real WWID from the device, therefore we don't
need to wait for the rescan to finish.

> > >=20
> > > +=09}
> > > =C2=A0=09mpp =3D find_mp_by_wwid(vecs->mpvec, pp->wwid);
> > > =C2=A0=09if (mpp && pp->size && mpp->size !=3D pp->size) {
> > > =C2=A0=09=09condlog(0, "%s: failed to add new path %s,
> > > device size mismatch", mpp->alias, pp->dev);
> > > @@ -1375,7 +1390,7 @@ rescan:
> > > =C2=A0=09if (ro =3D=3D 1)
> > > =C2=A0=09=09mpp->force_readonly =3D 1;
> > > =C2=A0
> > > -=09if (!need_do_map)
> > > +=09if (mode =3D=3D PATH_ADD_NO_MAP)
> > > =C2=A0=09=09return 0;
> > > =C2=A0
> > > =C2=A0=09if (!dm_map_present(mpp->alias)) {
> > > @@ -1789,7 +1804,7 @@ out:
> > > =C2=A0=09}
> > > =C2=A0=09/* pp->initialized must not be INIT_PARTIAL if
> > > needs_reinit is set */
> > > =C2=A0=09if (needs_reinit)
> > > -=09=09retval =3D uev_add_path(uev, vecs, 1);
> > > +=09=09retval =3D uev_add_path(uev, vecs,
> > > PATH_ADD_REINIT);
> >=20
> > Is it correct to take this branch also if needs_reinit is set
> > because
> > INIT_REQUESTED_UDEV was set? I don't think so.
>=20
> This is a little tricky. I agree that we don't need to add the extra
> layer of paranoid checking when the path never got a wwid. In that
> case,
> what most likely what happened is that the udev worker thread timed
> out
> on the previous uevent, so we couldn't get the WWID from uevent
> variables. However, if we don't recheck on INIT_REQUESTED_UDEV, then
> we
> can get into a situation where:
> 1. uev_update_path() notices that the wwid has changed
> 2. ev_add_path() confirms that the wwid we got from udev doesn't
> match
> =C2=A0=C2=A0 the wwid we get directly asking the device
> 3. We trigger a new uevent
> 4. We blindly trust udev's wwid.

We need to trust udev at some point, don't we? Assume

4. we double check again=C2=A0
5. ev_add_path() confirms that the wwid we got from udev doesn't match
6. goto 3=C2=A0

At least we'd need to avoid getting stuck in a loop.

AFAICS there are 2 reasons to do the SG_IO check:

1) vpd info from sysfs may be stale (affects SUSE only)
2) something changed between the VPD detection in udev rules and our
event handling

Then there is

3) a bug e.g. in an udev rule causes ID_SERIAL to be consistently
wrong.

Case 1) would be fixed triggering a rescan (see above). In case 2), it
makes a certain amount of sense to trust udev the next time. Case 3)
would cause an infinite loop if we keep double-checking.

> Perhaps we need more initialization states or a path device flag to
> distinguish between the two cases (never having gotten a WWID, or
> having
> our WWID . Or we can decide that we are o.k. with extra checking
> whenever something goes wrong with getting the wwid from udev (when
> you
> have recheck_wwid set). Or am I misunderstanding something about why
> doing this is wrong? Are we intentionally only double-checking once
> here?

I don't like the idea of checking the first time around very much, but
I agree it isn't a big deal. OTOH, see above.

Yet another possibility is to introduce a new mode where we just never
trust udev. That'd be a 180" turn, but it might be worth trying.
The longer we discuss this, the more attractive it seems to me. Rather
than guessing whether or not we can trust udev, just use a "zero trust"
model :-)

Regards
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)

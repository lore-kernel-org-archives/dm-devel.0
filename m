Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E619C14A4C3
	for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 16:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714064213; cv=none; b=qVW+6GFyQB67ela9zMC8+v/36pCHxFQ5dPN+TnwGEYxQTbG7AzbPLHW9SAmKJpFQclZowUqJKONEdXzhEBJWvq/2TpXXJ2bn8SLQ0B+OrTRMVexLfNZ6pBM0EevRLozhZLAEGEGPKyaQDZw+j2OTLAJqvE7VO61XtuUJrBZbdY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714064213; c=relaxed/simple;
	bh=4R9h5a9mxU4dTWzPVWFPBkYGl0cd0XhKvpYNpp8A+Uk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qlYI3pm4bxsxBeJll4MBxSVfVp7b63NwY9/JPX6SF2iPWr+vtr+TT4KcHZbIgPw0lXmN2rce+/ut7Ch18noNsr3VltO0ukeIfmihX1z9lfCpgOa51123yE9adWxTdsjLK2mS+dPyZPU+WFoBg6qafORO+gn0Qtbbm0LjaiC8sck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Xfy/bhEA; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Xfy/bhEA"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-34665dd7744so826191f8f.1
        for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 09:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1714064209; x=1714669009; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gNM4lOtBt4ttf7jpVsltM4M9Y8RRkR3MK8V1RAhVGXs=;
        b=Xfy/bhEAnXg6wfEbNnp3gvNBUjGcxf1/NBg/G2o6uzP9KhGVD/2EYT2RBdKPN0eP1S
         O9VQiLQWkdn5Z1M7sXbm1lwk0szBVy21tBdMinBKm9N3dkqgcMY0f0CUz8uyaz7XKlJZ
         420TzQNMUMnTY6qKNXMUNJfwsFzxa6uNYPPvs9zvI/NHwJ06KZnT13P9XmSBBDijypg7
         nKyXTuq8mi3jG9CyKlEN8QBgsftgiu+bfaZMC+q+n+LPtrzcv0ehnwSDJ9ndHoz2F6dZ
         wkBEnUkIjtUPEwS2wzz6uKthO+bLoGJ18a3niMBhbr3JjRUWpXdySEMmrXXKFywb6vkp
         5erw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714064209; x=1714669009;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gNM4lOtBt4ttf7jpVsltM4M9Y8RRkR3MK8V1RAhVGXs=;
        b=WrkNu3AOZ9XuXwa3oEWLcKEwWPBqdQN6OGRYNflEqf1Fm1L5TEILpd/gexr+X25Az+
         1SjNy89/fjc/y3YZ94azvWJ+H13cs9D6sv7z9Uvtuoxe7ubKfPF0SZ0NWFFXtlcF7EWh
         xLvN5l2dULBEuGdqrfucWbRGyXOc90Tt+r/GgGj1R0zEn2Z0RrHIRBcWDsNXcb9CYtGO
         X/fNJKKq2oDUhXORuPisR1LPlywl8Jl2oY/8POAZMmHE4MR5LgtyojCt5bF7g1SciGyv
         0ph1aVyDaEWViaWCcwoqdUqttiUDbWLrsKPaECoWR8hfA98rnr8RGIoA7MJWBGAcR2yG
         k2NQ==
X-Forwarded-Encrypted: i=1; AJvYcCWM282KYY89iO4AWjVKFb5RONvscYyECYm8YIm3y6t7K+CcY7wKFXRywvpaNc7McRiWZba27foJSX1BjHA2GwyTxfpS2Z0gbhU=
X-Gm-Message-State: AOJu0YxkBGH66+B1/VgmWVxntbZ7iswdSg+8BnLGTc0z4Izv15aXFDS2
	S8Sc5VcwLCzbA9/Bo5P+LjxVMdeMOyZYiiiNR6KEDEjonrmZedV9xzpvQxzq+y29q4ma58K1iiN
	f
X-Google-Smtp-Source: AGHT+IEiTW/N7xTG1OBvRQ5pnC8wRoNlmacMaB4Ru1ofTLSk3Z71WKjWOFfqA/j8cvRppdYM1Qsu/A==
X-Received: by 2002:a5d:4e86:0:b0:341:e4f4:4399 with SMTP id e6-20020a5d4e86000000b00341e4f44399mr56593wru.68.1714064209142;
        Thu, 25 Apr 2024 09:56:49 -0700 (PDT)
Received: from apollon.wilcks.net (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with ESMTPSA id l10-20020a5d410a000000b00343d1d09550sm20344369wrp.60.2024.04.25.09.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 09:56:48 -0700 (PDT)
Message-ID: <b555131290e6923f54a3494413aa3ee3eefb9813.camel@suse.com>
Subject: Re: [PATCH 2/3] libmultipath: change flush_on_last_del to fix a
 multipathd hang
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Thu, 25 Apr 2024 18:56:47 +0200
In-Reply-To: <ZilunDUSAH8jnBNT@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240423222536.2096486-1-bmarzins@redhat.com>
	 <20240423222536.2096486-3-bmarzins@redhat.com>
	 <439b76a2cdc7d044d2588315663bcca3a21063e2.camel@suse.com>
	 <ZilunDUSAH8jnBNT@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-04-24 at 16:42 -0400, Benjamin Marzinski wrote:
> On Wed, Apr 24, 2024 at 06:34:35PM +0200, Martin Wilck wrote:
> > On Tue, 2024-04-23 at 18:25 -0400, Benjamin Marzinski wrote:
> >=20
> > >=20
> > > I chose "unused" as the default because this should generally
> > > only
> > > cause
> > > multipathd to work differently from the users perspective when
> > > nothing
> > > has the multipath device open but it is queueing and there is
> > > outstanding IO. Without this change, it would have hung instead
> > > of
> > > failing the outstanding IO. However, I do understand that an
> > > argument
> > > could be made that "never" makes more sense as default, even
> > > though
> > > it
> > > will cause multipathd to skip autoremoves in cases where it
> > > wouldn't
> > > before.
> >=20
> > How important is the autoremove feature, actually? I have do
> > confess I
> > don't like it too much, anyway.
> >=20
> > I'd actually vote to set the default to "never", even if that means
> > a
> > change in the default behavior, unless someone convinces me that
> > autoremoving unused maps with no paths is actually the right thing
> > to
> > do.
>=20
> If we changed the default behavior, we'd find out how much users rely
> on
> it. My guess is "more than they should".=C2=A0 Ideally, users would shut
> down
> their multipath device before removing their underlying path devices.
> In practice, I bet that a significant number do not.=C2=A0

I'm not sure if we should continue encouraging this sort of lazy
practice. Actually, it doesn't matter that much if the multipath device
persists. If there's anything of value, like a file system, database
storage, or whatever, in the stack on top, the user would be well-
advised to close/umount it before deleting the path devices. If she
does, also destructing the multipath device would be minor step. If she
doesn't, the fact that the multipath device persists would be a lesser
concern.

But of course you're right, we don't know what our users actually do in
this respect.

> Since deleting path
> devices isn't a common thing, and we can argue that we are just
> enforcing good behavior, it's probably o.k. to change it, but I'm
> pretty
> sure some users would complain or file bugs. Off the top of my head,
> one
> thing that could potentially go wrong (although I hope this isn't
> likely
> in the real world) is:
>=20
> 1. User removes the LUNs under an unused multipath device. The
> =C2=A0=C2=A0 multipath device isn't removed
> 2. User creates new LUNs with a different size. The array gives these
> =C2=A0=C2=A0 new LUNs the same WWID as the old ones (I don't know how oft=
en
> this
> =C2=A0=C2=A0 happens. I hope rarely, if at all)
> 3. Multipathd tries to add these new LUNs to the existing multipath
> =C2=A0=C2=A0 device and fails because the size doesn't match.

My first thought here was: we could avoid this scenario by overriding
the mp's size with the path's size if the existing map had no devices.
But if there was actually pending, queued I/O on the device, we might
corrupt the new device as soon as it's added. That wouldn't be a good
idea.

But then, the situation at hand would be rather obvious, the customer
would need to remove the existing, empty map before creating the new
one. If this fails because the map is either in use, has outstanding
I/O, or both, it seems reasonable that the user would need to inspect
the situation and fix it manually. I don't think this can be automated
on our side.

> Also, our current dev_loss_tmo resetting seems pretty racy. It's set
> to
> exactly the same length of time as the we should retry for. If
> multipathd is slow in its retries, paths can get deleted while we are
> still queueing, making it more likely that you would have pathless
> multipath devices hanging around. In theory, we could add another
> check
> to see if a device has no paths and isn't in use when we disable
> queueing, but I don't see a reason why we should expand autoremoving,
> and we can easily pad the dev_loss_tmo value to reduce the race.

Good point.

>=20
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > > =C2=A0libmultipath/defaults.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 2 +-
> > > =C2=A0libmultipath/dict.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 | 72
> > > +++++++++++++++++++++++++++++++--
> > > --
> > > =C2=A0libmultipath/dict.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> > > =C2=A0libmultipath/hwtable.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0 6 +--
> > > =C2=A0libmultipath/propsel.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0 4 +-
> > > =C2=A0libmultipath/structs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0 7 ++--
> > > =C2=A0multipath/multipath.conf.5.in | 20 +++++++---
> > > =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 42 +++++++++++++++++---
> > > =C2=A08 files changed, 127 insertions(+), 27 deletions(-)
> > >=20
> > > diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> > > index 64b633f2..ed08c251 100644
> >=20

[...]

> > How much sense do these hwtable entries make? In view of your
> > commit
> > description, this seems to be a dangerous device default. It has
> > the
> > surprising side effect that users who don't want flush_on_last_del
> > will
> > need to set in either in the overrides section or in a dedicated
> > device
> > section for the device at hand. This can be changed in a separate
> > patch
> > of course.
>=20
> I remember NetApp having strong feelings about their configs. They
> are
> the only user of the devices section user_friendly_names option. IIRC
> the only reason this option exists in the devices section is because
> they pushed for it.
>=20
> But the way they have things set up, I don't see it as dangerous.
> They
> set dev_loss_tmo to "infinity" so their path devices should never
> disappear, unless someone chooses to remove them. They also set
> no_path_retry to "queue", since they don't want IO to ever fail on
> their
> devices unless someone manually disables queueing.

Yeah, I see it in 8e22682 ("multipath: Some device configuration
changes for NetApp LUNs", 12y ago.
I agree that in combination with "no_path_retry queue" and
"dev_loss_tmo infinity", this setting makes sense, or is at least not
harmful. Still, we could ask NetApp for their motivation.


>  It's odd, but nobody
> has ever complained that the builtin config for NetApp devices
> doesn't
> work like the other builtin configs, so it's just remained that way.
> Again, it seems like it's more trouble than it's worth to change it
> now.
>=20
> On the other hand, the Infinidat config already sets no_path_retry to
> "fail", so there's not much point in also setting flush_on_last_del
> to
> "always".

I'd say it's dangerous, especially as they don't set dev_loss_tmo.

[...]
=C2=A0
> > > +
> > > +	/* It's not safe to do a non-deferred remove of a map
> > > that
> > > has
> > > +	 * "queue_if_no_path" set, since there could be
> > > outstanding
> > > IO which
> > > +	 * will cause multipathd to hang while attempting the
> > > remove
> > > */
> > > +	if (mpp->flush_on_last_del =3D=3D FLUSH_NEVER &&
> > > +	=C2=A0=C2=A0=C2=A0 !do_deferred(deferred_remove) && is_queueing) {
> > > +		condlog(2, "%s: map is queueing, can't remove",
> > > mpp-
> > > > alias);
> > > +		return false;
> > > +	}
> >=20
> > Just a thought: Why don't we just pretend that deferred_remove is
> > on if
> > flush_on_last_del is set to "never"? Wouldn't that avoid our
> > issues?
> > In the same context, why haven't we made deferred_remove the
> > default
> > yet?
>=20
> I'm not sure we want to change the default multipath behavior without
> a
> good reason.=C2=A0 Users don't expect that removing a multipath device ca=
n
> succeed, but the device will still be there.

Right. We *could* distinguish auto-removal and manual removal and fall
back to deferred remove only in the auto-removal case. But I guess that
over-complicates matters.

Btw, I realize that in devmapper.h we pass 0 for the deferred parameter
of _dm_flush_map, while we should rather pass DEFERRED_REMOVE_OFF. It
has no actual consequences, but maybe you want to fix it while you're
working on this?

#define dm_flush_map(mapname) _dm_flush_map(mapname, 1, 0, 0, 0)
#define dm_flush_map_nosync(mapname) _dm_flush_map(mapname, 0, 0, 0, 0)
#define dm_suspend_and_flush_map(mapname, retries) \
	_dm_flush_map(mapname, 1, 0, 1, retries)


> Worse, I just tested and found out that my test will still hang
> multipathd with my new code if you have deferred_remove turned on.=C2=A0
> This
> is because there is no opener of the kpartx device, so device-mapper
> tries to immediately remove it. Apparently, it's also not safe to
> trigger a deferred remove without disabling queueing.
>=20

Ugh. I guess you'll fix this in a v2, right?


> > > +	if (mpp->flush_on_last_del =3D=3D FLUSH_UNUSED &&
> > > +	=C2=A0=C2=A0=C2=A0 !do_deferred(deferred_remove) &&
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (=
in_use =3D partmap_in_use(mpp->alias, NULL)) &&
> > > is_queueing) {
> > > +		condlog(2, "%s: map in use and queueing, can't
> > > remove",
> > > +			mpp->alias);
> > > +		return false;
> > > +	}
> >=20
> > Same reasoning as above, why not just defer?
> >=20
> > > =C2=A0	/*
> > > -	 * flush_map will fail if the device is open
> > > +	 * This will flush FLUSH_NEVER devices and FLUSH_UNUSED
> > > devices
> > > +	 * that are in use, but only if this is not a deferred
> > > remove, and
> >=20
> > "that are not in use" ?
>=20
> This *will* disable queue_if_no_path on in-use devices. But like I
> said,
> only if, according to mulitpathd, the device is already set to
> queue_if_no_path.=C2=A0 This is just to make sure the mpp->features isn't
> out
> of date, since getting this wrong and hanging multipathd is a bad
> thing.

I understand that you're calling dm_queue_if_no_path(mpp, 0) to be on
the safe side. That makes sense. But the comment is confusing. AFAICS,
you're doing this regardless of the value of is_queueing. Only the log
priority of is_queueing depends on is_queueing.

This logic is complicated (with 24 possible combinations of
flush_on_last_del, deferred, is_queueing, and in_use). It took me a
while to figure out, but meanwhile I think you got it right, just the
comment keeps confusing me.

> Alternatively, I could call update_multipath_table() to make sure
> mpp->features is up to date. This way does less work, and if
> multipathd
> thinks that the device shouldn't be queueing, then it really
> shouldn't
> be queueing.

I didn't mean to say that you should do this.

Regards,
Martin


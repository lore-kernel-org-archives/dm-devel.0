Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D81F4477E0
	for <dm-devel@lists.linux.dev>; Thu, 23 Jul 2026 14:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784816106; cv=none; b=PK7+Qf5J0mSZQjuDBZ6X0M6DhfltC6zJNEyvs7p1hVRlPnSbU7dWPi1Kl23J7zTqpG/RwlXTgGEPECHArPo4jPJZlRR7B2/ilgl5wfFg3U4RZ+JshS6q9bgTv45lBTcUCnUxXLy+uTdUIxnm0uuWWEFZHXBdzqwEX7O9pRNjQXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784816106; c=relaxed/simple;
	bh=w1IFmZ4+ao6A7BNFpOKSy3VkjF/sZd0HZsvleinm7QA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T8BKHzDFt0XVm5QLrzcKf62nKow2GU3tTIBGFWp2idlvuUPWBNiSx97zl+4Oy2LOHbK1qYwL/SwIdKP+xedWbOtj0GQ8GRcefUMOVlKaA/Jmr1+WzE43o0wq6Pdpiic1ChQtwolaItA9YQbDkZZ3tqZo2XVOtk6j8XqVhF2zSfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RbPXY5Ho; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RbPXY5Ho"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47f365afc5aso447015f8f.0
        for <dm-devel@lists.linux.dev>; Thu, 23 Jul 2026 07:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784816101; x=1785420901; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=uswztzllCVe9dzH4TTGSLpxnnmlNFpmgbqthJq9sZIc=;
        b=RbPXY5HomlKzlSXLWDvKVXQQdrU0w8rRU10p1290yxtzzvHbN8xKV0hGYOOS2upoX6
         X/0/iu8IJMSgxs5c0r4yBbXg+fW9PpBbr2IaGsH22NVUC+zNtUOv255V2K+MLMgCgrWX
         xb5T8hTncPRf83IQTty0VLjGAUAsGjdLGheCQ9SPj/b7e6j75OliR8XPjvV/4JYenSH7
         uhKF9qUf73V6RccOLIgO4zELCfDpch8K6adlPumpOKbUpFQrcDNj7LK25D+AXtDgT6yd
         oTTyic3rh4Kv57Xo0SF0CNJmRvcbCcZ8AFx9blCaBc98t4IupGaYiZZaUjigiFuNVE7I
         p8Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784816101; x=1785420901;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uswztzllCVe9dzH4TTGSLpxnnmlNFpmgbqthJq9sZIc=;
        b=MyvMtmhEkCykuId7AS6hPDSUsmfY8ky6dwl5116/34unffwxK7+H9I8Cd3iDE5a+kr
         5VXugkDPo+/Pz7rW2rivfPz+c1JnmSjlO5gk2q6pxk7LYGNIKhFgzK7jsaTIO3ot+TVB
         X0YMy103FhTMIfPIDhJ+CTqd6KzGZGbrvJY2sSJpVpakvCnrwHcA5u1N7yUxB5abFHKR
         eyDmw4kAizOKIIWYyQawhclW6+Hii8W9+nDAxDV0o7Ho/qtXCdwoTYB6sD1eeCG99lbD
         z37YkjEZhBMdhVdR10bqXdSng/cOkvcicINzuQ6j+SxV6a81qttb20uwTMjsKjMXNaHi
         W6zA==
X-Gm-Message-State: AOJu0YzozSXk8he6MK43DryOEg3PhjsLL9nemS9q9zZhfYvbcFMr+Sqc
	R5P76viEwePRQwE1xSE+244/bsxsHPN2iae483iMbFn+Rg+tTWhQ9+8T1UqJ9/a/cPo=
X-Gm-Gg: AR+sD13gZW5ONjqaV//cFwF9g+cv/W98kPV0Kx7Yl49z5+VZkb/EiocVtQY6x3JUBsr
	TdwwyClxruPBrtpPRlrhaHExP9gmKoNW0rNbtgdPbbUAwhFbjl9waczZpJnE7L0n96XQb7L8ota
	SVMsmv5MqpWWLF4aoA3SOIBzrpYRiXkmOUDiNqdYbcivICO7iTwXQTu6HDi3KxSVstBc+3DYCRG
	n54jZwdugQiM0f8nji6zSeBb8C5CNQ4WnJIkTkiCbSrcnTXF7bVdj/TWrcz5LYs6aYKk9EI3/VP
	h0lHVz624YjhnlQZWgrWr/wPwbUtR6k1E9cicwTOIW7kzzS79iwU33w8qxDVjBfeBwV3tJCjh0V
	QTLYUptxKEIg++FkKyMfjNNS8TAyjCxX+zg5CiX1GZ9tT1f20jYvxCZAyVi2SZxbBrWvAYQim71
	sG41/SSpxBy2z1oaI6qI2y9lgm0WJvpcGxdYJpsizXg/vqJ6tLvmN7NkBkzG1jXY1XOjtHUb5Cg
	rp5H30DCgL/EDke1wlQvnPrLZ5Vh/abwlj73Jjk
X-Received: by 2002:a05:6000:1ac7:b0:470:13e1:9904 with SMTP id ffacd0b85a97d-47f8da666ddmr4447578f8f.14.1784816100535;
        Thu, 23 Jul 2026 07:15:00 -0700 (PDT)
Received: from ?IPv6:2003:de:3746:1100:f390:c52e:1c24:9082? (p200300de37461100f390c52e1c249082.dip0.t-ipconnect.de. [2003:de:3746:1100:f390:c52e:1c24:9082])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c7880dsm16551934f8f.37.2026.07.23.07.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 07:15:00 -0700 (PDT)
Message-ID: <14b2f7a6345b675ad845432d39a6b9bcd83f79f1.camel@suse.com>
Subject: Re: [PATCH v2] libmpathpersist: fix self-preemption when key has no
 active reservation
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Cykang
	 <cykang4830@gmail.com>
Date: Thu, 23 Jul 2026 16:14:59 +0200
In-Reply-To: <3519e091bd5765b7a84f343347e9b199180368ba.camel@suse.com>
References: <20260721192413.2497873-1-bmarzins@redhat.com>
	 <3519e091bd5765b7a84f343347e9b199180368ba.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2026-07-23 at 16:12 +0200, Martin Wilck wrote:
> On Tue, 2026-07-21 at 15:24 -0400, Benjamin Marzinski wrote:
> > From: Cykang <cykang4830@gmail.com>
> >=20
> > According to the SCSI-3 Persistent Reservations specification, when
> > a
> > self-preemption is performed with a key that does not currently
> > hold
> > an active reservation, the operation should be treated as an
> > unregister
> > and should not fail.
> >=20
> > The current code in do_mpath_persistent_reserve_out() does not
> > check
> > whether the preempting key has a reservation before invoking the
> > self-preemption path. It unconditionally calls preempt_self() and
> > re-registers the key on the local paths, even when the key has no
> > reservation. This violates the SCSI-3 PR spec and can lead to
> > incorrect reservation states.
> >=20
> > This patch moves the self-preemption check inside the conditional
> > block so that it only executes when the key matches, but does not
> > bypass the general preemption path for keys without a reservation.
> > With this change, the code will fall through to the common PR_OUT
> > handling (e.g., MPATH_PROUT_RES_SA or CLEAR_SA) when the key is not
> > reserved, allowing the storage target to properly process the
> > operation as an unregister.
> >=20
> > Signed-off-by: Cykang <cykang4830@gmail.com>
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> Reviewed-by: Martin Wilck <mwilck@suse.com>
>=20
> One minor remark below.
>=20
>=20
> > ---
> > =C2=A0libmpathpersist/mpath_persist_int.c | 27 ++++++++++++++++++++----=
-
> > --
> > =C2=A01 file changed, 20 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/libmpathpersist/mpath_persist_int.c
> > b/libmpathpersist/mpath_persist_int.c
> > index 3091c5c2..97fc71a7 100644
> > --- a/libmpathpersist/mpath_persist_int.c
> > +++ b/libmpathpersist/mpath_persist_int.c
> > @@ -841,6 +841,7 @@ int do_mpath_persistent_reserve_out(vector
> > curmp,
> > vector pathvec, int fd,
> > =C2=A0	bool unregistering, preempting_reservation =3D false;
> > =C2=A0	bool updated_prkey =3D false;
> > =C2=A0	bool failed_paths =3D false;
> > +	bool self_preempt_unreg =3D false;
> > =C2=A0
> > =C2=A0	ret =3D mpath_get_map(curmp, fd, &mpp);
> > =C2=A0	if (ret !=3D MPATH_PR_SUCCESS)
> > @@ -953,7 +954,10 @@ int do_mpath_persistent_reserve_out(vector
> > curmp, vector pathvec, int fd,
> > =C2=A0		break;
> > =C2=A0	case MPATH_PROUT_PREE_SA:
> > =C2=A0	case MPATH_PROUT_PREE_AB_SA:
> > -		if (reservation_key_matches(mpp, paramp->sa_key,
> > NULL) =3D=3D YNU_YES) {
> > +		ret =3D reservation_key_matches(mpp, paramp->sa_key,
> > NULL);
> > +		if (ret =3D=3D YNU_UNDEF)
> > +			return MPATH_PR_OTHER;
> > +		if (ret =3D=3D YNU_YES) {
> > =C2=A0			preempting_reservation =3D true;
> > =C2=A0			if (memcmp(paramp->sa_key, &zerokey, 8) =3D=3D
> > 0) {
> > =C2=A0				/* all registrants case */
> > @@ -961,13 +965,20 @@ int do_mpath_persistent_reserve_out(vector
> > curmp, vector pathvec, int fd,
> > =C2=A0						=C2=A0 rq_type, noisy);
> > =C2=A0				break;
> > =C2=A0			}
> > +			/* if we are preempting ourself */
> > +			if (memcmp(paramp->sa_key, paramp->key, 8)
> > =3D=3D 0) {
> > +				ret =3D preempt_self(mpp,
> > rq_servact,
> > rq_scope,
> > +						=C2=A0=C2=A0 rq_type, noisy,
> > PREE_WORK_NONE);
> > +				break;
> > +			}
> > +		} else if (memcmp(paramp->sa_key, paramp->key, 8)
> > =3D=3D
> > 0) {
> > +			/*
> > +			 * We are self-preempting, but we don't
> > hold
> > the
> > +			 * reservation. This will unregister the
> > device
> > +			 */
> > +			self_preempt_unreg =3D true;
>=20
> If you don't mind, I'll add a comment here that this will fall though
> further down. It's not immediately obvious IMO.

Forget this remark, it's fine as-is.

Martin

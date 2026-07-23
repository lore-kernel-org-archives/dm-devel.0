Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8B5447803
	for <dm-devel@lists.linux.dev>; Thu, 23 Jul 2026 14:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784815950; cv=none; b=YuT8sSe5gTi8fyj4Bmp3eokJxpdLnXAaGkTsRD3/ELwdtWbz9/RzymmQ8vVWmJjnQHRQQ2hobJz9XtKXGqAH2Rfu2mxtsp44Qs3y3VpxeFmqNWIevtjx4z1LTTTbAl4uCHlZh8QND3mXMJz9W8tr98YtKcZoBrqtFesUiYVhK9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784815950; c=relaxed/simple;
	bh=C/6F7p8YXek9qdZ5KVPhwbFws6X3wNzUkukT1DM8tlc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GbJ+bGDtx+xmgaGtuzXfF2cEX0q3G6LVFBxgCyLPKKk6cPz6SaaTUzMzs8YQfmhcs9jGZXpokzYdVZyaealdrln3NMPZqEPilc5dHTXs2Qzv6MZr1HpGzMc0BHjlPJBDy7YuBGRaBYTmbsEoaGXSlqcUx3BMxSXotCmBw7ZSxsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZSi/7S8p; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZSi/7S8p"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47c2b362ee2so622730f8f.1
        for <dm-devel@lists.linux.dev>; Thu, 23 Jul 2026 07:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784815935; x=1785420735; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=G3KBLVA0i0AbuC0++5iHVjkC16oQXK5ZupJ3e4x7Wr4=;
        b=ZSi/7S8pAZY5RLav47bXk0LqdVcnwPzPHlF2aOhZzewoMoTPDiKqmGbziEUqAqcMi7
         4mdWdApjOohothOH6P2+PQclzQMmpX3M1nbZwg5PO9K0StxAnlrchcCEf8leQim+afHF
         6OBHKKBm7RhbFA9W6OHNWtPa3He4G4VV3qVk/3HuFMxT4ZEC6ABSLxFIV8VENVINdHtj
         Ca5zHfLuyH8FsbVFSde8DM6It04qggF/ejcbrqkRFHSI2KqSo3DrrvmgUKlz/0jjEdwv
         hcUHDIlBUqGMCARPs/j6kIqNC2AK7e+BZTchkZ81UArACHMDppaeVw6agJwqbZhDn0D0
         ygUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784815935; x=1785420735;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G3KBLVA0i0AbuC0++5iHVjkC16oQXK5ZupJ3e4x7Wr4=;
        b=Ra7caEuj9jaxmKcq6UwMMLN1+CAogk7s1FePlCZaKh6OCi1fwQM0rjwtJf8eSdU3/k
         v3OWOxdoSWs0PA2o50dfUPvTpM0DRNiuR1LdybWSN5kKT2Wg8RuG89/LAu4NTqyO8Wl9
         Y1zN/vyjRlhZGdo80rZOJ03GHlFgPnU0BN+/UlH10ivhOFicIK5B4CFfotlPnol0EaLY
         VYC1tdLqB/+BXRzXMoEBps2MbwCw/MWZoDupwf2JEKgyxT47WDEvCB6Z15gLeVB4IRcb
         PIYTBJuctXDFCP82NWInRmL3CtzdWd3Ektn2etFFXEHUK1wx/J/JU1DdrqsqT8Uz6SDt
         X9/Q==
X-Gm-Message-State: AOJu0YxtWukmzIEZCW582UBJoKHiGqxWvykodo6yhDMoxZUEhOrJALqk
	GLVIz2NJeaY8H1huH7kpALzJ/2YYpS9g6Mqxqd4w5BpWwGaYu4vQtLQ6l6SMjq3DgXw=
X-Gm-Gg: AR+sD10GYVaKjIz2IeHBqB6heWDjQcBu0wkegsKw2kQCphIbZ3lcbZt2T1o5H6KSOlk
	7MwMntc1nmx790Y/VKsNzmKok9/jIUhJc5fp5gxN7lTPV9VDsF2a3WmrSeLGWqgSYnS+Bivt1Ny
	ukuXm57v7Uzx6/nVPql2ehxobli7nShwbXsNrHyEg3pJZ8w4Zv6KuxViO8dYsDfAClnghcpO5uc
	K9kclIyLvUdVo8R1qADTli8a5Bdk/rB75i3kzcflIvkOz0kWgru3Y/b798ySJqEgbf2/FxZ8U3b
	BBttY5SoaEvY+R17Yk5FbkDn72w4OKaScAvepA9a9D7BI2eluI009nrKv+wMcxDgXwY9Ytk8h/A
	QANwHpS+jDkjM0gO3skkFFPV98JZrGUMiT1+cDB6eVgrDNp8wyu2xjKZ716PLqzzzBucrCYOodD
	KfXBzWS7FekAFtgSe6+agd3jVT8Bm1u6ypOmt7PReDVbna89ICjQyALing/aLpXU5Pu510UfbCu
	al4zfgDIm2h7MieXWMfIy8t61xw2nQZWDfWE4Kb
X-Received: by 2002:adf:e19b:0:b0:47f:5ec2:d54 with SMTP id ffacd0b85a97d-47f8d710b28mr4269703f8f.5.1784815934493;
        Thu, 23 Jul 2026 07:12:14 -0700 (PDT)
Received: from ?IPv6:2003:de:3746:1100:f390:c52e:1c24:9082? (p200300de37461100f390c52e1c249082.dip0.t-ipconnect.de. [2003:de:3746:1100:f390:c52e:1c24:9082])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a60asm16017374f8f.3.2026.07.23.07.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 07:12:14 -0700 (PDT)
Message-ID: <3519e091bd5765b7a84f343347e9b199180368ba.camel@suse.com>
Subject: Re: [PATCH v2] libmpathpersist: fix self-preemption when key has no
 active reservation
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Cykang
	 <cykang4830@gmail.com>
Date: Thu, 23 Jul 2026 16:12:12 +0200
In-Reply-To: <20260721192413.2497873-1-bmarzins@redhat.com>
References: <20260721192413.2497873-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2026-07-21 at 15:24 -0400, Benjamin Marzinski wrote:
> From: Cykang <cykang4830@gmail.com>
>=20
> According to the SCSI-3 Persistent Reservations specification, when a
> self-preemption is performed with a key that does not currently hold
> an active reservation, the operation should be treated as an
> unregister
> and should not fail.
>=20
> The current code in do_mpath_persistent_reserve_out() does not check
> whether the preempting key has a reservation before invoking the
> self-preemption path. It unconditionally calls preempt_self() and
> re-registers the key on the local paths, even when the key has no
> reservation. This violates the SCSI-3 PR spec and can lead to
> incorrect reservation states.
>=20
> This patch moves the self-preemption check inside the conditional
> block so that it only executes when the key matches, but does not
> bypass the general preemption path for keys without a reservation.
> With this change, the code will fall through to the common PR_OUT
> handling (e.g., MPATH_PROUT_RES_SA or CLEAR_SA) when the key is not
> reserved, allowing the storage target to properly process the
> operation as an unregister.
>=20
> Signed-off-by: Cykang <cykang4830@gmail.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

One minor remark below.


> ---
> =C2=A0libmpathpersist/mpath_persist_int.c | 27 ++++++++++++++++++++------=
-
> =C2=A01 file changed, 20 insertions(+), 7 deletions(-)
>=20
> diff --git a/libmpathpersist/mpath_persist_int.c
> b/libmpathpersist/mpath_persist_int.c
> index 3091c5c2..97fc71a7 100644
> --- a/libmpathpersist/mpath_persist_int.c
> +++ b/libmpathpersist/mpath_persist_int.c
> @@ -841,6 +841,7 @@ int do_mpath_persistent_reserve_out(vector curmp,
> vector pathvec, int fd,
> =C2=A0	bool unregistering, preempting_reservation =3D false;
> =C2=A0	bool updated_prkey =3D false;
> =C2=A0	bool failed_paths =3D false;
> +	bool self_preempt_unreg =3D false;
> =C2=A0
> =C2=A0	ret =3D mpath_get_map(curmp, fd, &mpp);
> =C2=A0	if (ret !=3D MPATH_PR_SUCCESS)
> @@ -953,7 +954,10 @@ int do_mpath_persistent_reserve_out(vector
> curmp, vector pathvec, int fd,
> =C2=A0		break;
> =C2=A0	case MPATH_PROUT_PREE_SA:
> =C2=A0	case MPATH_PROUT_PREE_AB_SA:
> -		if (reservation_key_matches(mpp, paramp->sa_key,
> NULL) =3D=3D YNU_YES) {
> +		ret =3D reservation_key_matches(mpp, paramp->sa_key,
> NULL);
> +		if (ret =3D=3D YNU_UNDEF)
> +			return MPATH_PR_OTHER;
> +		if (ret =3D=3D YNU_YES) {
> =C2=A0			preempting_reservation =3D true;
> =C2=A0			if (memcmp(paramp->sa_key, &zerokey, 8) =3D=3D
> 0) {
> =C2=A0				/* all registrants case */
> @@ -961,13 +965,20 @@ int do_mpath_persistent_reserve_out(vector
> curmp, vector pathvec, int fd,
> =C2=A0						=C2=A0 rq_type, noisy);
> =C2=A0				break;
> =C2=A0			}
> +			/* if we are preempting ourself */
> +			if (memcmp(paramp->sa_key, paramp->key, 8)
> =3D=3D 0) {
> +				ret =3D preempt_self(mpp, rq_servact,
> rq_scope,
> +						=C2=A0=C2=A0 rq_type, noisy,
> PREE_WORK_NONE);
> +				break;
> +			}
> +		} else if (memcmp(paramp->sa_key, paramp->key, 8) =3D=3D
> 0) {
> +			/*
> +			 * We are self-preempting, but we don't hold
> the
> +			 * reservation. This will unregister the
> device
> +			 */
> +			self_preempt_unreg =3D true;

If you don't mind, I'll add a comment here that this will fall though
further down. It's not immediately obvious IMO.

Regards
Martin

> =C2=A0		}
> -		/* if we are preempting ourself */
> -		if (memcmp(paramp->sa_key, paramp->key, 8) =3D=3D 0) {
> -			ret =3D preempt_self(mpp, rq_servact,
> rq_scope, rq_type,
> -					=C2=A0=C2=A0 noisy, PREE_WORK_NONE);
> -			break;
> -		}
> +
> =C2=A0		/* fallthrough */
> =C2=A0	case MPATH_PROUT_RES_SA:
> =C2=A0	case MPATH_PROUT_CLEAR_SA: {
> @@ -1018,6 +1029,8 @@ int do_mpath_persistent_reserve_out(vector
> curmp, vector pathvec, int fd,
> =C2=A0	case MPATH_PROUT_PREE_AB_SA:
> =C2=A0		if (preempting_reservation)
> =C2=A0			update_prhold(mpp->alias, true);
> +		else if (self_preempt_unreg)
> +			update_prflag(mpp, 0);
> =C2=A0	}
> =C2=A0	return ret;
> =C2=A0}

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Jochen Jaser, Andrew McDonald (HRB 36809,AG N=C3=
=BCrnberg)

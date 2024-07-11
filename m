Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489BB14532D
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 12:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720700759; cv=none; b=lhG7nQnWEfgMKVzzfbr2M/wRoRVVG3yUrNyF/Y1iRr5uKJLWikVnzRor2YeDVDT0txgA+a+TM+U/j0xxLOMQwO+de0FuinhhtmB1iOqPexZBQfWzYthY5g0/TrmriutXbsarzmwJ+2NH5KuYyxhYhRHAt8j1TplpPnTojvqh7bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720700759; c=relaxed/simple;
	bh=DUsj8ZeqKQUNoPV4nivxVDAcfeRynZ6DAsBfCkGJ1ks=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y5Ey2fNjl9dX3rvH2t6ym1tQ5HKrvZRMjFJmn5exS03uHYz9A2nkeyP3gT492xKAxPpr/weXyzDfhglAh//U6piObQSpe0v2tsb4PG4bvqaHzQ3B2U671A4+SnGMHcSaKumCxBkth9qX6AN1VxckuimlUi9NL9aqS+eJniS8+18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BNUcWRrP; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BNUcWRrP"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4265c2b602aso5431625e9.3
        for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 05:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720700755; x=1721305555; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IJZwphXgyljxnv4KWbp98ZBtc0FndfD56F28+fsl/SM=;
        b=BNUcWRrP4R7yz4U7MB3pt9/BVVHsSyL9kHf1ZJ12RB4OfMIjM5VbMxTbG0Gdd31T2i
         ZjhZBdOjkqio2HgX3BgY58a0S9daJ1FejraWCe59N5xuN1kCSXiQ0wbURNe4I/sG+PBr
         Ofn0NR4GXxE+GDCWPHHdZI0s5311aE1cUiYSBuMppf8RYCBOBn2g9QvC/+wp713muFKz
         9pzS01L66Nh7YQBv5X4ErT1sFtfnKL/4Dp/0EYFcVzkH1ZVpATBb2kOQGNINr1rK5dol
         tw4UAsODbS1aqDvPdTV8DaefNmjglaFUootqeAz7BL3QV0617upF6foYVw8ia9v4YnWZ
         O8/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720700755; x=1721305555;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IJZwphXgyljxnv4KWbp98ZBtc0FndfD56F28+fsl/SM=;
        b=udtxq8yfh5qzs41fPakejZS0fx0nHwqhxLixsJ9c72D0Dvl/gnRbwPj8tt7yA/oSlU
         IlDGZZBBsuWlcALTdlajCPY86+KFqJqxj7u+rE4fn6AH50kdvY6R14ju8et4HyegY7fR
         BgcLL+ct2dx8TXSoaEcZH5ZUTyJcx9ZtMIfOTCqZnGeBuVJPQ3GNIvU6h0yEOt8CDkFD
         uL/aM6DbyYO6I2w+ZXNqamtD82BAUH7Ck1HTHNc0/II4pRdqjM0gWJd9k2QkW92T3J6z
         tpn8Hz5ZROfmZYYtAYWTiRW+E0AWV+jf/LGOLj/+pdDZQCAFVgxjUQMypsKcSHhIFKoo
         fzZw==
X-Forwarded-Encrypted: i=1; AJvYcCWlzLB4QtBzifKlEAKi+TDXDJYD9LMhERcs1B0eF8lRKXESX9PbkvYhgNOBFM/2ZY4WtrTLZj0QSsEixcB4wbrl6NGgzyhjqGc=
X-Gm-Message-State: AOJu0YyKRagn4rF2xQeG3L9M6EuG3smuYVwB8VKdhitJlyEzlnMuM9KZ
	amZWKmFfHf6+fOpzONoHJHaWB0iExe6TKYarcrFsMTW4VyaMV/aPHolm4XLztZ8=
X-Google-Smtp-Source: AGHT+IGUflcPniPjnNHBOCKD1QXz14V4auIngdSbxr+PR09zKFmMYn/ns8xZ4gqKq5FBKy+SgAhk2A==
X-Received: by 2002:a05:600c:11c8:b0:426:607c:1863 with SMTP id 5b1f17b1804b1-426707e365fmr53391175e9.21.1720700755330;
        Thu, 11 Jul 2024 05:25:55 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4266f7430ffsm117101445e9.44.2024.07.11.05.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jul 2024 05:25:55 -0700 (PDT)
Message-ID: <c97168ac1c8d92b5403453f1be1190cda8a9d1e4.camel@suse.com>
Subject: Re: [PATCH 23/44] libmultipath: improve dm_get_wwid() return value
 logic
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Thu, 11 Jul 2024 14:25:54 +0200
In-Reply-To: <Zo8aoNebaxrgKlzo@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
	 <20240709213935.177028-24-mwilck@suse.com> <Zo8aoNebaxrgKlzo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-07-10 at 19:34 -0400, Benjamin Marzinski wrote:
> On Tue, Jul 09, 2024 at 11:39:14PM +0200, Martin Wilck wrote:
> > Make dm_get_wwid() return different status codes for non-existing
> > maps,
> > maps that exists but are not multipath maps, and generic error
> > case,
> > and handle these return codes appropriately in callers.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =C2=A0libmultipath/alias.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 5 +++--
> > =C2=A0libmultipath/configure.c | 23 +++++++++++------------
> > =C2=A0libmultipath/devmapper.c | 21 ++++++++++++++++-----
> > =C2=A0libmultipath/wwids.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> > =C2=A0tests/alias.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 10 +++++-----
> > =C2=A05 files changed, 36 insertions(+), 25 deletions(-)
> >=20
> > diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> > index 10e58a7..2ab9499 100644
> > --- a/libmultipath/alias.c
> > +++ b/libmultipath/alias.c
> > @@ -408,13 +408,14 @@ static bool alias_already_taken(const char
> > *alias, const char *map_wwid)
> > =C2=A0{
> > =C2=A0
> > =C2=A0	char wwid[WWID_SIZE];
> > +	int rc =3D dm_get_wwid(alias, wwid, sizeof(wwid));
> > =C2=A0
> > =C2=A0	/* If the map doesn't exist, it's fine */
> > -	if (dm_get_wwid(alias, wwid, sizeof(wwid)) !=3D 0)
>=20
> We used to assume the alias was not taken if dm_get_wwid() failed
> with
> an error. Now we assume that the alias is taken. I think we should
> continue to assume we can use the alias if we get DM_ERR.

I am not sure about this. but I can change it. I guess it's a corner
case anyway, where there's no obvious right or wrong behavior.=C2=A0

A DM_DEVICE_INFO call with this map name failed with an error other
than ENXIO. By going on with this map name, we clearly risk that future
failures will happen when we try to create or reload the map in
question.


>=20
> > +	if (rc =3D=3D DMP_NOT_FOUND)
> > =C2=A0		return false;
> > =C2=A0
> > =C2=A0	/* If both the name and the wwid match, it's fine.*/
> > -	if (strncmp(map_wwid, wwid, sizeof(wwid)) =3D=3D 0)
> > +	if (rc =3D=3D DMP_OK && strncmp(map_wwid, wwid, sizeof(wwid))
> > =3D=3D 0)
> > =C2=A0		return false;
> > =C2=A0
> > =C2=A0	condlog(3, "%s: alias '%s' already taken, reselecting
> > alias",
> > diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> > index 666d4e8..565ea5c 100644
> > --- a/libmultipath/configure.c
> > +++ b/libmultipath/configure.c
> > @@ -845,18 +845,17 @@ int domap(struct multipath *mpp, char
> > *params, int is_daemon)
> > =C2=A0
> > =C2=A0	if (mpp->action =3D=3D ACT_CREATE && dm_map_present(mpp-
> > >alias)) {
> > =C2=A0		char wwid[WWID_SIZE];
> > +		int rc =3D dm_get_wwid(mpp->alias, wwid,
> > sizeof(wwid));
> > =C2=A0
> > -		if (dm_get_wwid(mpp->alias, wwid, sizeof(wwid)) =3D=3D
> > 0) {
> > -			if (!strncmp(mpp->wwid, wwid,
> > sizeof(wwid))) {
> > -				condlog(3, "%s: map already
> > present",
> > -					mpp->alias);
> > -				mpp->action =3D ACT_RELOAD;
> > -			} else {
> > -				condlog(0, "%s: map \"%s\" already
> > present with WWID %s, skipping",
> > -					mpp->wwid, mpp->alias,
> > wwid);
> > -				condlog(0, "please check alias
> > settings in config and bindings file");
> > -				mpp->action =3D ACT_REJECT;
> > -			}
> > +		if (rc =3D=3D DMP_OK && !strncmp(mpp->wwid, wwid,
> > sizeof(wwid))) {
> > +			condlog(3, "%s: map already present",
> > +				mpp->alias);
> > +			mpp->action =3D ACT_RELOAD;
>=20
> If we return DMP_NO_MATCH, we'll tell the user that the device is
> already
> present will a WWID of "". This is the same as before, but perhaps it
> would be better to tell the user that the alias is in use by a
> non-multipath device.

Ok.

>=20
> > +		} else if (rc =3D=3D DMP_OK || rc =3D=3D DMP_NO_MATCH) {
> > +			condlog(1, "%s: map \"%s\" already present
> > with WWID \"%s\", skipping\n"
> > +				=C2=A0=C2=A0 "please check alias settings in
> > config and bindings file",
> > +				mpp->wwid, mpp->alias, wwid);
> > +			mpp->action =3D ACT_REJECT;
> > =C2=A0		}
> > =C2=A0	}
> > =C2=A0
> > @@ -1320,7 +1319,7 @@ static int _get_refwwid(enum mpath_cmds cmd,
> > const char *dev,
> > =C2=A0		break;
> > =C2=A0
> > =C2=A0	case DEV_DEVMAP:
> > -		if (((dm_get_wwid(dev, tmpwwid, WWID_SIZE)) =3D=3D 0)
> > +		if (((dm_get_wwid(dev, tmpwwid, WWID_SIZE)) =3D=3D
> > DMP_OK)
> > =C2=A0		=C2=A0=C2=A0=C2=A0 && (strlen(tmpwwid)))
> > =C2=A0			refwwid =3D tmpwwid;
> > =C2=A0
> > diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> > index 94ef369..1eebcb5 100644
> > --- a/libmultipath/devmapper.c
> > +++ b/libmultipath/devmapper.c
> > @@ -829,19 +829,30 @@ int dm_get_map(const char *name, unsigned
> > long long *size, char **outparams)
> > =C2=A0	}
> > =C2=A0}
> > =C2=A0
> > +/**
> > + * dm_get_wwid(): return WWID for a multipath map
> > + * @returns:
> > + *=C2=A0=C2=A0=C2=A0 DMP_OK if successful
> > + *=C2=A0=C2=A0=C2=A0 DMP_NOT_FOUND if the map doesn't exist
> > + *=C2=A0=C2=A0=C2=A0 DMP_NO_MATCH if the map exists but is not a multi=
path map
> > + *=C2=A0=C2=A0=C2=A0 DMP_ERR for other errors
> > + */
> > =C2=A0int dm_get_wwid(const char *name, char *uuid, int uuid_len)
> > =C2=A0{
> > =C2=A0	char tmp[DM_UUID_LEN];
> > +	int rc =3D dm_get_dm_uuid(name, tmp);
> > =C2=A0
> > -	if (dm_get_dm_uuid(name, tmp) !=3D DMP_OK)
> > -		return 1;
> > +	if (rc !=3D DMP_OK)
> > +		return rc;
> > =C2=A0
> > =C2=A0	if (!strncmp(tmp, UUID_PREFIX, UUID_PREFIX_LEN))
> > =C2=A0		strlcpy(uuid, tmp + UUID_PREFIX_LEN, uuid_len);
> > -	else
> > +	else {
>=20
> This seems a little inconsistent with the change in our returns.
> Before, if we found a device but it wasn't multipath device,
> dm_get_wwid() would exit with 0 but set uuid to an empty string. Now
> we
> return DMP_NO_MATCH in this case but we still clear uuid. It seems
> like
> perhaps we should either set uuid to an empty string for all cases
> except DM_OK or we should not touch it for all cases except DM_OK.
> Alternatively, perhaps I'm over-thinking this.

Right. In libmp_mapinfo(), I followed the idea that no output should be
touched if any errors happened. Here, I wanted to preserve the behavior
but didn't do it correctly.

I tend to think that "don't touch output in error case" is the correct
behavior, but we'd need to review the callers and make sure that they
don't assume the WWID will be automatically 0-terminated.

I'll do that.

Martin




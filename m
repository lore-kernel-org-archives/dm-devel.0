Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5E6126F0F
	for <dm-devel@lists.linux.dev>; Thu,  4 Apr 2024 13:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712238563; cv=none; b=Id2krBvsJfRNPW2+SlqVnTs7/npBAC6ZUPoe/ctFdgcAe5k3l1Gihxx/CONJiDEw51AB+Z55I86QFtKtzj9rvBmp8g/Rb/bbR1IOvUZQKY4rN/8ETwsYzpHR5EVZZwPchD6R/jBCtsyTu/VLF/nXjehDUHg3gExjEgu2xeOor08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712238563; c=relaxed/simple;
	bh=XAgg4UDEjgsTGZtUY+NkL9/O2R0nyJAt+G54h/hwFcg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dFmlmOqqz1e/75sSYMikkdzESJQu7Lu61y5NWyPCs6+FYw++Ie56C8cm68k8bqwsUlrpBjm/OC/AHgh0p55AYPag6q+yrMCIaysrIeEsIN64I6wx2FvYCWDd9OQzQ55oXXyU6HGjy338vbNNBEWHOW8cvq3PoQ2grmyN4Xjz50o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=g4ZwAfHG; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="g4ZwAfHG"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2d68cf90ec4so12725481fa.1
        for <dm-devel@lists.linux.dev>; Thu, 04 Apr 2024 06:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712238559; x=1712843359; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KG2EJ8uHSAKGaLlZoMIrAMtkFCXtM91gshg1wV3zIHc=;
        b=g4ZwAfHGzfUi91ifgbuRHG6sOXzIe9Ofo9ov2npLE/MdZyJOuxlAI0GpwLcvMlQM4m
         5Fqrq49jUxG6dz/2kqqxYwOUjFfIuTpiuqWWsEHJQDleC2s8scpqG7ub6/XgT0u2rprK
         FfUBc4fiZQOxcsP4CqkCwcQd7qelJM2voG2rwELRxaiXIvtB/CZTz7h0hDSwporIhd/W
         OkQMuUufAtw7NarWXEjFg8ahvBigugwkCNjKsEQEFbKDCPARl2mrq4JyGScBrlQwWuMt
         FcqbgrCoJ0gXi5gl4EkhtoMhliQrvRyB1SZX2jlgeUGQ15m3zezfmFxascdVhUs85hus
         wY2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712238559; x=1712843359;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KG2EJ8uHSAKGaLlZoMIrAMtkFCXtM91gshg1wV3zIHc=;
        b=GKqfZRUoS34UV+Dpic71tAbKDbgArdFfgEgiCBSJPJI1fQtP4rEaPysCpCi2uBgcJt
         ePujR5BuB6MY939bTqC3qilg8uHkkB0sxBFyzSc2HM1HzXR1O7jd6/F+Re6nPgCT6avt
         dNetlWITWUkLjzUTxroZYQd7wc++C65eCyXCxhNUujNSyR2YX59hFUpxqfXYFZPH5vOQ
         x4jcyB4jHUAOJg/HY+X7K0E9oiCEQs8j/YP5i0xZQOhd4T+AoYI81IIMT3PgY2CLXXrz
         D6OvjZTunh8on+eRGskttcIMzebHd5sUNd0q03goIT5xnzmBvPbPqPiaoNJlylll7J7+
         TicQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6b1yCWbfP1rNGLhJ5GWRwVeYaYX2WEeoa6Y8RGWtxgiqTWENWvBVfdMhHcAxKO5Z6dGTWz/CnllNG70ngYWpxvlccGIrtqS8=
X-Gm-Message-State: AOJu0Yy+qUuvDdObkLEYl3aWlz3Lz/pHGFN4JcBcDzafDz5s5GbTp762
	sPnEgp4TjuQflcUX+bfRMnWDxcdVsc8gC9UDN9RVwDjUPnJxeWVt0G1tJlsP104=
X-Google-Smtp-Source: AGHT+IFGPL5oRP1F5DwXsD8ltyCtUjsro/OMk+ZU1blp1sDYQdl/CD9Nl7jPEU7Mh4hy8Gcj513Grg==
X-Received: by 2002:a2e:80cd:0:b0:2d8:a71:b17a with SMTP id r13-20020a2e80cd000000b002d80a71b17amr1907079ljg.3.1712238559131;
        Thu, 04 Apr 2024 06:49:19 -0700 (PDT)
Received: from apollon.wilcks.net (dslb-084-058-019-253.084.058.pools.vodafone-ip.de. [84.58.19.253])
        by smtp.gmail.com with ESMTPSA id u14-20020a05600c19ce00b004161b59e230sm2774481wmq.41.2024.04.04.06.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 06:49:18 -0700 (PDT)
Message-ID: <4497eeee4fb681f7c5d7b36921173ff68049390d.camel@suse.com>
Subject: Re: [PATCH 02/11] 11-dm-mpath.rules: don't import DM_NOSCAN from
 udev db
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>
Date: Thu, 04 Apr 2024 15:49:18 +0200
In-Reply-To: <ZgNk3TymUNP-8ItA@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240324211301.7200-1-mwilck@suse.com>
	 <20240324211301.7200-3-mwilck@suse.com>
	 <ZgNGPsAz_H22VEaj@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
	 <ZgNk3TymUNP-8ItA@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-03-26 at 20:14 -0400, Benjamin Marzinski wrote:
> On Tue, Mar 26, 2024 at 06:03:42PM -0400, Benjamin Marzinski wrote:
> > On Sun, Mar 24, 2024 at 10:12:52PM +0100, Martin Wilck wrote:
> > > DM_NOSCAN is our "output" flag for 13-dm-disk.rules, and it
> > > should
> > > be treated the same way as DM_UDEV_DISABLE_OTHER_RULES_FLAG,
> > > which
> > > isn't imported from the udev database. The state that we need to
> > > remember is MPATH_DEVICE_READY, which we've already imported
> > > above,
> > > and we will set the "output" flags accordingly in the
> > > "force_activation"
> > > code path further down.
> > >=20
> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > > =C2=A0multipath/11-dm-mpath.rules.in | 6 ++++--
> > > =C2=A01 file changed, 4 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-
> > > mpath.rules.in
> > > index 3f23108..11b5adf 100644
> > > --- a/multipath/11-dm-mpath.rules.in
> > > +++ b/multipath/11-dm-mpath.rules.in
> > > @@ -18,9 +18,11 @@ ACTION=3D=3D"add", ENV{DM_ACTIVATION}=3D=3D"1",
> > > ENV{DM_SUSPENDED}!=3D"1", ENV{DISK_RO}!=3D"1
> > > =C2=A0
> > > =C2=A0# If this uevent didn't come from dm, don't try to update the
> > > =C2=A0# device state
> > > +# Note that .MPATH_DEVICE_READY_OLD=3D=3D"" here. Thus we won't
> > > activate the
> > > +# device below at mpath_is_ready, which is correct.
> >=20
> > Do you mean "force_activation" instead of "mpath_is_ready"?
>=20
> I see that this label is added two commits later. I don't have a
> problem
> with a comment being confusing for two commits, so if you don't feel
> like changing it,

Good catch, thanks. A few too many rebases, I guess. I will fix it.

Martin

>=20
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> >=20
> > -Ben
> >=20
> > > =C2=A0ENV{DM_COOKIE}!=3D"?*", ENV{DM_ACTION}!=3D"PATH_*", \
> > > -	IMPORT{db}=3D"DM_NOSCAN",
> > > IMPORT{db}=3D"DM_COLDPLUG_SUSPENDED", \
> > > -	GOTO=3D"scan_import"
> > > +	IMPORT{db}=3D"DM_COLDPLUG_SUSPENDED", \
> > > +	GOTO=3D"force_activation"
> > > =C2=A0
> > > =C2=A0ENV{.MPATH_DEVICE_READY_OLD}=3D"$env{MPATH_DEVICE_READY}"
> > > =C2=A0
> > > --=20
> > > 2.43.2
> >=20
>=20


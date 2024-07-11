Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC821A08B7
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 22:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720735254; cv=none; b=g9cZvcyMHFIFoyh809hR89qIL7tKzdN81ApxVK9742P3AgB66fU5Em9pzsSvy//gf9qfcspVtx7+RpojPmdnEY4FbnEbMhnkEqQCtb9hRL6MmQkFdNIIji0sJUVJ+eJ8NFV6TkRzd6Ub0Hz6xVjnIZ3Le3M0J01kL+5GKAR5qm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720735254; c=relaxed/simple;
	bh=Ez0MH4uuPyFkFSiJPNGTx5okf92j2APF7IgIC/IGRoc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hKpDoCFkBlpupSWa85/OtURtWyL9peTqi1LOC/y7huSVaDWi0wRmuuYM6MxaqGNmNDBLmhjpD8YqOg9I+SqJsJ91nj42HPW50N0kjSJ5N9om21f+WGtKLmsVJOuQLjwDJEM5mstrHbzNgb+11aeprPmhkewA5oOSgegVbBh3RWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PnF1j12O; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PnF1j12O"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4266f535e82so8848745e9.1
        for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 15:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720735248; x=1721340048; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oQoTcEcK5Ddbj+vJUQJd/KdPoBd8VmGNuYwa7o4QkG8=;
        b=PnF1j12OtouzdwsUclH8DFannuFqgK8RAfB+Miui40vAdBOZHmhsQhkKZuwrpRhFIa
         7ew4abWKe+3Pf/FuLc8SsrLLG0rnxB0foVU7YVkFJuudMGg5hUVFmZjhcjDECCtp/nin
         AHprN54IOJZrInlsnjc1T+YfP+ezh1AGMiXvp7auaT2DtE6XVyb5t9H4f5KAGDPpv/SY
         k/qnf5kM9qlsTxLSGN/PT1xzahOmdi8DfBHesKrBnNcFfOVcowlV3y7BCGuKBIASBEEn
         8uzlrjhC2fT4TfHtoh0EtpbzflL+kJMphQLoUt35yiDaes37xIjgagKXbYdnm7GuZlnQ
         WJyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720735248; x=1721340048;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oQoTcEcK5Ddbj+vJUQJd/KdPoBd8VmGNuYwa7o4QkG8=;
        b=tvQbfQ8SyvO87gE4ym3tH2YQw6B0FhjwYmgU/z7cN8r31X8/nKWCwBdVs+0qrNM+Ml
         xjrJsW2AHXVjuZ+0ZTdAX7D+ZI5O4fBZam0BdhXl8YqVtLguJswXE/kS8hZraujCkqml
         4ie3DhmGorJx6MiNYXTVeJzrO7OHxn3HDPK6vCCRA2tJLF5U8sIzF3lSmhSXWm4G7CKL
         pUnfrE+T7g8HLumZdcCoAYAEv0M5DDNB6hYEPOqAEpkYNMo5ijP9CKnRgCwac2HngmZT
         +vgfX4fD4mmTO7Y2UdWbFEuRM/6kD3NLne483qU7J+6bm+IHYYMXxk6AxYeod+Xnzuz7
         /6GA==
X-Forwarded-Encrypted: i=1; AJvYcCVwYrzVTXtRNmbf+hWym+WmFyP1hvtlJVEgjLmBkPU7z9K77tanxZ6fnt3Z4PsTPW8xSQPd894oMddwzrnAc4DudjLcJvNd4mo=
X-Gm-Message-State: AOJu0YxQMS/6DpBQPn0FWsoya2Bl4PxG+LHVM03Y4XZC9zn/iLSD24XH
	lpCKjq7FV3eD4PcwpxSID42kalSPL3Vsro9UDexMPtySPrTlW1hZxz6J25H997Y=
X-Google-Smtp-Source: AGHT+IFJPTLZcQq0hImP25E3RVj3vNFu3+u7oBTKObI9wxva4xRasR3Ctl6tQPILYYGhZ9UdECKGmA==
X-Received: by 2002:a05:600c:24c:b0:426:697d:af49 with SMTP id 5b1f17b1804b1-426708fa999mr69575395e9.39.1720735247772;
        Thu, 11 Jul 2024 15:00:47 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4279f2c15e1sm1891805e9.42.2024.07.11.15.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jul 2024 15:00:47 -0700 (PDT)
Message-ID: <f06e1686e04c83018c37954daeffe1d006eec550.camel@suse.com>
Subject: Re: [PATCH 23/44] libmultipath: improve dm_get_wwid() return value
 logic
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Fri, 12 Jul 2024 00:00:46 +0200
In-Reply-To: <c97168ac1c8d92b5403453f1be1190cda8a9d1e4.camel@suse.com>
References: <20240709213935.177028-1-mwilck@suse.com>
	 <20240709213935.177028-24-mwilck@suse.com> <Zo8aoNebaxrgKlzo@redhat.com>
	 <c97168ac1c8d92b5403453f1be1190cda8a9d1e4.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-07-11 at 14:25 +0200, Martin Wilck wrote:
> On Wed, 2024-07-10 at 19:34 -0400, Benjamin Marzinski wrote:
> > On Tue, Jul 09, 2024 at 11:39:14PM +0200, Martin Wilck wrote:
> > >=20
> > > =C2=A0
> > > +/**
> > > + * dm_get_wwid(): return WWID for a multipath map
> > > + * @returns:
> > > + *=C2=A0=C2=A0=C2=A0 DMP_OK if successful
> > > + *=C2=A0=C2=A0=C2=A0 DMP_NOT_FOUND if the map doesn't exist
> > > + *=C2=A0=C2=A0=C2=A0 DMP_NO_MATCH if the map exists but is not a mul=
tipath map
> > > + *=C2=A0=C2=A0=C2=A0 DMP_ERR for other errors
> > > + */
> > > =C2=A0int dm_get_wwid(const char *name, char *uuid, int uuid_len)
> > > =C2=A0{
> > > =C2=A0	char tmp[DM_UUID_LEN];
> > > +	int rc =3D dm_get_dm_uuid(name, tmp);
> > > =C2=A0
> > > -	if (dm_get_dm_uuid(name, tmp) !=3D DMP_OK)
> > > -		return 1;
> > > +	if (rc !=3D DMP_OK)
> > > +		return rc;
> > > =C2=A0
> > > =C2=A0	if (!strncmp(tmp, UUID_PREFIX, UUID_PREFIX_LEN))
> > > =C2=A0		strlcpy(uuid, tmp + UUID_PREFIX_LEN, uuid_len);
> > > -	else
> > > +	else {
> >=20
> > This seems a little inconsistent with the change in our returns.
> > Before, if we found a device but it wasn't multipath device,
> > dm_get_wwid() would exit with 0 but set uuid to an empty string.
> > Now
> > we
> > return DMP_NO_MATCH in this case but we still clear uuid. It seems
> > like
> > perhaps we should either set uuid to an empty string for all cases
> > except DM_OK or we should not touch it for all cases except DM_OK.
> > Alternatively, perhaps I'm over-thinking this.
>=20
> Right. In libmp_mapinfo(), I followed the idea that no output should
> be
> touched if any errors happened. Here, I wanted to preserve the
> behavior
> but didn't do it correctly.
>=20
> I tend to think that "don't touch output in error case" is the
> correct
> behavior, but we'd need to review the callers and make sure that they
> don't assume the WWID will be automatically 0-terminated.
>=20
> I'll do that.

Turns out that the callers that need changes because of the changed
semantics of dm_get_wwid() will be changed later on anyway, and the
respective modifications of the callers will be removed again. But I'll
do this anyway, to make the patch set consistent.

Martin


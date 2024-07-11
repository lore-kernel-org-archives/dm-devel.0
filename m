Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BF9149E01
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 11:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720695658; cv=none; b=CSp+HmbilvnqEN6scLEtWDEFELaOUB24vePlmaxsENfCU2qQVzBE51N0jCRH+fVV/lvlqgMsO9I7rfEXid3skpDaQUMrrpvta6XxOGHpiRZjm+TB+6eC4crXMFnctxY+PsTFh3RdfZVuJopUA7z7r7F/AmMIrAn1L8K67eb3658=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720695658; c=relaxed/simple;
	bh=EEjYCIdmQ33NXmdq8WUdgvU/8nIyoeITuPy8JZzAJVY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rq5H/63PD/roQtSs0fBFH25omogfTk2Kve+2ZfVFOCfynyi1p15Mdn/uqYGVTaCh39pUNKK05ZaNzx5hAMJ3cVqvtB63swfUfi81eSkRjcJSDaEqLUKljecUqYPpok8dXvzokpxIHSykVx91KZ52fLD2ckSLz6lGKlj3GDVDRWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ad/mMk2S; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ad/mMk2S"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4267345e746so5032195e9.0
        for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 04:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720695655; x=1721300455; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EEjYCIdmQ33NXmdq8WUdgvU/8nIyoeITuPy8JZzAJVY=;
        b=ad/mMk2SPaHsrHqFiZ3spapy/Fv7nqGo2L1gNPGSuPqvjGwcGp/yjvbCy3g8iOWY1T
         2ceiGxwyzA4XvWXt0wZ0TiWPCKVYYlpk1bf05E9KvZizWd9cgGAriL6s5FR2qom9szbZ
         TjpFhxTZnOX9Vep+qrTSZmrBc7S1j5Q1taP79vS/3WTP3XH3o24o/sU2/FMkd71mZfF2
         IJmHTLIdP61O1Rna8n5hlfD5qvxSYKVJU+J2DbQxP3b0p5V4m2ihnY9NBw21ScY3ZuI8
         9TyLIcQiTKo2MbNOl5GGixzXypE9mIL/FQFawpdZa0VlZTJLb3P9rkc8zkJB+trPc8S5
         pgjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720695655; x=1721300455;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EEjYCIdmQ33NXmdq8WUdgvU/8nIyoeITuPy8JZzAJVY=;
        b=M3sYNaJBqnOoGUOK3UhKNp4w3Q68+U0eG6IL9ZjAPlUsDjJrMc4NZWZm3Mil+OhAG5
         YeOTj4pPYkjckMtvolIaCK2M0UbO2VGqGILjGJAzFIuyK4rMO4iv8b5E+cp0pZw5y1ur
         O4M5gTfT+8WG2qe5dqT2c4KsuvDkKv40U2qpfepGzzajYk4No38lkhgjDKWXwBLEK9IW
         93prJJDuipW77NPhBVm0hY2UmSNXSkoKdcRixcDeBcO6QNpq6qO8mz0Bx7l4YE3WcY+h
         2VoDKkP1pyE3tQ/L99xzg7CCUQJFG6lzQ4xbAPJjgJGvFV7uDGKvXquDsHdQ+bAmNtgY
         LZvw==
X-Forwarded-Encrypted: i=1; AJvYcCWevMpDy7xnuapiMqFnumpPTfxBQvuinxx6AZhoFzitOJnBVqK0Cbm2ZeH/OIMlncab/h7WJARaoxLlUTVBNQEBXkrCSD6tVlk=
X-Gm-Message-State: AOJu0Yz/pwQG4j5FzZWPl9MrOOhFXhZi1YDIYxCsWGnGbCGZRiDd9Pri
	354IwhS3NRPG+nASeMJfneRP20+AxPLAUQBdA5FJUYxHzEwm//sPp2H8C40ow4A=
X-Google-Smtp-Source: AGHT+IGzfMc/jH3kTzm+sirLJay1aTYmzPHCkmTNiD5JaUUd3n0+bR792nHsu9KeBotPzcMl7Krxow==
X-Received: by 2002:a05:600c:5748:b0:426:597c:7d58 with SMTP id 5b1f17b1804b1-426708fabf5mr50013345e9.39.1720695654442;
        Thu, 11 Jul 2024 04:00:54 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4266f737b1bsm115206615e9.32.2024.07.11.04.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jul 2024 04:00:54 -0700 (PDT)
Message-ID: <db44a2c51a54603945f7aca495d0a6dc9da771c6.camel@suse.com>
Subject: Re: [PATCH 17/44] libmultipath: add libmp_mapinfo()
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Thu, 11 Jul 2024 13:00:53 +0200
In-Reply-To: <Zo8Q2UZLwzkaRePo@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
	 <20240709213935.177028-18-mwilck@suse.com> <Zo8Q2UZLwzkaRePo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-07-10 at 18:53 -0400, Benjamin Marzinski wrote:
> On Tue, Jul 09, 2024 at 11:39:08PM +0200, Martin Wilck wrote:
>=20
> This is a great idea! I just have a few minor issues.
>=20
> > libmp_mapinfo() is intended as a generic abstraction for retrieving
> > information from
> > the kernel device-mapper driver. It retrieves the information that
> > the caller
> > needs, with a minimal set of DM ioctls, and never more then 2 ioctl
> > calls.
> >=20
> > libdm's DM_DEVICE_TABLE and DM_DEVICE_STATUS calls map to the
> > kernel's
> > DM_TABLE_STATUS ioctl, with or without the DM_STATUS_TABLE_FLAG
> > set,
> > respectively. DM_TABLE_STATUS always retrieves the basic map status
> > (struct
> > dm_info) and the map UUID and name, too.
> >=20
> > Note: I'd prefer to use an unnamed struct instead of _u in
> > union libmp_map_identifer. But doing using an unnamed struct and
> > and
> > initializing the union like this in a function argument:
> >=20
> > =C2=A0 func((mapid_t) { .major =3D major, .minor =3D minor })
>=20
> This is a nitpick, but instead of using _u, couldn't you just pass
> the
> major and minor as a dev_t? If you're working with an actual major
> and
> minor, you would need to do something like:
>=20
> (mapid_t) { .dev =3D makedev(major, minor) }
>=20
> but we are often already dealing with a dev_t, so instead of doing:
>=20
> (mapid_t) { ._u =3D { major(dev), minor(dev) } }
>=20
> we could just do:
>=20
> (mapid_t) { .dev =3D dev }
>=20
> To get the major and minor out in the libmp_mapinfo() you would need
> to
> use major(id.dev) and minor(id.dev), instead of id._u.major and
> id._u.minor, but I think first set is more readable anyway.

Nice idea. I wonder if I should add this as an additional option, or
replace the current approach.

Martin


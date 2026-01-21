Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B9F30BF52
	for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 17:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769014907; cv=none; b=i+OShz857dhlf2X8y/eke5ATNcRFlenLjnEDQht3Dx0AEHfgE/6zwFI+geTV7dWrK15atJybatNbzwWPADG4wicV/amr2/AKU3wfnaw9kriVQgbtZKFhmMnLS6USbaNMe1mBSOBD/cH0W+/J2TdijY5VRTGbc+/1xntAVxLhNQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769014907; c=relaxed/simple;
	bh=+jRcdDbhjK1sCgH9JB42558Zn/SVbF9IGFkrhDcSgx0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z2XpeHlEYp656WEYplPD7F7UUoSN/r0xij6D1oZIrp8H5N+N+ACMEa1wG+sm4kbLrVCj+08j777aS+Ejrz2qiGdnvOkHA90dRDzll05XYZ7KjVn4vg4FaAKgJmEzo39jIC8/rbHj8IHOrfA9Sxsz9bHxJU7pJ7zIv/nXCWO+u1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=d4lkXbCW; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="d4lkXbCW"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43284ed32a0so20766f8f.3
        for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 09:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769014903; x=1769619703; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=D0353kSabTIoTikdXbdSfoVh/Akth8pu4Hx3F73cWuk=;
        b=d4lkXbCWKdEf2nR2dtazQrSKIfpllv5vjLe7jWYg3w7oCuVshBN9ckE2Qt3RdvbPTw
         UkGUckDEtAmTC/LnTrkGCVjZ39s6fqZbR/DKWQoIpcRBK0TbfwFXRUcJDdQqpcYW/+Zh
         BN5SXflaLW4oFEtQem8M7s0XGH4eCUtooI0uuGLT9eK/12n3xlifB2b4aSefawL/xWaG
         GTOMokQdqZck1jbTFzrOuDCP8632JwCTT4H14Rx9xCwJglMw/dIQRqW6gjEJOY80aZsx
         sO1dWMah216Lpk+j1NoqbCe9quRH/diO+JsKyh4iYTx0UxSc9DuoZdiS+Z67dwcRY36H
         pfaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769014903; x=1769619703;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D0353kSabTIoTikdXbdSfoVh/Akth8pu4Hx3F73cWuk=;
        b=HrIF8VK8rFimHV51x6qPd/ayPOiDnbri56fs+8RdRa7rwFvODsPOfcabCZAcL8fX6d
         vCNBuZ7uJo+D9U6KGhA6i621PqBg1PNipDjTq03D4wZoQ8OY+/UmAbSiNk1JydTu73O9
         PLVDoMKWDAqh1gPxBf2QyzyqcqCO75j9/AxCfvS/npcVSwLV/YgZ7YBMRJiP4kn4wiVI
         QlmlF5slYFsF4jJwHjpphsgXdpbuQ0s09lqa9V9jxXqsZwdEhNZTIOSCrd1L4e9fdxkV
         VCL2wR0kAQFJpivN9GxAeglKbgC4fqg1/otoIaMnDAgbIq6jSA+s70QynGemK+azOwUm
         TBQA==
X-Forwarded-Encrypted: i=1; AJvYcCVtn6ADVavFz5HuW2ynlPiA4SV4DTMpPug4DmWMO6Hf60DfdSs/6j5vGlzvQaenpro6sCbfT5mfog==@lists.linux.dev
X-Gm-Message-State: AOJu0YxywjvP7t/pReShsJYRua77icAkQaCD9eW53JsXMkekpO9ZCki0
	ot6XQgzagEZt/YuLBFAlaK6mva0ev+IcDirDX0pxK1fF5VHxH6eRe8Oucm3IIoVnfOA=
X-Gm-Gg: AZuq6aK4XVzDlcucbqa6oqlxaZVcYgInHLxyTJdWT+VWtd6AkdhYjeyNnHqiCyXfqA0
	ee0VGXT4bfvMNAkabZOh/nY68c0gzSkhLPj0CKlQGC4v8+Aq5u2OrhqX21sJNxk2LcTZU2CYCpY
	bllsNaRyaYwFIz+RmHql4Uyk3wXUw8tCVCzqEF0e5kLRescidQ8I3DVilsiA95eQEbMI+5RT9hI
	NRe6MUwtSXlo3Bx7goqH4s8yxq6F77kbli+URAMchZfnLEb1IGoc3qZmEfy5ZQTIb4QRGNtdJlq
	qLAWHcwH5bIAkOFAvUY6aVv1VmcGLOoyCy+xraIrbKUkyUrOgOw3I2jAa3ShkqdVN2FOlV3bCZG
	XsvYnENXp1VjJajzB7FB1NcDPw0QMLJMx46ejmY9aUxQbVIi+eELqsmd59NVsEQjizsa7BdnQUL
	9UrVMyi1GPxe19bGLhnepwBMha7T+cN4HG+fz5T0F0HQtlFtWSfaNO1vLEIbPRoostqyxHiW6FS
	oYvWtokMDRqzqTWTULsIDv1A5wFZoIq5kzMquICwT89qP8=
X-Received: by 2002:a5d:64c8:0:b0:435:9223:c625 with SMTP id ffacd0b85a97d-4359223cbd6mr9822836f8f.28.1769014902770;
        Wed, 21 Jan 2026 09:01:42 -0800 (PST)
Received: from ?IPv6:2003:de:373a:d100:7c9:709f:eaee:b67f? (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43597bda41esm8313892f8f.28.2026.01.21.09.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 09:01:42 -0800 (PST)
Message-ID: <cc15e6e5593427f633d9fb86f791db2bdc4fa293.camel@suse.com>
Subject: Re: [PATCH 4/4] multipathd: print path offline message even without
 a checker
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Wed, 21 Jan 2026 18:01:41 +0100
In-Reply-To: <aXD4gokRK8GZYSFY@redhat.com>
References: <20260121042315.3914707-1-bmarzins@redhat.com>
	 <20260121042315.3914707-5-bmarzins@redhat.com>
	 <cb0311f9641a398981a543a3698a5395edb27165.camel@suse.com>
	 <aXD4gokRK8GZYSFY@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2026-01-21 at 11:02 -0500, Benjamin Marzinski wrote:
> On Wed, Jan 21, 2026 at 10:00:21AM +0100, Martin Wilck wrote:
> > On Tue, 2026-01-20 at 23:23 -0500, Benjamin Marzinski wrote:
> > > If a path has a checker selected and is offline, multipathd will
> > > print a
> > > "path offline" message. However if the checker isn't selected,
> > > for
> > > instance because multipathd was started or reconfigured while the
> > > path
> > > was offline, multipathd was not printing the "path offline"
> > > message.
> > > Fix that.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > > =C2=A0multipathd/main.c | 5 ++---
> > > =C2=A01 file changed, 2 insertions(+), 3 deletions(-)
> > >=20
> > > diff --git a/multipathd/main.c b/multipathd/main.c
> > > index 2140e432..69e4808f 100644
> > > --- a/multipathd/main.c
> > > +++ b/multipathd/main.c
> > > @@ -96,12 +96,11 @@ mpath_pr_event_handle(struct path *pp,
> > > unsigned
> > > int nr_keys_needed,
> > > =C2=A0
> > > =C2=A0#define LOG_MSG(lvl,
> > > pp)					\
> > > =C2=A0do
> > > {								\
> > > -	if (pp->mpp && checker_selected(&pp->checker)
> > > &&	\
> > > -	=C2=A0=C2=A0=C2=A0 lvl <=3D libmp_verbosity)
> > > {					\
> > > +	if (pp->mpp && lvl <=3D libmp_verbosity)
> > > {		\
> > > =C2=A0		if (pp->sysfs_state =3D=3D
> > > PATH_DOWN)		\
> >=20
> > While at it, we should probably change this to "p->sysfs_state !=3D
> > PATH_UP", because start_path_check will only call the checker for
> > the
> > PATH_UP case, and in other cases, the checker state will be stale.
>=20
> Sure, although I'm pretty sure that will just mean that removed paths
> might see a final log message, since PATH_PENDING paths won't see
> any,
> and the only other sysfs_state options are PATH_UP and PATH_DOWN.
> Actually, if we print an explicit "path removed" message, it could be
> useful on the off chance that a removed path didn't transistion to
> INIT_REMOVED like it should.

I'm fine with always printing "offline" here, which at that point would
just mean that no checker state could be retrieved.

Martin

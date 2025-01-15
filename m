Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EABF1D63F7
	for <dm-devel@lists.linux.dev>; Wed, 15 Jan 2025 19:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736968462; cv=none; b=ICl8wM2wlXWrJVTsboNumQRolj2DlgRL9K70t8h6CLA3nHPyvyZ+PsmazYyG6on9ZXJUOllzaw9uYiI5u6aZMwz5d64sLKJ+Gq4wlC/SBXow8Gt4bclRb0Qp+bQsMtaGY98mz6+Bx/2OVtnX4tlGNu2V1kh/959twFlkhxcZddI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736968462; c=relaxed/simple;
	bh=wm79nJFWX/aQ6KdR3P+8UqRvPyCXgHY9onpyWuZd3rk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ncdENKeuymJD9ndaC925ysOR9U9nlB4eRhhkFSF9eHUQ796XnaZAUkQ4fRuBRerRYoTQr5UQDYdjmWGDAtkzKT52mxWnquDR0N9TFWnvbAZiU/2jF7xjGlFUMC6olFBVOgy17PwJaPpCMwyoxVfoPqtRHrK+78I9tAM58s1G47o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fvU4SJX+; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fvU4SJX+"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-38a8b35e168so110383f8f.1
        for <dm-devel@lists.linux.dev>; Wed, 15 Jan 2025 11:14:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736968457; x=1737573257; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wm79nJFWX/aQ6KdR3P+8UqRvPyCXgHY9onpyWuZd3rk=;
        b=fvU4SJX+/oRscZoMiTzWT7vUG/muwqEz4daghaCEOrxC8N27uw8wJl/2F10yqp7piy
         UC9qg7xp0SEXvHi/xDk/rZrB5bocS1mRHCSog2EsBezvJ677uD5a27PfxzA0grux2EwD
         vCrm9uYk7AIz7WF9uUM5LpnseOAP/IHHrqkdVBDtBWcM9mifWDTttloGB7wFrBKtyadL
         KMnBBZGnb5iEKcqv1jp01ONoenkAnzHunSpJqyDHQ1rhg/CGV5zhwsnkmE7uIiZ7E0gs
         33lVT4dZSslNNumom1TvljwRtdAQRgKlO9HjGQX+4lqN10uRc82P2fQ9m3QxhmuVFYgc
         Emcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736968457; x=1737573257;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wm79nJFWX/aQ6KdR3P+8UqRvPyCXgHY9onpyWuZd3rk=;
        b=Wl2DZ7/+UB2V3aqEDSbvesjNWJqEbPKJJTynesbsk+xHtnGMEcWTAUkrPsSVd3umUX
         eVmQh1dxSSv3sT852aBJGjLnWP/OXmKeKKCVnnt4gkJwrcyz8P9ghIDVP6GnbxKHuVcT
         0hbS5Xhtyaucj/RAE69sLT688mqOzR6aFafTHY+xnyRmVrES39VZdmDXj7AkBeh9sXef
         cDIHbRR2BvbGakcPB5HXHqVhyy7YrWjtAFacJHmAzG0V6K19kbyWWKhPAmlg7gAbVNBx
         +Awa6ABOMOSIqLsqkj2xUGdvnn/WcWZtuF/HrEAiEcicewZhPhVil0d+xy5hz8HM8sRR
         csTw==
X-Forwarded-Encrypted: i=1; AJvYcCULejUDuYeAagzfm8mJ4vFPOqimDLLnJJJK65stCDpnbQhhzGohmAI0/pNowUi4+man+0UtWJJbCQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4cjEGPATNH/CjKpxDbnjrRuJikc44fufR+I+mfpHXBTCOXNwY
	/iyDytS6hG+ej+C9naZHVg0mTGcjpEoSuhtZYi8y5dIhORUdRVYtjBbYWv8u1xc=
X-Gm-Gg: ASbGncsfFoTkCDlFkN5ajA6jjXfie6SOy1ynARBr8yDMRpc276w3dgWZCDhGhTs7aSY
	9mhnAymVicwa7qiADgJQX5ZuLt6mNAQZs1fhofGT909ALJM5zToyuHmA+Y1m231QUZE+iYTpTnI
	fOrUapphLyUQOf9cvJr0Y09KxL47jLfqtr85Kb4DZ6Zpiinpbb5F79MbBikgX/xIyasu1QnvlaW
	y+blmScjJKVyF7IkoX4RP8Of/jkzu0chHJ7wunX92cmQiWrmSDHozYtIKSlXiYZj+G/5kVdeCAm
	YzzRf2bAkhTGMXcpwvnH0GNMOu0WKqqBl15BaGg3qHiGXERpXBVS87a+cY+nSfzkMoGhbNgS/Q5
	EOx5R3P1JOLsw
X-Google-Smtp-Source: AGHT+IGhV/3Vcn7OQzjfqPrZ2LaFN6Wz8B1X6+ChbfGo/NutJtAL9BPTX+q3cZTr5Z8CS7kzS3nVAw==
X-Received: by 2002:a05:6000:1acd:b0:38b:dc3d:e4bc with SMTP id ffacd0b85a97d-38bdc3de51cmr9366114f8f.19.1736968456494;
        Wed, 15 Jan 2025 11:14:16 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e4b8299sm18448073f8f.74.2025.01.15.11.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 11:14:16 -0800 (PST)
Message-ID: <afc1de8f976fa6aa05d59c804552d577dff5dcfb.camel@suse.com>
Subject: Re: [PATCH 2/2] multipathd: set rport port_state to marginal for
 NVMe devices
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Muneendra Kumar M <muneendra.kumar@broadcom.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, device-mapper development
	 <dm-devel@lists.linux.dev>
Date: Wed, 15 Jan 2025 20:14:14 +0100
In-Reply-To: <Z4gFdSUb0JGFSAJ0@redhat.com>
References: <20241220020235.1759375-1-bmarzins@redhat.com>
	 <20241220020235.1759375-3-bmarzins@redhat.com>
	 <c7641dfc68b568dc78297c60c56a9ee8@mail.gmail.com>
	 <Z3wVVg0AgLLq4EUN@redhat.com>
	 <7fd13eec94452ac1128158aa7fb79ea08367641f.camel@suse.com>
	 <Z4gFdSUb0JGFSAJ0@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2025-01-15 at 13:59 -0500, Benjamin Marzinski wrote:
> On Tue, Jan 14, 2025 at 11:31:00PM +0100, Martin Wilck wrote:
> > On Mon, 2025-01-06 at 12:39 -0500, Benjamin Marzinski wrote:
> > > On Fri, Dec 20, 2024 at 04:25:22PM +0530, Muneendra Kumar M
> > > wrote:
> > > > Hi Benjamin,
> > > > Thanks for the changes.
> > > > But below is the reason why we didn't add support to set the
> > > > rport
> > > > port_state to marginal for NVMe devices
> > > >=20
> > > > In the case of SCSI=C2=A0 once rport-state is set to Marginal ,
> > > > If any pending I/O's on the marginal path hit's the scsi-
> > > > timeout
> > > > (after
> > > > abort success) the scsi-layer checks the rport-state=C2=A0 and If
> > > > the
> > > > rport-state is set to Marginal it will not do any retries on
> > > > the
> > > > Marginal
> > > > path instead the I/O
> > > > Will be retried on the other Active paths.
> > > >=20
> > > >=20
> > > > This particular functionality(checking the rport-state and
> > > > acting
> > > > accordingly) we didn't add( as far I know) in the case of NVME
> > > > and
> > > > we need
> > > > to check how we can handle this in the case of NVME .
> > > > That's the reason we didn't set the port state to Marginal in
> > > > the
> > > > case of
> > > > NVMe.
> > > >=20
> > > >=20
> > > > In a brief SCSI layer handles the case when the rport-state is
> > > > set
> > > > to
> > > > Marginal whereas in NVMe it doesn't(AFIK).
> > > >=20
> > > > Atleast with the below changes we make sure that once we get
> > > > the
> > > > FPIN-LI
> > > > notification we will set the affected path , as well as the
> > > > rport-
> > > > state to
> > > > Marginal irrespective of SCSI and NVMe.
> > > >=20
> > > > I am just thinking that until we have some changes in the NVME
> > > > driver to
> > > > handle (the rport-state to marginal) this changes doesn't show
> > > > any
> > > > impact
> > > > in the case of NVMe
> > > > =C2=A0other then keeping it=C2=A0 on par with SCSI implementation.
> > > >=20
> > > > Please let me know your opinion on the same.
> > >=20
> > > The request to do this came because the user wanted to see which
> > > target
> > > ports were effected, but when they looked, none of them we in the
> > > Marginal state. So there is some value in this for users, even if
> > > the
> > > systems behavior doesn't change because of it.
> >=20
> > Please add a note to the commit message explaining this.
> >=20
> > I'm actually a bit concerned about it ... won't other users be even
> > more confused when they see the path devices as marginal but don't
> > observe any change in the system's usage of these paths?
>=20
> Sure, I can add a commit message. But while this isn't implemented in
> the NVMe layer, multipath will still route future IO differently. So,
> any IO that multipath has already dispatched to the now marginal path
> won't get treated differently, users will notice a change in IO
> patterns
> going forward. Right?

Ok. I may have misunderstood Muneendra's reply. I admit I didn't double
check in depth. I may also have mixed up native and dm multipath
behavior.

Regards
Martin


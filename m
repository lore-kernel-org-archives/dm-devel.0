Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A61364D2
	for <dm-devel@lists.linux.dev>; Thu,  2 May 2024 08:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714639017; cv=none; b=FsEyzmspIBirMjca9VToxcuhlcO+CL5/32b6OiRehQqTlPLwPdHlavCa9xEKbPjqKS0/cLBRqAfvwky4gpN+43UL/pH1eMLURjCKBwFTFw/THxMVxzdR/CKi8zK6l6yG81OA6AiGyoKdkNv112M31lmwETH5DQPLmaWVPbuWzS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714639017; c=relaxed/simple;
	bh=Nsyt/VrPfxUfKHM7NjCvpwzEBmg0cgKNPYrhoND4B70=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mOWl90TVMej/wGPRVWdBycytoNOHetCaYUHN4maiZ9MByqTWGv3KAVgfOkZaizZDVdAkAquitd8WsfxpDNc0PK/wcuXn6qSHDYw5Gz71a9L7WzqCYT98Yud46WCI4L3eSR2cP0aDOIJSPB/0/NdpESOxdsxEyuoApsJUHzMaLKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BCI2G4Eo; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BCI2G4Eo"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-56e1baf0380so9591287a12.3
        for <dm-devel@lists.linux.dev>; Thu, 02 May 2024 01:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1714639014; x=1715243814; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+vitIvaCtyzlpxhIVvbK9TdOeQ4ZQ0WSfysDz2/GyCk=;
        b=BCI2G4EoV9+YkELLATOWBLCkwjJKALhMO+qiG2oZHY0ucCdk2vAWDybkR/ziUhsFcX
         BfjDslTl9oE5ysKt/lP74WJKCzsHxRw+/odHTlRq6VHhH38Oo0329ikbiSfr6Vp+Z406
         76/Q5fuo1ZE1+Uym7Rkta0QRPqiUEMPAoLWAsd6Nzhn6id6dJ0ddNoM+hZ+7+y4wBdEE
         wF/2mAnbG8lOoN2w+6b5NVbKOJLvOW6N/StI+Bgji79cdXGrrssvZ8DzL9OUzNc8c1O0
         XoguocztXh03v6WWuHA0+l6vZGlfE6JDysyiw3tuxhwxys77EX9hibgOH23MRDjMmwH7
         oj3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714639014; x=1715243814;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+vitIvaCtyzlpxhIVvbK9TdOeQ4ZQ0WSfysDz2/GyCk=;
        b=kdw+X6K8dBERazHwNW9267d1032KrWMpUdv50q+Up8vyJEYNhmAL+c7n/kXtTRkffE
         X+gbZywSbBIW/V3YDtotoNPLedr+SGYm+tXS07JVBUBIl5BGI1zrUIbMML/QCAH2wR3n
         lpuqamRvOQlEEtZE2ln6GMt5V8sdrZ/vcW+zoFY6l5yYCFs1ttfzlnziiMUr8Hmza72D
         CBbtIRKSMk0qq2+avX5mUcxtaPK4/rtwlaPULSDvxGlk8RTVBn32tKzCmJJ8cKtASMSW
         DYIitY/eHqx3ekt5514cEUvuuxpTNjlEaqGpGXXXZiHnqkb8zStEw3J/fR2PGJdeKNQN
         42Mg==
X-Forwarded-Encrypted: i=1; AJvYcCXxhWkd5bsh97oaUyQaIUBVjbG4l6ZWXMR35eb43VuW/xqAUsvL1P6llYK08S+a+2HGtZw9Av/6gLJ4wAbuAshXwNAoyndMHjk=
X-Gm-Message-State: AOJu0YxNiswSEwoXpj5qfE9gF1TDXMUFB01mqjFQQFCTFyD1Wh02wYhc
	h9aolsmksY62Ye/sJcFsVBOl0QLCPWh8ssbRKaqBVBZExbUlbbrggRRB3lT02vc=
X-Google-Smtp-Source: AGHT+IHtqnFs/FEwdhrPHwOi+0+udg3yzYydTyfzWKEobm+Ni/1VosCUSDW6cmBwxgbprjD7V8QCTg==
X-Received: by 2002:a17:906:3510:b0:a58:eb98:6806 with SMTP id r16-20020a170906351000b00a58eb986806mr3168389eja.32.1714639013649;
        Thu, 02 May 2024 01:36:53 -0700 (PDT)
Received: from ?IPv6:2003:de:373e:dc00:b298:a6be:282c:8242? (p200300de373edc00b298a6be282c8242.dip0.t-ipconnect.de. [2003:de:373e:dc00:b298:a6be:282c:8242])
        by smtp.gmail.com with ESMTPSA id gl7-20020a170906e0c700b00a588bcdaf98sm280651ejb.183.2024.05.02.01.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 May 2024 01:36:53 -0700 (PDT)
Message-ID: <cde66b7dff6ff4db2ed832c670fba475278e6527.camel@suse.com>
Subject: Re: [PATCH v2 2/5] libmultipath: change flush_on_last_del to fix a
 multipathd hang
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Thu, 02 May 2024 10:36:52 +0200
In-Reply-To: <ZjFir8_To8UGoYVK@redhat.com>
References: <20240425233517.2125142-1-bmarzins@redhat.com>
	 <20240425233517.2125142-3-bmarzins@redhat.com>
	 <5a5aa59a1b60ee0e91abeec292ef3d591d55a7e7.camel@suse.com>
	 <ZjFir8_To8UGoYVK@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-04-30 at 17:29 -0400, Benjamin Marzinski wrote:
> On Tue, Apr 30, 2024 at 07:06:24PM +0200, Martin Wilck wrote:
> > On Thu, 2024-04-25 at 19:35 -0400, Benjamin Marzinski wrote:
> > >=20
> > > 1. create a multipath device with a kpartx partition on top of it
> > > and
> > > no_path_retry set to either "queue" or something long enough to
> > > run
> > > all
> > > the commands in the reproducer before it disables queueing.
> > > 2. disable all the paths to the device with something like:
> > > =C2=A0# echo offline > /sys/block/<path_dev>/device/state
> > > 3. Write directly to the multipath device with something like:
> > > =C2=A0# dd if=3D/dev/zero of=3D/dev/mapper/<mpath_dev> bs=3D4K count=
=3D1
> > > 4. delete all the paths to the device with something like:
> > > =C2=A0# echo 1 > /sys/block/<path_dev>/device/delete
> >=20
> > I've tried to reproduce the issue with these commands. Test system
> > was
> > using a LIO iSCSI target with 2 paths. I created a=C2=A0 test script
> > (attached) to try the offline / IO / delete procedure repeatedly.
> > I haven't been able to make multipathd hang even once.
> >=20
> > I also played around with dd options. If I use oflag=3Dsync or
> > oflag=3Ddirect, the dd command itself hangs.
> >=20
> > Did I set up anything wrongly, or does the behavior perhaps depend
> > on
> > the kernel, or something else perhaps? Mine was a 6.4 kernel. This
> > is
> > not to say there's something wrong with your patch, but I'd like to
> > understand the error situation better, as it doesn't seem to be
> > trigger-able on my test system.
> >=20
> > multipath.conf:
> >=20
> > defaults {
> > 	verbosity 3
> > 	flush_on_last_del yes
>=20
> If you set flush_on_last_del to "yes", then you won't be able to hit
> this, because you will never be queueing when multipathd tries to
> autoremove the device. The goal of my patch was to make sure
> multipathd
> never hung on an autoremove, regardless of the no_path_retry setting
> and
> the flush_on_last_del setting

Stupid me. To my excuse, I'd set "flush_on_last_del yes" because I
previously had been unable to reproduce the multipathd hang with the
default setting "flush_on_last_del no", and thought I'd misunderstood
something about flush_on_last_del. But I'd made some other mistake  at
that point, apparently, which caused the issue not to reproduce.

I just set "flush_on_last_del no" and indeed reproduced the issue with
my script, immediately.

Thanks,
Martin


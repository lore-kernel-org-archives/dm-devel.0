Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53E923D7DF
	for <dm-devel@lists.linux.dev>; Tue,  7 Oct 2025 20:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759868642; cv=none; b=l1smU8FsVXZZLiOjgj8NvaDR7X+HNRY1o2CgwEdarqg0EVvVMtXzzVbN9dLUQofe9A2ez2C+asQo2ONgRPHMLGLgiWFaRqE7DSZc0yA7ERlazLeKyZZB4iqaJBPDkUXICUJluJo/4Cp/gxMyXcyQSGyVL2PDCZY9uZjL6T8iAy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759868642; c=relaxed/simple;
	bh=ctnKDPlYwTiZk5+oF4xdx9tvn1Vbkp2wHwLtougi6Rc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XLO3IftdngT5nqxFLchsjvleWoJ3yZbVSm/Y87hITms3oGBc1UHr387BsBPzFN+H3TQrZDKJJkVbUAcOFuU7J12AO/ENQAmBVevUyxZQ9TrngBpsoKWdNPHgw96CZTHcpldO/9PVo87IymXvISUrBQcjAL0/YR9qFhfgxBhQkho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Nsr2ZdFx; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Nsr2ZdFx"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-421851bcb25so3578888f8f.2
        for <dm-devel@lists.linux.dev>; Tue, 07 Oct 2025 13:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1759868637; x=1760473437; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ctnKDPlYwTiZk5+oF4xdx9tvn1Vbkp2wHwLtougi6Rc=;
        b=Nsr2ZdFxAR2Zk8pZn0ToHEivnLceASygj0T+aNnwxX+YnratCF7BmUWRWnE0nnmwzw
         7bVScdmH9Qz9RbLF6nh2wmeDkCB0Ueo1anL4ZEQ2lhuNFc9AVCU2cZyXX2l2beKHAzdx
         6o3o/BmxtmBfWThg4QUQtDJ1mBMirduPl7Inu5IifdfwCIKtb3Z+mUTne73SCsOU/bOQ
         qXtb+rTWBFQ5yXQJ7UcVl/TqWhNxb9Lo5ELA5q5LYZeuU7zxISn6kl5dAGyLPMxM/25q
         UKIAYC6hC4pnIBBv2byv70JL0rx6xZWOWztXLJNoDJqWbOJxiKnKmzBNkCOwL0SHo3rV
         MSNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759868637; x=1760473437;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ctnKDPlYwTiZk5+oF4xdx9tvn1Vbkp2wHwLtougi6Rc=;
        b=ZxUMQgO0tpvZfW8LGrFOzynhTQbwpDJBCgLZ3mNkCBI32CoCW/X//5eJdq+qESbP/O
         i/VQ7lEJwB58pP/294LsbDXoCjO2OU9NKjnSBHrAoMdzwr7j3YqQo+YBj8Fc0fHn9jS3
         ueFo88qaolvfA2H9z7sMugbnh4pUkOFrxlHGshqYWGDVPI9Mr2gj5gAYpF+liRXMWjRi
         CT7C+hqRMMZ6AGJPSjwd5a9PZ3wuWc/0Z5xfHZS3+c3Fk3iRK+U+L8kBrFkqULlqSRGL
         DLYrifSkdIv/81sd3d+bAMlTbz2K9ytdCugtdu+VVAVeScatEPNY3Y45QHEtnSz7hlQV
         EEYg==
X-Gm-Message-State: AOJu0YzxDVhyaGy6YU+xZswNxp8lnfYnqPhIi27PA0c0lLSdNbyGWVCl
	eka01xyOPjZ9ADdAS8k681DKzrZfBb3AtI1GCXwbUhJlb1118IxgSAla62pJheOmmdg=
X-Gm-Gg: ASbGnctox9epJ1OOQROogMwR4tmMvPrbWXQf/iaxvTE+walQMfY7Z6gwJqRc1WZC2sX
	wlxQuPUPdNXlDG982QfQI+tJ0UDYPdDixsHteozjN8Q+JfJJQ/A4G92EtyBCpQnR7ND8em6QOAQ
	3NkscuJjBp893yHVgJXEEaAU7Tw/3rFdfzSaa1AORBeMfyW0ANgOOQCndtVUzfotJH9WmoTv975
	IZog9MeygDH3REghPF3Q2d/WUFXvQN2PSKGAqkyVH6xYDdq6G0bbAvtHc5peZqlGpen9F9eR2nH
	elKVaNBo+Mfq1ypcei69TopjQgAsCmn4woBvZxtvE6Ah7wCADrEAEVcUW5Myq+5KSjjWe5RoU2R
	A1ljE6PKW0BfC1IO8xbK5wuRCKK4ZJHSMoCftACD5DPuS1/xhiQDO5lfsUAzRiNNdAqy5VUsPbt
	hYVeLdN7rCZGRnHCvgONjRdEsfJlzAgVLBfz+26n/4yVBJ//0doVPYkmnMXfPpyh32F3+WhAx6R
	rCtR34=
X-Google-Smtp-Source: AGHT+IFZstHUadrcXHWZP3tthrHks5urb+N5P8H51m3Ac4GU2mjyD+7hMgYv5Vgt5N0Kha2j8k2YWA==
X-Received: by 2002:a05:6000:603:b0:401:5ad1:682 with SMTP id ffacd0b85a97d-4266e7bf04fmr453425f8f.14.1759868637018;
        Tue, 07 Oct 2025 13:23:57 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f04:900:e894:a50a:fc99:6ee7? (p200300f97f040900e894a50afc996ee7.dip0.t-ipconnect.de. [2003:f9:7f04:900:e894:a50a:fc99:6ee7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8a6bbesm26617194f8f.12.2025.10.07.13.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 13:23:56 -0700 (PDT)
Message-ID: <ea8f1cc956e27debf0ee3645b21a846c9c9e8e5b.camel@suse.com>
Subject: Re: [PATCH 0/4] libmultipath: Yet Another PR patchset
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 07 Oct 2025 22:23:56 +0200
In-Reply-To: <113e928d9b68ed3b0ba5bd0b0ae87315890f94cf.camel@suse.com>
References: <20250923221252.1411687-1-bmarzins@redhat.com>
	 <113e928d9b68ed3b0ba5bd0b0ae87315890f94cf.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2025-10-07 at 22:23 +0200, Martin Wilck wrote:
> On Tue, 2025-09-23 at 18:12 -0400, Benjamin Marzinski wrote:
> > This patchset handles 4 separate issues:
> > 1. The self-preemption workaround for changing keys using REGISTER
> > AND
> > =C2=A0=C2=A0 IGNORE, while the path holding the reservation was down wa=
s
> > broken
> > =C2=A0=C2=A0 by a recent commit.
> > 2. mpathpersist was failing a RESERVE command issued on a multipath
> > =C2=A0=C2=A0 device that held a reservation, when the holding path was =
down.
> > =C2=A0=C2=A0 Issuing an identical reserve on a device that holds a
> > reservation
> > =C2=A0=C2=A0 is supposed to succeed, and multipathd has enough informat=
ion to
> > =C2=A0=C2=A0 know the device is actually holding the reservation. So if
> > =C2=A0=C2=A0 multipathd says that the device is holding the reservation=
, it
> > =C2=A0=C2=A0 should not fail, even if the path holding the reservation =
is
> > down.
> > 3. mpathpersist was not clearing the reservation when the key
> > holding
> > =C2=A0=C2=A0 it was unregistered, if the path holding the reservation w=
as
> > down.
> > 4. When unregistering a key that holds a reservation, depending on
> > the
> > =C2=A0=C2=A0 order that the paths got unregistered, there was a window =
where
> > =C2=A0=C2=A0 IO going to the device could fail. This should not happen
> > because
> > =C2=A0=C2=A0 the reservation should be removed and the key should be
> > unregistered
> > =C2=A0=C2=A0 atomically.
> >=20
> > Benjamin Marzinski (4):
> > =C2=A0 libmpathpersist: Fix REGISTER AND IGNORE while holding a
> > reservation
> > =C2=A0 libmpathpersist: Handle RESERVE with reservation held by failed
> > path
> > =C2=A0 libmpathpersist: use check_holding_reservation in mpath_prout_re=
l
> > =C2=A0 libmpathpersist: Fix unregistering while holding the reservation
> >=20
> > =C2=A0libmpathpersist/mpath_persist_int.c | 199 +++++++++++++++++------=
-
> > --
> > --
> > =C2=A01 file changed, 125 insertions(+), 74 deletions(-)
>=20
> For the series:=C2=A0
> Reviewed-by: Martin Wilck <mwilck@suse.com>

Nope. I meant to reply to the V2. Sorry.

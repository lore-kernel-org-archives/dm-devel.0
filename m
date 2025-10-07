Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B006223E334
	for <dm-devel@lists.linux.dev>; Tue,  7 Oct 2025 20:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759868602; cv=none; b=I9g/jGsFGd6SVgiDhFap9h+IjXvKbHH9KSsMjIjIwv4rwGcowwoq2r5u7XqdlLVoRNCE2qePbAtXMO/9/kxY0bnzc3hXbEJvTDJWnZiXiYoWT8UP4jS9EYaMRu63KF+oxvd5A5L0ySXe4lRyBN2u+E38cMxi6p7gqufKTxSpN40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759868602; c=relaxed/simple;
	bh=ufXCxfnNxxDWMxVJ4pLJKc466T+OYY/1PMnonChpNgU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=auLlskBynD8ieajvAhnrPbWRpyzIrmFe73/imvy1RLcztliv9EntCNuhKv+YDxLqBVzVmEU9Mn9e2+gLD1WOuCekPVq6dpsuvWnMtlifLBkuasB7U8WfmASIvfFFLNTzeu0jW04yIm/NXKU+MwbHugIsGEqHmXuM+pSIBuoz9rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=W9k0I5xZ; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="W9k0I5xZ"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-46e37d10ed2so58639905e9.2
        for <dm-devel@lists.linux.dev>; Tue, 07 Oct 2025 13:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1759868591; x=1760473391; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ufXCxfnNxxDWMxVJ4pLJKc466T+OYY/1PMnonChpNgU=;
        b=W9k0I5xZpT9yGMK4Y6PeNASDcyl1pdUCngdQwv7r9tsfrn175l28NW4n5f4IT/E2aG
         t13EHdL7Nny671towIshuJzB0WkhH/+JCcsz/4px/SBjMQz7CT+pDDjHnfIBT1HhGf1t
         QZSGC7Vb3Ju3ryAh2aFjtBsedgbLv6k/7Trr/fuaAy9q9C2yV7h37w9d/aonDWS3OLdS
         p5r3Gg3rN0iZF8RGkqhcQc3lihRrFtrSgRvRmCOjXUDBbRs5EfMEI43AJ71ldqNaJSXJ
         BwECFTaTGS2bqZHMCfjGdqMM5Me6OioULmicDcgHPMDges6QseAs3JwAaiaNVOlEVFlD
         dfMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759868591; x=1760473391;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ufXCxfnNxxDWMxVJ4pLJKc466T+OYY/1PMnonChpNgU=;
        b=uU2mSDvFyHXsvALnwyttTJ3CDr8VZJbUGNTfKwxbnHu4EYgdFi8+G21bxSX6FaW1ta
         61vs3H4+vMB1t2D69yU1A6tqodSIsUcSEILvL40u7khkx6mXGOz7YZZgoyRjficAK4JB
         h0v5XvdEvYDcHXPMEpg/VW4wp/xByAtwFuMI1B4goBCMZ5Rky/u1MW8txB7IuLWiGX10
         nqFLtOSjGtafdG1zMeigkIgvYzgylRBO0zLMym0rV3xw2VxvqYjTrNQVoo1W29OWNg7N
         eQWZqGGe7tw5q/KVG8lkprrT6z5R01kiXmih2NA8uXxqo51FeHNcnvk/CKd50i9A/4e5
         xjSw==
X-Gm-Message-State: AOJu0YzTeIQrnxJyNRyYWWzyGzg2xZKoKpxGmvzVtxEGi59D+cRcDmLN
	pf/w5Y6IY4APv++5NLrVtEK38x0Sq3hz8mJRXAKACMeANDIM6ULp+9Wu5NSAwSNGFy4=
X-Gm-Gg: ASbGncuWbl5aQWOo/8cKYa6786tjONumqRC6+OaMT/mDeXdv+0nQ3Hf/FGm7wWSQv2l
	XpjnVO1tmk41KqwGqBhbKnNrNWiFJ6wOefIy66uVAOfb12TtSuFaaYRzGnjPad1+w85kfUcV4R3
	QltzixK8C+z/nqwqAV4BeQ6cuTrfgcD0D3UnEvcPqBJFuvPn025FNfoqS5v0FhTxSvu4JQioIW8
	Akz79iNXDBi9mQyOecAyd3CuGaWecuwT23JWh6IDDiNVuBM9ezBNrOE4k2i3cmtKcjejJFVFG/O
	La7HD12dPT1aRstFrdtduY+P0k2y5nStuP3LO8eT5kqMoKgl6YW2If8Y/MY+HZjE8JVCmCcjgmi
	/4lyIaNDdNLI/kNC4DW6giwXbnJ+ETBgaKE8oD2QZMtiF0Gs/Q8tZecB8Vd19efhUCnjfRBMn8Z
	epHCM2Kok3jnIRXBsc6s6y0jHhLZ0a6YNcXGgjxPkutXXiW9nYCd1sPW3tzm1nbBtpGpLPKrOBW
	nYX3EsWW4UZySJ9+w==
X-Google-Smtp-Source: AGHT+IFBggWsXRAm/EQoOw21YtoCTNzPUbjTZhgmRXa235FXyoFVyqRt4tzQkQOEBCrD1l/L1FNleQ==
X-Received: by 2002:a05:600c:198f:b0:46e:38cc:d3e2 with SMTP id 5b1f17b1804b1-46fa9af3125mr6330005e9.22.1759868591426;
        Tue, 07 Oct 2025 13:23:11 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f04:900:e894:a50a:fc99:6ee7? (p200300f97f040900e894a50afc996ee7.dip0.t-ipconnect.de. [2003:f9:7f04:900:e894:a50a:fc99:6ee7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f4ab0sm26898705f8f.52.2025.10.07.13.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 13:23:10 -0700 (PDT)
Message-ID: <113e928d9b68ed3b0ba5bd0b0ae87315890f94cf.camel@suse.com>
Subject: Re: [PATCH 0/4] libmultipath: Yet Another PR patchset
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 07 Oct 2025 22:23:09 +0200
In-Reply-To: <20250923221252.1411687-1-bmarzins@redhat.com>
References: <20250923221252.1411687-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2025-09-23 at 18:12 -0400, Benjamin Marzinski wrote:
> This patchset handles 4 separate issues:
> 1. The self-preemption workaround for changing keys using REGISTER
> AND
> =C2=A0=C2=A0 IGNORE, while the path holding the reservation was down was =
broken
> =C2=A0=C2=A0 by a recent commit.
> 2. mpathpersist was failing a RESERVE command issued on a multipath
> =C2=A0=C2=A0 device that held a reservation, when the holding path was do=
wn.
> =C2=A0=C2=A0 Issuing an identical reserve on a device that holds a reserv=
ation
> =C2=A0=C2=A0 is supposed to succeed, and multipathd has enough informatio=
n to
> =C2=A0=C2=A0 know the device is actually holding the reservation. So if
> =C2=A0=C2=A0 multipathd says that the device is holding the reservation, =
it
> =C2=A0=C2=A0 should not fail, even if the path holding the reservation is=
 down.
> 3. mpathpersist was not clearing the reservation when the key holding
> =C2=A0=C2=A0 it was unregistered, if the path holding the reservation was=
 down.
> 4. When unregistering a key that holds a reservation, depending on
> the
> =C2=A0=C2=A0 order that the paths got unregistered, there was a window wh=
ere
> =C2=A0=C2=A0 IO going to the device could fail. This should not happen be=
cause
> =C2=A0=C2=A0 the reservation should be removed and the key should be
> unregistered
> =C2=A0=C2=A0 atomically.
>=20
> Benjamin Marzinski (4):
> =C2=A0 libmpathpersist: Fix REGISTER AND IGNORE while holding a
> reservation
> =C2=A0 libmpathpersist: Handle RESERVE with reservation held by failed
> path
> =C2=A0 libmpathpersist: use check_holding_reservation in mpath_prout_rel
> =C2=A0 libmpathpersist: Fix unregistering while holding the reservation
>=20
> =C2=A0libmpathpersist/mpath_persist_int.c | 199 +++++++++++++++++--------=
-
> --
> =C2=A01 file changed, 125 insertions(+), 74 deletions(-)

For the series:=C2=A0
Reviewed-by: Martin Wilck <mwilck@suse.com>

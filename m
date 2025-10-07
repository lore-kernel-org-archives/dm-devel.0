Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8515719EEC2
	for <dm-devel@lists.linux.dev>; Tue,  7 Oct 2025 20:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759868741; cv=none; b=geGbeFG1Wd2hZP2lFDkyGgag8B9+InK0Mz9uFFy69W8CzVH+q35WqJW+arVIOmTmjVrXsf7XWFO2x21PP2wMBUwb38DDvNQS5Rl1cCRAE51sjBG3QywnklDMoLiKuyfYmmBZ6iJFBRrNogjLfYzS/puVtPeRDy2LuF+KE7T2k4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759868741; c=relaxed/simple;
	bh=gAhl2fL7Ng5NzNupk8rci70PhsIpyzeJAXPIb9Sxij8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=o8ALjVo4CeyPN26Oe6hUksv7rQ6M6SdeZiug+hY95h1/yxEJ+90YsPmXQSSzFOvY7EVejOKBaUoNQ/NcSjg9aZJJ7DByJMrn2gfcsQEiZ3yDelFdUO8vW3gbC8Ok1lqlpaMAZ3IvwbQKFoTkNIVHTLEBAsWDYtPEp82yXhXxLWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=C98z3aY0; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="C98z3aY0"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3f1aff41e7eso5134533f8f.0
        for <dm-devel@lists.linux.dev>; Tue, 07 Oct 2025 13:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1759868737; x=1760473537; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gAhl2fL7Ng5NzNupk8rci70PhsIpyzeJAXPIb9Sxij8=;
        b=C98z3aY0LnN+zOQHIfbzNkoubCY4AwokTeGC7ou+vXK/7yJPqf0x8Y8slWgx3tXXec
         Mth2lLMkZy87YLD4EK3c9Y62s/kDpAVr1TwV1/7Q1PsBi852TRp7VuaOjzNx2bkATy6J
         6ARxWEbOOrqsek1qh5D1ypxGEwc69eR8xeoWnpGsXPiLXBev++BEr3znRmmDWGiKJh5a
         EFGmLKiNuPwGgcmGa5bNfWEy19gL0sq/IzytqDC1SSfAEJJB5PteObsxeYh7ykCGNNbL
         57iVHXUJi3NjA7onkCI/YVaay/DIdZ6ze3mn/XsSkWrYTIeHTvFSWe/VC8MwbF1aRRik
         APaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759868737; x=1760473537;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gAhl2fL7Ng5NzNupk8rci70PhsIpyzeJAXPIb9Sxij8=;
        b=f1h3IA+czheeUEunFdlfMjoXZsXdZxWDLcbBLHcPRK6x3/c8VMYm9G6TtyWA7JG2vV
         0g9hYLIY8kPpTjPjrpm8O3TUaHLfLS2m8B2dshnzHwgOr+/EjN9fzOciQDtGgbgG6R5T
         IpU3xwkpmSISwPc2h3DHG1263FVelj7Sox4wCckTtvO/yY1WUf6dyKO3kV6DkkcYszvy
         9kJ0o4XSnU30Pr7BCKJmrQYDbW4nTUYkbt91geYoFaLDlNjMbYErnOLgb2wPtZVTGHTn
         zUYhvw5sl5wAN1zQX0tuKMBEe1K//VuU/hg5WTLPEvzOMHDr+kVOyJ4pyb+S2Je3JX3l
         0VMw==
X-Gm-Message-State: AOJu0Ywl0u7/HtjHxTnBix5PSt4+lriH/dq1eSKrNoCgqANcqqkOT4vC
	uiO0QnDAfD9LafQRl3yPBFKZNj883fynzUz6uBcG2FCBmZ26AQzJ/gyBv1EfWd2x6Ys1XJrjH5A
	OjFWV
X-Gm-Gg: ASbGncsEDcy77QWMPjsgFIKnLjC+zgYJXebQxsu88xjbbmFMouKfNy2Y2Kk0xFNyU+g
	rAr+CPrO6bVTDH8A2xjOCdMhzjuBCVQ8j6guvw7JGvn65MMlig/lxDuxce0svRwf96E3I0wRo76
	HZpRPCGiNtyxaeoPw++WMI3zwO3RrLKUXdI24O29CwT8uPb4c/AOXx71qGLPMMBGsMxMZ+5hKBT
	IFvOX71svX5r6kd9Ptw077N7/W4xjw0LCcktcUtU0truJXMiofEPVWcYMLl/5T/THDh7zHCG/de
	x8irxBG+7aJy5FFL0a9OXVDjPvUlIIXECGleJ47OZ95ZYA01IS/HlVBA/p1iSrsk8UFNVvhMLwc
	crPDQts4Qr+jRi/8Ui3+iLGh5+LsC19B4+9bAMWGYQkhR+x1tshMzQ4Fn1D570oIceyTSoZTd6F
	ZQjEOVqKU8aIMCVwSZ9VYTNe0TpmiSKybxHteYnxL+Hd571VPbt7BXcVozkWYANlSQyh/08xpxX
	ysU+Y7Frzxn6W2jdw==
X-Google-Smtp-Source: AGHT+IF+NOOCkfTMK3vRWOBiAroAIbV+ERXckIPmOQbAaFSndCY7LxwpoTBvC+/Ng1uwePpjCEdmKA==
X-Received: by 2002:a05:6000:2303:b0:3ec:dfe5:17d0 with SMTP id ffacd0b85a97d-42666ac42d9mr357459f8f.9.1759868736771;
        Tue, 07 Oct 2025 13:25:36 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f04:900:e894:a50a:fc99:6ee7? (p200300f97f040900e894a50afc996ee7.dip0.t-ipconnect.de. [2003:f9:7f04:900:e894:a50a:fc99:6ee7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8a6b8bsm26705191f8f.4.2025.10.07.13.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 13:25:36 -0700 (PDT)
Message-ID: <95b25bad422df745e816b92e0918076ef3fda623.camel@suse.com>
Subject: Re: [PATCH v2 0/4] libmultipath: Yet Another PR patchset
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 07 Oct 2025 22:25:35 +0200
In-Reply-To: <20250926172854.1548351-1-bmarzins@redhat.com>
References: <20250926172854.1548351-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2025-09-26 at 13:28 -0400, Benjamin Marzinski wrote:
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
> Changes in V2:
> 0004: reworked how the unregister infromation is passed to an from
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mpath_prout_rel() to make it less confusin=
g, at Martin's
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 suggestion.
>=20
> Feel free to reformat my patches. I forgot to do that first. Sorry.
>=20
> Benjamin Marzinski (4):
> =C2=A0 libmpathpersist: Fix REGISTER AND IGNORE while holding a
> reservation
> =C2=A0 libmpathpersist: Handle RESERVE with reservation held by failed
> path
> =C2=A0 libmpathpersist: use check_holding_reservation in mpath_prout_rel
> =C2=A0 libmpathpersist: Fix unregistering while holding the reservation
>=20
> =C2=A0libmpathpersist/mpath_persist.h=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=
=A0 3 +
> =C2=A0libmpathpersist/mpath_persist_int.c | 204 ++++++++++++++++++-------=
-
> --
> =C2=A02 files changed, 134 insertions(+), 73 deletions(-)

For the set:
Reviewed-by: Martin Wilck <mwilck@suse.com>


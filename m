Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8A61CCB2E
	for <dm-devel@lists.linux.dev>; Tue, 19 Nov 2024 12:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732018819; cv=none; b=SVGE4mhWiuqZxgcsOvVzWnIJzNOzsiXKggq/CqQIJQQDIZo++PFbZ718W/nALj4eWyxWErVvEud59bjgpkSR9ckLqSKuJBmOlaGdUnu4k0mTS8muIqQKrV0SAoZoH8V7FU8Lqi+dxnVNSJCS3l7ZeZzJe051r9s1YHWZve5pK58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732018819; c=relaxed/simple;
	bh=Xnia4m9OPdaKVzFcD/P3AOFAmHd653S7HDNeD0OO82M=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CH67r4XpXhfzSk5AQvsxJyjqm4fO2IHUluLVHQfjNoyBP7UNySpk7gcmtLXsOBFtkp9tW6LX88/djcHet0vFmrSNyJzY9FY4GyeMoeJ4M0OnMaF9/wqWR5oyEhKyHWh2GF4q5C3ilq5TfQLvgzBOu6XWUxbQid+c13Ajmny+lV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FTYgLBei; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FTYgLBei"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-431695fa98bso7076395e9.3
        for <dm-devel@lists.linux.dev>; Tue, 19 Nov 2024 04:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732018815; x=1732623615; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Xnia4m9OPdaKVzFcD/P3AOFAmHd653S7HDNeD0OO82M=;
        b=FTYgLBeibf4g51EGFRWFj/j2eke2uTD/2NPX7l6P3nesZJta8OeuY6GhV2eGB6/IBj
         wzHrReuwUpS7oNrkypJkyge11+NjB+ufl2yvgOzaW9ZnRbIH6EzpEn5Zo4E8e5aB8/ca
         cBq7R+vFDYPLgZY9EkWOcKyxk3vINVVDUc/1uwVsEDCVuv5VT1NFtn1KE7Yk4xj7S2MM
         a70DBHAMQDfBLt33JKgCM/cRDW/hZGGEBybh01snlrrYAA5lAVFvBBflZIM9HkC7DGbO
         zgmr3ovg2rLnX3QDx+7G+7Sxhle9nm2uBQi7ua7gaem0ykmIQXKpFT79Kb69JXE9yHoM
         oHug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732018815; x=1732623615;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xnia4m9OPdaKVzFcD/P3AOFAmHd653S7HDNeD0OO82M=;
        b=KYmdB4lUpwZWid6s8++/gI6vZOVRdROlBgnwZnzBdC7naFSOhkmwFv+7zfP2MptnnW
         oVwigQaMjFpzCmlOdso3ipXTjv/XVmPQvELiLdEbkwiH3dpf1JLJfKDNvWwzppCO4kGf
         VWVLnUjC1/8nlnh29OhAWG87uAll8wNg8JsqZ9n4CrRRiGE/Tf3JX2JfkAy3A+1Gqp6K
         O5nAtAC0AuTz8gwwtQ4Xtk216ykIGxe8CTO0/UTAJBOHCpkKsWyqJqqGOfTpkZb+kNL0
         3SPGUrPb11oxCvwFdfIcknB5DhMVI0TAz3+2m6fl2F/0dQ9/MstJsyjDqM/snkSKl+Cc
         sIfw==
X-Forwarded-Encrypted: i=1; AJvYcCU4qgjiHyQ5xnsgZDM+GTYngmpBEeJQLOQM+csjoTmdVZ2xlD7Z74+jC+KoBdcdHHPprtDuvecY1A==@lists.linux.dev
X-Gm-Message-State: AOJu0YxllcReRln94i/SPtjxYv5Da3JjJJCS7HD1wzU69GhT6unsu9BL
	IyS7PXue8/51SG0jMiFpNh9/MzpUkjMIpM9WmGWtjllAVfFB9hA1aO5V72Gg2eo=
X-Google-Smtp-Source: AGHT+IHsEamPtLZuR6mxTA+ynQB0Q0kTQ/s5TkbCHT2b9TDDUyYlcBiRbOwZ0ipzr9+bcn4x8CkvfQ==
X-Received: by 2002:adf:e193:0:b0:382:4851:46d8 with SMTP id ffacd0b85a97d-38248514821mr6225687f8f.8.1732018815133;
        Tue, 19 Nov 2024 04:20:15 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-382456ba017sm6685762f8f.97.2024.11.19.04.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 04:20:14 -0800 (PST)
Message-ID: <23860ac02355acab86798e2ce3d582ebed61a0d6.camel@suse.com>
Subject: Re: [PATCH 0/6] multipath-tools: Handle tableless DM devices
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Tue, 19 Nov 2024 13:20:13 +0100
In-Reply-To: <ZzuuUTMJgFPWV16s@redhat.com>
References: <20241115232256.627933-1-bmarzins@redhat.com>
	 <fbab2026d6850617f84da01c9c075f468295aa3b.camel@suse.com>
	 <ZzuuUTMJgFPWV16s@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-11-18 at 16:14 -0500, Benjamin Marzinski wrote:
> On Mon, Nov 18, 2024 at 12:18:20PM +0100, Martin Wilck wrote:
> > On Fri, 2024-11-15 at 18:22 -0500, Benjamin Marzinski wrote:
> > >=20
> > > I'm not completely happy with the MAPINFO_ID_IF_FOUND flag. An
> > > alternative would be to run a second libmp_mapinfo() call without
> > > MAPINFO_MPATH_ONLY to grab the name, if the first failed with
> > > DMP_EMPTY.
> > > If people think that's a better way to solve this, I can rework
> > > those
> > > patches.
> >=20
> > We could simply choose to always fill in this information if the
> > the caller has requested it, without an additional input flag. It's
> > not
> > an expensive operation.=C2=A0Is there a reason not to do this?
>=20
> Your comments in the code said that libmp_mapinfo() will not touch
> any
> of the output parameters if it doesn't succeed. I didn't audit the
> code,
> but I can certainly imagine a situation where you passed in pointers
> to
> some varaibles that already had values and you didn't want those
> values
> overwritten unless libmp_mapinfo() returned DMP_OK.
>=20
> But I can go look and see if any callers would get messed up if name
> or
> uuid got set, even when the found device didn't match.

I am pretty sure that that shouldn't happen. The memory must be
allocated anyway, and callers can't ignore the return value. But
double-checking is a good idea, of course, and we should adapt the
documentation.

Martin


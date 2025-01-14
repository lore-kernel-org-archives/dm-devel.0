Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5C5213258
	for <dm-devel@lists.linux.dev>; Tue, 14 Jan 2025 22:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736893868; cv=none; b=iXU0mjMJsB+PVV544EpAswoXK7Rf4z70KQTijlmKGePrD/ecW+194uube4phu3OfiUrWqjRjbX+FdbRwJ+WENJIpWIsFzVVrabMm1bc0MyR0DMX0Rk+vht2e+bQGnKsgh+Fj5FtGi6+3GmhwxJXp/DRH1BJJq4XeUpwI791H2Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736893868; c=relaxed/simple;
	bh=RW5BwFLHYxBg+dOmJySzx8icvTaXy3mUHys8ejadWr0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QxFdtsQDwDYkdyuiaaTePQZqoFrpBS4KgjjN05Q1ZV7XLuqpNJgg1SaQWJxyG2/plmTBE/bRwmXVf/SdEGfC+aXY+Ey7+iPUb+iH2sMAUDwU+Px6OrcKVjCRe5FF7lfAiGViL+wvCvDWVeB/L+4tVig/zARyYMxr7L/p8wTVw5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WeCf5NcY; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WeCf5NcY"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aa6c0dbce1fso869570566b.2
        for <dm-devel@lists.linux.dev>; Tue, 14 Jan 2025 14:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736893862; x=1737498662; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RW5BwFLHYxBg+dOmJySzx8icvTaXy3mUHys8ejadWr0=;
        b=WeCf5NcYHzbjCQHdJx8qeRVNJ2bCYA2twdDcrkYf7+Y2/I1y/H/Q9T0PfSYYVOJ/Ai
         gtZvHZapbyzhGUEePNV18/C5Gs9YRPsStZ3u6KHOOzuO9dFDptJNdEBEAkYrcUlotWfb
         klZRKHIYo17dt8XyOnWuWxvCugMxCeABTFDu+4Z/s1kYkzMuKR+AK9RoEEX0tHUsKUgK
         mceQFEMR7q5gJ7rKCD44IpEEgg+ulqji74RXb5a8t9NYUrK+F7AoYaiM4Ekl7Y0a2ptp
         nLhAHH9hAMc7RWCJNLXFpDbly1AHd0p+cXUat/vKTKZHhUMSMw1DSP3DvqgIR0pZuxlT
         cS8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736893862; x=1737498662;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RW5BwFLHYxBg+dOmJySzx8icvTaXy3mUHys8ejadWr0=;
        b=GtC5+P+zTjUl4vQcykURcUWef5pPgV41KV215WTaNTKLprL/6wMZGM67rMFUpkPV0k
         Oac3EydLlsznWWJNPb21zcPNLtZTecnosXubgeNMDP1VpuKoW1v+1X4hgZpJquln6J5n
         I5/P5a2irXc5v5A/p45V3t8I2fi/43ExZOd0reiotDrB+wUq6MHpisNd9NzjWH8Esub1
         v9cLBN/1coITirVAhgz4REH9ponxJE5TcfTB1HAjl2CXEH/7L0d9IYK2Hf9iPwGkX5ne
         LrQYFRyOlvrIoa8g7P1Y/+lPMGtLl+R4WwNIzrAGzMKqmb/QxG1BSTjfeyoz23C3i5G8
         josQ==
X-Forwarded-Encrypted: i=1; AJvYcCWV2Y7QIBM7I9dGC24LFQvlbkMwxXm9NMhGfUh/Hj74j8rVBJhj79bo5t8k2wwQZKte8Nf0TjMTIA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzYKvU/B2WAHtPsjlvkuiE1qDS4MgEoKMW+nz2zqqEYPN/IauAI
	PJS/dnElf/iEwtYI8Xqu2h9QtyCAOp44cIn1/Q8JZnVCcMYqR4R/HiGkOhhm0Jo=
X-Gm-Gg: ASbGnctkCbbHorZAYv0ch0gSSpBygImCaJiLhDgEReSOfdU0KtMhr5QyCei05sBcavs
	ANrUeHMOvqcn3UKplYZdJbu8HwO3GbZVudWysdSnANO3y9qZUgOnqmab0gI5zRpmTpTCQ+poCfc
	aYb8nEUpkYUtt9ezqqwwTq+lJgfNW5oitD8tjGgrlfPiMYbAKu7haiqheI3yBZ6B+D2w6XuGbqT
	7F1RjbWdB34byLE4IHQBt0smSLQjPYsVDKYLE3aaR1r/FAE74zDaKrADBi6qWt3XtBj84Zsn9z7
	n4H224FGQjGIy7vnZaE/VFAzYS2tEFTeL35UhE9ES9S8/9s7C/mjLVK+uv97RXAjw+Pat+XiSGv
	6YLsNU4Bf3fWx
X-Google-Smtp-Source: AGHT+IE4c3RZVOXQzWSdu0voEKUwJaewfjUE7ARePvClVFAvkoLzzUsplSsNLmqFVj7hD3qXoD9WcA==
X-Received: by 2002:a05:6402:50d4:b0:5d0:9054:b119 with SMTP id 4fb4d7f45d1cf-5d972e63dd4mr58780984a12.21.1736893861751;
        Tue, 14 Jan 2025 14:31:01 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c905ecb7sm677466566b.26.2025.01.14.14.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 14:31:01 -0800 (PST)
Message-ID: <7fd13eec94452ac1128158aa7fb79ea08367641f.camel@suse.com>
Subject: Re: [PATCH 2/2] multipathd: set rport port_state to marginal for
 NVMe devices
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Muneendra Kumar M
	 <muneendra.kumar@broadcom.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Tue, 14 Jan 2025 23:31:00 +0100
In-Reply-To: <Z3wVVg0AgLLq4EUN@redhat.com>
References: <20241220020235.1759375-1-bmarzins@redhat.com>
	 <20241220020235.1759375-3-bmarzins@redhat.com>
	 <c7641dfc68b568dc78297c60c56a9ee8@mail.gmail.com>
	 <Z3wVVg0AgLLq4EUN@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2025-01-06 at 12:39 -0500, Benjamin Marzinski wrote:
> On Fri, Dec 20, 2024 at 04:25:22PM +0530, Muneendra Kumar M wrote:
> > Hi Benjamin,
> > Thanks for the changes.
> > But below is the reason why we didn't add support to set the rport
> > port_state to marginal for NVMe devices
> >=20
> > In the case of SCSI=C2=A0 once rport-state is set to Marginal ,
> > If any pending I/O's on the marginal path hit's the scsi-timeout
> > (after
> > abort success) the scsi-layer checks the rport-state=C2=A0 and If the
> > rport-state is set to Marginal it will not do any retries on the
> > Marginal
> > path instead the I/O
> > Will be retried on the other Active paths.
> >=20
> >=20
> > This particular functionality(checking the rport-state and acting
> > accordingly) we didn't add( as far I know) in the case of NVME and
> > we need
> > to check how we can handle this in the case of NVME .
> > That's the reason we didn't set the port state to Marginal in the
> > case of
> > NVMe.
> >=20
> >=20
> > In a brief SCSI layer handles the case when the rport-state is set
> > to
> > Marginal whereas in NVMe it doesn't(AFIK).
> >=20
> > Atleast with the below changes we make sure that once we get the
> > FPIN-LI
> > notification we will set the affected path , as well as the rport-
> > state to
> > Marginal irrespective of SCSI and NVMe.
> >=20
> > I am just thinking that until we have some changes in the NVME
> > driver to
> > handle (the rport-state to marginal) this changes doesn't show any
> > impact
> > in the case of NVMe
> > =C2=A0other then keeping it=C2=A0 on par with SCSI implementation.
> >=20
> > Please let me know your opinion on the same.
>=20
> The request to do this came because the user wanted to see which
> target
> ports were effected, but when they looked, none of them we in the
> Marginal state. So there is some value in this for users, even if the
> systems behavior doesn't change because of it.

Please add a note to the commit message explaining this.

I'm actually a bit concerned about it ... won't other users be even
more confused when they see the path devices as marginal but don't
observe any change in the system's usage of these paths?

Regards,
Martin


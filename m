Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC67416CD29
	for <dm-devel@lists.linux.dev>; Wed,  6 Nov 2024 15:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730907454; cv=none; b=Rf1treEt6oTlB54GNFeu2ecYsRLmmmOXyolCYRk5zDCjFGp7rbJeed5GXdfkiLUgZptyEIHZcxs/0g9tOOFYEHcd7U9k5wYQqyNyFM2LnOGmUWFRsbyBT64PZMX5E0xQIETUF0piSR0k68lSnsuORA7F0o2eRSxhCCto2iESPhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730907454; c=relaxed/simple;
	bh=AprLDQZzPH9h1CXw5SnG3icmLXl3b4mvFAZ0QL6hLhM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mCBamLZu0to6Zmy/nM2pTqFtPmFeGE1PdSJ1BckeuFPC6q8Y0L6a2bbMFCvv9pMpGh3sJ3Nz/i5aBUKOG8O6DMo70Av4OmL79/fErfTiG8ok6sF25pxHtejq+zUiHMFOikX1dg7cuSGgC2xRRWqfVDWRrY9N7Fo1p6R4+tp4aaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OSiHaANi; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OSiHaANi"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5ced377447bso5074213a12.1
        for <dm-devel@lists.linux.dev>; Wed, 06 Nov 2024 07:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730907450; x=1731512250; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AprLDQZzPH9h1CXw5SnG3icmLXl3b4mvFAZ0QL6hLhM=;
        b=OSiHaANitI5vBx650y0HwP6xmIRcayYtAKxb+/f/ZYWqrgLM8pCiVKXwnAyH1Wc8nK
         75rnK1WPqxxa5Ynm7+kgL+47YbyZqXI0qk/vSQJ4uGt9LAPExY45xpDFapfGa7TOqUwb
         UcQY7wDXBJc3QHkaoKmzbcw8+lonrHLnjo4Ua5cXwRTyFLRYJXknysCgyQNCGdmNUOSU
         p54hhDe88JWEEvEhskgogeFrBAqY1Ga++dw4t3rObBeDGBfR4ubqapGD9V5kpka68FL2
         ZWyyQ222d/DhMni1/YsXDmuzEjz4XPmwq8lSwSHAriUH1f+WxwoUBb3CHJTx2EybjIZw
         vhIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730907450; x=1731512250;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AprLDQZzPH9h1CXw5SnG3icmLXl3b4mvFAZ0QL6hLhM=;
        b=DReLtohvM6rB0f53NmyWuRLBmvL6kzGtdAUEHyYG56dKJs4RWDd52jGWNh982uMbcR
         1b2vonr8AKESgIR43iw7G8l1e+WXao/MZb5bDWUQHmoHDStoLBGXke22llzZYsN3J8/4
         g42VObGFZGZfiuRRNuRBcvykYLXq6//BWBx2mHWoxVgpXliWm7mhwyAP6PiOAVVWvKIm
         FI9PZzZAPyAhlznObLizPOJhoA06S/pJ9GqcJ4ebYM5AumaJMZn9rV672tx0AU3VRm5n
         5uk9SG0nHgAfUG2xZOlQI5a/QSGxqTlGDIwWeE2DNtxMM2cKdLVBkM8ei9qxepvKiLd/
         0SbA==
X-Gm-Message-State: AOJu0YxF0OryHxMzDmRiw4D59W0UueNlh7qf/vEQ3aOwG24zaVAy7mB+
	lrUz07zlXCbR/tzToCcfxWumB9Cxq4S7g0wtWLvlzwysA1Po3Ku9i5yw6k4l0C0=
X-Google-Smtp-Source: AGHT+IHzzOSOaKv7vk4Qotd71pj1Is6e/nCdhq/5YHMz6oHNFgJWo1mL38pd3Nn8i8/p00dzdCNb4A==
X-Received: by 2002:a05:6402:510e:b0:5c2:439d:90d4 with SMTP id 4fb4d7f45d1cf-5cd54af9db7mr20249865a12.30.1730907449750;
        Wed, 06 Nov 2024 07:37:29 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cee6ac31a3sm2946915a12.53.2024.11.06.07.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 07:37:29 -0800 (PST)
Message-ID: <f4e1c189ecdf64f0e29208feccb8e08f81a74b26.camel@suse.com>
Subject: Re: [PATCH] multipathd: checker port_state before setting it.
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Muneendra Kumar
	 <muneendra.kumar@broadcom.com>
Date: Wed, 06 Nov 2024 16:37:27 +0100
In-Reply-To: <ZypGPZOaJt9HnZQU@redhat.com>
References: <20240917155858.959835-1-bmarzins@redhat.com>
	 <ZypGPZOaJt9HnZQU@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-11-05 at 11:22 -0500, Benjamin Marzinski wrote:
> On Tue, Sep 17, 2024 at 11:58:58AM -0400, Benjamin Marzinski wrote:
> > If the rport port_state is already Marginal, trying to set it to
> > Marginal causes an error like the following:
> >=20
> > multipathd[365376]:
> > /sys/devices/pci0000:c0/0000:c0:01.1/0000:c4:00.0/host0/rport-0:0-
> > 5/fc_remote_ports/rport-0:0-5: failed to set port_state to
> > marginal: Invalid argument
> >=20
> > To avoid causing this confusing error message, check if the
> > port_state
> > is already marginal before trying to set it.
> >=20
> > Cc: Muneendra Kumar <muneendra.kumar@broadcom.com>
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> Ping. My in-kernel fix for this was accepted, but it would be nice to
> have this work on older kernels as well.

Applied to "queue" now. Sorry for the delay.

Martin


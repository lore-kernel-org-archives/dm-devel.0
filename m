Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24672472773
	for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 09:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768987676; cv=none; b=fWCW0q8z5RZyiaRm9fr4IOVWyGoADM/GGxUMsGQym6hjockQANdFJF7DgEHGBrls4t5Ty0oXHOo0CT710SxlsXI7i70LHa+57FGgjmCtFJEiR2J+pM5Wkypkml/Y+JAQiliXKUuJhixdy7iPUNBziqDQdlVfniXvZQRdh2xGL6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768987676; c=relaxed/simple;
	bh=Ev6yPu7y2Y22Wf2C2egkmhxMtF93deb9lFmwOrgrxwI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dtvBL2I76NPhAvFgfZ32TWq8r4k8saY/56JTQYCAPUjwov5tFNaOD/U7gu168FKYETdq4stxC2YuVzE4YayfSty+13CLnxKIIb4AMfbbIFIpXdKG/gpG26sFkojfwB14FJTaaIjeaXrhKk9S0MIoaRVk51LGNKfTkbJqulo0fQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WFk7tAvO; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WFk7tAvO"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47edd6111b4so59073875e9.1
        for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 01:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768987672; x=1769592472; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ev6yPu7y2Y22Wf2C2egkmhxMtF93deb9lFmwOrgrxwI=;
        b=WFk7tAvOhp7/Gai3oDNG677tKhEAl5MDWZ75RT/WcCMwcvd2FZX3jtpip/3wSqr/K+
         5XvhkeGZMt5eiKeGe65SN1UTYDh1kmTdtk8ALnHmuN4aAw6eX4/lqv73K0pCM4XLyBXK
         l3lzNVSBrveBjYSG0nBsRjFnPG4XTH85rLsm6aInsYFsBHee0qY3iA3owWn15EwHWCb3
         I63STr9fNFxIFTJfYvCQErRlOz+iDmHpfm1lLnn/3ovUqyRUgaP/FRalcnSQvAjMuipI
         yKM9G0cQloqk2/0CEyGrdu4h2kKQgOGNK6i4Y6cDcR8Fi7eaMmdoEkUBryPkSzaf4+b0
         jXMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768987672; x=1769592472;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ev6yPu7y2Y22Wf2C2egkmhxMtF93deb9lFmwOrgrxwI=;
        b=f4XwqnMjCdYeaNmDShUQxRxcM7LV7UuAj8epTRdrIJT0ojF106VgLaSzEzz3U6zpSQ
         Jn6kQ7UNuY5x0RNzqRCW1zWymHGOSjVAQ/0POSjIl6W5xCng1j5Hza6WHe8qzrtxPDb4
         OZZ8NimE9aHrIXAE1wmqAEkOnx8ktg/5/Pw7+0BwzC8lmRmCae8jZJgkxsty8dCXFmcM
         SXU3zD1Peb8k5MfWnBGKc6GLVuH4ToqLN1u+VCeOjbc7kQG1N+Ac/h+NTEk5MJdpli4y
         0vPG7NOjeh/Q2u1ohbOofVR4JzaKFd3yIMPlDmUHiMgrgttSuPKizHo3/cErir4++c0q
         V23w==
X-Gm-Message-State: AOJu0Yzn8un9gCXkvMx/6sj4XZl6fPL3HX4VMsB6DS1+Qo2UCFd1nmbZ
	7ULCKuSsoKjWwI6Tck6nbi4ri/Pg68No2PYTmM6LrQEThqHWh9YZMqLWPl/4vDOoPpiGBn9YP/W
	/Bzab
X-Gm-Gg: AZuq6aJUAp81u0H8slGnzo1wamaInXGHqgsjDjnB4uPmE+RxL/C+76rSYCAPhc6rlp4
	KZRF+nx7e/WMvE7f7SKLbCE6C1BSJBWL3VoDt4KXctHKZzIqNX141I+OSCr92U+6Rz23KwgNp6c
	HtSolYsASSviIFkhxdIvQlvpuSu2Uveh66EbgEKm05Ty2lMKVI7wzWzw4OrW7YkRZz7bzXWNbNe
	d1JqK/URLHu9LO+7FlzV41ow6cdWj6sfRqeXBDRALPmWhLpo97B035ARG4R6M4+zHzgD1Rd1IsX
	3RAIQt0R2q3eWIAlWl33wgK93myqV0zuRvXNGre7VZnMQAIwPnIrWJeGoACkFGBgNbl9I9DR0hL
	ZlHEBnnock/RJ6IRQnminqSP/VlFXxjFY6W+w1PjJEVR/xYymXNuh8t+U6AftNVu3U5x2hL6d0D
	dHEw827sIJwe8B2dbD03Y6dU3t2p0EfTncn0kAXxE+f2DUOYrAJqhiNjXhkq4vkkMrnKty6nUj3
	LTuBdLVztmjBPpgInTVUmz0dWS/1EttpIBGpfEQH+J6GBuh9flQSRcomQ==
X-Received: by 2002:a05:600c:358b:b0:475:da1a:5418 with SMTP id 5b1f17b1804b1-4801e2f0573mr250822535e9.1.1768987672351;
        Wed, 21 Jan 2026 01:27:52 -0800 (PST)
Received: from ?IPv6:2003:de:373a:d100:7c9:709f:eaee:b67f? (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f4289b83csm353643055e9.3.2026.01.21.01.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 01:27:52 -0800 (PST)
Message-ID: <a6931ca87fcb21eb20490be1f3a6b7b21d80985b.camel@suse.com>
Subject: Re: [PATCH 3/4] multipathd: make "multipathd show status" busy
 checker better
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 21 Jan 2026 10:27:51 +0100
In-Reply-To: <20260121042315.3914707-4-bmarzins@redhat.com>
References: <20260121042315.3914707-1-bmarzins@redhat.com>
	 <20260121042315.3914707-4-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2026-01-20 at 23:23 -0500, Benjamin Marzinski wrote:
> while uevent_listen() was grabbing new uevents, "multipathd show
> status"
> would still show show busy as "False". Add a check there, to make
> catch
> multipathd's uevent processing earlier. Also, access servicing_uev
> (as
> well as the new variable, adding_uev) atomically, just to make sure
> that
> the compiler doesn't do stupid things trying to optimize them.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

access to servicing_uev is protected by uevq_lockp. The
atomic=C2=A0annotation isn't necessary for it, AFAICT.

I have to admit that I wasn't fully aware of the semantics of "busy".
Na=C3=AFvely, one would assume that it means "some thread of multipathd is
doing something". But your intention in 69cb2d8 ("multipath: add "count
paths" multipathd command") was that it means "states of paths and/or
maps are imminent because of current uevent processing". With that in
mind, taking "adding_uev" into account makes sense. I'm not so sure
about the practical relevance, though. How likely is it to hit a
situation where the uevent listener is working but the uevent
dispatcher hasn't been woken up yet?

Martin

Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09572254852
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 19:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745956786; cv=none; b=hj/NEfnx98GKC3LzoLEtIgRgf6VQG2KKG8gseZQqg0VXaNEN7egHHs026TlJPSgxLCQwbwfEjAYENQ66cCbYL5T7RnBVNIiO95a5t0S9NLR6XJIF9HvQECDA5Cb/ZrqK/UpN8BmzeweIK02urlnlGWH3MEIjW29VliUTtStKWQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745956786; c=relaxed/simple;
	bh=TpeeCAONNIHICjtsDc5EicK/naWpruIupLOnMbhGkSs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XmEv/aZySJuyX5fPDp4fDcTpeI8+Ql9QRwe6H8X8xTj6YG4jk2bYjHVgCFPL2WqwRB0Vd2Ah31ttB4bXMhEhz+dY+BRhYW8qjmjFVISs+PVyCvmPZrvJMN5LEC/R6cqxGA+tjnqON08ZjyPyE5B/1NtSvp6VHn6kiMkiE8M0a1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UCLCDbfQ; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UCLCDbfQ"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3912d2c89ecso4945682f8f.2
        for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 12:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745956782; x=1746561582; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TpeeCAONNIHICjtsDc5EicK/naWpruIupLOnMbhGkSs=;
        b=UCLCDbfQ08Dh7GVsxMOj9OwxHrZQD6BumC8xZ9dEjrrILtYZL0XbJyZzPedGLsRBVU
         9QGQasNwp48M8vzlJrhS1Bm28G18q+83xVcpril12EmUOWCKR2o/nGmGMEsJo1QZ/AeZ
         KKG77U53epBiX9Ti/VAz0CkbxtgKvEgRfn1tDXxLjdnCb62O8dYOZZPYDeEGUwaHEq9A
         gvpp+MWoJpx3VcCVryXLUplXADDqCwxS5Amwdw+AUuYqLKOjsQaYbS5M4n6UL8cUFFNe
         Cduq1ujgVWeQw6heulXCSyMjtAbwcNwEiTtHTvSoWWKjdjAsiGDd9GR1P+cwuHF7W926
         0bIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745956782; x=1746561582;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TpeeCAONNIHICjtsDc5EicK/naWpruIupLOnMbhGkSs=;
        b=JJNKwqA2lHILoSg95qMzwGKRlOOfsoTyu4/bNQRm8Zb9eiv9Xzkjn6MpASD4uoMDNB
         /z2hxIg52BnRunvuVUv7ZdhqM3ECkhAGeEjgNpE5tgz6Y4Q6MoCz2E5R+FLntTZ10Z4Y
         ytlR07h/nDAnmfA/zokurXyRTWnYm34fwCsQrSpYbBJziRn5nUIWw1CVaRk2eL+YS9g4
         zmExikXiZslKEoMQMNCl0xtOXR0zwtdsl2hood0ePvf4eu+GLkW4EnumCbQoVy9XeyTq
         T/GGKmcHmihTlRO5aJWqas/3Q2ZOOXwemqwKD1QrtuvoHQCSOIKXl29UkxjJdfo2zXcj
         kHEA==
X-Gm-Message-State: AOJu0Yy2IJNXopHs7rvPxNxmXGkqYm9HdwfOTFlDytjGWQFvPPNOp0X8
	xrvr6WwqPBxC26gwqfOHP9UVVMYfbWetjzVsjPoBll43bfQ/US3tCAj4nIe8qnr5w5/qhCistdd
	u
X-Gm-Gg: ASbGncugKhSbpJ5c7laZWhLmqqAWmPHY8VXC6e8p8mU+ovJ4mSEWEs05a5HwRu012A3
	6uccIoLRWGzyUigzREXOXMaVdOx2uLF3GCENtrc3XqwkTCbLyc8orOXDmrXqa3ysjJQzRAFvaFt
	vWJkvM9SaoA4YpatcsS3n9bNPRLGd3o0rjjINfspRas5D3mAsUjUVKCePu0V+ykPJgvVeBbLwFj
	6OL+Dhad8vzk2/DXxuwEbyhTlNpA0jPq7uK1Ky+BWPX/2IOq+tzO8CzbNXmXzCCPKTuawLCLkn5
	l5uLHgnLQ4pXpDWE5wth+SgV0MyaiIyxPfV+Y8oy10oDEn9Se3IZPEe4T6UD8Wo88h323vRqfBQ
	yYYhsjwkxBS0LZxQArv9k9somP4EJm1jxX9Jpq3TkMWbvuTYehBoDpGINNKQwTyN+ntQjMWMdUt
	FaqnHt+A2E1Q==
X-Google-Smtp-Source: AGHT+IHKPusFrodo2HGGMX+IN3495UHPzHRgnJTPwoeyItzO1/TIJy7fMrGugSulyY/AYRDz2J/75w==
X-Received: by 2002:a05:6000:240c:b0:3a0:8380:3395 with SMTP id ffacd0b85a97d-3a08f7b95e8mr534969f8f.48.1745956782168;
        Tue, 29 Apr 2025 12:59:42 -0700 (PDT)
Received: from ?IPv6:2003:de:3740:fd00:677a:2a06:a366:3993? (p200300de3740fd00677a2a06a3663993.dip0.t-ipconnect.de. [2003:de:3740:fd00:677a:2a06:a366:3993])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073c8d1a5sm15231198f8f.13.2025.04.29.12.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 12:59:41 -0700 (PDT)
Message-ID: <d277b26e716775ef3778aa47c8a96ea24a551de7.camel@suse.com>
Subject: Re: [PATCH 1/2] libmutipath: handle blacklisted paths on
 map_discovery
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 29 Apr 2025 21:59:40 +0200
In-Reply-To: <20250428214514.1905327-2-bmarzins@redhat.com>
References: <20250428214514.1905327-1-bmarzins@redhat.com>
	 <20250428214514.1905327-2-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2025-04-28 at 17:45 -0400, Benjamin Marzinski wrote:
> If the multipath configuration is changed to blacklist existing
> devices,
> and multipathd is reloaded but the blacklisted multipaths device
> can't
> be removed, multipathd was marking the paths as INIT_PARTIAL, causing
> them to stay in the multipath device, at least until the
> partial_retrigger_delay timeout elapsed. Instead, mark them as
> INIT_REMOVED and set mpp->need_reload, so the device is reloaded and
> the
> paths are removed. To make sure the blacklisted paths are deleted
> when
> the multipath device is removed in coalesce_maps(), set their pp->mpp
> to point to map before removing it.
>=20
> Fixes d9c61332 ("multipathd: trigger uevents for blacklisted paths in
> reconfigure")

The patch looks good to me, but I only vaguely understand why the bug
is introduced in d9c61332. Are you positive that before d9c61332, the
hang didn't occur?

>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

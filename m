Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8456478C73
	for <dm-devel@lists.linux.dev>; Tue,  6 Aug 2024 18:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722970625; cv=none; b=P2hdDkl812RBAgVBXNHW+iOVXatTShfA40gyeItuYwUSiglRtRNVfv429AvvFFYiyxDE5obP7ngmjGKrZNA0LyBHl+SecgWCk2hPmuxSgBH1SelWVBQg6XRoRlpacmvbSJFB6d7XZfwVb0q/VciY6MmolgVzLtWMiXnWNlh1muQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722970625; c=relaxed/simple;
	bh=Cxsohev4a9zaL72+pLBA4Ofsjg6NwqLvmtVkPKUotEg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G5vl81wn3YMK2QhC0uAeOy+e29BqoRZLvLhfWE4pCdjScc7T+dGaH9ClOrtne416rWszBOVT9EJyObIfma4DJ6EYf+r1m1shpCKtVhKhB9YyR3sLCpgI/4eCjvSHHrDgmKo9PnZ7+5T65dg84pLt7EZ1D9idAj4EmzMC535EOsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OIHWz1ES; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OIHWz1ES"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a7a8553db90so111482266b.2
        for <dm-devel@lists.linux.dev>; Tue, 06 Aug 2024 11:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1722970621; x=1723575421; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Cxsohev4a9zaL72+pLBA4Ofsjg6NwqLvmtVkPKUotEg=;
        b=OIHWz1ESNuieivqATQNt/yd2zk7OMduvz8on7Zh7RyLADP2APASduHv8D6c+Rx9ZcX
         RUPj3lus4H+dAt2neN5v3OTZEUyfccHoyHGWX2UtQq+6ahdA/ADvvPEi4veeFVncxzjx
         RqyCROrlDetRGBvIVOknp6Ra3XA/u8FOmqAU+rI13M/3C/ofED7RwA8kqOz2VQ2p2sF/
         kfI/UdQYnVOhnSDD9Hr3XIn5/8ooLIXutxpOGNxU1eNrY/yAmJGqq0F6nmVZasB8qI90
         hjWoDVvho9oWUFOr2zau+osQMjwIiU6oW2O37mNDBN5QXHiFz0+4KndugbJgOxz64Hik
         CI2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722970621; x=1723575421;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cxsohev4a9zaL72+pLBA4Ofsjg6NwqLvmtVkPKUotEg=;
        b=CDDbDMphnVoxkvf4aI0X2Y8dth5GHqZQBNVdRxLtM8rrHSNvSqT7zhf57najBC5bi9
         lVrLh9GzKwumICQUhyQbtKVKZVVOvo5ZihH7t+ZjoV0dnsmiYVw/9Ysg5dGgydEP2PN9
         BMgvgpH8tQKOEwdtSZZzKRDF5bhVezw726BBpvqynT35JHibrs33QV3Awy4cOVqQ0+I4
         weP0duyhqfMYpO9VQQhuBNMDD+aaWVqdvHPobFZbIQwlqnvy/2grH6HgkHtw1+07QVvY
         lVBMjWNzI5gQYLQ3LI1V1c1GV9Wqcr3oAlEnpkhhNB5qtMeKxoKmb5Q8NtKKGEDvDTxd
         1yCQ==
X-Gm-Message-State: AOJu0Yydl4lJ+YfBVzs3PIzgNMV5dn6596ubhkiFNtHTNUfBLk9SvC/V
	KjCsn3NgXY70hAJ7RGAP0yBGEfjfRdwHoiM2DjWmLiGfZvlW1c/LjqoisOyBbh4=
X-Google-Smtp-Source: AGHT+IGOPYur4Sszy6Hle9euUj58T79W1f5qrI3bn0MoiNYPCgsr8MX9lJ78ayErHLOgzWMWQ8jhTw==
X-Received: by 2002:a17:906:fe0e:b0:a6f:6126:18aa with SMTP id a640c23a62f3a-a7dc51888c9mr1067294666b.67.1722970620092;
        Tue, 06 Aug 2024 11:57:00 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9c6627esm572103466b.95.2024.08.06.11.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Aug 2024 11:56:59 -0700 (PDT)
Message-ID: <2d8d57a4d9eb00753396116ff9a85fc33a3da0c1.camel@suse.com>
Subject: Re: [PATCH v2] libmpathpersist: set mpp->mpe before selecting
 reservation_key
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 06 Aug 2024 20:56:58 +0200
In-Reply-To: <20240724181712.2565138-1-bmarzins@redhat.com>
References: <20240724181712.2565138-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-07-24 at 14:17 -0400, Benjamin Marzinski wrote:
> libmpathpersist was not setting mpp->mpe before calling
> select_reservation_key(). This means that if the reservation key was
> set
> in the multipaths sections, it wasn't being selected.
>=20
> This appeared to work for many commands because of an error in
> checking
> if the correct reservation key was used. If mpp->reservation key was
> unset, then it would considered to match if either the RK or SARK was
> unset in the command. mpathpersist should fail if it doesn't find a
> configured mpp->resevation key, with one exception. To make it easier
> to
> remove old keys, if --register-ignore is called, and the command SARK
> is
> 0x0 so the device is being unregistered, allow mpp->reservation_key
> to
> be unset. The code already allows mpp->reservation_key to not match
> the
> command RK in this case.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


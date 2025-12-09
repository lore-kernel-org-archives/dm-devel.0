Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A9A28642D
	for <dm-devel@lists.linux.dev>; Tue,  9 Dec 2025 11:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765278560; cv=none; b=CsVP6uBgAVWIlypT7tArU7ZXpVK/DMzT9W/ZBgWY1pQdjNRuYCwp2+zXX9n/HUcLO3/gJNzw43XnKrvVo+lE6ulhysfG88S7i1NH4+hzJ42Kp3ACcFKgy8a6G+lieqBDpoSizqyTfRHPwsq0uevdWBn7seKaC01F/Z9b0NfGjr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765278560; c=relaxed/simple;
	bh=R28ly3uJzGzeeeTFvnf+WiIl9HHlx1yx+6s5v1EwbjY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uIn8nyEy1ZQINRDZHviokAZEMUL4RxJxQhhuAmxqa8m95tteVJWZm/ztQkjAC713E0u7bwSW7+KPjB14REoeB6BzDivb5ZNLMo3ILUqqmuy6INOUxYDnjVBQ6BEHLUl/wQponzPxkXMgVeNBpC7FVKlpwCeAgyWUkfZMuDen8gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BCKbhXZ2; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BCKbhXZ2"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42e29739ff1so2279136f8f.1
        for <dm-devel@lists.linux.dev>; Tue, 09 Dec 2025 03:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765278556; x=1765883356; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=R28ly3uJzGzeeeTFvnf+WiIl9HHlx1yx+6s5v1EwbjY=;
        b=BCKbhXZ2VcGbhoOl+XhklBmcsf5xf//HuUg5hJFfzhOK6TyGknQc2IEjdf6rQe+7kJ
         wAHlVFjEbj36Q6KS3l7ic7HaIK24nFAiVr5BBZX69ZzyHNPu6y6+r80hjY/3epN6uysd
         QZv2+/VVkFsZAeFXQc7Ma+Tp4fEh38Rct64ksBq9tOm/Ksfd04DbXkynTeunfYwi03D7
         sfaZxMN07QZr2JA2urbIzBQeWpkrf9QpifeJO75mIh4OUi1pp539c32UvGc85/KbDwRW
         UW9hCXRY3yJXF3tEMA1pIhFYNdGk9SLpBIBzcIbLEJKfpoZieYynoWm12QXm/ofwuZ3X
         REfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765278556; x=1765883356;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R28ly3uJzGzeeeTFvnf+WiIl9HHlx1yx+6s5v1EwbjY=;
        b=Ko6ZmKpi0BjVRbN/roSBAe46neKdHchVBThpm9LL9/toFnAUZb99P2MQt56tzWuJ/l
         jw9r1IywzQ4RSlO4OxnM2QMOv87ePpf+uxtVnsbB/z7KyZvHGibJGVvApNTSGEXsFRMV
         0B87xY2k3fbYN2jegiW6J2kPjOH6FG9nlfvxWkedV4nynLVc/sfrFO5MiJebnb+Gk7w1
         clT5ubfLVP252QzsOrPcggSPqUy+dpa1wIzmJB010hY40nOqcsbfsG0ZRWoZ+ScZkW/H
         NUDFiiRYPkoRu3woip8514ofdUfQjoeIbDeMYmJOC5ccnxTe4INPCQm35pnuoSv19iL3
         iIxg==
X-Forwarded-Encrypted: i=1; AJvYcCVjhAdq59zfMzBbRp+akAU8wg/s/BLRHxmE+nylapuD/ADFR8ua4ZQoSRbVlephQ5txm6vTaFY2hg==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywrk/CmlRt3DMfP7uJYhpQTKBCxpMMk0k4p0Bu7Ru+lKVPnw62w
	uk+hR3sz9VF7WZSchxy0sJ5XaUOod3yiekMk0OtNotDL3v0/6FuJI1Xonf4tWRWcqa4=
X-Gm-Gg: ASbGnct3A5Ml7mkqOnpaFZevmtlsRAhQ29B3LInjhOJTKgHI/ZiMeQ9a/wHem49Xk+M
	la+hFQyqOtGhfYVW6C5ImPLsXesVKjBmmgdOWoauukiKWXTmTbrIsTUwXCcg7BK71IGtZHGjcRh
	If/6RXhT8C+fmctiMXTBqEfxtGEm5ovP/rSPWJEbihe3yYd9EY6l4G629l3QG/oAWMx6GPisSpv
	o7auWuVE8mRuBFtZDbjZrTvS+g/92mySkwb53rAxYqyigmLwddprAS2qghhA3BvbvquexF8ot0a
	wf/2dIz4xFjTJO3HXUISaJ9Wo5sRG6cVRwGhwsGDrexktfCz9G7dO4y5WiZT6EQkYyvWKoUKZjU
	JBYJZw0n9jvn9p9362MUUfrqqhJ4ASaTYgrYC1vPuUdQI0sQZak1pmBfMuNu8vQo3G0tJL7jlWq
	MN3TA2gYhuImS2PNsemtvpbg2DA/LDD/askt4n72R3dg+iF1sUYnt9/Q818uFIjgZyRkT4LFzKN
	pddbisFMVS/Q6+gCEb5Ks+DtfJvTYZm5mKyfuAm0Lc9iVU=
X-Google-Smtp-Source: AGHT+IGOSQx0z+N7CVfLgu2UCozlv12o2ttvz4h/f2xb4kOku14iTEtzU9ELti4HvG8x1OimsGxeqg==
X-Received: by 2002:a5d:5d08:0:b0:42b:47ef:1d59 with SMTP id ffacd0b85a97d-42fa071b93cmr1359539f8f.4.1765278556390;
        Tue, 09 Dec 2025 03:09:16 -0800 (PST)
Received: from ?IPv6:2003:de:373a:d100:7c9:709f:eaee:b67f? (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d352a52sm31299599f8f.38.2025.12.09.03.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 03:09:15 -0800 (PST)
Message-ID: <75a98db9db51786c33337967aad231189c244f08.camel@suse.com>
Subject: Re: [PATCH 4/4] libmpathpersist: fix code for skipping multipathd
 path registration
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Tue, 09 Dec 2025 12:09:15 +0100
In-Reply-To: <aTc6DyGc8DWjhtxY@redhat.com>
References: <20251202030213.1432964-1-bmarzins@redhat.com>
	 <20251202030213.1432964-5-bmarzins@redhat.com>
	 <44ac6212bf407913ed7bd6fff15dda195c7d9135.camel@suse.com>
	 <aTc6DyGc8DWjhtxY@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2025-12-08 at 15:50 -0500, Benjamin Marzinski wrote:
> On Mon, Dec 08, 2025 at 03:46:56PM +0100, Martin Wilck wrote:
> >=20
> > I may be missing something, but this is quite a lot of additional
> > complexity just for the shortcut. Have you considered just not
> > taking
> > the shortcut in the first place?
>=20
> Yep. But that means that whenever you register a multipath device
> with
> mpathpersist, multipathd will (almost always pointlessly) re-register
> all the paths, just to make sure it doesn't hit these super rare
> corner
> cases. So this added complexity keeps multipathd from running
> unnecesary
> scsi PR commands, and should be quicker. All multipathd does is break
> the new cli message up into pathnames, and then has
> pr_register_active_paths() check the paths against the pathanames,
> and
> skip them if they match and the number of keys is as big as expected
> (and it needs to check the number of keys regardless of whether it
> uses
> the shortcut).
>=20
> I thought briefly about pulling all the path registration work into
> multipathd, but it ends up making multipathd even more complex than
> this
> shortcut, while not saving much complexity from libmpathpersist. If
> we
> wanted to make multipathd handle all of libmpathpersists work, that
> would be a different story, but I'm still not sold on the idea of
> doing
> that.
>=20
> That being said, we can drop a chunk of code if we just force
> multipathd to automatically reregister the paths. So if you think
> that
> the reduced work is not worth the added complexity, I'm o.k. with
> pulling the shortcut out completely.

I admit I am somewhat intimidated by the complexity into which the PR
code has grown. Therefore I would be glad to avoid extra complexity if
possible. But for that very reason, I don't feel competent to judge
whether this complexity is "worth" it, IOW how badly performance would
be affected by the extra register commands, in particular during high
IO load. I suppose it's not so much a matter of "performance", rather
of latency between running mpathpersist and the completion of the task
in multipathd, which might be critical in certain situations.

This is why I wrote "have you considered". If you, from the vast
exprience that you gained in the course of your recent work, think that
this extra complexity is worth it, fine with me. I'll go over the patch
once more.

Martin

Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2722D0C9F
	for <dm-devel@lists.linux.dev>; Tue, 11 Nov 2025 10:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762855638; cv=none; b=cavXgIwFVBcnhH/zjao98tJIaU9J58FCm+AVUXoImJOt98T/G4QiJgc1o5ZEfnAkpWtDO7s3XqvB3UQnRYm5jYuU1rLjA8A2Ygwz22K8hQ8qoYNgb5Zk3sIMl0UCsFFh3+NFMZJVc3KpROGB+H1XX2IFwe74BPoEHvalNJX72+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762855638; c=relaxed/simple;
	bh=YiFxbgF9b8tucndLRUBW5Nqn/lqhJbALYDn4s3/WHzY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s/QUSvkb+JGlSiYuUabg7GU2AYLAV/ZKRZ7ef51pFN15nkGmATpNJH860dZqVO+z8E7ysQqrleba90wXjZIgrLPJhs0Bu60pUO6MA8zjncHcnZqOARALNjleMwDisYTnfw65rlocKISLb0Vu7z4YrbsILUhxCE4o6PGEwiFNTZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=K4MavzDk; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="K4MavzDk"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47775fb6c56so30379995e9.1
        for <dm-devel@lists.linux.dev>; Tue, 11 Nov 2025 02:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762855634; x=1763460434; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YiFxbgF9b8tucndLRUBW5Nqn/lqhJbALYDn4s3/WHzY=;
        b=K4MavzDkrhK/DlUZaAAsoHAo1o4C2VEcBi6cGGH49tYo8p+IruQgr85Ri3QU1F5V6Y
         iN2W6zWgSpGi2q2raaJJ7402YCgo9ryGQL6XRU6XNd6Bc/BjBG5P+HBReAbAfjQDWMW/
         +WMz+snGn8DuQcgksXzAcGUu+HC97bHhIIFvNBsuv97PLKScQ11YdtERAuzEZAxdOGik
         1tYz4S3X2XtpUr/qEkiYIcH/NhOhYBx+kTni5rR3+PD9Eue0WyIn8K9IwU6zb2sWU5cm
         so2alkXIIBwYITEIqAt8j0yMtIcW/adCwhhD/Yof3WVlZBCRKf72EiuRtPn0TCHVOic4
         OorA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762855634; x=1763460434;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YiFxbgF9b8tucndLRUBW5Nqn/lqhJbALYDn4s3/WHzY=;
        b=F+gPd+qVteUIdm5p3vkfIo0wr7/D/MT5ewOF73QhL4W57Ho9GzGyPPCvUpPnvXRPPa
         kdlsuFhxvXSxM+HPlSzmKOFAMvgPeuYe6V4VrWy5XAHAdUVPJbxL9W2FIxWtmmKGZDkM
         XwDdsuxA0B4PWlzAU86J1ykMsDIg8ZgoI5jtsteedEP2Qttry2+UL33BHPAx2eCOobBQ
         vtVzRsmS6b1Kv9vP5AYLv7v1OblTLvSTvE4RXwQSa7SibHrfOrnptwt7NeqNYSGvOfMM
         fZXP5WmsBgiN9GKSXrmdVgO1u4bSqHu8zvNw+g+XEldcPSFXdBMEsTZBEOuqapBKZkZg
         L35A==
X-Gm-Message-State: AOJu0YxdCUEZ5b/+dr6q4FMbNxQBwfmABKRFTlISuq82rkq5qGU1JWkC
	jWfSC+BtFYvj9tV93LXBVEw+sIm2luMC2u7NaYB6sa2QActBwahXvCGFTnaRbJsV2sI=
X-Gm-Gg: ASbGnctNa0arzp/sMSNrtUwuoRdwqz04GV31PtOrKYR6wW4gd2UyqnRMIbCXP7XFPGs
	Fy7+40ChqbB+K9JsSZqAo2WMzNSQhMas6b+lGaRR7n44aKLKPVCX+VgjuGQ8rM/6xGyA9bn6yvZ
	Tnl4kabGnv1Rfa0+Mjv58Un3ksaLl/VIthXpK1pkEdxzrWSlcXGsqEyddcALzxkoh5NTtv/IMiK
	FWhcE1/59qgIuV6gddhZ1LRDvQHnIIU0mIKdVStlnA61HiQ325SKlE6mCBddk+DlECUPqrc5KOM
	ewlWCKzCXGQYUUshfB7JmPpiET76b+p9d+a/brZIgPkbhbBLA0iBofhNsuTLBEi6TL8ZPg+kdpl
	JYZbPxuXyXMCsb1YVOoiv0VdeV2TfmZvMmXaQ6Z14hBBuFzXE/P9X6EX+KQ3iLEhe0zPDwWH9Nu
	r6lvjptDG982bKeZpZ3N7ABTBvA/Xp5b6VIrlmXbN/gfqUbobuSD+RyJrI9slylP3i0w676oYjQ
	xTQxXYK61HLKr32KkW9XysSach/1smiCmlz
X-Google-Smtp-Source: AGHT+IG7IBOPeUWdy8qo5e0qSUkTH/JL8OyIpVT5pGPFf1caicltaDAwVmb6KPXUI9a5TidCyUgUbg==
X-Received: by 2002:a05:600c:1550:b0:477:5b0a:e616 with SMTP id 5b1f17b1804b1-47773228b2emr98492965e9.5.1762855634055;
        Tue, 11 Nov 2025 02:07:14 -0800 (PST)
Received: from ?IPv6:2003:f9:7f04:900:e894:a50a:fc99:6ee7? (p200300f97f040900e894a50afc996ee7.dip0.t-ipconnect.de. [2003:f9:7f04:900:e894:a50a:fc99:6ee7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477815ee9b8sm17080775e9.0.2025.11.11.02.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 02:07:13 -0800 (PST)
Message-ID: <9dcd363af870f9640a34e2b0f2b55b3da2f7b43b.camel@suse.com>
Subject: Re: [PATCH v2] multipathd: Fix race while registering PR key
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 11 Nov 2025 11:07:12 +0100
In-Reply-To: <20251107010814.447870-1-bmarzins@redhat.com>
References: <20251107010814.447870-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2025-11-06 at 20:08 -0500, Benjamin Marzinski wrote:
> When libmpathpersist registers a key, It first checks which paths are
> active, then registers the key on those paths, and then tells
> multipathd
> that the key has been registered, and it should start tracking it. If
> a path comes up after libmpathpersist checks for active paths, but
> before
> it tells multipathd that the key has been registered, multipathd will
> not
> register a key no that path (since it hasn't been told to that the
> device
> has a registered key yet). This can leave the device with a path that
> is
> missing a key.
>=20
> To solve this, when multipathd is told that a key has been
> registered,
> it checks if there are the same number of registered keys as active
> paths.=C2=A0 If there aren't, it registers keys on all the paths (at leas=
t
> until the number of registered keys and active paths are equal). To
> avoid doing a bunch of unnecessary PR work,
> pr_register_active_paths()
> has a new option to track the number of active paths, and
> mpath_pr_event_handle() now takes the number of keys to expect. The
> first time it's called, when there is an unknown number of keys, if
> the
> number of keys it finds matches the number of active_paths, it and
> pr_register_active_paths() exit early, since there is no registering
> work to do.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

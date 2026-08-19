Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8979E48989D
	for <dm-devel@lists.linux.dev>; Wed, 19 Aug 2026 16:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787157435; cv=none; b=MpmZ/TuMvKqfL/EGjyDwOZEnRAqlRcysclF274g+kOivZowHMy4a1VKhk3B/yCOKKhYPtUDK6t4FxYLf4UA89CKSbjvOUBGsKyPUW7rbGUGsl6VnCqjJl7t/zrlTz8BukQYm7mLC1v7q8RwgpF2oot7vkMgCpu18MOF/tKJLttA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787157435; c=relaxed/simple;
	bh=YWcc0p1ZJKT/5nyDOWUcLwbVuLkIv2XFQ7lzDdyxAos=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z423KL/vTBMrkcpaTx4AMFB9J4NMck9jEPhYwP8mctkjBsNjNwuZ4QhC49azDuqjVMaUhykm7lp/vf2p5yXQP25yIEIyzbeEXQ8G4fLxr/WHPt830EE+FKw0RCZuG9GkoZRm0VQlU+/YkpqF+SvT+fPhmbklXyxH4OCtVr9bspo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VWHpT+oN; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VWHpT+oN"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4980dc26022so13455025e9.1
        for <dm-devel@lists.linux.dev>; Wed, 19 Aug 2026 09:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787157431; x=1787762231; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=VHF9/9II+PPn7OtQFw85e3uW5cLrCgzkdulcCX/a5mA=;
        b=VWHpT+oNQZjOMVgalImvdKIoApPPWqNYusHRmFthyh3Tt5nygx3d7Od8pwz3nZYpiv
         KckC9W4xB9tfSe0B9VuC+MHMeh0/Tw6S89rBNEwa2BQXYl75yl1AGZeZsO+ScN2VHYLn
         MIPjJ2GouGPLAOoGy2Fq/GBp1rTsY7vXPRYc7YQXALuJ4fuBEuQZLindZONPB89j54mX
         sOtYiRR6nDGMFbO/scoBx/A/A4mvICyFwBsCdQ3Tf+kvJX0JlwDu2MJ4v3mU/vhodbmD
         TGzVbPezShuwi+9RHaQdioyxLR54mrwmjUlSnUCA17Sr7FfG39OS9U1yDBdczkROSrN5
         zMvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787157431; x=1787762231;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VHF9/9II+PPn7OtQFw85e3uW5cLrCgzkdulcCX/a5mA=;
        b=chtdO2nIy8jhlhevY5qNZdWuk5Kz/cmSHBUdS1ZhWL5AOHvW22hSJZ2Q5e2pw/eDGS
         7Y0DQn70NqGpCsBv6RA3Ht09/mctwc/H3+UhDT2qNfj6RNczEIImTqiitRAbme3z+LtY
         /wQDTfkv4pEuwKa3wvF64+egz3jTJKuWzr9FHWablcBxdPzay+8DFtCwMqsrVNm82/W2
         vdOswUdihUoatFuVSZyjFf1Q1ThjL8JhUF0nGdIDRX9A+RZJZmT/Uo4t9ygx0EHdORVC
         QQDnmJ6wUKPLRcLv/5TG+qzr1GoqE7ZIOPk874d5R1Uif1h3GVmd5sa1S/hUOYJfw9O+
         5u5Q==
X-Gm-Message-State: AOJu0YzTBMhhfeXNzhz3Rb07lnoOpHsG37upFQ3c6PzggNgIQP9rLAFj
	+9f4ZZCb8Ob6H47pptWaAeKZ1uGUqWcu9nVNyXX3AoeMjL9vF6RZijkcEzfdbGQETLk=
X-Gm-Gg: AR+sD10IXfwUKDri7/ZsiBSTDLZVz0yDFKBmHyjADjxfmUzbeq9NchU9kR/9vQULljz
	HXZZjHRw09G71kV7AUl6HTTZCa0i62dAiuhnrT0+CFPu/3VqEk53P9/QiiNlO50shiXl5VRkHCL
	uBbK8D9YCgmsRJdxIVQBz7+r3wRhDJm51XouNaZsfXQw45QiJbvweTZfaPEUk2TOC8oSu08DfUS
	zFjDs4i6Vue7FX4XRIu2oQKDxfggcOpwQ0lmhcGVL+lk9bGYNdTg8/TfhA/JeC5XRK/FiCFX3t2
	UoOq/hvkuH3BpEGD25nvaArK3obsu/Qxz+6Vi86FhsDhkTDdrehDW+eecb2O8nJcs8iQ68rSTKP
	DwP4g11a1ERtZdpHdEVUENyBpoEscmqCp+DTiCzOw5uccPuf1AawzSrWbaaQONMCsaIRlJUtJU6
	uTZTOu/XXb36koNU7M0QBgY4i2Pr8jTepK5K3L/QEsYEtySa34Kw4OcApid38XLTQexFcU654Ss
	SmUZU5l4A/uyxt2ZgQ34lbJvapNSz9wqvgKXAnE9sKrJr3uJ00UbdxVIB29PPDJHLtwnkjS4d/j
	wagGoVfLKONhn2mpZ/FebWZ9RR8DSn070g==
X-Received: by 2002:a05:600c:3f18:b0:498:1595:be7b with SMTP id 5b1f17b1804b1-499aa194df0mr124760215e9.4.1787157431294;
        Wed, 19 Aug 2026 09:37:11 -0700 (PDT)
Received: from ?IPv6:2003:de:3717:2700:e7f8:85d7:29fa:4be7? (p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de. [2003:de:3717:2700:e7f8:85d7:29fa:4be7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499aa0dd3c9sm72706935e9.12.2026.08.19.09.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 09:37:11 -0700 (PDT)
Message-ID: <a9126e0ae10ae9ee8e7f0999da767857ecb86f9a.camel@suse.com>
Subject: Re: [PATCH] libmpathutil: don't call pthread_testcancel as part of
 udev commands
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 19 Aug 2026 18:37:10 +0200
In-Reply-To: <20260810210530.1313185-1-bmarzins@redhat.com>
References: <20260810210530.1313185-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2026-08-10 at 17:05 -0400, Benjamin Marzinski wrote:
> Commit 47a654f0 ("libmpathutil: udev: prevent interruption by thread
> cancellation") added pthread_testcancel() calls to the udev command
> wrappers. This makes these commands cancellation points (but only
> after
> any waiting has already happened without cancellation), while the
> rest
> of the code assumes that they are not.
>=20
> This can cause problems like in uev_update_path() when multipathd
> first
> calls udev_device_unref(pp->udev) and afterwards resets pp->udev. If
> the
> thread is cancelled after unref'ing device in the udev_device_unref()
> call, pp->udev will still point to the now-freed udev_device.
>=20
> Fixes: 47a654f0 ("libmpathutil: udev: prevent interruption by thread
> cancellation")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =C2=A0libmpathutil/mt-libudev.c | 4 ----
> =C2=A01 file changed, 4 deletions(-)
>=20
> diff --git a/libmpathutil/mt-libudev.c b/libmpathutil/mt-libudev.c
> index 813ce588..b81cf9c6 100644
> --- a/libmpathutil/mt-libudev.c
> +++ b/libmpathutil/mt-libudev.c
> @@ -14,7 +14,6 @@ static pthread_mutex_t libudev_mutex =3D
> PTHREAD_MUTEX_INITIALIZER;
> =C2=A0		__r =3D
> func();						\
> =C2=A0		pthread_mutex_unlock(&libudev_mutex);	=09
> 	\
> =C2=A0		pthread_setcancelstate(__oldstate,
> NULL);		\
> -
> 		pthread_testcancel();					\
> =C2=A0		return
> __r;						\
> =C2=A0	}
> =C2=A0
> @@ -27,7 +26,6 @@ static pthread_mutex_t libudev_mutex =3D
> PTHREAD_MUTEX_INITIALIZER;
> =C2=A0		__r =3D
> func(__arg1);						\
> =C2=A0		pthread_mutex_unlock(&libudev_mutex);	=09
> 	\
> =C2=A0		pthread_setcancelstate(__oldstate,
> NULL);		\
> -
> 		pthread_testcancel();					\
> =C2=A0		return
> __r;						\
> =C2=A0	}
> =C2=A0
> @@ -40,7 +38,6 @@ static pthread_mutex_t libudev_mutex =3D
> PTHREAD_MUTEX_INITIALIZER;
> =C2=A0		__r =3D func(__arg1,
> __arg2);				\
> =C2=A0		pthread_mutex_unlock(&libudev_mutex);	=09
> 	\
> =C2=A0		pthread_setcancelstate(__oldstate,
> NULL);		\
> -
> 		pthread_testcancel();					\
> =C2=A0		return
> __r;						\
> =C2=A0	}
> =C2=A0
> @@ -53,7 +50,6 @@ static pthread_mutex_t libudev_mutex =3D
> PTHREAD_MUTEX_INITIALIZER;
> =C2=A0		__r =3D func(__arg1, __arg2,
> __arg3);			\
> =C2=A0		pthread_mutex_unlock(&libudev_mutex);	=09
> 	\
> =C2=A0		pthread_setcancelstate(__oldstate,
> NULL);		\
> -
> 		pthread_testcancel();					\
> =C2=A0		return
> __r;						\
> =C2=A0	}
> =C2=A0

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Jochen Jaser, Andrew McDonald (HRB 36809,AG N=C3=
=BCrnberg)

Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784E43BC4D8
	for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 21:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769032732; cv=none; b=kvyimn0EYuKSafHekmmmLTJ4NlIO+C5ne208rTDvekSIHOITLD5mTCjH9gFlQxkfpaBqtxteiSB9XwGARkgUAGO+F2uZTOfdfWIoXGFWobgNQXaSuNKSmhCalU/kyzHHwvaE1N50Zq6HlMZ++cYAkWcGkADCSHZVqmED22VllTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769032732; c=relaxed/simple;
	bh=cMvS2zJ6384uoGui8Zu3AiDNgaoPGlNqeUiAPUlyLYk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T7akbTLk9m0MssSzGYuTSIaGcKPBtkDxzgDSf8ruMvycgtYfGV/j3WLSb+lgygRMlZ6T1MllIwuyjmBvPYAAJzGPHpRrKN448gpEd8BlQr7aA5q24Vtsy11smzC/AQLGfaaDl35AzKzAkL9bkx7PwCWaiP4l2W6TSDyl0Vt33+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZJUNrT7T; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZJUNrT7T"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4801c731d0aso2484095e9.1
        for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 13:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769032727; x=1769637527; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cMvS2zJ6384uoGui8Zu3AiDNgaoPGlNqeUiAPUlyLYk=;
        b=ZJUNrT7TnHAJ9Ps+QW5xaB9GcElaDlkj9LoEgKRVdlZ8G3T/Y88rQDhU99F9RO+y7T
         l1iXkOUKczmF6Q8DNFjxKAxoZMlmHbjnlW+LMjeVkOCoVm37CJomUnZPYIl+pmeADn7x
         CwbmqgZyhmuYYq4aX1qf/HznwvNrhZjuvvj4FY+rod8zscd14SocvpOXNldHj/5vNyhJ
         9fdJQ+5rn044GSD8sa4XhaL9MJQCU2um8WXPCmb4oaESKyQvDI9yv44cCwOyPOh+4QNG
         fMK5/PuQxJlKtsopUmMl5QkVeCxxbd8KLKHFbWhNIPTJe/tVE1rolar1vpEz/ngl4szA
         5aKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769032727; x=1769637527;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cMvS2zJ6384uoGui8Zu3AiDNgaoPGlNqeUiAPUlyLYk=;
        b=q85DAXgEonbUbADPkmoXf7q/kB3y9ZUS2lgGa0H5c5Z2NBqfeghVzjaiot1jzw9c8u
         4zOEYPU2g0GOVUn3mRb59U6dX50J48AE8GuKy+8rrQF4OF2kSId8CG+wwAHbbs8cjIxa
         Kbeto6nkew7ejoejqvIHgPHqPQUZietMOuPx6fkbEAerWQ+AZgYsUtx1jUwO8wscIaaI
         v2Ft5OTFo8R0Li/898TULCwPmKPXTzlOboLqIj5tcn59ugdpjFrfH49Ivxyk5QbYlhIb
         sCsS7f60Mk/XLUWFY3DzM8VxOeVIIl8WTWjHIYO/B5zonT8LBnt53+xKSV3sMvD/7KKf
         WQiA==
X-Gm-Message-State: AOJu0YwEHfeW+bXNfbrAnnJNmDo+CeZxNbHWfZHlkLPWeuyd/iBY4HBZ
	2I/miJKst7dRn1xgaIDBf+aC26TT85uZo/Fyow2x/jbmh1yNgb0R6zEu6JJcDhOqxE1G8soWQs8
	Wu9si
X-Gm-Gg: AZuq6aLn4gr/PZkXJa8ctvM5UZvnSL9g3gm45+0y1ctkVdPCneRhAyxYqgrPBLILMxw
	sIfVMY5XoYNauQWl0ji7PzIFyQdVJb/NRkt7EAT/K4ALGjfW+EXW8gmF/fQqbFQ5gn5207awHie
	s38Z/W1rPWLWHxuIBHjtQjg1zemIMrrOhKkeQsuJ+5RB+kyFZzaHKd+fT4D2tFobfxtt9aBEYyO
	qfPwfCdw2eJ98Ig6wFBPrMi/H4q7Dw+w0cj25EHbYDADO1SxMAE6AoxR5hgOY1Co7y20KShQFgI
	68wLCnfZHoiv69hVIEz+aDTO7rItFOtMXwyjEZOOL6Sjp7xThAGTc6nM4V8rEZJvifnF2/5thKj
	MTW8IMIvUbga2P9tEuCGKHwjKQO/iP3l0WBy8G3cvcAXOZk56S00VaTXxb+asEU79yJncaZ6KXb
	g6aZs+y2iXo1opt///f4RR6VGKXwvIhO3jMZ/VS2s0s2G+F4mtUOeo0AE1FBZt2xhr/urtFV16Y
	vhb2rpq3i1JdYFuD8VNRh21LSRlXrR+3EwmV58PtwuzfZ8=
X-Received: by 2002:a05:600c:5493:b0:480:3a71:92b2 with SMTP id 5b1f17b1804b1-4803a71968bmr153029515e9.26.1769032726683;
        Wed, 21 Jan 2026 13:58:46 -0800 (PST)
Received: from ?IPv6:2003:de:373a:d100:7c9:709f:eaee:b67f? (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804703b90bsm22026295e9.6.2026.01.21.13.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 13:58:46 -0800 (PST)
Message-ID: <31ca45680cf45be9f77233156e715aba69bc3baf.camel@suse.com>
Subject: Re: [PATCH v2 0/4] multipathd: Miscellaneous fixes
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 21 Jan 2026 22:58:45 +0100
In-Reply-To: <20260121210313.3942727-1-bmarzins@redhat.com>
References: <20260121210313.3942727-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2026-01-21 at 16:03 -0500, Benjamin Marzinski wrote:
> These are a just collection of unrelated multipath fixes. The first
> one
> keeps new maps from adding non-discovered paths in configure(). The
> second one makes sure that paths that were offline when multipathd
> was
> started or reconfigured get the pathinfo checked and get the proper
> initialization state, when the come online. The third improves the
> "busy" state output in "multipathd show status". And the fourth one
> make
> sure that multipathd prints the "path offline" message for paths that
> are part of multipath devices but were offline when mutipathd was
> started or reconfigured.
>=20
> Changes from v1 (as suggested by Martin Wilck):
> 2/4: Switched to using size-limiting string functions, and refactored
> =C2=A0=C2=A0=C2=A0=C2=A0 the code for rechecking the WWID
> 3/4: Stopped accessing servicing_uev as an atomic
> 4/4: switched from checking (pp->sysfs_state =3D=3D PATH_DOWN) to
> =C2=A0=C2=A0=C2=A0=C2=A0 (p->sysfs_state !=3D PATH_UP)
>=20
> Benjamin Marzinski (4):
> =C2=A0 multipathd: don't add removed/partial paths to new maps
> =C2=A0 multipathd: finish initalization of paths added while offline
> =C2=A0 multipathd: make "multipathd show status" busy checker better
> =C2=A0 multipathd: print path offline message even without a checker
>=20
> =C2=A0libmultipath/configure.c=C2=A0=C2=A0 | 12 +++++++-
> =C2=A0libmultipath/discovery.c=C2=A0=C2=A0 |=C2=A0 2 ++
> =C2=A0libmultipath/structs_vec.c |=C2=A0 3 +-
> =C2=A0libmultipath/uevent.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 9 ++++-=
-
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 | 60 +++++++++++++++++++++++++++++++-----
> --
> =C2=A05 files changed, 71 insertions(+), 15 deletions(-)

For the series:
Reviewed-by: Martin Wilck <mwilck@suse.com>

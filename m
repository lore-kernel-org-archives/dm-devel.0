Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF2026B77D
	for <dm-devel@lists.linux.dev>; Mon,  8 Dec 2025 14:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765205224; cv=none; b=SY8UyBNE4I/ZFXla0vUycpeC6d5u8WXLgMCkSjxvxKhs72EUhDTi/hesGH1ZAzJ4GIIOQ3mVsyuiWVtiFRrMfd78UKAmD861XSGZTpOVjzMOhDPk1wW90yARC0ikjiSSzbRMmeepoNWtP/9THXJgQvsae7BwTHkrvi1Ar4X/8dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765205224; c=relaxed/simple;
	bh=ub6FYFh9/qSs7ILRi2Yw4YsXN7fRaCerqm3dThe96Oc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iEzMXZzVcWDs3ljy4pGe4GKR61+E6eyakl/CWuG0HnvvYJfBP6hwTIDZg5JK6jpwEIJkPJIAPWDqnkE36/IHP/R9fAwSW20P46FUvN4QvYpBjqOYpoiAF45ihvwenocDGzYHjcXB82fF/q4PS6UR4/lNoSe1mQbz/2v6tgvgzIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FF1+0S5m; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FF1+0S5m"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-477632b0621so33332595e9.2
        for <dm-devel@lists.linux.dev>; Mon, 08 Dec 2025 06:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765205218; x=1765810018; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ub6FYFh9/qSs7ILRi2Yw4YsXN7fRaCerqm3dThe96Oc=;
        b=FF1+0S5mr3amNrY2dPfF+Z/JNNmzUS9wwdDgzwz2UtVk0zL+1y8GDmLuFsrAkKtioB
         igvV/Z/5w1ILgqLAV7n5BE0QzKv60nohwTmCbVPjw4vHodGuENvvef6QwgQY0XochGMp
         RN2wUxyDjHvw48fJ/VyMJVhq4M9UpHnE3M0UfbJ1RTJFQCOa/SflHpZ5BGn/0PdKNivM
         wn8KlPyji4fQAufUKkaSvB34rf0WmvUxhGZJ42R4xLEqQvNW81qU0z8UEpBHBrWXCXrl
         U7Ocqr5pIsGsdNiIqNgt7pEogwZJfYELZ/41bRY+5jD4Sfs8bGGnG3wh2srvkCGF0dFF
         l+lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765205218; x=1765810018;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ub6FYFh9/qSs7ILRi2Yw4YsXN7fRaCerqm3dThe96Oc=;
        b=CgE9rfeWMxa0cxbA3ANdeQMedvTYs3noe2AdUXCeTpS3Xr4zR6ctv8tMfYGQZL0gKb
         O/0K+v35aApjcSmyVzhwSAhwNu0XwyOY3Z2G3ygNSqbhWz6Djr0K37pIyLtKaO0/1Flk
         vQZlWjQdOgoh+8aJSm54gMhDAgIqkn36a1FYIewdl+2JGuyQOY9XRwzH9szcf8J2JK6W
         fx4S97ZBrge6lTJJXhGtBTdtZ3cn5hannZfvCp9cGY/pwgZmbVsCLmC9PAguG4P/+p4S
         kwwmBGaLwnTvAxfr+SzV2c1A+phKhxqC37EAVaDc17tX8Cz0UtE8kDSjOD1uF0M1KRoB
         YNug==
X-Gm-Message-State: AOJu0YwFYn2AsnsCm0rqKizy80Xd29lSmL/tS2nqDs0Cd7sbCEGHBks9
	YnlHDOV6WSTpwh7yXnOXBwE01tske3AzO5S7u2/KhGzGuBWEMGfXa9sSAuAkZ73uZEw0Zk/jPXx
	viIAe
X-Gm-Gg: ASbGncvw0qIKCT7DwW2rAtIONyl54r+Ap2juMQhM8Qqn7G1Ls7RIAvInke2b27IeF6o
	94mn5CIcyD1DqySUGJACO8T+EEvfWk0faNXIB++edFw++xNFWCIGVd7hXEtPz3xfIKQ2WBAORlO
	MleZmHPyEbu7m6/v4Ty3jvSVg13JxwLOfwWwR/la0YquDxboKuKorkRhj71xcqehe5aGHTfkr2p
	KyPRTPeUVfxzZqfD+Eh6ZsA1Sr+tPop74u7DLaP19DrUWjZ7cxdP5m+juYi9maqgFSkWNxQNtAH
	HVxZ+Ww8HMgrmPPhT+R6S95AFFoYAwIAE3hjpD9/773NAmrz+WJ8HsxiqeZvA4vtWk1PjBFwims
	bNl6yO1qiqBQm/DlThfV9RUpJToIWc8/6pAtvXckjefAoxazbXfiy2W2JtOFzjT6PjiUzf7/kQg
	Mo6+Vamyjqch4VgeHqHu0hMaLAY1bphMKi+ys91LLnl4s+DIpdQgjvwDni7gWiCNIosSNajhnuU
	Ov7hulNVeRYua+A5pX8Iju3iRD38cTO5m93PFP6TJFqGrQ=
X-Google-Smtp-Source: AGHT+IH+NWbAVeJfot0e3UmpkHyqekJBLqCTHZVknTCKuh8gFvjFEzx4GWCfYxk+F50AO+I4hD35bg==
X-Received: by 2002:a05:600c:354a:b0:477:9b4a:a82 with SMTP id 5b1f17b1804b1-47939e49390mr95953305e9.35.1765205218114;
        Mon, 08 Dec 2025 06:46:58 -0800 (PST)
Received: from ?IPv6:2003:de:373a:d100:7c9:709f:eaee:b67f? (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792b152a68sm122970105e9.15.2025.12.08.06.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Dec 2025 06:46:57 -0800 (PST)
Message-ID: <44ac6212bf407913ed7bd6fff15dda195c7d9135.camel@suse.com>
Subject: Re: [PATCH 4/4] libmpathpersist: fix code for skipping multipathd
 path registration
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 08 Dec 2025 15:46:56 +0100
In-Reply-To: <20251202030213.1432964-5-bmarzins@redhat.com>
References: <20251202030213.1432964-1-bmarzins@redhat.com>
	 <20251202030213.1432964-5-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2025-12-01 at 22:02 -0500, Benjamin Marzinski wrote:
> When libmpathpersist notifies multipathd that a key has been
> registered,
> cli_setprstatus() calls pr_register_active_paths() with a flag to let
> it
> know that the paths are likely already registered, and it can skip
> re-registering them, as long as the number of active paths matches
> the
> number of registered keys. This shortcut can fail, causing multipathd
> to
> not register needed paths, if either a path becomes usable and
> another
> becomes unusable while libmpathpersist is running or if there already
> were registered keys for I_T Nexus's that don't correspond to path
> devices.
>=20
> To make this shortcut work in cases like that, this commit adds a new
> multipathd command "setprstatus map <map> pathlist <pathlist>", where
> <pathlist> is a quoted, comma separated list of scsi path devices.
> libmpathpersist will send out the list of paths it registered the key
> on. pr_register_active_paths() will skip calling
> mpath_pr_event_handle()
> for paths on that list.
>=20
> In order to deal with the possiblity of a preempt occuring while
> libmpathpersist was running, the code still needs to check that it
> has
> the expected number of keys.
>=20
> Fixes: f7d6cd17 ("multipathd: Fix race while registering PR key")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmpathpersist/mpath_persist_int.c |=C2=A0 6 +--
> =C2=A0libmpathpersist/mpath_updatepr.c=C2=A0=C2=A0=C2=A0 | 48 +++++++++++=
++++++------
> =C2=A0libmpathpersist/mpathpr.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 |=C2=A0 4 +-
> =C2=A0multipathd/callbacks.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A0multipathd/cli.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A0multipathd/cli.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +
> =C2=A0multipathd/cli_handlers.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 | 39 ++++++++++++++++--
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 61 +++++++++=
++++++++++--------
> --
> =C2=A0multipathd/main.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 3 +-
> =C2=A0multipathd/multipathd.8.in=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 |=C2=A0 6 +++
> =C2=A010 files changed, 132 insertions(+), 39 deletions(-)

I may be missing something, but this is quite a lot of additional
complexity just for the shortcut. Have you considered just not taking
the shortcut in the first place?

Martin

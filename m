Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1578E2F619B
	for <dm-devel@lists.linux.dev>; Fri, 10 Oct 2025 14:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760108178; cv=none; b=loSuMYCAwpsxbcJuRtPlMAuDXC3b/InsaDE8e3K2XQfEtbTJpZhTq+Qtth5jeQdN1ELGa1EKSBxsyIKfaGZZd7dlI/sqkM7WoVOr7so3b22MSlvZIcJbDGKNKeGalQPXuhaUZnP5dXN1pL0qJyfx40FAoDwZIogZcO5v6xAwVaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760108178; c=relaxed/simple;
	bh=BTLqXho2tsb0ZYsokIGPFob0sShMG+c7+Y9EEEZvKus=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eQslDfE6qaPbSSACM0uNFbVVP2lASKOBzLEh3odA4hE/qiBVkmjnp1kkhZ8UBYAMbXnzXcnDBXhSLk9OxGuVh6FB9fiTZgzyXF2IE1FiV6VPGMi/5b6bsCgpLYJl5LTG5DmoRc3EnWiH4rExSy0KlXHwZtFLIbjJdB8QfhDUz28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gs3SsTZm; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gs3SsTZm"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-639e1e8c8c8so4332820a12.1
        for <dm-devel@lists.linux.dev>; Fri, 10 Oct 2025 07:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760108174; x=1760712974; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+h5Zdr0nHBE5hHovOX863SBkCWG6ydyOJqbqT90tgu0=;
        b=gs3SsTZmdasXNizScP8iyExXrpWR1DCkUAHmrDEYpENyCdGmj1pZykmRK35oToQ5W/
         AjbOWc2jDTnWnbYJRziGsV4RrBPvpnBI+tZVyq1nRletN9JzLZKEfZ1w22VUU4MUQXSy
         pk47yqxUAxz96xKSjMb7tPMM01gTC/ZB4e5326df1+pUVLyjX4iRJ2eg0rvI2WWaV2AS
         Alf0A5WcAL4XTuBvK4pDAmuDosP6DZCgYxux2dNo9RfVU2kwTFfdbTO8qXrKLNN6qlVD
         9BWcUJJmJPGOIC6uCyhBiwvBp24EmseKBd7qca1af2FnngIOyUSwLCGQLiiHc/PWMCKX
         SpeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760108174; x=1760712974;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+h5Zdr0nHBE5hHovOX863SBkCWG6ydyOJqbqT90tgu0=;
        b=c4WeyWvVydfOjWSMTCMXh3Sn09+iHWVldwUKtpv1ADv/Ojsxf6s8t2xL4ByK7Ju4HP
         rrpZg6E50MhN8kJnLceXavZP6y8KYEDHClstescx627KDMTE+CwiMOap6mIn7fYtQo/s
         uWyaGiNeVaPS+kYrKBHosCTler29BpZNoGLmnZppIceb0Oo1XsXpcj3+U8qRkjuNxpAN
         NpFsvzg15889JEs6g9j692vcK/Mm+h+l1P9xjhT4QMmXIPoMWh+TnFvnCAWNj/yrn8Rh
         yn90Im9jzjtdhHrT+q/3F5ai8qmr2JllhKadZk5ndkHPGn3X29H4ijI+A/kiwfQAUynp
         PoBA==
X-Gm-Message-State: AOJu0Yx5RuL2jCIDaXC2D0vmJ2AdXrkUhAr9FONK+EgsDTmEoMnpt9Jt
	NUWnT6a7TuXMbkowN9DmxnpEBFXM36AlfeCjyXvSKdAqhlgW8P+gUUnbVmJdq1wzUAkOqHB0Aoq
	XM8tT
X-Gm-Gg: ASbGnctgFfef5D7XZcUspBJxxuK/dBccIx35wFNkx8KOpP6OYHEN8rB4OaYRSaE71Cy
	3kQwcdLv4siDdjK5kWKKZ6C+kor4CeoqJQ9fSrpMKGPVu1mncROmM4Juvg0WZvX6bHU7TQ0hhcA
	wiMEDiCnNYM/FPsU8F1bR2LVtAp2CiHYx0TUvuYCqkgm3bejWFwftfWbPhD4zI3+q4Jz6JoSHGI
	vBiIrobZsITPKxwHkMckExqMzPO4Nop0BrgtvnkGxurv9dT/bxaHZesPLLUrGOgTi9JXQNoxQxG
	sjs82h4oKPhkC/3mJm7bndkTAjRTWagViN3WUNwTytUQ1dUUczjHHzXUUFfruehmLN2Y4mZ6E4H
	zbxqZz2eIEYLQC31Xevc6F5+ufw/u6xYs2PJsC6bUk7ctx3e5h61Rz6M0oMJHVoezHmRdR8p6yg
	fEONSV4zpcU5c3xYBx48UrBG5F8DbExnL/EQeRzEOOXIcbGkePkIC6fSPemjBp6e0p0bOx9DS53
	g==
X-Google-Smtp-Source: AGHT+IEnMSnhdoVpNNs7kIrzRWJFSo54btt0PMieThic0jCw9iJtO0zereMevUkfrxN+qDwwJMzJgw==
X-Received: by 2002:a17:906:c105:b0:b46:8bad:6972 with SMTP id a640c23a62f3a-b50ac1c0fe0mr1303240566b.38.1760108173991;
        Fri, 10 Oct 2025 07:56:13 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f04:900:e894:a50a:fc99:6ee7? (p200300f97f040900e894a50afc996ee7.dip0.t-ipconnect.de. [2003:f9:7f04:900:e894:a50a:fc99:6ee7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b55d8c12a8esm249593966b.42.2025.10.10.07.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Oct 2025 07:56:13 -0700 (PDT)
Message-ID: <db9092245dfac9f5be0ead3cad1ebfd8afeaa2df.camel@suse.com>
Subject: Re: [PATCH] multipathd: Fix tracking of old PR key
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Fri, 10 Oct 2025 16:56:13 +0200
In-Reply-To: <20251001033524.1760914-1-bmarzins@redhat.com>
References: <20251001033524.1760914-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2025-09-30 at 23:35 -0400, Benjamin Marzinski wrote:
> When libmpathpersist is in the process of changing a registered key,
> multipathd needs to remember both the old and new values of the key
> to
> deal with a race between limpathpersist updating the key and
> multipathd
> restoring a failed path. It was supposed to stop remembering the old
> value when libmpathpersist was done changing the key and issued a
> "setprstatus" command. However, clearing the old key was done in
> set_pr(), which only gets called by cli_setprstatus() when
> registering a
> new device, not when changing the key on a registered device. Also,
> set_pr() is called by update_map_pr().=C2=A0 This means that multipathd
> was
> forgetting the key when it shouldn't and not when it should. Fix this
> to only forget the key when cli_setprstatus() is called, and always
> then.
>=20
> Fixes: 1aeffa9e ("libmpathpersist: handle updating key race
> condition")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =C2=A0multipathd/cli_handlers.c | 1 +
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
 1 -
> =C2=A02 files changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 0c65e7d2..7f572fb4 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -1293,6 +1293,7 @@ cli_setprstatus(void * v, struct strbuf *reply,
> void * data)
> =C2=A0		set_pr(mpp);
> =C2=A0		condlog(2, "%s: prflag set", param);
> =C2=A0	}
> +	memset(&mpp->old_pr_key, 0, 8);
> =C2=A0
> =C2=A0	return 0;
> =C2=A0}
> diff --git a/multipathd/main.c b/multipathd/main.c
> index d7642a0b..d11a8576 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -4250,7 +4250,6 @@ void set_pr(struct multipath *mpp)
> =C2=A0{
> =C2=A0	mpp->ever_registered_pr =3D true;
> =C2=A0	mpp->prflag =3D PR_SET;
> -	memset(&mpp->old_pr_key, 0, 8);
> =C2=A0}
> =C2=A0
> =C2=A0void unset_pr(struct multipath *mpp)

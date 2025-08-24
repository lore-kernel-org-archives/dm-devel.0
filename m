Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA2219D087
	for <dm-devel@lists.linux.dev>; Sun, 24 Aug 2025 15:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756049592; cv=none; b=cR/5usr+uDjJpBAR/ZB5nt/r8WcZGoOie1cQrZektKD3GVpGBM2Tj9a/dw26Q5Zz3LFdBz2SBShKftgqs4sv7rTFmtGADONY8SnoReMC0Acurj6u6WedbLxopSzDbwUkyJR1lHyZGq9cpKmCdJZs6HAFtxfP7ryazKUIwIAKZ/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756049592; c=relaxed/simple;
	bh=+spX+FerxBI8Uv2XbAnq5c/7/NBtvawhZY66iPS6l5I=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bbE47IAxZZtr3BqFYA4Bms/yLfYxkrb4NuddPTXLq2S3tvH+rI9XIrpYLpGZEqUbVg1IKRZESTknSqjv2zdYvZhSPx1QSuewqsEELV3WHRXP25U4nKJ8RQlAOEKqiBHbLyohgnG0OAo2scTbRmmcmL94mZPAQth59/v2hEEJ+ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ReBYfMsJ; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ReBYfMsJ"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45b55ed86b9so9162925e9.0
        for <dm-devel@lists.linux.dev>; Sun, 24 Aug 2025 08:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756049588; x=1756654388; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=//drhHSaC98NXVimEr1Lb5x0LHN61m1ucgWecZrKJAI=;
        b=ReBYfMsJvFbwEbQTkBNWYeCOPC3RoZ7Z+OqiyMWZArYOsIKT6kP6nvzT1yhP7Go1QN
         oYFGZgoDPa/1wp6gT7RKg35FbOdr3TbtTkQ3W9sE7Bb664nXzfiU/ga+T0BFkDqqYyAO
         WBlfJ3FmJdtqtpHaD4prF76Tph+huVC5HMJPhx0KDI+Rt6YT9wHDKURDPEbX2dfGYF3F
         OwGa5YnFuUXLi5vERSx5jPKrBWfV2A6AOXCzOlRIEAOIX41UdkKw1yEolu2hp0UDPrzT
         M9+cio8N4NXAseJcVfF+KY99UeGge8/l/HpF8pCpfwknPxBTUkX9RzfVo+OCUjNUUJOd
         ZEWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756049588; x=1756654388;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=//drhHSaC98NXVimEr1Lb5x0LHN61m1ucgWecZrKJAI=;
        b=f9Hu+en3HJYZctLofP82M6PDBgZH0dVd+e5wybvHwMK176KDM0c9bT4J1SGtmTns9S
         e4FUbeAVrNiqSVYzTKbHtWvgaa00WkwkuEb9VH+p2/ktz79LF9kZEikpUQnOY9W6InBa
         66XAk/QYh5kf5VhmR9sdAF5lFGC7ZCDr+1UppBp2kEzeCJPvgaDW2pqxjf2zUm8bBN8r
         UVWm7SjitZ9bnJ7Ko9RUfO6HKySRzEWyUVmAshNFd9lOZFSTKz9cU+l2/ft5353tKcPl
         tJg/6nOtzO+P8s7fgVTgu83ObSUYSB3UcrrZUInw6/drT0tRJ7wH/B525SPaArB/kQHz
         ulOQ==
X-Gm-Message-State: AOJu0YwsVDzjwSA6fnauK34OZK/hjoKpxpG/cNoG8t73SjbyvWLk75Gc
	JXB/HSRwpn4rjd7oprTxg9erqyTnJ1TwETyVE4AJaqiN0gIySh7yT/nDUXYmczrtEfgRpQ/fZSv
	ZywDvYXA=
X-Gm-Gg: ASbGncuH3CdIF5hnnYZdSUopWziky+ANDq5wkxydrh5bSg4CSzwcxh25fvcKyKj1hAC
	9S/L4jSMmwI+VERE6AiERhweSlG11CDitEq90jroZKANc3HoFMti9XJfeZEhfHzlwHAnYSDjNaZ
	qXUQ61eo7eih26pEdjs7bfOlaz36o+9+Jg1f/uck2Y3PekP99L2zXi6nCGAyI9hpsi99J2M2Y67
	oJ3cBvnxYlc0oTcjLaarZFptn919UGNdgfSBF9mtvNq3cGtSmRhLGDVc/nAHzKaDhhW3U8KiS9O
	ryxernQsyGuCxo0jcs1vRnZ40aXhMkpgbQ1UH2RgC7KBMRgYvoQD0UvlcszqupOLwJJu51G21SX
	bptE2OBjvg2f8GsoWZV3moZAXoYhMjwqy3D/aovF+A8rdr78tO1vx/7lHhmD5u0hCxrb85ftDbq
	yS7TJrXaqsowHHvACl6yagW3jj57GlNjFLxe1cDDA6AhYRfBvbfmxXKQ==
X-Google-Smtp-Source: AGHT+IHpZU/RLr8R6fjUyuvYJ5G8htlkV4pFc2AX90Puh9zauJDh/Zyqxo7rDJdhC3K7lR/NJUQC7Q==
X-Received: by 2002:a05:600c:5250:b0:43d:563:6fef with SMTP id 5b1f17b1804b1-45b517cca3emr64614765e9.21.1756049587999;
        Sun, 24 Aug 2025 08:33:07 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f15:4e00:f2e:2331:5e9d:fe56? (p200300f97f154e000f2e23315e9dfe56.dip0.t-ipconnect.de. [2003:f9:7f15:4e00:f2e:2331:5e9d:fe56])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b5c547ce9sm40850375e9.6.2025.08.24.08.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Aug 2025 08:33:07 -0700 (PDT)
Message-ID: <897959294c661240be74a785b7790c95af4c010d.camel@suse.com>
Subject: Re: [PATCH 10/15] libmpathpersist: fail the release if all threads
 fail
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Sun, 24 Aug 2025 17:33:07 +0200
In-Reply-To: <20250710181100.3997759-11-bmarzins@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
	 <20250710181100.3997759-11-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2025-07-10 at 14:10 -0400, Benjamin Marzinski wrote:
> If none of the threads succeeds in issuing the release, simply return
> failure, instead of trying the workaround.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmpathpersist/mpath_persist_int.c | 12 +++++++++---
> =C2=A01 file changed, 9 insertions(+), 3 deletions(-)
>=20
> diff --git a/libmpathpersist/mpath_persist_int.c
> b/libmpathpersist/mpath_persist_int.c
> index 7fb08b2e..ad5a4ee7 100644
> --- a/libmpathpersist/mpath_persist_int.c
> +++ b/libmpathpersist/mpath_persist_int.c
> @@ -475,15 +475,21 @@ static int mpath_prout_rel(struct multipath
> *mpp,int rq_servact, int rq_scope,
> =C2=A0		}
> =C2=A0	}
> =C2=A0
> +	rc =3D MPATH_PR_DMMP_ERROR;

I find the relationship between "status" and "rc" a bit confusing in
this patch. Can we use something like "bool all_failed" instead?

Martin


> =C2=A0	for (i =3D 0; i < count; i++){
> =C2=A0		/*=C2=A0 check thread status here and return the status
> */
> =C2=A0
> -		if (thread[i].param.status =3D=3D
> MPATH_PR_RESERV_CONFLICT)
> +		if (thread[i].param.status =3D=3D MPATH_PR_SUCCESS)
> +			rc =3D MPATH_PR_SUCCESS;
> +		else if (thread[i].param.status =3D=3D
> MPATH_PR_RESERV_CONFLICT)
> =C2=A0			status =3D MPATH_PR_RESERV_CONFLICT;
> -		else if (status =3D=3D MPATH_PR_SUCCESS
> -				&& thread[i].param.status !=3D
> MPATH_PR_RESERV_CONFLICT)
> +		else if (status =3D=3D MPATH_PR_SUCCESS)
> =C2=A0			status =3D thread[i].param.status;
> =C2=A0	}
> +	if (rc !=3D MPATH_PR_SUCCESS) {
> +		condlog(0, "%s: all threads failed to release
> reservation.", mpp->wwid);
> +		return status;
> +	}
> =C2=A0
> =C2=A0	status =3D mpath_prin_activepath (mpp, MPATH_PRIN_RRES_SA,
> &resp, noisy);
> =C2=A0	if (status !=3D MPATH_PR_SUCCESS){

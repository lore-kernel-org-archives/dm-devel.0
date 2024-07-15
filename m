Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE482AD31
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 15:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721056798; cv=none; b=sL2ZuSY3KGB2Sposy9tZpPwv7MuZ/NG+mMTn7WHjnXvX2XI9fcMww31FBAIIMWM0y6aQA5keGAqtp6QEyL1+ZWpOAwp8v9spbvZArKd8A4ImnGvp/tCIPxkclZriwwyjcv3hOnvY6Pna07kxgIZ/Qe4jhBXV8TFbRLj8v7AAv00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721056798; c=relaxed/simple;
	bh=M3/XhpOpTP8q2+Q1WdArRk4x9TavkzyQTPu3XlbNySs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qkAMF1/lADbOW0EDO4jLO0lueoAziewBe5uS5TKunt34TdCeCvD9RypoePmPfLuTxj1OYhTsbmz8IZTkferz3G+B8UYeJ3zZNDeFFwXoiCdcZYNH9CxpfQcDMaZbWgJQDwbiMuJLLCJp339M1pKKeHPiVlwVgsZEk1lcQ5Yoldk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gz7SR+5L; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gz7SR+5L"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a728f74c23dso561928766b.1
        for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 08:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721056795; x=1721661595; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rLByfI2SOSqXwkEAaoGSTozn8YumsJ8mrl41kLGKV40=;
        b=gz7SR+5LwCCY04327Iq3jlq11K2D1LEYuNDf40DErY7CE4g+H4eAy/Juol4LGLk88U
         21+gDz0I5jlRLL+r9/RIZAr8HCVPdAfXgZ1+tU4Smku4f4+7JUKsosJmLjW0nj2Dw98t
         9snGpAOq8KkPwPLcYdvMXpz5xnRCIK9FKE9FIGfY4sTzEDP57/vGArDYuIAvzEN1V8Us
         jN4mErdFWD6PZY4aCI+R/EmsLVuIbnkUSj3s1WK1srKyhK0lQs6q69xOwCN4yOHmmSpB
         BiA+82ALr8+K6bEKnA9rA4RoNWD8so4R87bbgd0Mh0JMxqsjvc6OHWfgFr2qf8+m1xPf
         7FPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721056795; x=1721661595;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rLByfI2SOSqXwkEAaoGSTozn8YumsJ8mrl41kLGKV40=;
        b=Bq0iM3r83lU372sD757kUYuELEwJGhFs16MAhz3nvUZSeYpXH9sTvA/1YWYxsZgVoX
         QGvvRI+B0YuMIjOUhDKFpOze+hA9Y2yCD8g55Hq3ETl83ufMNL9mmTlI7s6Vy0LhifXp
         SQdWdoMrF7FX9a9q+s792IGbWNjKSzAvpwBZY78BQsUIkIlo4N699S6mD9j+OSVbdOfR
         aR6WH/7orkF71+2VAdkw+EaTMFN4MjYmqZpUDO4wg6htbvodlz+C8PB6ByqE9trnh0ct
         3X7/XFb9Ffq9ZohjDa5ERkyVjwuyLwXC98GpCKrJBW9IAtKtp35RzlJDczTJuB4Ek/BG
         nZiw==
X-Gm-Message-State: AOJu0YzWbfZIfpQuar3OycAGAIQz9o/YVFOfXKXx2FhnEFXxvqZu/Bjy
	zm91xS3VyZMA+drW83Q9rLnNTV9Sr4/GZrrxSg+u3kmLmPZ9O4aG1p9enjm9Qzo=
X-Google-Smtp-Source: AGHT+IGVir1gDGCE4EQ94eaaPDb4oXh9RMr1sUToHsWfYbVcB2+/2o9tDSoakrzhXRQIbhWFpIcvIA==
X-Received: by 2002:a17:906:4ad1:b0:a77:dc70:b369 with SMTP id a640c23a62f3a-a79e6a46ce9mr5824966b.22.1721056794811;
        Mon, 15 Jul 2024 08:19:54 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a79bc7f1d1esm217697366b.130.2024.07.15.08.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 08:19:54 -0700 (PDT)
Message-ID: <5c5bc1755a4a1767ef431dfee9eae30811c945e8.camel@suse.com>
Subject: Re: [PATCH 04/22] multipathd: refactor path state getting code into
 a helper
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 15 Jul 2024 17:19:53 +0200
In-Reply-To: <20240713060506.2015463-5-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
	 <20240713060506.2015463-5-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Sat, 2024-07-13 at 02:04 -0400, Benjamin Marzinski wrote:
> Pull the code that gets the new path state out into a helper function
> named check_path_state(), in preparation for splittig check_path()
> into two functions.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0multipathd/main.c | 64 ++++++++++++++++++++++++++++----------------=
-
> --
> =C2=A01 file changed, 38 insertions(+), 26 deletions(-)
>=20
> -
> +	newstate =3D check_path_state(pp);
> =C2=A0	if (newstate =3D=3D PATH_WILD || newstate =3D=3D PATH_UNCHECKED) {
> -		condlog(2, "%s: unusable path (%s) - checker
> failed",
> -			pp->dev, checker_state_name(newstate));
> -		LOG_MSG(2, pp);
> -		conf =3D get_multipath_config();
> -		pthread_cleanup_push(put_multipath_config, conf);
> -		pathinfo(pp, conf, 0);
> -		pthread_cleanup_pop(1);
> =C2=A0		return 1;

Nit: Remove braces here?

> =C2=A0	} else if ((newstate !=3D PATH_UP && newstate !=3D PATH_GHOST &&
> =C2=A0		=C2=A0=C2=A0=C2=A0 newstate !=3D PATH_PENDING) && (pp->state =3D=
=3D
> PATH_DELAYED)) {

Thanks,
Martin



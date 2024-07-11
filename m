Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EC842AB5
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 17:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720719696; cv=none; b=TJlufd/2NyWI1rDTeDGz2DqWNGXZO3RgDUSUqrfQO1KOBtEUE0sCjRv89FFJRnzSL/A793NYVnlIG76VeHMqT1N3kfN2aYzcrBmu2NmcUa807ZjunF9MU5lVu4kHR4JlFuyNKmSWIYUJ8ZMDF0a84fwq4GRm3INUkjzk+MU0zFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720719696; c=relaxed/simple;
	bh=jgrUY4ZYxPaV6jKfMVBTVE2nv0AzbKMsal/OfiLJ7zg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iPpxjM+/jNP67QmgV/hRxXKBeH2eWT1u+uMd5ai7MxChEWMCP8l0jRfwfzmxyTUd9OcAmvFB25mmIW23sr5qf4CS+foOjv5m1x1i+HclUIKrpt6Mjw9K1ZI5eb/R6YGvSPU+KupvNpt6GvaaRQtyoBvYs8vw4lVeR1kqJfCNkdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=edyjHyhT; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="edyjHyhT"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-36796bbf687so557591f8f.0
        for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 10:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720719692; x=1721324492; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LfA1oZMPtN5iZbMlzrODY41vZA5ZulJz33p9jnWyxrQ=;
        b=edyjHyhT+HcXaihU2zghR/y1gIaTwLma7g48tb/Zr1z0gDns+GqQm/i2TisN/s6vRB
         P7BDzDQheLNipoHU0SAcL4aGaSBllcO/GDlkD9wVENm25eU0Fo8oth40daBoMJnUnLiL
         u7CiSQfgAYbexiprp45j1Gd10iD2RSALcovRNF/HuKlv/ErFRxlPs/LQKcY2XWhsinQ7
         ncoZT0P1nu++I3tzIkOhOcVd3ZwZNe/tXkmcOsYkZz6P0c6YKWtCySS6ALFMFSWA8nzw
         zOZ9iWkU1yZrNhGU6Wy0SDaDd5yeWuVBQDYv/2a802IwsIVoQO3097qDY39Lt8PsqzeR
         1+Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720719692; x=1721324492;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LfA1oZMPtN5iZbMlzrODY41vZA5ZulJz33p9jnWyxrQ=;
        b=AdTFfOXqK5wl1FPACHAOYJIBluvfBHIKAp+L11cXbLoIXcn+QPQvFa+mpGy3GbgKIG
         srp26v2t/8lGrS1yc4okCuMgITEwEuk/pBScRJrF2ouxZKNFbS4aRZmNiyHr5+sLhLVi
         qHU2q7sUAw1LbB/8RLys5aIaw73exTgZGHvlEqby5HJ4UQ3DFQ66t30vXc1Mr081s28C
         McXUdG/yQ0kcxVXXdOJOoNUkqb7nIs4pCR+MZ7wiBaXIGw+2KFt6RF7V3/hMyy8DB9jS
         C/JLc6KpkMH1Ixzyn5nEjda5PUIaS532QiK2KDnbSii7WbubQfFBSsT1+iodCJr7924A
         gMbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQ8zfAvVrB1q4jB/55blqwXoaiTzPTCZKuXm2NL/lYWxINcrdNRVa95Q9QAqkOiDSwuMBL8ifKsy+gutFxR3FKYAh+zb35HGs=
X-Gm-Message-State: AOJu0YwoNizV2Y8e3vQoGMedA4bmMXRMGr6FphH69pDFcbHmsYvpXSlo
	dmtFNhAJggF7UN22c6IKm6oTnvSUOIucDBp3pbFH9ufZseO0n/94aJWzMcMOV90=
X-Google-Smtp-Source: AGHT+IFgqIgn8SVu3u+j4PWxkmo8G0UBQ+2yZrjNwuJDGMlZYsLKbO/iUkYyYXDKfA8wxyYv0/O3Qw==
X-Received: by 2002:adf:e60a:0:b0:367:9073:3496 with SMTP id ffacd0b85a97d-367cea8fa18mr6436948f8f.29.1720719692418;
        Thu, 11 Jul 2024 10:41:32 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-367cdfa06d3sm8226414f8f.75.2024.07.11.10.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jul 2024 10:41:32 -0700 (PDT)
Message-ID: <c8365ed719dfeb30945f2e679ac63810d83d28d1.camel@suse.com>
Subject: Re: [PATCH 21/44] libmultipath: is_mpath_part(): improve parsing
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Thu, 11 Jul 2024 19:41:31 +0200
In-Reply-To: <ZpAPzqxbXm6dkTyU@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
	 <20240709213935.177028-22-mwilck@suse.com> <Zo8RMOqoXP-b3dWz@redhat.com>
	 <8348b96fc7ae7ddce4886efebcecbd7416a40d98.camel@suse.com>
	 <ZpAPzqxbXm6dkTyU@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-07-11 at 13:01 -0400, Benjamin Marzinski wrote:
> On Thu, Jul 11, 2024 at 01:08:39PM +0200, Martin Wilck wrote:
> > On Wed, 2024-07-10 at 18:54 -0400, Benjamin Marzinski wrote:
> > >=20
> > > we should probably use "part%u-%n" so we can't match a "-" before
> > > the
> > > number.
> >=20
> > That doesn't work, %u accepts negative numbers, too
> > (https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf)
> > That's why I use int and check whether the result is positive.
>=20
> Huh? I learned something new. I actually find that kind of annoying,

I know, I was also surprised when I found out. But strtoul() behaves
like this, too.=C2=A0In C, it's perfectly ok to write

        unsigned int n =3D -1;

Maybe that's how we should look at it.

Martin


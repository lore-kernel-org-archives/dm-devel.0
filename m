Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412D6350A3F
	for <dm-devel@lists.linux.dev>; Tue, 11 Nov 2025 11:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762862381; cv=none; b=pXo5eGL+KgXSEGQwDJvVCMpMtDjSgolt6TkjrdlYtaq20ALe6oTTMOwm85rBCLv6WhikGAHkZ1a+8n+Adz65/6VCOk+HLN4z8qcuKMjTrs/fpyc2iZjob53jXe19gkpWArHGyTrDykvwSIXptUgaqBe914CtKbkP/XMQhzFMiq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762862381; c=relaxed/simple;
	bh=vaD/T+qICtz8ZXm6BNMOW2lzNQTEC0dUE5JuBzFsCOc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SPrV/4BtfcVp/GEKqXcUYGthHmX4nCWGkgqESdz+knD2DUt6Dv/1PlKb7UgpcWZJHgvTnNH5+Gsd5RL0OrJ62b6YTbtoYszvGpebNuoXm1FeB/DrncChajwmM/ToVABXWNW59RfehW0nDVbNqW7RoLwFQndB1EfhlPlHosGhiq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=USBd4fbL; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="USBd4fbL"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-640aa1445c3so6295399a12.1
        for <dm-devel@lists.linux.dev>; Tue, 11 Nov 2025 03:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762862377; x=1763467177; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=foXs+A0tXIvOTIqlgy6mlErwwkTl3r2UTg3ln7Z/AkE=;
        b=USBd4fbLp6BUqFfQfq1FrMOvcGHOGrQMe3Mn4EdltEpLq/J/h3z693IJI7rTdv0lkx
         IVWbzoGNPeiiScB6tUWjV7OGZWFG34Qcqn8DZa24x3NkoD3GPHTF127Ntr1Wegb2ihTA
         uwnRorTFOOpI2OsI3lMnu0DJxVB8PJMupNSjLp2CQa781leRB9eEY8aQKUdx+qlJh0f8
         gG8J4qhtLly81jUE+b7SO7aBJ5JBltzcigactdqT4W+uTL1w7BiU32szZmg/T3gDuZKz
         C27340kmcBPFxvgehGjsQpeIM60FeUID0jWzW1BPpgStuIu7c6qnt8bzwNWbpVbfevSN
         yjDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762862377; x=1763467177;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=foXs+A0tXIvOTIqlgy6mlErwwkTl3r2UTg3ln7Z/AkE=;
        b=H04mhj2XrEqVZemKvNE5pD1j6fmx/ANsZaAG1FfXm7beMP6R4J/V0XHZrIlunasDvj
         A/ngLhfBZCNij5ET8cKVfxMIuaJ2iU6Hf5FfHnMqHtM1QQR6euASlBxwoYEBoHZKGFce
         /ZRVVqLv8ZkdzeLP53nNzqw9hnqJz7+5ki1juCYBuG8WeJe+rYSFBrNcwzPs8sSlkC1b
         A+A5NH++sJnkOByK1vWqiZJ1u41DJtwRJq4LbTeSNP9spQNVi8kzvCEzGY9tA8JOQttq
         JcG7/MDS6xIlZYIGUV32nhFf0W1ZY8+KKseYn3sIjgDxupi2GRr8bSQKmAdwCy/+THMJ
         ylhw==
X-Gm-Message-State: AOJu0Yy+22hFcw7K07m/W4lhDi1YT64Wvfw8687E98nDhLdWA9j5H9p8
	NvEm5rV3FOThFJgD5vO4vTx2hCoGsnYiRRLpP3as8ZXqP1vLYXFhDQkdvKCmUplFMDo7g4hEeuz
	4o306
X-Gm-Gg: ASbGncsaXBaEIbszz7IF0h1ksrJRSV8tDQSeoEPyyWewD7rVHDj5x4HIvuDB4fa0hRR
	b+4qx1mXR0J10nB4C3Lm1A2sBa1Auf06D9+aLhpV9Kvi1mJtMIZVkpcscGLkxXyYNFdOk38KcU1
	OOr6JrswWhEPpa2ZpBWqQgmnamx4QsSmyr5/MQQG3S6HmV70QMsreSES1DNTvQNFm44cyuJyXoQ
	cd0pas2yx+NU46lWj03dBxcwlxkNvE0g7dsbKTVPKVRXgUooS4bo9iJhfoAl+jU+w/7wWvdLDoH
	jUcvniiRglq6y9CN7yZVIR3i2ywVb81YKf9gLxahOk2QABPmRIQcXb6SzGgj1fsJgxQLQWcbpa4
	qt8sO6Cljor2PUb8pd8/A0xuCVgju+AIim8TvlKuWE6R8D+f2yhC7bg4kCq81SvnHcseVm6W/nf
	mWCLyH7SQwiYF1kU6/9qSkhRaZkOYqnIs77eYRComh1uqhjDatCl1ZgEX/qKxqwVoXfW6UuNdFY
	h44FBQQE58LLSxtiwcS0SOh/X2IpMcZRl/+e9MCCJRcXhA=
X-Google-Smtp-Source: AGHT+IFMB9+632D6cF9qRF7fUHrSNnsi0qnM4Zo/Vz7Xd7PeqC5knirFIdHUqRRcAyAC1HFjpMgo9g==
X-Received: by 2002:a17:907:c25:b0:b6d:8ce4:ff18 with SMTP id a640c23a62f3a-b72e02b60cdmr1310248666b.9.1762862377432;
        Tue, 11 Nov 2025 03:59:37 -0800 (PST)
Received: from ?IPv6:2003:f9:7f04:900:e894:a50a:fc99:6ee7? (p200300f97f040900e894a50afc996ee7.dip0.t-ipconnect.de. [2003:f9:7f04:900:e894:a50a:fc99:6ee7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf9bd72bsm1336385766b.49.2025.11.11.03.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 03:59:37 -0800 (PST)
Message-ID: <d5568bb0fca96dec88ca8fccfc68b2fa8191335f.camel@suse.com>
Subject: Re: [PATCH] mpathpersist: Fix REPORT CAPABILITIES type mask output
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 11 Nov 2025 12:59:36 +0100
In-Reply-To: <20251110215156.589437-1-bmarzins@redhat.com>
References: <20251110215156.589437-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2025-11-10 at 16:51 -0500, Benjamin Marzinski wrote:
> mpathpersist was incorrectly parsing the REPORT CAPABILITES service
> action output. In reality, the type mask is two bytes where the type
> information is stored in bits 7, 6, 5, 3, & 1 (0xea) of the first
> byte
> and bit 0 (0x01) of the second byte. libmpathpersist was treating
> these
> two bytes as a big endian 16 bit number, but mpathpersist was looking
> for bits in that number as if it was little endian number.
>=20
> Ideally, libmpathpersist would treat prin_capdescr.pr_type_mask as
> two bytes, like it does for the flags. But we already expose this
> as a 16 bit number, where we treated the input bytes as a big endian
> number. There's no great reason to mess with the libmpathpersist API,
> when we can just make mpathpersist treat this data like
> libmpathpersist
> provides it. So, fix mpathpersist to print the data out correctly.
>=20
> Also, instead of printing a 1 or a 0, it was printing the value of
> the
> flag. Fix that too.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

LGTM, thanks.

The way libmpathpersist treats this field is totally counter-intuitive,
but it has always been like that, and I agree we shouldn't change the
API now. However,=C2=A0it is not unlikely that other users of this API (if
any) also get the byte order wrong for pr_type_mask. Perhaps we should
add a comment in mpath_persist.h. Could you add that?

Also, while staring at the code in mpath_print_buf_readcap(), I noticed
that the output for PTPL_C is also wrong (missing "& 0x01"). While at
it, could you perhaps fix that, too?

Regards,
Martin

> ---
> =C2=A0mpathpersist/main.c | 23 +++++++++++++++++------
> =C2=A01 file changed, 17 insertions(+), 6 deletions(-)
>=20
> diff --git a/mpathpersist/main.c b/mpathpersist/main.c
> index 97fd5a43..5033ee8a 100644
> --- a/mpathpersist/main.c
> +++ b/mpathpersist/main.c
> @@ -761,12 +761,23 @@ void mpath_print_buf_readcap( struct prin_resp
> *pr_buff)
> =C2=A0	{
> =C2=A0		printf("=C2=A0=C2=A0=C2=A0 Support indicated in Type mask:\n");
> =C2=A0
> -		printf("=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 %s: %d\n", pr_type_strs[7], pr_=
buff-
> >prin_descriptor.prin_readcap.pr_type_mask & 0x80);
> -		printf("=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 %s: %d\n", pr_type_strs[6], pr_=
buff-
> >prin_descriptor.prin_readcap.pr_type_mask & 0x40);
> -		printf("=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 %s: %d\n", pr_type_strs[5], pr_=
buff-
> >prin_descriptor.prin_readcap.pr_type_mask & 0x20);
> -		printf("=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 %s: %d\n", pr_type_strs[3], pr_=
buff-
> >prin_descriptor.prin_readcap.pr_type_mask & 0x8);
> -		printf("=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 %s: %d\n", pr_type_strs[1], pr_=
buff-
> >prin_descriptor.prin_readcap.pr_type_mask & 0x2);
> -		printf("=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 %s: %d\n", pr_type_strs[8], pr_=
buff-
> >prin_descriptor.prin_readcap.pr_type_mask & 0x100);
> +		printf("=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 %s: %d\n", pr_type_strs[7],
> +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !!(pr_buff-
> >prin_descriptor.prin_readcap.pr_type_mask &
> +			=C2=A0 0x8000));
> +		printf("=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 %s: %d\n", pr_type_strs[6],
> +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !!(pr_buff-
> >prin_descriptor.prin_readcap.pr_type_mask &
> +			=C2=A0 0x4000));
> +		printf("=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 %s: %d\n", pr_type_strs[5],
> +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !!(pr_buff-
> >prin_descriptor.prin_readcap.pr_type_mask &
> +			=C2=A0 0x2000));
> +		printf("=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 %s: %d\n", pr_type_strs[3],
> +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !!(pr_buff-
> >prin_descriptor.prin_readcap.pr_type_mask &
> +			=C2=A0 0x800));
> +		printf("=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 %s: %d\n", pr_type_strs[1],
> +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !!(pr_buff-
> >prin_descriptor.prin_readcap.pr_type_mask &
> +			=C2=A0 0x200));
> +		printf("=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 %s: %d\n", pr_type_strs[8],
> +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !!(pr_buff-
> >prin_descriptor.prin_readcap.pr_type_mask & 0x1));
> =C2=A0	}
> =C2=A0}
> =C2=A0

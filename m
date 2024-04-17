Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23A213A3E8;
	Wed, 17 Apr 2024 10:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713348343; cv=none; b=NF++83WGlMLokKiwiFzUD53ebluXwlT7EG+/O7G7ortpbnLTsh5XK1+oEVfgAP+KUSZfJ9K7EIcwb8VS2LzodnID/YabqhZfKVCrLofo5hr3ecViNjUX0zi51I0v6A+urOJCDCF+dn4vNrkEyMovKqKlyP38+Cq/29UQR7iDR5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713348343; c=relaxed/simple;
	bh=1gRmg87JIr+AbQO3Esc+cHkCY63QUm02iWl6ErooOoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XU3td6G7fWbXnPQf48Ggof1Fp54+Dk+nhoogxH6usw13701HNr/jHnf9sOMZrfh+KiA4uo90vw+/VdnlrIbEZ6BSJTcmCHdEnuQP0DKeFAl3p/IW7l3FNJ281xkDVEIEXR36ehI9JGEKd8eUI/QYlIomd8EaJ1L5qic6YYBdyTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E7N/1X16; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E7N/1X16"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5d8b887bb0cso4045938a12.2;
        Wed, 17 Apr 2024 03:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713348340; x=1713953140; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1gRmg87JIr+AbQO3Esc+cHkCY63QUm02iWl6ErooOoI=;
        b=E7N/1X16YKChCa7WH9BNN4xCDPxkjcZecadqnavxB8oDRzUN1b/UV32QQ6dCdOy5UL
         UT0C71rVadhQQQBNpwq5j8HEaXe3GTwkrHy1TDqvVP2tIRn32clrUhwZzZASlG92dhmO
         M5r4vnXltLTfNZPiSIRElAcGZRmMilE8URxo0jG/iahlQqMUKsdlbPPzt8+aceYBmPp0
         pImNeF4USvuSUulc+nK7nj2dTBBotybvOX1fIzOJamDmoEiB18H1Z3dfmc5Dk47W2cEL
         6gFKPv5e67rj3HRmoR5FlByamiLHwt+pmk9TCCFxt4H8NWzdJc3OVQNlHEVqSmIy8Io9
         Lq+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713348340; x=1713953140;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1gRmg87JIr+AbQO3Esc+cHkCY63QUm02iWl6ErooOoI=;
        b=RB2MGdUwOtdYMMaMA25IgESDfBtSAahCf/qxLuVVJKOI0BZ6rXhktQFV2r/IzpMtaD
         Ooa8au8xFRa0pkgHGvEB/CxL1iXujrS2+mElqZyXwMyXsVsGMpoGTGrg+wLtASYpjN4n
         SjyxRvEi9Q3kXzae5lNXE86QWI2nEsOckHRMzaQm74Yh5EqldhaMjfl3+eiY6JsTL7IL
         EOCrssJO+JFBCGlt9nMIHFB23Oj7MZpDg91Z0kl+f/jmx9K5+p57kXnvkg+bL07mlySD
         m37zXCmIcfsAny/vcCANGETAmgdF31i9uZe7e+Z1Ye+dZsxicBFUz5xREw3lv1AeXuib
         BLHA==
X-Forwarded-Encrypted: i=1; AJvYcCWaF5CPOBYQGKoEiEajy6pXtaNmNRoVGC3S8kqldm1yqysQI4iP4pWqSsvwtlNLpeEV/I/ZBVhVDZr0ZwS74FxOF9xAwMpvKaRJCYogf+eV2TClqY8HPjYIae2kAqdX9hWkmQ==
X-Gm-Message-State: AOJu0YwzwFuYTYDyJWgl+FIYMjMObzNobgBRq7e2wJU3ref+19/M8MfT
	4LCIgGFfSybBDW4ia79glHWefJ/pXhi/6UCmhvDPL11prNui60uU
X-Google-Smtp-Source: AGHT+IHoSQwgWNaYYN9PHfJ92Leu3dCSJnPJtoI+4IJ8iitgaNIncK7hpg/lzzZCpwVd83QGt3/Z2Q==
X-Received: by 2002:a17:90a:108:b0:2aa:7057:437b with SMTP id b8-20020a17090a010800b002aa7057437bmr6040509pjb.16.1713348339921;
        Wed, 17 Apr 2024 03:05:39 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id t12-20020a17090a5d8c00b002a474e2d7d8sm1019325pji.15.2024.04.17.03.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 03:05:38 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 1682E18462BA0; Wed, 17 Apr 2024 17:05:35 +0700 (WIB)
Date: Wed, 17 Apr 2024 17:05:35 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>,
	Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net,
	zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
	tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com,
	snitzer@kernel.org, eparis@redhat.com, paul@paul-moore.com
Cc: linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org, fsverity@lists.linux.dev,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	audit@vger.kernel.org, linux-kernel@vger.kernel.org,
	Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [PATCH v17 20/21] Documentation: add ipe documentation
Message-ID: <Zh-e7945DM6f2u9T@archie.me>
References: <1712969764-31039-1-git-send-email-wufan@linux.microsoft.com>
 <1712969764-31039-21-git-send-email-wufan@linux.microsoft.com>
 <Zh0Zh3-xraVl85Lm@archie.me>
 <a2266217-c3ad-4bb2-8188-498a2c8ae36c@infradead.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0nWDRmFxn5oWDUvp"
Content-Disposition: inline
In-Reply-To: <a2266217-c3ad-4bb2-8188-498a2c8ae36c@infradead.org>


--0nWDRmFxn5oWDUvp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024 at 07:56:16AM -0700, Randy Dunlap wrote:
>=20
> On 4/15/24 5:11 AM, Bagas Sanjaya wrote:
> > The doc LGTM, thanks!
> >=20
> > Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
>=20
> Hi,
> Please see netiquette, section "Trim replies".
> Thanks.
>=20
>=20
> --=20
> #Randy
> https://people.kernel.org/tglx/notes-about-netiquette
> https://subspace.kernel.org/etiquette.html

Thanks for the tip!

--=20
An old man doll... just what I always wanted! - Clara

--0nWDRmFxn5oWDUvp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZh+e6wAKCRD2uYlJVVFO
o4TXAPwN11FytsnDX/+gFpUvWYFc3CxPaaA7sJCuHF5qVYQtGAEA6GP0hs+AljG4
tOsfo209C7he+IJJJUnxDpScnZoh/wc=
=jvcJ
-----END PGP SIGNATURE-----

--0nWDRmFxn5oWDUvp--

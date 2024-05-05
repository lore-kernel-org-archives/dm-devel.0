Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C30197;
	Sun,  5 May 2024 00:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714868127; cv=none; b=UKfEUqhfPDDa1c+gm6WspE0at0AKpNFxw+XDMFmJe/GCxgR1m22ZCX9/h/ktITOlNV8boYHZ5JXbHOCEWSOAbPvSx3hqOAIPoSdbRyHkK3GAa6N/C66anzOefcWoDCBcG+vw0dAmU4a0SI0GLwx/c8OMR7uffv7q9stoelNB2ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714868127; c=relaxed/simple;
	bh=Us12kLS2/JZzE9OjnNQSSWjgW41q/1qK+0tYJ109430=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ml0hN+F7hmY0dNB/qbNqRkGeHmGPxrW8wMuXHeQscMMNyhFqD90g0vR+2iPWLhndWK5vwcJT0ehR+4hfl5GoAXoC2SrSP0iMtOK8BQ708bZg1VlthA9DRagEgyX7MUQyNDkktPZxkRw1+9l5muLDXIFdu9ctmik7ejMSnvkF96I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AiBb9jnn; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AiBb9jnn"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1ec486198b6so6673685ad.1;
        Sat, 04 May 2024 17:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714868125; x=1715472925; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wgS8JoAt6F27d1bbCvSCcX4fIE1TnZzCg1FmdDqGcZI=;
        b=AiBb9jnnOV8ccKeIGtW3v5uskVKc1Ll4vfHtLPyBtfGfOGwkIrrajZtYLKUUk0RCtV
         udHZHSKX+AyX4cEdzAr5gKiluniF816AxT9f+soXo0Szq44R+rr8PpCR7CQ5ES8FcwSi
         l+EBTjVSWU69w8bH2r6tBQ5BTZqsvRxif9vDl+QD1GrhsERFf4JYTKIVpN7WBUTjd+VH
         D1qLV2m5bVO3dhdR34C8O7Y0NfdI9HRClhMP9kRotYk6OYlxTZucwYiLL4mOIb8Dplh9
         Y74aq3UjJuYKTAmoWWuxwPQCOdqhXqUFlrtEPYGEiUJMKbumq9vnX20e673g5x7dzgeV
         Qp8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714868125; x=1715472925;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wgS8JoAt6F27d1bbCvSCcX4fIE1TnZzCg1FmdDqGcZI=;
        b=ZVvCYFQGxGHbx+3jeh+m1R7bCAgA/F3tIGHVrfsoI463JFHrIvLYq04Ng0jUk8G1ty
         FFoFs3Ib6LL7giAhPE2rlSoAf7LBq84HixEIAAPZ5tcs25N8GK8NhW/L66KWXZx4Urrk
         msM7w9d2yK9K29xTAQ6PcufNw1hTXlvgO0LoV1gnJhd5BCPjKBZG5BmeIhSvpfDi2M+A
         cjbZaAxyrsdMT4WQNAZ54SJrO4R/iNSuxqNbdYSGTtTvTn3YoqhXqJnO0jAHtMXjcrel
         2SLXjfCqn/Zjt0EyDu7ynzI+MJlJOnRIM2XHhw3J9y/k8xPITU8kCcohInx/OMx3jv21
         5/Gw==
X-Forwarded-Encrypted: i=1; AJvYcCXk8fE0pw01ZINozEfQp6G2P0AdHWufe6EJBeOsCm+BYe77b2oCY2wf9+9JDYzp1CubpJKFafyvEQEAgNdF7DTQ+b+AJxrifSTqh4lXPEujMn5te4bUKG2OxcQzZSoH9E3x4g==
X-Gm-Message-State: AOJu0YxW93p+thBzwF2i4XaNKzyQyQZSFj02ngezcR0lHmhjZrgyafd+
	mjx5riFdJdYoRzj/SXFwGGIh/jhKJgEgQlo2wg9m/oRfzGd9OUp+
X-Google-Smtp-Source: AGHT+IEuepOKmbUX0nP6tkkmgH/wJcdmWEBFxatponT+7JHJdiSXjE9CQIyDOyyrEvUleV3UtJK/YA==
X-Received: by 2002:a17:903:2403:b0:1e5:8175:4968 with SMTP id e3-20020a170903240300b001e581754968mr5632206plo.9.1714868124735;
        Sat, 04 May 2024 17:15:24 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id ld14-20020a170902face00b001e0c568ae8fsm5583101plb.192.2024.05.04.17.15.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 17:15:24 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 133A9184947D8; Sun, 05 May 2024 07:15:18 +0700 (WIB)
Date: Sun, 5 May 2024 07:15:18 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
	jmorris@namei.org, serge@hallyn.com, tytso@mit.edu,
	ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com,
	snitzer@kernel.org, eparis@redhat.com, paul@paul-moore.com
Cc: linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org, fsverity@lists.linux.dev,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	audit@vger.kernel.org, linux-kernel@vger.kernel.org,
	Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [PATCH v18 20/21] Documentation: add ipe documentation
Message-ID: <ZjbPlk8ZwFZwdqJJ@archie.me>
References: <1714775551-22384-1-git-send-email-wufan@linux.microsoft.com>
 <1714775551-22384-21-git-send-email-wufan@linux.microsoft.com>
 <ZjXsBjAFs-qp9xY4@archie.me>
 <ab7054cd-affd-47c3-bd98-2cf47d6a6376@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="InlbHezzGTuEcuIT"
Content-Disposition: inline
In-Reply-To: <ab7054cd-affd-47c3-bd98-2cf47d6a6376@linux.microsoft.com>


--InlbHezzGTuEcuIT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 04, 2024 at 01:13:16PM -0700, Fan Wu wrote:
>=20
>=20
> On 5/4/2024 1:04 AM, Bagas Sanjaya wrote:
> > On Fri, May 03, 2024 at 03:32:30PM -0700, Fan Wu wrote:
> > > +IPE does not mitigate threats arising from malicious but authorized
> > > +developers (with access to a signing certificate), or compromised
> > > +developer tools used by them (i.e. return-oriented programming attac=
ks).
> > > +Additionally, IPE draws hard security boundary between userspace and
> > > +kernelspace. As a result, IPE does not provide any protections again=
st a
> > > +kernel level exploit, and a kernel-level exploit can disable or tamp=
er
> > > +with IPE's protections.
> >=20
> > So how to mitigate kernel-level exploits then?
> >=20
> One possible way is to use hypervisor to protect the kernel integrity.
> https://github.com/heki-linux is one project on this direction. Perhaps I
> should also add this link to the doc.

OK.

>=20
> > > +Allow only initramfs
> > > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > <snipped>...
> > > +Allow any signed and validated dm-verity volume and the initramfs
> > > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > <snipped>...
> >=20
> > htmldocs build reports new warnings:
> >=20
> > Documentation/admin-guide/LSM/ipe.rst:694: WARNING: Title underline too=
 short.
> >=20
> > Allow any signed and validated dm-verity volume and the initramfs
> > ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > Documentation/admin-guide/LSM/ipe.rst:694: WARNING: Title underline too=
 short.
> >=20
> > Allow any signed and validated dm-verity volume and the initramfs
> > ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > Documentation/arch/x86/resctrl.rst:577: WARNING: Title underline too sh=
ort.
> >=20
> > I have to match these sections underline length:
> >=20
> > ---- >8 ----
> > diff --git a/Documentation/admin-guide/LSM/ipe.rst b/Documentation/admi=
n-guide/LSM/ipe.rst
> > index 1a3bf1d8aa23f0..a47e14e024a90d 100644
> > --- a/Documentation/admin-guide/LSM/ipe.rst
> > +++ b/Documentation/admin-guide/LSM/ipe.rst
> > @@ -681,7 +681,7 @@ Allow all
> >      DEFAULT action=3DALLOW
> >   Allow only initramfs
> > -~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +~~~~~~~~~~~~~~~~~~~~
> >   ::
> > @@ -691,7 +691,7 @@ Allow only initramfs
> >      op=3DEXECUTE boot_verified=3DTRUE action=3DALLOW
> >   Allow any signed and validated dm-verity volume and the initramfs
> > -~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >   ::
> > @@ -725,7 +725,7 @@ Allow only a specific dm-verity volume
> >      op=3DEXECUTE dmverity_roothash=3Dsha256:401fcec5944823ae12f62726e8=
184407a5fa9599783f030dec146938 action=3DALLOW
> >   Allow any fs-verity file with a valid built-in signature
> > -~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >   ::
> > @@ -735,7 +735,7 @@ Allow any fs-verity file with a valid built-in sign=
ature
> >      op=3DEXECUTE fsverity_signature=3DTRUE action=3DALLOW
> >   Allow execution of a specific fs-verity file
> > -~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >   ::
> >=20
> > > +Additional Information
> > > +----------------------
> > > +
> > > +- `Github Repository <https://github.com/microsoft/ipe>`_
> > > +- Documentation/security/ipe.rst
> >=20
> > Link title to both this admin-side and developer docs can be added for
> > disambiguation (to avoid confusion on readers):
> >=20
> > ---- >8 ----
> > diff --git a/Documentation/admin-guide/LSM/ipe.rst b/Documentation/admi=
n-guide/LSM/ipe.rst
> > index a47e14e024a90d..25b17e11559149 100644
> > --- a/Documentation/admin-guide/LSM/ipe.rst
> > +++ b/Documentation/admin-guide/LSM/ipe.rst
> > @@ -7,7 +7,8 @@ Integrity Policy Enforcement (IPE)
> >      This is the documentation for admins, system builders, or individu=
als
> >      attempting to use IPE. If you're looking for more developer-focused
> > -   documentation about IPE please see Documentation/security/ipe.rst
> > +   documentation about IPE please see :doc:`the design docs
> > +   </security/ipe>`.
> >   Overview
> >   --------
> > @@ -748,7 +749,7 @@ Additional Information
> >   ----------------------
> >   - `Github Repository <https://github.com/microsoft/ipe>`_
> > -- Documentation/security/ipe.rst
> > +- :doc:`Developer and design docs for IPE </security/ipe>`
> >   FAQ
> >   ---
> > diff --git a/Documentation/security/ipe.rst b/Documentation/security/ip=
e.rst
> > index 07e3632241285d..fd1b1a852d2165 100644
> > --- a/Documentation/security/ipe.rst
> > +++ b/Documentation/security/ipe.rst
> > @@ -7,7 +7,7 @@ Integrity Policy Enforcement (IPE) - Kernel Documentati=
on
> >      This is documentation targeted at developers, instead of administr=
ators.
> >      If you're looking for documentation on the usage of IPE, please see
> > -   Documentation/admin-guide/LSM/ipe.rst
> > +   `IPE admin guide </admin-guide/LSM/ipe.rst>`_.
> >   Historical Motivation
> >   ---------------------
> >=20
> > Thanks.
> >=20
>=20
> My apologies for these format issues and thanks for the suggestions. I wi=
ll
> fix them.

Oh, I forgot to also add :doc: directive for the last reference link:

---- >8 ----
diff --git a/Documentation/security/ipe.rst b/Documentation/security/ipe.rst
index fd1b1a852d2165..aa2e64d4119f3e 100644
--- a/Documentation/security/ipe.rst
+++ b/Documentation/security/ipe.rst
@@ -7,7 +7,7 @@ Integrity Policy Enforcement (IPE) - Kernel Documentation
=20
    This is documentation targeted at developers, instead of administrators.
    If you're looking for documentation on the usage of IPE, please see
-   `IPE admin guide </admin-guide/LSM/ipe.rst>`_.
+   :doc:`IPE admin guide </admin-guide/LSM/ipe>`.
=20
 Historical Motivation
 ---------------------

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--InlbHezzGTuEcuIT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZjbPjgAKCRD2uYlJVVFO
o8HPAQDxhozqHxPAtlb/vByqFj4O4DT+qZVm5PvJcv9tnq0aCQD7BQbQr6wEPrYZ
0lIMQIcpVMj+XdMBtixikEDTadIDHQI=
=mp4a
-----END PGP SIGNATURE-----

--InlbHezzGTuEcuIT--

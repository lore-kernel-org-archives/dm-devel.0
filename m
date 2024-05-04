Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA9ADF5B;
	Sat,  4 May 2024 08:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714809868; cv=none; b=QTJk0BfcZTKJH1TLbkVT0DFQjpqhnFNXNdW6NdO6ukVkV2v4hkvVPZHX55xIetg2Frxe6K2enaKVGpE9g/b5GorD4nWAcp7AE4TtBwRRr15B49z6O7/+qQ+f8j2E1w6BcnoFp+N9q5zCjJLcJfuaKE67py/9jaCzzmhwjaY0IxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714809868; c=relaxed/simple;
	bh=0hjZIw2e2IuhjYNugxhXSXZpWs5mVXjcsoZo1BqocAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YfEJeBRC7V+qSDjqxNplOZZZLPFi2G8IROgCQOG+HMoPfs48lmWUEzNFtiyS4ZvrMT/JRY+M/FXRmbWyNN8KFP+ck55xZ+FyyKKqn4dHNvN+CZ4b8YZ4bJnjnnRnaSPxpkyfbPjg2xiJiSRTgbqyJt9wIkv0VkKke6hConb6DgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cYi8Q4tb; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cYi8Q4tb"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6ed3cafd766so391270b3a.0;
        Sat, 04 May 2024 01:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714809866; x=1715414666; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Lj67rtK1QueWPk7ARNpfvxl9vOgAVWGxhUJDN/QBK8=;
        b=cYi8Q4tbeOm4UtdVqThudGK9WvsQpu5azFkQRITMxzeOShrN8HYpqRRT8anl2PMEiM
         wYxbU3sObG4Z3uqWC2Bs3QoXk69kiS71u/94CTCcLaptDaeRHy+lwsqe32r3TN+/vQVO
         vx8TsqwqM6Omg/DoMl+dUJbNWgisTkMgGkS5h+5SaAZGzxhiWcvRJnL1BS/vLUqJoNVz
         KjAPKOYq63RhewTUozqZ5CPollmOE7tEnl2TaPMaT2Or3iAl4sxGqoQkRgErZ3q9XQIs
         psOl+t24NZPDxXYegPzJgYZebc+nINUQ0qRhs+ssqEL1MhOF1Q3idOCSpWWhgcIn33GF
         X3cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714809866; x=1715414666;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Lj67rtK1QueWPk7ARNpfvxl9vOgAVWGxhUJDN/QBK8=;
        b=tknOw9YRzIYhg6DGb+K2kEy5G2trCH8Di/5SQ5dkCgx4hdmYGDwOkjJdxgHkC6W/DQ
         NX2X4LYM3grl6q4v57hM/p8xhZRCd9VhHkfuXnEw27iYHk0oj36lli3IpSl9eUVH/aB2
         EqMDQft1fFyE4SjPl98Uo/g+wqwKpO7W34CqbSldCd3f3812qt4BZqe2Gn3dapzuhdCh
         lCF3a0LkGVm/Pd7Kp0qt/3Kt0ciH7RB58SBq61VLQPUiodWVrhicCO3tWPyKFNTPWhSi
         hToVkWUXg0tZ/F0kEW0vHsPMQJrzIet14WbX6cSw0sHvVHTlnEIScLF9xDtIOT5jiiAQ
         iyug==
X-Forwarded-Encrypted: i=1; AJvYcCXmlGtmfhL5zao1s6zcIEGsA1en8bv9qFVs2dZNYMrG90j5NTxwR3ehzfZZt+a08xCutCU0EJN8I6dsKOwnDaLk7f32wwH2TA7h0qNFgxNMUu96BWIY0JMMY8CifWboia8GnQ==
X-Gm-Message-State: AOJu0Yx1jFKOTWcEty2dJHdLiHAmLTRi71CUQgjCZRNwlsKCqRJMw8o1
	Wl+XWlBXFHlKVkr2m1vRpr5eg0eX+ABferRWq7obuuBybbroCZg1
X-Google-Smtp-Source: AGHT+IG0qZqH9zc005lWKjgxwZgqZm5TyMRd8CrRzXUZbRqngw1NpFuolrIDkh7YQEN+G1GdDh8Ciw==
X-Received: by 2002:a05:6a00:a81:b0:6f3:e9bc:7ed3 with SMTP id b1-20020a056a000a8100b006f3e9bc7ed3mr5704824pfl.17.1714809866257;
        Sat, 04 May 2024 01:04:26 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id bn12-20020a056a00324c00b006edd05e3751sm4356202pfb.176.2024.05.04.01.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 01:04:25 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 8A4001847D504; Sat, 04 May 2024 15:04:22 +0700 (WIB)
Date: Sat, 4 May 2024 15:04:22 +0700
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
Message-ID: <ZjXsBjAFs-qp9xY4@archie.me>
References: <1714775551-22384-1-git-send-email-wufan@linux.microsoft.com>
 <1714775551-22384-21-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nK/4++6p9aVBG6jQ"
Content-Disposition: inline
In-Reply-To: <1714775551-22384-21-git-send-email-wufan@linux.microsoft.com>


--nK/4++6p9aVBG6jQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 03, 2024 at 03:32:30PM -0700, Fan Wu wrote:
> +IPE does not mitigate threats arising from malicious but authorized
> +developers (with access to a signing certificate), or compromised
> +developer tools used by them (i.e. return-oriented programming attacks).
> +Additionally, IPE draws hard security boundary between userspace and
> +kernelspace. As a result, IPE does not provide any protections against a
> +kernel level exploit, and a kernel-level exploit can disable or tamper
> +with IPE's protections.

So how to mitigate kernel-level exploits then?

> +Allow only initramfs
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> <snipped>...
> +Allow any signed and validated dm-verity volume and the initramfs
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> <snipped>...

htmldocs build reports new warnings:

Documentation/admin-guide/LSM/ipe.rst:694: WARNING: Title underline too sho=
rt.

Allow any signed and validated dm-verity volume and the initramfs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Documentation/admin-guide/LSM/ipe.rst:694: WARNING: Title underline too sho=
rt.

Allow any signed and validated dm-verity volume and the initramfs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Documentation/arch/x86/resctrl.rst:577: WARNING: Title underline too short.

I have to match these sections underline length:

---- >8 ----
diff --git a/Documentation/admin-guide/LSM/ipe.rst b/Documentation/admin-gu=
ide/LSM/ipe.rst
index 1a3bf1d8aa23f0..a47e14e024a90d 100644
--- a/Documentation/admin-guide/LSM/ipe.rst
+++ b/Documentation/admin-guide/LSM/ipe.rst
@@ -681,7 +681,7 @@ Allow all
    DEFAULT action=3DALLOW
=20
 Allow only initramfs
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+~~~~~~~~~~~~~~~~~~~~
=20
 ::
=20
@@ -691,7 +691,7 @@ Allow only initramfs
    op=3DEXECUTE boot_verified=3DTRUE action=3DALLOW
=20
 Allow any signed and validated dm-verity volume and the initramfs
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=20
 ::
=20
@@ -725,7 +725,7 @@ Allow only a specific dm-verity volume
    op=3DEXECUTE dmverity_roothash=3Dsha256:401fcec5944823ae12f62726e818440=
7a5fa9599783f030dec146938 action=3DALLOW
=20
 Allow any fs-verity file with a valid built-in signature
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=20
 ::
=20
@@ -735,7 +735,7 @@ Allow any fs-verity file with a valid built-in signature
    op=3DEXECUTE fsverity_signature=3DTRUE action=3DALLOW
=20
 Allow execution of a specific fs-verity file
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=20
 ::
=20

> +Additional Information
> +----------------------
> +
> +- `Github Repository <https://github.com/microsoft/ipe>`_
> +- Documentation/security/ipe.rst

Link title to both this admin-side and developer docs can be added for
disambiguation (to avoid confusion on readers):

---- >8 ----
diff --git a/Documentation/admin-guide/LSM/ipe.rst b/Documentation/admin-gu=
ide/LSM/ipe.rst
index a47e14e024a90d..25b17e11559149 100644
--- a/Documentation/admin-guide/LSM/ipe.rst
+++ b/Documentation/admin-guide/LSM/ipe.rst
@@ -7,7 +7,8 @@ Integrity Policy Enforcement (IPE)
=20
    This is the documentation for admins, system builders, or individuals
    attempting to use IPE. If you're looking for more developer-focused
-   documentation about IPE please see Documentation/security/ipe.rst
+   documentation about IPE please see :doc:`the design docs
+   </security/ipe>`.
=20
 Overview
 --------
@@ -748,7 +749,7 @@ Additional Information
 ----------------------
=20
 - `Github Repository <https://github.com/microsoft/ipe>`_
-- Documentation/security/ipe.rst
+- :doc:`Developer and design docs for IPE </security/ipe>`
=20
 FAQ
 ---
diff --git a/Documentation/security/ipe.rst b/Documentation/security/ipe.rst
index 07e3632241285d..fd1b1a852d2165 100644
--- a/Documentation/security/ipe.rst
+++ b/Documentation/security/ipe.rst
@@ -7,7 +7,7 @@ Integrity Policy Enforcement (IPE) - Kernel Documentation
=20
    This is documentation targeted at developers, instead of administrators.
    If you're looking for documentation on the usage of IPE, please see
-   Documentation/admin-guide/LSM/ipe.rst
+   `IPE admin guide </admin-guide/LSM/ipe.rst>`_.
=20
 Historical Motivation
 ---------------------

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--nK/4++6p9aVBG6jQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZjXsAgAKCRD2uYlJVVFO
o5rXAQCS3HwJg98sIZ+dvHD4EtrdQXP2AZQEC3nP+kq7cOi47wD+P0ZrOINzS3p5
azRTQTXUkE+0lznZFyE75YeW2OX1dQs=
=ebwU
-----END PGP SIGNATURE-----

--nK/4++6p9aVBG6jQ--

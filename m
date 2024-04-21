Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B731843
	for <dm-devel@lists.linux.dev>; Sun, 21 Apr 2024 01:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713662433; cv=none; b=ftmotisVjMj9kJdVYx9jXfPhjApw+QV3Nf8hJXR+BbAdTVKv1yd3tVl+crXcpVlINQJQdG4/LhydBgiZCcgAhLbA/KoTY2yZUfG25cOQthoub++Cl/0FKlkRpBHKOHYEO6ikBVhfhnla8UoT5OaPW1aiZjlhvwcQvbzjU7ZFWQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713662433; c=relaxed/simple;
	bh=umUN52MAHLhx2zWn+c/A/RFRkUo9ct1QnOMPoMHdu4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g0fMj3XFK2Vkzsh04zWvk1qMsJoT4cYyghh+Gk33a2PEQvq4oZpvGpA0oOfV7s6WWZ34MuTohSxZ0GGUz3aBUq8/JU390jtyWJaXHFVAySnOhT6Z8mqnFTQPm9w0vTrnpdREpohhMI4pa1B7UaGgfwAyzq6kJudEcTuoyUpyk/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
From: "Andreas K. Huettel" <dilfridge@gentoo.org>
To: libc-alpha@sourceware.org
Cc: Zdenek Kabelac <zkabelac@redhat.com>, Ondrej Kozina <okozina@redhat.com>,
 Milan Broz <gmazyland@gmail.com>, dm-devel@lists.linux.dev,
 Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: memcpy is leaking secret data through ZMM vector registers
Date: Sun, 21 Apr 2024 12:20:20 +1100
Message-ID: <4900476.GXAFRqVoOG@noumea>
Organization: Gentoo Linux
In-Reply-To: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com>
References: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1899325.tdWV9SEqCh";
 micalg="pgp-sha256"; protocol="application/pgp-signature"

--nextPart1899325.tdWV9SEqCh
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; protected-headers="v1"
From: "Andreas K. Huettel" <dilfridge@gentoo.org>
To: libc-alpha@sourceware.org
Date: Sun, 21 Apr 2024 12:20:20 +1100
Message-ID: <4900476.GXAFRqVoOG@noumea>
Organization: Gentoo Linux
In-Reply-To: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com>
References: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com>
MIME-Version: 1.0

> We have a test "dmsecuretest.sh" that loads cryptographic keys into the=20
> kernel, dumps a core, the core file is analyzed and if it contains the=20
> key, the test fails.
>=20
> This test fails on AMD Zen 4 - the reason for the failure is that the=20
> "memcpy" function uses ZMM registers for data copying. When memcpy exits,=
=20
> the encryption key is present in the ZMM registers and the key remains=20
> there even after both source and destination buffers of memcpy were=20
> cleared.
>=20
> When we perform dynamic symbol lookup, the ZMM registers are spilled on=20
> the stack and they remain there forever - this is the reason why the core=
=20
> file contains the encryption key and the test fails.

So let me ask a few obvious questions, as someone with not (yet) deep
insights into the problem.

* Shouldn't this be treated as a security issue?

* Are the expectations on where the (key) data may end up defined=20
  somewhere?

* If yes, which component behaves faulty?

* If no, who needs to be involved in making the specs?


=2D-=20
Andreas K. H=FCttel
dilfridge@gentoo.org
Gentoo Linux developer=20
(council, comrel, toolchain, base-system, perl, libreoffice)
https://wiki.gentoo.org/wiki/User:Dilfridge
--nextPart1899325.tdWV9SEqCh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE/Rnm0xsZLuTcY+rT3CsWIV7VQSoFAmYkadQACgkQ3CsWIV7V
QSopUBAAgUklOXkgwbUZbNn1PqxeWR3xT9iLTPim3cHscv40WYW7Z9rEYsWmv3UL
AOqdAChBOWfqFYe2J6mNJDsC78iWGndvITBrssfAJ/5cUsGjaAz1mdgY5t1RZcye
5Q1wt/58N7vLl0Bnf0JA1ZhXJYKTq+8WaeyZdGk5Vwu8erm9lLw0AKGo9lHpBQ21
XTSDa3Nj93f0X/2Mo8MSgfY8QDIoQsZsCIV9+gBmqgIU0le4xNmJHmwEWAxrufjY
tNPhwMYXY/oRNaIkCcJGb80YSR6IFUXq0uPfoCSDyw1urU2Y0JP+bhqNNbBPFWC1
xIH4TtANHsXZiW6mDQlpF1AFX1XhInCkW/+iOUUq4nIsVRB0gLM7cK/Z832cpNvS
iddYB5j3bsgOA8IGmp/7iwcO1Sxv8X8CnMfCHepMiM3RWytzj1r7lJk9OJoY1v6d
wJJibcWwOy0Gv0f6HRnGnHQOMnMkgmyAWLtLgOPMvfm/QP0ZXeKac/xsMoxZoo1T
Bc1nHq+HGFYR0nA8zPD1EkWqnLV1RqLVUo0jl8Cj+onLkKY/AjQNzQ87lb68aMfR
QzMxh+b50xJoItcfiiu//DbXSXLksoiW73GMlVYo4VWBlu/79kcCXduejYAF89Ko
lyJLDpua9iyhI+WrKzf2fPPRKyEnaWzzSP5PL3QaAwCNjX1V2Fo=
=0XOU
-----END PGP SIGNATURE-----

--nextPart1899325.tdWV9SEqCh--




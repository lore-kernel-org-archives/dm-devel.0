Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DEB21345
	for <dm-devel@lists.linux.dev>; Tue, 13 Aug 2024 11:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.165.51.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723547380; cv=none; b=O+Ysozbv78JDjEvs13fDAlVrACSMCH432B5R5DPYTgTzHG1MMCKNi+dSzSEHa8Nit2EYD/GAiPvhgpOCRPpBXPXssNIFBq77CK3CO3/kvVcyRoEsfTrr4TOpCYR7KQEGqeUWEZNubzPnbmbIs4KQG8loMoFTXEJzQwhdzBtz2mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723547380; c=relaxed/simple;
	bh=aWQPGVIfY/cQJYKqMgu5mX2z9Z1udEnsCPiYHPR2dBU=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=GYFYSI5l9YZLL1xkF4YCrsa7GhtvqtlsqmaEi2O6LIkpChha/4XaAAhFdhU01Z0sPTCJtOJ0Cke8K0wbuc5pIkp+baRkeCdxLT4zmhM7+7Yd1k0Ox0TBJw4yGDrwc87zlDzG4MYu7LqqLEtQb10fH+GC7UNOsdmEd0RAC6mJcdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=g8vlBcrb; arc=none smtp.client-ip=188.165.51.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="g8vlBcrb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1723547365; x=1723806565;
	bh=aWQPGVIfY/cQJYKqMgu5mX2z9Z1udEnsCPiYHPR2dBU=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=g8vlBcrboKDCNza/4l1y+yd7slJBLVwIB24ekBlt8Ko3MJ+GpfZrMmY2gBTeT1H8r
	 iA9s7iVJ5RXVcbBndirg0RZywrNiQ+rwOEl+Z5hzGwkKxUICxreK+qs6ArkP7ralGd
	 uAvmS4jQm3PzZhkbEtbuLoBBfMeJKuIX5cCeLH7T9FCSYbxTYl/zxgSqoXaQ1AQ5GB
	 qL1ox2jyarFbZeQBiwqBvuVu1/UrXkN8BPiB5YGvKFm90HeibMAmK5jeQNkVHsKShy
	 CWfM/jj/Z41HgOBStlOymtCX6PpLAUxi2kw2+qdYQhMr0/GauUJLxkD1VK32kzr/1Y
	 EpPg10K0GwgvQ==
Date: Tue, 13 Aug 2024 11:09:22 +0000
To: "mwilck@suse.com" <mwilck@suse.com>, "bmarzins@redhat.com" <bmarzins@redhat.com>, "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
From: spybull <spybull@proton.me>
Subject: [PATCH] removed duplicate check for subsection devices
Message-ID: <TI8T_ijNQUzUt4vhmNUqgakWd1LJaKYxVmnFUF2dQs-DdTfLLEbaETdLQv3RjX8ur6T73gxM_arDIAiqD_bPoT01rfmxJ3d7UmHUj-aYyAs=@proton.me>
Feedback-ID: 99450113:user:proton
X-Pm-Message-ID: 52454f4ef299f9ad30ff0fd11929e20d36e5d462
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello all

From cd1c6223f05cd3f34b66fe6239d60e7bc3a5a428 Mon Sep 17 00:00:00 2001
From: Babich Vladimir <spybull@proton.me>
Date: Tue, 13 Aug 2024 12:49:05 +0300
Subject: [PATCH] removed duplicate check for subsection devices

---
=C2=A0libmpathutil/parser.c | 3 +--
=C2=A01 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/libmpathutil/parser.c b/libmpathutil/parser.c
index 29b212ce..b44bc301 100644
--- a/libmpathutil/parser.c
+++ b/libmpathutil/parser.c
@@ -406,8 +406,7 @@ int
=C2=A0is_sublevel_keyword(char *str)
=C2=A0{
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return (strcmp(str, "defaults") =3D=3D 0 =C2=
=A0strcmp(str, "blacklist") =3D=3D 0
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 strcmp(str, "blacklist_e=
xceptions") =3D=3D 0
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 strcmp(str, "devices") =
=3D=3D 0 =C2=A0strcmp(str, "devices") =3D=3D 0
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 strcmp(str, "blacklist_e=
xceptions") =3D=3D 0 =C2=A0strcmp(str, "devices") =3D=3D 0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 strcmp(str, "device=
") =3D=3D 0 =C2=A0strcmp(str, "multipaths") =3D=3D 0 ||
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 strcmp(str, "multip=
ath") =3D=3D 0);
=C2=A0}
--=20
2.44.2

redundant double-checking of the devices subsection
https://github.com/opensvc/multipath-tools/pull/93

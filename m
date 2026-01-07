Received: from mail-43167.protonmail.ch (mail-43167.protonmail.ch [185.70.43.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE3930CD85
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 12:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767787809; cv=none; b=GOhjd0F6Cg4DByqCPu/LL8kpd1T7tZ/NxtQ6Fvc45TNY5v/MlbdNCHXE1Ni51TeDzsjCb1UwWAWij3Mfgx9Y3+2JfH/DaZpOh5REHyKxL/ONENIPMX9rZrP6wqtK1vZt8G4BL4jPBhL0vfsByiU5hzjQCtUXO45l3+Uzbhmakzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767787809; c=relaxed/simple;
	bh=HUfHooCdCr5i0FPOY6ZrqJiaC8QV+8vrWd/cfAGGbnk=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=m1fERSlM5oMo+d3mvr492Z2PnD7gsJi+7anIPIAza/C7vcB0D8mPPt1dv6cB/9oA/hVBrb3pM3FHGKG8rZAQ0Ds4h+oykVykPDfpA8kT5qVvIeQqYJkQsnBmWt2DfkXtb5bcbAh6YMdEd9kGRldIrU6MZvMr6eE3lGrHDfBfFrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=OHOEPAKC; arc=none smtp.client-ip=185.70.43.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="OHOEPAKC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1767787794; x=1768046994;
	bh=HUfHooCdCr5i0FPOY6ZrqJiaC8QV+8vrWd/cfAGGbnk=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=OHOEPAKCRqJ4dMPp4cZTFUKA94VPp9q/p+H5KDodYs2xeEvq/oG9Lccm9JjVtJzAY
	 wMG8sLiLzX5mFGb47zqbVvG4U3NS/72jiSZK9jOaguMAqiHTZnpPS6yr01E0cTz/MS
	 syg1hBPQwZr4wECSfU/NHlyQt20I6X4G3rHBGqo1bb/94sIDBkChhWMgJw6l2dXfpB
	 RthsKMXp933/HGEzkD3KNku+Ad+YDhe6aXnbEHGTaNzkgx/dl6G1JzHZKWJxFQE80o
	 uQ16eOyD+FVfI2F5BvDL1J/oPP+334c8Rc3W6StJHfEwXpLdGT60rnOQGNeBJFgmBD
	 Bx//YuFsBtQXw==
Date: Wed, 07 Jan 2026 12:09:51 +0000
To: dm-devel@lists.linux.dev
From: Michal Rostecki <vad.sol@proton.me>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>, Michal Rostecki <vad.sol@proton.me>
Subject: [PATCH] libmultipath: Remove the undefined symbol from the linker script
Message-ID: <20260107120938.28215-2-vad.sol@proton.me>
Feedback-ID: 154827606:user:proton
X-Pm-Message-ID: 401f1e2eda6e3ad446ce1be468cd9f7b7e35e6f4
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

dm_get_multipath() is a static function, not a symbol that can be
exported. Clang is strict about not allowing undefined symbols in linker
scripts and therefore its presence prevents clang from building
libmultipath.

Fixes: https://github.com/opensvc/multipath-tools/issues/132
Fixes: bf3a4ad ("libmultipath: simplify dm_get_maps()")
Signed-off-by: Michal Rostecki <vad.sol@proton.me>
---
 libmultipath/libmultipath.version | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.=
version
index 89ae2a3c..5017a54d 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -85,7 +85,6 @@ global:
 =09dm_geteventnr;
 =09dm_get_major_minor;
 =09dm_get_maps;
-=09dm_get_multipath;
 =09dm_is_mpath;
 =09dm_mapname;
 =09dm_prereq;
--=20
2.52.0



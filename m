Received: from mail-4317.proton.ch (mail-4317.proton.ch [185.70.43.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D06E15383B
	for <dm-devel@lists.linux.dev>; Tue, 24 Dec 2024 22:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735078416; cv=none; b=eokinBH90SYCsAt+KLhrPNHj0sjXuyZgA3VAp43bKYIXMhC1NbdnuOj67MAAnxFCj1i2Vo23aqSLnK/YmSYE519QlVyO3FEtPlAIUn8FGROAtsHc99AyKdzr4O3An8/8DttDt+/GsJVyr8z9nqGt7ZOP0fUucyrojykH/THvwM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735078416; c=relaxed/simple;
	bh=xcsYzwkfoJw/YDrO0iTnx/T1E4z0B7tmt4VgVKC6+/c=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=j5H5JDA2SOYdIrmGP861bPI6pzzu4I5XZ1IctNsU43GWd3C+N88ax7jDXGR8Vt1L8kfWZNLrgZ9HdpUYfo0IEph+PxIXDT+ru6QvHBN7pNNXWlHbogmw6Tt7VhKSMoklN7eJUzOOMXujncfcOAUrA/snoVJcPN0G1VQDSYYcb84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ethancedwards.com; spf=pass smtp.mailfrom=ethancedwards.com; dkim=pass (2048-bit key) header.d=ethancedwards.com header.i=@ethancedwards.com header.b=g28Ue7yO; arc=none smtp.client-ip=185.70.43.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ethancedwards.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ethancedwards.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ethancedwards.com header.i=@ethancedwards.com header.b="g28Ue7yO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ethancedwards.com;
	s=protonmail3; t=1735078405; x=1735337605;
	bh=s8tMHzHmmJ+SEcYAfDqFaGKe7WAZQZkom1vhjssxqCQ=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector:
	 List-Unsubscribe:List-Unsubscribe-Post;
	b=g28Ue7yOjQ6O1kcuB8CWz0KBgP2K6zpLG0B477sgyMzxUOqKIPxfPYqtu9begsRmg
	 4ePlIlZ5EcqlxNl3swuVONFkjxzbhUZoRL6+2tFh+JqZLJTkg6bYzBEIE8b5qjHFts
	 MhkqI4iCUmUYBAaZf1ljmRMLyAF5DUS0x+FGbm+eYoX+y5SvSofpwxXzLD+2Sqv9Qr
	 8ADd3NUbxgwi3ZpvyUE9I6Y7viRQ9w+mFzD7GVkJdQBYLTdzzjdp4KZ5rcdaX/lV3/
	 EEcVcR81nCkPhu+ukXTZUFmDRv4Y5DW8/ESj6ARmNVvwTVe6ErwnHGfj9ZErsq/R5V
	 ODtgGAMW/u0lw==
Date: Tue, 24 Dec 2024 22:13:21 +0000
To: "agk@redhat.com" <agk@redhat.com>
From: Ethan Carter Edwards <ethan@ethancedwards.com>
Cc: "snitzer@kernel.org" <snitzer@kernel.org>, "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>, "mpatocka@redhat.com" <mpatocka@redhat.com>
Subject: [PATCH] dm: change kzalloc to kcalloc
Message-ID: <Z7XWRfRi3Fn25wT4Dg19JRN4xrKcCt3TxaxZwsR_0LDR2C6fQxCiLrsMBfJg8f_ZqSAx3u6aPm-TR02dC6bLpMmqSI_jp_ADiJ_qW_27puk=@ethancedwards.com>
Feedback-ID: 28410670:user:proton
X-Pm-Message-ID: 1bd655178d25c363227416789bb2d5305d0fba03
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Use 2-factor multiplication argument form kcalloc() instead
of instead of the deprecated kzalloc() [1].

[1] https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded=
-arithmetic-in-allocator-arguments
Link: https://github.com/KSPP/linux/issues/162

Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
---
 drivers/md/dm-ps-io-affinity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-ps-io-affinity.c b/drivers/md/dm-ps-io-affinity.=
c
index 461ee6b2044d..716807e511ee 100644
--- a/drivers/md/dm-ps-io-affinity.c
+++ b/drivers/md/dm-ps-io-affinity.c
@@ -116,7 +116,7 @@ static int ioa_create(struct path_selector *ps, unsigne=
d int argc, char **argv)
 =09if (!s)
 =09=09return -ENOMEM;
=20
-=09s->path_map =3D kzalloc(nr_cpu_ids * sizeof(struct path_info *),
+=09s->path_map =3D kcalloc(nr_cpu_ids, sizeof(struct path_info *),
 =09=09=09     GFP_KERNEL);
 =09if (!s->path_map)
 =09=09goto free_selector;
--=20
2.47.1

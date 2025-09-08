Received: from ksmg01.maxima.ru (ksmg01.mt-integration.ru [81.200.124.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C2C2F0C51
	for <dm-devel@lists.linux.dev>; Mon,  8 Sep 2025 12:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.200.124.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757333338; cv=none; b=pnw9xfguVLWRGlyemuFq8rSq8i3rPuG1NHZUUPT6lg3rF1/gY3PWaZM/PyXrKSWpY+fvzZFfBKKOV3QryOKl2zDHI4bjs4dBTt0yoYDgBTdyu4SWiFBQtNXkpIf7IL9G+LYID5DWhmMqZhQHFQlAOoZgI+BtnSaKoP0VQQj+jZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757333338; c=relaxed/simple;
	bh=nVUvUQdiCXtG5ibnmAC/vLTjS1jrut8OfsMJ4tfoKYs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=k3oUTmlR6tNu9z/El38Qo+b6U8nAwKPWhmoVGSqMC2jONdkaA2+kSQukACilb2BwI/Y6F0NoPFPPgg/IK/y0gt1DPoEvEZvW+guKac6ZpX7V94M4ArwoElsJt54VG1W4dEkpumP/Zx5G7fQQOMvd1dwyoGB/OR8eWcGSDzXHYhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mt-integration.ru; spf=pass smtp.mailfrom=mt-integration.ru; dkim=pass (2048-bit key) header.d=mt-integration.ru header.i=@mt-integration.ru header.b=q3o8vem0; arc=none smtp.client-ip=81.200.124.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mt-integration.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mt-integration.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mt-integration.ru header.i=@mt-integration.ru header.b="q3o8vem0"
Received: from ksmg01.maxima.ru (localhost [127.0.0.1])
	by ksmg01.maxima.ru (Postfix) with ESMTP id D31B3C005F;
	Mon,  8 Sep 2025 15:08:46 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 ksmg01.maxima.ru D31B3C005F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mt-integration.ru;
	s=sl; t=1757333326; bh=8SmJvAYmvvbrFch8QBFs7KIWv71UMCJ8kcu7j7DFLXo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=q3o8vem0yxrJ7BGLT2zY8a3Cey+hGguoM2um3+Edvv/eFymwliJgx8ZL6vuv62S8P
	 3Hi/bNySfSfujvSJOPqY5O12PSHXful5jtf82IrIHBj7ASqrZP/W1OkZf2rClmfZ41
	 iIw7alwOZ9t9IkPjDfUFu9nPF6LHlnBeDWILd5Te74Sp374vfDCmB2L0QMIMJm/qGw
	 TvUngDrignnsMnWwhViGPkY6C7gQKflvXBfjBTBnFkVgsumcZ0NYEe/Jxak52Cetia
	 K76CEHOLQR1R8+DsN7wbnrZltAHTPNT1zjKIpG6eL+dlExIXgif29gOIO6udJ7qUGK
	 LglDQB0Il74Xw==
Received: from ksmg01.maxima.ru (autodiscover.maxima.ru [81.200.124.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client did not present a certificate)
	by ksmg01.maxima.ru (Postfix) with ESMTPS;
	Mon,  8 Sep 2025 15:08:46 +0300 (MSK)
Received: from db126-1-abramov-14-d-mosos.mti-lab.com (172.25.20.118) by
 mmail-p-exch01.mt.ru (81.200.124.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 8 Sep 2025 15:08:45 +0300
From: Ivan Abramov <i.abramov@mt-integration.ru>
To: Alasdair Kergon <agk@redhat.com>
CC: Ivan Abramov <i.abramov@mt-integration.ru>, Mike Snitzer
	<snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
	<dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<lvc-project@linuxtesting.org>
Subject: [PATCH 1/1] dm-integrity: Remove unreachable code in dm_integrity_ctr()
Date: Mon, 8 Sep 2025 15:08:31 +0300
Message-ID: <20250908120831.135419-1-i.abramov@mt-integration.ru>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mmail-p-exch02.mt.ru (81.200.124.62) To
 mmail-p-exch01.mt.ru (81.200.124.61)
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Auth: dmarc=none header.from=mt-integration.ru;spf=none smtp.mailfrom=mt-integration.ru;dkim=none
X-KSMG-AntiSpam-Envelope-From: i.abramov@mt-integration.ru
X-KSMG-AntiSpam-Info: LuaCore: 66 0.3.66 fc5dda3b6b70d34b3701db39319eece2aeb510fb, {rep_avail}, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, mt-integration.ru:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;ksmg01.maxima.ru:7.1.1;81.200.124.61:7.1.2, FromAlignment: s, ApMailHostAddress: 81.200.124.61
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 196094 [Sep 08 2025]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.11
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/09/08 08:44:00 #27799356
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 7

Since bi->metadata_size is an unsigned char, it's not practically
possible for it to be > PAGE_SIZE / 2.

Thus, remove the corresponding if statement.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
---
 drivers/md/dm-integrity.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index efeee0a873c0..b7ad7a5adb56 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4752,11 +4752,6 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 			ti->error = "The integrity profile is smaller than tag size";
 			goto bad;
 		}
-		if ((unsigned long)bi->metadata_size > PAGE_SIZE / 2) {
-			r = -EINVAL;
-			ti->error = "Too big tuple size";
-			goto bad;
-		}
 		ic->tuple_size = bi->metadata_size;
 		if (1 << bi->interval_exp != ic->sectors_per_block << SECTOR_SHIFT) {
 			r = -EINVAL;
-- 
2.39.5


Received: from ksmg01.maxima.ru (ksmg01.mt-integration.ru [81.200.124.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DB832CF8A
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 20:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.200.124.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757449385; cv=none; b=hm+x8Tdysv33Wxm0beiTnXyypcVFVB9DkM1bXq3zRcsyiCmqUcwbHiOc95LORD+5NK6SJlicQnS3eC+mRLIqShPa/UZQ2hrvAykHaGi/EF1WOK0Mzfu/xk6jjKlad622+m4VDoBCJ4DB28/imn4acgf0UJS53lGLgZMnQfOKTDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757449385; c=relaxed/simple;
	bh=BYhxr7WXO3V9EC/HncPZSfJFIrFL9VZ+O4zvQGpV458=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ElSQXD5N++JWzjgxLFVynh7vaTprT1EKL7TzwhLQvrmOKlG72ZQiQS2g1D7sSji1i/jW/5qJI3OboSXqJ6OPXVkoaX7SCnPs3UJULgoyHd+q71CitqeCX2Epz2nt+dKGPKWf9RWcuU3r8fK7gV+erIC0eyMIhK0hm3sHglmh9iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mt-integration.ru; spf=pass smtp.mailfrom=mt-integration.ru; dkim=pass (2048-bit key) header.d=mt-integration.ru header.i=@mt-integration.ru header.b=fjcVFYFb; arc=none smtp.client-ip=81.200.124.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mt-integration.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mt-integration.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mt-integration.ru header.i=@mt-integration.ru header.b="fjcVFYFb"
Received: from ksmg01.maxima.ru (localhost [127.0.0.1])
	by ksmg01.maxima.ru (Postfix) with ESMTP id 8270CC0017;
	Tue,  9 Sep 2025 23:22:52 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 ksmg01.maxima.ru 8270CC0017
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mt-integration.ru;
	s=sl; t=1757449372; bh=9CNyxPMJq3Zjq2fgFiUckrKdjDPPEBiRclmaAGhSoxk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=fjcVFYFbF+aCVvsbHqGUjvopyaFIWnVw8ru7B2uGWNetFU+XJMFCRY/UF1Xr21n74
	 DnBce0XEeBpONuB1GQDBVhWA6TzRPMyHz8d29VywKl5IDE6eDN8e/QGxraxUscljaz
	 u0D4OM3Qn5D3B4sieqlFP9ymsAOGGHZ/V2YNd79FC+XgpvvLqIA5GKcXdEPs5yykSZ
	 FJXasKm95RmJsBaktM5UVl0YOjTq44SBVa/3cpdn/PUFcYrIU6dc1LVtzXYs40tXAg
	 Hm08IgphGQ+z6yJ+bTxpGUS0lS5CW7DHhZcrGSRHof1Ik+d0PFRn3km+w/XKxzNmji
	 LXK7NNfDy7uIw==
Received: from ksmg01.maxima.ru (autodiscover.maxima.ru [81.200.124.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client did not present a certificate)
	by ksmg01.maxima.ru (Postfix) with ESMTPS;
	Tue,  9 Sep 2025 23:22:52 +0300 (MSK)
Received: from db126-1-abramov-14-d-mosos.mti-lab.com (172.25.20.118) by
 mmail-p-exch01.mt.ru (81.200.124.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 9 Sep 2025 23:22:52 +0300
From: Ivan Abramov <i.abramov@mt-integration.ru>
To: Matthew Sakai <msakai@redhat.com>
CC: Ivan Abramov <i.abramov@mt-integration.ru>, Mike Snitzer
	<snitzer@kernel.org>, "J. corwin Coburn" <corwin@hurlbutnet.net>,
	<dm-devel@lists.linux.dev>, Thomas Jaskiewicz <tom@jaskiewicz.us>,
	<linux-kernel@vger.kernel.org>, <lvc-project@linuxtesting.org>
Subject: [PATCH v2 1/1] Return error on corrupted metadata in start_restoring_volume functions
Date: Tue, 9 Sep 2025 23:22:38 +0300
Message-ID: <20250909202242.355086-1-i.abramov@mt-integration.ru>
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
X-KSMG-AntiSpam-Info: LuaCore: 66 0.3.66 fc5dda3b6b70d34b3701db39319eece2aeb510fb, {rep_avail}, {Tracking_phishing_log_reg_50_60}, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, mt-integration.ru:7.1.1;ksmg01.maxima.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;81.200.124.61:7.1.2, FromAlignment: s, ApMailHostAddress: 81.200.124.61
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 196145 [Sep 09 2025]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.11
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/09/09 16:41:00 #27803217
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 7

The return values of VDO_ASSERT calls that validate metadata are not acted
upon.

Return UDS_CORRUPT_DATA in case of an error.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: a4eb7e255517 ("dm vdo: implement the volume index")
Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
---
v2: Change approach as per Matthew Sakai's <msakai@redhat.com> suggestion.
Change subject and description accordingly. Also add Fixes tag.

 drivers/md/dm-vdo/indexer/volume-index.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-vdo/indexer/volume-index.c b/drivers/md/dm-vdo/indexer/volume-index.c
index 12f954a0c532..afb062e1f1fb 100644
--- a/drivers/md/dm-vdo/indexer/volume-index.c
+++ b/drivers/md/dm-vdo/indexer/volume-index.c
@@ -836,7 +836,7 @@ static int start_restoring_volume_sub_index(struct volume_sub_index *sub_index,
 				    "%zu bytes decoded of %zu expected", offset,
 				    sizeof(buffer));
 		if (result != VDO_SUCCESS)
-			result = UDS_CORRUPT_DATA;
+			return UDS_CORRUPT_DATA;
 
 		if (memcmp(header.magic, MAGIC_START_5, MAGIC_SIZE) != 0) {
 			return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
@@ -928,7 +928,7 @@ static int start_restoring_volume_index(struct volume_index *volume_index,
 				    "%zu bytes decoded of %zu expected", offset,
 				    sizeof(buffer));
 		if (result != VDO_SUCCESS)
-			result = UDS_CORRUPT_DATA;
+			return UDS_CORRUPT_DATA;
 
 		if (memcmp(header.magic, MAGIC_START_6, MAGIC_SIZE) != 0)
 			return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
-- 
2.39.5


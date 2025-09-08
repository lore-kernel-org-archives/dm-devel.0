Received: from ksmg01.maxima.ru (ksmg01.maxima.ru [81.200.124.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279162D9EFE
	for <dm-devel@lists.linux.dev>; Mon,  8 Sep 2025 22:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.200.124.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757370286; cv=none; b=pPWwfXcReSuq3go3M2ODsuE9CUgBhcEYaznidiPN621ZRdsi80FAlfvcChvWdXIM/Ssv+S/JXwTOB3X+zTOKIJ+loIO8m8AcKZkbcT1SSTzKRyVhNqv0Vzd9wOYCbDgRzGNXZdCuv7gqfuEHcnuFqZhJyq0NrTrUYW12t3qxGO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757370286; c=relaxed/simple;
	bh=e3lx3D/ilKhUbD1g2I3seLgU8zYnJJO2PELjf4iaCik=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TDbCmLpnPkR5/UcUsWFlBCXWPj9Nkk0gFxUWWdPjrtbTQRN1XSxlC4nQv/bW6ChgGztkJWKjBEv/pjhVIVJRT6vuBSxEDxmXfeF8SJT5lFTaXCTBU8jyw7pw6iuilcXN7lxg06uHdM/p94PT3PCBlICrgbewWj3iML/h+Gvohu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mt-integration.ru; spf=pass smtp.mailfrom=mt-integration.ru; dkim=pass (2048-bit key) header.d=mt-integration.ru header.i=@mt-integration.ru header.b=uKlQwqRd; arc=none smtp.client-ip=81.200.124.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mt-integration.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mt-integration.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mt-integration.ru header.i=@mt-integration.ru header.b="uKlQwqRd"
Received: from ksmg01.maxima.ru (localhost [127.0.0.1])
	by ksmg01.maxima.ru (Postfix) with ESMTP id E37AAC0061;
	Tue,  9 Sep 2025 01:24:38 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 ksmg01.maxima.ru E37AAC0061
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mt-integration.ru;
	s=sl; t=1757370278; bh=DhwTRmKl7MHR/oEwfrGL4GjlbQAiku0AJpqQ5M2jTRk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=uKlQwqRdSAMev60HG7wquRa6n/qPRKE0S7ExsKi0r9NIUQw3D2AVfquD4UdVpPR/U
	 nhIN/+auaQ3YztDKbdWCw9RtbD/kHEfzvc0DOl2f3B7ygi2+4TDdj44I/yOMhog653
	 /CGvZgMfA/mYf83wrkBELcIrMnXVEF2rak4ZR8u9RwWI2T8Ivnecs4AJaMbC+rNWbv
	 Le1KJw6Ck9j7A+o6/i/oR+utTiy9hUdjPYQDVDRwE1NimyQRwiHE9xuuSvzsO6GKbK
	 LEaTy71p6NSORSICE/qhZ76ofn5YEVdpBi/3PwFE+UeLYPdRkTUThzXml/Pe4c1pGl
	 3YMQe9zauLDHw==
Received: from ksmg01.maxima.ru (autodiscover.maxima.ru [81.200.124.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client did not present a certificate)
	by ksmg01.maxima.ru (Postfix) with ESMTPS;
	Tue,  9 Sep 2025 01:24:38 +0300 (MSK)
Received: from db126-1-abramov-14-d-mosos.mti-lab.com (172.25.20.118) by
 mmail-p-exch01.mt.ru (81.200.124.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 9 Sep 2025 01:24:38 +0300
From: Ivan Abramov <i.abramov@mt-integration.ru>
To: Matthew Sakai <msakai@redhat.com>
CC: Ivan Abramov <i.abramov@mt-integration.ru>, <dm-devel@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <lvc-project@linuxtesting.org>
Subject: [PATCH 1/1] dm-vdo: Refactor VDO_ASSERT usage in start_restoring_volume functions
Date: Tue, 9 Sep 2025 01:24:05 +0300
Message-ID: <20250908222410.223574-1-i.abramov@mt-integration.ru>
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
X-KSMG-AntiSpam-Info: LuaCore: 66 0.3.66 fc5dda3b6b70d34b3701db39319eece2aeb510fb, {rep_avail}, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;ksmg01.maxima.ru:7.1.1;81.200.124.61:7.1.2;mt-integration.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s, ApMailHostAddress: 81.200.124.61
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 196103 [Sep 08 2025]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.11
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/09/08 18:38:00 #27800772
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 7

There's an incorrect VDO_ASSERT macro usage in 
start_restoring volume_index() and start_restoring_volume_sub_index(),
since assert's return value is not used anywhere.

Thus, use VDO_ASSERT_LOG_ONLY macro in such cases.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
---
 drivers/md/dm-vdo/indexer/volume-index.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-vdo/indexer/volume-index.c b/drivers/md/dm-vdo/indexer/volume-index.c
index 12f954a0c532..99608f14400a 100644
--- a/drivers/md/dm-vdo/indexer/volume-index.c
+++ b/drivers/md/dm-vdo/indexer/volume-index.c
@@ -832,11 +832,9 @@ static int start_restoring_volume_sub_index(struct volume_sub_index *sub_index,
 		decode_u32_le(buffer, &offset, &header.first_list);
 		decode_u32_le(buffer, &offset, &header.list_count);
 
-		result = VDO_ASSERT(offset == sizeof(buffer),
+		VDO_ASSERT_LOG_ONLY(offset == sizeof(buffer),
 				    "%zu bytes decoded of %zu expected", offset,
 				    sizeof(buffer));
-		if (result != VDO_SUCCESS)
-			result = UDS_CORRUPT_DATA;
 
 		if (memcmp(header.magic, MAGIC_START_5, MAGIC_SIZE) != 0) {
 			return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
@@ -924,11 +922,9 @@ static int start_restoring_volume_index(struct volume_index *volume_index,
 		offset += MAGIC_SIZE;
 		decode_u32_le(buffer, &offset, &header.sparse_sample_rate);
 
-		result = VDO_ASSERT(offset == sizeof(buffer),
+		VDO_ASSERT_LOG_ONLY(offset == sizeof(buffer),
 				    "%zu bytes decoded of %zu expected", offset,
 				    sizeof(buffer));
-		if (result != VDO_SUCCESS)
-			result = UDS_CORRUPT_DATA;
 
 		if (memcmp(header.magic, MAGIC_START_6, MAGIC_SIZE) != 0)
 			return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
-- 
2.39.5


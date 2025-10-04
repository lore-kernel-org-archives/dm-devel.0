Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD55288D6
	for <dm-devel@lists.linux.dev>; Sat,  4 Oct 2025 03:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759548364; cv=none; b=XCQka8srtsLgwFWIEajKRYndVh2CAPB08WfuqYLx1ZPzbhf1+iaS4sKvMN47hgpA7WBPeLXb+VPN5OOAHahVlSgSWsNDh3eZgcz0Qi8en8z7XogRwfzuBMDnCSMsXMq4GR9Xh1WU7z8/YDNviUbA5BdeAtoIhs/xcex8FqJ6RIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759548364; c=relaxed/simple;
	bh=4fbD+bPbiVKsQ/kInv9VxVrhUJekeoAyMEPUirZ7ec4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GPUxy4MtdqOaZTZC+Dwu1RYlWMHQ2RgDmqeNDTXjAQm10P2FEOSEj1k5d4FPruSJo7FrGcFtb4yy25x0VFvwDrUbUXO+IMBUM7XV2mecQQEvY6Q3rbBQv/HqHzRhm0yaFnePTtLc/9pwI93le+k7C522G85/c+rIJMVauK3PGuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Doug9A+m; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Doug9A+m"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-782bfd0a977so2742658b3a.3
        for <dm-devel@lists.linux.dev>; Fri, 03 Oct 2025 20:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759548362; x=1760153162; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8yl0nQE2zdIwp8lpR9k8ql7CeF/Uw7tWHoOrvMUQqVA=;
        b=Doug9A+mub4d8Tra5X8k65zdJUODJLjNmV1C8GRCpHn3IBOiCfeevIYs67NXy4/Znd
         9bLWPHWCo1xxOCTjRqo9/pBJ1MoiHl9PJKoxJCCS0+OCAm78dQpYFBs2f7/KLVqwS8wn
         zGxGmT+OhufyIJh0Pvg+9/RJpDgSzx9AWcQrG403NqdoKM1PHYUNFZiPKY8eoQ6iv6Lc
         zUd772E2oVmb2TKa1j201bYxVDSFd4ko6PBg42QIHLsPv1WdTifG62EL2tsyFmbONXMm
         s/NPCBEXgiv3sk+FhlC3T/hytFgFIkTjaWUdsEw+J6JyFSMeiRN+vfm0ydDVP32iFhVN
         EePg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759548362; x=1760153162;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8yl0nQE2zdIwp8lpR9k8ql7CeF/Uw7tWHoOrvMUQqVA=;
        b=dxitOF68H6qAlPvSIFCGg+j9nTXsZv6Oz5O4IDSnhRFfERN3t3oGtzVfDl/ANMwr6v
         IPx6XU+tDAHBW8ouSkXXBYCEdpmZLhYI64udeMsbo+OMMz42zd87fyPArH1twFz8Ox3X
         tzTfj6YSaISUVvLsTz9Ng/vDHoPRzHKjJYUZK7+6NBuqlDsyDemnXTftdC81jVdxhwen
         5o4ZLRMCsRVtzSHM6OYgLfDt/37w6ELa4NiEj1uyzn+jsY8IlcWnZ66afQ+Xihtshnqx
         7zrZmt0DqJSpzN69zpM4CimT1uV7tdlu8jBAdh8RmgFD9Tw/p6K1aImx+qEA6lSFg5AH
         aK9A==
X-Gm-Message-State: AOJu0Yy4o4cjIsGA/5Ns+KdLLNthYAqCf6+EsqRF6va62+zFf75iSUje
	oVBRamOdMMWeyo4B/b1/taCqpQ9rtuNOvpY/SUDDQOdzeHfddH8M5hNRxn1oBgkQQ5I=
X-Gm-Gg: ASbGnctMmtDAlUd4v8rTBsvBqblQ7KlStNlk5z2U5tpQdNtss9AD/4bfpE3W6y2qUWA
	Fk9Zqent0pkxwNjsQfJMwgmolDwKp078J2UskaN62gYw201SD8ZTEBIlWLIzBKwoVHAppfaxhg8
	FniVDncdiunXHBqwZafEPlRfstXWbrUKnqTdzCRUXNhp8gGqGA6RqbHs21WnqNODEpxHepRUIx0
	TE0udkC0GjqUJH2RRchyyfSd0s97KZY78R8fxbqVE6n/B75YrZ5o4sD0pLps7VOc4TMGALb+OmP
	jP35PbQszBKIUWFmz49SO2VfNoAbEXFf6AwOhnf2vYow1c3kQ7AFHDIjS7TRZUZ6NV3MtgHFhhL
	C/WfFDJ38BmY8+xLJk3K6RCde4bMpAnEvZkhF/Sd2719JvJy3Gj9uM6tQMy+OjA==
X-Google-Smtp-Source: AGHT+IEkNafZar1ueZEPL9MEDN3ag8gecCLnLQdfj/M3tiCwsSNyQ/VzfvHVVS23dBW1jEO8qtxtig==
X-Received: by 2002:a17:902:d549:b0:251:5900:9803 with SMTP id d9443c01a7336-28e9a5662f6mr71312635ad.21.1759548362576;
        Fri, 03 Oct 2025 20:26:02 -0700 (PDT)
Received: from ryzoh.. ([2804:14c:5fc8:8033:c5aa:36f3:14cd:8995])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-28e8d1b878bsm64818395ad.81.2025.10.03.20.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 20:26:02 -0700 (PDT)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH] dm-crypt: use folio_nr_pages() instead of shift operation
Date: Sat,  4 Oct 2025 00:19:12 -0300
Message-Id: <20251004031912.50662-1-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

folio_nr_pages() is a faster helper function to get the number of pages when
NR_PAGES_IN_LARGE_FOLIO is enabled.

Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
---
 drivers/md/dm-crypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 5ef43231fe77..a1025bb29ebd 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1781,7 +1781,7 @@ static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone)
 		bio_for_each_folio_all(fi, clone) {
 			if (folio_test_large(fi.folio)) {
 				percpu_counter_sub(&cc->n_allocated_pages,
-						1 << folio_order(fi.folio));
+						folio_nr_pages(fi.folio));
 				folio_put(fi.folio);
 			} else {
 				mempool_free(&fi.folio->page, &cc->page_pool);
-- 
2.39.5


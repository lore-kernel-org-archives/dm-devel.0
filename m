Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFA63F54B1
	for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 11:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777376998; cv=none; b=XH5XRdzzKxA4F24Yke6yRpPbyyVv/Xwmje/Tif1G6EXXGLR6wNlDlxH8+CvTDCKGOKw5ytVqGELd+FONdGzBytHeBL8/T/TivXSF+GHg6nEUMabzUZiHU5DFtGEjp0XaJaRtmP6Gb95Njun63nObSQIoAqXa9c4PHP0lHBjEzVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777376998; c=relaxed/simple;
	bh=QR0IAtwTbzz9a9rGja/qJDRSsQSNKiD3Z+fuymvVIRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eo+1Dn6V4APaTgyCU2Igu5oZgDqw9Y7U+EpHE7cAoN5VRcGf5UpRjQAkFDgii7XTNHO2orEFkwK6NpLysZdwhstlwdhHCY3u/G6J3rJh/xyOC+fjqcUXsEDazMQ4ugPIC69ZJYlczfkS6Iy46mxPr/ip0GoC1A7iOBrtk5uzqUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=K3fbsT9A; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="K3fbsT9A"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-488af96f6b2so149489825e9.0
        for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 04:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777376995; x=1777981795; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T4Q48EDz2T8t0xWbhOaZoteVvRDqzy6HwQLC4yrS3Dg=;
        b=K3fbsT9A7D0XTWgNr/qLjRAbW+rgNaj94TrgPDmoj1GW0aqpjV1C1rEqdzxGc8XXMs
         et4txE0H1+Vp3dwyAw2qOZG+3iShqrgzkzdKVTNNVxkAvzWnaqMsO2Usvm5puKLnCKDu
         dwMdKTrbaus0Tyua5SZFZZYGr8AQzqDo+Vws8jXVYMC7hqHpbycaBITMPERFXOmmz4KI
         wuf9wLjzYN/ZoPgdm4KzTPRaqKoXnf0VBUCWmPLe3eSa4q+p1YqoZA+ZeUg4ykO1gNFQ
         wKdDxi5nVm2zdh7ODvtsX3xEKEAGvmM6Vv9JgJoEnyP241g+078wotNUMY4X1PMQhEuf
         Q1jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777376995; x=1777981795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T4Q48EDz2T8t0xWbhOaZoteVvRDqzy6HwQLC4yrS3Dg=;
        b=se/wbGdhRXsQW/ABg6TLUdLtQQUnpEj8OkgK2Y/kJGeAyDxKx8L2hF/ojC2ZGKA7pS
         ylSO/5PEPw/4FP4u/dAiprD4mSJZ1I6FUW10kLDLbJnEmEX9hlKmhBKKwTfHvwgZccBF
         SPyl03gFuE6RxzpsCXm2B7HpRdU72BnWnb5cCIDr7a/HTELaWf7omnoFPYXNzxtRZBjw
         mmGFLBIS/VeT+PVL/p6lCEKBBdVteRdwGXuZ/AOBKM6iEBQP6zsrONFz0GGgJJQovSoZ
         tztlp2vTbEzFe8yQqVCuMKr4PFvohDB75di+y1LKLvUJ0kFrO8ibdIGUaSkJIc5NJRmt
         SCfg==
X-Forwarded-Encrypted: i=1; AFNElJ8+LDTFiI77c9KbnDKSxrugHtXECDI01tIMytlWMU8vEsUHyAQnt673M6kgLa4dL3nIczQLJpcvKw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzwtv4mdmVyUB3bcaB1fYnIBEr75RbCacxsYvCmxoRS1AkSTvJ5
	ErXSTdQR8VsFS3cV6aYGYoj9jcMNUdvLdEfPQJyI7TR1reMk1uvbKzaNDZM41WpCafA=
X-Gm-Gg: AeBDiet5EzoHFbKnn2kqp8M3pN3LHMzwLinTWoY5Mp1J6V6DP+hZ/bSyywKR/HjtCyJ
	BVuz/UFJiXa4EfOAEC+jEIOY1CsuUBIba6zmVK3JsxnkgfNJwnk2VcKgUJ7mdHMlK1y/oenzSuE
	oDdjMTBdwz9W9ca74ydew1DpcTC5wtZnIGGSAscsi3Kg8PkwP9+8Uh24e2FZ8giVowOKnEraQ1F
	p0Uj7OktwZ2tZu72om8jZb7jaZ31qvZ9NAjGDIps4Q7RQEjvBgTD7w2ogiUYSUtZumRx+4pcXMV
	cYQQ29TvQzWOOBg3NReTX7594shTre2ZZdB65f3ZT877ZpXmj3WC+pGm3ZjWIOI5VtRIXmB1K4z
	2L2I0DSMFMXDPBcY80SX298fx02084tPdz2ueVFpWp7abumZKA/a59t1giU4uueVzvIiP/5Yzql
	l6IiUStBdARrjiZdVwFo8wLn0Hk39ZC72N24D46jfkZ+JY/AIOJ46NdVJEndYVmqamoNeQQhiTK
	0GdV6ExumJjV1XuL1Hv0vVz
X-Received: by 2002:a05:600c:8b11:b0:485:40db:d40c with SMTP id 5b1f17b1804b1-48a77ad470fmr46160105e9.3.1777376995006;
        Tue, 28 Apr 2026 04:49:55 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48a7743f922sm25701965e9.0.2026.04.28.04.49.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 04:49:54 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 1/5] multipathd: get_new_state: map PATH_TIMEOUT to PATH_DOWN
Date: Tue, 28 Apr 2026 13:49:38 +0200
Message-ID: <20260428114942.292307-2-mwilck@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428114942.292307-1-mwilck@suse.com>
References: <20260428114942.292307-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We map PATH_TIMEOUT to PATH_DOWN in pathinfo(), but not in get_new_state().
Do it there, too, to treat the states consistently.
This avoids logging "checker timed out" twice in update_path_state(), even
if log_checker_err is set to "once".

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index d87c7b1..9bce4d6 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2503,8 +2503,10 @@ get_new_state(struct path *pp)
 	 * Wait for uevent for removed paths;
 	 * some LLDDs like zfcp keep paths unavailable
 	 * without sending uevents.
+	 * Also, map PATH_TIMEOUT to PATH_DOWN here, like we do in
+	 * pathinfo().
 	 */
-	if (newstate == PATH_REMOVED)
+	if (newstate == PATH_REMOVED || newstate == PATH_TIMEOUT)
 		newstate = PATH_DOWN;
 
 	/*
-- 
2.53.0


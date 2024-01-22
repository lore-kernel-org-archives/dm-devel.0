Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083A1FC19
	for <dm-devel@lists.linux.dev>; Mon, 22 Jan 2024 22:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705963331; cv=none; b=nYhA6YqYD2WZA7CBOQzDfRYdrUpJ/K2Ln2fjr7Wcwq4YlquIyDKXOd8qAYPcLykr+tu7K/VpdjXoE1C02kNm+0AO7sv4UJGezk5zSx0QvpfnkhXrOk/I5V0fehFCbrpRvqJPJJWpm5gd82xP73OMrebBnm9+dEB13s7phsNOMKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705963331; c=relaxed/simple;
	bh=PwIVGMqRQxCR1/KwtOrZ2EqDNPoGnNCuM+cAW+8N2to=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ufi6We688QKPH++qU6PxL2e0sBwYK2VhgI7nfUG3xmKI5ERzfGlwugLzIewsC933Z3oRQvkdxwAeMEF4zfo2cVq6YuZvTfHA0JfjFNSMUlEP98AcZbQm2P+0gy20IHGzOtv+66giuZF/TitSgBKBv01fs/mE+4MrIFASXl+uDVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kAb3WXun; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kAb3WXun"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-40ea5653f6bso31192275e9.3
        for <dm-devel@lists.linux.dev>; Mon, 22 Jan 2024 14:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705963328; x=1706568128; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jUw8j7+WcoGeKCLFgHScLrHAnNK/sP6N5JGXXrncqUk=;
        b=kAb3WXunprYeFa7OvN2nRopieOamODlbR6FAghgM7m74UUX2eQNrU1yX1MHvs9oWrI
         6AS9R0V3i2dpmoD5KlhLdX6g3KSmQl7V/2Hzdn8dFpgekejgxaA2gS5ZA83HNhZWmvJt
         UyB1GH2maKQNB+bmar567fVczgWvO+itr/K+dq/aSVO3HpiKo8kPs21a9as9D+MWvH6T
         c6ig1K9RXgsumxOUn+/Q7dQ1iPwnpJsl3ynmLv9CbvonbTo8MiI6veSqZqq0fSbMDQWC
         0nimQ3Z8LAvUD8tpmYvDaywGqI3wwGbwtiDh6pMSC1cpDJEyhLTBAeMbcYY7SlOEGqFj
         WRMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705963328; x=1706568128;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jUw8j7+WcoGeKCLFgHScLrHAnNK/sP6N5JGXXrncqUk=;
        b=fOnjV7y8j8An++mXNO/4P3kXuWxXckSXL+9FuemxXUNcSFi9kzIkELGTgUE22EtScj
         zoFYpt/gq/Ob33rmbD+JgvxzbEYwkDHefdapb6DPN8uGa9xLszYPCcAAgKmRP+ImWCLl
         bog7eAjkZL60DLSYpXjv0jmxgA42/f/CdKOsv1/+rw2taGa0vJ+zQQVlfUIFzC8ryiqe
         cn4vzCTM5yxtgMc8FA5h/vCrmXS/PpFeVL2Xc9+SjaMGs9GAcbjRSlmCFkqFeOjLtnmR
         +Sv47k7RxEzcUxBvteMYzL6774qtdrs1cZDtr6iruSXlrbgrlGxNwQ/dVv6zPTD3Hzmu
         Ykrw==
X-Gm-Message-State: AOJu0YyvFEgAido0Il2cNLbJv4qOfKzsBxhLfSkHPuqe+V0W15ZaVJYl
	X0jda4axefvMVuw74dcpJgc1w6lgoWz0ZCtI7Rrd0sQYwtPR10Y=
X-Google-Smtp-Source: AGHT+IFsXytm1TqDUCgjQgZ9njTlwL3Uv3Aaq05NkvyiNQAIwHxiak7dxFvIPFY7Nd7MfZa1B9ufZA==
X-Received: by 2002:a05:600c:35d3:b0:40e:4710:b33a with SMTP id r19-20020a05600c35d300b0040e4710b33amr2653491wmq.45.1705963327749;
        Mon, 22 Jan 2024 14:42:07 -0800 (PST)
Received: from localhost (254.red-81-44-195.dynamicip.rima-tde.net. [81.44.195.254])
        by smtp.gmail.com with ESMTPSA id r19-20020a05600c459300b0040e42391a12sm40120602wmo.13.2024.01.22.14.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 14:42:07 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: fix an assignment ambiguity
Date: Mon, 22 Jan 2024 23:42:05 +0100
Message-ID: <20240122224206.141196-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

spotted by indent:
./kpartx/gpt.c:623: Warning:old style assignment ambiguity in "=-". Assuming "= -"

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 kpartx/gpt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kpartx/gpt.c b/kpartx/gpt.c
index 47d8743e..fbf6ae22 100644
--- a/kpartx/gpt.c
+++ b/kpartx/gpt.c
@@ -606,7 +606,7 @@ read_gpt_pt (int fd, __attribute__((unused)) struct slice all,
 	gpt_entry *ptes = NULL;
 	unsigned int i;
 	int n = 0;
-	int last_used_index=-1;
+	int last_used_index = -1;
 	int sector_size_mul = get_sector_size(fd)/512;
 
 	if (!find_valid_gpt (fd, &gpt, &ptes) || !gpt || !ptes) {
-- 
2.43.0


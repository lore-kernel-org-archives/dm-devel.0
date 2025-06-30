Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F3E1EBA0D
	for <dm-devel@lists.linux.dev>; Mon, 30 Jun 2025 21:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751320340; cv=none; b=csNi/bfzaQsqKKBMd80oYW1IeZgV20P5V3yMT9ZMm7+FwGuTnHfgqjpEXvwiYIqLIS5y2QJ6hTWAeZuwK7otyv4t02KaNUcaywh3Fh0iOgP0HscMjsjZwevNKDbDwNsQkg6lhUfY15tkIZQLoDgUe17ihXDBfdXGjRgpjik6G70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751320340; c=relaxed/simple;
	bh=OpWFQXD9hnp+HmoB3JUhhzLrtk2AY0dVNGXZVIsYbik=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qscN+BTG4IDUVbTE85YBhOe4bqzB16X/6JY4NTCAmauXq3ouhDkiga3vRG+yXjj9BSbokruljVrIXY2jJ527u0S8q6lDEwJ75iXnYFR7TaKtRnMZ+TkhySuGqrEVZvBmmuZJzlYR8qpa1HpDGzJUQ7AvlXRM17A+bm1CV/IqEBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B4jGitTd; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B4jGitTd"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3a52878d37aso632516f8f.2
        for <dm-devel@lists.linux.dev>; Mon, 30 Jun 2025 14:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751320336; x=1751925136; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZadOp/y8MiRZEkAUlJp4sHs73rjOml8pZinfdCobXLU=;
        b=B4jGitTdtufEYpWQcRG2Di1kjFHoO2vCXqtGxP+GAHVnZyHS+1imo6MH/4fyX9320f
         wntQWCBZPcRx+q/fFH7THoq4JhRXUEHLPQFmZfoZwjO/9Diraw3m+ntRktkXAG4Fsk5a
         UuvGgu2naUEgEA0yBsOrCqp7+DqXHaYT0iNzpcrnuF7eB2IdJeeELsPJBTt85a8oEXQl
         BmZyky7pEUuyOMEfxWosljXoqjEeHU4pDVIUfQ+LHs8eS93oh+PG1swyAEO1iorgbnk+
         zsqlsWOrTmxbrg3XeO1clLSK2BXq5dNI7tqnaGMZ7aPHTJ+ykbvIv7RBJMCvRIfKUSU4
         xD+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751320336; x=1751925136;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZadOp/y8MiRZEkAUlJp4sHs73rjOml8pZinfdCobXLU=;
        b=UrwYGcIMC7hDWCs+8BN4k9w0K0KdtjQmZwyAP3TOIqY4kcWcBRHq/EX7iq2yOHFBPl
         hNzKPtaf/NfXyURF4fwsBP9Umb0r+z3958n0Z6m7UhUPpy/J6WZYm5+Fe+EyNA7loFlA
         O075/47ZfpAtyyYZAwTHZEuMgtjOxmvFQ1buQOnJoVZ0CUywNqqd7iq3MtWW0CWT5FgY
         Llpgw60K961OM0hhTd6m+XFnrn1vFf5FdgRcYU1DGcqRjB+bYzgCW2Y231ybbtVGP8Y7
         q9YlRh+LBzDHOX3yOiuKnJijqw8hEal6LIZ4eMreWnnZ8xGKPlJD04GTxHWem/OnEoSc
         kC8Q==
X-Forwarded-Encrypted: i=1; AJvYcCW0bm56KQsGGaPDrGKGFBXop92gxISwxOojn1zLgs1iDy5HjvuAro8IV6mktBgRzzXRDlyIKF06eA==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywj59myvea0qkqbU00hx5UyXD5ICB28eJvJr9Id1w4QDXlNNnSe
	IVO3PhltKuaXks/Z94DS0jDKbCKK/e4lcxq7LTQDySjEcwaN4llIA4I=
X-Gm-Gg: ASbGncsj6egC5n3s1GqOgt8PAqzQV+x/qolM+MMC9s/aG8YnsW6QC2SgvZnjcF0IxTQ
	aGMsiNcJj0XuNuB9iUTgbx8tohWeiqh+Hqj/nTN1aIjnyyGxVqdhuZkITxFWZE4sFvwfvVknw5T
	cY9r6cLSNcw/1fBw1CMJYTVGES15Aq4xKBs2EfJfC8YKPG4rmMaxrjvGjbtZwu/RYwI9+MC6Z70
	Tro1/+DkbTAHdm1Urg3LCFN8EOxY2N2ZQnXcvL/bLs+z78Nc3Gq/j1HavNFzxICQGAXh779au75
	jSjlJy1bRBiuATs5t+z7ZVU0nIzZ9gjBYILtNyI0rttK8jX4rgRc0zRpZzi1VGtC2CAdgYwFqXg
	Ju9FWbmwA6QiAyObisFIKIOgvSQ==
X-Google-Smtp-Source: AGHT+IGL9vjo77nKGZfT8+4cOTrziTiSqKoDvAKsCHRrY6Ff0zdIHfZupLH4KVbDVu1fGzpx/+/hvg==
X-Received: by 2002:a05:6000:2081:b0:3a3:61ab:86c2 with SMTP id ffacd0b85a97d-3af2465b018mr214546f8f.7.1751320335293;
        Mon, 30 Jun 2025 14:52:15 -0700 (PDT)
Received: from localhost (148.red-80-39-52.staticip.rima-tde.net. [80.39.52.148])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453823b6c21sm176983235e9.29.2025.06.30.14.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 14:52:14 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: fix licence identifier
Date: Mon, 30 Jun 2025 23:52:13 +0200
Message-ID: <20250630215213.86166-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Also location and SLI tag: https://spdx.org/licenses/

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmpathcmd/mpath_fill_sockaddr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmpathcmd/mpath_fill_sockaddr.c b/libmpathcmd/mpath_fill_sockaddr.c
index 750ef3ee..61ef377b 100644
--- a/libmpathcmd/mpath_fill_sockaddr.c
+++ b/libmpathcmd/mpath_fill_sockaddr.c
@@ -1,6 +1,6 @@
+// SPDX-License-Identifier: LGPL-2.1-or-later
 /*
  * Copyright (c) 2025 SUSE LLC
- * SPDX-license-identifier: LGPL-2.1-or-newer
  */
 
 static size_t mpath_fill_sockaddr__(struct sockaddr_un *addr, const char *name)
-- 
2.50.0


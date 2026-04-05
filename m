Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A8F30EF7C
	for <dm-devel@lists.linux.dev>; Sun,  5 Apr 2026 15:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775404038; cv=none; b=NxPsixGb92Ff5VAt4o2nG4b91ehpfla8CRLCdSLAbUhP4ntml1e8XTEJwekv3rRi/efkj01WkO2qsPxkbpWZeBgaOhbmzCi4//2iTh7qkcc+QVP0zu81gkXmENRvaQMP+aBd3zxmm5Ten6EKehROTcZ/SHTDKOayoJDZbSdRUM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775404038; c=relaxed/simple;
	bh=Xe0Jw5/Y7bMf5xSKeNRkXoNZfvMGIbIh0l+mFS+Hk4I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kLP5utxwPFd+QuxdnSScdp9nNaz0o2rgV9ft5svKt9DMDbsRy133gn/WNtTiiJmSBL9CGyM+9CAk5W96WxQBJB+SSaiWOF624DgRDNMyFPT5vqi2Q9j6ZQcKMuHkz9rQRqzdFXCk1pBb79gtL44wpJIByvMPyhxgakONHVeQgj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GDZMlKkH; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GDZMlKkH"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so3621405e9.2
        for <dm-devel@lists.linux.dev>; Sun, 05 Apr 2026 08:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775404035; x=1776008835; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9c+NACocK/nbrYxw2bkOyOR1b4xgoP/8tGaK1DKwMDw=;
        b=GDZMlKkHgW6QNTusDMVk+badJCrO0lBcCUwncCVn1PIiejlcHnW/rXlfGMg3Yt1Wty
         UCu1CCL/Gz3gYceuLNEm1x7/Ogl8XciHcus3yR6kpEUE57JAFnPoi3+YHh+566/y6a+A
         kmImYPzyznoFo4v0cQ/IDLnuywBmYKSwUDiF0C4vRJ0Czb1gR/0DhuimbT+qrtxxj5Nd
         g1ajijbLe5TJjYrLckN9ts2lnMKRA8ZwLey0DQD8qsZqzi5ppWolxtX1WdCoc5n4Jcnr
         pe2FgG4hrqk98mJ4PKKL1FwyBogwTKXpMbkYY2GS/bJXU0FAuSWT2daoFCN1nvyR1S8j
         c33g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775404035; x=1776008835;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9c+NACocK/nbrYxw2bkOyOR1b4xgoP/8tGaK1DKwMDw=;
        b=TkIKsNeQtaqocz3D9GIe2VtlHDcMs9hE1uhCZRzE1augxpVTuEHJkOqGxZVGTQF2/w
         tlfi0zvpZFG88OV1rixYh8bItirrqn0QHcYscrm7tU8v0ftfTKE88SMLKq/uLY965T/b
         UsIR/4B8ISX6ZNYR9gKpe6XscFXRkvlBL8cmnls3Xfk0gHMUrB+2fDQpPGQMZlGe1UHz
         J17p7s0E/XZ8mtdd2FHN3FEsO6ALXp1tWKuMR9M6NDipoTpL5M/XTDICxY3FCbE3wHh1
         o+veIuuop8xJ9klLhfe7RgEsntu7Mxpb5RTMJQZKMF9Pa+opeviYaOjCTa8Xz2isiyP9
         vodw==
X-Gm-Message-State: AOJu0Yw3XIaxebk190SMYOxJ23kVpb45Eom/pC88d/GSbgjYndmEA+h3
	sACaIVrQ7zZyL4PlgJ44zCfuFmecTaD1P9aFmrk5byGWscdMmZai7A3k
X-Gm-Gg: AeBDiev3ToN6aBj/RgmxuN06fP6ENn6FAtjM0+wsmwlVprAC7V6Qr7QKi4rg2pgk/qf
	F9KlAP5h1HFh+4tMrq8VrtUlLxgCjVOvxdXjsAT7lgXEUpseMMsf2x6IcIQ/1p2b/TjXHOoQPjq
	VAB0K8Xkd5Rspph0xoE4rjzVCR3mxg4IWSRmD5XPa6/wVn2OLi9opF1LTGgAF03Q7HX4pdA/jFP
	c9X+Bb3FTgeRf3Xhi1HscMDtCaOrHSWQn+UCkj/HnNtDboy9VnyhfuGlLrkOdOug5ndw1yOLSBd
	gvxe0I8AiX4RHW65nuyjoNstW7pZIbd3B8MlzZGKMER8toW/9xHGNRBj1tKrsUB6jNrz54RyagY
	WM+CJoOqx/a2Zevpq6+n2ezKroV49r96NOn9qOLeVyZ8/6+XYjfCUq1SiVLeeyTR8pGbQuKrPsV
	pK9vRETSsImK0Wn5lXjuzZP1M7H4/K92fvVxBCNyalvvplX5/BPlr0N1CcaNPfgZyj8hRTpbEY8
	Vo2EddAR/i7vnzLzTl1HVU=
X-Received: by 2002:a05:600c:3b23:b0:488:869c:edaf with SMTP id 5b1f17b1804b1-488996df052mr128365645e9.8.1775404034962;
        Sun, 05 Apr 2026 08:47:14 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48897b8f40dsm96511335e9.0.2026.04.05.08.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 08:47:14 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Matthew Sakai <msakai@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH v3] dm vdo: use get_random_u32() where appropriate
Date: Sun,  5 Apr 2026 16:47:13 +0100
Message-ID: <20260405154713.4660-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the typed random integer helpers instead of
get_random_bytes() when filling a single integer variable.
The helpers return the value directly, require no pointer
or size argument, and better express intent.

Signed-off-by: David Carlier <devnexen@gmail.com>
---
 drivers/md/dm-vdo/indexer/index-layout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/indexer/index-layout.c b/drivers/md/dm-vdo/indexer/index-layout.c
index 61edf2b72427..8707930c9910 100644
--- a/drivers/md/dm-vdo/indexer/index-layout.c
+++ b/drivers/md/dm-vdo/indexer/index-layout.c
@@ -256,7 +256,7 @@ static void create_unique_nonce_data(u8 *buffer)
 	u32 rand;
 	size_t offset = 0;
 
-	get_random_bytes(&rand, sizeof(u32));
+	rand = get_random_u32();
 	memcpy(buffer + offset, &now, sizeof(now));
 	offset += sizeof(now);
 	memcpy(buffer + offset, &rand, sizeof(rand));
-- 
2.53.0


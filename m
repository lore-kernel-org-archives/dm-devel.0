Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2ED42BE65F
	for <dm-devel@lists.linux.dev>; Tue,  2 Dec 2025 17:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764695947; cv=none; b=iAWCbCLQJzHfk6Chd9/NdZ0fLIsJL1uDBh0Cm5Lo5LnGoeuCvh/5/K8Z9pHSMSCNrDElIMvzYbp2q1RJ2tZNwReUyCwjai2l+dao6Hyw6moi5CwCgc1cgZ1TeKIFHaIzyRN5ICX15ax1mxQuIyPgr1dt7uHA4GRCFBJ0/heIRYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764695947; c=relaxed/simple;
	bh=R075mm4j0czBxaGrFbUk0u1Q3QudDHV00oKH9m4lQ4k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lMsj6m45RoyF4uZJRbxWzZqDId7zoPPhxlndKoggjZP0a8oV/gPmbcVfIHo7RYZbhXpbGyczyRKAaBPznJBecuH/nfSE2k/N9mHOvOz3ztPtpNwiCF7Tdf6wUAHAMv9L/cSTtBAPkvUSGPkarJFzjxyrJwkNRcOJM58LrUz5PvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e/YVqgnc; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e/YVqgnc"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5942b58ac81so3225077e87.2
        for <dm-devel@lists.linux.dev>; Tue, 02 Dec 2025 09:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764695944; x=1765300744; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mkCNa6wGWAvKh4QQfYuDgARzZ319bGdtNNMtjRTAVOA=;
        b=e/YVqgncFF8+DGuyN4LQWNsoZF3ml4UINGhvz9cCxsWo0ClvZCDoXpeXjleV2jXcfm
         krWYiNiTvxiJRhUivo6PK0UvSQ91ua5pCGq3Hzm0/HbmBKA5mNAcS+blOXQgRxxKTAGF
         GmHtFzCv2+/5seXrZf6Y2/0W4LJ0MHKZFGA8Yj0j1ss/euBYRtbOBSQPjdzgoz2w5XZt
         upTjyy6Fp9PdEhRxTJEYx5NofGMUThYMh7TREru35kH8kliGLprXSS2dssY4RC3Cg2k/
         +0Ylz59q1nMqwQhdmrIqCM+zCknrmAUPsvUxlJXxav/eNpVcq5vg9np1WLVeZAfAJ0To
         C6yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764695944; x=1765300744;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mkCNa6wGWAvKh4QQfYuDgARzZ319bGdtNNMtjRTAVOA=;
        b=uK3HYNRE0S09pDSfXY+6jK18E/9x9cJcxxx9yWc6v0KL0FUMX5aUr4yflgpX33VnaY
         phnHKe39b+yQ/KhKvvJGXrStjxQ4kSlObc2wOunDCEBVxDXZm50hPpdsRFmW1jNHidpb
         VI7NDiNo1jsmPIwUpIcYgkQCF8PZ/h4dYiqCfxk2OVQzfWrTxlJygiYVm3sKaELsiaBb
         ePcDH263Im3jVcMtms0Wlto+OUbfvRo4olKMQW5WoxD3gR8DbgOXoRn0pJ6Qk4TlPPpO
         aXDu6Wb/mUuMJtrsfKQOu7thBgsjemnVdz10UZnkJVgJvZZ3V230DGYixyrFp3sc9Fhw
         Gj9A==
X-Forwarded-Encrypted: i=1; AJvYcCUaf1ng4wW4ZvZF2mBMiCU0Xq8Lv+hVvN0B8KeynQKvu2gatBnLe8aUqodbtZOM0SxEZyxGjT53cw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwY5rQQdwe+mS0V9r0vIaayQI9PAzUUVFECzJBpj5u+HRPwC6ci
	hgyUySU9pgU0ghZvgFT0XuDgn7fjFUY/xVBNHz3Wr2BbQ86ClhWEQK9b
X-Gm-Gg: ASbGncvnfn/xB85vUAPCvxouSgea+WreupX2HoCcNrIbrF5h5HS8XYDG4I+xTRXCxeI
	UR8xJ8z3aFAzW9A0lENjtxCGQAvRkDELIk9rImUvrtJszZP2CPACRqRyv1QSzym+sJ3djTvE1hG
	sZ5ZZCn+MRbt6TAPUaQSVxIwGFqaQtUbwTjkkNogbVHkH/Yge3n+6FQw0DOt1nuM5TU3xrC0QYk
	TdCos4Dqhlbtazmkvxp4Rt1De8FaQJrjlApPeHWgbOBfxh8QsMhRFz8wLhBGIL9b8fbz53UUhWR
	93f0iPE9tYe6zTpNVHAL9vvq3u5dGWSDiHf5tX890vDjhVYo33uNL4R+jF/xCbBEsBlcThc6k6h
	oaGf4coDiPVPrYaTJ0xP0gqag7VtsRe7DX3PHJdKM/e7rlg0CkjEXqE5DVUz2oYxTL7jyiegRjl
	7DFuztfn3tAsxCp7LZP/wHTRNreG0rKG9KJa4kSTXPaCz0HzoP
X-Google-Smtp-Source: AGHT+IFAYBtTVy0vtizx3Avb2en6D1cIqA6bPP7MdaLWgXujXpXJKFdpqskzzLPg4devlhWQrkSkCg==
X-Received: by 2002:a05:6512:110e:b0:594:3615:a919 with SMTP id 2adb3069b0e04-597d256a041mr70897e87.38.1764695943428;
        Tue, 02 Dec 2025 09:19:03 -0800 (PST)
Received: from home-server.lan (89-109-48-215.dynamic.mts-nn.ru. [89.109.48.215])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-596bfa48c16sm4756661e87.73.2025.12.02.09.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 09:19:03 -0800 (PST)
From: Alexey Simakov <bigalex934@gmail.com>
To: Alasdair Kergon <agk@redhat.com>
Cc: Alexey Simakov <bigalex934@gmail.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	dm-devel@lists.linux.dev,
	lvc-project@linuxtesting.org
Subject: [PATCH] dm-raid: fix possible NULL dereference with undefined raid type
Date: Tue,  2 Dec 2025 20:18:38 +0300
Message-Id: <20251202171837.19885-1-bigalex934@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rs->raid_type is assigned from get_raid_type_by_ll(), which may return
NULL. This NULL value could be dereferenced later in the condition
'if (!(rs_is_raid10(rs) && rt_is_raid0(rs->raid_type)))'.

Add a fail-fast check to return early with an error if raid_type is NULL,
similar to other uses of this function.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: 33e53f06850f ("dm raid: introduce extended superblock and new raid types to support takeover/reshaping")
Signed-off-by: Alexey Simakov <bigalex934@gmail.com>
---
 drivers/md/dm-raid.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index c6f7129e43d3..4bacdc499984 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2287,6 +2287,8 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 
 			mddev->reshape_position = le64_to_cpu(sb->reshape_position);
 			rs->raid_type = get_raid_type_by_ll(mddev->level, mddev->layout);
+			if (!rs->raid_type)
+				return -EINVAL;
 		}
 
 	} else {
-- 
2.34.1


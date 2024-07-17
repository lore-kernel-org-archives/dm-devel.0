Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006867470
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 18:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721242687; cv=none; b=SODwNhcIfFAMvDFqhACMzCErcShMr6msIN++UdPC0P8mdpD8S7hiz532SzjijysDgsJoOcQQcH/FJtVPZfbYAHGTp5gYofRCt19cyE/GmP7+c246OrS+AasYqWK5+13NywsrNWgcHnl89CM0LE0GAMl95ONX6ido9A2wBnE/FQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721242687; c=relaxed/simple;
	bh=GvwL2MamBexf2IAXlg3pCGVub/YfPtuX77A7VLpFOHg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tg5sZJtzOCAdX4jh7oun5xBhnZOq7QJ7yk9JmFj7xsooBeldD/37qrGV2ClE9YosUTkLo4F2Ld7jbxsr2/127zb425c3Qibuo45Gx2jBsxwGRhGLqfupNS58TjNUtoR50QvyZVRbDJ3tdx7KSjm5wWiJSLYvYZGYE9YQg2QihGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ayAU9iDB; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ayAU9iDB"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7611b6a617cso4490074a12.3
        for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 11:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1721242684; x=1721847484; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DQIyDiaE+ClPiBp80hO5ErTtgh10GYm8LU2b4tKKZso=;
        b=ayAU9iDBTvYPJbcdKBlU2W/5sBvWfk0jUrPFkTelLj0CZzTjyWijnXwH+Ba3m8bSCc
         2MeLYO5p2kt8rOD1ofOuSIxpOL97iTrB1tCkUOzzNX0ERado9zAhYtN0AnS1hgYyjhSU
         wu8SqwKF4tZNWfwaOjLuFTpNryiSfjYHbueh0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721242684; x=1721847484;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DQIyDiaE+ClPiBp80hO5ErTtgh10GYm8LU2b4tKKZso=;
        b=ptHQt1KtVkEoHRMbop9sbXi6Bi7PF28tK/vrsLSb6/hsWhz/TjsYWs83+iTQLTBBt2
         zWHZMcelIv4MbeqQ23+dOFj5HCTrdyhi+yyormRHTV+CwUoJwOg+1ap1JaP/PhtQgKID
         N9PTXi8/oMgO/SKd5ZlrKdInxGrHiUr8zzVZyp6Lv2FkZ6J282RwCUYfyXYM4dV0KiJz
         j1BOwyRVjY6u/RtUt5uy7jWxkuhTzLo20WQHOfNQWB2Z23wCjFUhLr3kFuGt0k+lfOpP
         9sRlwk24oXRaoyA+jc/vN8GCItNsTRzJpoRXH2ARnljQnOlm206VACfWkmo0dyH2dkf7
         i0kw==
X-Gm-Message-State: AOJu0YyjkY5pHsrwLFzo3X/5UHot/FNxRwOF/WiG/RYoiFDLBZh5nWkv
	mf9Nmb1Aq4W9YzJRwhv89AxgD+O0WEpYAWUmWmsCLPLVS2UPL0SPoq/yGq3sPA==
X-Google-Smtp-Source: AGHT+IHPkzahbBHA98FUgdZB5mHOIUyDg27+QzN4gYapMulyWLYICptq571PRhkgkdgfkKsYtpeFMw==
X-Received: by 2002:a17:90a:bd8e:b0:2c8:946f:5fe7 with SMTP id 98e67ed59e1d1-2cb52691c53mr2038292a91.17.1721242684091;
        Wed, 17 Jul 2024 11:58:04 -0700 (PDT)
Received: from khazhy-linux.svl.corp.google.com ([2620:15c:2a3:200:ba92:94ff:8264:6b34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cb60145f70sm290192a91.32.2024.07.17.11.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jul 2024 11:58:03 -0700 (PDT)
From: Khazhismel Kumykov <khazhy@chromium.org>
X-Google-Original-From: Khazhismel Kumykov <khazhy@google.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Khazhismel Kumykov <khazhy@google.com>
Subject: [RFC PATCH] dm ioctl: fix erroneous EINVAL when signaled
Date: Wed, 17 Jul 2024 11:56:40 -0700
Message-ID: <20240717185640.1026114-1-khazhy@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

do_resume when loading a new map first calls dm_suspend, which could
silently fail. When we proceeded to dm_swap_table, we would bail out
with EINVAL. Instead, restore new_map and return ERESTARTSYS when
signaled.

Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
---
 drivers/md/dm-ioctl.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)


RFC as I am rather unfamiliar with the locking semantics here - whether
we do need to re-grab hash_lock to write to an hc we previously grabbed,
and whether the device becoming unhashed while we're in this function is
really something that needs to be checked. However, this patch does fix
the issue we were seeing - we'd get EINVAL when thread in ioctl was
signaled.


diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index c2c07bfa6471..b81650c6d096 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1181,8 +1181,22 @@ static int do_resume(struct dm_ioctl *param)
 			suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
 		if (param->flags & DM_NOFLUSH_FLAG)
 			suspend_flags |= DM_SUSPEND_NOFLUSH_FLAG;
-		if (!dm_suspended_md(md))
-			dm_suspend(md, suspend_flags);
+		if (!dm_suspended_md(md)) {
+			r = dm_suspend(md, suspend_flags);
+			if (r == -EINTR)
+				r = -ERESTARTSYS;
+			if (r) {
+				down_write(&_hash_lock);
+				hc = dm_get_mdptr(md);
+				if (!hc)
+					r = -ENXIO;
+				else
+					hc->new_map = new_map;
+				up_write(&_hash_lock);
+				dm_put(md);
+				return r;
+			}
+		}
 
 		old_size = dm_get_size(md);
 		old_map = dm_swap_table(md, new_map);
-- 
2.45.2.993.g49e7a77208-goog


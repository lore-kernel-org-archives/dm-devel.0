Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F6420457F
	for <dm-devel@lists.linux.dev>; Fri,  6 Dec 2024 23:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528208; cv=none; b=qYbXOKMrmU7tUQKvbV0l/pYmhd3drGflbqXCiVw2ntcceGv5AhLxZO0aEGXfDn2wto0KklZ9aNsr072izl39+pdlim0ClTEdA6XFsyXEisvZGe5X5W4LIplV6+aVWGkI6MmkHzCs1ep8RDgWJmt/UTKmURB8KbV/hIKCmjEDy14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528208; c=relaxed/simple;
	bh=rrGSVmOgyi1ETVifSDgJb3B+MjBSFqlPN22Xf2m5eJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMiZWbWh7Gbai5EoC0BC7NGvjpTS1Xl1y49USaH6fsnUYHphiBqAr0iGpkmixa4d/fwTaTaDYMms9+1/1GE2ktnbZs4hfe3RtdbXkQ17LbszP6rVuxfjUORxB1e7xChp7tXl5aETS+f9mCKKfo7e7lq23Dc8C4rLONAPPQOYfYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IqX/z3PM; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IqX/z3PM"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-aa64e1dc9b8so33532966b.0
        for <dm-devel@lists.linux.dev>; Fri, 06 Dec 2024 15:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733528204; x=1734133004; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PvsqZ4zdQ+CnRhMyNVwfKD3vMahPAdqyL66NwgdCQ2c=;
        b=IqX/z3PMqS3xMWerTrqE49wz1xoGZVifM3WmLUt4AO1FDgr4k7PbWwa+wxlX1zFGKZ
         VdPCzM8ihWR1GuOz640ZVAx5JJwvhqo7J3IBiONltgjiO/gs1wy6YIBrLxx5QjqWoSmm
         g37CTJ2m/iMKKOj/ciVmHj5udkXM8Dwds1rcZ6Jx1+rnGRwhJcvBP1CDA3Lq/UKAELmg
         QZxyNsgqXRkonn6lfQs9B6rWZ5PgigoAHGE07e7Fui+5ZMLCARm35LW2WdJDNPf4OEaI
         x7FcCHJUkQlYC1BZ6EXLi54CHwqEU7sfRE9iEhX5GpIsWKBf1OtxolcA3BAWIM1+/Bmf
         +ghA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733528204; x=1734133004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PvsqZ4zdQ+CnRhMyNVwfKD3vMahPAdqyL66NwgdCQ2c=;
        b=LnLI2b4WMNrllxr07GHXkluHpPuDNj73PAqnlYNE3w8Tv4VD8e+RDUgDaj8QpzWQ3T
         bLkeJbI64/mJgQKYthRlueUJDc16jyyt1mRVTO+mx4M4434WnNCei3Vq5/vKv0AR2zL8
         iVf8Db+chB/kzs9zTsRm5suq6zYLy6KvysNjFMAx03RKU5tmOXzpuA0c4l74aSP1kiv+
         i5xl9Cic3y7xZ2yAN6DrUt3KBe1N5jha8+mt0ZLK1CGQngQPji/fHWeJCBHZddY1Tsk7
         Xqz8heGF8LlWiuIJrf4iH9vZTN/E3SbrOcLU8wmmrouoRnIqTjZs55UKN/7imWsF32q+
         Mg3w==
X-Gm-Message-State: AOJu0YwjauUBSFGdlp5m40bPeLw9iE94c32oJTofOwYq+Ryt0pBoyJsQ
	cfifp0CY/JkomnfwQB23mHz5u82A9mDg2TKtj/Gk4mpoRRb3DSa0CnVbS44xd4E=
X-Gm-Gg: ASbGnct6qwKVTW5r8q3rUU+oPBrYExMCtV/xqFIsgpfXTyR43Mm16ZVDF1u7bpQ+v7X
	4PZMrScnUgFm1uIqoO3EcuiJz5aBINxRld47OEjQtK0Npfs9vrVO36/L/02HyHpShnvpE6+eleg
	f70kmpngccDhJkf0Ns/BcJN48eV34Y6MulLYrGpmhs7iRJ/SHsssGCMQFa+8VfrJKdIZwqIQHEF
	sAtHXh1khbLnPnBeD8pPRlZJfACsMlmodMaYhbUavgNTJKGCUGWRUrHEpbch6Lw3SneUN3Katon
	X4qoVTUdxbLEWgKxp1tDpkJOnJ5TLKdvxfu1
X-Google-Smtp-Source: AGHT+IFGS29Afp8GztEP2gTux74eUN5uavYwmHmlfLz+qNlnXPAtqCM4mvAWvAByxunuRvXR/EuEVA==
X-Received: by 2002:a17:907:c28:b0:aa5:b4e1:ab6d with SMTP id a640c23a62f3a-aa621aadb05mr873609166b.29.1733528203802;
        Fri, 06 Dec 2024 15:36:43 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa625e4b600sm303870366b.14.2024.12.06.15.36.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2024 15:36:43 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 02/13] multipathd: remove dm_get_info() call from refresh_multipath()
Date: Sat,  7 Dec 2024 00:36:06 +0100
Message-ID: <20241206233617.382200-3-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241206233617.382200-1-mwilck@suse.com>
References: <20241206233617.382200-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the map is inaccessible, update_multipath_strings() will fail.
There is no need for the extra call to dm_get_info().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index fa684e6..4a28fbb 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -503,20 +503,12 @@ remove_maps_and_stop_waiters(struct vectors *vecs)
 
 int refresh_multipath(struct vectors *vecs, struct multipath *mpp)
 {
-	if (dm_get_info(mpp->alias, &mpp->dmi) != DMP_OK) {
-		/* Error accessing table */
-		condlog(2, "%s: cannot access table", mpp->alias);
-		goto out;
-	}
-
 	if (update_multipath_strings(mpp, vecs->pathvec) != DMP_OK) {
-		condlog(0, "%s: failed to setup multipath", mpp->alias);
-		goto out;
+		condlog(0, "%s: failed to read map from kernel", mpp->alias);
+		remove_map_and_stop_waiter(mpp, vecs);
+		return 1;
 	}
 	return 0;
-out:
-	remove_map_and_stop_waiter(mpp, vecs);
-	return 1;
 }
 
 int setup_multipath(struct vectors *vecs, struct multipath *mpp)
-- 
2.47.0


Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005DB28980F
	for <dm-devel@lists.linux.dev>; Fri,  9 Jan 2026 18:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767983976; cv=none; b=enl66E+HO/BfnBHW0EVXz8zwZa7ZkIdhSjU22IaeFCBx4w9s9WXC7yOVSFcha/LZ0JjP8kYYmgu/0Rxuv5lY/j7MakYFKhb9+ADPh2QzU5Bm7qzZXOrJDu1pAmN9tWn8M/kRpexQyy1rRg8uPUGEeo7Z8LWCDHin7aDMoQryhN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767983976; c=relaxed/simple;
	bh=009gwf42u9CJFR6D89Yyxjo7/Pzu0l+K3DvafutyC28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGdwyl6Y7sAm5n3Id5WQZHEMfi5lYztp2ysKwSNn7WiNSz+V4/khuC/yQ5trdjQABeS6ibGsQ7aGuM5t/SPXdXbDSTAeXmV+hpXeCvz++t39gRQ8yACLLNxYJhtb57+DopMLuhs1kWRA0twWdP7hXxGZPCrniC4HEDIoaDU6aTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VCArzOmI; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VCArzOmI"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42fb6ce71c7so3683753f8f.1
        for <dm-devel@lists.linux.dev>; Fri, 09 Jan 2026 10:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767983973; x=1768588773; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=omBAMrfKiAzNM6k3Dm0ExVfMw5PTHNmlWIsHhOrjpjA=;
        b=VCArzOmI/UgxMF/KirHKAXKqz7X+4b8UrmImsNSLbcAe9zVShgW2tIHDftwxZKQd/m
         wS/prh7ShpFhm1AgB8hQipfdszcJSHEJ/ta73sQFFvfGCr4LfNx1bIZnciteAU16qkGt
         EJMJxKwNPyNpU9TdCqmo3s8ZVvCye/F5Z3sM9SWP2IbCoI3ICArngB8tl77I4ueR3N+Z
         ZzP36vTAcQOspp9MGpJsYWSiDbQugrflrGAtoSmJcne+aeXur59kxYuB2OZabYMpmDDg
         leSDH0fSC1/mM/wYPR5B5VuoppoJHndspqEw8FrQ/hzh86/Ao0KR6V1opIcnVaBqo40K
         63hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767983973; x=1768588773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=omBAMrfKiAzNM6k3Dm0ExVfMw5PTHNmlWIsHhOrjpjA=;
        b=Iaud01gx7yBoe0FF4q/UBMlOtSOUJBfn3gqIBEdiwDgGUid5FgpJetruSRCaVNXe/y
         G+2XH8Xb4OXJsgUmZuGKRosvOBrnyWoBlEH+4unC4kqsuRxxf4sujAHwV5UbTttBM/1e
         kOEifogG9Q1oSSVi1J7S4QeK6c8j27ZJWFxQmqgGhrwoYW1kCU3eWyD3CmOUnUcGTDSV
         OHbNM76EWAZiculGr/mvY2EP23q68ePjUb9LljFa6xz3zd4MvTqOgTzLaTCbDxhh8/zR
         Wi6NRaej8HtEkeqO9TkwmHjBSBTaCqOzMRhhEzdsGGOdK+lE+zzPHdyI22P1Y8Q+J47d
         fuNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJP1SKBXpnVHasyI2WCZgCHPl9aLay5js2DHBS3oXCNU7zRJCgcLUq4GgrsInT4Ln3mEiVMfrSvg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyrjy/eddE63UptcYCj8Nz9MJs3giccVUOFswMGae7bPT34r9CF
	W9tXF/EZRS/qKkSI+eC614wrf1XkduoMNlwOapZvpBYqQVbLwTNLdQnwLe0HXzktAVI=
X-Gm-Gg: AY/fxX5KFCfTMjwRdWhwwAxRQqToX4nT9rKu9I9fPOUY9HArkjs683m8uwPFDPVosBK
	AgEyE3C/PUOx/7iSJr4x9fl2cWG85qJ6bSvjZ0ZfgWCImaTnhddlKy8RYYDvrBhOQIp7tz5WyZf
	5cvAc1jvBbLD9I7BGaAeMKZnNaWC29SB/9M2jKrIMRP40dVfiqXEBqaMYcZHplfFGizhXlOvJ18
	gO1ams6dryquI1lMwNCYGlxqF2JT/FeCWP5OSr1oXp6EmB63HZr78w1tJylLoT1Q9zd6ww3lc6o
	hZEEEtzmpg6tLNZXzCmjN9DryiezxYsvz7PQvLmboaGPwb1iWgp1Pwrx7YwR/ick47/XHyh/D88
	OWoXL1tj1gRwI7ko//6HkVOLsF+ru4kyZX+uiK605nQ7aP41a2iwY3T9QzWRm14yYbI0ZZok2ft
	JW8xt70ShQLmjnrz9ooRKZvWqDih/PsMP6kSO3co5k6E7Pfi3Q2xB+DzyemWs1QtohY1pxHBa2P
	A==
X-Google-Smtp-Source: AGHT+IH/QhENOjJI2DC8fcdFhLFL6VY23mvXA8R9OKjqkh5jJXsAhQCR3b2vFAPVs2Zv0bL3LyE7rA==
X-Received: by 2002:a05:6000:4024:b0:430:f59d:4dfc with SMTP id ffacd0b85a97d-432c378a153mr11094789f8f.9.1767983973160;
        Fri, 09 Jan 2026 10:39:33 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-432bd5ee243sm23651706f8f.31.2026.01.09.10.39.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 10:39:32 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH 5/9] libmultipath: sync_paths(): print message when fixing pp->mpp
Date: Fri,  9 Jan 2026 19:39:03 +0100
Message-ID: <20260109183907.201250-6-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109183907.201250-1-mwilck@suse.com>
References: <20260109183907.201250-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This should help us find cases where pp->mpp isn't properly set
to begin with.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 7185038..9384de0 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -639,7 +639,11 @@ void sync_paths(struct multipath *mpp, vector pathvec)
 	check_removed_paths(mpp, pathvec);
 	update_mpp_paths(mpp, pathvec);
 	vector_foreach_slot (mpp->paths, pp, i)
-		pp->mpp = mpp;
+		if (pp->mpp != mpp) {
+			condlog(2, "%s: %s: mpp of %s was %p, fixing to %p",
+				__func__, mpp->alias, pp->dev_t, pp->mpp, mpp);
+			pp->mpp = mpp;
+		};
 }
 
 /* This function may free paths. See check_removed_paths(). */
-- 
2.52.0


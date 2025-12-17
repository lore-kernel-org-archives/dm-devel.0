Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8005A30FC1E
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 21:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006496; cv=none; b=R59vCk7EA/vBmGeNb0mjLGDc/R7dI765u2xtAjsDL63urplsm4gBVcx4DMpjRghkS209yhJiECTjEfregscyc4IKHhQZfyyco9+8eTZPH8RmqADpBmvDKQkQSaPM1iqaSvAyNzrrsdoAm2FsL5QpgCRfEDLmiCZlSqdfVGNd/3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006496; c=relaxed/simple;
	bh=g+sAiRZxolx3GHaYInU67c3pRpOyQ4SgNAUNBLbBmpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mafhz3voO3K6+JQ8Bc3EokXaa3V6n58uJTtanxMoqKZdaiSWzsuSHNNroTp60UF1KyeKgURU9l8C0rJjN/SmH060QaykGqzRMIXf8V7xaWbXSyt+DMcVkFYDHa7RzN/j2esZxJKP4VhMfejzdtZqb7ax09iN6UtEG8rrTa9W4Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Kq6oCra3; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Kq6oCra3"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b7a72874af1so966063566b.3
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 13:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766006492; x=1766611292; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=agKHIGLCwUgbgjPo49ZGfWhs3ax6br8MV6OJiXLhTpg=;
        b=Kq6oCra3G28A1ZO/izMEDyR0O39zC3oQqX7J4mX7iAkluLsnjsohhyk+JnqmpEuwM8
         bLprVqZuwQw3RSnRlnlKpeSS3aEOvOVk5bX8Lctgu7HKkVVcS3VtoAc+QFOUPjd8UZzm
         hV92RPld5QTxmsSCm8vGy6jyrpCJaT65cQiixT5sdV7vc1d/0WSJ/SvcZ7gpH6mKBr5b
         x9qqgWy4eKLSKWxtLlLZOr5sBXiSeXW8sZPl3RAIcJ0Z1lneeivJMTsXChwfC85BURqD
         l5HhxjLpNpaspH7RzIfiRWyh7t/pxVFSXpiPNo0v43Xj2JpFXsXpm6tPI+MwYVBzhxAC
         2HuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006492; x=1766611292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=agKHIGLCwUgbgjPo49ZGfWhs3ax6br8MV6OJiXLhTpg=;
        b=D83TF2zGuJt0YEq95XhG+TDM5Xz5VJU02EgtmcHlrLmm5+5n2wmj/Un1KO1TKysMpr
         tiAEwpxStC+kMydYuNzA9IpW74oj0hHrhRrb+pwmPRiribdZ5pM0Wjmv9iEjfkfhJkRL
         lz9yF7wd2su0pR9uUcpW2VxNL95RNRGaiRcEIaH435FrpY5GXkwo3u9DEHNax7fzW4WI
         6tN2CUJgRKGFhJDxV+culsuTzWholPXTF03IAFEsEAvck3BdlJU7B9iqHUPyNSqsAgCz
         oo8dynrUFGvYRVAUGA/IZYJOQWIgGOmKYf3ajUvrE2Ttxtq+u+9aoxu+WNAKjB4rfeex
         4Mmw==
X-Gm-Message-State: AOJu0YwvGCg7flxFwnCb/ZeJgnN+sbvTRrhlcRKkczcS6lGeFQUDn0ga
	pHMuTByhFhx8YNhJ93mDa3kqTMi/UB9e/tfIPcKUEU9mJpn2uR3ebAQrD9745Xn96Uw=
X-Gm-Gg: AY/fxX6ZyuAGydiZVLLunuGnBvODDzAN56sEFKVFleAOsquw8k3nmBvd6PEgfG7OvXf
	dNaDHLgN+PJTZL9OD+ZiFGeeVUsDHsJLQOjb9zv786+Uxu+yeDxewczQ1/LrLIekDaX6Xjwmabm
	ZFKt+YJjsAXocti0k3bau1EXoHDXHHd6ssz7nL0ywnV7BHMUEDVKuGd44dSj03NO0Fdnus6ISrO
	Y8BKnB/DL9OezRRvUVhVrwofERkT4bGDUsw5tzSiAR1j+GPdazuL5XQs/S9SUV+uDn/u08ClTxJ
	x9YK3gl3QlWAlVa96NgVYUx1h96ROz4IGai/jA4nm7Z9w4WRafnHL788N5rEvdb05VIfl/rNkLJ
	TwJVGlLHbuqmm4XvnmNBE45x8Xq0IhBCE4FcDTlEVafse7nB7w9M1G5KWvMOPlPul+OXh4x2wNq
	ab+aDnDCO00MtJp60msrBQWX9jHJnrBXRMGCGYnz9PUh6r7/l0PnyRa23gsnFhbYPqqYOuAZeoP
	Q==
X-Google-Smtp-Source: AGHT+IGEXfVo9zREErBEXL2lX9954weDoKUZY1c4JsZOaTYPB0RoyaWdw8xWWISS/j2ZIkh2hIj3hg==
X-Received: by 2002:a17:907:3c91:b0:b7c:fe7c:e382 with SMTP id a640c23a62f3a-b7d236670eamr1803077766b.17.1766006491419;
        Wed, 17 Dec 2025 13:21:31 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b802351a335sm28004166b.66.2025.12.17.13.21.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 13:21:30 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 09/21] libmultipath: fix numeric value of free_paths in free_multipaths()
Date: Wed, 17 Dec 2025 22:21:01 +0100
Message-ID: <20251217212113.234959-10-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217212113.234959-1-mwilck@suse.com>
References: <20251217212113.234959-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

free_paths is an enum, use the enum value.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index aaa7e50..059d454 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -310,7 +310,7 @@ free_multipath (struct multipath * mpp, enum free_path_mode free_paths)
 		mpp->alias = NULL;
 	}
 
-	if (!free_paths && mpp->pg) {
+	if (free_paths == KEEP_PATHS && mpp->pg) {
 		struct pathgroup *pgp;
 		struct path *pp;
 		int i, j;
-- 
2.52.0


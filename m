Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E63926FA6F
	for <dm-devel@lists.linux.dev>; Mon, 16 Feb 2026 11:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771241142; cv=none; b=jPA5VX0wTjmapn5zaXYLLmBAR5Mtoho6ImYAIMNprJvAPVLSyDIJeNBYq0zcIFSdDMrRbAA6gTrXDaXNzobmHORqzDdL54HQhTlUlgbWncZ6DH9p+yPDIDqsepGQ+ubvLa2RWqPbERvR8nlRnR7PcmQ/1Kp2txWRxXrhysVHhKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771241142; c=relaxed/simple;
	bh=EHl9NKReES/DgtVZLnM2n/TdvpFrxpqVI2qT3d+hdck=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RqYInEniaU96iscj0mtdWES+Ui6C9wJ8HvNFTxK/wInHQIzGfQY2E0tvjjOCT7V56BFqZ+MRic1kzzTq32wfScWfvjRzaFgqdrtR7XKQDTGrI2fKs3daj0GaW9gzeh1D2kMbufOZI5sM5P+UR6YpgiRmwCPreq2IPOzeNx8fiHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=muEpQbrs; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="muEpQbrs"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4836d541968so1946865e9.2
        for <dm-devel@lists.linux.dev>; Mon, 16 Feb 2026 03:25:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771241140; x=1771845940; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BNT0V6okWDcTRHlbWaGQUAAKv2TewztcpV/KE7Hp8PM=;
        b=muEpQbrs6AgiNbo1Is23pxULselDCvB68QGL+WlAzErELDKLrguqjuUso0tOF5kLG4
         bAS/jD1zJ+LAhD9otKa1nttKb3eZI7iggO8JpnX5cQPpyo1//l19DGG7hjY9lGRagtrn
         zGs01867U6r012vrUOs3yT7azzpqwU0ceyy/BAZGjAROzMg8JvbURVIoMV4Q3arAARE3
         2vz7zqn2EWYCv+UnRxA3CCj+oWkU3W6yl2BV/n6OPM7pax3z4EWZedwtGrzVpEL6s4MC
         lz0jRi90O43UzLduXUy5Zg3mzHo2VKnPH6I5qTi36X8uyVIZBQGHyKeYvC852Zn/nGfQ
         I48g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771241140; x=1771845940;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BNT0V6okWDcTRHlbWaGQUAAKv2TewztcpV/KE7Hp8PM=;
        b=P9bJ9iAYHVDTLSY8sErZ+zkDoK5xEWhtl1EbPDu1R9XsHu2yYUCth0EfV/ZDObZj/2
         FEEF+s6IHRRN7oXmtRYYUAG4qGrOtWufVBuAqN0diTRUSnjZ3yu2BToipcXgk5wYJ8V3
         k6YtlkgiGLuaR2I5f+2s959ATJW63UXXWzfpGDYDYAY0zlR8IOGDUDyaBrygdzwCsWWu
         /SytMaAsoXoveV3Pe0zZ6XJvofdy5renMdw73YOKuvu1FLWvjFDmw0gYNwZPxRu5CrBG
         8jbFarEfBSCT8KQYB3HMAdFU38FpaGrV/KZwF9xnzVBupIAlat5YZqKJrsah0NZ909Nk
         F3pg==
X-Forwarded-Encrypted: i=1; AJvYcCXgh0+9iYoX6/FPn6uV6rTEwT/2h+6WeFMMLB8qhfMw9W+fwFyFtzeWvJEzJqHC02cBqDdR/d9MWQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzbSCdCkJvKyGeHVbHtETRLnaM1vikvb2plZMi79rLkv3rY4Bnu
	zWp3xNwBqkTvds6TcAzrnNNE5fpof9rq4lwI4iYueCTWDdZGRVlHpCU=
X-Gm-Gg: AZuq6aKP/GTz8h9fk6qHrpiUL7EvmVedhAufwlf4Gqf9DRh2bV7GoltXLB+EmPsJUol
	ZqKmzDyE5QRBSaeo4IKyGNSlioro1CGk7ElgO3saP+hM14dnhGsrFBqpVedjjJCsTKpWQlbTcgQ
	aS9a55BvBm+kbSFMcfdM5gpE0ZBq/P1cJghUMR7EZBvya7WwgfEwWQ1OSfxnXOVs1f+Vhkj0gFt
	UGaw+XjZgfut527eS7jfrx6QzrBh8lRV1NQcHuRlRceai9vNnY1Y7fNU7TMp8ERxkJTNy9DWNvv
	qsVmcrusbu5aFG2056hLs37HerxlxTyxJoeOFCiMEoHDTvSkclQjeLL+s8T4YNpm1s2HPLM8X9J
	r0Xz10zjgoE+k0FF7Fcy+t1Kq7hjQb6VkvlMV3xn9yQwjCIn+9N78OdAx5qrnNwn8nqwHbpO1l0
	rImMCDtmcm4YJrCqWjoOiEpyzlumoxep6PywLECsiYNlWxmnPAIEfN5alIGo4DaVH6o/DVLPxj/
	QY=
X-Received: by 2002:a05:600c:8b4c:b0:46e:43f0:6181 with SMTP id 5b1f17b1804b1-483710663d9mr98841235e9.7.1771241139279;
        Mon, 16 Feb 2026 03:25:39 -0800 (PST)
Received: from localhost (48.red-80-39-158.dynamicip.rima-tde.net. [80.39.158.48])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835dcfafcdsm658813855e9.9.2026.02.16.03.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 03:25:38 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: add missing colon to the multipath output
Date: Mon, 16 Feb 2026 12:25:37 +0100
Message-ID: <20260216112537.120343-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/propsel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 56895c4b..0c10ebc1 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -640,7 +640,7 @@ int select_checker_timeout(struct config *conf, struct path *pp)
 	}
 	pp_set_default(checker_timeout, DEF_TIMEOUT);
 out:
-	condlog(3, "%s checker timeout = %u s %s", pp->dev, pp->checker_timeout,
+	condlog(3, "%s: checker timeout = %u s %s", pp->dev, pp->checker_timeout,
 		origin);
 	return 0;
 }
-- 
2.53.0


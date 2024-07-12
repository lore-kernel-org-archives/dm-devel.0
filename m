Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6159817736
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804566; cv=none; b=iVXrrT/CJdMuObcTXp13ZV+shkPrFtkIFLX1LTIQsj2kZb/RTjxlEvoJsw1fVmd7fkkzaKFNVH5lb+hritrfQxn9VDpRW8oOYzLnl93tOaXp+N7dQEp8XNc5R/HGDNFmS5juFW4yZyPWJ487KiW2UDBIxDauzfNizDG+X1LREHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804566; c=relaxed/simple;
	bh=HF3j0dbEr3yuUCnuLfxqfJBJ5H75iSUG0ZhKAGRsb3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qm36wRQoEQrnDSRobCua3A7AmFDdGGFUdk++P4sYATvXVBtnY+d3AmbBmdNMXnHikzjeRR3uESYT+yt+/hoLtIkusplZ3KWl15KiHI6EPHMPe2Gh2GSWELHo+CCO3Xda4k4FkCx72KKg4BNCkIZXQj04qExqY4t+X20lp0bPFK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZbgTZDsg; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZbgTZDsg"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a77e5929033so316013866b.0
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804563; x=1721409363; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vfjcoQiCbIhNP7HJ5CwzQFMqhlKc4fWC00aaqfOdGmo=;
        b=ZbgTZDsg0CtCMjfjd4g/mK3wWpM+lsLm1rryi0RlbBc/oJIMs15uECQ6AOl+guOr/L
         FbsBo1nBxy93MUQnCxx1zfuIS4s4In5V26ryNMgFyzkEqoc6DRdEOZxc+ULU8Cnm3hBR
         mFLGHPUeGkoC45s9gNx1yHbXxhC9NWuQVj/Zr71Tw2o/WAjwzhdGhx5JSK5G0D3rA0rZ
         4hI4TM8r8S3uHi+oC9XgXjsf6l4GcC1QuqdGcciz+aal/aP01CLZpVX6wkzkNwW6qIuV
         QE1okcIhq71rVuXjMvOlFiUjeDztK5KKR9BXONtYSKl/R8D5OeiijEsGjh3S+BLvn6fY
         8jLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804563; x=1721409363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vfjcoQiCbIhNP7HJ5CwzQFMqhlKc4fWC00aaqfOdGmo=;
        b=JHrUBcL2qNsZPG1VnEW835iVUTYeXQw+doZRWtbTft8SLih2Jykp0axwzP8Hm0/iA+
         J1mYa8BJ0Hc5sRXZFtUVk5zI4T1fll5Ar14pC4B7FnmAcse/GkKhioJFdwnYMHP9KL6C
         55tz3OFyluPubhD/GQ1Zzno7T54Q8C1pJbhpSe7LQ7gQq6VTPFWcl0xiG+tHR6LEZQHe
         uJFAKAOmlXudAxh7qOoozg7R3zqrVRXKZkb7p5CLUbc1R2gwC2AvU5AZ/K3bkqy1PQvE
         VSPA0n+HVcrGsQIm80WFONGQJpfeFN+77jDUdhhzfjlaLgUL+qWVdKX2gYBJLJhEmhpa
         s3Zw==
X-Gm-Message-State: AOJu0YxMECeDcBtlJCyTedlpLhB6L9Zo9wBYmJU98C/L8g5+qhKmhAah
	XuiwiX6dd9s3msVGVLgquHQ1QFyDWhFoBtiGn4gRPmXImeG8uYSQDvo8/yx9ajw=
X-Google-Smtp-Source: AGHT+IHW4rYyxOCU3j7UDKmNPsLEpML2Oikz2+ctVToq7O6REUoKHpXYdHwWNVs+b01MqQnjpGdSig==
X-Received: by 2002:a17:906:6149:b0:a6f:ba77:e677 with SMTP id a640c23a62f3a-a780b89ca10mr741615466b.73.1720804562658;
        Fri, 12 Jul 2024 10:16:02 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a6bc80asm360141966b.7.2024.07.12.10.16.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:16:02 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 29/49] libmpathpersist: skip redundant dm_map_present() call
Date: Fri, 12 Jul 2024 19:14:37 +0200
Message-ID: <20240712171458.77611-30-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240712171458.77611-1-mwilck@suse.com>
References: <20240712171458.77611-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm_is_mpath() returns 0 if the map does not exist, the additional
dm_map_present() call is not necessary.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 6da0401..5a5ac3b 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -185,7 +185,7 @@ static int mpath_get_map(vector curmp, vector pathvec, int fd, char **palias,
 
 	condlog(3, "alias = %s", alias);
 
-	if (dm_map_present(alias) && dm_is_mpath(alias) != DM_IS_MPATH_YES) {
+	if (dm_is_mpath(alias) != DM_IS_MPATH_YES) {
 		condlog(3, "%s: not a multipath device.", alias);
 		goto out;
 	}
-- 
2.45.2


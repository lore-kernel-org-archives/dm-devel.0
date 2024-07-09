Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1209185606
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561212; cv=none; b=eLb71ARyzSDqLqzrZSLA00jB1uCQLr620galqOs5qc6vCldqFLVrM+y6hWXT7ycek6YwyjuuSiJj6zWMZKSLZcILyeRz1jyKJlBk1ra9AaWCiuIZgkOQ7ypGOSeLpUzBnBV0Hq48H6LrZoLFn0NAKkd6uKgTgN8FCb7tCGlq4y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561212; c=relaxed/simple;
	bh=0Arq6FobvC/yg1NMVzOqfs+p/A5SaARA9LMGqdwpy3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mI0EpYqXrpXjED10VeNssdWdHHPc8v/oHIlmABJt3QMayKgNOwIdiYwxcmRAbu2l5KMLzbtZwt6d7ifVlO5yd0AevJI0Q3FFBXKxZqnSTxFAzCwhid6m0jdbCEiykZ8L5vBz0kZm3OIrkRlAokcb8jJLhYY88FxxrWPAEKpwtoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Im1u7hvW; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Im1u7hvW"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-58be2b8b6b2so7087226a12.3
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561208; x=1721166008; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nwlUJpYb6U4EqVvswuKJvgPSc9BM580QPbusVluxCK4=;
        b=Im1u7hvWFuRIiiAgrNs1tdq6wZ7N1q5q+UuNhzOSOBabImLUz7tVjo0AlotjjkecDT
         RYM9GHWcnT04KcybedHL18lgoThbYQWbbVyAFVFYNquO8FT6cIvZ0rdjT6t2ePXDXWXB
         sSjF/dI5T2H29AADqAoNFxNGFp07yRx/87JJgUemd8GXAMNKdK1hcP8IyRswCszFofDn
         ln7dmsK4UzW+pEjLVJiTMCNgDS8d31QI3BU5YPp2pv6dzbqgi81ebDUZ/tXW5RyJVxRT
         kjg8yjlIEn0/nBhakOSz7zvGZDf8kvDRfH6CT2L088w7wUfJ47+hRYfkaKe0TH8bxThn
         oAAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561208; x=1721166008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nwlUJpYb6U4EqVvswuKJvgPSc9BM580QPbusVluxCK4=;
        b=ojk8oAINQhRRSey9g7fKeO5kNeGl7mryaBcaG4yZP8kdrGNw1Ykk4as3WmgJjn405x
         K0UcHKJSfmlmmooORYTJdnTMbog1Xe1Z24HUsg32rSGtX3ATbGU6c/BKhAD919g8MW+8
         ZFpZLXS3WJnTOhm59EIv1Cq10qGkUSrJyhoYXzCtwtR9CVPRvmLC5zCxu4slt7nl1I27
         Dvungd7WkHWeB2m5/zmdjB9YzGixPqW8AhAeEo1L/1aFIAuH0IVBN6mOcMWw/vYYC1eL
         Wqd8auGbbJLAOIF05tAiX7+YdeAbwwQrZ5RXNwzJ4H6mKREqH9N5b8siHS7E2Eb6nsbP
         rvmA==
X-Gm-Message-State: AOJu0Yy4FHiQe6r6N2aThGz2Naq3931urmIchCuTKxL0ImOgOuWwngpy
	TSl+P1dvFqLCwLP9fLvS0SfSB3jVYkuUxYYvCoehCmwhkAitKBDy1tgmZ+2VqX4=
X-Google-Smtp-Source: AGHT+IELml/qlbbzJHhGC8gNgaJEQIhb8FW6m5EjnuL3qtFmHbxaSuWR9f2uq8eLcEHALNb1R/HPZQ==
X-Received: by 2002:a05:6402:34c8:b0:58c:fec8:1fc5 with SMTP id 4fb4d7f45d1cf-594bb580499mr2579874a12.21.1720561204626;
        Tue, 09 Jul 2024 14:40:04 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bb9604easm1485506a12.4.2024.07.09.14.40.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:04 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 21/44] libmultipath: is_mpath_part(): improve parsing
Date: Tue,  9 Jul 2024 23:39:12 +0200
Message-ID: <20240709213935.177028-22-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709213935.177028-1-mwilck@suse.com>
References: <20240709213935.177028-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use sscanf to make the parsing of the UUID more robust.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 56157af..d62a7dd 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -846,23 +846,20 @@ int dm_get_uuid(const char *name, char *uuid, int uuid_len)
 
 static int is_mpath_part(const char *part_name, const char *map_name)
 {
-	char *p;
-	char part_uuid[DM_UUID_LEN], map_uuid[DM_UUID_LEN];
+	char part_uuid[DM_UUID_LEN], map_uuid[DM_UUID_LEN], c;
+	int np, nc;
 
 	if (dm_get_dm_uuid(part_name, part_uuid) != DMP_OK)
 		return 0;
 
+	if (2 != sscanf(part_uuid, "part%d-%n" UUID_PREFIX "%c", &np, &nc, &c)
+	    || np <= 0)
+		return 0;
+
 	if (dm_get_dm_uuid(map_name, map_uuid) != DMP_OK)
 		return 0;
 
-	if (strncmp(part_uuid, "part", 4) != 0)
-		return 0;
-
-	p = strstr(part_uuid, UUID_PREFIX);
-	if (p && !strcmp(p, map_uuid))
-		return 1;
-
-	return 0;
+	return !strcmp(part_uuid + nc, map_uuid);
 }
 
 int dm_get_status(const char *name, char **outstatus)
-- 
2.45.2


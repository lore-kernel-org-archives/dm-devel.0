Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3BA18786D
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561221; cv=none; b=ShNIt/S/AmAy4CGi21oclNAOrkCOtFPJaeNenu86jqi2y2TBVC7/fnfWsSbvQdHNvWC8UgU1cGLsZDi4FTTp9BGzdw8xivVsiZM5oxaVPRX5+AlnMofRlH5PiIimU1BD5JPE3ziZkktKV7MCo623gZnnZEEsQOSjNJ5/TFaRas8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561221; c=relaxed/simple;
	bh=fOJbIB1pNrkQLn1AxpnIzmQp4W2p6uN2jofDD1UTubk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZEKQ1GDYxOw86MQjwMhCxqX5sr6XKABzWP1rRCygiz4aV1MOBcYFHmF+s8yIOOvRlhMudV9UwvSzfHhGff6+jXZ0Ldx/z0fmg2xCULG4919kkYsqqhSisOegxyOTludwrSh8xDs3F0iM0qgU9HZGxO053EJdIpFRjOLcPfiTwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cN8MUOgT; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cN8MUOgT"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a7527afa23cso711488466b.2
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561218; x=1721166018; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HbE+eXopTF594cdCh0H4gap6n+/IhdcyXeNl+LS0U0E=;
        b=cN8MUOgTjdBG32MQNaaurzWJ5Lqf8uEdj3KYlbvBoCK2HsjWG1wYAkzynVbrXxuB37
         kL6qctkXkfiT4UVZpdFiRZ2X3Y00i9nmOIKkFm6zPowFnOS1XBlnl89+TbFXfsH9cUhw
         ycnE7hSdHCAYuMzAo4SRZP7fR8v+GFL68Dmq7KCws4KpXomLk8Aypjq+Qqxs7Cbo5jea
         aFPafV1+gkGuXHAca6k8r/GNUSWUk1R6GlgUHGKPX9D3ZM+o+2b3DwD349W9SDuzyil/
         H0DC+d6d3t1f0YKQFitWdIW1VMsjD3ieB7VPGLrp8ht4S9jGC/gs4IMtLKPpjXftb2Px
         uwHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561218; x=1721166018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HbE+eXopTF594cdCh0H4gap6n+/IhdcyXeNl+LS0U0E=;
        b=YqCrJwUwSjpqfKPJKzwmmhVPEAO0iyBBKWzd7tOmBHkhHBDqrjVVb6QsrnzwzPDpo2
         18GsD93UNDcxKjajX2Ioh3yRyhxM17v3hoKvWvIPOjq8SMfHVPYuXQasIZP+kGmltTGG
         mNP06BPIKfC9iZ359jbJC4hPOEhEUkmgWZ2pG+jNKqCMmKL/l5JY0frLGiY9EdOpSR4D
         Z2xrVMgBh5gLgSMS5gQ8HuQar2+rtY+XVhleHHL5q0HZZbAMegIMGYPF79BfzCZ6b8iE
         sAi1tIhHVBcl37xENn/elRLRoApijz/Xw7fWfF7VM9E7PDvQJVn3XULQaGIrw4fhLqH5
         Ke0A==
X-Gm-Message-State: AOJu0YwV2ZsvXE+lwCoEiqdVNUaijSStq6jBhjTPpMLh9QjQlTMq5sPg
	ccnBXpPfRJ2gdV5yoOMyZBHIBfBBAdy0/8jHxvhFuGRHbnY6SYwRXn/rRRiFJZ6s9w/2PCkHrMG
	n
X-Google-Smtp-Source: AGHT+IHE4wcDDrbvEVwyBjKsQpRB/ePUw+/MfvwGQvMUjxRSB+UZ+Mno0po28RkVLH0bET6RsIP3YQ==
X-Received: by 2002:a17:906:f6d5:b0:a75:3c2d:cd8e with SMTP id a640c23a62f3a-a780b6b1941mr239214066b.27.1720561217748;
        Tue, 09 Jul 2024 14:40:17 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a6de20asm107381666b.60.2024.07.09.14.40.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:17 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 32/44] libmultipath: add is_mpath_part_uuid() helper
Date: Tue,  9 Jul 2024 23:39:23 +0200
Message-ID: <20240709213935.177028-33-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 5f6c0c8..d321041 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -860,21 +860,15 @@ int dm_get_wwid(const char *name, char *uuid, int uuid_len)
 	return DMP_OK;
 }
 
-static int is_mpath_part(const char *part_name, const char *map_name)
+static bool is_mpath_part_uuid(const char part_uuid[DM_UUID_LEN],
+			       const char map_uuid[DM_UUID_LEN])
 {
-	char part_uuid[DM_UUID_LEN], map_uuid[DM_UUID_LEN], c;
+	char c;
 	int np, nc;
 
-	if (dm_get_dm_uuid(part_name, part_uuid) != DMP_OK)
-		return 0;
-
 	if (2 != sscanf(part_uuid, "part%d-%n" UUID_PREFIX "%c", &np, &nc, &c)
 	    || np <= 0)
-		return 0;
-
-	if (dm_get_dm_uuid(map_name, map_uuid) != DMP_OK)
-		return 0;
-
+		return false;
 	return !strcmp(part_uuid + nc, map_uuid);
 }
 
@@ -968,6 +962,20 @@ static int dm_type_match(const char *name, char *type)
 		return DM_TYPE_NOMATCH;
 }
 
+static bool is_mpath_part(const char *part_name, const char *map_name)
+{
+	char part_uuid[DM_UUID_LEN], map_uuid[DM_UUID_LEN];
+
+	if (dm_get_dm_uuid(map_name, map_uuid) != DMP_OK
+	    || !is_mpath_uuid(map_uuid))
+		return false;
+
+	if (dm_get_dm_uuid(part_name, part_uuid) != DMP_OK)
+		return false;
+
+	return is_mpath_part_uuid(part_uuid, map_uuid);
+}
+
 int dm_is_mpath(const char *name)
 {
 	char uuid[DM_UUID_LEN];
-- 
2.45.2


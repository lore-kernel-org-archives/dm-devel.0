Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45A11E889
	for <dm-devel@lists.linux.dev>; Wed, 17 Jan 2024 22:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705531894; cv=none; b=uR6GAGUIdZ9Z23qMqEhE+LA/Ry/IpJuTwGnBIbzqSvzR8Epuj4tax43csJp9GmbEObahQo38rH5FJ+FI5jG3yw4HDPFuUsyYjWImmFD/6aBLakIbEiai5PMpOPCmKWZxyd+fCIP5p7OicogocAcfyxKvq0odWgsj2jDW9km9i7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705531894; c=relaxed/simple;
	bh=LNM1suIJHAziGAW09AfMCSecP1EWCk4HykV6ezwO3ew=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding; b=CO6pgrjbb4x0lLrZF5l/+MUQdIk1iZzjFuEz8IgKVOqaryZxhwJq1srD6FPGXye4UGTMgNoCYp0HP5o4iTBAzqv/c7cflrxYiS9sTXx9/r6OtOnV7HIaPi7Lq1g1R+EDbJPYaLrpEzy1VZF0FcmoRPBXJvin0OqEN8DJDOnwrxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Q33Fl1ER; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Q33Fl1ER"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6d9bee259c5so6819845b3a.1
        for <dm-devel@lists.linux.dev>; Wed, 17 Jan 2024 14:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1705531891; x=1706136691; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7vTgeIRkgSab6s1qP2tEbaKLn3w0odGN6BwuuHHwL1k=;
        b=Q33Fl1ER9oYxCAkHLsvYhaRQIbTYYmsZBMLtICDXNcD64stejj9NroQhJQfnWKGZKc
         fZHJnq81rH4/IGIAQsGLNwmMqTHvX14SgUA60DXxVGx0NVKjS47fTQJfmz70vUKKxFDT
         Tsf++eXAsI2kPTIIBAVT5sHo15UnZagGrBhe5U84wvdJJUWVCfyivoeJeazDjTi9mEIY
         Q6u9f9rdsMmNZ3EI4zm7cvO1KakPCKTDXHzaKypCrsvXgwtoJsZrXuMwJwJLry8t5ZVC
         wY4ND7tdXHIo7x5MQgcCGuCrlHKIAI1OnOyqbD+m+5F1iHbERke4p78vU4IeH/EQ1avQ
         S8GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705531891; x=1706136691;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7vTgeIRkgSab6s1qP2tEbaKLn3w0odGN6BwuuHHwL1k=;
        b=YfnhGQSwdjBhGNpXRUDTr+1TY7yVEojNNgneJoK/wLTtHJyvK/gLVmSgsKxqIbAbbT
         tGDtlKwbmiSwknEdGV9CryOzVgzL3wH4y3QiIJ/82LBIBA0axgbCTqT/NDXozlGIJXwf
         sNokQaqwGUpLiFCWFS2OcAvLZMCEcc/xoNSKYEwvCHvxGP3UttN5aN2TXoNnxpA9opSN
         rCA54WOjcCaHCO0ms7mPZJfW5FRYsMx65WJHugP8wlKznKd6dsw31qOS2I/+eT4dpCRk
         1ibBovirFnddVC+KlYQBFTgb/4K/U14+x2QyzDOlijPusqxL18ctDkiVWKnuYroXFHOJ
         vhaw==
X-Gm-Message-State: AOJu0YyAAJM0lmfZYkN+jQ7Q9qtapf3rSnTXjYBHW9MjMse1UykBR8kS
	+YD8x2tFk1KWcPylnDLyT81unu2m+7SQTlUVpeMI4wTlvdeofuuDDdyGs2iwtmkTgMMXc+1txb5
	5+xv5jDJo6Y2s9SabSvG3gi43hfuO3iX2TvjQ0X9OckWaGb82eEf16e3rloWHiPpt7TDi0dAhCZ
	8Kbl+Vfw7EtIKomg==
X-Google-Smtp-Source: AGHT+IE3bTx5xT3lPk1nQ6t+bd57aNWe18H2cUUXKDdGKvcJs6exWcOz4IR079NDd1MguV8QBv8ESQ==
X-Received: by 2002:a62:cd04:0:b0:6d9:3b54:b37a with SMTP id o4-20020a62cd04000000b006d93b54b37amr5534335pfg.1.1705531891089;
        Wed, 17 Jan 2024 14:51:31 -0800 (PST)
Received: from brian--MacBookPro18.purestorage.com ([136.226.79.24])
        by smtp.gmail.com with ESMTPSA id v2-20020a632f02000000b005cebb10e28fsm178642pgv.69.2024.01.17.14.51.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 17 Jan 2024 14:51:30 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: Brian Bunker <brian@purestorage.com>,
	Seamus Connor <sconnor@purestorage.com>,
	Krisha Kant <krishna.kant@purestorage.com>
Subject: [PATCH] multipathd: the local path change is not considered
Date: Wed, 17 Jan 2024 14:51:10 -0800
Message-ID: <20240117225110.50072-1-brian@purestorage.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When update_prio is called, there is a check to see if the local path
has a priority change. Then all the remaining paths are simliarly
checked.

Only the result of paths not matching the local path's priority are
considered in the calculation of 'changed'. In the case of failed paths
becoming again available this can lead to multipath not reloading.

The result will look like this:
3624a93703c9f34490f6140a100011010 dm-2 PURE,FlashArray
size=3.0T features='1 retain_attached_hw_handler' hwhandler='1 alua' wp=rw
|-+- policy='service-time 0' prio=50 status=active
| |- 1:0:0:1  sdb 8:16  active ready running
| |- 9:0:0:1  sdc 8:32  active ready running
| |- 11:0:0:1 sdd 8:48  active ready running
| `- 13:0:0:1 sdh 8:112 active ready running
`-+- policy='service-time 0' prio=50 status=enabled
  |- 8:0:0:1  sde 8:64  active ready running
  |- 10:0:0:1 sdf 8:80  active ready running
  |- 12:0:0:1 sdg 8:96  active ready running
  `- 14:0:0:1 sdi 8:128 active ready running

Where the path's priorities are updated, but the path group is not
activated.

Signed-off-by: Brian Bunker <brian@purestorage.com>
Signed-off-by: Seamus Connor <sconnor@purestorage.com>
Signed-off-by: Krisha Kant <krishna.kant@purestorage.com>
---
 multipathd/main.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 230c9d10..62b87bf8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2127,7 +2127,7 @@ int update_prio(struct path *pp, int refresh_all)
 	int oldpriority;
 	struct path *pp1;
 	struct pathgroup * pgp;
-	int i, j, changed = 0;
+	int i, j, local_changed = 0, other_changed = 0;
 	struct config *conf;
 
 	oldpriority = pp->priority;
@@ -2138,8 +2138,11 @@ int update_prio(struct path *pp, int refresh_all)
 		pthread_cleanup_pop(1);
 	}
 
-	if (pp->priority == oldpriority && !refresh_all)
-		return 0;
+	if (pp->priority != oldpriority)
+		local_changed = 1;
+	else
+		if (!refresh_all)
+			return 0;
 
 	vector_foreach_slot (pp->mpp->pg, pgp, i) {
 		vector_foreach_slot (pgp->paths, pp1, j) {
@@ -2151,10 +2154,10 @@ int update_prio(struct path *pp, int refresh_all)
 			pathinfo(pp1, conf, DI_PRIO);
 			pthread_cleanup_pop(1);
 			if (pp1->priority != oldpriority)
-				changed = 1;
+				other_changed = 1;
 		}
 	}
-	return changed;
+	return (local_changed || other_changed);
 }
 
 static int reload_map(struct vectors *vecs, struct multipath *mpp,
-- 
2.43.0


Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC11B1B392A
	for <dm-devel@lists.linux.dev>; Thu, 24 Oct 2024 11:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729767876; cv=none; b=nHRqUks7iv3mRU2C5Kg/RrsIFlMJkAgktAHVSF/BBYOyZNivuhS6h9jwVD35EjqqwH30TySBWV/QkKHZNEGfS54OXDy6KBZC88azYIzDGApb3sl/iA5B1hf2ffPr//2/v9LjlvNeKaHpGt4orYZ58GHivlWdAZeXfo83/g4RIaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729767876; c=relaxed/simple;
	bh=iqUHT538y1XZ2FPWcMn9nqaJe+HywOwuSLzBsMlplkc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=HMRKN1++6O9HoAzhq+QFgEhrgoW75uYspOwCRNjfSj8S5t+PtecLDJZGsyJ+eAkOl+6qWqMJh5kcJFHuWC4tnrZZ1Cms9oAQqwbZU+2dvshWtl46uDjtaykigiI5WG0ZX6FDy+OEMBCFWZcOW+u7p8f1Y65WbOtr+q6lfiU7kDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eVEebVxa; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eVEebVxa"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-37d3ecad390so1364864f8f.1
        for <dm-devel@lists.linux.dev>; Thu, 24 Oct 2024 04:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729767873; x=1730372673; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3Hp3MZ2J5nvjPXe4owm1R1USO0JqDtTZ1bRIkLYYf4c=;
        b=eVEebVxaRLGGaCYD6a1bxzS8SLs3tE26yql+yt1eQt/LtPnfp1mIXcrRqIJSSYNTUZ
         La75yZqKgSGRm6Mt1/qMVGzr1ZbJ1xCd7IO7ZDhFt0qHa3FRRrPhG9HauTn+K+LSuJuP
         IoQmg76Qtljd2k9C/1Q3sK2rMZwXJVgneh0BZMnbJQQOpQYMWU1qqsRgX6HPKB5xD6d4
         LuKOYuBYPoYb7yDGcwK4r2Cq92z2FSSzGwk/Ufp2BfMXwagyQGmg2SAmLXs4R4Yhe/9d
         HDSHnpnulr0E3mDNT0nOTAuFfeei0ezRdL467eCEhix8YP8F1UiaHP0QHMGDvY8dwLKp
         7rTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729767873; x=1730372673;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3Hp3MZ2J5nvjPXe4owm1R1USO0JqDtTZ1bRIkLYYf4c=;
        b=CazW5Z+7QsLUKbccv35W0AXPimPn5mJYO5bJV+zY28vmWROyj9WCPh+jjsIwje8US1
         E9cW5+t75r1m5HBUD98VvDCJWRFnnVBhaX1wjppRGlYduAb+GiqtF3tAiePu6gbxRvxQ
         de963/BWE+yec69hwnUxaD/bTO6HGyVkh0eQ3MsEJSuon7pLWVdq9xZqAvj/U1Mt3L0s
         v7njdKP/MsipQrgnetAZrF+vLPAk6ibAlu7kH4gJA88KRMS1jZMgXIQ76h8cMGdfIuDB
         DiVmrIlbGntdlWAcCsozGZNs+EyMVWg0wVExSB2wmyH9lh19c9OGangIiF5mpb/NlMot
         6sCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUD//owiEwEFT4Qk1b1nItBrUTY1HzySABAKPE1ak42LxeYjHMDZLRtBwD5L+vJ525ysHLTkvP9aQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwnzkngLYpVh7zQxOVV1Lg2paZGZSg0RTLTqOoNo+WA9PKfez6Q
	uwIMKxR1CgqyOrC+0lAmI2TCC8tLp0L9TdJpu7w8CFclegcIq+LN
X-Google-Smtp-Source: AGHT+IHvwFm17skStNFtAvwBetWlAr6wTNMIcnXZh06SN4NQvfSTJYIsr0Uu7Vb9CZ6jFfl6Ufp29A==
X-Received: by 2002:a5d:4fcb:0:b0:374:c33d:377d with SMTP id ffacd0b85a97d-380458812bbmr1052145f8f.28.1729767872710;
        Thu, 24 Oct 2024 04:04:32 -0700 (PDT)
Received: from localhost ([194.120.133.34])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43186c15684sm41770165e9.39.2024.10.24.04.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 04:04:32 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH][next] dm ioctl: rate limit a couple of ioctl based error messages
Date: Thu, 24 Oct 2024 12:04:31 +0100
Message-Id: <20241024110431.1906858-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

It is possible to spam the kernel log with a misbehaving user process that
is passing incorrect dm ioctls to /dev/mapper/control. Use a rate limit
on these error messages to reduce the noise.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/md/dm-ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index f299ff393a6a..d42eac944eb5 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1912,7 +1912,7 @@ static int check_version(unsigned int cmd, struct dm_ioctl __user *user,
 
 	if ((kernel_params->version[0] != DM_VERSION_MAJOR) ||
 	    (kernel_params->version[1] > DM_VERSION_MINOR)) {
-		DMERR("ioctl interface mismatch: kernel(%u.%u.%u), user(%u.%u.%u), cmd(%d)",
+		DMERR_LIMIT("ioctl interface mismatch: kernel(%u.%u.%u), user(%u.%u.%u), cmd(%d)",
 		      DM_VERSION_MAJOR, DM_VERSION_MINOR,
 		      DM_VERSION_PATCHLEVEL,
 		      kernel_params->version[0],
@@ -1961,7 +1961,7 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern
 
 	if (unlikely(param_kernel->data_size < minimum_data_size) ||
 	    unlikely(param_kernel->data_size > DM_MAX_TARGETS * DM_MAX_TARGET_PARAMS)) {
-		DMERR("Invalid data size in the ioctl structure: %u",
+		DMERR_LIMIT("Invalid data size in the ioctl structure: %u",
 		      param_kernel->data_size);
 		return -EINVAL;
 	}
-- 
2.39.5


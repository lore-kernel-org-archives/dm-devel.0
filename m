Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155021D5ADC
	for <dm-devel@lists.linux.dev>; Sun, 10 Aug 2025 11:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754825440; cv=none; b=bjznhg1xPOzmTM+YTnOrPkb2emQDEunk6iCC5hRVinxq/C57Mumz8ktQxwhOXUQjI5bBs2Etoy+NRyVPzqzi0tlenUZ6ZgkOznKoJFQILt/ZXzZyrRGgFFwjcneaNHDR4l1dgUoeXC/gUvq0LIzMqklpkSlB9zfeirdiQViBb0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754825440; c=relaxed/simple;
	bh=hQFUiJVkuiVnyTmM+Fv5SEJ+oeDwsytX/0vH1GdXtNY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C1sImK5/92vWijJr1vFopjveMWplZm8NIBB+Kt3F8VxCTWT2KLCA9kyvtuPzWYGYgZxMoBxlpVSg4hhDD9flqKjpWyUMu+DrUq5qZFKKAI/qXpzS//wzVLJnLSUqwJdyXwSJWa1Np75HUKIuUHE4ReFZmgf8OkY9HZ78voHLHiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mnq/xueD; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mnq/xueD"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2402b5396cdso21713835ad.2
        for <dm-devel@lists.linux.dev>; Sun, 10 Aug 2025 04:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754825438; x=1755430238; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SHl5buntrPd4REBXQ/H/Xwm8L4W6B7MQuY5lUwVZl88=;
        b=Mnq/xueDCx6K7/sHG5IyJseeDZwAkn2OAdQ0t0QBiNB6Y95ls5Srnq1xG4B0qNRbMo
         4Za7gV72ZDFNDLpZyfkqiQ9op/Q/+bJr13pPSmzkjbxVVpj+DPiXO2Rw4dtNPFeZo9B3
         EVfSpToWU+Sv80T9Gb4An5KNCRP/UmdhKYZBBMAv4zgAAJ5N4ZpomDxPtRkOBU8obKU9
         QQnOLXbZzJfH4DJzF36aimzrv3QQkF4A0D0s0/VI45OjvrzvjTf0kROiuMktbycJGvX5
         UMTO5uruG8cyH6Bpc2AyYL5Y65ppqvDCKqDTDtH21pZY977lwaqQT1BvG8/dEqVqWfFc
         B+TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754825438; x=1755430238;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SHl5buntrPd4REBXQ/H/Xwm8L4W6B7MQuY5lUwVZl88=;
        b=b9W2hcx+pH7XiLH2im2ZuES+tHM0rtDDdjuTvu9OpgzIKcomhYqKttfUFnj5sBv8k6
         UNbHTSP8Ipr19c9KOYbUNAaYHYdAMtgHgSGb/aQtYbTFrG8IQKXHWi3zO1q3UEjR4XtH
         uyskf7ZIQKuVxwuP20K5mwvRWDRaA/cbteqEf1iNBvOCHvJCgyLECYAbtea0+JAxqr8R
         l4JKuFIBlNdzX/yQqNVPVZQ2HnjOJC03nvTJVD/q5EUb9uh19kymKk0/GVrMYFSH3fDS
         Fa04SrjkHFiaOwwuHNoJ9Q1IgGJ9lcaA6x9eWNcEWcUk1KqKe/du0ND4j8pMB5UGYMPO
         zeHw==
X-Gm-Message-State: AOJu0YwGmZ/YpUS2Oh3OJNUSXl2dkceWLk5Ro6JAxMsQgphWxF7JTOo+
	eLnAb+Lep1GZY7tzyDpY46feaIE3mkGK2jxlDQZdY+HKLCXEWImp8J3m
X-Gm-Gg: ASbGncugvJohb1n71bHDPapXVHBv3I2b2WWRHTpAy9d790phtru+YPf8V3jLjX0JGKD
	gYL64wftvJJvC/t/nAmMW/49eVer971t5ZPQQG7dpdUqYG0elneMW44ickLGltynjDpOCekxTx+
	+WNw4ld/MyjpBrcUqvoRRmp+OEtW/pPeOqR1neDYdE13z0t6ffxM9MKgNrx2H5AEVT1Xyphkq6k
	2FDilEX4d+3z+7r+8ubKFt8lJxRQ2awAMGSwiuLJlPMy0/eR+RK6bFPC2vnMFaZfZtdKzW07DvE
	S6Y8m9P5x3jj5zJXx8sMq+m7X8LU+3aMrH414MR9AlAOmpIeC9q/oPMC4aUPICze4pLuG7E+R1h
	JiFq4p4795VAGa799jReP4Md5ASZdQZFSDoCxgSy1M8FGhDTnT/KDoyoftl40
X-Google-Smtp-Source: AGHT+IEddxsLOd/KSWuIkQ8MPbH9RPfw7fHsY7z+FeE8UayyoT0bDzrRE1sn5q+TZ+gTV5c17FWunQ==
X-Received: by 2002:a17:903:41c7:b0:242:b315:ddaf with SMTP id d9443c01a7336-242c1fdc0a3mr168124875ad.7.1754825438182;
        Sun, 10 Aug 2025 04:30:38 -0700 (PDT)
Received: from shubham-HP-Pavilion-Laptop-15-eg3xxx.. ([117.250.157.213])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef5934sm247615075ad.21.2025.08.10.04.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Aug 2025 04:30:37 -0700 (PDT)
From: Shubham Sharma <slopixelz@gmail.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	corbet@lwn.net,
	msakai@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shubham Sharma <slopixelz@gmail.com>
Subject: [PATCH] docs: device-mapper :Fix typos in delay.rst and vdo-design.rst
Date: Sun, 10 Aug 2025 17:00:08 +0530
Message-ID: <20250810113008.27381-1-slopixelz@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixed the following typos in device-mapper documentation:
- explicitely -> explicitly
- approriate -> appropriate

Signed-off-by: Shubham Sharma <slopixelz@gmail.com>
---
 Documentation/admin-guide/device-mapper/delay.rst      | 2 +-
 Documentation/admin-guide/device-mapper/vdo-design.rst | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/delay.rst b/Documentation/admin-guide/device-mapper/delay.rst
index 4d667228e744..982136160d6f 100644
--- a/Documentation/admin-guide/device-mapper/delay.rst
+++ b/Documentation/admin-guide/device-mapper/delay.rst
@@ -18,7 +18,7 @@ Table line has to either have 3, 6 or 9 arguments:
    to write and flush operations on optionally different write_device with
    optionally different sector offset
 
-9: same as 6 arguments plus define flush_offset and flush_delay explicitely
+9: same as 6 arguments plus define flush_offset and flush_delay explicitly
    on/with optionally different flush_device/flush_offset.
 
 Offsets are specified in sectors.
diff --git a/Documentation/admin-guide/device-mapper/vdo-design.rst b/Documentation/admin-guide/device-mapper/vdo-design.rst
index 3cd59decbec0..faa0ecd4a5ae 100644
--- a/Documentation/admin-guide/device-mapper/vdo-design.rst
+++ b/Documentation/admin-guide/device-mapper/vdo-design.rst
@@ -600,7 +600,7 @@ lock and return itself to the pool.
 All storage within vdo is managed as 4KB blocks, but it can accept writes
 as small as 512 bytes. Processing a write that is smaller than 4K requires
 a read-modify-write operation that reads the relevant 4K block, copies the
-new data over the approriate sectors of the block, and then launches a
+new data over the appropriate sectors of the block, and then launches a
 write operation for the modified data block. The read and write stages of
 this operation are nearly identical to the normal read and write
 operations, and a single data_vio is used throughout this operation.
-- 
2.43.0


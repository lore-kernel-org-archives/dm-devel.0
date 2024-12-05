Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7F617E019
	for <dm-devel@lists.linux.dev>; Thu,  5 Dec 2024 22:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733438964; cv=none; b=ItngX08wrnk7A3vvqDLbCOEZwsa0oBgSQFa03WmqZoTwZCX85RFqcT4xai8Sln5WEoqDxdRATL6YqV6XLPM2qlRNqzVEVULb4laRKgYiWMIC16N4L7ee+WO2P/kM2Mhdjy9rpvFd8hUk4LWz1y1A8Wf9UP3qU5CQJH/x7vUg8CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733438964; c=relaxed/simple;
	bh=KPYr0d/r+laJLbpzq12KsWqNF64bPtxBd8449aWBGDU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yo9cGRNpefKsbNxAbkioZuW3cDCJhKSHc/uMAFIH+4xt4sAU/ET+ofzkopQicm9i9DJmpbjvgjEdgC2KxWgVKJvpQGppPKQJxSGFoHUTVzQg5HdNwK1ohvOUmwBLnLlifevh6xx4dqI89/F1sufXZaFSsLP/SDWf4pq8u3jM738=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U8naZ1NX; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U8naZ1NX"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-434975a1fb1so1089965e9.0
        for <dm-devel@lists.linux.dev>; Thu, 05 Dec 2024 14:49:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733438961; x=1734043761; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6zddE+hE7rYLHdFj9R2vm3+vKIrOud/yG0pkf9gwgRw=;
        b=U8naZ1NXLeugJ5LBRnCJ0T7R1qEbUnAlik6RJwlvuXazlNrY6cXxNSHhyQGu7ErNLE
         hMcV/88hAT+LkZncnekt4V3MRFJKa3E3xCzwBI0dHLi4WXDcfnGILZL7KW02YtH9o6Mu
         O9l4z6x0VQVDZlswzav8DiDNZBKLcqghDhFkkHI8jRFczqo83+HEoseswo2LxDybSwgp
         g7kCCgopZI9D0rAOfzCQ2+IcbWBAkRdjHrX5R/ht+vWlFnaJ86lxt+p8+LKMDnwr3+xK
         JX2Atj9qEkAmOBFm37Z2hBkarqzUGWjcXpaF5umZsLGSGl8ehK0wa51KGP6cOOe2o3IG
         5/PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733438961; x=1734043761;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6zddE+hE7rYLHdFj9R2vm3+vKIrOud/yG0pkf9gwgRw=;
        b=QW6zYjqE8tR/f/7ep6ruxzMh1dK/NKvcRN8uiJBqDQk/m/7XRBDmFqksiyHRhzvOe6
         A+Uzwdkbeaql6S1PYwFvpUZlIWuPXQAvkoFfzn+6VqvkBWWbviQhW9c9YjB2bYKuLL9x
         6tNasSr0EIVVOlzPKQnQ2IUPBGIGDEhFaCjTXg2v+GeQXN4ql+mo5tQGK9XbbaVEzIkC
         T1RsOX0UqEbNsMJ6SnvWotjLMy75YfogjK+EZ1TeKtdDyk4ZiITp1TrdxalCKTTro19/
         lIxPSsfdqZ5AV68XYolo1Afzo5CCltrDxSHBlpj6LDbsXHw+vXID60g4wyZD4BKzZp/w
         YkxA==
X-Forwarded-Encrypted: i=1; AJvYcCX7dDhkm3pFeLfh3Q1Mtk/jaa0KTwyz7BSZiZtizHpVhpeyIim4o9KJavvTB6t/y05xiuSAlPO2wg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxAY/4mj+H1FoROiZlFacwX/nD9fsNwA8s6KWtarbzcHfLTVs0a
	SYXLsAtn4MwDiHdegUPgQWS9z8a3ZJ4iE0rCnFETau642Zd0RWU=
X-Gm-Gg: ASbGncvTx0TSIX2N7YVrpaoik0X9oj6T0dDqh5l0oMb+lorqYSv9zDIXe+BXRAgSqMA
	YLfuDG36oeoUpWtRleFcLbnljwjSqEjdGLQ7jARnV8rMJOwSb+JxMWq7F9a3cdemfbtHApbcqWx
	cokDwlPI4s+buq7ucMbkWc40+i5JJqmrH02BZv0spcgUVrHrQTinpGBUikWDbElaYdrkVG3sU1h
	kjwrR4QlYCFOU+9QXyyloWuFIIipLuKr25LwkCR175n3SU=
X-Google-Smtp-Source: AGHT+IEmvjRZ3geGrBLX390TQcbkhY/NjDiPXdSdPn1XwXcSVPMadl16gx4neX4lAEZnBEJ8gZx9EQ==
X-Received: by 2002:a05:6000:144c:b0:382:4b5e:5244 with SMTP id ffacd0b85a97d-3862b37c373mr223068f8f.7.1733438961000;
        Thu, 05 Dec 2024 14:49:21 -0800 (PST)
Received: from localhost ([88.27.111.29])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3861fd46870sm3061753f8f.54.2024.12.05.14.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2024 14:49:19 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Jon Paul <Jon.Paul@hpe.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH RFC] multipath-tools: add HPE MSA Gen7 (2070/2072) to hwtable
Date: Thu,  5 Dec 2024 23:49:16 +0100
Message-ID: <20241205224917.7104-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

https://support.hpe.com/connect/s/product?kmpmoid=1014856412

Just guessing, confirmation from manufacturer is needed.

Cc: Jon Paul <Jon.Paul@hpe.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 32118339..543f0bc1 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -188,9 +188,9 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* MSA 1040, 1050, 1060, 2040, 2050 and 2060 families */
+		/* MSA 1040, 1050, 1060, 2040, 2050, 2060 and 2070 families */
 		.vendor        = "(HP|HPE)",
-		.product       = "MSA [12]0[456]0 (SAN|SAS|FC|iSCSI)",
+		.product       = "MSA [12]0[4567]0 (SAN|SAS|FC|iSCSI)",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 18,
-- 
2.47.1


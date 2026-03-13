Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E872DAFA1
	for <dm-devel@lists.linux.dev>; Fri, 13 Mar 2026 11:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773399626; cv=none; b=cmggCdVD6G8tqGrYKQn90ZXHaYqsXJomhTWPc/zRT4KDjpfY6Qsx9bfF/J7tOcVU6IA7hnZT6nDI4uPSYMpDSHNroy2gALNIA+faj6p0B0CUq2zAip9v3f+CeDjk8feZLRrnthAx9y+XSi0dQgpPIzZgl7oC3AxCmeSy3FIPnIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773399626; c=relaxed/simple;
	bh=YqrUXYPNdcwykalWJw5ZFwmwDyr2mFKRE5z+MNv+vU0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KMQ9EpMUaUfP8nXGd5YXZWfoGNJGuHxEf6GhBlS7TjVZsXVxPNw/JSbNMTZWIUVaGFLlcuMcyC0go1eB/vo9qg38TsYJ4mODFxiO7vL4Utzsj8JmPVUjXNaV/AADKmgQoup3FcYYtF+m7dMgt0kq9yl+n+0QKXqCBmGqk6E30co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TIGDv19+; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TIGDv19+"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-439bc832351so221504f8f.1
        for <dm-devel@lists.linux.dev>; Fri, 13 Mar 2026 04:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773399624; x=1774004424; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZW2xxk8nHJa1jTbClCFKncmVuUtOab6WRc6EA5/ajpY=;
        b=TIGDv19+fDHInCkYU1MKZJAyUOBIdUwUXXK4dTJ+qzmB8GwMDPFXtymCRxLbUi0jI7
         AqPGm3tizQUrzlbNKLqzuECwvxExz3ipMgKNoOY0j1ocMtle/EtC/V4cTWkoar0NanVq
         +32HjmEfIXiWeIihCAoi8PVTmNvp/wmxvzJ0cW1dP//9qExOsW3+2LoT8atDkdPtS4g7
         SC55oTUYrPTUkcPPwSWgC0CPqU9ERube9bzmv7pfzKzBgonU6Dx8kaYF6ijVa/YnsGnn
         kW1BQWKLx1E08BYQIt8j2ZJRHfX5AEHTCS+6vk+4676pU5PN3ULtkD6Ym98fa/lTzSdP
         xPSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773399624; x=1774004424;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZW2xxk8nHJa1jTbClCFKncmVuUtOab6WRc6EA5/ajpY=;
        b=ryChSYNQ98fE7TKc87vVQflvdqGu24WypJPAusopK8PjyClvEEhHRcTZDXluSON4t9
         fsW5TrjYrPMV9bGqWM/uxSaCrD3M/uCgoUl93LV3iGxNbmsEu/69GFnMMEW9wyRio8y3
         K4/sQsdPHeOVAu5OAncHCynPUurTo0PdSDHsHHefmjmkfT4Iu0t/ILOXrD2iexT+bGDZ
         V+q+BsJLztAXQpX89qgH4lY8Y1zkz5MpbK6ApR88Pfo8DVcnFnjcQzdc2JV29EyHjMFr
         VhzZt34z1JKghhyLWn+a+fxEIWlCdwfGgHO+4y67icmv4zoVeVT9nyCr9Scn2UYserp4
         Loxw==
X-Forwarded-Encrypted: i=1; AJvYcCWkQ1oONsLWrzURT00Vg7VDmwi2USBkhW97SL5EVWtSPkcURsK5v1T+AwL0wlTl5H2P0B+WVnVnIA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxP/ZxNDymVKGXYQyN6F8NvpGXeCHoYOGAsnqZf6x0u2DoNMzl2
	msPV50utr1Cdv3H98mig69u0lohlenTd72pVA78DIcVswBxY8ANwGGc=
X-Gm-Gg: ATEYQzxipMQ/oBSBmrouGkjMA3uktMyX/mqX30trPIh0G+4b8VE/a08Hrsyi3iRJ4uI
	xigrXTL/xdv9TcxbReVGXJhAahRxhRh74jXXCEb8ywHUdHfZHGM5HYR2AqJogw74f7Rr9n6z+89
	I3l8ozFl1s9Q4Hj8YTDTmC6BnDae8yQM2RZCsO0bGkQgqPkBTSj/305vhX4LHNCZHoHONt8EYwL
	D3fnOquaaCAY9TZBrxFGmIidRy55MvvbcpOO/FisL9QIy+Mv5SoBUZzbK0WrKiKx6ndkY9oTfLC
	wVWDaK9tNxLHjlvKvBccCZGCNthsF2OfLOb9NPEmVIW9OWpxtE9NjonYdL5R8rvLNhSEPesoUOh
	W2wJRdS/gQp54DXzQWhgk4Td3Vu5Gk/7QoQstBHjBz+JnRp9POeFBfx69GchM1znKSQbm76MFU8
	dTNJWAz9e2rWlCDpwgrKZKlGx+AK7BJW0HXqIjhtVL09h651hzSdKbIO5kJe8C1r8t4IcVhGmhI
	Yaf+Q==
X-Received: by 2002:a05:6000:1845:b0:439:f55c:b577 with SMTP id ffacd0b85a97d-43a04d79be7mr2968672f8f.1.1773399623356;
        Fri, 13 Mar 2026 04:00:23 -0700 (PDT)
Received: from localhost (219.red-80-39-142.dynamicip.rima-tde.net. [80.39.142.219])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe2186e3sm18943658f8f.26.2026.03.13.04.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 04:00:22 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>,
	Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
Subject: [PATCH] multipath-tools: identify the hds.c licence explicitly
Date: Fri, 13 Mar 2026 12:00:13 +0100
Message-ID: <20260313110016.91868-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

ACK from the Copyright holder.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
---
 libmultipath/prioritizers/hds.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/libmultipath/prioritizers/hds.c b/libmultipath/prioritizers/hds.c
index 212301ea..70eaa8c0 100644
--- a/libmultipath/prioritizers/hds.c
+++ b/libmultipath/prioritizers/hds.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * (C) Copyright HDS GmbH 2006. All Rights Reserved.
  *
@@ -60,9 +61,6 @@
  *           not work under RHEL4 U3 i386
  * Changes 2007-06-27:
  *	- switched from major:minor argument to device node argument
- *
- * This file is released under the GPL.
- *
  */
 
 #include <stdio.h>
-- 
2.53.0


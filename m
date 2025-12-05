Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C6E326934
	for <dm-devel@lists.linux.dev>; Fri,  5 Dec 2025 11:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764933038; cv=none; b=QGwTiOBrwlclMVQCblv8IluSBHcRPvTFxh6LLs/oZacO/Y5P6So7IDNbRBHWRo3l1B4lZatAJzNrAGo+W5XmCGxctGgFf2CzH8xI6fmK5H3do4pvrQD1EjTaUvhKjO/hXJ3/ARfqTtVL9T/mAuUWdbSXD219EyWZ1Ii387zLFqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764933038; c=relaxed/simple;
	bh=FIqRbn0iSd4HWbkmd2425iWGFEgDgReDrwM0rbsXrfU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=lQDGCXpXzHyy9a4tMK9ctDQPfXsRR92gq7PG5PdiUIMC6DSR8VsGzIM9snr7ciPqd49hNje/8Tre3Wy5pADtO3mxvl7S/CJMyBuoB5yfxNMWzusYPa9LvKs/k9RwqsrNKl4+K2bii1dVU2XCw0ST5lA/YtRxPU6CdwPNZ6ohPv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TtJ6Zqip; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TtJ6Zqip"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-477a219db05so14052195e9.2
        for <dm-devel@lists.linux.dev>; Fri, 05 Dec 2025 03:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764933028; x=1765537828; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A2Dv02xDxln81ZjHynp+AfkUOxA71nmnU4NFvPsIXnQ=;
        b=TtJ6Zqip1CYRm+Qv956GGQqlVMYECIprNVX7sIuo22ylcbcqg2ukTjYGf+v1DbxkdN
         G2cAZVKijfhpk9fmw+R+jd52qaFSLBz7MPYaaCut88U2c1cBNpBkvwJljGfuWxn+Vz78
         9bXU96vu3C9WTlg21+XXtuTBngjc2+Jc9j9UrfbiIXMb4BwEmKXUOdvfJ6IvlnQ9wUsG
         MnC5h7AalcuYeBLVXt5Mz2SKbU1Inaat+SYIh75xB4UDwHZZIZW/J4Q4uHCTQYJl4aBS
         Ik6JrPu7EXpKynPjqZKy5F3Qvk/NF2TqZBYuSGE9bjrbrrlW2vwyCKaqn7W4Rmowh6U6
         55pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764933028; x=1765537828;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A2Dv02xDxln81ZjHynp+AfkUOxA71nmnU4NFvPsIXnQ=;
        b=bSjH8KtuaUYCNq5B1f+ZT1Q2XCHfeY5owUXCQeKQAxri6eqhVwEbAYU1H+BbtgEnn0
         BduBLnsUBa7xp+OckVyOJEINnuGTtvEAP/TEnm4XMC46KueYKtCafSmyAk/K19/K1J5u
         AZZwy4ri6mRuHWkGZ/zuadkFKCESbjF8UCahQj56G1AsF0ZdHpWUwSzDCOhVH4CExH5w
         POIKEmH6akYPbRx2m6cBC9ynlDJBbsXtH3diIEUHWfpiuBoBv1/EYtYjp0FW5MApKCUM
         14O0LJO5uiObHVWHuKZjlIX9R7VVxSnafNOkmyMgiGcBN1vt2sqxHpICTYgJ8dQSUGVi
         72OA==
X-Forwarded-Encrypted: i=1; AJvYcCVsV+GsOmHxklowflVPlCv4U2sGWsU0hbel0Wtkezb81USv6OpHgMaybCYTcFJJm4GxayhcVdG7RA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxj+dv8kXo9fhCZYH+peXntuZHKa+YfUY6MwY59bty0S0cpLzHE
	oYS5a8Z3JuCbcFBBJKvB5EFQJZSrR8c7HvCS6xeOWWbn0k3BdGpkz3eJ1i6TJrCQ6/Y=
X-Gm-Gg: ASbGncvdY7ViuD70bjghksv5jRnbvrQ2nViGyAU+Ik8ZoWFRF7vgGmkCGnd+9EyeeEe
	icjA15Zuqoaei2302LrfGKrR6hL32yDNWiR7K8iHyHl1kFPfVYuYDKyCICpktDfVUh000Cw1TQz
	5p0odXCGRkHRtOxsLqUrqRdTToohzMye+Jwzq7vUd00wXDiMEDx3J03SjB6xZmKKSlBYwYIy3+O
	pNOvc6auI+NjzzThnYZTuvSV7GgwwBAuTexcVUliTg0jFTWZ8cjFZzCdTBIspHMPq5LN4Dkjp8U
	VcWZB5oJi1KeufwrSZEpETaNa7EyFYUDmEd8yjnI+7W0RoEjx3l4aXVWJNBS56g/cCOvmwYqRjd
	wbQqSHDcbKEihnvUhboEatX/nk1nJOR78Q75crxqrMk/RdUKxB1q2CnxD7hHjdsK7RLwp/jDxkH
	mW61eiGICor9uZKg6DYxSfAnGyCew=
X-Google-Smtp-Source: AGHT+IF4cZwMgYUn5BppW3VrmacPI7X5JRdwSyYMQ8T8eEKTmMfQncgG00M1U3s8j1O3a01skm5S6Q==
X-Received: by 2002:a05:600c:4f90:b0:479:1348:c65b with SMTP id 5b1f17b1804b1-4792af34f30mr83682085e9.26.1764933027960;
        Fri, 05 Dec 2025 03:10:27 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-47930cb6a96sm77241035e9.15.2025.12.05.03.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 03:10:27 -0800 (PST)
Date: Fri, 5 Dec 2025 14:10:24 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Li Chen <chenl311@chinatelecom.cn>
Cc: Dongsheng Yang <dongsheng.yang@linux.dev>, Zheng Gu <cengku@gmail.com>,
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] dm-pcache: Fix some indenting in cache_info_init()
Message-ID: <aTK9oGAZuWBfedTh@stanley.mountain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

This should be indented a tab instead of five spaces.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
It was changed accidentally in ed79b300272a ("dm pcache: fix cache info
indexing") but it's not a bug so there is no Fixes tag.
---
 drivers/md/dm-pcache/cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
index 6d5001548628..f02c7c4148c9 100644
--- a/drivers/md/dm-pcache/cache.c
+++ b/drivers/md/dm-pcache/cache.c
@@ -42,7 +42,7 @@ static int cache_info_init(struct pcache_cache *cache, struct pcache_cache_optio
 	if (IS_ERR(cache_info_addr))
 		return PTR_ERR(cache_info_addr);
 
-    if (cache_info_addr) {
+	if (cache_info_addr) {
 		int index = ((char *)cache_info_addr - (char *)cache->cache_info_addr) /
 				PCACHE_CACHE_INFO_SIZE;
 
-- 
2.51.0


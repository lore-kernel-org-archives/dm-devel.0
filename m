Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7100C27F75C
	for <dm-devel@lists.linux.dev>; Tue, 19 Aug 2025 16:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755622486; cv=none; b=EHe2XCBELiW7z72bzrc4jWz7FcQirI3WLGDARplWmA7sFZp3rfoCbchZDwXXYz75AIkLag0Yw2YI0r2zGCtJ28RgmB9+NkKbL0TDCCSGYxwVrckcB7OHXoMkLtlMGIy8tRTIOyH6v0lxybGFOU/V7AlyAqKkpqclYejtN6b9JKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755622486; c=relaxed/simple;
	bh=DKoQydukyuDW20GX3BiEqlGiYSi9Ohgg/Sjs+HLGNGI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sXQPlid8QY67Kkk+txuWttCokGFn5JGitYvEMPN1Jn3vfxr4livEeQYX31oK9bZAq+lN2D0ro7XQkduGrNUfmeTUfxcacpJWXfIEsz+TulT2xnyvzqum3Nqy+t5jXc1JUqBmRdIY6BScswicHsiuRRBiogJ/caAFuwjvZ5Y8HMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UYe6YnEt; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UYe6YnEt"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45a1b0ccd63so10542005e9.3
        for <dm-devel@lists.linux.dev>; Tue, 19 Aug 2025 09:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755622483; x=1756227283; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=l4uXneR7d7mVQappCYZ6zGHWOYfo3XziT+cOJm5mvdw=;
        b=UYe6YnEtOCUK5eS6o6EPDKfPYbQrS9EWrK/wmWLaxz8ncWBwvauwy1kMFY1L7Z/IzM
         IoWCBMB7Jzllf9CA2gPvGWmShVsy63rLlBQ210km3qTJFqiSdB4h4FQPjyy4JY38mxlh
         V6bQU8nZrsplhMVSqShXdiHJv7JOSDsA0mqZ+CkhoVW5lQU7A8d3WjJOCGR6k//3B+oa
         HEt3kAnyQZ1q25ffSHmMQlpQjY9RSJTu+TYfxeZ4eBj1c8X1E1HnXOEXVcGk3uKfo3KQ
         T4z+/5fyVyuOOlWzRQAsqFgw7QIJjXxoUzhUx4wIooMIGBkU6gSdyMCI3ElxAcnm33yw
         +OJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755622483; x=1756227283;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l4uXneR7d7mVQappCYZ6zGHWOYfo3XziT+cOJm5mvdw=;
        b=InnU3HAYCVyc2F2h2zOXchedv5CmUAdZg2nCsau3K0Dkp9MUmgCkbJrisF4E+nN0Ke
         N7tVrbUNJMC+Pu0UZr7jnL+RBcgi+bndrK7IwXTqwscmdv96vyamiKUeQ6tIZRIs3WSZ
         3sFU54o78CU1nDdKy6QlT+rsfklAUmjJ8kbrVNxPGW5XtrMyZeHtEJzQjJ5F3UvH+8W5
         aISTjoS6kYuHYySG6NFsshmeWyzpIbg4FBOVSz8lwOzWCdUyi3AAsiS728l7OKjjzfAc
         rpjw2Ibw6KUPnPM04simtgOYyGZFqjK/MPB0kUpPoDE0gqapl/3Ohf9Q7HS5WD9tasV2
         I/ng==
X-Forwarded-Encrypted: i=1; AJvYcCUYMTwYklz54RleK26wkeUinqpT1xKLIXw2OFEoQNYilZBB2uJ0IdrgQLpREaQ9gB7H0w7AzksR8A==@lists.linux.dev
X-Gm-Message-State: AOJu0YwZ9dwDDuNJ/gDXvgxzDaeWNWMhOHo2RwXxj3wEpWqwmk3/Mihc
	wK34USmzEFIMFM8J31j/qTpyuOowO9Aj1tqo7vxYMLbbHfMA6qhigpc=
X-Gm-Gg: ASbGncuffhnZ/Bf1WIs+JKLUZC4V6iN3QmP0np4xVcZV5bN0vy1jKXLZa2SQz4/cjE5
	mN5d1bUrqospWiAesdhgtsYjRtX534vrBMLmygk+Vei6iemYQ9eFRdD4i39LUVce84TaKbVvme2
	hX2xC4+sv3HOI7bu+GVV2CEjXCsbmRc36lrD7HD+tFBb4T3m/mqM5saGE62JgTxxv15NO80WfZn
	kncPtD4hEjh48604879FftDyly+0GeDcroposC3/5DtnRP1urMEObAYA4uvR1mowuKtVyU45jD8
	uz2Aq+QDerggdJVLMSfm1vz+f3WpcN+dSxKa3Q2bW6BrvmneqE/dTDuPEimuDDqea9q8iz2G316
	pFW2If41Y5BDaHqhG351HwAwSUQ7kzO3O4rlk5gThojmzNGS3FsymeCC+zaVB
X-Google-Smtp-Source: AGHT+IHDGwlsEreSS5U+mbumdZ1DZMuwxR7yuqR5WG6fd95ghqfjk8KNYtyeN1euN99ecm/l6S2F9A==
X-Received: by 2002:a05:600c:1c98:b0:458:b6b9:6df5 with SMTP id 5b1f17b1804b1-45b43db8d1fmr13041595e9.1.1755622482275;
        Tue, 19 Aug 2025 09:54:42 -0700 (PDT)
Received: from localhost (67.red-80-39-24.staticip.rima-tde.net. [80.39.24.67])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c074879859sm4304220f8f.3.2025.08.19.09.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 09:54:41 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] ultipath-tools: standardize NVME vendor_id in hwtable
Date: Tue, 19 Aug 2025 18:54:40 +0200
Message-ID: <20250819165440.59040-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

There is no vendor_id/product_id for NVMe devices.
Just "model". and typically it's a combination of both.

"NVME" is a static tag, added in:
https://github.com/opensvc/multipath-tools/blob/de16cf82c5263fc148118be56ebf44c8f0ee60b8/libmultipath/discovery.c#L1635


Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index aedf4b88..de0af8a4 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -88,7 +88,7 @@ static struct hwentry default_hw[] = {
 	 */
 	{
 		/* Generic NVMe */
-		.vendor        = "NVM[eE]",
+		.vendor        = "^NVME",
 		.product       = ".*",
 		.uid_attribute = DEFAULT_NVME_UID_ATTRIBUTE,
 		.checker_name  = NONE,
@@ -396,7 +396,7 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		/* PowerStore NVMe */
-		.vendor        = ".*",
+		.vendor        = "NVME",
 		.product       = "dellemc-powerstore",
 		.no_path_retry = 3,
 	},
@@ -738,7 +738,7 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		/* FlashSystem(RamSan) NVMe */
-		.vendor        = "NVMe",
+		.vendor        = "NVME",
 		.product       = "FlashSystem",
 		.no_path_retry = NO_PATH_RETRY_FAIL,
 	},
@@ -1112,7 +1112,7 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		/* OceanStor NVMe */
-		.vendor        = "NVM[eE]",
+		.vendor        = "NVME",
 		.product       = "Huawei-XSG1",
 		.checker_name  = DIRECTIO,
 		.no_path_retry = 12,
-- 
2.50.1


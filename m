Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3401F0E29
	for <dm-devel@lists.linux.dev>; Sat, 12 Jul 2025 20:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752351300; cv=none; b=TLP9NrgSphoXifC5JHBfm0usBkckKr+v5GXV/pWKSqKOrmFnqDAYcOH78f4M0CgNadzfASyMjF0l8/Uikvzp6FwHJcRfE5UV0UyAp9seMBqeKLM2U82YGD3q4l86zRw+jo9R/sIiWV8m58Sh5oFudL8/j4oG64gqQ/1GgtqtT4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752351300; c=relaxed/simple;
	bh=Az09RGSg/CWES0TEpg5AmHj9cs8SpA23n3ISythda1E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PfoDq5fXE9XeiIZ5zjFCHjFPcM1Sx9WkgKnb0BxW1vtmdxUKBBRFNfdZrvVMBneZIFioMhr5shHtb7QEF0S0IE/VeomGdmZ/SPwS/rxuNuRvhyyrNdAwdpPLBtiZgCyqLfPlBMD7FKYqXhXqgUe0Y4+rYm/UDTJtcoPTlxKYljY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kLMdHBsi; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kLMdHBsi"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3a524caf77eso395413f8f.3
        for <dm-devel@lists.linux.dev>; Sat, 12 Jul 2025 13:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752351296; x=1752956096; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=c2H/5n9iiow4hm4TqJZcD/kc8dTmrePwwyGHqrCmV0Q=;
        b=kLMdHBsi7tQOvUKAmB9WsoXqV31PctLehmPl/3KhnXFgF5ArBGMgLPZLSFd0NI6N9l
         m+HlGkPe7+wL3iZOB4vIeMIrmr78gtftvxKy8AKqIwZeK7+s7+wcT9b0B84s4Fntn/Jg
         C6koHdUGgXAOUHrnYugWmuu8pgKrS4lrvG6953ij4IxlFKy6rPMR+RpJ/znNIWXwM93n
         +pJRSJ5YuMXRvED/2KMgSAeyGTVVSByFKRCvq9zOXoJJVN2vcmQ90DgEp/7P1Q35GUok
         gZVz8LjxpAMbrZKvRg5HP038TdEQ9v43T8/jvBZftpuz5LD5xXUU4RiJ/XEXZEraj7cn
         EGTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752351296; x=1752956096;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c2H/5n9iiow4hm4TqJZcD/kc8dTmrePwwyGHqrCmV0Q=;
        b=nJfOqIXWpDJC+9EI5O4J9whDxNs1I0ryXastcGYq4xdBwjPsgQoKsEG15X9yWiQR0i
         juVHf3tMAGbe3TypbMLZ8ih1SclMejbUjJkjqim3wtn7LLGYrn4btdrsJ5HHla/03az+
         AM88LwfzWcHJ8HN/1LhCXoHyRfyGmf8CbtO5e+bdy8I+Vbfh5x3cLkMTCqW6KciZmVO2
         thZAi5sCtRJ99Yzx87zGv0qwDAdsIItzBo+BhpW2q5DbmYI5odCHG20tMLDxztfKaQUY
         Cg6COuVor+yUp1BUh+Qd16xUtgxvUpbWwrVEs4mjXy3XUS/2n6xfdYmAPwj5CNU6aydW
         tc2A==
X-Forwarded-Encrypted: i=1; AJvYcCXVV38rG29za3/1mQp7sVvUkabhj15pNDw+oGROkZ56TRXzZmuLk3MOp91c3S9gxc+vHBXMhdLovA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9Tt0a7rTAtXuJyca/h2WTY8O8o2Ursvduvm00633Pe3JbeChG
	b2n/k3wAECNYoT87GXLjDLK/kDG8T2xGYDdwe1gThvVtY0vkrYcyIVA=
X-Gm-Gg: ASbGncv0yT8g6EDygJKynYJ7pfcF2dvZe/Vg7XEYR8JLrkC9hd/b7njm1eXoPKN0RKW
	/m3GuD8n8kjIiB6rhvj/ZX3A15gBjUgnb8aGcS7DSZnlVwfy4sum3Y6zmIAQLKJ1VaZnXS1RZOK
	DANEEkyxqLuX3FZMp2TObcjRy/yPsyI62YFSP0/X/XkHRaRxhUZTTe3T10rkF9cbGbkCL7HXP5t
	fZu+sI1fJ25C6amkkmC9lRHhT39DbyesZ0LPDy+7v1CfSzhaSeU31aMPytmI0IEgeN8vTwFQZYT
	nvYXEauzBqcphB/Ijiffag5EXAmqL0O9H+Pnm5rgTnO9pnyCRLIOnp54uN3BDsQ4pLxvtcYB6ar
	ue46ZlKxI7MYdetkJG59EfZN0VWCYPdQihywjIp9LMW19La8O+X/NAY4mSVxDyg==
X-Google-Smtp-Source: AGHT+IHuIeAbzXw6/mJbD5MNQ/jWc3Nq/FoekJkkho10xMl4GNlABZqE63Wt9bw//KAWlR5mHOVVzA==
X-Received: by 2002:a5d:63c3:0:b0:3a4:e0ad:9aa5 with SMTP id ffacd0b85a97d-3b5f18e6cccmr2246206f8f.11.1752351295969;
        Sat, 12 Jul 2025 13:14:55 -0700 (PDT)
Received: from localhost (182.red-80-39-24.staticip.rima-tde.net. [80.39.24.182])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454d5032fc0sm121475465e9.2.2025.07.12.13.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Jul 2025 13:14:55 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Nigel Hislop <hislop_nigel@emc.com>,
	Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Hannes Reinecke <hare@suse.de>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	S390-ML <linux-s390@vger.kernel.org>,
	DM-DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: fix default blacklist of s390 devices
Date: Sat, 12 Jul 2025 22:14:53 +0200
Message-ID: <20250712201454.215404-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Each blacklist only their own devices.

Cc: Stefan Haberland <sth@linux.ibm.com>
Cc: Nigel Hislop <hislop_nigel@emc.com>
Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: S390-ML <linux-s390@vger.kernel.org>
Cc: DM-DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
DASD devices been blacklisted twice, since:
https://github.com/opensvc/multipath-tools/commit/a6ff4f957c78bd15c49278ad359671a705eaf4b5
In the current code:
https://github.com/opensvc/multipath-tools/blob/de16cf82c5263fc148118be56ebf44c8f0ee60b8/libmultipath/blacklist.c#L233
---
 libmultipath/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 081d119c..4ca4245c 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -677,7 +677,7 @@ static struct hwentry default_hw[] = {
 		/* PAV DASD ECKD */
 		.vendor        = "IBM",
 		.product       = "S/390 DASD ECKD",
-		.bl_product    = "S/390",
+		.bl_product    = "S/390 DASD ECKD",
 		.uid_attribute = "ID_UID",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = MULTIBUS,
@@ -687,7 +687,7 @@ static struct hwentry default_hw[] = {
 		/* PAV DASD FBA */
 		.vendor        = "IBM",
 		.product       = "S/390 DASD FBA",
-		.bl_product    = "S/390",
+		.bl_product    = "S/390 DASD FBA",
 		.uid_attribute = "ID_UID",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = MULTIBUS,
-- 
2.50.1


Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19A6101FF
	for <dm-devel@lists.linux.dev>; Sat, 19 Jul 2025 13:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752932784; cv=none; b=KeNnkrU6Qebk09zFTPPro7lPaFUdUGkq06Yrn8fk1wHVabMrBexenR4ItkfhkEr/gUxEuDZ8D1SwgT92e8g02N0KFUbCRTZgbyZh3mkkF5i+ppWkkG1WCIcfSoAkRlDqOVwEtfEMp3nU/rH4YqA+ZNnonrF9cPUeNthbx8QVizs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752932784; c=relaxed/simple;
	bh=DjzqGzUlo/sIT2JaiMrDdXX5dhs5Yx23SsPHmVKfofo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HQkK4Zjggn+r+LF/We7QDKJYXbne11MxiROhyK4wC0nOSDWpb09mvopGFJtSDkvwsY4ZdQKDgxP9HtdYWVLj2YzDym1rynz4DHgqg+bWxOOHBiTBSkGLBV1g7P97TZOvJHArcKvF2+tRRS96J+IP6Gkc/RH9/m5KuHVaeHvIhyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gwiuIikd; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gwiuIikd"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a4e62619afso314099f8f.1
        for <dm-devel@lists.linux.dev>; Sat, 19 Jul 2025 06:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752932781; x=1753537581; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mHg5YvItvmX572ShvjvkOAwdnvh5M+a6tgw6nkYQPfY=;
        b=gwiuIikdeFauZawHg30hQdUFtS8G/kwZwKPjl6IpL4asiQtUQ9J6nM/kRHDD32PgeJ
         2CYhi9lWTCtird5569QJWcq3z2buweFQu5tTvCWoX32vfX45FnHnRoHD7mFNWWR6MnU5
         z/C2NS59FPhYnajT+6bGAI4UigaIXs9OCQ20sVowsWa+Mumrjr0M42z3y6vZY/1L3RDI
         idXo91mAX5H1AeWqduuBVzDZ5Fl2W68iok0H/uKYWtOBArJupvlPV8xzdR0j35leUWhw
         6WJcmNGWseNx/aLsYQdMOVLIkp+Acv4gB3OhfmDjMJTtA3MAqrrviSKmu9An4Uu7eFwy
         HrCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752932781; x=1753537581;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mHg5YvItvmX572ShvjvkOAwdnvh5M+a6tgw6nkYQPfY=;
        b=Xivz1UFL3/jk8I+o2ekcgtUMdW3+fcUun12AeQLggY97k20w4jcVQa5c3ZKgG2gaeM
         YHnXxBd2IFMvHm+gDPMY9VCklatmM5jHdWHeLCGok6XdI6zP05o9USqSOJPhWMIE259l
         FUsk1mWvG1muPxg4cRuImoUMQINk0SbIkeTenTLmQWZzw7V1qHxuz6ln+59MYfSr9767
         rd1p4YByKccumCpsM6eQn6V+lj7oLtOPzcJNuSdvABGhy+SxNQkAv5+oTGZRe3xuHUtm
         /6/RHeEXNAJtRrKe6amLKyw0yI/xwz7fbdnMeN1n0yHbFXNw7GN1tO0OZ3i4rzSFQobE
         mJzA==
X-Forwarded-Encrypted: i=1; AJvYcCVzquGQfo+cuR4hmuiXZLsZ9+rsusqPHRkjgm5Ojvj8aqMm1VqxVFLxCfgi6bCt7A38OE/onw9sdQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/WQ4cokLr+ILjb00Jx+rnQFrSXYfKqfsuvlBIaV2PlYEEwwfz
	dv/8DuUiuQeTKEHmf8thD1eS+1LlkL1syH61Ry2jvqcej7VKiUWpTH8=
X-Gm-Gg: ASbGncvNLlbWavL9JFP8B2dCynsFMq+kNXjyOEOSfACJSY0QF4RUJCC9Pizd5RVK7jM
	jo5z92xHjUo7u7jodB7qDRHVpkGnFaeUgNSKFvE/RRLQuoeZAjS0sBS+Pyu9kZzfmI6NZTrRrA+
	K+vUw5lO2gOLTSUWH+8gLIuxJzbjbgi/6YwD8tNaD1FZICxdDNQvoX7YNDnUX40FkwkqnNoBoDP
	INCLHB83mfyDRZv2R4tytZ+4lHWUNW4peHdiAMIE2ryfSxN5oKIw5UhGx2ndBB98OKfB4YDezK4
	YOm5TntFr5X2R4N63JI9TbGyZptnxx/kJkTMZohvNGTFkGSQ+AnX1BGBfca/rQ4GWJK911AWSnh
	5pTbyqziDD74ahxPt7zg0vJruvMkZUDQKzbwrcg5lzY8M5hh/CXINrdSOZXS3Tu79HQ==
X-Google-Smtp-Source: AGHT+IHJqkICjwjj4UeIVLdGFt/DJFe0i2365dtr+EpU6Sfit/vU9mDnwJT2eThsTkixMejgmYenIA==
X-Received: by 2002:a05:6000:43c9:b0:3a4:dc42:a0c2 with SMTP id ffacd0b85a97d-3b60dd4da51mr3277301f8f.1.1752932780664;
        Sat, 19 Jul 2025 06:46:20 -0700 (PDT)
Received: from localhost (179.red-80-39-133.dynamicip.rima-tde.net. [80.39.133.179])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca4d807sm4853763f8f.73.2025.07.19.06.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Jul 2025 06:46:20 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Nigel Hislop <hislop_nigel@emc.com>,
	Nigel Hislop <hislop_nigel@dell.com>,
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
Subject: [PATCH v2] multipath-tools: add a comment about DASD arrays vendors
Date: Sat, 19 Jul 2025 15:46:18 +0200
Message-ID: <20250719134619.331400-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

vendorid for DASD devices is always identified as "IBM". But EMC, HDS (HITACHI),
or any other PAV (STK (StorageTek), AM1 (Amdahl) ???) array vendor, are also
supported.

v2 - remove list of vendors from the comment

Cc: Stefan Haberland <sth@linux.ibm.com>
Cc: Nigel Hislop <hislop_nigel@emc.com>
Cc: Nigel Hislop <hislop_nigel@dell.com>
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
 libmultipath/discovery.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index c4bc6df6..c78e8b33 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1669,6 +1669,7 @@ ccw_sysfs_pathinfo (struct path *pp, const struct vector_s *hwtable)
 	if (!parent)
 		return PATHINFO_FAILED;
 
+	// Identified as IBM, but any other PAV array vendor is also supported
 	sprintf(pp->vendor_id, "IBM");
 
 	condlog(3, "%s: vendor = %s", pp->dev, pp->vendor_id);
-- 
2.50.1

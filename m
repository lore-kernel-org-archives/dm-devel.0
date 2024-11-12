Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CD6204027
	for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 15:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731423777; cv=none; b=k4NuaWTTs15LCkdfbrVGKReIxd197OjF8AbwuzLkLipHD4t8AlW9zc4U7+FdouWzoDwEoJJn/ybT0HAcu4Wu1Z6LEP7GNy932MDBeBvNILimraRDgcolfhZqSeeS3Uka6yM72rbH8nuegf653iifPvh1V/WQQfF/y06XehKUT4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731423777; c=relaxed/simple;
	bh=P4QZIPlTFjOfEV19+T7IkTY5b8/zpjZmiO3qQ6J0Ut8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4u3uyFNbqwJL4TaRc5yls5jGWUEUI8Kp1yBm842y86MBPwdUlQpD/KVz9nyQvBaS2jipb2jtktop+AqS5hqhOLnRIsMKYb33JlHE7pDM7c6cUEtZCqRWdHQEpA1RtjZNlUk4VWgQaZsJiFod6Rxufvm6vsSXhak8CLOHnQwK5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AhRA2dXy; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AhRA2dXy"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-539f53973fdso5510908e87.1
        for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 07:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731423771; x=1732028571; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MVwT7oZIOWnuzpL8iQZqG1FDeYB+P+/VcybAWauqrnM=;
        b=AhRA2dXyqKl+ZgFwuwhEMDTEA2oEkSn6wOe0H+c75YUEHg/9gUOf/6oxhk1SLpO8lM
         3QKA4gGznqa0swjkosN0uVTVw86P8aL2GDaB4/lB/XnpQjtOiaJG16OsU73Lwdmyshh7
         HBZpZQ8y/17mIb+qUnMW5uhbBfGok32vFr7IeheaPT5sR01Os1RCBqJ91N+90bbjDCKK
         at9dip94dp/VXT4rNqryU33nJzw/PAlmArvV7eaeyLPq4ITaWPp7N7ROx14ugS9io/Dr
         6+R9Xa4qVPq7p62YP3MQ9E4oIs+oXzGZJN/jU4ekGt35a2by6/6owbkR5Qq7FXVLheJE
         4iLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731423771; x=1732028571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MVwT7oZIOWnuzpL8iQZqG1FDeYB+P+/VcybAWauqrnM=;
        b=Ph0LKjDbVrINb3dzqDYvSgPIv/WFiopXhCKJNUu4IxMAI7RHikqFUltX5NlUN7gps2
         mmsOq2yFDTZVfKk7xWZ8SU6fGMKjbWJnNXtAbRlvYOPJ+TA87YVKO9W/d/G5yK2Ql2q4
         OMzllTxwjK0z4GCOCM8C5URgOL498DTiFxr/2OVGBiOPcsLcNhY6wi8rxo4/3d7MyVY/
         h+hp5v3SdwhFUPTi1arcixGu4o5xQs3ClfcsmJnU5p/C2Q+Qu73w5naUtUXF0TUKrGk2
         aijpnWYfMRzlPi1f/dc/thytrtSC1X8Tpq2sObvkK3jqH3xMUcP/6963Jd2zky6WX108
         A7KA==
X-Gm-Message-State: AOJu0YwonXnfEhHuplzyfjkvfuyth70tzxvmkPTaLdsHu4qKumIDOsRI
	KULxZTkUtu8ygctxk+7MH6T78A5LSS7sDASG2Q5r2NuKQDQUr4/C36SQwR2JNIvOjfgg81czKk1
	y
X-Google-Smtp-Source: AGHT+IH3dAXcG5uGXfD3NvSmfPI/8yzi+RTDOmQSd/1y+EVtBUpPRPtDZBH2gQeQAScDfMWhNxB6rg==
X-Received: by 2002:a05:600c:138f:b0:428:b4a:7001 with SMTP id 5b1f17b1804b1-432b6872c8bmr140594675e9.15.1731423759211;
        Tue, 12 Nov 2024 07:02:39 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-432b05305a4sm214401845e9.5.2024.11.12.07.02.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 07:02:38 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 06/12] multipathd.service: restart multipathd on failure
Date: Tue, 12 Nov 2024 16:02:09 +0100
Message-ID: <20241112150215.90182-7-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112150215.90182-1-mwilck@suse.com>
References: <20241112150215.90182-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benjamin Marzinski <bmarzins@redhat.com>

systemd will now restart multipathd on failure unless it has already been
started 3 times in the last 30 seconds.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/multipathd.service.in | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/multipathd/multipathd.service.in b/multipathd/multipathd.service.in
index 646001e..b6a25b3 100644
--- a/multipathd/multipathd.service.in
+++ b/multipathd/multipathd.service.in
@@ -12,12 +12,15 @@ Conflicts=initrd-cleanup.service
 ConditionKernelCommandLine=!nompath
 ConditionKernelCommandLine=!multipath=off
 ConditionVirtualization=!container
+StartLimitIntervalSec=30
+StartLimitBurst=3
 
 [Service]
 Type=notify
 NotifyAccess=main
 ExecStart=@BINDIR@/multipathd -d -s
 ExecReload=@BINDIR@/multipathd reconfigure
+Restart=on-failure
 TasksMax=infinity
 LimitRTPRIO=10
 CPUWeight=1000
-- 
2.47.0


Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA0E12F58A
	for <dm-devel@lists.linux.dev>; Thu,  4 Apr 2024 17:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712252323; cv=none; b=kfzhVQnbFVttk0XYpe1vblYVyjiYvxLM6ZieKjHQ0yk45XImp+a+oFWc9dYW0t+lyAa96wlYpA/sg/F4ZyL76vIXn6OvBDzeMO5wQguUdB7d9c24N3sd4Gc5Jk0ZMhhx4fqDoQyn6Q9fLobFtJefp2WZA30rfIDu0cV/srIGdX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712252323; c=relaxed/simple;
	bh=tssE8I7KeqSM76vuV+gsPYdYXSi9WkmjJRXr+YRAHnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLUFAxUQqeplCNqgjoYGRuh9cjiTK4q1k6/yowsnawhNH3d3sA7+MyY0Pn/kv06/mWMdRqu3W9CGYvwomNSCCABZ+lEcfm3pi9klBCvgvkTPHBnxVKT6H/tafMAAOO9iXpwXgq9vZnRNoQnjVgUuqHNeuQnUKyyzPkWxqi+skso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SbbPM3FA; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SbbPM3FA"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-343c7fae6e4so513710f8f.1
        for <dm-devel@lists.linux.dev>; Thu, 04 Apr 2024 10:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712252320; x=1712857120; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WBgDVzqOATV8/m/3G8iqx/JhKwqmIVaIGnoDpTtxjfg=;
        b=SbbPM3FAnTZB43nzLz58ESdhjsRT5+XjGins04hbIGv1b+Y1dGS4tpk7YWwjpL31pB
         YLqoY0I78UzqdIy3I5V98V6akGwyvCxGI1NDW+rmGSTx1HwGJHlmZEK94Te0sRJng33o
         1gGk59kNv1MGZmmSgk+RSAeRvVErKnU3J1bhz4nO1fQkLRMHsi+u3whAHtHAzzR4K8HX
         lCQLRACfRvcCssNULuAPjAQsAl83fgPMbtxgfouC/gr2Xxk5UhuUHhrVaKm1MVUPzc3K
         0fkFuDk7wQf7z+UItMckgrqSg+iqsM59uLA+TYNE5xn7PLBNDDFvBL3lCIjUkTiJ9lN7
         Ze9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712252320; x=1712857120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WBgDVzqOATV8/m/3G8iqx/JhKwqmIVaIGnoDpTtxjfg=;
        b=q6HHOCb2IJAjachWkMPX8ZnGeteLzmkFORM1CHHjZCXNmVOA8H47KKZfurToFiEx5w
         92DTXPQDgGPKjP9tQtyG2fbmA6kkMc1mAXQ7Ih+F3JLDciIU2U9RtsUN8jXB2QuOpTBk
         6Dyd0jEd6rl4e2GpAHAhD5Y1NluysG59WmjHFPtFZTuTYCBgFOceTE0uYzeNCoi72aAo
         TJnwr44hY/Iu/OtQ0nRZkElS9QhB5Is6+btRVnQy55vZbULSCFIRlsFdOjmKHgzM+iKi
         lR/zdeCbAJWuFkL8Xg+Uoh9hEkrTtC7lD0/KgyDKAXEykCzWRdYPe1w2DE4xQnw8a39F
         HA4w==
X-Gm-Message-State: AOJu0YwegjLeVXDqUXMO6moXPUBece9gUxT8iqh9aL/4Y9ScrabnHhT4
	s9R9sqPFwnC43jFS4onpKI/eIc0U4EDKuVzd26jFNIWSGhFrobM8ducEbwl66mo=
X-Google-Smtp-Source: AGHT+IF16ZfwACRyOJt5AcpAKyx+W2qTr0ScdUuyAP6jA9bRjDKpy7KJ0oIqzx6AtDaHSQzNxRtqQQ==
X-Received: by 2002:adf:e604:0:b0:343:b5dd:f6a6 with SMTP id p4-20020adfe604000000b00343b5ddf6a6mr1933513wrm.4.1712252320048;
        Thu, 04 Apr 2024 10:38:40 -0700 (PDT)
Received: from localhost (dslb-084-058-019-253.084.058.pools.vodafone-ip.de. [84.58.19.253])
        by smtp.gmail.com with UTF8SMTPSA id b10-20020a05600003ca00b00341c563aacbsm21115462wrg.1.2024.04.04.10.38.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 10:38:39 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 09/11] 11-dm-mpath.rules: simplify PATH_FAILED case
Date: Thu,  4 Apr 2024 19:38:12 +0200
Message-ID: <20240404173814.3143-10-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240404173814.3143-1-mwilck@suse.com>
References: <20240404173814.3143-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This combination of a GOTO and a simple rule can be combined
into a single rule.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/11-dm-mpath.rules.in | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index ec55435..8653081 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -56,14 +56,10 @@ PROGRAM=="@BINDIR@/multipath -U -v1 %k", GOTO="paths_ok"
 ENV{MPATH_DEVICE_READY}="0", GOTO="mpath_action"
 LABEL="paths_ok"
 
-# Don't mark a device ready on a PATH_FAILED event. even if
-# DM_NR_VALID_PATHS is greater than 0. Just keep the existing
-# value
-ENV{DM_ACTION}=="PATH_FAILED", GOTO="mpath_action"
-
-# This event is either a PATH_REINSTATED or a table reload where
-# there are active paths. Mark the device ready
-ENV{MPATH_DEVICE_READY}="1"
+# For PATH_FAILED events, keep the existing value of MPATH_DEVICE_READY.
+# If it's not PATH_FAILED, this event is either a PATH_REINSTATED or a
+# table reload where there are active paths. Mark the device ready.
+ENV{DM_ACTION}!="PATH_FAILED", ENV{MPATH_DEVICE_READY}="1"
 
 LABEL="mpath_action"
 
-- 
2.44.0


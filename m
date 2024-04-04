Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BF71BDDC
	for <dm-devel@lists.linux.dev>; Thu,  4 Apr 2024 17:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712252316; cv=none; b=bvj3u/5IqW4dyyG2jPW8xC3a2oWbZDxdHlIuaEOhIgV3wyF4K5dtqNRrFh/pmahtnElBap/yH9w2UpaBd76E6kLHOAqW1fKdwroDJzq2bLbHzi0+LNQ9GhZqnog9kUROpPiDmW2YPAF0PejX4hhqtgoLF4ezmMsG3+R6n7U9ZDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712252316; c=relaxed/simple;
	bh=k3STvMD8w9boBHRa4N122KKuCgt/BMpEwu3tW1EHVRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KskZcMbrs1VmTJ+9B1FNL/s3XykgOQ0jyzF84gB5I5ho7nkNvhh3fvhJPgUiJSINl6dqEbNS6R0kh91NUeWlNP95noJiw8ra+5MAjjLvE+rbtczAy7h2nfAsi/LQB7JRd27xQ1HgOCDDVY9NoA6k2IKuuk08coYvkU7zN1vVoQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OiD3N8cF; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OiD3N8cF"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-415584360c0so9427585e9.1
        for <dm-devel@lists.linux.dev>; Thu, 04 Apr 2024 10:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712252313; x=1712857113; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WNeNmyTzg5xJ9I9SCOFxr5iGK0i8bhHWC3Q2//meneQ=;
        b=OiD3N8cF2EKHBdvryhrpQ73zXxNvZqLbnOY79UJYOTq1w/NjwK+bJvTgCDSqH/pR3f
         Rd8jyNKYNu1zMaF/g/19chEjeKIFer9IWPgESHxUYDW1DXH9/7kDvmaIiYeiQKTf5la7
         iFRd9Z9wG+LqAcEwR5t1gfPW1mwW/KNd53xWF2xvK/RL1GRiKzjhBPrE//4AS+oR8bU0
         MZyTIMfSpQWXMVAeamtcTA2kWD+ExWOilYiEYHRr8oiLTF60mHyNCJk7QGDaRF9vbBO7
         365gbleWe8S0eyULxHjJLD+PEdmSQ1yz6xA0RGFhRZRcxQSLafd3XJlWlSzW3Jc6sBbL
         dqrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712252313; x=1712857113;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WNeNmyTzg5xJ9I9SCOFxr5iGK0i8bhHWC3Q2//meneQ=;
        b=eQr7C2gksc9gntnjRF8VIq+h8u0bbIB2hM5DkUPknC+dLO9NUABqI7+6wy2rFwDDGg
         i3otK12dePnfxRqlanRpCuNsQNVU7/VZEDHo+tmscxIhVa9nW9lFupXRCF78q1jUJN2J
         UBigZw2iC7M7sbeJBgRVzfqOCgOUANmIYDn/ZrzOTIVYmkvriTAVcRPfkDBF0CZJpmuj
         X2YvuL1ktAkngIhYUVvwFYkc8AIfAv/BWPqvHfWnNKwbKBi0n26K2xbS2mh99dSKVjrv
         A04KJvJ2moH/vIcJ/Y72VzfFI0K2kX6/jIczB4TVeN2UwT08m5QrJMfONL4taz1M6X0f
         fAIQ==
X-Gm-Message-State: AOJu0Yz9HUmP6NtZpWDKL54R+wHTq5rAcIc8rCaMJRoGZ+Ou3SnTMQ2s
	xjeEbZXRmPzLgPuQ5IZjuS8HjzxnpavjMK1rF7wF8NQIbnK4dQg1/9+YuNIbYbg=
X-Google-Smtp-Source: AGHT+IG7o2VdRKWi8sbPHcD7aQKqaTqXAYVk9AN8WAvmMdhEMexM0dUXnFTzteMes0jFF29J4T+VSA==
X-Received: by 2002:a05:600c:35c3:b0:414:6ee:a392 with SMTP id r3-20020a05600c35c300b0041406eea392mr2425838wmq.8.1712252312675;
        Thu, 04 Apr 2024 10:38:32 -0700 (PDT)
Received: from localhost (dslb-084-058-019-253.084.058.pools.vodafone-ip.de. [84.58.19.253])
        by smtp.gmail.com with UTF8SMTPSA id bx12-20020a5d5b0c000000b0034354a99d43sm5320395wrb.43.2024.04.04.10.38.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 10:38:32 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 02/11] 11-dm-mpath.rules: don't import DM_NOSCAN from udev db
Date: Thu,  4 Apr 2024 19:38:05 +0200
Message-ID: <20240404173814.3143-3-mwilck@suse.com>
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

DM_NOSCAN is our "output" flag for 13-dm-disk.rules, and it should
be treated the same way as DM_UDEV_DISABLE_OTHER_RULES_FLAG, which
isn't imported from the udev database. The state that we need to
remember is MPATH_DEVICE_READY, which we've already imported above,
and we will set the "output" flags accordingly in the "force_activation"
code path further down.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index b8d19d0..eb12b0c 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -18,9 +18,11 @@ ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}!="1", ENV{DISK_RO}!="1
 
 # If this uevent didn't come from dm, don't try to update the
 # device state
+# Note that .MPATH_DEVICE_READY_OLD=="" here. Thus we won't activate the
+# device below at force_activation, which is correct.
 ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", \
-	IMPORT{db}="DM_NOSCAN", IMPORT{db}="DM_COLDPLUG_SUSPENDED", \
-	GOTO="scan_import"
+	IMPORT{db}="DM_COLDPLUG_SUSPENDED", \
+	GOTO="force_activation"
 
 ENV{.MPATH_DEVICE_READY_OLD}="$env{MPATH_DEVICE_READY}"
 
-- 
2.44.0


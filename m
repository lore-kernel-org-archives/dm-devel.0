Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE1713A264
	for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 20:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707943881; cv=none; b=TJC6yycd65zRM8eVGoWlh9pJlYMaGkneEgQCHR8fK8JIvnrLiXCoGCcgA0TQs1575YtE0zqEd+MI9ml1UULns1Vf3QB6OB64DwHYqJfRJS+WsW/9MmA2wIKvihEW3VF6tw85m80aA4gD+P7RN1aezHgE0O/W/DxnrL+Zxce2Qh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707943881; c=relaxed/simple;
	bh=CzZ10ebMl8Aq88rtRWQiE6iaWZ9AnGpBYpJc/9ul6Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRGoxs6byRIzMoVp4GYXsUjgDeG/hRmPJkHwFl/NPOpk/hbwkPkE8dTacw0lZly0cdcDWvoXt3Y0kLiwAEdVeJt374TBEcnvT7a8/2XgWtgP8Og2/0w2aKLLK6ktwnvXx962HhOQr8OAi8Er/TqGUNLt18CiHfbDBfCvMj97uLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eReCVEHt; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eReCVEHt"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-411d253098eso1110395e9.3
        for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 12:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707943877; x=1708548677; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T5jWCKVtO1cjEeo6EXqTxx4ngqmzQtxCdaslRQfg+ZE=;
        b=eReCVEHtsmP3zjf5KNwceSuP16fU4s48Yig/GbkVFvvvSsVIWSXGPH1WU/zhzqtf8X
         aeMf+l1ztJsvpTSiTwA4eF8vng/5Gz3NmqETColrDy/7islQFfM1LLreUm8iZCO8GcM1
         Cergxyvoq2eHevvLJt0YlSSDPEjRBDK4KbO9Alm+BgCE3Bmq5Zbw0Hu6ZdDCHOOEs7ur
         z+YYdrE+RLLnKb6U9Qj5tlr1zkwk9S/9mKjnvWLor7xWVhHDbuUNITIsRwhSK++KaCae
         BbtO5YcswJTbYeMUgiR2OT3PM/4RuZdY4rC1VHZwfC+RxUhdGj5SUgDjNx7PIbbGMaYK
         Z9rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707943877; x=1708548677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T5jWCKVtO1cjEeo6EXqTxx4ngqmzQtxCdaslRQfg+ZE=;
        b=AnSSUbC3xp8tDx1fgwz/F8Aotvl5HVJyI07LBANa56gH3yvn/GnqJTtW/X0DGgSJbf
         KP3mssEwr+8cgSw/LQ2lpzt1NbsEXPqFTexZMsBYEwZQdP8t0pEHCSlPVCVksE03KqSo
         UMwoIBKTsJ2Az9hLWQtf4wYr0x6TffiVjizLdqTqNVunOh+wo/DHfLAHoC97/qpirYEo
         ARk0C+qnLxr26CC7WM1Ol+J9YhfZEIThCV8QzMTiOXZdWshsCC5+tBjqWl3ke0DIS9yG
         Sdu4ZNv6d5ZPULIz/dwwItFbiarIbZUcU+Vkcpr4ouW/5L6njpcmiz+i+wZTWk4mpHsv
         IDNg==
X-Gm-Message-State: AOJu0Yw99y/SN7rUo3Cs5iec1sMALMB/YgQxMLxdI2AIu2GQlhLEVePZ
	4loarTrmxkplfQpE57r6VYfoKDLcNjLQVTltiHkWnXza2OoyfGI5xuHFFREmHYG2Dgn91QH9y4X
	A
X-Google-Smtp-Source: AGHT+IE0KTUqu6XUahTzkKdhpRUtF5qAqbWDhi31XH5NABrEPlHVKa953lMyHCDxUqz/Q7k7nEK+zg==
X-Received: by 2002:a5d:6387:0:b0:33b:60ca:2219 with SMTP id p7-20020a5d6387000000b0033b60ca2219mr2652858wru.45.1707943877674;
        Wed, 14 Feb 2024 12:51:17 -0800 (PST)
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id y5-20020a7bcd85000000b00410ab50f70fsm2868017wmj.15.2024.02.14.12.51.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 12:51:17 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-lvm@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 2/6] 11-dm-mpath.rules: don't import DM_UDEV_DISABLE_OTHER_RULES_FLAG
Date: Wed, 14 Feb 2024 21:51:03 +0100
Message-ID: <20240214205107.27409-3-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240214205107.27409-1-mwilck@suse.com>
References: <20240214205107.27409-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

DM_UDEV_DISABLE_OTHER_RULES_FLAG is handled by 10-dm.rules, which imports
it from db if necessary. There is no need to do this again here.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/11-dm-mpath.rules.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index e7be12d..fd8d202 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -7,7 +7,7 @@ IMPORT{db}="MPATH_DEVICE_READY"
 
 # If this uevent didn't come from dm, don't try to update the
 # device state
-ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", IMPORT{db}="DM_UDEV_DISABLE_OTHER_RULES_FLAG", IMPORT{db}="DM_NOSCAN", GOTO="scan_import"
+ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", IMPORT{db}="DM_NOSCAN", GOTO="scan_import"
 
 ENV{.MPATH_DEVICE_READY_OLD}="$env{MPATH_DEVICE_READY}"
 
-- 
2.43.0


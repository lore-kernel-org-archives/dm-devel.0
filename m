Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D077EF0A
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 16:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707497730; cv=none; b=afyZJYolQZ3m7Lq6nvyLu4xV7aCXnZ3zvirNZUcKLLMfVhYDs9LJIEelY8HfksNs/xO8HTDRUdgCbYomsTTXtHVHsk1MCj+K95WsB2s6ZLd0a6fT61TMi9x9IBcnFI6/e15E01hgPqbc662b/dwprcqknSKWQI3RUoDQgzMW1L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707497730; c=relaxed/simple;
	bh=CyiM5LvSbQYJhEJ6nkB4ZfJ1MbF4QShm1vgGJn1B0r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raufauYipvKEZ7GD3sT6dUBSZgNbAAaaHwzImM9rVwWwKTwvf7Wk19sdMUz4iHAYz0Ctwiy4HI4tVmta8zw2sPZz1Xl/pJHWzZ8WZgLoSCB0Hd9jVi7PCm7SZvWI0ck98xDL2/LUXRNM+WWbbIjPZzhtrc74IxxdM91QtZA9AJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=V2PtDGLP; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="V2PtDGLP"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5114b1e8819so1681053e87.1
        for <dm-devel@lists.linux.dev>; Fri, 09 Feb 2024 08:55:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707497726; x=1708102526; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XdKwi9YodNJD282KzK7O3DAPwVLkD53DU5p+wodh61Q=;
        b=V2PtDGLPAVxuNpt4TFOUmBs4mtAOqzaxiDUyjI6ong2mSOzeuL1bg8Vzh7NGLrVE8k
         PspK1DZO9M4KBvVwshHiLQrwu65bGRa9KMOF91KegSjbSYt0OdBguWaRRUyFjyiDQBfq
         rBWrqZJ+QnU56D06CQXPC1gfnVFsprIFLpr/85BQZP0kYs1e10UXfy0FjxQdgbDl8p96
         xXltT3oEp1QHrk1nitJVv1dDzLhbEecGZKWj/4Meh/qssYtrlYYPlJ3/9QHBFCBaAug8
         4mNuxQpUO4mVWdhLsFIXLVpsgf75pn3kc5sHnKe3DG4hr79lPbE4sPK1NQc897UD4+Hv
         PS6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707497726; x=1708102526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XdKwi9YodNJD282KzK7O3DAPwVLkD53DU5p+wodh61Q=;
        b=H/GDr0aWRQ9tdnAs5VZL83GvddzOdaJ9TzEhhiWnaUjCvr/Zi2t5rDn1GY+atU9Sqm
         UvpH32tSV4LuHodNTv7IO4+43LLhe9rl86fBifq67W8SJKYyNg6cLZmsaQh3zel8d7j7
         N9YteJLicuMfiJULK3UhXvKEqd320a2OUGYeMQMKNVamnejLxsgE7JHekwvIj3x7G/Ez
         w2giJ2JeBWBFB/Cx36CtQDYPf5PV34t3pkpkhMp4iJYGxQWfeXEwm5kLoM+eJOnCttk0
         pSLzWsgsB4LlYkADA14cGgD43WvMGH3d5qn+AEPbcdqZdsD4wUPp7UBcrzwlFCp7JvLi
         TL5A==
X-Gm-Message-State: AOJu0YzBhIeo1ZWjJcHAZdolSxTUD7MTneSXsLV3v3HfvrIiK2K76YVG
	MSWeNER2nInMOyPEg0lFVQKQshIqVQvZWnbWA/SyNxPrjVfYeq1MyYcHK7J00zU=
X-Google-Smtp-Source: AGHT+IEnPbKclbZK1r+x8GBe4uGCB2NXVtUPFTXAG/uwmGtNyD1JXsp6AzTWO/TZfkobPqWJhcA95w==
X-Received: by 2002:ac2:5323:0:b0:511:7292:c4db with SMTP id f3-20020ac25323000000b005117292c4dbmr1635947lfh.12.1707497725934;
        Fri, 09 Feb 2024 08:55:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWz6kJIDLeOKtNKbjPe1D54aOwOz2/kq7NfHYP52ckeHVjaWP9ImGoElaDvFKHBixpFBBINB23+pbztQiNF1M9iEasTBsy/k7bGhFBAWMTm7WX+KOFh+8MLt0Utau1Z7T9uEwPzh4T5+Z4UP8PiAK02MnMGguVa73/5I4ZCk2RLFXNzUiWLySOK
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id jd10-20020a05600c68ca00b0040fdc645beesm1142919wmb.20.2024.02.09.08.55.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 08:55:25 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-lvm@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH 1/6] 11-dm-mpath.rules: use import logic like 13-dm-disk.rules
Date: Fri,  9 Feb 2024 17:55:08 +0100
Message-ID: <20240209165513.7661-2-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240209165513.7661-1-mwilck@suse.com>
References: <20240209165513.7661-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We have to import the properties if either DM_NOSCAN or
DM_DISABLE_OTHER_RULES_FLAG is set, because blkid will be skipped
in both cases. Also, if DM_UDEV_PRIMARY_SOURCE_FLAG is not set,
it makes no sense to try and import the properties.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index b3117f9..e7be12d 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -79,7 +79,14 @@ ENV{MPATH_DEVICE_READY}!="0", ENV{.MPATH_DEVICE_READY_OLD}=="0", \
 # not. If symlinks get lost, systemd may auto-unmount file systems.
 
 LABEL="scan_import"
-ENV{DM_NOSCAN}!="1", GOTO="import_end"
+
+# If DM_UDEV_PRIMARY_SOURCE_FLAG is not set, the properties below
+# have never been properly set. Don't import them.
+ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!="1", GOTO="import_end"
+
+# Don't import the properties from db if we will run blkid later.
+ENV{DM_NOSCAN}!="1", ENV{DM_DISABLE_OTHER_RULES_FLAG}!="1", GOTO="import_end"
+
 IMPORT{db}="ID_FS_TYPE"
 IMPORT{db}="ID_FS_USAGE"
 IMPORT{db}="ID_FS_UUID_ENC"
-- 
2.43.0


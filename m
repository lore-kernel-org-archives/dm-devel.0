Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69834381BF
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 23:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707521277; cv=none; b=OcqgVX/T5IAlpI/X5gAm6icwtNWbJZL8vRa/nIVJYud14zlwBCXs62lx5fgSFEi3WNj1PpzeLJGgM+WB3vZJkYDH1UuxqNftG/OmmoPIzh8Zdkrhs0/5NKSORZi2NsMxoBGxw28pdI1WouQwmwFw5tYoRTqoktY2scd5YJ20Bqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707521277; c=relaxed/simple;
	bh=juVndOSHbLqiMXagx+PpMzzoeOQV4GjA6EAmwBFBbXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9js6KmQ9SBm5AaXq1o2AJ0qFXjbcOQiDB76QyZHrgglyRTxFGw5jblM2Y0aY3mECRCQboOl61uvs02f+pcu0dLWkZRk1qDAIfYGZytBla3t0hB5eYNNkCrZHKuVqvEyxPyqxymdggWCMLD0pk+XlryUkjWTYHYfpZA9dx8bTUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IzNbanUW; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IzNbanUW"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4105006bf11so12355825e9.3
        for <dm-devel@lists.linux.dev>; Fri, 09 Feb 2024 15:27:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707521274; x=1708126074; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qpHBjGBs5KT8NHv5Xjr68QkEb4nZ9M6hzLeZDP0nDA0=;
        b=IzNbanUWp+RjndN6cOtyha2QcfEHk/ScxR/u2OQq0H+3iH5LhdXZgp0vBpk+35C3Z1
         tABt6PNyOEpLfHH6QVH1E6baJqy2HtF/DZNPUv4bRlz9HIThehnM8HqnQWMUFGCmWIYW
         M4FLPVDzruEnNStbiULIgtdrJbqUWvyJTy2qg6G9YovVwvpUrisRKP1AeDgfy0Bw0hMc
         eW4b4tpzdR2qsnOgGRQE1+EuEhivxMN7J89QZoFPB70OQFUn/htvxiBargIaHjhPl9mg
         dQCdKM7eZ8PvlH09q/zceO63+RpR33QorZWkJ6VhF+7YOYkoDzPLZ5Eskbe2WvC5h9hz
         h28w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707521274; x=1708126074;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qpHBjGBs5KT8NHv5Xjr68QkEb4nZ9M6hzLeZDP0nDA0=;
        b=mCfUgRcLfE63ztL142p4LiTiAbbXX6MkcB0/kHDF0x9tNXkZ42E2/uUezUqFbhKhMQ
         Uvlo7V6Dc0sj0dwL8yLxLi00pli1RDTLkFZrDeVRtTcjXpTB8laa1Is57K2IquDgnBW2
         dtENhEGPDnf3QdIe5orjoyEQwfQ4BdHeaY66EzTTfQqV3cG6n5+MRgx0dd86dJbyGB5H
         SCyYkECZPmyPHdpAsMoPYIp/bwN/U5tfaTBNIUeR6k7riXQZ3xD07ADWiEZBhF5m3S4+
         7JSkAKYgoGY6ID4CNthWi+kAjMrthM2n1WHX2vhUl5sCj7XB5i6rYqKg19MrYL/xpRi/
         WYMA==
X-Gm-Message-State: AOJu0YxOs7WXDPWdtx/PccCko+WdGkgI55V7ZfarsZ+ogx8BU/VGUsOd
	MZnyIywpo2m0Boiv+KSj40B5zpl0LDqWjJb2QOMKPvp78MgqkJ/ggwsHy867ivg=
X-Google-Smtp-Source: AGHT+IEXVvWB7Fou5QV1hjHwzqAZ96DdgCblaPAqhalXH/5a/6EK8Hu1imh5cv6f4vKCDGiI2W3QgA==
X-Received: by 2002:a5d:634e:0:b0:33b:3a90:13ea with SMTP id b14-20020a5d634e000000b0033b3a9013eamr389715wrw.4.1707521273818;
        Fri, 09 Feb 2024 15:27:53 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU5jVEfXZVULwGaIPvPLfF90ab9O67ZmO5/ND/gYfGXGy4JSrxbZYDw2n9YogAwRbTd0g3sWEx4xkPOGG5RiFk+Z5YWa9nCZVKDKI9FIBkxGfsH2LyZo7fBgq3lf/SsQL3yhEI/9Wh2Rf+P8L0bdLY43fNWbQq53XxjOkC45q0HRyCUrOssL2Rz
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id g7-20020a5d5407000000b003392206c808sm369593wrv.105.2024.02.09.15.27.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 15:27:53 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-lvm@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH v2 5/7] 11-dm-mpath.rules: clear DM_DISABLE_OTHER_RULES_FLAG for coldplug events
Date: Sat, 10 Feb 2024 00:27:33 +0100
Message-ID: <20240209232735.9791-6-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240209232735.9791-1-mwilck@suse.com>
References: <20240209232735.9791-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For all "spurious" events, which includes coldplug events,
DM_DISABLE_OTHER_RULES_FLAG will be read from the udev DB in
10-dm.rules. Thus if a previous event saw the device in suspended
state, the flag will be set even if the device has meanwhile
resumed. Reset the flag if none of the conditions hold that
would cause it to be set in a genuine uevent in 10-dm.rules.

It would be cleaner to do this in 10-dm.rules directly, but it
cannot be done easily, because the flag can also have an origin
inside lvm itself; lvm sets it for various kinds of logical
volumes. For generic (non-LVM) dm devices, the flag is only set
in 10-dm.rules though, so doing this is safe for multipath.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index e31107b..8e8741a 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -9,6 +9,13 @@ ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}=="1", \
 	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.warning \"Coldplug event for suspended device\"", \
 	ENV{DM_COLDPLUG_SUSPENDED}="1", GOTO="scan_import"
 
+# Coldplug event. DM_UDEV_DISABLE_OTHER_RULES_FLAG has been restored
+# from DB in 10-dm.rules. If the device is not suspended, clear the flag.
+# This is safe for multipath where DM_UDEV_DISABLE_OTHER_RULES_FLAG is basically
+# equivalent to DM_SUSPENDED==1 || DISK_RO==1
+ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}!="1", ENV{DISK_RO}!="1", \
+	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="", GOTO="scan_import"
+
 # If this uevent didn't come from dm, don't try to update the
 # device state
 ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", IMPORT{db}="DM_NOSCAN", GOTO="scan_import"
-- 
2.43.0


Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B6E259B
	for <dm-devel@lists.linux.dev>; Sat, 10 Feb 2024 17:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707585217; cv=none; b=nYmPr+22qqcI3kZnwFQgtAWEIgxIl3tRPgypFNlxjKoAj7Lu+Az67Y1xZUeJS/TQokGbXUT6YDdJxZPD+W6GUnB9HfEsB8DhwdLn5l8VpVq2Us6TT/C1JWW9rE5FQa069LlzoWxKMdytfhxIbVNGTduiWs9fKAhxg/X4HZpNkpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707585217; c=relaxed/simple;
	bh=4AY96jOmZbV0J3rmVt6P4iQkPAUaFKGPoOVNu4zVUw0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OTd55EaHo8htNyYqhkWVeoXEhThSL9do5N4pO61c8kluhX75LuSpg9MmcaEgldNscACzro3kkNUfGle/FgPf56iIMwKDZoJuy+Y0VcvNI3yGYmWn7GDGx50qkvyG43HwQ+7Gibr1MXDsN1FYwoTHpm3LJzDAJNIGKSWO6gOLoww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=faOJle7y; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="faOJle7y"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4109236b855so3619065e9.1
        for <dm-devel@lists.linux.dev>; Sat, 10 Feb 2024 09:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707585212; x=1708190012; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rac8ORPtTf0KHWw+UKyoVl08mNgdC5kStOkBnQpqKDE=;
        b=faOJle7ylM7ol28bf4XQzYR4PyNVZUBh/Lu0w2MweB/Tu/iFNZDa99RisHSfqNlKUX
         5d+Aut3v915oXlpsmhsPE9Bo18PT7q7q+xOhWsPcKMAM+Bj2ymmOYeFIuFquAnRfBrbf
         DObKzsD3KrVamZ1K+iiqX68WfvE9mJsAkGkyFAcCYPQcBT8IK3pdUkjIjl1LElkBaMf1
         d96Tag2QzKpNEG00R5cAbsUptVZdsC00gQF6p6sO8djNojzLYKujBoXQw7HWn13eYOOe
         RDA/4hnSOWipaZnokTz8Te3K+EixplLRGQ3k9SHBoLq1JJyD+JKYHAbP/fnLuitTGxG/
         E73g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707585212; x=1708190012;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rac8ORPtTf0KHWw+UKyoVl08mNgdC5kStOkBnQpqKDE=;
        b=KokasKoMdLahTOE0V3kjvxe9VGnka3xXwQ0DMjM1g2UUfs7ncCBg4jRWsymNVQMppK
         SSSZHCBcb619p4fqY1l7lYQJ8MVa12zwuqBQTrXgB/Hk0SPX9h5L397hYG+5PoPz0j/d
         3qlzj2+yG+wsKsB50inUuHrW3x4YAwXNQGYm9cxREVpuwQdQaPQaM0GGECKFRiBueoRF
         Lf81oz657stwAd5ofY+op4UvD55n7WksGAz0xiME2bR4sqj5r69Nd9EBom9KBrP6a3B2
         g+zUGGCE8XHmxh1WaGpnHd7/zZIfI+SnKJRUTqXLI/ZGdnGpWohgumFO8W1tHf07TM5u
         h8Mg==
X-Gm-Message-State: AOJu0Yx4bkXpv80BlLX62s+Tf7rSsv/8b/aU9VVsFj5vaDblXsYH4KYu
	vroNttq+fqmvtCcMK1iXEIcqRMZNxhsxbKEQKJbOUA59XbmdV1il7Zkyavr6q38=
X-Google-Smtp-Source: AGHT+IH0o1lk1GcX44uyWefonvzBlZEs42+03V7hl+Sx4eBgYIhIsPJpO/cFPwgmhcrqDPIMCs337A==
X-Received: by 2002:a05:600c:1f18:b0:410:7d33:25d4 with SMTP id bd24-20020a05600c1f1800b004107d3325d4mr1812932wmb.25.1707585212084;
        Sat, 10 Feb 2024 09:13:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWPyPnnhH2uLqYqLpO/w2WRjBJJi6GlsXI+5c5PHiRlNzFHKD/WO9FV23QJj8COL/N2Nxg+lgatIGUcOMJiV8w6UkCObQ0rG9gH35+z7WmnDvKQp5zfxnS9f5jcm/euwqCO6FkFPnC+53+Q0yjPSDdlRA0ObvS2pXrD+3OwNhQ8cAldpB2fL3Co
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id f13-20020a05600c154d00b0040fb783ad93sm3752129wmg.48.2024.02.10.09.13.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Feb 2024 09:13:31 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-lvm@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH v3] 11-dm-mpath.rules: handle reloads during coldplug events
Date: Sat, 10 Feb 2024 18:13:27 +0100
Message-ID: <20240210171327.11811-1-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a map reload happens while udev is processing rules for a coldplug
event, DM_SUSPENDED may be set if the respective test in 10-dm.rules
happens while the device is suspened. This will cause the rules for all
higher block device layers to be skipped. Record this situation in an udev
property. The reload operation will trigger another "change" uevent later,
which would normally be treated as a reload, and be ignored without
rescanning the device. If a previous "coldplug while suspended" situation is
detected, perform a full device rescan instead.

Signed-off-by: Martin Wilck <mwilck@suse.com>

---
Changes wrt v3:
 - restore DM_COLDPLUG_SUSPENDED from DB lest it get lost
   (Ben Marzinski)

---
 multipath/11-dm-mpath.rules.in | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index fd8d202..30d6e78 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -5,9 +5,16 @@ ENV{DM_UUID}!="mpath-?*", GOTO="mpath_end"
 IMPORT{db}="DM_DISABLE_OTHER_RULES_FLAG_OLD"
 IMPORT{db}="MPATH_DEVICE_READY"
 
+# Coldplug event while device is suspended (e.g. during a reload)
+ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}=="1", \
+	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.warning \"Coldplug event for suspended device\"", \
+	ENV{DM_COLDPLUG_SUSPENDED}="1", GOTO="scan_import"
+
 # If this uevent didn't come from dm, don't try to update the
 # device state
-ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", IMPORT{db}="DM_NOSCAN", GOTO="scan_import"
+ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", \
+	IMPORT{db}="DM_NOSCAN", IMPORT{db}="DM_COLDPLUG_SUSPENDED", \
+	GOTO="scan_import"
 
 ENV{.MPATH_DEVICE_READY_OLD}="$env{MPATH_DEVICE_READY}"
 
@@ -43,6 +50,16 @@ ENV{DM_ACTION}=="PATH_FAILED", GOTO="mpath_action"
 ENV{MPATH_DEVICE_READY}="1"
 
 LABEL="mpath_action"
+
+# A previous coldplug event occurred while the device was suspended.
+# Activation might have been partially skipped. Activate the device now,
+# i.e. disable the MPATH_UNCHANGED logic and set DM_ACTIVATION=1.
+IMPORT{db}="DM_COLDPLUG_SUSPENDED"
+ENV{DM_COLDPLUG_SUSPENDED}=="1", ENV{DM_SUSPENDED}!="1", \
+	ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0", \
+	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.notice \"Forcing activation of previously suspended device\"", \
+	GOTO="force_activation"
+
 # DM_SUBSYSTEM_UDEV_FLAG0 is the "RELOAD" flag for multipath subsystem.
 # Drop the DM_ACTIVATION flag here as mpath reloads tables if any of its
 # paths are lost/recovered. For any stack above the mpath device, this is not
@@ -57,6 +74,8 @@ ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", \
 ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", \
 	ENV{DM_ACTIVATION}="0", ENV{MPATH_UNCHANGED}="1"
 
+LABEL="force_activation"
+
 # Do not initiate scanning if no path is available,
 # otherwise there would be a hang or IO error on access.
 # We'd like to avoid this, especially within udev processing.
@@ -99,6 +118,9 @@ IMPORT{db}="ID_PART_GPT_AUTO_ROOT"
 
 LABEL="import_end"
 
+# Reset previous DM_COLDPLUG_SUSPENDED if activation happens now
+ENV{DM_SUSPENDED}!="1", ENV{DM_ACTIVATION}=="1", ENV{DM_COLDPLUG_SUSPENDED}=""
+
 # Multipath maps should take precedence over their members.
 ENV{DM_UDEV_LOW_PRIORITY_FLAG}!="1", OPTIONS+="link_priority=50"
 
-- 
2.43.0


Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02C522EF8
	for <dm-devel@lists.linux.dev>; Mon,  5 Feb 2024 12:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707137214; cv=none; b=eDUBltBBWQ3tznPzYztkpqyPCfnR+JVQq+hpXU3usR1EMfQdCOg5nesZ8zQdl5tciysatMYfFvuuvgnSVJpji+kVVFEHWuK00kiAgdz7E3NUHSvr9pRJGITbipa3Qzx54o87bDMMVzkT2iv6tf64g0fgIEnF4NGkT5FZWV74CKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707137214; c=relaxed/simple;
	bh=D2Vl0FmplNSA93s1bIfQaWieJL2IHHa9jsFmOrweAKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUi7rsuQeqAKRq69uSWcOo1X0KbDfS302umjzqPzzC8KZGuwZSZxq9CfgNVT3Ba1s99nZfnaB5FzMUyrP+AEtjCoBVWjlJTqEQbvFQCh5xGRPnv+MXTu15xqSFt6VyoJSVnZJRr1OC7f2N4J/dzXJknrZFOnE23fjF1p74CtVZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GLNpSKSW; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GLNpSKSW"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-33b130f605eso2822186f8f.1
        for <dm-devel@lists.linux.dev>; Mon, 05 Feb 2024 04:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707137210; x=1707742010; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fTq3LbSBVSDVVJF9Agks6bAQ+2mtZSg8+mqEtrlbwWg=;
        b=GLNpSKSWJMktj9px7WEseE9KtVqv/5b0wZWBSW83e0lA5Ha4SE0DAZlKBbUCRbxEKx
         aruliaWM/t+4fTMsPqu4lreBaPNqQYTzqi8J++0N/MHTpIDcD9lUn1s2Iu+qvsEBeQ8O
         d+p53aQOI/ZsZmVOI24hKwNrFaiE7+ifjqRvtf+0NN41gBFOhOl01iuvQmqEZWjHj0/I
         1y4KyxO6mjXN6rXgwqD6NaRw0vgSXx9BBsMm1iQ4Fai9KC3UwoPX8C2k0jkfjbNP/EL6
         KLa4KDhYblmBZq0+bjITx70Bh39nPigKWov3AmoVbZTd2G/Ds1BxYD6F93jDhN/Ngg25
         DmCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707137210; x=1707742010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fTq3LbSBVSDVVJF9Agks6bAQ+2mtZSg8+mqEtrlbwWg=;
        b=AWWirtBYdGG6xHxus0VOnIsAodGFk83XGmF13GXuKqmwa8pW8cz0u/nLDR2rJaE4nC
         n+pBlWnQsFXaIeq30BWJO4UFuahcC6drV0MIhFkvvcl8sCZCA+sv2isX3kRSnmT8dlSm
         57fQj6S/OTBHdebeimVYemo/MdIZYhTWGE7NLJzViMxhIIrGZSYkm1qDU3Mwg45nQ0v/
         BdDZvw2M8yC7lOzNEy/cP5wmGijOTmEDs89uF8CCrbkyaJtYY8TKS/OqU1RTMntZC9dN
         vOviqmnfdZ8r5sipOiComn0UNF/DbaBtjHSg687i8fgUuORN4e4iv7YcTMyyhqScGQqD
         Fcfg==
X-Gm-Message-State: AOJu0Yy01x5rhfxl1y7FNpmIEqomEgrAmWNnN6OpZY9y6YVs+cuWitMv
	9J5vckIOUxsVAMWH6yTS2xWl3w+cn9o8C2ENqzmfNxuWidYV2gJGZmhh4QxNjC4=
X-Google-Smtp-Source: AGHT+IGnmvB4DrfaiXnbMISwSoozD061LR730vtYXabaWmWqAUCItDzXerhfIc67IZtFYKZ5hRbeCA==
X-Received: by 2002:a05:6000:144c:b0:33b:3b86:b845 with SMTP id v12-20020a056000144c00b0033b3b86b845mr2825597wrx.58.1707137210348;
        Mon, 05 Feb 2024 04:46:50 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXTsvf9oynPrDc9Ln7o/M56uVM5NLLAJqO+CuDMDGAJ4KF9xAwA2cnrzAELPu3vrnovYyGxRCeNinMKTSOE747HX6Y4ukZznQVyG2qQ0YYGxkYJrjuXx6ofuTP/YB/q9GMfQ0GnzapNaqw2SCZ8vuGlCnrKjDQhlQHFQ0uhZuA6nHt/O06turTN
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id v23-20020adfa1d7000000b0033b37fe0577sm3302915wrv.54.2024.02.05.04.46.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Feb 2024 04:46:50 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-lvm@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH 4/6] 11-dm-mpath.rules: handle reloads during coldplug events
Date: Mon,  5 Feb 2024 13:46:36 +0100
Message-ID: <20240205124638.17877-5-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240205124638.17877-1-mwilck@suse.com>
References: <20240205124638.17877-1-mwilck@suse.com>
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
 multipath/11-dm-mpath.rules | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
index 8fc4a6f..2706809 100644
--- a/multipath/11-dm-mpath.rules
+++ b/multipath/11-dm-mpath.rules
@@ -9,8 +9,13 @@ ENV{DM_ACTION}=="PATH_*", GOTO="check_ready"
 
 ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}!="?*", IMPORT{db}="DM_UDEV_DISABLE_OTHER_RULES_FLAG"
 ENV{DM_NOSCAN}!="?*", IMPORT{db}="DM_NOSCAN"
-GOTO="scan_import"
 
+# Coldplug event while device is suspended (e.g. during a reload)
+ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}=="1", \
+	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.warning \"Coldplug event for suspended device\"", \
+	ENV{DM_COLDPLUG_SUSPENDED}="1"
+
+GOTO="scan_import"
 LABEL="check_ready"
 
 IMPORT{db}="DM_DISABLE_OTHER_RULES_FLAG_OLD"
@@ -53,6 +58,16 @@ ENV{DM_ACTION}=="PATH_FAILED", GOTO="mpath_action"
 ENV{MPATH_DEVICE_READY}="1"
 
 LABEL="mpath_action"
+
+# A previous coldplug event occured while the device was suspended.
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
@@ -67,6 +82,8 @@ ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", \
 ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", \
 	ENV{DM_ACTIVATION}="0", ENV{MPATH_UNCHANGED}="1"
 
+LABEL="force_activation"
+
 # Do not initiate scanning if no path is available,
 # otherwise there would be a hang or IO error on access.
 # We'd like to avoid this, especially within udev processing.
@@ -103,6 +120,9 @@ IMPORT{db}="ID_PART_GPT_AUTO_ROOT"
 
 LABEL="import_end"
 
+# Reset previous DM_COLDPLUG_SUSPENDED if activation happens now
+ENV{DM_SUSPENDED}!="1", ENV{DM_ACTIVATION}=="1", ENV{DM_COLDPLUG_SUSPENDED}=""
+
 # Multipath maps should take precedence over their members.
 ENV{DM_UDEV_LOW_PRIORITY_FLAG}!="1", OPTIONS+="link_priority=50"
 
-- 
2.43.0


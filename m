Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E461CDA12
	for <dm-devel@lists.linux.dev>; Fri,  1 Nov 2024 21:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730498338; cv=none; b=IloV6BJLtVjH3C652z75Xb9ltOautXygCbHM9vZhDauDrUz7QMKO8XFiUpYKp9Cpht58ph5dbF1rccA48LKXRfGHPV+24tc8qFmreXQn3qRGKsQFz+lsipJTiygpNzRRT/twbH9GCxbrxddWwopeGEnjvjOImUIBFsOtOTZtiXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730498338; c=relaxed/simple;
	bh=y4U9iPrzRx1fmNaDXtpeyk4HL4jw69wuQNInyAWw+Yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmPGj29EBrZKlSoefeMVvZWaGR6p2ysEn1e8WxEEgIj9eq+BWeNKcbIEzIsVyNRT8uCK2QoCSWP4ajO4lDrwLPQjSItDh1ix1pjQhR2G4AVVxozzUJVTM14OP0jYP+I5quAxg6Vg5Xu9kGEA/3hhEedq21s1OFydVwVp5jL53AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VCkZwOwB; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VCkZwOwB"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5c9709c9b0cso3524162a12.1
        for <dm-devel@lists.linux.dev>; Fri, 01 Nov 2024 14:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730498332; x=1731103132; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Fo6mER/MrdLTL8ecoNmszLXLw94Lvyub5gjrXUN81Y=;
        b=VCkZwOwBMmgLKSH5ZYt4JKjh0gis/vnK85IWyEKfi58YdCnfXDe3wZm1ctt8cGWnkH
         5Mol1OhroLWSwLnbZEip+DuxJrAZy4snbIa5IZUX8Hlh1FldxFevxOQr5ga1L/AVyVCD
         a07BtpOFzer0pAedOmzoNZNmrOmkvLnVsQNmwOKkqjSru+S5XvUP/qO+pjKqk8LKjfxc
         O6iVqohKnAxRNtJJAJMYsJf2FuMQ3zLN/eBb+zh4BPMyl7yDDUSTIiQgyksuK1qAWAvl
         0oWYbFwx2c+8TxrL9QAFf1UNmKyJSvdoQPGW/w8vmzl+ugAuYkV+LqlDOTIcFRawRFDF
         xlSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730498332; x=1731103132;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Fo6mER/MrdLTL8ecoNmszLXLw94Lvyub5gjrXUN81Y=;
        b=SZDJSzEybKHspCRsTgARcPuERsfgDxG8lLKrQif7Fa4wBPkBwxPLq9Hr81MXtzzaZu
         faT3kBTo/HS+pJjsr9LXBn7Co+sjEuRtW1+JlVCsztATOi9gVZE48fIT86XG2pSNc04J
         B/WqoFYUtlJ3vYa/IKIESLjL2eZ5X9Ci+O8B6HoRNIbQDKPqrXnDIGSfggme1MZKLonT
         lppuiyBt5XDpYnlPdg/rVwhWUPxtHKnW3x/Rze0Sk2pBJQ8rbXquZZogr+b+pRdUKzBe
         dczxT1nrm/KNmNasz0SAAo6WXxQBOXAWaXofR1SgR3H3V7I9eu5eGwry2eF323HxVyTZ
         Sv9g==
X-Forwarded-Encrypted: i=1; AJvYcCXQ45Ds2yhWvOIanz4T2qWloKL+iavLzghS1H3VcGsQVcxArm5BuH7RneJ9Rphy8CCs/MmYjTfcPA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyjlxT1R5Po5ljCzLWRnUlhaj+ozr0wBt25towql7FBrbZstw42
	yxu9+fN3Bo4DSLWphol/C3JtGW3Xfc4RSjoqpugGYL1075zc2yt9g9O3zijOewg=
X-Google-Smtp-Source: AGHT+IFUGpHDKGSj5vhQdjtJyEPpoogU+MYDI0jZjZ29dgkDcg4rR8EGUnb4qIElYFdgZaWVtXFaTQ==
X-Received: by 2002:a05:6402:d05:b0:5c9:6fc1:6177 with SMTP id 4fb4d7f45d1cf-5cd54a84c8fmr9025746a12.11.1730498331935;
        Fri, 01 Nov 2024 14:58:51 -0700 (PDT)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5ceac7c8d9fsm1934210a12.77.2024.11.01.14.58.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 14:58:51 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH 1/3] 11-dm-mpath.rules.in: import DM_COLDPLUG_SUSPENDED only once
Date: Fri,  1 Nov 2024 22:58:38 +0100
Message-ID: <20241101215840.1077082-2-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241101215840.1077082-1-mwilck@suse.com>
References: <20241101215840.1077082-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We import DM_COLDPLUG_SUSPENDED in all code flows below mpath_coldplug_end.
Clarify this in the code.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index 30647b9..6783826 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -24,12 +24,13 @@ ENV{DM_UDEV_RULES_VSN}=="1|2", ENV{.DM_SUSPENDED}!="1", ENV{DISK_RO}!="1", \
 	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="", GOTO="scan_import"
 LABEL="mpath_coldplug_end"
 
+IMPORT{db}="DM_COLDPLUG_SUSPENDED"
+
 # If this uevent didn't come from dm, don't try to update the
 # device state
 # Note that .MPATH_DEVICE_READY_OLD=="" here. Thus we won't activate the
 # device below at mpath_is_ready, which is correct.
 ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", \
-	IMPORT{db}="DM_COLDPLUG_SUSPENDED", \
 	GOTO="check_mpath_ready"
 
 ENV{.MPATH_DEVICE_READY_OLD}="$env{MPATH_DEVICE_READY}"
@@ -67,7 +68,6 @@ LABEL="check_mpath_unchanged"
 # A previous coldplug event occurred while the device was suspended.
 # Activation might have been partially skipped. Activate the device now,
 # i.e. disable the MPATH_UNCHANGED logic and set DM_ACTIVATION=1.
-IMPORT{db}="DM_COLDPLUG_SUSPENDED"
 ENV{DM_COLDPLUG_SUSPENDED}=="1", ENV{.DM_SUSPENDED}!="1", \
 	ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0", \
 	PROGRAM="@SYSDIR_BIN@/logger -t 11-dm-mpath.rules -p daemon.notice \"Forcing activation of previously suspended device\"", \
-- 
2.47.0


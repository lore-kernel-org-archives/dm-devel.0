Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA5C1C6B6
	for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 21:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711314803; cv=none; b=mfzUfK1KSnNpEft4isg9nNPygRYVrcfhyMgU87538cvcPmeagcVvtWvNuHiXkYJd1wc+voaWAixFNTtfZlJ5Z8mZsm7Pu7P5uUIVZFhwny0SCCmUjqdYRg5FGcB/jYlMCZaCeceXDpxmGjZ9blhDZckGVxmXbx+iZ0B3f2yKWl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711314803; c=relaxed/simple;
	bh=jTnIrmusTnr2O0jwYdqF2YUL0D1wNEdqxmV7lDJVWpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0G+Ho0nQQlVJfPluUBc2cASjbZYt2glAGCkkFvDYcCfmWMWDfCuHeVWcukoakPZ0JtayBO2U50kO4qvFSkCisJ2aSl9MN3Cv5sdezjCIga1SdHXmPA5DUG7UJM9aFWonb2+n4DmPNCm3dvRF7eBEcXT9oTBWxSajlI3Ya31DiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=I2Svqatp; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="I2Svqatp"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-56c0521a636so929701a12.0
        for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 14:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711314799; x=1711919599; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ROPZyVLWcvbbXffyFfsATCl1tKIZ+LH7D/oYWsZLXO4=;
        b=I2SvqatpEvBtcohq3fLdEsu1YeuZbjJgcKU66zTuP8Ff/GnVmCdPgNN1uaNPI4/lzq
         IeCFcZcUBjma0zpF3xP1E5OUv2fQXW6QS7B4Qtovn85YCCp8ZJntyq6y2NIqniQX8bC1
         9fdYyeVthKgR3HLmPOsjpGNYHbByiA2rIv6oO5llrlmJCAZ93tQslTKNJjYNjqDcGtTC
         CIDNOFHfHXWxBBFaW+t5h92SfQadvEIafTF8fTVruQVgEPpWNTqLB3e8UGb0iZ87BMb9
         T8YRB7QcQJilE4z8SpmNDZjnCKhv0ML5n9FAmduCeB45ZqvF2htOR5p1IElL1GjbhLU8
         W0mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711314799; x=1711919599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ROPZyVLWcvbbXffyFfsATCl1tKIZ+LH7D/oYWsZLXO4=;
        b=jHupFswmfcjPU47am6hr9U0+3DlRAOj1KKdMpviAhrhMTyt8uBXj2WGdhB+Xq5pND3
         FgNnwDnXM73mKgk/Bm4lMg0GcYgOiYeJGHQzyOWQ7Nw6O13xNAl9Z7bjw+Y+yaW1Khwl
         zFk8qbSLstYkuvEzdz2qXLTd50l9fCYYn35bT7iE0OVh5UcinYA8buIlNrWSAyW8VOP0
         lmeUtLWlFn9pbDJBGqiPrFseeWPlI1x0CFhOyG3fOiaLYaX7/+RXKT6nhJw2nnuZyqxP
         yeOteLbyDBWGld/Kznp1jSfMqASaO7vdKVk1d+oKPN3SUW1Lv+BGcbbG14XDAZNmph0T
         LRuA==
X-Gm-Message-State: AOJu0YzXVB2agmUTZa8G5prKGb+Xby6PMt4Z4kwGtqEcDehzN3OTmRRp
	FDUfhvospkY5mkdLi9Lmzlis9CDoXrbgduQmo16FlCFOiVjYL5f6TPUnz2ZSSpU=
X-Google-Smtp-Source: AGHT+IG2u2K3cWLHVIJnp/imYRsyVb0+yjTKHQ4tb99f8lTj4VW6FPKv2jnD/VLV2B9UzETaJzTxSQ==
X-Received: by 2002:a17:906:6a04:b0:a47:4d8d:9483 with SMTP id qw4-20020a1709066a0400b00a474d8d9483mr2509490ejc.59.1711314799062;
        Sun, 24 Mar 2024 14:13:19 -0700 (PDT)
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id i16-20020a170906091000b00a4735fc654fsm2304006ejd.205.2024.03.24.14.13.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Mar 2024 14:13:18 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 05/11] 11-dm-mpath.rules: adapt coldplug event handling ro 10-dm.rules update
Date: Sun, 24 Mar 2024 22:12:55 +0100
Message-ID: <20240324211301.7200-6-mwilck@suse.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240324211301.7200-1-mwilck@suse.com>
References: <20240324211301.7200-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With late late patches for 10-dm.rules, DM_UDEV_DISABLE_OTHER_RULES_FLAG is
never restored from the udev db. Thus we don't need to clear it here
any more for coldplug events. Also, we must use .DM_SUSPENDED instead of
DM_SUSPENDED as input flag with the v3 rule set (other occurences of
DM_SUSPENDED will be replaced in a follow-up patch).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index 997e3e7..cf004fd 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -9,12 +9,17 @@ ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}=="1", \
 	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.warning \"Coldplug event for suspended device\"", \
 	ENV{DM_COLDPLUG_SUSPENDED}="1", GOTO="scan_import"
 
-# Coldplug event. DM_UDEV_DISABLE_OTHER_RULES_FLAG has been restored
+# Coldplug event. Import previously set properties.
+ACTION!="add", GOTO="mpath_coldplug_end"
+ENV{DM_ACTIVATION}!="1", GOTO="mpath_coldplug_end"
+ENV{DM_UDEV_RULES_VSN}=="3", ENV{.DM_SUSPENDED}!="1", GOTO="scan_import"
+# With DM rules < v3, DM_UDEV_DISABLE_OTHER_RULES_FLAG has been restored
 # from DB in 10-dm.rules. If the device is not suspended, clear the flag.
 # This is safe for multipath where DM_UDEV_DISABLE_OTHER_RULES_FLAG is basically
 # equivalent to DM_SUSPENDED==1 || DISK_RO==1
-ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}!="1", ENV{DISK_RO}!="1", \
+ENV{DM_UDEV_RULES_VSN}!="3", ENV{DM_SUSPENDED}!="1", ENV{DISK_RO}!="1", \
 	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="", GOTO="scan_import"
+LABEL="mpath_coldplug_end"
 
 # If this uevent didn't come from dm, don't try to update the
 # device state
-- 
2.43.2


Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0925F5EE80
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 22:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709332851; cv=none; b=Pe/H3b3cMKaD35LgJU4TuMJ+sd/IfVghBBGw/iMbYTeHM8HxYfy4/Xcik4mDL6izQGJ8pFF1lFXRE+a0b1R+T5nhiXWUSy3MDkbugK1LQiRh5AEk6lHVuUMRxWdagfIm6NUrS7wF95fpHw4HPhsHum5Ugd0ZcYfx4ie9SiqWs8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709332851; c=relaxed/simple;
	bh=XwLouIOkyoFFCY/NijAavYEmB65ECJZxxV2Smeki4qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5LdWfAQ185ctAiZae/M0Q2rOUQP1vD9UhwYFI6SVgXdl0I/ROgQB3Bf0VMFWWSGsPWDwKjdqvFWjqrONCsTe/8TfSBjDzqKUUA0Q9xVkME6lH6WJ5etOVqls90qlqj0Om8NFxizdXQsi8EUgd2IvBbUrVKBAL1q002cKMFm62I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PN4rYPgv; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PN4rYPgv"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a446478b04bso269730666b.3
        for <dm-devel@lists.linux.dev>; Fri, 01 Mar 2024 14:40:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1709332847; x=1709937647; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6q7Z+JuTjKNCARoW6XoPy3jitO6RjQKV6tGuor3jKWM=;
        b=PN4rYPgvV6TcffYXWiwgzN/HYYUYgJLxjf32cui/9yIK4zXu05yD8SWSBOV6ydvK1o
         wsQVTG7hO75N55WnCeRmm7UdlQyOGeYiBri/ITCUH04Ay798XrWpI7+AjjfqGkhGeIZ4
         foTLVH13EIO4gE+5eW9+RVLIeKAgb3CEdVd+PiLf09QAAEaVHWk7a9CP1iQExXlVwYuU
         8iJWn+CHbodJEpw0fQpgo5TEl2CO84mT8hkC2AVUVTud734AmzdIWIy15kicc9OTRNik
         ASVPGIo6JJFRkZjnwnEZ8SVzJ/6O2sUm87x+SWv2snIXTdnoNZT6fFS7Hfkbd2a2pEYI
         Os/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709332847; x=1709937647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6q7Z+JuTjKNCARoW6XoPy3jitO6RjQKV6tGuor3jKWM=;
        b=ZvE66C6pL9uVBhZWbPaeiXNeg/pcLNiPawi+YsjzUu174mzIu6il5Cyp4OPt3JT0F0
         TaMd8PJUeQA1FgsAwLchAjmmqjwa/xjG9D414eTMnhniB9uv/xPfs9HSrYjKHiZwaG02
         aJTmYOLgh0nW3Cx4Y2sZ18DcIXqe4kmDSvWATEsgl98QFXRzDpMdKdY01hHlgmfk/5ut
         Go0rOtA+KRp6a0mf9U/x4DejWCZ+wo9AMxa0Rk1Uly0qwf2RraqHzZS4Jqx0FRCgYXEG
         s7eYIiiPH5nKHfJ2FEQhoM2V6JfrLmO3qAMWL5qMFlkeKWDkznrwx98gnemA9oPz+fUP
         L5Ow==
X-Forwarded-Encrypted: i=1; AJvYcCVqHY4Schw2HgKE/5oR4uTXGLHe346ADNyL64bu3OXhnCgPAF/ddeubiDs4bjaX8OH3TpAxe+r2YekN3S9Ge+uRcNzSPXykXwA=
X-Gm-Message-State: AOJu0YyiGQaLtgbzgzWPF4NOQBTu6q7+hhTWi6W4QblxIQlBSQcU+oKV
	KL9cZWG9I0MGL3QPhsn2Tqf98VXF8mwm3mH6ni8Mz6xOI2B3i9ZIya+vvoSwVbM=
X-Google-Smtp-Source: AGHT+IEl4P2vuj0lshHbB5C5Q/Mx9Zq7iOobkkv3ARuG9BlHZoWUG2mYHgzMjixVnO2oXOgdc7fIGw==
X-Received: by 2002:a17:906:f89a:b0:a43:a628:ff31 with SMTP id lg26-20020a170906f89a00b00a43a628ff31mr2760430ejb.26.1709332847544;
        Fri, 01 Mar 2024 14:40:47 -0800 (PST)
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id s22-20020a170906501600b00a42e2bc82dbsm2084406ejj.169.2024.03.01.14.40.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 14:40:47 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Peter Rajnoha <prajnoha@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Teigland <teigland@redhat.com>
Cc: linux-lvm@lists.linux.dev,
	dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Hannes Reinecke <hare@suse.de>
Subject: [RFC PATCH 4/7] 11-dm-lvm.rules: don't restore DM_UDEV_DISABLE_OTHER_RULES_FLAG from db
Date: Fri,  1 Mar 2024 23:40:08 +0100
Message-ID: <20240301224011.11117-5-mwilck@suse.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240301224011.11117-1-mwilck@suse.com>
References: <20240301224011.11117-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

DM_UDEV_DISABLE_OTHER_RULES_FLAG is used as the "output" flag of the
device-mapper rules, to be consumed by non-dm rules. It is a logical OR of
several conditions that might make dm devices inaccessible. 10-dm.rules
calculates it for every uevent, whether it's genuine or spurious.

DM_SUBSYSTEM_UDEV_FLAG0 is just another flag that needs to be or'd in. We
don't need to restore the previous state of DM_UDEV_DISABLE_OTHER_RULES_FLAG.
Actually, doing so is wrong if the flag has previously been set because the
device was suspended, and the device isn't suspended anymore.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 udev/11-dm-lvm.rules.in | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/udev/11-dm-lvm.rules.in b/udev/11-dm-lvm.rules.in
index 7c58994..0b77fe2 100644
--- a/udev/11-dm-lvm.rules.in
+++ b/udev/11-dm-lvm.rules.in
@@ -26,14 +26,11 @@ IMPORT{program}="(DM_EXEC)/dmsetup splitname --nameprefixes --noheadings --rows
 # to zero any stale metadata found within the LV data area. Such stale
 # metadata could cause false claim of the LV device, keeping it open etc.
 #
-# If the NOSCAN flag is present, backup selected existing flags used to
-# disable rules, then set them firmly so those selected rules are surely skipped.
-# Restore these flags once the NOSCAN flag is dropped (which is normally any
-# uevent that follows for this LV, even an artificially generated one).
-ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", ENV{DM_NOSCAN}="1", ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
-ENV{DM_SUBSYSTEM_UDEV_FLAG0}!="1", IMPORT{db}="DM_NOSCAN", IMPORT{db}="DM_DISABLE_OTHER_RULES_FLAG_OLD"
-ENV{DM_SUBSYSTEM_UDEV_FLAG0}!="1", ENV{DM_NOSCAN}=="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="$env{DM_DISABLE_OTHER_RULES_FLAG_OLD}", \
-				   ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}="", ENV{DM_NOSCAN}=""
+# If the NOSCAN flag is present, set DM_UDEV_DISABLE_OTHER_RULES_FLAG
+# so those selected rules are surely skipped.
+# We don't need to save and restore the previous of DM_UDEV_DISABLE_OTHER_RULES_FLAG,
+# that's taken care of in 10-dm.rules.
+ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", ENV{DM_NOSCAN}="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
 
 ENV{DM_UDEV_DISABLE_SUBSYSTEM_RULES_FLAG}=="1", GOTO="lvm_end"
 
-- 
2.43.2


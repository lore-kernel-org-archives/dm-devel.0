Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F0A5EE6A
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 22:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709332850; cv=none; b=t9dfAOG/3CB7rpAsNBHCN69UbMTIg1dffpKmS5OIyFHhZj6aN0iQiz64a0aoZys6F++SFg1qs7H9Q5CL+r+wLTNzWSAQlEVZuH3e1DgdEUDQYyFABbZxqC6RhN9qAh+2yn1HWU1JmQ25MqIK87kFsn1slGM9ncWxjyq2KlKoq6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709332850; c=relaxed/simple;
	bh=Ah0wwrQbOfb0DF3FLO3ZWWBYBsheiGMUZGVYdN6lKhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImrnZwVPET7vE1HmKp9aVWD6b7oDB2QJ3boOwvwdr1IyILqqmwYBoIq4XusoO7At0/HdX4Lqpj9udwdid5KNYnxGgIQqFsIEWd76RIKHU8FUlsaeRvWGzGQM9KlBjkUW1sJ4SC/sVjtqEs+YcBgy17H+u7jcnOGgM78CNVgDlKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DxhD5db5; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DxhD5db5"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a3f3d0d2787so386312866b.3
        for <dm-devel@lists.linux.dev>; Fri, 01 Mar 2024 14:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1709332846; x=1709937646; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C2ow6Gr56HWizluoYRmTkM1M2od1AQq+6bxnH60MW/U=;
        b=DxhD5db5Z2682uHx23ahE6gx7NP7EkoDz5sxHABRqPeVpppGjQqwia50TRQYPcpejY
         lWdthBAWHN/Ne5YQgTJ5bjs1ralUaZPOe+uS45Q+hXD1etuQoapXpXroa2F1cGiACtSu
         JJDMjOfb0xQncTkb2VYP/DwxooPZBXgEwd0YVXABIYJKafkbmITZDMHAZm33HZmw710P
         Brt7UAjsESkWbJkNqTBxBaUioChGxLH4ytraIxy+A5pyRUlFPloAH9Zn909CCanNeUKO
         n5gicpTy+8SbunQRZ7mNgLR7BIASeOM/0OVnGoSyBdmFaHaG8MKzis8ZOTXCNHbS0Nmi
         dc4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709332846; x=1709937646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C2ow6Gr56HWizluoYRmTkM1M2od1AQq+6bxnH60MW/U=;
        b=YoueL4rGi8esz5s3cn5dMDWwFmg0QYOIMTGJ9OTxyF2D1XT0JqHbD2RcTlfNfG4UDp
         Ypd6X1T3rMMpXmo5wGqNV3Cn1hk5Brfyvn5Q6luyiPCdt4+k8rgapRPNkkMHVClkNoGk
         OtCku0h1ZHQcVZJR2GY7/1jwyUo/NDCq6TD1NjqsNPbofzxikXXRc4h+ovIjTTbYz8qH
         wiihSFBpmlx5aIKB8vNdorPg9uEx9U1l9wC5ndTYXbLzVDGC4XvLWsBh/xLFVi04tmBJ
         lmz6aMyJMz5QV53lR2n1/3+bvFtMTZzPgeHvhUFXbcr6FSHHIq353gfAJL6nlC2DBUxY
         MqwA==
X-Forwarded-Encrypted: i=1; AJvYcCXClaSE5BORgc8Bq3v0aR8nBIDlS+GBlKfL7XaprdqiylQXt8BqiKDekXjdt4BKHw4m/StaoBEikZV21xhQPEQVGpWERupnBbk=
X-Gm-Message-State: AOJu0YxkUFAiwmiyJbHhwoSvizALva5UgCFogfFqEQmNCcIG9UZHoRse
	N7Wqrm1OtDccD3sJt7BBgUKHSEG2elRkZvNFsBvlInqKd/fOTOcQdznIZY0MSXo=
X-Google-Smtp-Source: AGHT+IEs9BSpKyibUXm8RRi8iHpfN9K6Q9egv7kLS6krZxdOPc9B8asrXq5a4g47vTsBvFs1BleHZg==
X-Received: by 2002:a17:906:7d6:b0:a43:88c0:7729 with SMTP id m22-20020a17090607d600b00a4388c07729mr2308729ejc.56.1709332846376;
        Fri, 01 Mar 2024 14:40:46 -0800 (PST)
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id w26-20020a170906385a00b00a4394f052cesm2102987ejc.150.2024.03.01.14.40.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 14:40:46 -0800 (PST)
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
Subject: [RFC PATCH 3/7] 10-dm-rules: don't restore DM_UDEV_DISABLE_OTHER_RULES_FLAG from db
Date: Fri,  1 Mar 2024 23:40:07 +0100
Message-ID: <20240301224011.11117-4-mwilck@suse.com>
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

We use DM_UDEV_DISABLE_OTHER_RULES_FLAG to tell upper non-DM layers
to keep their hands off the device in question, for any reason.
One possible reason is that the device is supended; another is that
the cookie carries the flag of the same name.

DM_SUSPENDED is not restored from the db, but evaluated anew for every
uevent. Therefore DM_UDEV_DISABLE_OTHER_RULES_FLAG shouldn't be
restored, either. Use a new variable DM_COOKIE_DISABLE_OTHER_RULES_FLAG
to save and restore the original value from the cookie.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 udev/10-dm.rules.in | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/udev/10-dm.rules.in b/udev/10-dm.rules.in
index c08d829..ef36209 100644
--- a/udev/10-dm.rules.in
+++ b/udev/10-dm.rules.in
@@ -48,7 +48,14 @@ ACTION!="add|change", GOTO="dm_end"
 # These flags are encoded in DM_COOKIE variable that was introduced in
 # kernel version 2.6.31. Therefore, we can use this feature with
 # kernels >= 2.6.31 only. Cookie is not decoded for remove event.
-ENV{DM_COOKIE}=="?*", IMPORT{program}="(DM_EXEC)/dmsetup udevflags $env{DM_COOKIE}"
+ENV{DM_COOKIE}!="?*", GOTO="dm_no_cookie"
+IMPORT{program}="(DM_EXEC)/dmsetup udevflags $env{DM_COOKIE}"
+
+# Store the original flag from the cookie as DM_COOKIE_DISABLE_OTHER_RULES_FLAG
+# in the udev db. DM_UDEV_DISABLE_OTHER_RULES_FLAG will be or'd with other
+# conditions for use by upper, non-dm layers.
+ENV{DM_COOKIE_DISABLE_OTHER_RULES_FLAG}="%E{DM_UDEV_DISABLE_OTHER_RULES_FLAG}"
+LABEL="dm_no_cookie"
 
 # There is no cookie set nor any flags encoded in events not originating
 # in libdevmapper so we need to detect this and try to behave correctly.
@@ -58,12 +65,13 @@ ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}=="1", ENV{DM_ACTIVATION}="1", GOTO="dm_flags_do
 IMPORT{db}="DM_UDEV_DISABLE_DM_RULES_FLAG"
 IMPORT{db}="DM_UDEV_DISABLE_SUBSYSTEM_RULES_FLAG"
 IMPORT{db}="DM_UDEV_DISABLE_DISK_RULES_FLAG"
-IMPORT{db}="DM_UDEV_DISABLE_OTHER_RULES_FLAG"
+IMPORT{db}="DM_COOKIE_DISABLE_OTHER_RULES_FLAG"
 IMPORT{db}="DM_UDEV_LOW_PRIORITY_FLAG"
 IMPORT{db}="DM_UDEV_DISABLE_LIBRARY_FALLBACK_FLAG"
 IMPORT{db}="DM_UDEV_PRIMARY_SOURCE_FLAG"
 IMPORT{db}="DM_UDEV_FLAG7"
 IMPORT{db}="DM_UDEV_RULES_VSN"
+ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="%E{DM_COOKIE_DISABLE_OTHER_RULES_FLAG}"
 LABEL="dm_flags_done"
 
 # Normally, we operate on "change" events. But when coldplugging, there's an
-- 
2.43.2


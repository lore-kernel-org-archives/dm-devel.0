Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0A118BC2F
	for <dm-devel@lists.linux.dev>; Sun,  3 Nov 2024 22:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730673848; cv=none; b=Nd34ZjCb7hbwFq527Ql2JmPEhcwcrr75bskCaHX3UtGPSqoo+4Ggm5EnQgHrK5K6BeDtki8Vc2zFj971xEkoJXfk2p5kTGoT75YwROTJqtyXihxEDOsTNeFRKCpBavmcmY1h6EKQGBdS6mnliaUneGaFt44uqylmkCI1jryvIT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730673848; c=relaxed/simple;
	bh=NlxzbDUJ7h4re1FQBK6KOnNcEl2PIZ8Pe8AFnYwfBFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXCcz3w+9GFLkrM0WFCpn+GqaQQWOU/dfBi3q+b1PMjipfj5nDIUDzoUXv+x06U6w9Ac8OiOJ4adujCWZNivdAb99NWo7e96JaP32qzBfL1NhONs3kSgHhza9h9WSPqUddJikAHVfe2lJkD8TZzBZrrwKf1F2WqCRPVHMeWZJls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZDXo0cMY; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZDXo0cMY"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5cec93719ccso1805059a12.2
        for <dm-devel@lists.linux.dev>; Sun, 03 Nov 2024 14:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730673845; x=1731278645; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MFda3Nv7nkjalH7wJLPTGB48A68kdy2UdMn+L3x+ICY=;
        b=ZDXo0cMYYvXgyPFTXFrDJmor0htUCK16stc/1rCmYsJ8P0seQjmep2HewGiPAKHaea
         RLpuoRKGvvCT0Y04Hbw4+MMogZko/UL2IS8k3WGe3c2Yg9HsnBCGPSBtQX3I2wzutzIs
         iH87PXikL+PC2DSL91dkbpc7241xA51fyWqn1jfd7aPxMLZSuqkuZ5HSQk72ENIJXuX4
         MOOZ5UxbuVHyyiGw+8DkRzOtBac8E8BEYC6tU+XA6Qu5cSAa+8xZuB/9i9HOuvtmXqWB
         dCBfOl4r6wGnAOj9fqwNd/zQz6MFPcTvZqDaLKm5nCNsuBv5eG6hD8Ey7f1ZTfxLwvFC
         varQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730673845; x=1731278645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MFda3Nv7nkjalH7wJLPTGB48A68kdy2UdMn+L3x+ICY=;
        b=Qdu8vw8sqQADkXnERGzm/ehx0fYk9VXHItK0Qp9jCBGGlQ4IaZy7DADDNqKbGbzcP5
         V9Pmk3RF+eXVaF2tD2OuLw9QFaWzTX7aXM4tRbv6Lq9Y/YzfoktrkEvVpy1SeCSS0lSv
         y1ou5oM7sdtzQHpa5X1Km6sFPfxs8hxylGVsUoDEH+f+cff7tYb6GL+mNtyzQv9rT+Dy
         S3MWd+2HS6KfHKhJE066cYTk7Qk9Ja7nJoPalDb+UVfAdI/Z/asWdjwBDeOpseRzvSdn
         AeTUYRX9fwWysM3AYY8yp2WrCQjon2YBKiCxHrB5lrFB2Uu+QwBnujr2BZ0H4MNoV7i9
         Peew==
X-Forwarded-Encrypted: i=1; AJvYcCWM7Xfay3PXR2IWFWkbHB4Irhg4Qs0REPUi+AkYny7KShX8VJSfqz7QX7RO38Y82Xan3iTyPxC6Hw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yywi9l+VnabKpKwvaHedtVBeY0sWJFBLnPS9ZDWIKpXNgEBWs+g
	cWLwlXIoKZFVU3Z4XlBBdF9bdwpcueQCqyNuNkbU64svW9UUhh97nrGM7rgPfZE=
X-Google-Smtp-Source: AGHT+IEvjgJWCAr5gcAeG/Zg2fMU+pPOU0acc2PUYvIlPAJs57hdYT8FZAon9mdDMzHXcJQLoO4POA==
X-Received: by 2002:a17:907:31c3:b0:a99:65c6:7f34 with SMTP id a640c23a62f3a-a9e3a57380emr1814102366b.7.1730673844326;
        Sun, 03 Nov 2024 14:44:04 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a9e5668466dsm472392466b.211.2024.11.03.14.44.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 14:44:03 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v2 3/5] 11-dm-mpath.rules.in: clarify DM_ACTIVATION logic
Date: Sun,  3 Nov 2024 23:43:47 +0100
Message-ID: <20241103224349.42582-4-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241103224349.42582-1-mwilck@suse.com>
References: <20241103224349.42582-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Our code is always setting MPATH_UNCHANGED and DM_ACTIVATION in
pairs. While DM_ACTIVATION is a global DM property, MPATH_UNCHANGED
is owned by us. Just set MPATH_UNCHANGED, and adapt DM_ACTIVATION
when necessary just in one place.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index 20f8c6a..a2655cb 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -74,25 +74,25 @@ LABEL="check_mpath_unchanged"
 
 # A previous coldplug event occurred while the device was suspended.
 # Activation might have been partially skipped. Activate the device now,
-# i.e. disable the MPATH_UNCHANGED logic and set DM_ACTIVATION=1.
+# i.e. disable the MPATH_UNCHANGED logic.
 ENV{DM_COLDPLUG_SUSPENDED}=="1", ENV{.DM_SUSPENDED}!="1", \
-	ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0", \
+	ENV{MPATH_UNCHANGED}="0", \
 	PROGRAM="@SYSDIR_BIN@/logger -t 11-dm-mpath.rules -p daemon.notice \"Forcing activation of previously suspended device\"", \
 	GOTO="check_mpath_ready"
 
 # DM_SUBSYSTEM_UDEV_FLAG0 is the "RELOAD" flag for multipath subsystem.
-# Drop the DM_ACTIVATION flag here as mpath reloads tables if any of its
+# Set the MPATH_UNCHANGED flag here as mpath reloads tables if any of its
 # paths are lost/recovered. For any stack above the mpath device, this is not
 # something that should be reacted upon since it would be useless extra work.
 # It's exactly mpath's job to provide *seamless* device access to any of the
 # paths that are available underneath.
 ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", \
-	ENV{DM_ACTIVATION}="0", ENV{MPATH_UNCHANGED}="1"
+	ENV{MPATH_UNCHANGED}="1"
 
-# For path failed or reinstated events, unset DM_ACTIVATION.
+# For path failed or reinstated events, set MPATH_UNCHANGED.
 # This is similar to the DM_SUBSYSTEM_UDEV_FLAG0 case above.
 ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", \
-	ENV{DM_ACTIVATION}="0", ENV{MPATH_UNCHANGED}="1"
+	ENV{MPATH_UNCHANGED}="1"
 
 LABEL="check_mpath_ready"
 
@@ -112,11 +112,10 @@ GOTO="scan_import"
 
 LABEL="mpath_is_ready"
 
-# If the device comes back online, set DM_ACTIVATION so that
+# If the device comes back online, clear MPATH_UNCHANGED so that
 # upper layers will do a rescan. Don't do this if .MPATH_DEVICE_READY_OLD
 # is just empty (see comment above the DM_COOKIE test above).
-ENV{.MPATH_DEVICE_READY_OLD}=="0", \
-	ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0"
+ENV{.MPATH_DEVICE_READY_OLD}=="0", ENV{MPATH_UNCHANGED}="0"
 
 # The code to check multipath state ends here. We need to set
 # properties and symlinks regardless whether the map is usable or
@@ -146,6 +145,10 @@ IMPORT{db}="ID_PART_GPT_AUTO_ROOT"
 
 LABEL="import_end"
 
+# If MPATH_UNCHANGED is set, adapt DM_ACTIVATION.
+ENV{MPATH_UNCHANGED}=="0", ENV{DM_ACTIVATION}="1"
+ENV{MPATH_UNCHANGED}=="1", ENV{DM_ACTIVATION}="0"
+
 # Reset previous DM_COLDPLUG_SUSPENDED if activation happens now
 ENV{.DM_SUSPENDED}!="1", ENV{DM_ACTIVATION}=="1", ENV{DM_COLDPLUG_SUSPENDED}=""
 
-- 
2.47.0


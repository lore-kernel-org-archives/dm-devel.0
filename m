Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518771E2829
	for <dm-devel@lists.linux.dev>; Fri,  1 Nov 2024 21:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730498337; cv=none; b=eq5MITGRPSRvLk8GJXG93pcKJ0CwH7ZC5JsxR5gsRJF8uIwpo+BKJq36QMes7BFGG3BTvfvw2k7sRn6iF+9W4O0H7Yv3zkL3fgVU5QtX15jmQR0mCSn0ifKg8jKQ6A01rtxTsjsPY4lZ+6tXbKapqc9XetDqZzET1ilgAGIKOl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730498337; c=relaxed/simple;
	bh=CZAssxSjpM2GC0gMgeX98EciswnZgtt3y1xEBcaEJxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbPXSyoKmdvQGq2uSKdBKCzj7EkKME+Cf0O9LxHRFoZ3kjvG8EjsQ6zaoAun3wVZ2ghElGnoIhap7jBvOEI77t8gEotmCCqPER+BNW0falY0RLBKCqDE/Hkmm3k9+EhoYP/tEexAo8iKhiyfelFZou5bhsNvbx8FbpUC4Cd2yuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XMA6pg8Y; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XMA6pg8Y"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5c903f5bd0eso4024735a12.3
        for <dm-devel@lists.linux.dev>; Fri, 01 Nov 2024 14:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730498334; x=1731103134; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2DacYKzLolIBI+9tOo5qeyNYiB38EUO8vuHt/ehdxbA=;
        b=XMA6pg8Yy9E8S52Q383qj7GwikRAINreS/JGriryYQYUU2y71jVRt2mpEFEHmXNa0b
         Qu0wcSZPjcGsUSlqbijJGmzmuCU807dWXYjUROyfe9YaqaBxdG0MBtJKRCT0zCpnlmw/
         bLmNGLUTYmj4+GE8rjpvOyX+aATJsR9T6Dm7DGVhisP5kfZIG7VLcl0A0uuHenmyIy1P
         Vq6wDFQM36aUcKycUALNZjZ8Ie+cREnnWPZuamjHqL7GSCQk+IcmAPdkrPQGGjL7log6
         u9vI+zKmpzKAOQURGrMBC/Uyn9bzUY0vqxXenyXuLoYbOaYjz0xZJP2GjZs5cr9papuz
         Q4bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730498334; x=1731103134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2DacYKzLolIBI+9tOo5qeyNYiB38EUO8vuHt/ehdxbA=;
        b=VwjwGyXx8xxblMTBGAUuLDBz0Dw/CvhaD6dJzJwqIgr2kduORwl/o38xglBrMw7Fi8
         Ls+aNsIbkI0iYXqdcuwFW2yfjIBGcHkTWtKiJ8WJozOr/tv8Y1+I0GvNikXyqoMkSPAm
         tDAS7imHKK/q+s+5MHpaVm+xlvXxRBb6qgBIoQ83BTcG6HQu6OT6hVjjFYRxqWzzbJZm
         Wti+cKAPwHVmNYLloKif0rfyLWhMj8wF27PIS+F0UVsCU7A2JSRJxH2MvlPoqaygSxqU
         opAidgQ/1gV+U0LpnEabD5beIxxRaAJilUkMZKvbno2ymUPIidUv4fTEi9edk/ud/+OT
         KsPw==
X-Forwarded-Encrypted: i=1; AJvYcCXfIyPCJQ5SitIcFsJFL7mIQFVWIU87Zjt+cl5CN5SPukJkBWZeqx9O73BpKRvJRrzkDc5CkCXBJQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6xYgsOmd5wpXNVtDKNS7oIDqCrF9wYmG/7Ij/4pKBA3nw6jmv
	nk0ysCx/LHz9JNfAUyzxUqiWy8xbOqUYIpTO5kZfX+ShhmDpATVrIcvtMtemr1A=
X-Google-Smtp-Source: AGHT+IGgtQOM59v1V5abYfy9pWBT6wPuETdnCk6MAMxbvc9nywb8PX7GDhNAxfQuJMpTgSVMpakFbQ==
X-Received: by 2002:a17:907:7e84:b0:a9a:123d:3f1a with SMTP id a640c23a62f3a-a9e508d4af3mr725973166b.17.1730498333432;
        Fri, 01 Nov 2024 14:58:53 -0700 (PDT)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a9e56494295sm236538566b.14.2024.11.01.14.58.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 14:58:52 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH 2/3] 11-dm-mpath.rules.in: handle inactive suspended devices correctly
Date: Fri,  1 Nov 2024 22:58:39 +0100
Message-ID: <20241101215840.1077082-3-mwilck@suse.com>
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

Since b22c273 ("11-dm-mpath.rules: Don't force activation while device is
suspended"), we've handled the case where a device is suspended while
an uevent is processed (e.g. because multipathd is reloading the
map again at the same time). But we were missing the case where
The device had never been initialized before. If .MPATH_DEVICE_READY_OLD
was empty, we'd jump to scan_import without setting MPATH_DEVICE_READY
to 0. This can cause a device not to be fully activated at boot time,
because in follow-up uevents we'd assume that the device had already
been set up.

Treat the case in which an uevent is processed for a previously not
fully set-up, suspended device like other situations where we set
MPATH_DEVICE_READY to 0.

Fixes: b22c273 ("11-dm-mpath.rules: Don't force activation while device is
suspended")
---
 multipath/11-dm-mpath.rules.in | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index 6783826..20f8c6a 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -35,6 +35,13 @@ ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", \
 
 ENV{.MPATH_DEVICE_READY_OLD}="$env{MPATH_DEVICE_READY}"
 
+# If the device wasn't ready previously and is currently suspended,
+# we have to postpone the activation until the next event.
+# In this case, we have to set MPATH_DEVICE_READY=0; otherwise, the
+# MPATH_UNCHANGED logic will cause later rules to skipped in the next event.
+ENV{.MPATH_DEVICE_READY_OLD}!="1", ENV{.DM_SUSPENDED}=="1", \
+	ENV{MPATH_DEVICE_READY}="0", GOTO="check_mpath_unchanged"
+
 # multipath sets DM_SUBSYSTEM_UDEV_FLAG2 when it reloads a
 # table with no active devices. If this happens, mark the
 # device not ready
@@ -106,14 +113,10 @@ GOTO="scan_import"
 LABEL="mpath_is_ready"
 
 # If the device comes back online, set DM_ACTIVATION so that
-# upper layers do a rescan. If the device is currently suspended,
-# we have to postpone the activation until the next event.
-# In this case, we have to set MPATH_DEVICE_READY=0; otherwise, the
-# MPATH_UNCHANGED logic will cause later rules to skipped in the next event.
-ENV{.MPATH_DEVICE_READY_OLD}!="0", GOTO="scan_import"
-ENV{.DM_SUSPENDED}=="1", ENV{MPATH_DEVICE_READY}="0", GOTO="scan_import"
-
-ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0"
+# upper layers will do a rescan. Don't do this if .MPATH_DEVICE_READY_OLD
+# is just empty (see comment above the DM_COOKIE test above).
+ENV{.MPATH_DEVICE_READY_OLD}=="0", \
+	ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0"
 
 # The code to check multipath state ends here. We need to set
 # properties and symlinks regardless whether the map is usable or
-- 
2.47.0


Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EE6C2FB
	for <dm-devel@lists.linux.dev>; Sun,  3 Nov 2024 22:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730673848; cv=none; b=sv1eeXZMZqC48vUkIYYCjIYVkh4WSGj0SeX8FS++LFDgbVDLU4qiGwjA05x1BOiyqwtwDZFuFm1T7cLxDI1b/TC23b5eDL67hxtqN3ZLu/XvymR5cYlcux2uq0mKZkazzcGQQoo60jZk31vKwNCeL78ptKa37fEwe6fX8jW8l5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730673848; c=relaxed/simple;
	bh=CZAssxSjpM2GC0gMgeX98EciswnZgtt3y1xEBcaEJxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFQwQLHjyrJjwp/gg9wWxosMz696Vu3yI7Hfb+GbUGWG9vC7yw57ZaeaGaB4Cw/Uyx+pWZ6tXks7UNL9ldmqHausZ9yI3Nl1JvsT6SLeEh3EF3yYKjKaji+dSnIkI68vmLPReStZRRHve+6nFfOlW7VFZW93IuzkVZWbGjpFIW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fae0n+KU; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fae0n+KU"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a9a156513a1so632052066b.0
        for <dm-devel@lists.linux.dev>; Sun, 03 Nov 2024 14:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730673843; x=1731278643; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2DacYKzLolIBI+9tOo5qeyNYiB38EUO8vuHt/ehdxbA=;
        b=fae0n+KUqjzRTqIZafT1YuBNA/gsGRwSBsFJdNshrZqr+/4TuhdJaQ7NZAjPThgXJq
         Yoy5Xmo7OAhlNEuSjHBxM6SVgCr7Ph2BxDKsQkIPaDiPmkLDpCnaQUrliRnn74HXvZhD
         XSR/W4HB35GjMNP7sJnHPmTcjs/FIBpQbDYbN2qAQ3K2kbf1XbIYUV+/AfEKgm8LvpYM
         WQyqLFi4PIyijFmjdeAN72VMDlXvHIhcdUvQJIl0xBfJsNNP37yNz/p2Ih/wfVz6odFT
         /57nYSwOoXmHTUpKj0kfV+coHI/Em362DVrW/dqtSa9Xiht79sBhGnoGeUtkRUEeMfjf
         7mLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730673843; x=1731278643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2DacYKzLolIBI+9tOo5qeyNYiB38EUO8vuHt/ehdxbA=;
        b=LtsQkN9jRxRG/aVEvcKzJCjXYJGPzpr5JgwCQs+PoY00KRma8L8JDz6paa01qSEHHr
         CRQpeU2ecCrqFntgzfyCli3ncrVfrr400wJowdb0pbAgM0NQ7CVfAYE6nT3KGH/29Zeb
         3EFTO780wa5QEX1z5J1zCWb82yzEVrZkFxlBfif8fw2SJlvbdPM1k2TsBi4yjRB2r1Nj
         w++1Y/nd1hduVhzUTPG3RNU9++9EMtsJnb4ZIyCLZDMbv38ypF9h6L0SzNeovp5VjlHS
         WC9GATqc7LWvgmlhE7Ub2Ot83VZUq4A6MaAP3arrr06iaGHSkpXNU31cWeeD/IOltNPe
         Uq+g==
X-Forwarded-Encrypted: i=1; AJvYcCVeQoTJo393yW2NdzFALvuC83wfiMrrA63is2pce2VtwZKDLTOP4dB2Ro43ZT4Z/l4K7vCJbhzItg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzP9JjmaQotdhEBA4AqkzTasK1SsPAdC1D0uL1BdUgaMEq9zjli
	FTAl712SlVSPkc+FOZy7QGpxRPWah4g5Z5vZqdCUPcAOPbIKUv5IjJ6FnY/0Abs=
X-Google-Smtp-Source: AGHT+IHn1G/yfQ5DqSE5JZe7rd4vFrGs3dk+WsRkP04mgyipGC6jKbJ10LpyUBDV72gYrh4CswT0lQ==
X-Received: by 2002:a17:906:6a19:b0:a99:eb94:3e37 with SMTP id a640c23a62f3a-a9de632ffbamr2632563466b.58.1730673843086;
        Sun, 03 Nov 2024 14:44:03 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a9e564c4f73sm473440366b.62.2024.11.03.14.44.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 14:44:02 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v2 2/5] 11-dm-mpath.rules.in: handle inactive suspended devices correctly
Date: Sun,  3 Nov 2024 23:43:46 +0100
Message-ID: <20241103224349.42582-3-mwilck@suse.com>
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


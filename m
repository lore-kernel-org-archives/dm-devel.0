Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194D35A11B
	for <dm-devel@lists.linux.dev>; Tue,  5 Mar 2024 12:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709640372; cv=none; b=KzXLhhtbBQb0CUFC3Lz6vUqghl4qtvMZ7uGjYW+Rz0iF47dwTXt04sVlhgFNzZ+4IVSxdU4pKOA4eUrXvdrtHWYt31zVVWjuZV6S9Xz2XE2+4Bu60TT6aWpHGdn/vXC3J9leFn2nd05HA1MBV251g0ID5uM39Pzx3OxfnPIgztw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709640372; c=relaxed/simple;
	bh=lfPPztJSU8i6PsrnDFEgaFR33/L2AhHRnuO2C8qKK44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5cPEvU13sn+TUG3up1HWECcm9bbL+zKpHsCPjP9wXMeeosSjITUO09qfDqU9W2TwO7GI1NZgt8Zxx7/kiLkPNGwBOXnnxtdd952pxdZguwEuAhuPflfStWe8IBSE5HMpA2PWkktNhM3OIWZzuqsDTf8iEm+mtpopGBfZ9mPucg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=az/SN6MU; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="az/SN6MU"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-412eddd165eso2873005e9.1
        for <dm-devel@lists.linux.dev>; Tue, 05 Mar 2024 04:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1709640368; x=1710245168; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mLLG4u3ZUc3JsevxgnlE3EEFCImXDxYAkZZZX7kFVkg=;
        b=az/SN6MUIS0SJbIlOHQrrAlOYrn0QNc4IDq59NEJF2Rw7AIlhKvpbF5X9OOx9Lgn9O
         /+qtw7AVt/S+KMc2d7o8qu307sFKYNPOZz9kWASct0ZX7PvVQ1dwqWVmfyguxwRK9B1S
         oKdrixFyodLLMNMhdPtnagBM682zUYsz6yV5PiTe9FiOb0AydKF3Tgc8GnbbX6/y13kR
         pU7bgwKwryPqV1Zy9lBbmWTA9kUG5aENV1jlSLW/M+sJbmxUvxzK+hs7bAajI/b+q+A7
         BehuYkIYKsH4FCYMQJKOk3El7Zhc1cBc4v5mrsOPzv66VKDVcM70s3npKJQz2NPWzVo5
         bbOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709640368; x=1710245168;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mLLG4u3ZUc3JsevxgnlE3EEFCImXDxYAkZZZX7kFVkg=;
        b=io6Sv3OV5uPGiX4/ARUi2yxRmt2QN0TspiyjX6qxldYmKAYmQnO1U7r5HtsgHOMVsb
         expU7rYUjGtT+YFdRVA13VVuOAsT/Zsn4VT7obYtf518SAX7q3PAhvhKqLb41+pYHZ0B
         l3RTHCQ5Nif2goQ1JIjIhcJHLG8M8WNheXNaFeRvDTvyzeXOzdY8sA0rADZLVMX/wQoy
         osy5P2hzP9rsrH4arebO20OYHIsFXxwakfn+y/M+5BmSuH7iiKdbwiBb/szWNlL3ptfy
         UGTz3/ca7dckLi5QxE4+eOjx/zU3zKBdg3/qmhqNE6ckm8Pv9Tr2zdKHG8aMdKz9zHtn
         h+ew==
X-Forwarded-Encrypted: i=1; AJvYcCXGRF5uzIA2tDPLLwFZtI72b2Wg2H+SgCWLM4exTA8Y6B7p1LhlsFmZ2bsC/2L/vtFmVJ/PoizTYXWNBZB0zeFP1AGRqzsGPTI=
X-Gm-Message-State: AOJu0YzWFd02IW1iF4wKQz8f3lbMmqOzEP5+kN71iRfU27COWajaCnj7
	oduB4ODtcSmTiL7DyDgNJQTSzXEmE8WNKx/Aq6XrdYtGPjDS4Q+ZPBCboRxA0cM=
X-Google-Smtp-Source: AGHT+IH3R2HyyNiBsP+BSGsIiTmJU9kd4BGJlOdJ2dhAWJAZBfptzgA08b36FN7bTpAhGaCPMO6wGg==
X-Received: by 2002:adf:cc03:0:b0:33e:dd4:ca44 with SMTP id x3-20020adfcc03000000b0033e0dd4ca44mr5586991wrh.2.1709640368544;
        Tue, 05 Mar 2024 04:06:08 -0800 (PST)
Received: from localhost ([2001:470:6d:10f7:9114:d168:fb53:9a37])
        by smtp.gmail.com with UTF8SMTPSA id co17-20020a0560000a1100b0033e3ca55a4esm5800201wrb.21.2024.03.05.04.06.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 04:06:08 -0800 (PST)
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
Subject: [PATCH v2 2/7] 10-dm.rules: test DISK_RO after importing properties
Date: Tue,  5 Mar 2024 13:05:45 +0100
Message-ID: <20240305120550.11617-3-mwilck@suse.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240305120550.11617-1-mwilck@suse.com>
References: <20240305120550.11617-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

DISK_RO is set in the environment of a block-device uevent if and only if
the read-only (ro) attribute of the device just changed (the kernel
function set_disk_ro() was called). It is not synoymous with the "ro" sysfs
attribute; the device could very well be write-protected if DISK_RO is not
set. Device mapper-level probing is possible for DISK_RO events, but it makes
little sense, because the device propreties haven't changed as far as dm is
concerned. But we should import possible previously set device properties
to avoid confusing follow-up rules. We should do this for both DISK_RO=1
and DISK_RO=0 events.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 udev/10-dm.rules.in | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/udev/10-dm.rules.in b/udev/10-dm.rules.in
index 4ffd3e2..f83fbec 100644
--- a/udev/10-dm.rules.in
+++ b/udev/10-dm.rules.in
@@ -50,9 +50,6 @@ ACTION!="add|change", GOTO="dm_end"
 # kernels >= 2.6.31 only. Cookie is not decoded for remove event.
 ENV{DM_COOKIE}=="?*", IMPORT{program}="(DM_EXEC)/dmsetup udevflags $env{DM_COOKIE}"
 
-# Rule out easy-to-detect inappropriate events first.
-ENV{DISK_RO}=="1", GOTO="dm_disable"
-
 # There is no cookie set nor any flags encoded in events not originating
 # in libdevmapper so we need to detect this and try to behave correctly.
 # For such spurious events, regenerate all flags from current udev database content
@@ -69,6 +66,10 @@ IMPORT{db}="DM_UDEV_FLAG7"
 IMPORT{db}="DM_UDEV_RULES_VSN"
 LABEL="dm_flags_done"
 
+# If DISK_RO is set, it's an uevent that changes the ro attribute of the device.
+# The event should be ignored as far as dm is concerned.
+ENV{DISK_RO}=="0|1", GOTO="dm_disable"
+
 # Normally, we operate on "change" events. But when coldplugging, there's an
 # "add" event present. We have to recognize this and do our actions in this
 # particular situation, too. Also, we don't want the nodes to be created
-- 
2.43.2


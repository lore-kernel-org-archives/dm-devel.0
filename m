Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98CD1C68C
	for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 21:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711314802; cv=none; b=NeygExw2jw9Os+3Zbc4il2MdgJehm2kjvmchNOH5/cCXHkLSGyEHmV/erv0phsKLQxJDNIxjU4BwbFN9Vwvo6rh8OzS+s6oqgjTwGvcAJKzO1oTJOKjZnxJ2FvFZECvuW1JU3ICKSiyjQmz33c5Yh1D1BSwAAChpZluJ/1ubaRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711314802; c=relaxed/simple;
	bh=aQDtUsqSZDks++4+4aVm/1r5e9E2S1/AkkV1vciiQ9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbhH7dp02ezl7oGVpf6BaTGNaEiO+m+HmSCJJFltZNlQKNNpiZrkicloZTp4fmjT62ov4N8u9rLY3SzPH2Fsukwd1MLvx+XNsFjEcGw9w/yZcQ4jULDVfekbrylX7DTP6rIpIx5trx+jI08QYmt2MH+0dzS0oF8scvr+In8yEdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=c2w3R+Wg; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="c2w3R+Wg"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-513cf9bacf1so5099046e87.0
        for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 14:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711314798; x=1711919598; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GnLimJrGXje3zkfwDU/rSbqICbGjFslBIN92J2rU9dY=;
        b=c2w3R+WgPSJdCkATfGE4Pk75KjHlLZHzMgP0PhdXepQzfwcay/XpDo/eXwhN4GI68y
         nIiCUfawmPPMavgBszuotowchBQ3h3bRdsFhY0hNDKBrbkN/uDspg4CGENKlKlH9WAUb
         PSBb0xyZlizEUDnmvhuK1Es14UbVh0vjSDE8h+gO6UyHBYM1ZsFCSlIFImB+1eqmS4Iu
         eVQCv3fjOBforP/dVCph6KFO8ObanAZT6vqI70H3FbYbUNLWKzO5tWPtZgD+70LOaiaf
         3T7HWaIjf8ye4jAO38EvoebO5Qt/3mSTaRfK8TEriWc/ugePjrHr7xExwQqsxoqnyht/
         OwkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711314798; x=1711919598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GnLimJrGXje3zkfwDU/rSbqICbGjFslBIN92J2rU9dY=;
        b=ofhRNweEY91I/t/BQPsB1ZcljBwjzTBkyI84++UTP7W35yA0NyfBAx100G1PqeopKA
         qFh6Zh+M+0XpZiYQBY2PDT6hLys+XPaLSGq5pv7fV3qk9MiPk1hMpGyuSUMYuOYhpLLp
         j6Oto4igvZuoL/fi1ASmgSP7SDDjpfSwRiaCcgxh77SqAHq7jhpuRx1svAEcw6XntncP
         MVKDFG7Iunb9ARE16OnosYgWqgFZ1dzPgAGjm49rHKlDt95RUGwi7i4eAVLhjet2m3vD
         xL8ia9hMvz5dlYgYPOew/5YPsOFYeCQjEETPZyG1m0IIBcWm2WNablEOIGd1sZcRrt2h
         YvWQ==
X-Gm-Message-State: AOJu0YyOt/aI13HzzKcBUsiA76rUS+UnNMMg7QENw1ti0DETH7x8xygc
	xz7V8HBVqlS8yNEupN7bBsxZSMyRp7su/F9TQ7x2PmJP7Jr+OmS0U+hK3Wfgf5E=
X-Google-Smtp-Source: AGHT+IFoGSVASpmtB7DbT1HPO165KnGiWlRkfgW6/4pq0KGwRgNJY2oSY/cSkohgTPOtHSoM1XrVTg==
X-Received: by 2002:a19:5f5a:0:b0:513:af26:8cd0 with SMTP id a26-20020a195f5a000000b00513af268cd0mr3152972lfj.68.1711314798129;
        Sun, 24 Mar 2024 14:13:18 -0700 (PDT)
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id pv18-20020a170907209200b00a46cf83216csm2309925ejb.120.2024.03.24.14.13.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Mar 2024 14:13:17 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 04/11] 11-dm-mpath.rules: adapt MPATH_DEVICE_READY=0 logic to 10-dm.rules update
Date: Sun, 24 Mar 2024 22:12:54 +0100
Message-ID: <20240324211301.7200-5-mwilck@suse.com>
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

With the late patches for 10-dm.rules, DM_UDEV_DISABLE_OTHER_RULES_FLAG isn't
restored from the udev database any more, so we don't need to restore
the flag to its original state before it is saved to the db.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index 5259b86..997e3e7 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -84,23 +84,25 @@ ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", \
 
 LABEL="force_activation"
 
+ENV{MPATH_DEVICE_READY}!="0", GOTO="mpath_is_ready"
 # Do not initiate scanning if no path is available,
 # otherwise there would be a hang or IO error on access.
 # We'd like to avoid this, especially within udev processing.
-ENV{MPATH_DEVICE_READY}=="0", ENV{DM_NOSCAN}="1"
-
-# Skip all foreign rules if no path is available.
+# This is communicated to later rules in DM_NOSCAN.
+# Likewise, skip all foreign rules if no path is available.
 # Use DM_UDEV_DISABLE_OTHER_RULES_FLAG to communicate this
-# to upper layers. The original value will be restored in a late
-# udev rule.
-ENV{MPATH_DEVICE_READY}=="0", \
-	ENV{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}", \
-	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
+# to upper layers. With dm rules < v3, save the original value here;
+# it will be restored in a late udev rule.
+ENV{DM_UDEV_RULES_VSN}!="3",
+	ENV{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}"
+ENV{DM_NOSCAN}="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
+GOTO="dont_activate"
+
+LABEL="mpath_is_ready"
 
 # If the device comes back online, set DM_ACTIVATION so that
 # upper layers do a rescan. If the device is currently suspended,
 # we have to postpone the activation until the next event.
-ENV{MPATH_DEVICE_READY}=="0", GOTO="dont_activate"
 ENV{.MPATH_DEVICE_READY_OLD}!="0", GOTO="dont_activate"
 ENV{DM_SUSPENDED}=="1", GOTO="dont_activate"
 
-- 
2.43.2


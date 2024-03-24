Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C711F619
	for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 21:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711314805; cv=none; b=MRkdWKIX9Ygky799ga47J+bpNEnbezeerdxp9/K4y7vQPJkKuv42KUFn4nAH8rwAeOLUZrd6Y9pEMhi+jJUwBIMQzpk1atT6ywlGXEQVMhOn1Qp8LSHbMbZ3O9l36bY4mLMtS5Hh9NTWgjxjRVGrF3dW2SLosN1d7LdD9SVm0wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711314805; c=relaxed/simple;
	bh=QHlQKNlaCbniaOHXQYFkyfq0HyEiEdfuI3G/R5QTtCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0UrINhXhh4in6IY0KkGzler7qh16vkBG0EOoMOdKzvfeYcukQTXTELg9MDxfdkOtRXUTCwaqsIxbYFYdqG2SPu8bZUX+UnGIXl2J2ooEw/Z0TQ4x5vK/QRPpBKCYTtQd812csb4ZDEWqgE8wYxA89lthTmyeuEZs1vRxZZMoCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Z2NW8ekn; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Z2NW8ekn"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2d46c44dcc0so44819341fa.2
        for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 14:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711314802; x=1711919602; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V5mbFHNHU8ho/itASuaXZX7BGRpxUygxaaMW4L275Gg=;
        b=Z2NW8ekn6277Ov3XLJaPe20hFvPyBEf1BgldnVG6w6G5vFg6JeMjlhtxJO8qxIJROr
         hv6f6BB5uLdKtlVk4fsNC3uvBp8+e9kGNbfoOiWIPoTpCI742L4Ija2Roymq4eQOpOOW
         BCYzGsSfVzeI89ePju3XRGwx8jsGnK0yUVzG+EfV05RqSsJYDOYPFbYhJ5Traawkahp0
         nbC29sFEYA265xUb0jK+Qlb2TPjYZu2P4gUFqBHVciTlCHiQLTLdQPnCJDhnZPqIRj+h
         X+pBlo2pqYvbBF75wlOs97x+lNpXdlcMYTJ0JLRMXKQvK1Sf81retuSiK1dNdG3jvw5g
         7xpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711314802; x=1711919602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V5mbFHNHU8ho/itASuaXZX7BGRpxUygxaaMW4L275Gg=;
        b=oQZYDbfZnmluvJ5/XnxC0XaVPQzlaQe4vJ6NdDxbhHXqac0y56sGlNMT53MEnteJG6
         JfAzsFyUfbWTrMpIs2NDNyDaHL/0hsOSaxmujxQUolDK9wDubW1rz06rsWPauaqKhJi5
         KHYNmdGmAqOmaU7zg0ZYS+higNdKtT5t3CbyEqFg3BPA+Dm6U6O2dmi8Hx/MmdhrtyW0
         theKad8EFaj4Hn9oymsDIom2jAt/rBbc6w3Ujt90F/J0S5CtfoLfrecbwbStJ6DktpWn
         iYoa+lJ5ahTwrnvDPJ+qkKAuBvNgQkDxC6Tgat1p1p7sSkgeuwgSPcviRdSnXXpIitRy
         Ql3g==
X-Gm-Message-State: AOJu0Yz4OAr5XUXh9qavz858Ii5UFJbmKAwv6lnHokJihl2GpT2B78H5
	pTX5Y1b+M90w2Gk0Ubu76KOX+Uw6tjBreYmepZFT6v+VicVhBu8RyFOxp4uhvas=
X-Google-Smtp-Source: AGHT+IEO2FdR76CaO/b93ejgWaq3o27j59eTDVZYG5IbqJaOLOGu7yuXtu4TDKoVcD2NoXTxKaPZJg==
X-Received: by 2002:a19:6917:0:b0:513:5dc3:9ebb with SMTP id e23-20020a196917000000b005135dc39ebbmr3214889lfc.4.1711314801898;
        Sun, 24 Mar 2024 14:13:21 -0700 (PDT)
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id bs11-20020a170906d1cb00b00a47423b4c33sm2159123ejb.128.2024.03.24.14.13.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Mar 2024 14:13:21 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 08/11] 11-dm-mpath.rules: replace DM_NOSCAN by .DM_NOSCAN
Date: Sun, 24 Mar 2024 22:12:58 +0100
Message-ID: <20240324211301.7200-9-mwilck@suse.com>
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

We don't need to restore DM_NOSCAN from the db anymore, so we can rename
it to .DM_NOSCAN, making it a temporary property.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index c4b5685..8833e08 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -96,14 +96,14 @@ ENV{MPATH_DEVICE_READY}!="0", GOTO="mpath_is_ready"
 # Do not initiate scanning if no path is available,
 # otherwise there would be a hang or IO error on access.
 # We'd like to avoid this, especially within udev processing.
-# This is communicated to later rules in DM_NOSCAN.
+# This is communicated to later rules in .DM_NOSCAN.
 # Likewise, skip all foreign rules if no path is available.
 # Use DM_UDEV_DISABLE_OTHER_RULES_FLAG to communicate this
 # to upper layers. With dm rules < v3, save the original value here;
 # it will be restored in a late udev rule.
 ENV{DM_UDEV_RULES_VSN}!="3",
 	ENV{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}"
-ENV{DM_NOSCAN}="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
+ENV{.DM_NOSCAN}="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
 GOTO="dont_activate"
 
 LABEL="mpath_is_ready"
@@ -132,7 +132,7 @@ ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!="1", GOTO="import_end"
 ENV{DM_UDEV_RULES_VSN}=="3", GOTO="import_end"
 
 # Don't import the properties from db if we will run blkid later.
-ENV{DM_NOSCAN}!="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}!="1", GOTO="import_end"
+ENV{.DM_NOSCAN}!="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}!="1", GOTO="import_end"
 
 IMPORT{db}="ID_FS_TYPE"
 IMPORT{db}="ID_FS_USAGE"
@@ -148,6 +148,9 @@ LABEL="import_end"
 # Reset previous DM_COLDPLUG_SUSPENDED if activation happens now
 ENV{.DM_SUSPENDED}!="1", ENV{DM_ACTIVATION}=="1", ENV{DM_COLDPLUG_SUSPENDED}=""
 
+# device-mapper rules v2 compatibility for 13-dm-disk.rules
+ENV{DM_UDEV_RULES_VSN}!="3", ENV{DM_NOSCAN}="$env{.DM_NOSCAN}"
+
 # Multipath maps should take precedence over their members.
 ENV{DM_UDEV_LOW_PRIORITY_FLAG}!="1", OPTIONS+="link_priority=50"
 
-- 
2.43.2


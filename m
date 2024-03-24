Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8374C1F95E
	for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 21:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711314806; cv=none; b=S6Gf3wVjtcTrWbWUIxMyoxwEImUASlY9zM3A01L4NOR6BeKp43BUIN1HSNLmc/Awkz4hG+smkQOygPKl9gzvIFGBh4HW4cxE5vwnXR9mcOh55x+unEe/eYO4PXujMSY008Mj5uf3Fg3+/+vUBkfDiJ5OPliocBJkc9eCjMxub58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711314806; c=relaxed/simple;
	bh=NBwZAaUkhR66x83MudYjghL+OcLHlf0dUcqALAgFv0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmPhpfpbtlrUV7xHhw0VY01J3/GQX+0BlK8ei9WCFWj9ZMb5YOWxKvGK4/GRUlLuCclJdL/myifvl8velfmNeobviulRWdb+jU7tb/Hx3bH0ZI3mOE8mwxFLut0PAkzhFWWz0SNC938UFzGvLgqG6DS7mSi/xpKhQcpeY5ar8O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HsXzalYi; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HsXzalYi"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-56bf6591865so1966284a12.0
        for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 14:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711314803; x=1711919603; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rr8NAOBJOu3ePPxpGom9eE/3yiHxaVL7u1BEvZHMkr0=;
        b=HsXzalYiYZ7YEGoO42qGsdVbkK5XDDcsvD/tD2zUPYTIbItcSFVQNaCPGpjUiewmW4
         RkA+vwrq1tXyJNfoa8XAO0RN2E/3c0CqqjrYETz/jVBhL9YKOHonx3cJhUYjkxUItM2P
         RyJABGoBMXIYMJ5MZc3ed9phEQtJvQyTyBZWhLG+2zi1T2DmpeGHO88CQnFBz4hFzIpa
         EdGqj5capzkJ6FcdMPCBJVulLEsoGkJeitgAulINUFPl3KgmYLppJ514bGfzIFcq+Uw4
         mK1WNJvfg/imoHUlIJq1Yd89gGrdpsYRHqe7DerZA1FJLO8D2/pIZv8p1GdywZ1l/5Yz
         3Qcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711314803; x=1711919603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rr8NAOBJOu3ePPxpGom9eE/3yiHxaVL7u1BEvZHMkr0=;
        b=eTFiYm/wTPXFxoyJBAXcjZKAPB3Di9gYcww0I2dzXfEJpnx7OCrYRrSzJZo4lg6+Yj
         PtP15xV/PpmkWIn15BbGPerkw05A//YBHJJHNs9eP8dTa8pkeZWnP2+8xDY9STCO0qAI
         siXtPP5wm9swM5ZF05x2C+tNIl/TL9X+IW1juPzBxfX376Ogxe9r3WuB5+0JX+efKVHi
         uDpYtyTY05pRXxqd3FVDMhXkw1MFvEAw7WUG6I+Z6F2FxJvEJ5L6lDfT0UnLRBux7DtR
         DY8PJxTM6axcCPmqXsAVzXw2D34Mdc/VZaTo4on+OODxOvYO/l8UqeI8Y+zWtMvKQOri
         /12A==
X-Gm-Message-State: AOJu0YxHcPuFu7rWyfMK30G/ZRd840yx8oO74M/NzWo2jymbfdZIYKOI
	7yrdtJDNd+fzPmgl3FYXmPZJtI4ratR8hZllVllkP5B3v4t/i33paG/sVpCtaDI=
X-Google-Smtp-Source: AGHT+IFqWR9aboq07w5jfOENxKQ6HQzHGxjLnzSvnSxhGq9kwItyLM3LRTVHiWOhdD7SV3Tob/HipA==
X-Received: by 2002:a50:d49a:0:b0:56b:7e43:a3f6 with SMTP id s26-20020a50d49a000000b0056b7e43a3f6mr3054732edi.40.1711314802942;
        Sun, 24 Mar 2024 14:13:22 -0700 (PDT)
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id o26-20020aa7c7da000000b0056bf34d656dsm2251377eds.29.2024.03.24.14.13.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Mar 2024 14:13:22 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 09/11] 11-dm-mpath.rules: simplify PATH_FAILED case
Date: Sun, 24 Mar 2024 22:12:59 +0100
Message-ID: <20240324211301.7200-10-mwilck@suse.com>
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

This combination of a GOTO and a simple rule can be combined
into a single rule.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index 8833e08..2285853 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -56,14 +56,10 @@ PROGRAM=="@BINDIR@/multipath -U -v1 %k", GOTO="paths_ok"
 ENV{MPATH_DEVICE_READY}="0", GOTO="mpath_action"
 LABEL="paths_ok"
 
-# Don't mark a device ready on a PATH_FAILED event. even if
-# DM_NR_VALID_PATHS is greater than 0. Just keep the existing
-# value
-ENV{DM_ACTION}=="PATH_FAILED", GOTO="mpath_action"
-
-# This event is either a PATH_REINSTATED or a table reload where
-# there are active paths. Mark the device ready
-ENV{MPATH_DEVICE_READY}="1"
+# For PATH_FAILED events, keep the existing value of MPATH_DEVICE_READY.
+# If it's not PATH_FAILED, this event is either a PATH_REINSTATED or a
+# table reload where there are active paths. Mark the device ready.
+ENV{DM_ACTION}!="PATH_FAILED", ENV{MPATH_DEVICE_READY}="1"
 
 LABEL="mpath_action"
 
-- 
2.43.2


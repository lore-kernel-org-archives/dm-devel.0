Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF9F12F5BC
	for <dm-devel@lists.linux.dev>; Thu,  4 Apr 2024 17:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712252325; cv=none; b=lc4SQeHyJtFiK0/BEtpreOuJkd5HJSN71s0ZmbO7Ss+Qo8cz6WDnfPZ3AYK3KNhg3y6nl0b9PcOHoogtedVml/9uIR9GYu+I0qG2OmGcnPjYS5C2jMAEa7lteBlDSKTy3RvwVbK8a5vdLqEn1WUT71m1eel/aaiiCilE02EAIv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712252325; c=relaxed/simple;
	bh=hMJKq/SmA824AQR2cfWBlZWXT2/Fz2l+t3Z+8PhepFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGdoOPT+66bA0EPoj8yuIW2sIO+rbjhWV+fT0yf6LANbitwRXTIn4pH2cjgFxvTL3fHRMN6XM5EbxtMCan450USmqIjNqX8fN9+8CytzkoNWKlpeOwmMX38eZ5hdcQmGUDjikGGAx1QDC8LcBNFHlbF/lnuwtdWukNzDyf65Q8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SIXVnbOd; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SIXVnbOd"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2d718efedb2so22208261fa.0
        for <dm-devel@lists.linux.dev>; Thu, 04 Apr 2024 10:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712252322; x=1712857122; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kcEVHOvMDP2F84U5QD7C+dBXealcbHcTSreuwWZ+Qx8=;
        b=SIXVnbOdWUIVJDMoWFdTQgu939miXzX/2EYzx9Qb2szRZaltqUWiY4ih/S4f3ujlWz
         9bONh9W7iL9QIYms1RSx6kqRoFc8vybgkFmdvoc40+Lb5w1B4/DH44c/aleFUJKSIsdp
         7IJiMNg+65c15wtOhjHQ/Q6rJYsFsQXqgxBmzCZUjBsobrYqjeC2zWCsj20EBGk6n9q9
         L5xsXRHgrhtAuLL3Qbt3BDvOMRRu1IKOb9RLsnUjoo0FMruZEisf18wTdgGU8GEIb1kv
         A3gh8aGX6OBMbfi3mc3/W5CpcF7+tIcapKPeVuxKgDGhJw0g7d+xTRWjljgxw1w1yPfH
         /fOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712252322; x=1712857122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kcEVHOvMDP2F84U5QD7C+dBXealcbHcTSreuwWZ+Qx8=;
        b=Cfflpk1kz+fckaBVd86TJi1bzAhleNCkcbu4tfJXFjzL0dkQtjTaIjdL+aSiJqNBdk
         Ftr67dU08jyr4/EYG9CO8Nxhs3QMRVDFM94eCTcKcMP/VMAauVOQt4KWGBjf2uwCsdxn
         QMBqoCczzkZZrdWwydSBJAZ+GfdlkhJjICaNoWNwIwsWTv2WV46qmjLuOaGv+A6Qcuww
         Ger+K6Nkp8A496xcStyymbSnXSq7Ln+G/msvnEf4xb3rsPip9DgxHaWWTiYkiWkXKvJJ
         /9ITR8hyZ5jPvdAN0ZfwTMMWac7m8BjXrAKwkM5Y6mLnYPwDT40WA1VHOo1tMh4urZl4
         1DrA==
X-Gm-Message-State: AOJu0YyaShjLA+pluXD7TgtMvfBIoLrIRCNLF7U3ce2/y41WFBuEeFNP
	Qbnf++IDnDhlWls0sN2QsAK/ObFgNN0K06WCm6RrBEakToM22HnKdbreNT6J26M=
X-Google-Smtp-Source: AGHT+IH2FRRUF82HuBbOdQ/cdYuFEHNVQuy1parzn5m2BrGIXUPgP8YAzmACobnAjGhQE8UDrD9pnQ==
X-Received: by 2002:a2e:8054:0:b0:2d4:676b:f591 with SMTP id p20-20020a2e8054000000b002d4676bf591mr2946490ljg.45.1712252321829;
        Thu, 04 Apr 2024 10:38:41 -0700 (PDT)
Received: from localhost (dslb-084-058-019-253.084.058.pools.vodafone-ip.de. [84.58.19.253])
        by smtp.gmail.com with UTF8SMTPSA id c16-20020a05600c0a5000b00415509b11c3sm3441736wmq.22.2024.04.04.10.38.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 10:38:41 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 11/11] kpartx.rules: ignore DM_SUSPENDED
Date: Thu,  4 Apr 2024 19:38:14 +0200
Message-ID: <20240404173814.3143-12-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240404173814.3143-1-mwilck@suse.com>
References: <20240404173814.3143-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

DM_SUSPENDED=1 implies DM_UDEV_DISABLE_OTHER_RULES_FLAG=1, no
need to check it again. The DM_NOSCAN check needs to remain in
order to keep compatibility with dm rules v2.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/kpartx.rules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index 1969dee..8dd3369 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -27,7 +27,7 @@ ENV{DM_SUBSYSTEM_UDEV_FLAG1}=="1", GOTO="mpath_kpartx_end"
 ENV{MPATH_UNCHANGED}=="1", GOTO="mpath_kpartx_end"
 
 # Don't run kpartx now if we know it will fail or hang.
-ENV{DM_SUSPENDED}=="1", GOTO="mpath_kpartx_end"
+# This is required for device mapper rules v2 compatibility.
 ENV{DM_NOSCAN}=="1", GOTO="mpath_kpartx_end"
 
 # Run kpartx
-- 
2.44.0


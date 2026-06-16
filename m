Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3879D35DA7F
	for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 12:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781612966; cv=none; b=aLNAN4raCAXsul+aN5Wzs5wapZ9gvIhDuWTiaGVT+11QtkBFhBEcXXggZQ02Tt3ZCsRPQMuTUasuNUd5Mfw63e1h/UUhJfVAkhwvlTpBGbkmUAFGrrij+kKyaDbXGzKOECAQi00ZlBqpJnSUiFGajZbLLzhFj9VeLfyrhfYWZEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781612966; c=relaxed/simple;
	bh=VEH7WnM8Jebol5AX74cPnoiA00g+oUlWCuZgewqPtZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+D5GI1881nh14YcEapBU6QHCCc58AsG9Rloar0OXaMAoyotWLF8OJ2cwHIRtL/7n2sgvnHZDErgtAKqj9FTFwKoKABTmQCWw1t9wCtYVnjTd5Tl5Iv+fILOYYFI4VsYrdenCB0z+h71KmGhAmsgm50kZFfdxqSN8UXZsxg8SIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ttw1YmmH; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ttw1YmmH"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-45ee45db96dso108681f8f.0
        for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 05:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781612963; x=1782217763; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mIUG9punaEqOLFtc1zdBkQGP+P+ZF9e0DD4bt5BMGIk=;
        b=Ttw1YmmHUgTG+hBn0n9jMnfmNrp9VqRoZLVv8zhfb/HYIC4oMaFUw51v7QbVd+F2DP
         xr5nF0pfAvNHFlRlOpvw1Zy0g8s4eljtSTsAVtEYljmA+MPleSdgMEdo+MtUXgP2cbDY
         cVZVT6Y7Tks1SZ1KnqZAOco86sVeHK3GxpDUX8p/zn3Chjwg75BcVBV4qtHLK11YVL9w
         xpX7uYUdhBCOeX1mFFMfyQ+oEek6QQrsqjFU9BJPHbGwAO2Rw3PsOCFHrWLvhWMdgTda
         mQcflGURev59Ud8+KoM9OqQeYwHxSrwM04qmB5GTX3hBSCWED6OwhDdz1K7SumcnDSv+
         2CMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781612963; x=1782217763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mIUG9punaEqOLFtc1zdBkQGP+P+ZF9e0DD4bt5BMGIk=;
        b=GuhLPJffiq2pR5QCFwSYzhMKiwSZQJKng9EuNZ9jeEJBtfMmOS5yVgjhlhBZaoK1MZ
         h2ex35EXznplxt1q2shJsEIhJh2jS3OXX+ocsyoGIPw/rM7LkRbGfJrElbrPVCfDrYuJ
         0U6dRe3ZfahMxbIEQf1jtwnlvQMgcldPKJ2K8c9fG6tmUTAfc6rn5lJ/b0Wfa9Qg3dVS
         XgHRkd8LVoOBokBfZ/9OduePA789rWn2PdQKf5SuFMYyZQfqXMTXhGqKiiXgP1MLl0wW
         8bGLCZyscdYqKZh7iidiy34gO8hhOMxf+07Ax2l7BQFEA2yVcl0TZsn4FbKGlmhs0LdA
         ceTg==
X-Forwarded-Encrypted: i=1; AFNElJ9umQS7cFBmBFuL6PBEjdvXLVyRzdP+2jN6zYS14ZnEjETsUlUkcKiIBh8BaUJ2whHfM+SmBDk9Cw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwA0J/hsIq14t8ktUjvwhlbnFpcuyGTg813QsiH+aCKTel5b6fn
	zTIU/fA2Y8B4akmnBUmLWPb2abAA//MZ4ztBUR0Zqgupi/rtQMHR/AY=
X-Gm-Gg: Acq92OHkXHSUMtqN8XtVP+Q4GX6FgGPheS1lfNfaeAoqsbgMrQr40qQjaaKN4I5mR4g
	qJ5Kgbu4CBumlbVQfBba5FQkE3xSL8wdxwVESp79VuicyDYd+QHGXeA51+X3Rlh5eTzG07veAZu
	qMQMAP8kwNgKTWkYxY31yq9JsB2+QrZSbGtKUTp2Hvwj5L9cNHVW/i2UtLfqr9oPFLoyjm1KbmH
	gLRZHKQsJTQFvjQDMycuvFQpnTTmdX4EjMfz9Nar4ODb7YJa9zIfP6BYIPN4Aqr3okRt37u1aMR
	x1W0waM+kuCkdR0KgK13drZM5eBcqd9AZA+hVXutZXfht2HUcgL1z7SHMv37EmRUWt3EStIctld
	VDuKc2FYvrPY5jNOhbZYBaMzvOPqoDEqunjauV5hfhye12w/DRSCSGrbS+g50zSTcXcF5SwbK21
	8T1RCpnqosat3FM6H3yrFyM+B0rg77p9jhto/0Aai7aRfQutf7DL4N/9I3dwxWMua8
X-Received: by 2002:a05:6000:40cc:b0:461:a159:4a74 with SMTP id ffacd0b85a97d-461a1595206mr2093878f8f.1.1781612963566;
        Tue, 16 Jun 2026 05:29:23 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2dbfb1sm47192196f8f.35.2026.06.16.05.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 05:29:23 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH v2 7/8] multipath-tools: clarify user_friendly_names prefix behavior in multipath.conf.5
Date: Tue, 16 Jun 2026 14:29:03 +0200
Message-ID: <20260616122909.244619-8-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616122909.244619-1-xose.vazquez@gmail.com>
References: <20260616122909.244619-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Clarify that the alias prefix depends on the alias_prefix setting.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
v2: fix copy-paste typo and delete <n>, changing "\IBmpath<n>\fR"
    to "\fImpath\fR" (spotted by Martin)

 multipath/multipath.conf.5.in | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index de6c21b5..165d3df3 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -704,11 +704,13 @@ The default is: \fBunused\fR
 .B user_friendly_names
 If set to
 .I yes
-, using the bindings file \fI@STATE_DIR@/bindings\fR to assign a persistent
-and unique alias to the multipath, in the form of mpath<n>. If set to
+, the bindings file \fI@STATE_DIR@/bindings\fR is used to assign a persistent
+and unique alias to the multipath, in the form of \fIprefix\fR<n> (where
+\fIprefix\fR is defined by \fIalias_prefix\fR; by default \fImpath\fR).
+If set to
 .I no
-use the WWID as the alias. In either case this be will
-be overridden by any specific aliases in the \fImultipaths\fR section.
+, the WWID is used as the alias. In either case, this will be overridden
+by any specific aliases defined in the \fImultipaths\fR section.
 .RS
 .TP
 The default is: \fBno\fR
-- 
2.54.0


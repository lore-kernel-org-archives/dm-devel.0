Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786C226ED46
	for <dm-devel@lists.linux.dev>; Sat, 13 Jun 2026 13:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781356210; cv=none; b=WxPltU48ZDrZ7OQwLkTy8rU6QrAZvGb9x63m2rQlP5ZSrMk2dyQsOtSXbYrG8EnDCR2TV8Jy6gpAefd4ybe1g4aAevMI7F0FmIa5kBfiMdP+pIrscbb8zyQ9HwrGmnyK0EWZ89TMKjD8cTg5dYhyGEbqbMcq5XuF/9MAFqn8cec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781356210; c=relaxed/simple;
	bh=kJ6WRyibSMaUyqvZkE02Q7F1cR05Wm5K3Wd3sCEQJBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skZx9tbTO/zoZXrqD49Xgs+x9LmweLcrKiQ3AaOkclzj5Zwo2XUz2HDJbtMiwLMXRDzzaXILNFOyqqEfGxo1EHf6CLEp/thM6ev2ALFGhWxxKAQ9sd4fizqZyKmTvCdBceHYK9k5RoT4hZvhew4i66dxNcSEi02p/PxnmL/uUy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EcQUUE/I; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EcQUUE/I"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490c28f84fdso4223155e9.0
        for <dm-devel@lists.linux.dev>; Sat, 13 Jun 2026 06:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781356208; x=1781961008; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrGbEtbTMIxtt4Uo/b5CKopxDQokElchGMDM/+fcaoE=;
        b=EcQUUE/IwlZPiQyaRv79rlPK/mzyoVLmhcmjoqtTfoNSDtzaTXX4jzm+0pRLnklRGi
         VTKhjAkeDEDWKGymGSQm+of2TeTSTgDVOeCKYLpxRUD/+aLH1hGS7qOPhZ9NZEiMwRwA
         e0+0qYn2AfbaRvR/GQnK9yYtwYah1oaDJGhDk8D1usW7CUmw2xt1aEG2WsDXyRUhTG1S
         iNcm1u1kDVx6fN8iixUV+mn7qqIDvtv99r/K9gld0IqhZPrj4+P4hddIZDjoIa5wuic4
         Ak9jcngb4kavMOmrmhbW7TFtKdcyoHVJBA+Bsy+RQCvL8wKqeWlDUIdcbaebSidYyuQb
         D6dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781356208; x=1781961008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lrGbEtbTMIxtt4Uo/b5CKopxDQokElchGMDM/+fcaoE=;
        b=dos2o0/vwvxa3FVytu12lJVyl60eQpzse3w7Iu1wZaLTNJ72AuzhlWnETiWEN6BTOQ
         GHV1R7Q92bcvmXg0ueOTht5kphn1HvPWIe7jYYO93yJSdERVKIF0fR43ETJ+djvJ4k+0
         vup2qCf64fCa5jOhHkLXi+4bF5H7jShrI2q3My15iKG+17iBH1aAt5OFY6NhYYb51WVo
         J+0OUWd/Pl6LN54Rqzrx3Rv3t3EvXmfCFvTu+WebLJgDOaMX5nzSV4uuykbj9/8k9Aog
         7hPfAZuqTtz4KjGf8ft3aU1s7tNtPluEvXJY6XaO+ogc5VNxmPBt6LTlcHByGV5DEMqS
         ouMQ==
X-Forwarded-Encrypted: i=1; AFNElJ8snd/dkEU+s6fUTE3c+mecH208BhbCigqYbWhJsCPhM4AIKL2109ptemNNitQlIBiUFCC32LVpPQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxrUb0iMR9h6hKQwIWS/qie/eH5qOSSUrT6QtQ7byq5NUea42M6
	fQ40oNxh9XhXkwWujinMK8SdmLbENqOffzcmJwDoJtZRV4lzv+NzH/s=
X-Gm-Gg: Acq92OHRgQMdjMTlEZWJ2AI2juBbN87mmUq0SS518mcc9ByImzCRFkcG7bsbg5fEJk/
	5BCQT7vzy8ERHFFsw10ZtoL7W49uYQZzbMNhfabIhX+J/LiJUflLresbvZIRIuLqIvmUulTnmmp
	hzyIeiJ3dbVwdf7ZY4ylPlfPiUmCB+Z4THHTKmAp/KzobZB9T2zbOQ2qABFnWPUIAVVzV9BobXA
	INQDNV8rgR3DPvv+md59JBP9xuwBO+OnPp3B8IlkVPrY2vltuwzh/sk3Uq9J3rWv2vF/FYUEA85
	+ZM9gBxXSGnFtNBVqrCWcTQPIjgDZMEEiGt7kJAH918/qKjuAFZ5jftY3jpeUZf5oogbVmqWTFc
	xnnm0mitoc1+tFfkC1sQx5wgbyXxxtX5684SbRIGNfTqereV0IYaX1UnKI3PVc8L25OYe20UELT
	MkWXBAXi8F2GiqoVkv+0PN57d7vl//3CyiKHA/lj4G4OnAxGAGeEAHQcAO1ELWRe7dnnGbHcAF6
	ug=
X-Received: by 2002:a05:600c:138e:b0:490:b45b:2471 with SMTP id 5b1f17b1804b1-490ec5067cemr45200725e9.6.1781356207592;
        Sat, 13 Jun 2026 06:10:07 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2637ccsm15317250f8f.6.2026.06.13.06.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 06:10:07 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 4/5] multipath-tools: clarify user_friendly_names prefix behavior in multipath.conf.5
Date: Sat, 13 Jun 2026 15:09:59 +0200
Message-ID: <20260613131002.144263-5-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260613131002.144263-1-xose.vazquez@gmail.com>
References: <20260613131002.144263-1-xose.vazquez@gmail.com>
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
 multipath/multipath.conf.5.in | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index 9289b244..74447f8c 100644
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
+\fIprefix\fR is defined by \fIalias_prefix\fR; by default \IBmpath<n>\fR).
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


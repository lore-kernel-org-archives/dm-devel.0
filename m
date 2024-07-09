Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4475B189F30
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561226; cv=none; b=WfwzCr7t3em8wrjHidSH0Z3MFXFw7BQPUVZCoT87q2UEVJ8di6h4ZWrlnXnkF5QDZ1N72wg/Jk7DV0gWkQ3uraTVhlJyzqn2t54PAmHRxqyrCSxlkv6VOlAv0ygwMmYtMSg7w6TmDG+8W/MQEX+OUziClFSpVcrC1N20Bs2kMdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561226; c=relaxed/simple;
	bh=tQFBU+z/kp3Jop/VyLHVwhQ9gh4Hkrknz+iriOb3Uxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkW0Zr5MseWdq+Uc4iIewI4sJn9PV4ryBz5xIh84f+TUiOA0xmTqmuw+EJDFi6tMj7vySPbSC6lmh/uriQaUcet5bZRAhBkT97o/JtgNfJUuw5jeJclsvfLAPZsRqJe0+S4z9UKiQaTxU7NQPNmIkPCD9knrVAzjMwEE3IYL8qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=I7mNWb+N; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="I7mNWb+N"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-58b966b4166so6855744a12.1
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561223; x=1721166023; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7M/qjX04KFB0tD49eYeiG4bRU5le18KKIKvEXTRllT0=;
        b=I7mNWb+NbxqV/Zq036gLuQwFXktwAyYssbnUyy7EMM9jXp57yfGTdd+GnbMmFugD4Y
         vXTlrGZjoG1NaBysGTvll/wOZ5j5Z/PhGPiOSZjj8/T4QtLjZ1W8M49X3yMM5NZhySkB
         5DAo5wz6Wr1NJolgPVrtxV6kcr7rie0M8wxgbCiMeF18eH1WD9fSR9dCHRIypt2naJhy
         X1GJ0iZyQs2AaflkwDtO/jPLGkdJIBBR0IQU8jsX/jGBtrIrA0oOaXRh6yc/xVWkjM/X
         Q2yWz/b1BrvJwMnGhkrnEz31Vn+HmJ5hZAnZTkRkzQr3P88dhBcMhbWLxiOvfwiqTnGg
         GaBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561223; x=1721166023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7M/qjX04KFB0tD49eYeiG4bRU5le18KKIKvEXTRllT0=;
        b=CAgtu1WARNxb4GW/alnELSNoxpXmH2xfs58PcdjwWgd4T3qP4BNIpniO+ldgLwxtR8
         nR3N5emJ/qhB4VYSvAPAqpo/TUGTQlMY2fwf/69ItUBOKHPqO5ofqDPtXBb4e85ejcYI
         HD0QI5DQNBPDNOgnkPr6aLF+L0MXEvNYoK7cRa4t2cGi5Q+1nq8qPHVOuCJIMU6A+Q3L
         g3VYBTDPnzDrIhCSp+IHwaX0xO2rd5VrTRFS5fnodlURO2TnTHMX7xVPQj8/si7TK1zL
         ZRKm5q4bA38A2FFFxTCwII6ep0ZcoytM+e0+wPTFoMSZGsRCph7sfMFcp6rvP9LsfAyo
         lEdQ==
X-Gm-Message-State: AOJu0YxXEdtbjjJ7QOBZCBC+nU/ZoEBiuMoc1sLPNvEyYUrJo+7Ldaz5
	A5cs5rDym+NkYhYQs7Ot2J0iNV5p2SwZcmR7kSVIkvRFeZFldM0Bildwc7P1suo=
X-Google-Smtp-Source: AGHT+IGjw/M+AWWaY82qjgUZt74SrlG2Dz+hZ+f3CuvlsHy98f7Ss6gfvATa0p35PbZ30wpgQi1HQA==
X-Received: by 2002:a05:6402:5255:b0:58c:c29c:2b73 with SMTP id 4fb4d7f45d1cf-594bcba7dd5mr2004472a12.40.1720561222513;
        Tue, 09 Jul 2024 14:40:22 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bc3f3defsm1490434a12.45.2024.07.09.14.40.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:22 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 37/44] libmultipath: drop extra call to dm_map_present() in domap()
Date: Tue,  9 Jul 2024 23:39:28 +0200
Message-ID: <20240709213935.177028-38-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709213935.177028-1-mwilck@suse.com>
References: <20240709213935.177028-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm_get_wwid() will return DMP_NOT_FOUND if the map doesn't exist.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 565ea5c..29c11ad 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -834,6 +834,7 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 {
 	int r = DOMAP_FAIL;
 	struct config *conf;
+	char wwid[WWID_SIZE];
 
 	/*
 	 * last chance to quit before touching the devmaps
@@ -843,8 +844,7 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 		return DOMAP_DRY;
 	}
 
-	if (mpp->action == ACT_CREATE && dm_map_present(mpp->alias)) {
-		char wwid[WWID_SIZE];
+	if (mpp->action == ACT_CREATE) {
 		int rc = dm_get_wwid(mpp->alias, wwid, sizeof(wwid));
 
 		if (rc == DMP_OK && !strncmp(mpp->wwid, wwid, sizeof(wwid))) {
-- 
2.45.2


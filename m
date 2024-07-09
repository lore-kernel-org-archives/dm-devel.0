Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C90187879
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561230; cv=none; b=g9r3twXGJDcqFlp2nmhdig9TA9Hv81weVgs0ytlv7Ag2APhmTT581gdQZ0AarF7g8D7C1SFx9hFtuLIvbIyRNajuKNTj3vx0W1EhKx81xHVX7+Tzc9Xylr/qUU+b7I8lN+weLro5et5pMnTaiiHo/LJz51ii8wF6kBoD0aWcmOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561230; c=relaxed/simple;
	bh=4iQdFJUqg1TGMM4SFDi+cPVzxU9O6Hc8Vu0lTxWr79o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KiyLsFSEdja/ajMIMPFyABEcgIgVmfDCL4cOdmwRdNWbOzMPv+7ousNSeSbjoJ64NG21J4SGQOS8MJP3AlVGrH4IoGsXhex62UzMWijsk4wq4rLySUujevwcU9hYrjXgOEVLlBLdb+ZRXd9wLOGA+NKap+RebXNQ93Bg4L1jF7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Zv+9JMaV; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Zv+9JMaV"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-58b966b41fbso7196873a12.1
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561227; x=1721166027; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o/J7dgWf2/69kUcpJUs2AGuK82UmnBkiAPK9AVx4Hyc=;
        b=Zv+9JMaVO+1U6/uLM8pWSMCu9XLrhur0HSn67BL5M72mQOrIgm6w30dYhGUqs2EN6X
         y7PSheyi68MZ1IQuLitYEUkn5TY/JFsYt2bKxnvpu5MDVIJnLcSIB2rw4eMeBfVeB5+K
         rK0ZGJ2zhpoOBe0wA6r2YziabukwwA/IYhfuGLkeHMZHfMt8vAgFtSdA1XyY/uOJZoI4
         eVZw7BLC/eut746cF7KRFveooSII6sm19u3IiXbT3NBNGC9jSANBjLJJ59rUiHtUbLRr
         yxfoJ9NQyOW1CPJqSEuboTswdlaQfL4d+ns49eRWEEOlsDa9I0k3+R9gnMQDOhbVHxfl
         FZSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561227; x=1721166027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o/J7dgWf2/69kUcpJUs2AGuK82UmnBkiAPK9AVx4Hyc=;
        b=QuBXwZk3GuYr5KIoRzneffE9ZGXMUW7qt8PLxAMBCJ2TzvvU3kpdqMZrIyl+9w9IkY
         M83vaOM7J2LLJFACwobIheNKKkwPXvkgne/nX94vy2MX8dgMP8X3i6PeG4BV9L2gWTvx
         Fm6bCWqn2uRq2caOa7l/BCPWVUjNeYrgoqDFuKvwd2w7fEkWrTUl0iNFVnepNnzjDWkz
         w59LHP1fkA5L3qXMCAXWesSYZv/cSCpiiTOUTFypO68u0WCePS+OR8agRO6zYBcj2bNG
         YsfkUOYrAoHMbBDAl5z0tu4HM/hzEkq9mO5rGLPbBFyMz0I/DFNcWigqsQZooHYzA5cq
         dEqw==
X-Gm-Message-State: AOJu0YzxBTu0zj9ByLsLPgbP2W8NWygb+p+1b9eTMYWqGojGDuZqXD95
	opsWXMG/A+0KupxXCoSaMMiKuJEFhOEHUD8kQsEfT27FwTszuRgOwaSFEl6Gq/lv2KamHqrY19o
	p
X-Google-Smtp-Source: AGHT+IGSKZgafv+fGOIVfhEKCxEBJfygrGK0a26LnqgQpV+Z4ScbNLrxIvN3d1ZSB+83d1PjbRhrmg==
X-Received: by 2002:a17:907:6e88:b0:a72:7ae5:66df with SMTP id a640c23a62f3a-a780b89a23dmr284983866b.67.1720561226924;
        Tue, 09 Jul 2024 14:40:26 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a6bc6cdsm108713466b.23.2024.07.09.14.40.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:26 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 42/44] llibmultipath: fix return code check for dm_is_suspended()
Date: Tue,  9 Jul 2024 23:39:33 +0200
Message-ID: <20240709213935.177028-43-mwilck@suse.com>
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

dm_is_suspended returns non-null if it failed to obtain the device
information. It's wrong to assume in this case that the device is suspended.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index e653ca6..e9a0103 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -604,7 +604,7 @@ int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
 	/* If the resume failed, dm will leave the device suspended, and
 	 * drop the new table, so doing a second resume will try using
 	 * the original table */
-	if (dm_is_suspended(mpp->alias))
+	if (dm_is_suspended(mpp->alias) == 1)
 		dm_simplecmd(DM_DEVICE_RESUME, mpp->alias,
 			     DMFL_NEED_SYNC | (flush ? 0 : DMFL_NO_FLUSH),
 			     udev_flags);
-- 
2.45.2


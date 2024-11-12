Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8910E2038D6
	for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 15:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731423767; cv=none; b=trtNPbEB7Mjn4J6gmvZfPJ0fMBrtjbCCHZ2JBfx+KDnIflAzZkN+R3J2g1dlW5J8BSpZQ9dY31iD2idoAa72VHhL0CJxtJ0zyB8caVYpKQLwCcbxuVAro5VwXauRfqG71M8TWkxv0CW3cLzeqXtViR9dGFDncdgWLqvucRnY4zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731423767; c=relaxed/simple;
	bh=IPkwcRkbWsK5ZzvesuHuopJZJirvCzm1LcApdqjpPxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eocuExdzaLqA8CNKdxtbqyjiSiM2hxXooVzQWDv5A+wngttgyWjnSZXm1lW/QvYAdc0KSRG3Be82/bLougfWheTWp3OGZAPf2ADlJeKB+gKOyRPJjqedsIVfDgPTkrp7idtCl+F/JxSCeTilXHsj5IfbgzqDYqtl4tBWcK+XOBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OdoyQicc; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OdoyQicc"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43167ff0f91so50999975e9.1
        for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 07:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731423764; x=1732028564; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tgrRLTBS1xpLyE81YX4fHW3TadW+RZKWohG3rYC8HP8=;
        b=OdoyQicc+PFMne/IKAIexpSCKrdlncxM5RuaSDyb6xQiiboqsfycvIIXAeKNgEJxyq
         127ODDO5fqECVF0cWYbSbI2peHXSPw74M68gQA6I3RvTDuydQ30w3G7VuEdBy13GwgrV
         nV1TjEzVlfD3mifsu+S6dEffgdLQREbAaeTR1ziL6XU3tfmeO1KNu1UCwXX4Ky2mms3i
         BZDOl1Iv5g3Z9xf+zKOxgJz/SSiWFur2+XTPJmKZp/LFx3qEax0ABAJpW6+ioTya6toc
         tZf7naGr1NoF/axHFiaWz9mBKfQ40HB+zVxpu2tGRidzrQD6+j3TYVj60sbnYmckgiYI
         q6kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731423764; x=1732028564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tgrRLTBS1xpLyE81YX4fHW3TadW+RZKWohG3rYC8HP8=;
        b=Mgyifi12G+Vf9VYUnoyZeWinOUbOGH/S3IJNCh0tfdvxFfB07lNUtqHsBP/qmMn8IX
         COi0ZWq0UHm7mbSQcliMduDfv4yeLu1qpgjUuihRUGp3LJtlNuwgfkKfTlrAkLiCgSED
         NNA7ZXCQ11JrjVIyq8fnG5dqoeQ5pQHOUf80IYeVXS6vTADKz5JXqkVdzCd3AapMe+99
         q+SKSp/iIcy26cJhPqdf65cY1bkvU87S+1owN4FTR93C6VB0EiNwCPoxkw0W5vCZH9lS
         blmCYAEA74ZEuRc6I/lp1YlBi2BIn3YduvdGaE/R9aNSXF9kcpqCJKSodEGgsXK7b+eQ
         K0hg==
X-Gm-Message-State: AOJu0Ywd0H+II/lRowMyXMDXbOklMSCn/venWmQfTtSTgNE99xcSPG6o
	tFPjL7Ti5339MfUNbVU/FfG+ps2wM1sZ4eyoH9lzr1dmLGCy1jeJpeMzSEBghXY=
X-Google-Smtp-Source: AGHT+IEbJ39qsfoZQvGuv923+k2QsUqgAoBCmMXXYeHXqY8pz4cQtztOsjjt7B4j89K/sshZqpdn2A==
X-Received: by 2002:a05:600c:3b22:b0:431:52da:9d67 with SMTP id 5b1f17b1804b1-432b74fdaf9mr148638845e9.3.1731423762941;
        Tue, 12 Nov 2024 07:02:42 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-432b0530599sm217756505e9.1.2024.11.12.07.02.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 07:02:42 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 09/12] libmultipath: increase log level for removing partitions
Date: Tue, 12 Nov 2024 16:02:12 +0100
Message-ID: <20241112150215.90182-10-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112150215.90182-1-mwilck@suse.com>
References: <20241112150215.90182-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Removing a partition map is an important action that should be logged
at verbosity level 3.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 3ab231e..3502d05 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1392,7 +1392,7 @@ remove_partmap(const char *name, void *data)
 		condlog(2, "%s: map in use", name);
 		return DM_FLUSH_BUSY;
 	}
-	condlog(4, "partition map %s removed", name);
+	condlog(3, "partition map %s removed", name);
 	dm_device_remove(name, rd->flags);
 	return DM_FLUSH_OK;
 }
-- 
2.47.0


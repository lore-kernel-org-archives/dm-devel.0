Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7045204030
	for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 15:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731423770; cv=none; b=DlZxGOHyovkr+lSektkGn+RHYQiTDJCRkuvRekpt7UyjzoacUfimXBZ7I3xt5/b6NfvD47gtmAreMczBWpW9Ed+n58efgVj5sMnUqBX41l2YGwHCTRHj5749GhHDIw6YX6r9f4ew1qiFTNSGJFHWwZMydnu/n+Fox+J27xd7vn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731423770; c=relaxed/simple;
	bh=HyNqK1r6QUWdru52yD1z8iwS87iS+jsVTF5BEcc+Wjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHqL5/N6zNVa52eR9ThzAgdP12491MLM4IKPYEf5vqrNskRFztRibd6TA74nWglNaIeKOro4T7SSG68XtjfLrSXy0Q3sP+J122Qj3tG7Y0b5UqoSjXhVTjl9VjXYzU/zby/jGF6M45+mdER54OSMeYTPuzyz+sVTE/5AP0wUpS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SB0hTOyG; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SB0hTOyG"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-382026ba43eso1325170f8f.1
        for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 07:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731423767; x=1732028567; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5k3rxKGwcmdGypHCFp3inEq13eBuYaI5+UQ70ZS7A14=;
        b=SB0hTOyGb4mrffFZQ1FCzOXuSOo2sj+yuVAx0aDGr8AT36a9SYfsSY11Bvx2eLuZAA
         XSptAEJlirfYdfKijuYsfotf82spAP+JCJuM3HT3vntdRc0iL0+PLpCX8WUlwW1rR31T
         hShFNngU2Pg1wBwzldZ7R9gxRCbrmnS6A1RUU/ov8UJaLEXCw5PPjLkzL0pMq7qOch4b
         e+z+BcO85ZYgM0TsCrzV+aT4N6On3sm02+goCw1uW11f+8sZM9BUYLKgg/qMODWjD2qE
         u9PkZLWCIj/Xw7j9P81sXXqjTsa7sAqGrOpd3LHRl6XZZsx9jMjP9t5KSMfHOMYCqhd0
         029Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731423767; x=1732028567;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5k3rxKGwcmdGypHCFp3inEq13eBuYaI5+UQ70ZS7A14=;
        b=j5RHNC01abodFeClMdUsGWPvvswW9y2t4KWxMeDXH/186dHiYOTgYvgRN9W0hGcsI9
         Em8x+yov+7UTpPMqj4GMrnys7qfFllIDDgR9dvpL8sciZgepLypFls7RvDQs/4tm0rIn
         fQQnC4L/UOOEYFmbQUCDO4C4jYsGQREQh0WEwgLIWhakQNiJbZV+5cRykZu6MwMhiLX6
         V6n5h1QhlXInnDaHY/J2nqt5JcDgkIK99Db6hpqqYlDAZnbfLjVWcdar/c12V/4Ry4NH
         yXxE6+rnTfkABmy0+oYjIzL1T/bpNpj7xO9h8E68EFxLOZlSdlVum0fZQEkopcdOH1OS
         111A==
X-Gm-Message-State: AOJu0Ywl9dYpuOuUW5A3D+zcauSwnHHDiy2QDdd2syrAEoq+LEdSuBJr
	LwKK2zaYuFz3VHLlmayt2IC9cmHwTxsVhEZCMFFuBdyxHaDd/OZp8e2bmHGh30Q=
X-Google-Smtp-Source: AGHT+IF9BIWWTn+4RQzH39BkAyN3o+WMd+ROQeR7H685a/qd8MOaZeemHsfPb5ZL72NAClflx5Blkg==
X-Received: by 2002:a5d:5f95:0:b0:37c:cc4b:d1ea with SMTP id ffacd0b85a97d-3820834a0d2mr2285218f8f.53.1731423766788;
        Tue, 12 Nov 2024 07:02:46 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-381ed97075fsm15425447f8f.14.2024.11.12.07.02.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 07:02:46 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 12/12] libmultipath: don't set dev_loss_tmo to 0 for NO_PATH_RETRY_FAIL
Date: Tue, 12 Nov 2024 16:02:15 +0100
Message-ID: <20241112150215.90182-13-mwilck@suse.com>
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

If pp->dev_loss is DEV_LOSS_TMO_UNSET and min_dev_loss is 0 (which is
the case if no_path_retry is NO_PATH_RETRY_FAIL or NO_PATH_RETRY_UNDEF),
we will set pp->dev_loss to 0, which is wrong. Fix it.

Fixes: 058b5f5 ("libmultipath: fix dev_loss_tmo even if not set in configuration")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index ae9fc8f..b585156 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -942,7 +942,7 @@ sysfs_set_scsi_tmo (struct config *conf, struct multipath *mpp)
 			continue;
 		}
 
-		if (pp->dev_loss == DEV_LOSS_TMO_UNSET)
+		if (pp->dev_loss == DEV_LOSS_TMO_UNSET && min_dev_loss != 0)
 			pp->dev_loss = min_dev_loss;
 		else if (pp->dev_loss < min_dev_loss) {
 			pp->dev_loss = min_dev_loss;
-- 
2.47.0


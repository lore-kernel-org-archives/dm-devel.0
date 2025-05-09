Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB79293457
	for <dm-devel@lists.linux.dev>; Fri,  9 May 2025 13:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746798305; cv=none; b=fCSSUklSM63E6W1Fgj1NgX+QPBNDRxrBt4P+1fLidMqklXmbtu1JmTI040yqmAl8eF7voWujh19aOyAOu/xBg6n3Z8WFhtQ8asaUfy/7O6Oyd0pYEH8ivGKnB+0ibTF/30y8J8wHmN98Txfw2Jr2BeSlWZLLYLSF1hIRQmLTD1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746798305; c=relaxed/simple;
	bh=2knaVMFPL5WJe1eoUDp9NOOmEkejuBiPUFDXSK8zdkA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NhhhTCjlUsk64Z283DL/LCkyzIw76xaZgTYApw7oeP7LEbuF5E1Nbf3LqY6qq1hPQue0pFYO54KmYDkJ6S+HgWBPkzBSZE18koV27azvxgOPXWHWXrAAh4NtC+ZCu0NYbckWTKadnooFG5nexrcWBIPU8BxppCP6/0+P9Qa+BbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h4EVUcVE; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h4EVUcVE"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43d72b749dcso2123615e9.1
        for <dm-devel@lists.linux.dev>; Fri, 09 May 2025 06:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746798302; x=1747403102; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XFBCU9DnKB/pCvuZn4wKLRfCsd5YShKSlW4HqbRxlcc=;
        b=h4EVUcVEXXoRaL/XBpxtES3ypQMlgxC7sd0H5Ip9g7vd4J2S0bwl41CFaXJ/hkT3za
         nAEa3A/sa7OzsUV1cLPLkqzD010cB+YM0Vd6FNylJLC8NaRNL0qVMQnJiYHvar8/LLe/
         vMWByjc1xBysuXfvJGOkZoZ0wmVZuAx9+WSy5SN4YYbpFdSlr4jiBv0IPxfYa+rCmRgJ
         nY65MstwAcOrMiCh1ZlSNYilDiy3NKPL3ti2y9zLElerMICPc4CXQm07W824gOLx5FjQ
         svIMauASGJh6mgGEdguFCUTslKgpZqoG+7lUyfffH+G8Z92ldEga6eGqWqCFieOlUWMU
         sS1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746798302; x=1747403102;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XFBCU9DnKB/pCvuZn4wKLRfCsd5YShKSlW4HqbRxlcc=;
        b=jP0+RKHaL9uIppldpGX6GVurmwYNXp/LwQMvn0Ii/HnEp4+vYrp/xtsLp2X+iCCnr5
         QghUx4sYHypEX1Uez+2MSZSQJPyMMHtbrCMuN4dgJymhkgfANRHymrtFB9gqyBs7mB5A
         ATPrh4jSqtQac3LmrSY5XObZgvyjQUMoTSFoIxMQOoag9+xbbyGpGm/G8/NVPkCiYwxH
         mvkq7xGgHM75N9jY2YHxoGVcgYdeC6DsHvhavqlqvkRL6vqY3dl9XQenuYNkIwRCEYTE
         +kLJseGe6c9jA1mJnGuDAYpNj7WrCaqPC0z7aYMJ99G10/XyS7h61yqGODV0Q/VetRGS
         nEOA==
X-Forwarded-Encrypted: i=1; AJvYcCWw6Haxa+4kyVsM33BrbJXiLIUGhJe0DV5m8i69Dc1lcRh0xwF7K0pEg/D5djsE6DF0hsDKNFDmlQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3KlQahnatTdKLA2Cu2pWodJU7TdSpDyOBYX4zOzeVhfbLvLmf
	E/vAeMyQgJQemfMD/N1HXDq8g0ac3kewMUcRVTriC0tWsd2+9No=
X-Gm-Gg: ASbGncuTaOVGGKYjIG7YUiEtSMcIp72AjJSwN+aRuEmb6AZGbiWvxeAb2OVOq+3GFao
	086by71zO2cyGj7GeU8MRWbb89cDMVquUPawFJTQgxuzB4fXwP1+TPwyet8PtLcjT0P1tMBPJIF
	/LiWjkjQALqgYKJDSJ31P4GbEuxPtlHpBEatizr86NaW/CnVOt1YDDYEYAwouNqR/79CTgaDuhm
	IUBbbtLvHC/h17ik6x8dIqh2aoIlWeb1BxH9nmJ/lJmOFmUIhpmBLAePzyjYrx9YyPnRg7JlH0V
	J/7gyCm6hSzeEZ3dZ3smusErHZ7IaJqt/rfEIdtUkdhrFRp8riWFLv8d/TG6YSW8hiPA6hi6XSi
	CSlv5k0tn
X-Google-Smtp-Source: AGHT+IG9Aev6sRPdKDmC38BT7EajSrx8/kNal1zHwF8KPxX808GBXaHB35snIHnoMHvSehnMqTOjNA==
X-Received: by 2002:a05:600c:4ec7:b0:439:9fde:da76 with SMTP id 5b1f17b1804b1-442d6c39b14mr11223825e9.0.1746798301531;
        Fri, 09 May 2025 06:45:01 -0700 (PDT)
Received: from localhost (236.red-80-39-130.dynamicip.rima-tde.net. [80.39.130.236])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f57ddd2dsm3296814f8f.9.2025.05.09.06.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 06:45:01 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: replace round-robin path selector with the default for NFINIDAT/InfiniBox
Date: Fri,  9 May 2025 15:44:59 +0200
Message-ID: <20250509134459.226640-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

round-robin is a basic selector, and only works well under ideal conditions,

A nvme benchmark, round-robin vs queue-depth, shows how bad it is:
https://marc.info/?l=linux-kernel&m=171931850925572
https://marc.info/?l=linux-kernel&m=171931852025575
https://github.com/johnmeneghini/iopolicy/?tab=readme-ov-file#sample-data
https://people.redhat.com/jmeneghi/ALPSS_2023/NVMe_QD_Multipathing.pdf
The same happens for scsi.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
Should global keywords be banned in the devices section, or deleted from hwtable ???
dev_loss
fast_io_fail
max_sectors_kb
...

They interfere when two, or more, different arrays are connected to the same host.
---
 libmultipath/hwtable.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 081d119c..3ade3669 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1125,11 +1125,7 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = 30,
 		.prio_name     = PRIO_ALUA,
-		.selector      = "round-robin 0",
-		.rr_weight     = RR_WEIGHT_PRIO,
 		.no_path_retry = NO_PATH_RETRY_FAIL,
-		.minio         = 1,
-		.minio_rq      = 1,
 		.fast_io_fail  = 15,
 	},
 	/*
-- 
2.49.0


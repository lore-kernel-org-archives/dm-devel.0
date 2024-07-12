Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AC31741FE
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804537; cv=none; b=EK0egVf6kZlTzq5bh7adp0fpEgOBMLWhSojVspE9YB38O5pmBLxfC2eFNlrn2Hz8CaXbSFYaOq8KI1d0Bn9Xh11ZNMBPnmHMgln9o+9Lk/uYqZCipIUSrpX9edegDOjKS1oR8BTfwUWFWxhrXEP2KoU2aS+x3dV2A7ZF2FarnUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804537; c=relaxed/simple;
	bh=CNLRRXAEnW/JowZaB9dPkXOsSETqiaaDYJmrWlr0aH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEVsIfA4ae4GvfE1EWZNvVZygQF6zgmi1A6JIlmShdNY6MUpRVPN/BHbk8/8QrU9up2DTYrdoP4wud6sdh9nTktKcUf5cYIslcAp9kqol6y8TrKK/zDrsCRx0CxemTJVbxMO57ciiFAJc3dbIRC83KdN9Q5rVbZYqDccNKdbpuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XTQMtm9e; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XTQMtm9e"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a77cc73d35fso586714966b.0
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804534; x=1721409334; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IZFL8y3BYWp+nTuY6qkieNI9HfQyambeOkiI5ShwR6I=;
        b=XTQMtm9eMP6hLyV5rg8q40QMxD2lGiKea+rlgxIhClXFksrR5DMTI5IghJuGSr/CtN
         1UoRlp2HOEtUNs2fFjk3KfbwfCNmSXCqj3coSTA8SDJCtZThmSRe+Cia5m6JuPBW08yU
         X+fQGT9azPXMnL4OMq2eWEJOzxQtxBJm9cx/KamEQ9Fiv3Lqwajb9XU4Wt9Z7RXerA3j
         52yrw0ZHX1iF+/7Sn7IOxF5+mahRokN47aqyujDm5PgNzKQ3NtW5xdfwy6ea1YAOIKcD
         WDVYcEZwkg5W3JiGggYPB3jeP31iTGAsdB/4C1/mhI2RnWzY3y4bZGIcF4oQbHyq8+tX
         o+Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804534; x=1721409334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IZFL8y3BYWp+nTuY6qkieNI9HfQyambeOkiI5ShwR6I=;
        b=XLbsV4Rp3Liv52jiTdeqUpJBwWhPaG/Dwfb+N4o7y/IHcAEVy9xasEaUMoc7q7fnkA
         iIQfg0NDWrtIUuPi+Vw65NGf4UzV62y4tcvzaTR4OfH2v6v5kjsNS/GHKgzzRKgYudHt
         3cf1deQ8WNCYM1to8CWep8/PagQ2Y+m9CaU0Imtcz30HSABL076doHmwVDnA/YfX712U
         OroBc2FLat5/YR6pyTxNml7MIT7N0pBWLv38tDwzPEM55cru+ECmPClyijva+dwZGfEI
         HPG+u/aPT83s90AKcsqXIx1cLUG1hWOlsK+iU/dSIoVLFPukljHQvS/QsEr7d6TlrjJt
         EWig==
X-Gm-Message-State: AOJu0YxYWSGenU1YxfOe5W4jOjiLDuC/hPJVlOAJMMHv3swWLhtwB6To
	knLKfqOle7D9UcLL/8om500a50PwqwCJR+2i3hfPztZjWDzUJpYZ+C1KvE+IDj+fQ9NgCW4Ovoi
	g
X-Google-Smtp-Source: AGHT+IEzQ9bimzGr4nz7SONzXubehSZu66EAlAm+Q0bODxW6jy5pHl5QvOHYIBv8MAOPcqOvXXiWoA==
X-Received: by 2002:a17:907:1c25:b0:a73:9037:fdf5 with SMTP id a640c23a62f3a-a799d301a04mr311949466b.6.1720804533969;
        Fri, 12 Jul 2024 10:15:33 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a86f604sm363811266b.207.2024.07.12.10.15.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:33 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 04/49] multipathd.service.in: use @BINDIR@ instead of /sbin
Date: Fri, 12 Jul 2024 19:14:12 +0200
Message-ID: <20240712171458.77611-5-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240712171458.77611-1-mwilck@suse.com>
References: <20240712171458.77611-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The path in the unit file should match the actual installation path.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/multipathd.service.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipathd/multipathd.service.in b/multipathd/multipathd.service.in
index a63ddd9..646001e 100644
--- a/multipathd/multipathd.service.in
+++ b/multipathd/multipathd.service.in
@@ -16,8 +16,8 @@ ConditionVirtualization=!container
 [Service]
 Type=notify
 NotifyAccess=main
-ExecStart=/sbin/multipathd -d -s
-ExecReload=/sbin/multipathd reconfigure
+ExecStart=@BINDIR@/multipathd -d -s
+ExecReload=@BINDIR@/multipathd reconfigure
 TasksMax=infinity
 LimitRTPRIO=10
 CPUWeight=1000
-- 
2.45.2


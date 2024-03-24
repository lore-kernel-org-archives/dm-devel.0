Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CFADDD2
	for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 21:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711314799; cv=none; b=EK4Qg9uDzt3VTI9huCBj3sPmOV05UvLEvaQrGehVt+vbU/P6xv2ePb/cIBN+Sp2jo4YcbYNYsl3rgaY3GUeiCcGEjgsFZtpf/Cs7C/3uioEtYtKI7gcVvJAwfnRXLyC4S2y/816vUxVMfUWh2OE34d2rG6qrW0yiNZhXMoSPJBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711314799; c=relaxed/simple;
	bh=GbInGcbEl2WjTsUuVYG3EHtADZEbN/x8V5FqMuayWuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Te4pdWiOAQ9FXAOcaahIUKrDDK48q0tSbJQsQLh7s7ur4x0C+tZXe1RlzzcziFh6mcClm/hSLbBpM7CLwbjtKdSNdBzjlne3b3LO7jFhpIX9pVcFuMr5jEUkISWKBaWWuZMMY/kbUougJZw7jkgpaTLypfi8ys2BAgf6VBMDpC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Sode4bMB; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Sode4bMB"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a466e53f8c0so494313266b.1
        for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 14:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711314795; x=1711919595; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SHqtB0Vhn3BLyWIFx5N2vw0XbOoC7SH5MZHYPTPYdDM=;
        b=Sode4bMBsexDeGFrsm0EmZYbz21HfmsY2B8aUGDEK5xjpcC4CVcFPqbrFy7af0yYZg
         oiRCsM747eZ6tMMvqtnAnaksIbACGsb1gWghNodtToe1XMHoBQexQzMojQ0y4gVVLxi8
         rjxA/jzkztK1h4VcapQRewbTnggDzkaeaneIp+aF0KsoawM29V4vZQx+P0uOEOk92Zqq
         3lvSn12rCdFASoc96qECLc0Jldv+561XnBISk15o4tfU23ypAm1R7Q43JwE49KNY8dW9
         KJHVXvK8wj/KyEcNp+pg7ZCHEtHgzxBMWir8sdfymB5fNUJWVAV0wX5fjWdVwU/8Ykvf
         Tnrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711314795; x=1711919595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SHqtB0Vhn3BLyWIFx5N2vw0XbOoC7SH5MZHYPTPYdDM=;
        b=rtajRq9tHcYxE0St+GhSMtTVdeC9GKDkl9osYTe6ufFpB2Z6Wz1LUaM+lgIbJy7H1O
         K626KFAekB1oGrdWQNwM5+myc+4db0L4QUpce5a9NqDn7V4KPZ56N4II5fjnoSXyP0ke
         MDgWhM6czt3t0RqD9ZuHXKb+3ApFXOPIEfysRQMCNFUuAAkcHwlUHzGMAkT3FprTspAO
         H2Wovqqd2duLMixUKIdJvdfh9JUxYBXB+NMOQWKxwJjHVIcTnlXGfDETC0dvkp9XwZKj
         5XV04xKhEsjPX/S3odbwQs/eqfJ/YKcHUgL3IYUlwCgBGmk7VzdtnUyayrMIkwEcjx/4
         4mdA==
X-Gm-Message-State: AOJu0Yx//DrRWGET7394+sfTdgD9YVdYVvMkkutom5erXbR6SvZ/Qs97
	OqCIVzQeFAfbJBoNUVyTdSVviLWRp7eBO+U7Bey+IOTwH1+z2oZKOrKPJ7p2rEg=
X-Google-Smtp-Source: AGHT+IG78x7Q8Q7OhlbLhUJc5lQz8PVssW7MOU1JTYMEMKBdIVuvyFXsGG24rydWD/XaXiFl3+fWOg==
X-Received: by 2002:a17:907:970f:b0:a47:4293:947f with SMTP id jg15-20020a170907970f00b00a474293947fmr3996613ejc.8.1711314795245;
        Sun, 24 Mar 2024 14:13:15 -0700 (PDT)
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id j24-20020a17090643d800b00a4672fb2a03sm2360935ejn.10.2024.03.24.14.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Mar 2024 14:13:15 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 01/11] 11-dm-mpath.rules: don't set MPATH_DEVICE_READY=0 for suspended devices
Date: Sun, 24 Mar 2024 22:12:51 +0100
Message-ID: <20240324211301.7200-2-mwilck@suse.com>
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

MPATH_DEVICE_READY is an internal property, not to be consumed by
later rules. It means that there are no usable paths. Being suspended
is a different, independent property of a map.

Don't set MPATH_DEVICE_READY=0 for suspended devices.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index d9585ab..3f23108 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -100,7 +100,7 @@ ENV{MPATH_DEVICE_READY}=="0", \
 # we have to postpone the activation until the next event.
 ENV{MPATH_DEVICE_READY}=="0", GOTO="dont_activate"
 ENV{.MPATH_DEVICE_READY_OLD}!="0", GOTO="dont_activate"
-ENV{DM_SUSPENDED}=="1", ENV{MPATH_DEVICE_READY}="0", GOTO="dont_activate"
+ENV{DM_SUSPENDED}=="1", GOTO="dont_activate"
 
 ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0"
 LABEL="dont_activate"
-- 
2.43.2


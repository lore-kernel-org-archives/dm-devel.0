Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760EA53E22
	for <dm-devel@lists.linux.dev>; Thu, 18 Jul 2024 19:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721330069; cv=none; b=omyN5vvJXKab3CPf3BUH66cr3HWxSNe5htDmMRAnvJg2n17q+QaZc0tBMtYGCyK+OQJR/P4cBvqJrH1KbNumFdvl9APmLTEyM4lc8bNxySBGp6LAsFemVy/O692+xLYKuXEGMHL+nhLnhANf91a8FDF64PXYdJCq7xe92BhSEck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721330069; c=relaxed/simple;
	bh=G7ysSdN4nbQM4/YGx4XqgeIVFmGfJW7kLbjDh4sffmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fg/YvP9gkB61zIN7Q0Bq+JUNkV8FgFM2epmd/M6dGqyjxjDN3ssyMr2ysLL1MesWi1hDhsaVhOnejfoq7R395IQ9L4TpHWlBtUFgvXW7C5VCsaSTzX7AMhOKVoo2PerT0cowqD8V/yTJJR3yu8rDFK7fXLhLYnrWHGnSSzCwPE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gJDaFU6K; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gJDaFU6K"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2eeb1051360so14137811fa.0
        for <dm-devel@lists.linux.dev>; Thu, 18 Jul 2024 12:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721330065; x=1721934865; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2BDoJEQcF+B94OM1h6B3wCPV/MSMOCb79YIwrru+A6s=;
        b=gJDaFU6KxmER3lOTpPT2fK9gK+/KUT1hz7V4athLIsX8C7KEpqQHzx1zhAtXP5h1Wq
         61japQpcaZEJDv5xcFBkHydjn/+aNHsu4VJ/KYg+LkX0G4ZszQ83qmz7nj/hzp+vvQLi
         6Hj5Ul/3okVJx5a8ZdMiA4Esfyly9DetFmDORsETNSO7E4KklIWkF5CB2qS7N28V0Wpb
         D41CFpOJ5TtvtnJq8dhiBIvCjj1UTjPOq/GmA7BENxjg/Cj2Ow4udT3zNmXm0bIvkJi7
         RJkfatsV3Z3nhIc8TX0LESd9Q0OVJkP0z5Ju8TrmlH2fvxsgU5h0aEkxEXM7b23m8sY8
         Pl7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721330065; x=1721934865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2BDoJEQcF+B94OM1h6B3wCPV/MSMOCb79YIwrru+A6s=;
        b=GMA+5eHS1z0uqwuoSxJpoMrnOXD2QOrMZr5IG0JGo8YGVTJNwBpLfYsW+RTjSosO55
         SIrIigdF4N9b5vbZeGzFKn/UEtUd+y07zaN4B+nTd3iQ/VwKFpd1/DFko6Olr9I6Ju+5
         dQPrvT5qDqGFBMZ70fTbmdazNfOvwU6v8oowoun8FoDorptTIjr/G3oJhLhffzw5ljnP
         l7gsER017R7QGb2Nsvbf4wJBYeDJ2ttvS3RHN+bCdxl+G3gM0tHaDom1YtChLWrUPd2G
         AHg52hKDZeWhgDDn7keB6Tsn3iFEGNVJSmBzRclPyRyMSMBCPSzgEVi+TpAkVwv5YCrG
         LI+Q==
X-Gm-Message-State: AOJu0Yydm4RAo1WbjKaT5V4LclpuBI/YByiNs/PHNhKbhBcHJeG1V8Kt
	p8j0lFzcnumySjebHme5LyIBR+MFxS2PQ2b0sFAuq4hgnVOLo2wxBzq38mGvphE=
X-Google-Smtp-Source: AGHT+IF+pGMaVrKnMPCNMcIF7nSu0saMUnvZ2ffMzGvU8XeLCaGJNph9aNY3I1uy4d8iwEdIjUTgTg==
X-Received: by 2002:a2e:914d:0:b0:2ee:4b17:dab9 with SMTP id 38308e7fff4ca-2ef05c4f868mr22392321fa.4.1721330065261;
        Thu, 18 Jul 2024 12:14:25 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5a2b73036f5sm209718a12.53.2024.07.18.12.14.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jul 2024 12:14:25 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 1/4] libmpathcmd: check len parameter in mpath_recv_reply_data()
Date: Thu, 18 Jul 2024 21:14:18 +0200
Message-ID: <20240718191421.110487-2-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240718191421.110487-1-mwilck@suse.com>
References: <20240718191421.110487-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Found by coverity. Callers check this parameter already, but
the function is exported by libmpathcmd, so make sure we don't
write '\0' to reply[-1].

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathcmd/mpath_cmd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index 60b2d96..d7c3371 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -170,6 +170,8 @@ int mpath_recv_reply_data(int fd, char *reply, size_t len,
 {
 	ssize_t ret;
 
+	if (len <= 0)
+		return 0;
 	ret = read_all(fd, reply, len, timeout);
 	if (ret < 0)
 		return ret;
-- 
2.45.2


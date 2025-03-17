Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DC328F3
	for <dm-devel@lists.linux.dev>; Mon, 17 Mar 2025 17:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742232838; cv=none; b=RFE8vYTLFA3OaGbSDymOjCPMHqxV0emygy9zr4agc5DbOTOcd9Rzy34qwN6NarZSKxyALVEMQa/cIBM52H9NkMnFMe4hvimVytORPxVxWMILkThTuF3AViTM0mtcw+CUISuB3ZtX5+61NkouXFvmi4bHU8In7Eo1vKOXhDlMlB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742232838; c=relaxed/simple;
	bh=NbKsy1WVZVfRlWXN3n0fevId8I9CyUqRuV68o+6AQMc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cejPQIVByX0M4SEZr9+tpQqOTetsPjBLnFSqeeD5H0KhHSDCr08D9UxvnpcI6Q2BXbRlCI2FFb76J2k4Ou6KS6SzwSGYVMD1ghKijcPYi6NjH+l7B1axwlddgy3KtkdRS/586jZi8TE+up8f3dDq17R+nxZfnxCFPmKa4kG+Ihs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k1gVYnKm; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k1gVYnKm"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3912b75c0f2so584392f8f.0
        for <dm-devel@lists.linux.dev>; Mon, 17 Mar 2025 10:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742232835; x=1742837635; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bIP32nINp07O4kkVp+QL3fGnIMJ5F0RleSoKCbs+Sj0=;
        b=k1gVYnKmez67iq1keMWYCE962d4L73ny/rkC8QlVhqKLWSMZ7YyecGOj++lnaUIAyF
         EVYlMSDhazVaj59FrzIyu/MgqvTWEOaFYUviQdwayYAVDSTYvmR6XVn4mGwS1u4xr545
         j1J9WaX8VV8q8L/Uum17t1gCGMdGjXvQRWA9LYXfyT3hrb3yRvDNlwoTZ3ZSzSZ2L4pL
         phEzP0WYQKHWmmJobWFaHQ/pRAdZuXeoUZq/I7+jXdmkrztEDvc29zxEfd5prwCT7XnN
         BJPGUgXIr31kQIPqvu8RfX0IMAJ3bpGe/eGVTGWq/Ry4rPmR4tu+ePf/Idhwl7Xg8qUy
         z8mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742232835; x=1742837635;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bIP32nINp07O4kkVp+QL3fGnIMJ5F0RleSoKCbs+Sj0=;
        b=IBjsTOMCDuKCDTsTWMw9lfVDkfyu4n/U3MZgL0T7CwDfjkHQm6/CEbAo/2Cg0R2Tgm
         GihM1DHD1RGkCnVMynyESiOE1DzLHKXkUatFrRhwvBAvoB6y9UuUWIUoYyU8ne0euOYM
         feley1CwukazPdU8o+Dr7Puvfkgn/qWBPDhbkKVInQDnUagKNgunl4qwyPwb00Zekt1n
         vWzMbyAxM6akiPE574cED2sp9/g01JAoPH2J1LHgUAWY/p7FIzPYoWBtumeeyzjommfO
         5r2A6ksKHH1aXOCRzWcdwMOUaFWNhpll3sI9E178br9c6zquslB/qzoCIYjkXNnXhJON
         02Yg==
X-Forwarded-Encrypted: i=1; AJvYcCVP9S/JXozv6s89kRAsyo6zpl+yPLQpCaV4LdAkEdIP4uEI4TaVryVhCqNlkPv2lQcYgo2yC2HvoQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5CR0vEoenIwhJi4ihacJz2+/SxkS24kNycFO0D8uA7Hey/v0L
	lG/u5xarNNYFIeUUy0JuK2jfWRs84rUcHM37u73f04ZbgKYsPjM=
X-Gm-Gg: ASbGnct+4+GulpKeMeC1OcZWtljMOC6t23ldfqXkFHqPgpI68HFMcd8lOHJDr2guEE1
	EXYSBnVCXJXc1co7HTXOuSXCgIWwSK1TuLjJ0qB90w2k9TMirfQz2zfdOKjuMUMlbPJpuTOx9CW
	YMxd7YeKql0IuQvgPQiLQ4GSN16M8f+yj4Tcp/tXvCyWnh+rDgUZv3WsyXHOIwyjEQTCZmnqpRE
	aNt/6tdor3/qzvl5jX4tBMQwY1pUCTzLyPgCvmP7AHe/PBq0BBn5hg5px9P8Pcfh0mT4dDLLQ+N
	n7iiJIg6NU3X4lq+FaLzRffUtfFE71hmdErXqxvCGeTPj8nB2J+C/TtWR1OVm/Ag3IV6Okt5QQ7
	Iwp2eIHrk+k7VLCBZZs40
X-Google-Smtp-Source: AGHT+IH1q1QyAiiNMhkDZZCLARFLwVcCKg7EoULqcp2pXInqn1Q/Vl8ly80Dq7lAWjQyCa+0y89TWA==
X-Received: by 2002:a5d:6dac:0:b0:391:c42:dae with SMTP id ffacd0b85a97d-3971d8fa89emr5913432f8f.4.1742232834593;
        Mon, 17 Mar 2025 10:33:54 -0700 (PDT)
Received: from localhost (191.red-88-28-10.dynamicip.rima-tde.net. [88.28.10.191])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c83b6b37sm15843254f8f.37.2025.03.17.10.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 10:33:54 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH RFC] multipath-tools: add Generic SCSI in hwtable
Date: Mon, 17 Mar 2025 18:33:51 +0100
Message-ID: <20250317173352.14387-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index f8cf3fa9..34b1fd2f 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -79,6 +79,17 @@
 #endif
 
 static struct hwentry default_hw[] = {
+	/*
+	 * Generic SCSI devices
+	 */
+	{
+		/* Generic SCSI */
+		.vendor        = ".*",
+		.product       = ".*",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.no_path_retry = 30,
+	},
 	/*
 	 * Generic NVMe devices
 	 *
-- 
2.48.1


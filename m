Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F7D268C6B
	for <dm-devel@lists.linux.dev>; Mon,  5 May 2025 16:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746462634; cv=none; b=Imw14WDjdxwDZaGWnEG2CJe6XCIL78pIlIyfjHnfaeeyJsSNASUgXoU9Eugs62Ts2I0POCUiTw6C5ZaZLgyPROTuQVPRLs6Gtfp8uKSy9v1Vxv6zCNzW9XqQPIvxvsWEJ0Jl28vHZwm3bIlrzKJtYK6hFnc6kfwLVOfVAIKaXjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746462634; c=relaxed/simple;
	bh=hYkLtnozaxzC2sVqeH/UJc9v3Iic3nve4jygY6j0zqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMBSzoEZNDKDziP3WYAwhzEQPJU0762Y7fwoHyGhahugmLLQeJzkL14Sc+i6699uNKPAKxjV3lq+fQqSEh7quCBdI2JTWX4gFEgYy7bSdoUyer8tJ23qPpUFMoPOpm1rHo7OobFr6QgPGoS/hnVqYAm9VUimcXm5rLrrFOqI9yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=a0oP7FmP; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="a0oP7FmP"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-39c1efbefc6so3441610f8f.1
        for <dm-devel@lists.linux.dev>; Mon, 05 May 2025 09:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746462631; x=1747067431; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c0anoguhm3eXPx9u+OLmVnP6Hb1kkkeNREkfOexoCgk=;
        b=a0oP7FmPpCo/KOHZywMlsrgt7wv2qNbLJM8sa//U75WyRqOxTDH/SaERldrre0nvcO
         EmwJ7gPRumUuUz3NYbLMxPwektPsnkGpwmnLM8L+b833rlCN4F9lysaQrTM17uWBuTdp
         xcPvfeO+6PaIDUfr4mKD0rYGwAeN+LLqLh6ZYFIOPPYi1Lh/GAHuc5wA8tMln4nNU3Vt
         Dgh2HBMU0nvYcRp6QINOCaf+yMFSnnktDptPdGtL1iKQCBbdw2lr1xmZuEPocL0Qvqse
         qX0aRIAmWRz72rKVm/Z2LBy7BOO/fU2GXgmeZsMtmcloaQuvyi4irAx8Ba/mISU3Nxcc
         9Jyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746462631; x=1747067431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c0anoguhm3eXPx9u+OLmVnP6Hb1kkkeNREkfOexoCgk=;
        b=Qp1RldXRG7bpu+BpYEsoZXa99LPrx0M1glVvtJssKL/iNjLlRnH4TKCwd4uQfk/9Bj
         6UVfu/Aw36IjssyXPUenXxalkzNhIumJi7Nc5NG7Z9j2NbDXzGZU6IkbcHCWmfar1Xrh
         vfRB6cVXuoiPizmOMxy8ToWUUpHQwvcxYl/JblQgSSyScMU3stiuCh06PUVFsSJWKtDC
         iyJ8R51vGOC8NuBbZAbXNM7NXL4Eb16Ar+BGl9QbF0peLA7CtTdAWKPK1sZBnqkmyH7F
         8abl/pOlTTE35AymySk2FQy9YJ63Im3d+AXTeJ9NiBjWP/sTV0CyOYZC6+eI6q6JfKqe
         RSnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQlKrFmMd+eI83auFSO4Hl0svZVghvVj+51B8g8HFhNYWTq646IIrLJkkVWdbLXcJhwyYmYESl+Q==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9DaHcNNqR+qwGPPMXxwGqrSBnnPWVgssxobRJd/mWRlNzTnNu
	NfQJZ4yMcmewnQZ+LuXpnvlmNwdB2vFBUUV+XawtZQHTO/T2uxGMGot9Hz9SYQ/14CQQNs4FCPA
	a
X-Gm-Gg: ASbGncu3YnmLdXfFRGQlPq2LOkg+4K9ydVA5m0zH/oTGrq/NM4o+T/yzXO6LS/FtSqI
	YeWeI5QMxVLGOydKrDlTb6Q8UiWGwMkq9SKs+h0G83160BGgynw9kBOYNqNVx9+7M52nnXNeQG3
	IbqEoFdKJp1YyvHmI7CD0fdqNxVBG/qIPld/CNbNMlmw71niLHhMKDSUObMlSMee87y2hAyrazc
	1HFURE7pgXRNS3LdH+8tHIqd1zGYsb1QzJiTEcayVCACrTXiAFZyy12AFeaJJFiLNtCLzzGxSy0
	i3Y8xhISP6AUDbpo/yE2crMzU9YcsLKwbzFaA6MFfpEb+b+FZ9q4XeGfYGZ/s6kv/rZu26Rrxnp
	O8Wob5gaPmZSgxMIRPRnDrUkg5mWP
X-Google-Smtp-Source: AGHT+IGee2/jLE+B+2KSHd0VdaHvjBe0gbBDPlrQM9S+d1IF0odVXwNf+/rb+usMDNrnuczgJpVkJg==
X-Received: by 2002:a5d:588d:0:b0:3a0:90bf:b9b with SMTP id ffacd0b85a97d-3a09cea72e3mr6562918f8f.8.1746462631001;
        Mon, 05 May 2025 09:30:31 -0700 (PDT)
Received: from localhost (p200300de3740fd00677a2a06a3663993.dip0.t-ipconnect.de. [2003:de:3740:fd00:677a:2a06:a366:3993])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a099ae7a35sm10674824f8f.43.2025.05.05.09.30.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 09:30:30 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH 5/6] libmultipath: fix undefined behavior in 31-bit shift
Date: Mon,  5 May 2025 18:29:57 +0200
Message-ID: <20250505163007.59352-6-mwilck@suse.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250505163007.59352-1-mwilck@suse.com>
References: <20250505163007.59352-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Error: CPPCHECK_WARNING (CWE-758): [#def61]
multipath-tools-0.11.1/libmultipath/nvme-ioctl.c:572:
error[shiftTooManyBitsSigned]: Shifting signed 32-bit value by 31 bits
is undefined behaviour

Found by Fedora's static analysis [1].

[1] https://openscanhub.fedoraproject.org/task/51915/log/device-mapper-multipath-0.11.1-1.fc43/scan-results.html

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/nvme/nvme-ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/nvme/nvme-ioctl.c b/libmultipath/nvme/nvme-ioctl.c
index 6959976..445ae2b 100644
--- a/libmultipath/nvme/nvme-ioctl.c
+++ b/libmultipath/nvme/nvme-ioctl.c
@@ -569,7 +569,7 @@ int nvme_feature(int fd, __u8 opcode, __u32 nsid, __u32 cdw10, __u32 cdw11,
 int nvme_set_feature(int fd, __u32 nsid, __u8 fid, __u32 value, __u32 cdw12,
 		     bool save, __u32 data_len, void *data, __u32 *result)
 {
-	__u32 cdw10 = fid | (save ? 1 << 31 : 0);
+	__u32 cdw10 = fid | (save ? 1U << 31 : 0);
 
 	return nvme_feature(fd, nvme_admin_set_features, nsid, cdw10, value,
 			    cdw12, data_len, data, result);
-- 
2.49.0


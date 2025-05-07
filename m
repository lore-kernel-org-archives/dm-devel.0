Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B06828E572
	for <dm-devel@lists.linux.dev>; Wed,  7 May 2025 19:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644785; cv=none; b=oO1p7OmGCnh4P2PpnwRCKrrCKE/JJuzf2YdFAT9trkJc6VyEB1qLatK4lqh77mp48615NsdRt3i8OeQgiu5h9OJN8Y0Nh+oKDHgijHjp2hrC0Qe3WWv/ReUUcGlVsGAGD1ZperDXaFCL28ou80TQGf6Uv5pbO9AykvrD9HnI36U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644785; c=relaxed/simple;
	bh=j+HaxdDu62ao6m8YwtO5YB/am3GCvHXXla8Z5dgpgeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSnpjIEFnJYtNWwu51ZQCCHcNZlFDFIE0F0hu9PVPLf6ZbnyyNbX0oS+RNR7iZIFxTkd+/RwtRq31NjUDFe0aeeF/kpZO/GTQ7yY97uVQYlgt686F7L8vcTsSOD6zPGdmmSDF9E68VNJPu7xMXpliwtTQUZVQ8vG4R3TeW80RtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gPWPXrbB; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gPWPXrbB"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-39ee57c0b8cso197819f8f.0
        for <dm-devel@lists.linux.dev>; Wed, 07 May 2025 12:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746644782; x=1747249582; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BpMdiffNLkX1dWTLpHaNJ5fKATrGOYiBLtKG6UpdpwM=;
        b=gPWPXrbBWsH5Xkvk8LLO52afY0sZ6woGc6YDYVkSbu0zwoOobIfYQNTvtd7kMHFoTy
         Yn+hyLlJPadNFrJsfkbceG1mTSkEUbJX1raf3d5b5ecqs9fV3SYym7zxNAD0sVMKz/RS
         7cIB3cu5l6RglrfhUrtjPtzxuELhS5+vOVa5Is4vWCZUbb9uqlH4LkXTLpO32BmPEZNj
         5WY6ZcCstzVTVwgMndomn5D8NGNWv+NSC55cznu3zBabNdFcMvARLoSfwNeW8CBKmNmq
         tpEhLkm/g9GEHILforzRKhv/wcvn5HtYlvIBinXA6g6TamjJE5IUqA1I3LjUDWVNsJLw
         SVqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746644782; x=1747249582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BpMdiffNLkX1dWTLpHaNJ5fKATrGOYiBLtKG6UpdpwM=;
        b=oVtHyw9qGv81pOA3ZPtY92/tm2dSktZDn0tceq/TpJwA8MRfBxPYW3/4sdVY4HMnDE
         7Rb6436tznNQiGJdLJIjeX5dcvp2zHiz7BevRUwQS0rlIvpdo1zg1iH5aG8OuOAM3g5J
         F42Vzijv0qNKNpP4FkBfbeQviYBlidxzGt0jCp5OdvfXUSSFxkNu063/l+NLn82Ai+3p
         6N8u98LKXbytGRpnwTvPwSkFuk3OdocvZrv4ES0QpXviYPReboa5Abgd2GeaolFYDar3
         DFfo+O4Jg3He2I0iRYNtX25tA5ISd78lTAB0rQZ/VE7hl3a46Es2BTfbFwQH7740XaCJ
         U1RA==
X-Forwarded-Encrypted: i=1; AJvYcCWy5b06CL1/15pEKLrp9qNV6GEQvivNnv5giRO2ia+P9mOZIRM23dyze3cJlzKhkvZffboNYht0UQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw4WFQgyGk3aZpz0lETlqmBoEx/vIFiDD14i3UrHVcQ1dtWMoy2
	Jo0JlqjdaN4yPwChaJU3mdgAwnVvHmgB3DKEnzXpqwPTiGX7G37nQw7XTHAvxu4=
X-Gm-Gg: ASbGncs1P1k2lZJ/c3ox+8MBfqho/2GuC7WxuXT8QSLyjrrdF7oJsLtbMQT4dAsU8Xf
	vY3iPzSZUWnN8tHJIDCCEm7XDbCM242O1jH/rfP2q73ki6FZbSPHoSJaSMkeoyd2Wz0asLAlRI4
	ngMOyFePDXRhr9rTH8+Z7X0tJ8J72/BFbJH2PlFTAiOZAsu2m23is9RXLBUU9soV9ZlR4Jiy5j3
	R4jwGsHw6xcpM9aghNlJc6dZ3x4FnOUdvFQuyDoOG2kctNExtBPLV8Yw0ce9J880yLeAOD9VyiG
	nDnJCSUfARti7rXz5OGNNxC0RedcJNmSr/a7yKvRoEPWMb+q11BemEpQ3WtwSjchb4+fxB92sK7
	mVH5M3U/YJmGHxPxVXXFZKUZKXmzh
X-Google-Smtp-Source: AGHT+IGeHaYF6ZXJnNl7NX5aSYda2CqBimGJEoWa2dqykmpqWSMivJd3dZfGbetfBJ1W2fCU7oYLoQ==
X-Received: by 2002:a05:6000:2410:b0:3a0:b37f:c97e with SMTP id ffacd0b85a97d-3a0ba0952c1mr248817f8f.4.1746644781687;
        Wed, 07 May 2025 12:06:21 -0700 (PDT)
Received: from localhost (p200300de3740fd00677a2a06a3663993.dip0.t-ipconnect.de. [2003:de:3740:fd00:677a:2a06:a366:3993])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a0b348419dsm4262225f8f.23.2025.05.07.12.06.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 12:06:21 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v2 5/8] libmultipath: fix undefined behavior in 31-bit shift
Date: Wed,  7 May 2025 21:05:49 +0200
Message-ID: <20250507190552.209637-6-mwilck@suse.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507190552.209637-1-mwilck@suse.com>
References: <20250507190552.209637-1-mwilck@suse.com>
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

[1] https://openscanhub.fedoraproject.org/task/51915/log/device-mapper-multipath-0.11.1-1.fc43/scan-results.html#def61

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
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


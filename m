Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FDD28751B
	for <dm-devel@lists.linux.dev>; Fri,  9 Jan 2026 18:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767983980; cv=none; b=CMy5D6gLJghCeD9soByWBz2nGo0f1CUOS7KovqwDHNBD3TKWZAE5Z/VjQ1o8GcdVKAc7dHO5RGAfCDtHGS5FbKUnhLrYvTP5KH9VqxYGN67lKCwwNnanHAaPNnmN3qTDlAk4O+eEnDLqn82LYW7ckdX7TgjK43iUOFd9Wfxz5Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767983980; c=relaxed/simple;
	bh=UTVW0X7Qetzf8Qy2RTGo8lyqAwyC9tb84UpfD6UUvok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWbk6uw90phYIkTquRBUyGdDTgLl/JAbzAeEAV5R0ju6tk3qBBl5YcMW0mDWhhiSKTpUUUzcCVZtsaa4rMESPs2QJLrIupU5yi4IGt9LZ6KtdunBNIdTqrt/5+TQ8wB/e85i5yBwzrKaNS8rxt7vWFELr0ivGP+ndZFQ4FnKHBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XBdp/kU9; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XBdp/kU9"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47bdbc90dcaso33544405e9.1
        for <dm-devel@lists.linux.dev>; Fri, 09 Jan 2026 10:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767983975; x=1768588775; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JSsDZMCM9ntTiwmAoOis6UC3qAQeS5Z1Z1VvIc54GDI=;
        b=XBdp/kU90wPwIF+39WeHKdpaEBGLL8L4756UOpUUU8XyAv0fj73OpQV9ZpcGYrILp3
         2NzO38jG+GnKs/m5ZxYmJ1rueQqCB3kFOlpR/6xe6U15cdBZfCQduNfroMQFeNVaYJSe
         J2/HlJgTeYjqkeNhOi6Gtj+XW+gpQWVQMa/nHCGUmLDDuD59GGFBqCC5PQFHaAlDSbGS
         y8EfifHBH99BfpK4JXHH/YYdvbwVaVUSxBKmGPzhcsE9JH1PPuOpkK7xeUvvG6HhOVfl
         b6ApH95ZSVS9C5rTtIHvJxf2HepMni/0osWKwSNwloWJDn9hmceL+SqoaUGu4PRBYYIz
         tSgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767983975; x=1768588775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JSsDZMCM9ntTiwmAoOis6UC3qAQeS5Z1Z1VvIc54GDI=;
        b=DFzzoxsem6M3hh01RptK3Ku5g3nbYSfqvfKC5IXcelgKxUpkMgkye8Wbj9X1gqDQrF
         OVPFRTBrqJotURtXzlgBjp4vC0tbbEn3RIRX8EKUMbDETdXkCEvhFvUXSqTLEtTN42nX
         hETKa9TaRZam2FiWt4NPvhVwu1NvgjhognikmRHg2Z1TpRP2XD/XoyKSUdPCrXy7PVgt
         0ImPEAs0x7LdF477vUwOLSuF9FTisIK+svO6tFUnF/rgdFr6dnWXp+EEkX9e4EEUvgp9
         ixiNKB5R2HOD+g2QYV9jftfREleuyL3fZQujEXBjj5SJSqk2LZNDxcQwo11i/6uhI2q1
         XSjA==
X-Forwarded-Encrypted: i=1; AJvYcCXrD6bsWJcsnbDytC9sv2F1S+xXhZUVkLJORglSysTSNM+XLkqNohy0/xrV9A6tKdjl7JR67t/dSA==@lists.linux.dev
X-Gm-Message-State: AOJu0YydbYyxlS3k5saELkPNpK8iixks7B0EzlKywjzi7xw3dzmpJsLz
	yGPLcOx4YHz8lYoi46gfc2UVCI+VLuDrTEDqhkOYhvfqqo7l/Tz3JlztxnkztJJx4RaFXy3WLsI
	W0b36
X-Gm-Gg: AY/fxX70a3faDgdwfQYg/p+XMAnjb894bP85PW4oMvRqngk6bPrKmhn4qksPrCYNnnu
	fNU78DUotCv9bJ8pub3Sy2/uqzwjELaZ812Trb63DwP6ImZn7LaQ/X5R3ySwJDF6tZFkpOKN54L
	qo0iMjBVsSDhxpsr5B3gcuuOdrlJJhLTUbnvoGspRiPK1L8GXgOo9fh2mcX7/MBvS22leIlr1hA
	2m8Rrc7kb/Pw1YBXE7V03Z5Uctu1XYYm9A3lfMu9+PYCPGiIZ+dGY2odt0EeYm0vO/XiDtqOLQE
	aWcWQUAG5rZB12TbAYfYiDwVCN0X32QrZl4+YEKOiTcfPcpwz4KuOqJmU1d33TyiWJgjPAJP/fi
	+PWxc+z0LE1tgtufx5pN0YwtAvB/29R+goxOjMfS7SpgBrGHHJNH/MCMNB5u43NP79xnglPAkwE
	nm9/tNx40tZX3rxz8ed/8aB6hV2Dl1izGe/0CjlCpKr91R7z2rbAf9cxLZG9NexNCmYn//txdGc
	Q==
X-Google-Smtp-Source: AGHT+IEeQRX+Ypg33fODG5VN86HUxhUJCF831q2zUp92cMzYKKlexVfERxw/nCNquNx1IYSmGFFajA==
X-Received: by 2002:a05:600c:a08:b0:479:3a86:dc1f with SMTP id 5b1f17b1804b1-47d84b41012mr105736095e9.37.1767983975059;
        Fri, 09 Jan 2026 10:39:35 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-432bd0dade5sm24197720f8f.9.2026.01.09.10.39.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 10:39:34 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH 7/9] libmultipath: warn only once in scsi_tmo_error_msg()
Date: Fri,  9 Jan 2026 19:39:05 +0100
Message-ID: <20260109183907.201250-8-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109183907.201250-1-mwilck@suse.com>
References: <20260109183907.201250-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The intention of this code was to warn only once for each unsupported
protocol. But the condition statement is missing.

Fixes: 6ad77db ("libmultipath: Set the scsi timeout parameters by path")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 9d0f6d9..f8b514b 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -888,6 +888,9 @@ scsi_tmo_error_msg(struct path *pp)
 
 	/* make sure the bitfield is large enough */
 	BUILD_BUG_ON((LAST_BUS_PROTOCOL_ID + 1) > bits_per_slot);
+
+	if (is_bit_set_in_bitfield(proto_id, bf))
+		return;
 	snprint_path_protocol(&proto_buf, pp);
 	condlog(2, "%s: setting scsi timeouts is unsupported for protocol %s",
 		pp->dev, get_strbuf_str(&proto_buf));
-- 
2.52.0


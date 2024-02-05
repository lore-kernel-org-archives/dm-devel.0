Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B7D28E0D
	for <dm-devel@lists.linux.dev>; Mon,  5 Feb 2024 12:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707137216; cv=none; b=GbLL/hk/ciJRFKzv9OD0J28yZISJcrjtVlnjvMb1eR7hKXvxNextt0YC0g2rJRERXognpKY2k3eaLRuuWlAtJuRmw5s22W28KhBIIEEYEYrIq5t70PCxELzdMZCyddDiUIeNYd3mPKLHTSqOjkfTGZdEgDoqw1it1ZolkqHS89A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707137216; c=relaxed/simple;
	bh=uCHwYtcqJvKd0vl1r4shZl0zfIqS2AF7bW4iDLZRD6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QIGmJBU+KdLEjpkB2e6f9NwgKZHfRZIfnG1EjG6RZfGUlrSAr3cuIHScIgqJPrngZHqszWbXnP9XFvWZqbPTQlEMP50RHKnoF10FaDlNP16e9jvphDZYNlk30DgrTFFi5S+7P6KIM4nR+ck+cSp1Nj/ICiJTjW/0igT0lb9ujhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Xsbbi34h; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Xsbbi34h"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-40f02b8d176so38222775e9.1
        for <dm-devel@lists.linux.dev>; Mon, 05 Feb 2024 04:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707137213; x=1707742013; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TS6RPL1ziCGOnuiUbiIHJtHOa3zWHBq75Wkktv9HZ/k=;
        b=Xsbbi34hTFx1HO/gQ1Xc2FgxvLPXzZ4m6Gz9jC4/vxF8G7THmVcreLM86v+IrR6U+t
         Vesy+VjDI+FM3J3tNnTjdox7T0XTQi8AxkRioNC2NrqJ/6LifqbavkbncRFEO6pUPkGZ
         jx/XoiIex7zdKZCfImocGD9H0xlkZhdMYGt3N19AlUaO+0pIxTtRrWcKmcAOL5x9hPfX
         91m8mxCz5gdGfSwV395i3CYOOlOMDNcpP+osBdTugNrKp3omzdraON4uKmBEPSdee2D/
         jo92qZyZLHtWpRn3xA9HSr49purcpATp/FH3fAvTYV8PVNHB2m0nX8HzQJZ/q91kdwqY
         vDKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707137213; x=1707742013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TS6RPL1ziCGOnuiUbiIHJtHOa3zWHBq75Wkktv9HZ/k=;
        b=mMSNy3ahqyTKaG8Nv86M1ftF2CtiZ3zUYh/C1BacMKjhOwVlE/cA6do1aUjgKUfnN6
         M8adLob9wYlRCtTwrt+EMT8MYCIOywOpHFyZTLz15UuY6Cqwbh2useXCeUBKTHEKIUnd
         niF9wMnt7eQ4YZrbyGbD2EaCkNXsiA8Sa4gjLFRrEeREa96uvS7Wo0m82SV1q+UfErMP
         p0kmajcIDLKT/E0gqoBMIZSSJIT4cs1B9T4PdQzm8QUVIMP/R3zDc77ldul53pDehf3D
         glp+C3m+8mkbLJSfb5Es6uG0bHxfSJpxY6xRkX0Q0maZuD7Pvcg7JvFBe5koBoc5bAaz
         DtQw==
X-Gm-Message-State: AOJu0YzW3AegYKPVr+bD9mEa3sjCnEm4dvGr8xFrn9f2SzSE4GLUDEFX
	x2voi2q/s1AiGZgZ0egE2dGW1d59+n/V9gDCZ0QFw3+AT3Glg+COvWLH+3WfHas=
X-Google-Smtp-Source: AGHT+IEyBSh7/mcrMvtcAFb0iUUFQNfJAkDR9dHyjEisZ8h4ikt+VTBryf7aHog49AftJP4To04maA==
X-Received: by 2002:a05:600c:35c7:b0:40e:fc29:f527 with SMTP id r7-20020a05600c35c700b0040efc29f527mr4912104wmq.31.1707137212820;
        Mon, 05 Feb 2024 04:46:52 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCU+aDRcP0sy2EzKUgYgs8p4qL9EBmvPfsvTEu9dU5B4U0saWyjDNZ8BBGCGG6nsSTX2ekSEai6txJxm5lTsvfxNYZvC29D/8pOWxEhSI98RcKEMrCoyd4zHZWEowlX3Toxg+v06H8mqi5dUq5w5RqBePL7U/A9UVbmpRjb1ZSIOBwTUXBk/nZgENA2mjXQJTeDbbTp450fBTBOp2PSNndOhMsHiUDGHbFxhnAzg5RwjMA==
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id fm16-20020a05600c0c1000b0040ef67bd244sm8571313wmb.17.2024.02.05.04.46.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Feb 2024 04:46:52 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-lvm@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>,
	Sergio Durigan Junior <sergiodj@sergiodj.net>,
	Chris Hofstaedtler <zeha@debian.org>
Subject: [PATCH 6/6] multipathd: don't activate socket activation by default
Date: Mon,  5 Feb 2024 13:46:38 +0100
Message-ID: <20240205124638.17877-7-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240205124638.17877-1-mwilck@suse.com>
References: <20240205124638.17877-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Socket activation will start multipathd on systems that don't have multipath
hardware. This is often not desired.  On systems that do have multipath
hardware, OTOH, it is highly recommended to enable multipathd.service directly
rather than have it started via socket activation.  Therefore don't activate
the socket by default.  multipathd still supports socket activation, so users
who find it useful can disable multipathd.service and activate the socket.

Fixes: https://github.com/opensvc/multipath-tools/issues/76
Signed-off-by: Martin Wilck <mwilck@suse.com>
Cc: Sergio Durigan Junior <sergiodj@sergiodj.net>
Cc: Chris Hofstaedtler <zeha@debian.org>
---
 multipathd/multipathd.socket | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/multipathd/multipathd.socket b/multipathd/multipathd.socket
index c777e5e..6a62f5f 100644
--- a/multipathd/multipathd.socket
+++ b/multipathd/multipathd.socket
@@ -10,4 +10,6 @@ Before=sockets.target
 ListenStream=@/org/kernel/linux/storage/multipathd
 
 [Install]
-WantedBy=sockets.target
+# Socket activation for multipathd is disabled by default.
+# Activate it here if you find it useful.
+# WantedBy=sockets.target
-- 
2.43.0


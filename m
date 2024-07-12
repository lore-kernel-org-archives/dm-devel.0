Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F73176FA3
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804543; cv=none; b=M78dBuTVw9lVNJqTF0tdmHx1sRaEi3LuIXqszWNvRmD4+NwDYL6Cobk1Jr2lJNYzjMGyiPEAiZXWFEVptSZRPvXcFYCcvYaqm39wkAIuCIx7ZPAcpOX0aYwa7edTpGfsczHOL7aqphUbQZInET1uUiiYkakq4iIVs7yWXIHAUvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804543; c=relaxed/simple;
	bh=DkpK5sEthTCt+y/GnS6D/M8eXItVAmzk+mJz+pD03Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sceLrb/slMpTGnlIrg/oyXwcvuFZ66R+8B9SIqIUp/rx5OcMxPSYjT6gD2YsB9AmQOdK5untu+aC98iOFNB9E6aXMnL7Al3+Gj8YLTSfmgoSX8U2vJMBSu1IRGJRJvQQ8u5IsiD69JaZy0dv+dljagsDN7m/I+65IXVIrFWVzjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DBoGr1Aj; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DBoGr1Aj"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a77c1658c68so279267066b.0
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804540; x=1721409340; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2vPyUeFhrVt6vMKZJgkpTDZ38Ys1EHTjBOKpBEKY4tU=;
        b=DBoGr1AjLIckZnuC6e4mmyqiz9FS/QJmVwnQeLh9cxVBY03O8wZPQIGvRiv1JpGPiK
         s1OumeWc3L8MtDU2q2ZIqgoFEX9evKFUHN+c6vK2FtQuFflib3JDZvPjRKz+HJ2/n4gw
         6iJw1/fUhm3junXSm2qhllndtmVyzm3hW3EKe2wq/poFGkgdUApu0h8Bt0oAJWC8FeCV
         CMLeKxt+fAvIJNcAa/ZjuZlydoKQazb3CqOzVadwxuu7RuKjF2ulVVTQDN5+iIHoIUcp
         0Ow8zScdhhm65z616wKJbnG47K6lvxwdoknbLr2Z566P/9WYa70/D+EBa9ma8jk6Y1Fd
         7VGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804540; x=1721409340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2vPyUeFhrVt6vMKZJgkpTDZ38Ys1EHTjBOKpBEKY4tU=;
        b=HjiSnol1dm9mYRu7COOaBYvVBWIfJPNQAvhyNgxc+bmyjRuar2iWyKyoncsI9TA4v1
         gqvZGS8yJYIn7ppiFF6tkxwhIgByflxCswhMY6dbALndwA+8V8xyAjW1ZUscpfCRVluO
         Jr8mWLCvJw2FVUFEfT3YrOhSggeuOjnvDJaZxUlNqlwH1ZzOSuwku6XWH7s6N1V+qYOj
         5l2u6X1ltT1k04slww1Xb/8bNpV/hv8stS8ifbTyYuVYwOqJRevo+jGVbGRm4oymcYhF
         X67TJ5X3zmnIUnuEL5eqomquNMCqPz+AHNGdpcJFk0pZ2nbwDpdeDXnFJhBDnrktkufr
         yi5A==
X-Gm-Message-State: AOJu0YxloYB8/Svu3Dq2oRaJMHmbiINqcZclX/pWQGDYv3mMtQVhYytO
	GoObFkKFKns06vi7UoX+jkE3Ce4RFfDtxP9HoTi+mbY1/mDAEK3E9z5ax+HjLum7PIxRZluX/9c
	n
X-Google-Smtp-Source: AGHT+IEyWWhmVtSZkpRtcusyklFTrnMNkltXi5Ogv71F2wylZNYBGBVfMu6mvoEjdl3u3XfLdrdhVw==
X-Received: by 2002:a17:906:5650:b0:a72:8d2f:8594 with SMTP id a640c23a62f3a-a780b6b2f20mr773913066b.27.1720804540056;
        Fri, 12 Jul 2024 10:15:40 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a855e24sm369204166b.177.2024.07.12.10.15.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:39 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 10/49] libmultipath: remove unused includes in devmapper.h
Date: Fri, 12 Jul 2024 19:14:18 +0200
Message-ID: <20240712171458.77611-11-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 08bb3c5..3ee8555 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -17,13 +17,11 @@
 #include <linux/dm-ioctl.h>
 
 #include "util.h"
-#include "checkers.h"
 #include "vector.h"
 #include "structs.h"
 #include "debug.h"
 #include "devmapper.h"
 #include "sysfs.h"
-#include "config.h"
 #include "wwids.h"
 #include "version.h"
 #include "time-util.h"
-- 
2.45.2


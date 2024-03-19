Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBEF2C6A9
	for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 18:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710872330; cv=none; b=Z1uZ3zT67y9qC4H1x2Uu3BAXmp6Kud31ZeChMhjSONNDyiX012Q0cPtPlHxQYBtDl79iNtNn473hd5yYRGmYuDoV5Zq7myoPjDz0RCbHYMdQom0ZQtux1wG9f/prmWZ1oILXa06UJv2zMEMbDW13+9ae2iC0N+/QgJLMNfchnwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710872330; c=relaxed/simple;
	bh=hSQlxmu0JQGOLCccDVMeGRvCXoBcKwvCRhFdCa7EKfQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aIjAMaOLJGUr9ID0Sak0/m6LLX+pOeDKvUC+nTMPpSoODficjGo1EX0yqa7WFwZiTuSMmQXIYUKxR/zAJu8cHXCHsZj4GE1cbywFFBrdtP9dnxY8TptMQFwrugRqllYASQRWMwsKvwJu1KG/j7/aOWTf9YWTTmqXHMkOogi93Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HHRcjHDj; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HHRcjHDj"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1dee5daedf6so7843235ad.0
        for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 11:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710872328; x=1711477128; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ttsLf8/Vv4XSDgXwOmjeIFqmOGIaA6d4xvoGx5K3xuw=;
        b=HHRcjHDjMrFM8/CFpjoQzw0E2902Il0Vrq31wvW38JoEh22Bk+IWwEfXtuY52mskSb
         bvFcKsta/2UVaajJ6teK/bk2qA030IKoo6PIy6YzxzojLkLlfjS8ek+wXKGIG4S2dkGF
         2Ga7aD4KO3iA/3QH8l7G17InWQ/9ngpIBdCTeic0ErSI5WVULLaP2X9OEWC1EQTeYY9W
         cgptSIZMWMSIIdf7NQCH89RdOdggLcpNcCszx0I5GbM79s+y1hv75QUIcAfhAFtmHIut
         swy+qe8gt/5lGNB0nmt8ttDU7/qiat5vsvO/CUrI/hXqqqIaprwm9XU1rm/5BD95GRM7
         yIZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710872328; x=1711477128;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ttsLf8/Vv4XSDgXwOmjeIFqmOGIaA6d4xvoGx5K3xuw=;
        b=Rx3PuJ49XkFA80GI/qql8gGGQ8OPnD4Qxxpj/wqYpe5SbNKYvpNl+VSmaE1Nfzo6iv
         2OB/NYLvhtxGH8eAPaGiM+HZMnAtZkQU42T2yr9ycYirFEUMiSqhTxF/W6nPuQj8XK2X
         tINWZyZsc4kNZitaiX6mMepsNkdaH+UrrAO4h2GLTqZkm6fX3/dtBglBB9AhWI6lMSmZ
         00tCheep+/aa7R+HFUwSjk1iIpMLgmFR5PWo3ul5UpzmamWP23FbtqY+bOAYqfYVoctG
         YMBEdhjMi6I+5Tbmka+wyhogBdmP9Vnts0bQAPr6pRr/n/catfZHKrnEf3rJRTCSYnBS
         YTaQ==
X-Gm-Message-State: AOJu0YxivBbFJc+hvAwyfUWeJljrM0azI8DRxsh3tsOKY04zxhimM5ei
	ZJBtuRtb2+7LfSScvaYvkVR/Mk3aFGokj6kizGYUiaHQQI086K9J
X-Google-Smtp-Source: AGHT+IHdWSDyGQAgjTBQUrEny3k9F7nqWA36dWJEPS2flyYlHH6hN4GRg4Y09QU5dBjkGxccVy7gQQ==
X-Received: by 2002:a17:902:e5c9:b0:1dd:db2a:62a7 with SMTP id u9-20020a170902e5c900b001dddb2a62a7mr3230063plf.3.1710872328228;
        Tue, 19 Mar 2024 11:18:48 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id h17-20020a170902f55100b001dd6f305a81sm4306166plf.293.2024.03.19.11.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 11:18:47 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: msakai@redhat.com,
	akpm@linux-foundation.org
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	jserv@ccns.ncku.edu.tw,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH] MAINTAINERS: Remove incorrect M: tag for dm-devel@lists.linux.dev
Date: Wed, 20 Mar 2024 02:18:42 +0800
Message-Id: <20240319181842.249547-1-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The dm-devel@lists.linux.dev mailing list should only be listed under
the L: (List) tag in the MAINTAINERS file. However, it was incorrectly
listed under both L: and M: (Maintainers) tags, which is not accurate.
Remove the M: tag for dm-devel@lists.linux.dev in the MAINTAINERS file
to reflect the correct categorization.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 82896c3e0559..e0a4e0def090 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6172,7 +6172,6 @@ F:	include/uapi/linux/dm-*.h
 
 DEVICE-MAPPER VDO TARGET
 M:	Matthew Sakai <msakai@redhat.com>
-M:	dm-devel@lists.linux.dev
 L:	dm-devel@lists.linux.dev
 S:	Maintained
 F:	Documentation/admin-guide/device-mapper/vdo*.rst
-- 
2.34.1


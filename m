Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6D56FC8
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 17:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709313925; cv=none; b=Lchv5ka6+i5V+P7Asw9T2a+M9HQg406/hHKq8F4qLs0Z1skTz7jp/u0juiAu8hSshVE8eP++JGAo/NoK9ioTmu3bnFkDUh4qeH3rsuy4cARv5XCmVvs16WXMt3ouC4907ue/cbGA8404XR3iFP2W5ZVzC+MO/Hrbx6D/6pBIT/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709313925; c=relaxed/simple;
	bh=DnAdJBk1C/k2uFUO9U8zgwM2eM4Fgt5Sgt81UaljBE8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K0r3PcxiocA2sEzELgbH1WFphPyDMoyNQ9xjFSgRz5E4e4kfGyhzyH5DV6gOn/E/Zmi9Cnr0iZzZez2IKZSoyP4iR+yDLdbt2jicmP/XeVo6GhOSH3Q3+gIGN3s/inlqpZnjMKnnVWZKpd4+uddKdLPf+LY6cpJJXhCcETurZ+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Tgk6xB6o; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Tgk6xB6o"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-563cb3ba9daso3237300a12.3
        for <dm-devel@lists.linux.dev>; Fri, 01 Mar 2024 09:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1709313921; x=1709918721; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iYWfWq8xPZZBQLR2dyDFXLx79MhPdZaka8rU6WPuA9U=;
        b=Tgk6xB6oBUnm2XHWTbqQ/t12ktq2//zryAMMHJr6i7LZzGNrCA0TQ9KBFHnrKw9kIz
         6+cpT3RZV+I5TOm924LrSOs/RqeBi+DvZvJyZ/EvUA0/q4EM6SA26ZhS1Y9YqOGXI8JM
         J7nRWuO060PX8VPXBr9O7bXjSOn8XD/2vtNbyJjISlfKiKTab9VtiFxsMvs8vhvauIn0
         V0D+F7BgpdQJoAeaprgQJwMeG69be/WxBI0vFnz/S/cwlfWq3x2WtafGJ7QKJLKI8GeF
         InJi6iki6Ru3+igB5bfNrGvmZbO0DQol5r2dcBwqqKpllRp/3qgyzjNwG5NHyd0rLCLG
         VhFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709313921; x=1709918721;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iYWfWq8xPZZBQLR2dyDFXLx79MhPdZaka8rU6WPuA9U=;
        b=vTlb+vBWxA7uyMH2rliLfD52QRS/LU9oaLJ6TsmFw0RDiqC8EHoAWmYkYQ3hFGF6Au
         Viwz9RQ8wmaM3NKnWaVPuTbpvSq5haoxhcfPHDzdg+EJ7rrHyV81s7mWP4oZ1pnv9r7o
         tjm1/OuzNOeKA5HBnRbWPmccWBsUfb3i6t0J9dIs5jMpYghTDuCeJ9q9o2FJOB/5zata
         XRqUazPVW5lQiqz+hDTNtrglu6PYnFgGUnExGR/RVZfZ5wW1aD30MMMuXBquXAdDpZKC
         KfzBam8qrl9SoZlAOrJqyhMARKG5QrkFPlPF06CJg9Y4v+8IOJVv2q82Nb+44Z+hVenb
         ZhCg==
X-Forwarded-Encrypted: i=1; AJvYcCU+r0OvdVubj79gWSeUU3/QXFlBFQpqxBboCxqbKdP9XYB9XT+c6f2UZEMyJ0o5AE+1pbOAd8DbpuGu89lgvKs+AxbP/5OuIyo=
X-Gm-Message-State: AOJu0YyOibep+7zlML/xuRcxHzYu0gg6M9a1lIQKw5+FjGqX7VG5aDvP
	/trWV2njQypIGRtaNpAS4wbfUR5rqY7/+5mzykCKobiQsj4/WzscDBAIYizfvo/WNMSQ3lSWN18
	L
X-Google-Smtp-Source: AGHT+IGwtHcxzGu4nUUxA+Qsz7xhvyrDVJ5J5Vj3zPyxdcbYthTJV+sVUSPvswy+GuBWLBp4C2wnXg==
X-Received: by 2002:a17:906:d92d:b0:a43:fa38:901d with SMTP id rn13-20020a170906d92d00b00a43fa38901dmr1729370ejb.45.1709313921115;
        Fri, 01 Mar 2024 09:25:21 -0800 (PST)
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id bq5-20020a170906d0c500b00a43bf243342sm1887087ejb.24.2024.03.01.09.25.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 09:25:20 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH] 11-dm-mpath.rules: fix misspelled DM_UDEV_DISABLE_OTHER_RULES_FLAG
Date: Fri,  1 Mar 2024 18:25:14 +0100
Message-ID: <20240301172514.7262-1-mwilck@suse.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes: b3582da ("11-dm-mpath.rules: use import logic like 13-dm-disk.rules")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index d364f9b..d9585ab 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -116,7 +116,7 @@ LABEL="scan_import"
 ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!="1", GOTO="import_end"
 
 # Don't import the properties from db if we will run blkid later.
-ENV{DM_NOSCAN}!="1", ENV{DM_DISABLE_OTHER_RULES_FLAG}!="1", GOTO="import_end"
+ENV{DM_NOSCAN}!="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}!="1", GOTO="import_end"
 
 IMPORT{db}="ID_FS_TYPE"
 IMPORT{db}="ID_FS_USAGE"
-- 
2.43.2


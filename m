Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B136C1448EE
	for <dm-devel@lists.linux.dev>; Sat, 27 Apr 2024 23:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714261550; cv=none; b=n9Qq0TjbCKMiUyYTrZe/NNR16HrObJ9IkSRiEirkdAqLj7vf2HRqdX8tACwRfqUGuxLw79vUD1TKMkbTgUUZX7zs9TCGYn4af34tgqO0V0ex34/e+BpNMvg3BBDD9NjInnB22gL/5qxH6j3+ZGz2HP7cg9qC1tC1NEvoKHV3mew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714261550; c=relaxed/simple;
	bh=i9dOj/WIZ1G32fy3lhxdnjC0IqpXh/6iBmJJCGuek/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=METbc/cElE4sGZ16CvsjBdqUxZTtdXCfmgIx4Yw8Z7U+SEJRukHCIt5rYeWkGoGMF7SV8H39TOc+G68AnZiRVasmyKLnhxtfjCoXzTd0iGa7sJOo05Nd9mN0hBxTT1vXz79Tuju7d72fqfDSXIeyoeFgHTGUHB9tz/n7+eFGJOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aYPp4jg2; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aYPp4jg2"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-41bca450fa3so7594605e9.2
        for <dm-devel@lists.linux.dev>; Sat, 27 Apr 2024 16:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714261547; x=1714866347; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zN3v3/5XekK8gpaUkD8G/dLVvPy/2igCGoA+7OSgoaM=;
        b=aYPp4jg2PdSB2MAz9f3HItzPkgSgqvEV04URWl5bdI6K2aNwo38HrwDOYGElS/0i6e
         sDSe543qsutgniIUQsaevgNqBJ2KNpei8LQJ4b0rlebCEdbo+Y1q2JdZQA3qXNTstb+s
         GymIQoRuSypVz092463HyezLZGNRXmn7Ufd6GoXAJnJOUQQmKmvZSGawX3bAVlQHkJUh
         s7LrrdqUIUOCN5TNMsZe0zD9NLwVBwp9ySNA+GkanyqIRB7bF68oIHbc6JJEyvDQwyy4
         Fmbx87sqgY3uFIfD0txIOWKE8il04Yw0NZvMqGISqRehQJ8sRbfY4lakDE00wO0V5yHD
         ckKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714261547; x=1714866347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zN3v3/5XekK8gpaUkD8G/dLVvPy/2igCGoA+7OSgoaM=;
        b=vVgRmw25n/rbxr8YA8T01FTg9DUMdqmoXEXUVLN9sWP87JWCfhMIppel/3AdjEtOdK
         ze984EWgNm/7DyJYADNowgOGZHxXMKkltcJRkGuvMU59+UTy0PL33P5gsWVuzOuA5UJ9
         fKJ9SGNXvPJZvaos1LAO7vBUJ1ri1E/hjDxq2Chx7+VD2+ll1+nexmxQ73yzTywiFeeJ
         YTOc7Q4pgwJOZeHqEfj+tstEE5CrmCsL1ZxNecHrzM/NHM4P3EZAhD2cICpAoqh1L4u7
         /dzj4TLimNO2nM2C1smwA0eyFw2zDKNz/a80/BQ4cShUz1aZgL9kDW4unYaRt3t1QJzj
         ORKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwfyI1o600n71XebDWCsZMuW1PENmuJRBlEdwkwWAVyLOmwHymIHPyt0Y0hTcJPPi1Z9ivJONfppskfMXiqiu0yjP89NQcEUU=
X-Gm-Message-State: AOJu0YxS2Nx1BdjvwlB5NI9BZMTzS0eUh+dr43Xsm/bW89DhhjscgRkb
	7X2UQN1q1UOasdJS20oYyXf+G/H28apHArAR33zLqdutGMjQKaka3BUaL8g=
X-Google-Smtp-Source: AGHT+IEE8b7PxJE++n7LgRd4Al2IO3+sLz/JgwgzLmu9Oh1dL0IkakYIzZgmU0b4J7+AdI+0HLRKGg==
X-Received: by 2002:a05:600c:4448:b0:418:ee30:3f92 with SMTP id v8-20020a05600c444800b00418ee303f92mr5168169wmn.25.1714261546842;
        Sat, 27 Apr 2024 16:45:46 -0700 (PDT)
Received: from localhost (11.red-81-44-148.dynamicip.rima-tde.net. [81.44.148.11])
        by smtp.gmail.com with ESMTPSA id bg5-20020a05600c3c8500b00419f419236fsm27599104wmb.41.2024.04.27.16.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Apr 2024 16:45:46 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH 2/3] multipath-tools: unify text in multipath.conf.5
Date: Sun, 28 Apr 2024 01:45:36 +0200
Message-ID: <20240427234538.8025-3-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240427234538.8025-1-xose.vazquez@gmail.com>
References: <20240427234538.8025-1-xose.vazquez@gmail.com>
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
 multipath/multipath.conf.5.in | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index b29a75fe..c1a19ebb 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -187,7 +187,7 @@ The default is: \fBno\fR
 .
 .TP
 .B multipath_dir
-(Deprecated) This option is not supported anymore, and the value is ignored.
+(Deprecated) This option is not supported anymore, and will be ignored.
 .
 .
 .TP
@@ -277,7 +277,7 @@ The default is: \fBno\fR
 .
 .TP
 .B pg_timeout
-(Deprecated) This option is not supported anymore, and the value is ignored.
+(Deprecated) This option is not supported anymore, and will be ignored.
 .
 .
 .TP
@@ -322,7 +322,7 @@ The default is: \fBID_WWN\fR, for NVMe devices
 .
 .TP
 .B getuid_callout
-(Deprecated) This option is not supported anymore, and the value is ignored.
+(Deprecated) This option is not supported anymore, and will be ignored.
 .
 .
 .TP
@@ -995,7 +995,7 @@ The default is: \fB<unset>\fR
 .
 .TP
 .B config_dir
-(Deprecated) This option is not supported anymore, and the value is ignored.
+(Deprecated) This option is not supported anymore, and will be ignored.
 .RS
 .TP
 The compiled-in value is: \fB@CONFIGDIR@\fR
@@ -1295,7 +1295,7 @@ The default is: \fBno\fR
 .
 .TP
 .B disable_changed_wwids
-(Deprecated) This option is not supported anymore, and the value is ignored.
+(Deprecated) This option is not supported anymore, and will be ignored.
 .RE
 .
 .
@@ -1340,7 +1340,7 @@ value in \fI@CONFIGFILE@\fR, run \fBmultipathd reconfigure\fR, and use
 \fBmultipathd del path <path>\fR and \fBmultipathd add path <path>\fR to
 delete and re-add the same path device.
 .LP
-The default is: \fBundefined\fR.
+The default is: \fB<undefined>\fR
 .RE
 .
 .
-- 
2.44.0


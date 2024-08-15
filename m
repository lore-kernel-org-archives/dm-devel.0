Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1EC4C69
	for <dm-devel@lists.linux.dev>; Thu, 15 Aug 2024 15:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723735443; cv=none; b=T16GVTJibHCAo2nJMAY8GQk0tFzaIDHcbHyJx2aMTY9RzXGISMznqvJxOx29y1Ap/D97w+yeLbPWrY11MGbfgnhta6Dzlk6Istuh7smk2rpP3DAqj6rGnb/3tkRkmonZPW2S+/ZN8bBcjc/oYow47TQOKKS+tIFkbtkpQLBBR0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723735443; c=relaxed/simple;
	bh=rkR8Lej2G9NOWE3pDuNeSqdWAY5nrlUddUmkajii4gY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DoAohG2bEPmbDsEiSmeZ0PiFOEH493NFZ+akTA4nT4mhKn1J1aNwROgyI8anoqmouZMjnQ+dxDjJZtfv3abcetakB9gUncgay+QNrnxpFa7wD8trRDOH0kTdVTFO+aCC5BqyY6M3u5QcYla0f7tRG8Mf5xFTzfMW8es/ghaMIqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TIGzQ+u2; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TIGzQ+u2"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-367963ea053so702311f8f.2
        for <dm-devel@lists.linux.dev>; Thu, 15 Aug 2024 08:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723735440; x=1724340240; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=88y+/swP6/qOEaZXFW8YAv7XQxQ5BvUs24gTVhS1P7w=;
        b=TIGzQ+u2fOilAw2MY8ar1iThfM2Y1YPSPCB0cYw4Bg+5nSvL4qwg4tt3IPM7gKpj2k
         g46CIGBjIziNCbf96oDS2Jw4KZrvrIymOezaI8r72hkLZRI/7oUXPvrMmKYn4Lc3SUfX
         MyzxJyR+QxoSmdVkcoYzGvqnq7WIGzM45XKaXeImZOigUZ73a/KEn9zVGMKrKZDnLNf8
         SnqKnWKsXxoSPHCGEaLjlruiSVumIo8+7KbIO6n6fGPA1SIprwQRwrx5f3JkuvnAh63I
         ikdJIcW9fJNIThNbCxprT80PG4tuePX8bT4hyKysWxY876bqBbflEDmqT6SR+bsSCt+K
         APLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723735440; x=1724340240;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=88y+/swP6/qOEaZXFW8YAv7XQxQ5BvUs24gTVhS1P7w=;
        b=Frx/gsRer8QtJFPIt11RaxV365DAM2pac3DHWa/blhIvR0vJBc9ZMz25o19CAmLLuL
         EvgBL4wl6dLfgQv+0J2ed8QL+8JJczeiTAJmnT/eGyEsu94mAt9p/nqOBj2Kcc4OXk5N
         hPL3UPu6qjyg9ntiMiXA3Jlt90HPiKD0S985ZqsSjm6UHdgJKDXjtbZDgJDZHwTE6atV
         uuLynTBKapFnnfRWL6sm0Xd97PU4up20B+y79E6InM9nkiYTwwVGezBz0aUzVxFBr1vO
         39L1Ohc0kojavurqoFhrl1zLwt1hqp+OqKUuwo8aHJW0WLgd5hbHOqRfNRde099El+PR
         XlvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWuv2hds4402LOlsviSTkxvITBE1lBasKpHvCILFH2mz3Kw3dKZgP53+4E6Hd3X4ohKyGcycQGPCcszC13lsMDc95yvMdkLsOw=
X-Gm-Message-State: AOJu0YzyDyLuGkBpkoSmC+ZyOPKZGOTN1Lm+vurmB9gOgSq6u5uQifS2
	x+gH7Mviz5PrFMHJbAdLZJ6kZjuKK4EoZq+nmH8tpjODyySxewM=
X-Google-Smtp-Source: AGHT+IFAtPG/uNkgih8TvaSwnbzV69T+O9j8IYkwdfisFqVosn9qv6KF50SzAkeVGwxsK7dywhLVwA==
X-Received: by 2002:adf:e907:0:b0:371:8dc0:f90b with SMTP id ffacd0b85a97d-3718dc0fac3mr1206578f8f.55.1723735440165;
        Thu, 15 Aug 2024 08:24:00 -0700 (PDT)
Received: from localhost (45.red-81-44-199.dynamicip.rima-tde.net. [81.44.199.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3718983a2eesm1769387f8f.19.2024.08.15.08.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 08:23:59 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: update info about path_grouping_policy in the man page
Date: Thu, 15 Aug 2024 17:23:57 +0200
Message-ID: <20240815152358.233091-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

It's hardware dependent.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index 677b0823..4388baad 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -6,7 +6,7 @@
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATH.CONF 5 2024-04-25 Linux
+.TH MULTIPATH.CONF 5 2024-08-15 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -220,7 +220,7 @@ The default is: \fBservice-time 0\fR
 .
 .TP
 .B path_grouping_policy
-The default path grouping policy to apply to unspecified
+(Hardware-dependent) The default path grouping policy to apply to unspecified
 multipaths. Possible values are:
 .RS
 .TP 12
-- 
2.46.0


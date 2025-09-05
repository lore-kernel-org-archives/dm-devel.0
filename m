Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33972727E3
	for <dm-devel@lists.linux.dev>; Fri,  5 Sep 2025 21:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757106449; cv=none; b=CHTER946fkO4BkyBNL3+PdOH8o1x/DkDwuQzkv/Wp98ZBhrREnHb98UiwnZiv+dvQSKSeazmnqz51+Y/5Zaj/1RsrPV7B5rwfDDjeN216P1KO03y7AYDzUJj+CrDdJV+kEvyWlN0O6VLIgdRfhYuVoTFHvoCuo+j3WbLz2SXLJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757106449; c=relaxed/simple;
	bh=BSSeaek05ROw+3idKrWChjI3a1s0JjmG9WAZJj4szwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHPmAw6HBlafAKlHOgzIlJqnrcHiiD7qq2ltzzL+ohYlIKf/1Fl/wyMhj8XXETJwWhIXDX2z4piaw05xqf+w5hoc+BkjoDyGPi0U8goj6xTva9MechripfCsgdESJmbzsgqdr0qqw5JSUKYtMcSq11ujLlzakRUivmBifVkZfJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CiLt2fUV; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CiLt2fUV"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3df35a67434so1487048f8f.3
        for <dm-devel@lists.linux.dev>; Fri, 05 Sep 2025 14:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757106445; x=1757711245; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=STl1T+45A9ik6vBMxejWRVjEerrZM/erem8IehYunXw=;
        b=CiLt2fUVkSNVkISdLksAXEbQ42eKZn8vIFGvBvQCpttbm8jocqyVekWa2gSkAZujEt
         6fstLPiwEV+1p+5np0wOMmTWMRngWkI8Ejj1dpjSwdiZOyE52+ovb/x7PNkxV6SqSwb9
         W832scKEfmSZBNDvKGJ55sot6gyJiBZVYTSxZwLfmTP/Ay2quRXJuh+K7sTZj7lQRW8W
         cpTBFdszmu7KrGf78VJ6kmlRCFiv/yeLC0w+y30LPNasg9u8FXHdfkyMqRSS2g9NFhd+
         GqvfbOF2uYolfOaqV+InyHom3BUdxHEVhZI3J2S3rf5PcfTl8Y1ZxL3mnsW+GfJeAKzm
         3ltg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757106445; x=1757711245;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=STl1T+45A9ik6vBMxejWRVjEerrZM/erem8IehYunXw=;
        b=FFfpDMF08CKMubuPHdxhhjdlQkmLh2UlauMxYV7w4OZ0JSZesWnksdMipw/JQb/4Z9
         GrussLqrz+ZpWFTSwvUSduufm7CnaCxCdUmEjRPn3Bo5PaqI/guyAqFzresxVGegg8Vj
         3Xthp50LakVldSMg9BO7hXWCJ1OcGl1jSlFg2QtR6lMjgSfnA1/ZbJJiFT0Ai0ttTDms
         rzTJ1pVhp6BXrSkRYLZUZPGV/PR7+Uy8F2RhOU1uJjrsqGM3U0YTFhxroezDlCqItl9g
         zD+yz69gI8cv3fdPjpOjgKV+AhmwaPXQxyJWsxseC6JCfAMDt4eGQMF6aPSbXMa4ssLo
         54Bg==
X-Forwarded-Encrypted: i=1; AJvYcCXk95Hg++ftXjYoilo8XalVIObZfkzBjT2+VSL3HLuWBkJP62hIhjLxJkyHHtRPyr0mI/+/yrwuwQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyd/zVTdY3sTyEBeGskEq8SzZRxtE6B3CYcIRGNyqoX+6V8XCwe
	OsFSGNPQ9Fct3KwJYpPnIDygaro1Bcknm2D1wCXyn/yCKG0I2Z4qwfU0nx9hAhNNyJ4=
X-Gm-Gg: ASbGncuYjekLk2KgmlL+df6MDYCEfMU/ZNOhgyTcOJ7qlhTfG+F4WJMWW/AWMnHpPpO
	uszQjRUKwo6R+WV1OebebyF3ohJFL0UekXxXpZLx3FbW+exG7r/4RINVDMw0I4HeyOhLhCavBXl
	Ur675H263RceLH2ZBNr4cbGWZrkeIAuVuiQFW4SlUvyWC4sTrWDY6bvRbRga5rpZBbb7SBNnS+T
	YaHUKG4NkpdzP9l6ypSSVBdEUcCk6sfsZP9pUYiW18C1HgJl07Qefj4qUJovLF4aRW5iYe6nDhY
	LzgPbfWA+yM0yEvGWowz34sxKL3udQXNf2onduDXIKNexwMlWdbcomZUVi4bxA83KzacHptX8uz
	C+JK7f+cJOeW3kD5JFiP6c5AE+FAI8BqzzcoV7I7YN5ii4LILJlp8b6d70pilaS8XkYPZEprmhQ
	EBnhdYP5hXDNWSHWDHLhDu6g==
X-Google-Smtp-Source: AGHT+IEF8rHhE4ot/gRo56OWsyYfM4jC9aPj2WauD4JlZkF3kGcqnM9tdtn5mlzwsI3VMD7uG3yXfQ==
X-Received: by 2002:a05:6000:200b:b0:3e4:957d:d00 with SMTP id ffacd0b85a97d-3e4957d0f50mr2474104f8f.58.1757106445168;
        Fri, 05 Sep 2025 14:07:25 -0700 (PDT)
Received: from localhost (p200300f97f1e2d0062fae9454b512ce6.dip0.t-ipconnect.de. [2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3e06dbde2d2sm8899668f8f.12.2025.09.05.14.07.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 14:07:24 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH 1/2] libmultipath: fix missing return value check in snprint_devices()
Date: Fri,  5 Sep 2025 23:07:13 +0200
Message-ID: <20250905210714.167202-2-mwilck@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905210714.167202-1-mwilck@suse.com>
References: <20250905210714.167202-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Coverity scan defect #488155.

Fixes: d041258 ("libmultipath: snprint_devices(): use udev_enumerate")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/print.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 019ae56..a7306f0 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1993,7 +1993,8 @@ int snprint_devices(struct config *conf, struct strbuf *buff,
 	enm = udev_enumerate_new(udev);
 	if (!enm)
 		return 1;
-	udev_enumerate_add_match_subsystem(enm, "block");
+	if ((r = udev_enumerate_add_match_subsystem(enm, "block")) < 0)
+		goto out;
 
 	if ((r = append_strbuf_str(buff, "available block devices:\n")) < 0)
 		goto out;
-- 
2.51.0


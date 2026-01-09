Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C42827E1C5
	for <dm-devel@lists.linux.dev>; Fri,  9 Jan 2026 18:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767983972; cv=none; b=C1/BsA1H9A5OBWJwgchlUnNqso/Z3WmUj5W6ovMObMgiu3cl9RSY8UaXUEfyfpBNi/t1rpFYGNk5VZQRFxu7WkFqkUGgX82L4iuK3PhgXaMBXbyoBzfWIdjNvG67V0JZSkSOYs17uUm0n6mktaJrZvDe/QhsODVoSJbMpDAG+ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767983972; c=relaxed/simple;
	bh=4o/vfmP1ccyNcw/p/sRy6XHhzejBhJ1ZRo2alRKpeZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A81UEVamJGGpC4mpLNwtdWZ+vdWKHesABTeEg8eXAUVZBJf5Y3mKiFHpb8eIgq7Dpoa8tEmaonjRr1iOOS+H1VT/jBzH4C2ghDRaK89A1OVejiSJL/Wo6JMUn4ewXuNzau1DKYF/tLH+zxpSxaP4k9MjQUesXGF4ssDHoa2wLTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MBgzvJnU; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MBgzvJnU"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4779a4fc95aso17417535e9.1
        for <dm-devel@lists.linux.dev>; Fri, 09 Jan 2026 10:39:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767983969; x=1768588769; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yri6wExFuvS0m34v1cEU6P3t3l7IYCo9dduq7DmEkNw=;
        b=MBgzvJnUuYD1SChzOeHv3xDU3x/lRdmwriudeGfIf86GpFEZYZzNZDUNlvZy+z0HZz
         4sY3tCfjsjzFRb7O/613g0TDlmOKAIZxepehrFWosFVmxNUokSxG7qUa/M3uw/DXE470
         q0300AOK7AeU3SbrwiLrPHmbmkEBLzhKn6M/4E7+GUnJ25nyzfPvdtMKwSLdO7Sf1p89
         xvTiKGcaH2xy5/xPTrjMKtrpNWnWmLzQmryTWnp3b+4HcgAQXM6YM/lGAi7Vu96NyndQ
         AKGIPkcGZ7lK6fvDgrRH40awNusJkGn0MVpCGrcM/PrUYcgUeaiZEYG0BjZiJFm/LwSv
         kjhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767983969; x=1768588769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Yri6wExFuvS0m34v1cEU6P3t3l7IYCo9dduq7DmEkNw=;
        b=OzX5gZst+6NoVL30sPyzAJ9wr1cbKdOg+NOMdT1TO1WX7AzyOBDAvzODt/yD2O3EXD
         D7Q9sDcxf17Qwww1FXsKBNyWk4I1TrzWJss+Y3oDTBUzMH9uszI+0y+jfcFoBab4iasl
         DumDJjUku17XkonkP4XpcKZM5C8futN1EoBgRVwhSBmyYL7HeIwpH+TQgQGSmwiH5UcF
         bz5husdCXJ92yKc3Rul+3mSmRCbhHHKxqxF+coIy8EMjxvgano9a3GCoEOc0TzTOZv1g
         76kEFIbWNtfr+/V1GvQO5zN+pPW8YTQbMG6/a9ywHsV4Qdh0XwLfS0x9PsLaY3jhbkY8
         S8hw==
X-Forwarded-Encrypted: i=1; AJvYcCX2DKeFKnW8fob9ZcKLbsoQYeL9qIQB8AWw7XovvFXBD4reOoBiASxbF8SEJifdFHHXhVVmaDaimw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwGF/fIAEEVCenYNyrk7EaFhe8CWDfPpDYIJdq7t2dbE5oaMO+t
	fYC4B83qimbWfKdaRrGusdAZsWQIiEOuDOc16Cz9UkUoxtQiIVwzUCltoDhuo8zTFK8=
X-Gm-Gg: AY/fxX7VG3PZdp9sgGbO1ZhFa5UhJfa0qGFlB3BeJGeDqk9Bmw+4KUDsNfGGOV3OgpQ
	PxNVDQ4PwGr/t60G3F6DQaYSiq3uWMWHDBJxA0T+z6ltyFBzQswXE0GF/3dUO5qT+mlOSOXJiK/
	uw3LB8XX0XOcd0NtyksDh91ejYK0/KWt6haRbKvq4hrOmNrgMNkmKBArZ0lYs848P3SaGXcURAp
	b9InEABBGlefNTbUb6UkkadibMtiX1Y3TXcAf/cy5cRohRKwy/VsLK/1zBzgJSiYPhSSheCJ4NO
	HF4OMXqd3Cx4ogXzbR3mVF9bQqrhIoNaw5Rn6bfbnc6FcQlNf8SCOPgwGVBWACleLHBgkhdwPfu
	KLcfwTjSu0rhKz6Y4Z4zp2FtAQJom9bBk3052w4AR03kghS8YXIn3QVdFj29Nlx/MV6LICK5zlB
	1VDGWeOYSVkSp8INyI8t6u/JykDoeyAM67rxo3owOokBqwHGfc2pYAvOmU7HJ5qm26G24SMeriU
	g==
X-Google-Smtp-Source: AGHT+IH23bdh/VfezaBs2FBlQFw/wvtPkhuLzswGUH9PkBViuCozt1DySM8vESlOL1C1NpC0OkR2cw==
X-Received: by 2002:a05:600c:1f8f:b0:47d:6c36:a125 with SMTP id 5b1f17b1804b1-47d8487f5cfmr127707165e9.17.1767983969287;
        Fri, 09 Jan 2026 10:39:29 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-47d7f6f0e15sm217829835e9.10.2026.01.09.10.39.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 10:39:28 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH 1/9] libmultipath: reset pgindex in uninitialize_path()
Date: Fri,  9 Jan 2026 19:38:59 +0100
Message-ID: <20260109183907.201250-2-mwilck@suse.com>
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

This is where this operation logically belongs.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.c     | 1 +
 libmultipath/structs_vec.c | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 4d993be..29c0008 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -150,6 +150,7 @@ uninitialize_path(struct path *pp)
 	pp->uid_attribute = NULL;
 	pp->checker_timeout = 0;
 	pp->pending_ticks = 0;
+	pp->pgindex = 0;
 
 	if (checker_selected(&pp->checker))
 		checker_put(&pp->checker);
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 75b6d5b..434b57c 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -373,7 +373,6 @@ void orphan_path(struct path *pp, const char *reason)
 {
 	condlog(3, "%s: orphan path, %s", pp->dev, reason);
 	pp->mpp = NULL;
-	pp->pgindex = 0;
 	uninitialize_path(pp);
 }
 
-- 
2.52.0


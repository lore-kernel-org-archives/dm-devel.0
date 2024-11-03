Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC7B165F1A
	for <dm-devel@lists.linux.dev>; Sun,  3 Nov 2024 22:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730673849; cv=none; b=o8Q+Fp8sN5zbaYZI3a2Er082SS5C+gfIlE4D52bHcK8lHiWefd9U5tz+djS61mUHtlu/nTMzZnf8PzuYOWhu+Pb8la6jh1jyayffoZGdQcqpRkuFJogpxwX11/utIvyYbT3RtXPE/ubY1hsbeUdRjPsT1ui1S5zQBtKf2h3eWvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730673849; c=relaxed/simple;
	bh=mI7Q4/DOyHOnNCuJjYNULsj8tfM+qzNLdpz9DMtZX4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuySLX5IX6dw49uyQ+HpSciRiy44YQzGTEG/qMpfGDXJNh53zRkTCD6WHG1/sKXcntvZeST5fYfWz51hC4X+Eme+todEmzcZnNfTBOmgMn/R+J0boKnmbYht/gJRepfP8wM/LHl0wqw3U6o4HJ5ElgySprBAtzBOE/1G8iaE1og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SdIs0uma; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SdIs0uma"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a9a2209bd7fso648322666b.2
        for <dm-devel@lists.linux.dev>; Sun, 03 Nov 2024 14:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730673846; x=1731278646; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y0eJUXRVH8gXHiSTWpWPkXrCbscVqP9+lj1wXjjtqkY=;
        b=SdIs0umanSLpiTSemXFIWKc8Z8PNG7sR4qLXKnrr94dLKwoxUxxpBteA+y4QnmmImf
         0y+/JyjCejBdZg1cB1EsQLl6dpC85i7lDqvUP9DQNGVBgB2VpAo2l3GN0Pd9NB2sutf0
         kaKic4ZThRelH2Z7cOi+WGxRi8mNZNfXo2/Rfnwj0IkW5rtyqgB7Rl4hO/EqnpZN4WWG
         Re+kdTeuB/eMgYC8dOaNBxhj1fXmxKJbe+78jYkJzCiUn4dxPcQVQTr7phnQaKpJuapm
         IdZDRwyTxKAa04uRkZdHaWjA6Xhnpx9VMBdOTxBihPNGpSQXW7teYW/qy+t7j1b+l0n8
         UZQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730673846; x=1731278646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y0eJUXRVH8gXHiSTWpWPkXrCbscVqP9+lj1wXjjtqkY=;
        b=CXu1zAEtp0Q1UbSQpGR+u++9lmiknsEVW2DaGICeRGIZtDNfRdcAsVuKbmk6VUJohf
         LPRvOk3ouN1+7pxdhxCZAommlVeqhkwi5f0kOESJgoUqYTmZUgTmpg8UPe5rNfx4zgm6
         Mlncq+4tuDfiWo3NXXmwKrxdon15m2roMJ7WbIrDzHBXlJoVx3cTWZWhwpDb4nkmu9f6
         GIgKmdD+u+drBm7pjWMoREyOVFNtzHd2XKMiE5CiWYzwLxkunjAcw7wGtQZYLd7k9+f8
         AHdOvbqmO91Wfb3ajjT2aRtAI/a2kLYwYXLJswyULWSjvX2/b3ZYkcEieN1I0g3NZtZM
         QCUw==
X-Forwarded-Encrypted: i=1; AJvYcCXG8daMSlIa1uNmXn9/wMH3l28PWiCtG/52U9bba2FzJ6FCIlhxBlPNXnEbG2Ttsis7r13WDT1w/g==@lists.linux.dev
X-Gm-Message-State: AOJu0YxvPzdgQLMG95T5YGlh1UQNafMYtIuMAgmVPReRFKax53W3desf
	VM+B0wVwpDx2isycx2cZd9rZEgppqB+aYSQbjMcNhIcUlzfRmwp054WKEiqO9SddE8mKpfjJ8hf
	e
X-Google-Smtp-Source: AGHT+IHnAo2Mr8lzSeERSU5gkeooZ/MBV9fcrIUaINio0adU9ndFZVWKiYd4Ecf8xaEcEKzRrHjevw==
X-Received: by 2002:a17:907:7d93:b0:a9a:8a4:e079 with SMTP id a640c23a62f3a-a9de5edea84mr3128437766b.31.1730673845532;
        Sun, 03 Nov 2024 14:44:05 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a9e56494470sm471834366b.2.2024.11.03.14.44.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 14:44:05 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v2 4/5] 11-dm-mpath-rules.in: skip one .DM_NOSCAN check
Date: Sun,  3 Nov 2024 23:43:48 +0100
Message-ID: <20241103224349.42582-5-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241103224349.42582-1-mwilck@suse.com>
References: <20241103224349.42582-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We set .DM_NOSCAN above where we set DM_UDEV_DISABLE_OTHER_RULES_FLAG, too. If
the latter isn't set, .DM_NOSCAN can't be set. Skip the redundant test.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index a2655cb..79227be 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -132,7 +132,7 @@ ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!="1", GOTO="import_end"
 ENV{DM_UDEV_RULES_VSN}!="1|2", GOTO="import_end"
 
 # Don't import the properties from db if we will run blkid later.
-ENV{.DM_NOSCAN}!="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}!="1", GOTO="import_end"
+ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}!="1", GOTO="import_end"
 
 IMPORT{db}="ID_FS_TYPE"
 IMPORT{db}="ID_FS_USAGE"
-- 
2.47.0


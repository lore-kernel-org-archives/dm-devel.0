Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7F618638
	for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 21:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711314800; cv=none; b=PdkrU0XNpGSsvAHFZe4C0GAC4Zpv8k8nvYcw3T49PhTsI+xd+AfyUshUmT8aRpBtpgbniS1xlWe0cyNZWijOPQMNDal/sXg5liW5l52esbunFlzMqcdEJ68Z287g8lLriy1cgzdt8ut7nzc2WV4RZIIB6NBodqUqRHO2LyNyMB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711314800; c=relaxed/simple;
	bh=zblfVA4y1VKgEXkirIOXZkFhMrQgzO0hQRciI15VkTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=expwx5k5REzwktkm3KPaLCOoz7ggglv8unMJPA2glQjHmjyDzhvY4gRB9l7G/Mk66bdwaSb2Ovg+QscH9PM7z+BWroIj1kLjizNL5nxjYSpwzjWB+6AWKHbYq187dKRVxJALVva6Kq0U/kjkfDf6M6j5XN8wFRG3oY5CPsMoq7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fFXbcfI1; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fFXbcfI1"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-513e89d0816so4636865e87.0
        for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 14:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711314796; x=1711919596; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UYJwzfOU6MHM+giVKgiFGwGDInVQW4rruy3zeGg3g/I=;
        b=fFXbcfI1PaBTmg043riUGS6T3UOKBIZ+QaTe1cjCGiUtw9bx0B96YcbASNfpRwzKQI
         K6PCTahj+QStspGfiMOdtKhiT4YaLzmc6iqD3ks8dZk7oo6WXY1bshcw23zED5UZW9mj
         L2W0PoDRP2MZRP9Xg8nCoVgC3Y1PMBZkbDO8G9BMHmnEZML7Qx60uD/rpNQVV2rKbTDI
         alYEOZA4VlJIaXMYySZrnrcnR111IzQ4HAugDkA2VlTE7/4LzZZJ/donCH6VS/uKbqs7
         omB7RGfrpPIXLqlWhkwzeAnOco+5MrrSMS+OZfW25olO04Obn2oyrLpJmJ7kKdEpjw/G
         dFXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711314796; x=1711919596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UYJwzfOU6MHM+giVKgiFGwGDInVQW4rruy3zeGg3g/I=;
        b=sxVhPccss/ctYDacBC/1SgGEtCiZEgGkhOgsNPGPpFuVox7fDcoVjSDBTbxVyatuUh
         mywpUBY+lxu6H4mrW4JxeCcJzokGA197NSUs7FFTaV7czwyXHe0U5YZzl6MCEI3E4SPK
         1WLfTVqr11qJ8aKAWgkLAF/aAYCrBq+JJa0blFc/0qVv8ExZT7BvWRXUdSjALoc2kPdI
         Xnho5HkrpTJ5CBZgkwH4Yxli1F6rQpbljJYgQgH0L9nTYPBiW4kWvtzN/8paj7cFBbYD
         S4LlaUwoxXP7jQ/G2DkAbhdf5sPXhTPdwe1pJu0K+DzYyI5qm6hPqEKxoAr1xEFPAuXd
         Y2Mw==
X-Gm-Message-State: AOJu0YwPbQLksA1phk9HsEjxF8WYajl2EATMNhtlYwf3Q16mRr6Ffa8z
	ccPyVFV9zkxUg0ePyYYdl2fmQD+RSAuUZt0z5w43vMtZwHNdaypqoqWuq7UZgiM=
X-Google-Smtp-Source: AGHT+IFnHqe8wZ/liv60nQsPSbokLXczqL+7lAtAnMpDwWE6VbfiWqie2h8ehywB7tc0jMBQ9Rkm5A==
X-Received: by 2002:a05:6512:3292:b0:513:c593:a634 with SMTP id p18-20020a056512329200b00513c593a634mr3255014lfe.6.1711314796277;
        Sun, 24 Mar 2024 14:13:16 -0700 (PDT)
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id gu3-20020a170906f28300b00a44ef54b6b6sm2310325ejb.58.2024.03.24.14.13.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Mar 2024 14:13:16 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 02/11] 11-dm-mpath.rules: don't import DM_NOSCAN from udev db
Date: Sun, 24 Mar 2024 22:12:52 +0100
Message-ID: <20240324211301.7200-3-mwilck@suse.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240324211301.7200-1-mwilck@suse.com>
References: <20240324211301.7200-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

DM_NOSCAN is our "output" flag for 13-dm-disk.rules, and it should
be treated the same way as DM_UDEV_DISABLE_OTHER_RULES_FLAG, which
isn't imported from the udev database. The state that we need to
remember is MPATH_DEVICE_READY, which we've already imported above,
and we will set the "output" flags accordingly in the "force_activation"
code path further down.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index 3f23108..11b5adf 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -18,9 +18,11 @@ ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}!="1", ENV{DISK_RO}!="1
 
 # If this uevent didn't come from dm, don't try to update the
 # device state
+# Note that .MPATH_DEVICE_READY_OLD=="" here. Thus we won't activate the
+# device below at mpath_is_ready, which is correct.
 ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", \
-	IMPORT{db}="DM_NOSCAN", IMPORT{db}="DM_COLDPLUG_SUSPENDED", \
-	GOTO="scan_import"
+	IMPORT{db}="DM_COLDPLUG_SUSPENDED", \
+	GOTO="force_activation"
 
 ENV{.MPATH_DEVICE_READY_OLD}="$env{MPATH_DEVICE_READY}"
 
-- 
2.43.2


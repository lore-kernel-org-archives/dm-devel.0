Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795602376;
	b=rDP76jamhstUS8oy5U53KTSk5rkDQGQTcOGec4YxWiGgSfRYOepDRMkNgyaE0hF2AqRq
	 OetR9ymiwUsg20+18HpUri2S1h3WlaE+SmOHOC+WHgaZ32lNsvE4TcR6kZgBfBOFttlrZ
	 pqf9BNCAi5jqVzBNiHAhHtvi4Njof9Yw4NUEoYJsd8bvNGJedY5B/iMtRXOcP8KyFO32q
	 EueOzkXRGadEmRZkZ0sGNuM4ZNKeeUsTCvSs6ffMGcZKTfgMJMclSUJsSbAliscleQyT9
	 hRdueaQXDwrIQ/Jqhla95+WoaRSJft0o0Eh5xsSiP+CB3pbhtuywv2Jfh+8SAdqrwrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602376;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=EBVfefCd2O+shqjo5CX8uJdQ93lKLEbuhJ7PKxXbrqQ=;
	b=LxF4vYXtDsQRjH7PnDHWR13I6Cg+wDl5/KK9vLlt/Cifcne0s++gwSWYgL2wC0xFacJn
	 Y3IKucSV+ElP2QOyiFlmhvZkTEb8SVsLgKN2sw9I/1SHTAIAOWgyKUjv4XsIfqNDuEJgC
	 F5BYG7w6l67KZrhWUh9mZiDuWU71kenEoYn9p5HzfSGA53Tpf0SWmibgfaOxUBHryPT/k
	 JgDpsBB0RNpQKlFH2aGaADUqC7s+Ru2eB60NljoInXOEqcVspr/Ma26Z5yUxRJqDM3woI
	 4PjBAjtesIibFKR5F9BNh4IwdWku1sVguDvsJPnFzpf82kW6IXmELkW/ZGmCZAmoFlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="D/Ip9i8u";
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64570606A329
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 10:26:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64570606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=D/Ip9i8u
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-49a357e48a2so413506f8f.3
        for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 02:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795602374; x=1796207174; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EBVfefCd2O+shqjo5CX8uJdQ93lKLEbuhJ7PKxXbrqQ=;
        b=D/Ip9i8uDAZtNJcfQUVQfqXX8mJxtKetXnq66VIDxpivE+e7lZczdVtyAojtnLg3hg
         Yo7xa7W9QV8zcsHECW9D9FvfKvKlGBFTuXwHDp9WuIrhPuADjzTks8eQdQci/Tu/rmAz
         xFDq9P0fE6FbqYx/36+byOdePZR9fCBXPTAr3bd5jZGiKFjXuXtc1rnJjlYnSaQInvI4
         USOto7QWoetgMvu1TBtx1KMj58kEVoGh3N9FSRTDnz2Tt0tYn3kAIgb25/FNXjt24X47
         a0A9sIA2FMY7FYHcHxBOb4KoXVluskm1apy9h/f7vZNH2hqIDG325qa/VrpqPoj9XpaM
         3bjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795602374; x=1796207174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EBVfefCd2O+shqjo5CX8uJdQ93lKLEbuhJ7PKxXbrqQ=;
        b=f0sfm6xG0mI3GYXSeNQXc3plLO8bLz1HBvRBSm3GmGz8yhFdZsjda4is2JEsumE3CY
         4bci7d+cRKfhvbi2lxl/fohcO/7CfCYoKorvodyc4pl6vWRx473sxSKdxwP1gZd5+ZrG
         ss5x6G/wJ44DnD0OrxgP6hHUpOaOLgrlYO80B4KxTfytib1wrlD6tyR02fb0lSSikBNX
         cNfpYOz7Dwb6XY/qoxV0a9CWdpwqZC9u9eRgBUkWP54C8+/GsArhFisJA0G1yAqnWwXa
         ezOCfcIppkPggsVTK+UgINXh9odtI5EYL/zTicLxPzs3kt+l0x7fndYP+ndbzU/UaY+8
         u+uQ==
X-Forwarded-Encrypted: i=1; AL+hErGIiYNwHwaSnv7ovXx42CuJFSpfXeKmKExN8NMJLqPEYHV+JpY18QXCQCKNOJlFkoaGOic9SAuRXA==@lists.linux.dev
X-Gm-Message-State: APuU4Z9fbdbMQgyPPqXu+07otbJS339rNIpfHzzUQ0215dFohz3e6SPv
	01nIwSetA2IdHa9YD5PWruL/9M9EtzwZRAozng/ac4P3DA3lG14vvVY=
X-Gm-Gg: AZFdTZdbch/Hyg9XPeBVju2z3jUy7aGBMg/V8mf1L9yG1APQmJadvlAxwMyVwWN2nZ2
	Y1DyDUEvpHfqoSx1mQRIj/zyfOZ3g8leSIwvdXj/bxJ2t29pqVxVvofOBmgSWb4zVN7XOigklEk
	bF1u4UlJZcVkd/NpSCnbz6fl/A/xGA1GcRiSb1mABSqtlBxNgfP51pgFeziti3ApRidlm/yofAj
	bU1xKgWykUmipNdOwfS+d6YkK0okhTlYVuLXUn5m0VqVvgRAzWxGHa9De0X2qcZNpjV5K/62AqH
	ENNXG11GZcBscbw4sKK/kK9qf80Pk2Y3zy8nBHQeyToZ+mFnGis/kbCNlOi85+0d9VpdCoE+PnD
	xKLL6KeYHQfhb7mUFnF+4EZfYKyOeRSSdzGlEgVPaYoT/fAlp7V4oiAhRhFj3gCQ0QD1llEQw8k
	2ufgIdnkD+pGCmQKq0faz2XC+4jaKuDWJHi4xKAX7pcchw7BBw+UIwLYOyOQS3w3AeQQpBS0y7c
	2RcL/USGec2gsLuu3pajoxYf3OfPjjfIjMlvItBXmFroxp6MHrn+zW/AS8iBlnXkOYYCVkIqWHf
	Hk7CLIwdytbFpW0XNmo9gzMQismuAUQdA3e5FgB5wxksPe5V8MMT6i4kiyjbjokwjQ==
X-Received: by 2002:a05:6000:4013:b0:48a:f5c5:d077 with SMTP id ffacd0b85a97d-4abada78637mr36826903f8f.2.1795602374463;
        Wed, 25 Nov 2026 02:26:14 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6a680355sm28061984f8f.27.2026.11.25.02.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 02:26:14 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 4/7] multipath-tools: hwtable: add StorONE/S1
Date: Wed, 25 Nov 2026 11:26:01 +0100
Message-ID: <20261125102605.82009-5-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125102605.82009-1-xose.vazquez@gmail.com>
References: <20261125102605.82009-1-xose.vazquez@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Config on: https://docs.onestor.com/books/linux/page/linux-nfs-fc-and-iscsi#bkmrk-multipath-configurat

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 64bd9c9f..ee3cea5a 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1461,6 +1461,18 @@ static struct hwentry default_hw[] = {
 		.product       = "OpenFlex",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 	},
+	/*
+	 * StorONE
+	 */
+	{
+		// S1
+		.vendor        = "STORONE",
+		.product       = "S1",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.prio_name     = PRIO_ALUA,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.no_path_retry = 30,
+	},
 	/*
 	 * EOL
 	 */
-- 
2.56.1


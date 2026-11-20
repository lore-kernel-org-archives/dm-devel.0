Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795173522;
	b=Y9XAOVia+c0t++YKUnfRyXjoWQ6Kch1v4YjW8/lyQ6+biQT7x0/0OWMLAix2pPFJ2q+3
	 BaTK3rIGkFb/KMrab3NfcqI/VdVnMprVyv/FUVwg+7oP4EeXY3EahcW0H4sIsZYYsLHMd
	 ZcB6+eZGBqgjDS5O0+K0oWLeGkUln1QAi4AFeRS4r9N6zLvmvw07SDUWTgyUQGQh6s40H
	 n+oo5ZVAD+RdpAXkA/ZgVCq8nnT4bPzq/5eaWMu/kwCS4KGLy3a2MTe7P03vGvW5tf+Cg
	 clADoQZ9Dz7iLeEbmr7GAHyS3CkFIRTCAujljUlQMcDfDDDaljjSA0BgvPcu7C6wq+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173522;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=k601JWrAQP7gZSxEDk6d56SMgqLV0ht9a++a4PXuy4c=;
	b=RzZphaPouIPv981EdGAIvcB68Uc02yVTXs40B1fh2c9I28758O37ayDfJ4aAwp57aKSW
	 YCJpD+nyNrZb3KJGPVbjSJ0U3fR4pH9HFBuMrgpq0qJTicyiOph9WrVbuz1hVWQGXD53E
	 pROqBtUAGtXQcEX83iSNX8ioaluH/JlqLA32xj+Il6XAToD32LsgGjuYokqW9raAzJ5x+
	 cUbkKMIquw9m28dHdDsi2xNFfW41tZhiuAx4IwCyHsl3i4pPEZXpSZSv+d67d2t/pXq/S
	 9TN3qSyNcErTfDtTMl7B/hkqXCUL0am0MVUayvLLn57bmFWxoS3Eaf5hUQkPgXHq0ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TTHeE6a+;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D695C60A2603
	for <dm-devel@lists.linux.dev>; Fri, 20 Nov 2026 11:18:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D695C60A2603
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TTHeE6a+
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4bb6ba3b244so6605785e9.3
        for <dm-devel@lists.linux.dev>; Fri, 20 Nov 2026 03:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795173520; x=1795778320; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k601JWrAQP7gZSxEDk6d56SMgqLV0ht9a++a4PXuy4c=;
        b=TTHeE6a+liJGwBFWuhb0KXKCn9Cr7hkH/hokcmWQ7llEfiMBPrxd5tZFgpPO8jRSed
         sNPyFKLuvqetx2ve1xIxx2yKtH5jzzKX46unTsBcuqGDmNdojOUBe4bvr2PBr8hPlHOl
         lAmT3U/frXenglHegFjhTgGMCku5RPpTwHVj745J949TwlbfSu9rwBISUQ5Id1/WEGyY
         HJQzoU/lItS7ef2hjpx6RDh8I6eLy5/Sfn7Jastp4f8po2OBxHpu1RhudFiOk6In5uPd
         sFRS+oMsdyA1CUXe0Em07Mc49Qmr4DKDntUeGTyfeWQyELiJFFGnvzWpgi73Ghfjgvvv
         KuvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795173520; x=1795778320;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=k601JWrAQP7gZSxEDk6d56SMgqLV0ht9a++a4PXuy4c=;
        b=V2S/G6bUAr8t540FuEj4J71p8xQrMAy4q3saMyQQepVMNIQ7/OZN2S6w9BRyzatlfY
         3d3UUI9DwtzP8eqaJm3G2vdcz/1G1ZDpOcEcq1kGl8KYIPvRniipHb+e1Sz2D0ferlZT
         a4JOtIrPFxTLF1vH7GGxZVxK9HwiyM3A0b5SGdpVz9sspLeb4P9m98UKC1g35L9KSPJz
         OGFmFqhK/YNejUuE5uJQ97UzFRIdwt3VwZ0K176xtWIZJTTRSORUoiygi98vTEJPrwY9
         px3tsHts0w0dhgLppGhtTB3pfEN5TV+ic/pph8D12ePtB1z42hfUFGco8wSmxnz9Xowq
         vEpg==
X-Gm-Message-State: APuU4Z91xGR8eDvvTMQ87YpdrZmhOIxcZVdEfwD+wE553dnq+XAw/soq
	2NMzmOajIgHyiTdSdUqa4W3AjCL2VJnOAOiv3iRQbLjM72n5H32xXXNo
X-Gm-Gg: AYBFou2LjkiwF1fRyCymlGt8dnwNSQbCqT1E6VRgxYPD594ni5p7jDvpx/YNfFEG+Vc
	hD0qm0a8HmQFXbYEzSCyrie1O2Y7LC462g8j81oCE5ydyvFiTD8kIie4OJQ+heJbzUVgcfyUyqH
	cDflae+ZjHAfLODsFFD/WQN1sdADEnLoRic1thz5wuA54Jv2pN89U2VI25OsfdCgo7qgXv03OW2
	mMUKIzOE1VGNmkVVUsiBMQncc4tbtaR4CRohXMQXJh0GOW3W1wOfqiZxuZVPyu8/KW+Xa3bYoLS
	a/hHLZDpT7Eh099sqI/ydK9V6RS+Zrww1+7kpLi/93p+1FuHg6WDDqOEo8jDxkAz3etq17stMZZ
	lNmd2KbmW+O4nWid7UXT+DMWgcaJGtrfST7Kt2IYcv2L+IZjhRrp8GtaBz09rNUIyHnTaCYuUXd
	jy+8nv6UetKtMKhAyqp60kyMjPE20jJbWyOadmfP6WkIpMGAb6Lm8fTh2nI3OPfoCOEaJ4FOxn1
	8WJg9LPuTCmWLq1xVoQvqxJk1dKcULt1yy/EamlMcINIE8XaO4z46lWL4vus19Yp201CP6piqFl
	bpBk4PKpA3fsA08XhpxJUO8INJO4g/XTd2O/nf6Bgy2/hgiWnBr+0+IAEwsyBa4XcKuP+wv7CA=
	=
X-Received: by 2002:a05:600c:820d:b0:4bb:6cef:d14b with SMTP id 5b1f17b1804b1-4bb887c34f1mr65783585e9.2.1795173519913;
        Fri, 20 Nov 2026 03:18:39 -0800 (PST)
Received: from DESKTOP-OL07BOP.localdomain ([87.116.183.240])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab658e2d60sm4985562f8f.3.2026.11.20.03.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:18:39 -0800 (PST)
From: nenkov2004@gmail.com
To: linux-raid@vger.kernel.org,
	yukuai@fygo.io,
	song@kernel.org
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	neil@brown.name,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	syzbot+8b22a0459202f76b4096@syzkaller.appspotmail.com,
	Hristos Nenkov <nenkov2004@gmail.com>
Subject: [PATCH v2 2/2] md/raid10: Preserve recovery flags on reshape abort
Date: Fri, 20 Nov 2026 12:17:57 +0100
Message-ID: <20261120111757.4705-3-nenkov2004@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261120111757.4705-1-nenkov2004@gmail.com>
References: <4d13edef-f454-437b-8910-3a905697303e@fygo.io>
 <20261120111757.4705-1-nenkov2004@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hristos Nenkov <nenkov2004@gmail.com>

raid10_start_reshape() can fail before it updates the recovery flags.
Its abort path clears the entire recovery word, including the
MD_RECOVERY_FROZEN bit that dm-raid requires until raid_resume().

Keep the recovery word intact when rolling back reshape setup. The
preceding dm-raid change clears MD_RECOVERY_WAIT on failure in the
caller that set it.

Fixes: bb63a7019df9 ("md/raid10: resize bitmap when required during reshape.")
Reported-by: syzbot+8b22a0459202f76b4096@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8b22a0459202f76b4096
Signed-off-by: Hristos Nenkov <nenkov2004@gmail.com>
---
 drivers/md/raid10.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 066c43154..1fd3f5f4f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4490,7 +4490,6 @@ static int raid10_start_reshape(struct mddev *mddev)
 	return 0;
 
 abort:
-	mddev->recovery = 0;
 	spin_lock_irq(&conf->device_lock);
 	conf->geo = conf->prev;
 	mddev->raid_disks = conf->geo.raid_disks;

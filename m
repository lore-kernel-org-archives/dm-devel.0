Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794574574;
	b=yZy/GDxFYyMyzX7OV2wQEZ8VZBAAHmvjhao9WggFjpjGBdE7eL5yK1VgessspwkcoEe8
	 a7WbS2a6fSOtkm3Vzsbdi1UnO4pEs8wg4ugiYN9TzIMLj4P8ajfBuUAJg48C4HA6QMSvx
	 2AgzzgGdie8i5Omrw9xQCka6AZQywVzovTSmWjn7Uo4zu6i/kUVQu1FqJUNMRBZckhzp8
	 4VGhAfxw8KlhhAcRhHXxvSJPPmsssv6nKEkVYa3XwEWMImvqru1QGno36L/Zk92CK1iPf
	 WloaF6OIxX6sSdTdOvWd39CrVviwdyO+XjmNFOL0TU/+Ai4IyKLCd2NclL+rkNjArxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794574574;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=o/nHhf64meJDAv8FSSXisH4IhMez4+rVUy1oWWkBLd0=;
	b=ins+uOfUsorECDE0txszc1jYxe0YjF1Ld8O9bJLqRXwLo+l9o3FAb3jDI9BpiQnGJKiM
	 PbOuocMXVHbxylbSc4V+vtSkBUyrpY6sZWQkN4J5Er9JlliUxMgK/LYV2XxN+idYUDbeQ
	 19DpGteYJqB697WqIJ2MLICoquOxkySyXRTA2jfEcSFYuvA/PQvzZ645dI/+dUYf7ufK6
	 vN7rrO82SZf0XR3aEbJO8Mp6wJwySRSbAIqMeSEJAIlsFFY3JbuHJYDkSrLSnPnLqtKQX
	 f0DQtCBqf99Lwwr2KsGsk90Xlwvc1uhHClXoT9hxlFutiVpRfxZLMOLEUS4wNL3ZQ6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mGP57Att;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA25C606A333
	for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 12:56:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA25C606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mGP57Att
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a78ec32fadso1684525e9.3
        for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 04:56:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794574572; x=1795179372; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o/nHhf64meJDAv8FSSXisH4IhMez4+rVUy1oWWkBLd0=;
        b=mGP57Attk4t9PAVrOS/zwWPoWQGhGwwZmSa2n38+VGmuPcHvxN00OVmeIQgyA1bJl3
         f+V80bhBmRk+kVkfNj2YAMm8RGYqjVUs/scwB79S1xO3WnNSsPKUbXLi2tdKmKdj/iX/
         lUu8gS907W7jaGnH6D0g6zSptMwiIo8K0j5/ZwvAX56bbqnXWugo29isx79kzrvDUb8m
         Imz6zgGCTZ9NwZhvnQZocjJzHbIkuayAosGM+AzCeCqqDI+LXpYCXDgg8idLcmR0cXGn
         Wse0S75lkqPwkZ2COoW8gAymFypMaKnGsKlLeh5vdwzQMxWyNAoyFWvD1lpsjwy/B4j3
         VR9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794574572; x=1795179372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=o/nHhf64meJDAv8FSSXisH4IhMez4+rVUy1oWWkBLd0=;
        b=rf9WSEiDSgcPlBABgwwxYORVjz2e1V14I5e1gqi2BqQr6AIB/rwnweTxALlfX2+FEh
         RFYQGlNQ5hOaHzNoNMAck5esYi3OJAJkJ0+X2sxqXi6wZ37E7TxDUBvHCeV81zzfwKb+
         W71mcxXmAvL9OTRySwAgT22SCAjbhTHpODFOvWqoEa2UC720iPEuQgbiOuJnWfZt5HQ7
         B6NG6jSKcFBr0FRP7jawkG4hi9BCMm6mJlqlq3zRZQ2Z9/M0cnyhWmYUHgmRhuVnM3I3
         djrv0zoPnotVWZI9tdI3IR6yRpZV6VidgDmDbKHG91ZMJ1olZM3tJImlJogJfEcujZLd
         W1Nw==
X-Forwarded-Encrypted: i=1; AL+hErGk7qUgQg8YXUf1snLcyLhC7e7jcs0tXDs1KkuVPuUhz2vhyXtuOOVw3s+iuLUgtEvYnGpucbE+3w==@lists.linux.dev
X-Gm-Message-State: APuU4Z/vZoCwTbPxtKzI6FGDuaz+yDb8efBJR698sXwaKlXryt4emYtq
	+aRpyGYDiP6NvNRf8GCRvZJbDIaeIf5wIoTRX5Mt7JTbK5N74sDc/aA=
X-Gm-Gg: AYBFou2hTY6+0G2q5rXGQpTY8lCEyav4A/tHqls3S79S58sVVxYXEkkyXJ7Vyvvm32K
	RfryXH/ZmVnDY2PnhoF363HqPdlUvBDbO9/iN9hZopdig343jK956GAf+QQv9ojUckvtzQE9FVA
	1k1iG9+hgqSuqgIS1WvNfs9w3kyhR+KNTkEAi0YpMW0TNASG8l+M9BXccCmHzee8NBzZdl0E4Lh
	Tl2K5Sm2/+7vM9JSz6GqU3ffjc5hKeLJ6G2fm94ieF5NAwqnf7elLuwX7TffOEueQNuEoCdLnoc
	y0ZLZuUixn2dlA6hWNMxIARuLQn8CfSfsnoeOS8C/2u9EzUjLDP8z/UY0Jo43hYWJ/wfx5DeWcW
	yRJqDlr7pM3auqhWpsraSsyPrLzfLCWgf5Uv9s26hUJIsESaZitbHfrGWuOQnipiiho9YNzeTCX
	5cJVgUpzQeWBTL/HV19Q/+OVTolwpd6u5ZaAGLZzu5fDUnn09BVVfysHais6ccKcGPPWTGJbHP/
	xzcZKgDalVaKE9dkAeRXBmkjXidqW6OmHHIEx8677kHPXgawwQ9OCrqSFyBkwWpRpq2OOXtSFY8
	fh4JT4oh6OWVeI5UArcQ42wrAI59bCJDqajDanQ8960ogkkGK44i/su2E6QTQ0H5a6rDRDy62s5
	oHum0n6CYs88=
X-Received: by 2002:a05:600d:644d:20b0:4a1:b027:99ef with SMTP id 5b1f17b1804b1-4bb55a3f05cmr41335435e9.2.1794574572244;
        Fri, 13 Nov 2026 04:56:12 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e28d0b2sm122206445e9.7.2026.11.13.04.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:56:11 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH 05/13] multipath-tools: hwtable: update Intel Multi-Flex comment
Date: Fri, 13 Nov 2026 13:55:37 +0100
Message-ID: <20261113125549.504780-6-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261113125549.504780-1-xose.vazquez@gmail.com>
References: <20261113125549.504780-1-xose.vazquez@gmail.com>
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

Identify the exact models.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 9c07183a..c9f12b26 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1035,7 +1035,7 @@ static struct hwentry default_hw[] = {
 	 * Intel
 	 */
 	{
-		/* Multi-Flex */
+		// Modular Server (IMS) MFSYS25/35
 		.vendor        = "(Intel|INTEL)",
 		.product       = "Multi-Flex",
 		.bl_product    = "VTrak V-LUN",
-- 
2.56.1


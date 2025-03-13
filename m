Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9C41FBE8F
	for <dm-devel@lists.linux.dev>; Thu, 13 Mar 2025 07:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741850278; cv=none; b=enzoFrLhr+ju2bAaqhDmLgWwYIFMKq6fdkF/+cmlSMzGL/rHj/rdv/VPae8spdtPBwI41IM2lDqGhrOBkI97jBGhjBpy7jocqUpffz238bfpdzF3nkIlQZN+vmsOQhoeEGfEPKjAx6APGPw8yxbVtvetL51GxxSC4bEPLQjqRmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741850278; c=relaxed/simple;
	bh=oAgV73aqIzre6z7Xw1xqjQZQRtMiceoTDIaT8JaLQ2I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xvw9/A63AsqDoAAaYvguedw+/dh1JBcunG7jZt3ttOg+LP56vAA6b0/NdEi9YsnSdBUs9T1zozJ8Co0i2XSbQJboJZEn/NReP5r6AxhB7i17JdeWVVzTxZoHZWWlTveBS6n1M3bePuKP0eA1YTwqVmgTXYVhIHUChRCNMiw2SAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E9DIoVkj; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E9DIoVkj"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-39123d2eb7fso32737f8f.1
        for <dm-devel@lists.linux.dev>; Thu, 13 Mar 2025 00:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741850275; x=1742455075; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=n8KjTopVh8GfFMbYhsNTsg8XSpE4Z9l/HdEp5IJi6o4=;
        b=E9DIoVkjVR8ZVxyxdAcjI8tyaPbeiuqpBRo64ITuqhcyh119MsK+y3fdWphIXMumfF
         z72OfoGnTi4cY8CgyD8Pebhmrw6lDNDKmgCsu9OH5+U+Wnbynkx2YjhmKJgG93i5Aw+d
         s2Ohq9tUQygK19q0/NHc/Bh8N6w1PoxIDVWEi+uy20D8Joq0FPXMMhDeCW16n2aisIf/
         TgINLQ7CjqoDLUcpiNcEbSh9iWKvny6bFsh888oVE0CfgqrBu46d4ULQSQuxoqP87E6M
         Hx8VFI9cNq19EFZ+OWvoMB3VxGvoQVjfqJaWFFx2LXSkC02gLEzjdHw+AqX32mNxn1Ay
         gNLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741850275; x=1742455075;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n8KjTopVh8GfFMbYhsNTsg8XSpE4Z9l/HdEp5IJi6o4=;
        b=disdWWJdgTLUTAlyzeTLv3jexbBYiXVCy71NqavSkXz+ARqYuHqoERnu/+pQkK+zSq
         8xwtKOTmKTu1sQ2Mm+HseIicBcN2ETeznvzMSUaJZnCbkLWL6d9ze3slf1GR5rgBjiEw
         mktYKX2ZIlgVG0QlN2po9Cp6ekikN0hdYsdL6zUJH9cuG54TeKSp0yAwEeGDGCw+qnxy
         08GVjPyFL2FVhfTmGYYfOLRdkLoi0LW9OU+ARFT02NAEdp3xhnj2/mon/+JfQctX+dpC
         m+GnNQnykGwToKn79uZi79gLTglJTZo964VrWbrRTGWz/mC3SW9MgN1rVyvxosdzXbUX
         LR3w==
X-Forwarded-Encrypted: i=1; AJvYcCXw39wUymv+30WJd7jzw5LWnwrt56f59If72F9OBEj1KMlBOTYXSTHvO9YuZzOc3Iz5icKiDJ7rnw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyluASc4flBl+Xgkfckomn6OU48pjBDarmHmWu5CwZjBdfc0nhi
	of62tXk7FEaPEOGkxRCn+t2boqpDZxIts2kszQFUb0LvTMobOpk=
X-Gm-Gg: ASbGncu6YwzGVSMFs1QzaGb5UoWdh2VyRBXLbKgJ1Bv747GBFk+R87YU7brFg3HzYRT
	UlAugPvT6Sa+H0oB2iQyttrfMWotKLRDVMYxKVL9CuDvOfum3Kj0Sbs0CMWlWA1mZFRQc6sQ2iH
	Zd+J/wKAJpyeHCCeOVev8DYIEGlGXPJkdVJuGTopNwcTzugbMV37/JGZfeuSx2k6ct4bhDgrrM6
	ZTdnOPKgKAP88H57aXpEfovEQWLCFLS8giAyraK4DDYpGA4ORUmzBVBQSaXMlwT5tALAsMQPZmI
	2Bwx+/rC7AAJYOMaHyYf/R2bKeOw5BTDznTZ0lFkY8/Kyxv4ovJ+A/gDZb2OVo6wPFEi/BAYLw/
	0wRGY3ZTchGAa
X-Google-Smtp-Source: AGHT+IHMaX7f+MDT2yurFOk/u/WBOPs7RcSfkfZFDFZ1+s0BdRL7MGuz375w6wO4zhM+DExxy3WXZA==
X-Received: by 2002:a5d:648c:0:b0:391:1319:9007 with SMTP id ffacd0b85a97d-3913bb4810cmr5995837f8f.5.1741850274308;
        Thu, 13 Mar 2025 00:17:54 -0700 (PDT)
Received: from localhost (242.red-80-39-144.dynamicip.rima-tde.net. [80.39.144.242])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c83b6a27sm1128679f8f.31.2025.03.13.00.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 00:17:53 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: identify more arrays under IBM/2145 ID
Date: Thu, 13 Mar 2025 08:17:51 +0100
Message-ID: <20250313071751.345627-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Add IBM Storage FlashSystem C200:
https://www.ibm.com/docs/en/flashsystem-c200/8.7.x_cd?topic=system-settings-linux-hosts

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index f8cf3fa9..8001d5be 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -659,7 +659,7 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		// Storwize V5000/V7000 lines / SAN Volume Controller (SVC)
-		// Flex System V7000 / FlashSystem V840/V9000 and 5x00/7x00/9x00
+		// Flex System V7000 / FlashSystem V840/V9000 and 5x00/7x00/9x00/Cx00
 		.vendor        = "IBM",
 		.product       = "^2145",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-- 
2.48.1


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794574590;
	b=J6fIOBFE6EUNxulIrQ+eZGc0TRoidVwDMW2Cs8X9OR0i66Ve08+DYv4HrksTPcwQhISH
	 3io8BqZhm+0fknRoJtrZbffZmypkmUjJ3G8VzdJhv1usap8fsm7yZ3gkITmjKK8UxMaXq
	 UPG1/c8gnbx5K9mLctBZ22xDYwfWqWbJ1+esIcSVW8B51zsh692RwQ+6GbWzmD/Zms6Dm
	 B59+xb+EH5ge6E282TK4E50Tdpo+hXH5aU9uNh4YcMDbmyr1lRRsGKvzXNkdgBTHAvJmX
	 NdzOxJhzcUBzFvMsvdieXv+x1a6e0WwMHKHiDR27hZc3VdhVKX/4NQYWochRDna62PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794574590;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=UlMcgI2EmcufL7qphq4S/oFi9WERqbY1vVFzFlkeUkU=;
	b=V9SnphU9Au+f8H74d3wFfsT9MHjKW6TLGtr5JrNp+7lFauonTEqvrnhdtQnwDK6eL+fg
	 YUq/OBFzS9j/06X5MDHbUKUX09ge7Z2zYmHVHWRN2XHo4vUEOJj9khoioVQH5bBnGjFTL
	 Z1og6/BL3CwMvG4DEddU7XCbBwpfEC6669cWQdFbK7PPpz+SrNw9ECs6J640/9XWGHDkq
	 xv7y6m5EXWfcPfLm+EitF0VtnXXZr3xxehMt4Wa17S37uxxEzh6mKwdHaP0mH8xRjeOpr
	 VUFrQookC5ZQ13JWijDFDGMRFq/t25ARUI1ZlN1bgg7++FGeSCqFfelFkBNofra7Lkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=M+NiuPqO;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D782D606A327
	for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 12:56:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D782D606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=M+NiuPqO
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a5348aaba5so1498525e9.0
        for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 04:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794574588; x=1795179388; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UlMcgI2EmcufL7qphq4S/oFi9WERqbY1vVFzFlkeUkU=;
        b=M+NiuPqOBGSGftXl3XXwug+NuV71CBt8jix3LhIDuIN2SZ9bpQUw/0tH7zodCb9cJQ
         rM2mOvBfoDoCJ7iJKgaZM2Pcy/rvlWMvgwMr36pW8xxP7IW291gg4tfw4fPg5QBoGD6I
         wRwVsFSKYYyf2SiEVZoJ8o5jSzwkP1j+lqAwC+0fTtYGEEEPgU8ECndLnsW6ff/1cXKB
         C2dmsdDDW5rH7wZ9BqRngBKXKaEODmUaU6EPaRjG9WfFGlbqKMYe9nOBs9Q4z66gbR62
         LWkrrW8h3yOYA530+aq8YVkKA5O5mgNChS6L26zDVyRqfGY47CiTCBW3fzXISjoRovh9
         o61g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794574588; x=1795179388;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UlMcgI2EmcufL7qphq4S/oFi9WERqbY1vVFzFlkeUkU=;
        b=2eXEntf44z16Hq2zKiHy+si8yWyTUTfrTrXaF2oE6TFuoCJ5kd5w3uGU8EnFrHKWlO
         8z/3JRP88H4qKcK2MTQ4LyKp6eJPCPlOtAdgOQFZovmGCIAc5UgDs4asUPObjtkIduJr
         NGhAnh5wpmutUCS3CODZLuUKF2mbIC36hIBV5fdNLhH6GL5BoaSD7OPtFGfectyOIuuk
         5vDtZk3VzxVhY95NXcH2rsYQLKS+0hHa2FHqOCwNYjH+IqgbtExg9shBR62aYFmVoTW6
         Q1zdY2yqqdpz0M5YhGY6LM5qK7Y696m4TTdAoo2AfwV7wgD78CC1//9LslJIKOzVVV5u
         BLhw==
X-Forwarded-Encrypted: i=1; AL+hErF0Mt+YzPJTgOymCCGuid8ys66fCYFHky7gTw9MRglKFBcZBQ7Qhi8jMULwxZ2RYl7jSaFgsdSqdg==@lists.linux.dev
X-Gm-Message-State: APuU4Z/IM8LOOY+Ez34hgEnN00JfJ0ZZ4Y3S/MQe/4ckI/Cz0oU6UShQ
	nRscvrfHXPe6R9C/veoe4lfNhABgxpDbUDBzsUCeAIwNvWNWV91gASA=
X-Gm-Gg: AYBFou0LnTHImLhdIByAx2Nc7saMhfrnhE0iHXsp9MVsCxdN0+6gIsl3veGb/8iv++m
	eteBIuGwvg1BwGgS75ePkYkKeAZ4xMkiXx+4Z7q8e/rlohKksxNtE8oBfKtY1giPdPZk3Xz8klC
	RbX2GJFI2cyunH2D+uOnPT+3mXysKO7opcgxnv7fLA36W37XIRFii31kL7ziQVzx2w/NpD3UEVj
	EGjxS10/EGxCzO7813b72KsKLyDfuucGngVcpK464l2P9zO0M7x5NvpmLKEjnF1TdtdejSfJReK
	ZIpV5l06uYYNkyYitue0KTx6Y3lLqGdde8WExiMq44vRKvnLY2nRebhB1bzczQq8xnWCvM93yMl
	Z+YR/T4OOTIum/+SbUzQcW74MrqGAyMbFKSHk6ZhaNUx8ZPccXUqmvtNV7I+v2Dkyv3SSpOt22Q
	SO2TCBrKygp1lVFEffY/+EIChTq48AQ/KZNmsZEkA561DLdG7pS2IWVwnwd18njoaVWHYHWy3Lv
	KtMSvMEK295iYfmRglaf8epmEirEoH4B+x1JDUoR4xjckQA9FwWpbtXSctRwzfG5OUjKEedTxgP
	Rg+rbcwCmljxi2l8i7O+kVNuEtMA8XSC31WwfMLmwHTMo38E38/XM0hGfDOlh8yqzH34dcfnJBQ
	0sk08qvvKaeA=
X-Received: by 2002:a05:600c:a209:b0:4a2:417:7db5 with SMTP id 5b1f17b1804b1-4bb55a55f27mr34285885e9.2.1794574588087;
        Fri, 13 Nov 2026 04:56:28 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2538b9sm259078025e9.1.2026.11.13.04.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:56:27 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 09/13] multipath-tools: hwtable: update IBM arrays entries and comments
Date: Fri, 13 Nov 2026 13:55:41 +0100
Message-ID: <20261113125549.504780-10-xose.vazquez@gmail.com>
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

Broaden product regex patterns to match the kernel (scsi_dh.c) for
DS series (DS4300, DS3500) and update model descriptions in comments.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 41e7e0a6..89ff8a9d 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -539,7 +539,7 @@ static struct hwentry default_hw[] = {
 	{
 		/* DS4300 / FAStT600 */
 		.vendor        = "IBM",
-		.product       = "^1722-600",
+		.product       = "^1722",
 		.bl_product    = "Universal Xport",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
@@ -561,7 +561,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
-		/* DS3000 / DS3200 / DS3300 / DS3400 / Boot DS */
+		// DS3200 / DS3300 / DS3400 / BladeCenter Boot Disk System
 		.vendor        = "IBM",
 		.product       = "^1726",
 		.bl_product    = "Universal Xport",
@@ -585,9 +585,9 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
-		/* DS3500 / DS3512 / DS3524 */
+		// DS3512 / DS3524
 		.vendor        = "IBM",
-		.product       = "^1746",
+		.product       = "^(1745|1746)",
 		.bl_product    = "Universal Xport",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
@@ -633,7 +633,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
-		/* DS5000 / DS5100 / DS5300 / DCS3700 */
+		// DS5100 / DS5300 / DCS3700
 		.vendor        = "IBM",
 		.product       = "^1818",
 		.bl_product    = "Universal Xport",
@@ -669,7 +669,8 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
-		/* Enterprise Storage Server(ESS) / Shark family */
+		// Versatile Storage Server (VSS)
+		// Enterprise Storage Server (ESS) (Shark family)
 		.vendor        = "IBM",
 		.product       = "^2105",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-- 
2.56.1


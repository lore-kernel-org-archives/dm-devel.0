Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692F637F00D
	for <dm-devel@lists.linux.dev>; Fri, 13 Mar 2026 23:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773445653; cv=none; b=gn+py9Ao+GA7z8vemr+kMq9yXAq7JmTh59yGq/QW+++SGYggsZy7w6FPAZCln60SMTpS0NMlzgLeTILmEbHIbZitqWwj6efnSm1MX7ReCSg6zqjEXHqGGkfHbQNDosHG+nWpXiGfbOTZ2Ri7kDktV2j54J9lcYZguIiVkBOu+G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773445653; c=relaxed/simple;
	bh=ZFzggHBQ/tbZFi86xpheMlmtzRIRrVVhVWtsLkvu+TY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EH08TXruutwcGwFoP0YgFiuLBuadKQgdwP/4ZdOctnAbInYwI4GCIdRpwoIpv2emKvwp0ZK4lmKadBIj6tz4SXWTuYaHYY95ZIn50FwlMP2bWULDUYqRwo9jIS1H2aumhZTWAVtAW6DrH/4OEybP/CZ1K/fUUtYIWTuKZbBKlKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HzAqc5Xc; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HzAqc5Xc"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-439bc832351so306381f8f.1
        for <dm-devel@lists.linux.dev>; Fri, 13 Mar 2026 16:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773445651; x=1774050451; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nHY/jViQLNKqHjdX/hnUpKsMMiB6V9oZ9VZzsGnz74E=;
        b=HzAqc5XcRCfSJM9aJ/X6tQB433L/IYzq41MipnwU2zq1WdB9fmvYxs1l++Zh506csU
         YoZy7WPM2h02dN48k4lhMX8LFVpdW5u42Xz8AiLxv/dJPxM4iNKNWRXH6hsOPS5o/mRX
         u669INR6cXJtGV2EiSs48CiLBcYOaWfWxzcro+wXG8lZifqk4+BZweEo/iEBNZEaWcRe
         pDvKmICbrCUgCKXHqm4jaPP+7UxLgPCbAS/UyGJGI2T1EnSLTzL4zb6z6gG6BOJFI8uL
         scLDg18/3BalCxrgTBINKwS6Kd5k/KN8XMgRFqLvSivDDjGXQ4x2+z6Sh7zBf8b7y/LR
         15Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773445651; x=1774050451;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nHY/jViQLNKqHjdX/hnUpKsMMiB6V9oZ9VZzsGnz74E=;
        b=nh5i8h/bwIVlruhCW2dh6MU8PtWs7w8UQe2Viv0sicUo9MMz9IKovjCxRK08InHIS7
         YyxvVUr/usL0N75zkJ/cltGTkVpbp/KVjOkBlmsUJEoq65qToYbhQKc7egqT3knX2xQR
         /hy21q8AOk9c76CKZxvm1cm5KJ7lEuB8nBorPS92T/bo3YdMQbUcpnVPcx0xFJLOB7bW
         P8oXbS2RobXnYZYUDAfZIR5nJmHLyJ9BcdX99D+lbfwuXGoklFzCVK48MQGSZO1GRda/
         cj5JrVsjtQynIYk1SPB4ExFUeYuneH29Yv02YKeY361CuqzW5j2JyLDJNTNpU1eurKvs
         iQng==
X-Forwarded-Encrypted: i=1; AJvYcCW5Qj+vUQFaTmVWWjYbA6KCDJiJOC5asYUGETzVRVGCBQ5cJ9bQvXxQHnskttzDRgN56h6uTGvafw==@lists.linux.dev
X-Gm-Message-State: AOJu0YycVoU6VEI/PB+oRwO9yEVVlSf0ujQi5/kDKYM35kS8hpxI2Sfo
	lHGTdMDVi9lfsxWZm+lQcRkLDnfjgw9hUldAQ1Y2GidbPehAMMOwhvzcDEHh
X-Gm-Gg: ATEYQzyJSnMa2z00RJeCFucJJYWsX1s8SHP6BwDfyYnMJ1Q+pVuf1G1CvR4T4IXR7Ov
	0Vsxh40sM03nhSDJwXEPP/OoENczHiqf3pGC2J2obKaosj+s1p/N3tJY53oX7F9CH4ILcw8V7ar
	NpJIuNetqAqdzfUTGM7zpXLRSFzbBoClBSQWH2PoXn1viFCUxGf8YaJmsELE32EZ+ugIuX6cAnb
	UpRfVqZ3PRID5HTsitdeoF4Sc6DY4VUB1N/5OvB7hflectRGN4R9BsALe9GYPXZxGZgmahLTv06
	2zR5TSkOckmvexeO0OVGNvfMQAiG55PgH3j0CKsUcNVaJZ0rlJQi4fj084e3Joj/fNDfAIP5j3U
	rguwzHZ3zBQUt00cmIdV4pIUmWo7VLO1ohkbKXGeFisaYXksH5e8sQax5M77wblCWTS8wXhhi4E
	jXg2x66ndDUdh6yuc1GvpjJMmJ8voDoi1eDGP3IeKb+8nyeB4ya7qw29Yn8J/4rHhNdkzbdgQ=
X-Received: by 2002:a5d:588f:0:b0:439:c3d1:a38d with SMTP id ffacd0b85a97d-43a04dc0bf2mr6200568f8f.5.1773445650417;
        Fri, 13 Mar 2026 16:47:30 -0700 (PDT)
Received: from localhost (99.red-80-39-36.staticip.rima-tde.net. [80.39.36.99])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe19abbasm19785742f8f.6.2026.03.13.16.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 16:47:29 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: add EMC VNXe info
Date: Sat, 14 Mar 2026 00:47:28 +0100
Message-ID: <20260313234729.85854-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

It does not support PNR mode. Only ALUA, like Unity.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c        | 2 +-
 multipath/multipath.conf.5.in | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 23c54933..55fca0b6 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -339,7 +339,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 	},
 	{
-		/* DGC CLARiiON CX/AX / VNX and Unity */
+		/* DGC CLARiiON CX/AX / VNX, VNXe, and Unity */
 		.vendor        = "^DGC",
 		.product       = "^(RAID|DISK|VRAID)",
 		.bl_product    = "LUNZ",
diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index 84cd1a0a..8a9bb6f9 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -533,7 +533,7 @@ Issue a \fITEST UNIT READY\fR command to a SCSI device.
 .I emc_clariion
 (Hardware-dependent)
 Query the DGC/EMC specific EVPD page 0xC0 to determine the path state
-for CLARiiON CX/AX and EMC VNX and Unity arrays families.
+for CLARiiON CX/AX and EMC VNX, VNXe, and Unity arrays families.
 .TP
 .I hp_sw
 (Hardware-dependent)
-- 
2.53.0


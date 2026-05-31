Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A7114A619
	for <dm-devel@lists.linux.dev>; Sun, 31 May 2026 10:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780223912; cv=none; b=J96VJaf33jDWliCJbpRAzoWjFubPeWMCc7aELNy7gbQVDNCqAXJtK6wyEEbozuk1aHae/TnklZ6D7jbxHP+3KtcmE57U1JW9qxuPUau2Enl0qC1LspxqYs29KSHJiB+TCCMRF2ikbmSJ07e48WwC0Lb+19RpUf0hoGBL7aytpTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780223912; c=relaxed/simple;
	bh=3hRTfETnVN7gBxlc4sDR2rKxjYr9OCGJ4qnma0LQEks=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dYhfcPQN2BQdfgpy//d/QX4fAmd3q+uj5ObuPlA9AhjrTMhc0yN2lUBNJlK9f8y1pCWK4nv0zPhIkJuDOHpOH50ysA259ejlkHeRVSaSE/4VBpbuGevjYTvvUVSO7gcnwBAeHvab2IxEPD/8Fqwtll6sXDtI+CHh8z06V1RPOXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R2MNK19m; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R2MNK19m"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-45ef5b33e73so149187f8f.1
        for <dm-devel@lists.linux.dev>; Sun, 31 May 2026 03:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780223910; x=1780828710; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0qoZ0dylRmAwe3rfUr9ZXx+BDfL0uT2ldx0xre/MYsc=;
        b=R2MNK19motkzupRfon31ZJGNE2lDnDt2VolyheogHXUgm76zHMYV0h7sg9jA13F6Kl
         7zIKWVvlPojuaXIvo7xJXaO20+YcbKmIEGTzzYfWU7wFgjgkno9HyjIYN3ftXVTEuafN
         hYbWEr2I8kVUdKYGpGswuaQE9M96YpsuDs7gcOuV9RAvmwAPqphkrY9rqMXQm/SXIKC8
         UaGfgDG8p5xrAd9JpmVXzNfwQC9ImLakxrUnuQVQ/WH7864s7JykLVKPK6qH//oyD6s4
         doZrs4oE2Om/odtEsFfycZUxcHW10KNqO2alv7j4DwDBOsw3Iu5lZOnLoZrCsY0PM7rA
         erKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780223910; x=1780828710;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0qoZ0dylRmAwe3rfUr9ZXx+BDfL0uT2ldx0xre/MYsc=;
        b=bYuKB4g9pLXEslfFddySFp0XkFFrS5IAxetDH46yj/SbYFCMZR507NSiRLwyNCerHM
         Ju8YELmt+nrkGgDdejzMfCd7r++ENEUIxALBiwZAe94rMrw9/PIOVukMs/8wWo6aJKZm
         TCv4roOVmA3ZMbe2lNh8loT+3Ei1Fi12NmN+vyOuj+sZFh967V6S/CD+xlauAyK1od99
         /tTpmNII5S68C3vpcRSZ2b+9sDGTXjxdfZHTvQ6alv8h7Eyhz4SEPWyscPvbEcSoakRL
         JYB30dvNYomMFNo3BDN+dBKZFkJtxR+ATnIRiittH19LLht9bYWZXmUdbnYkerDNF6Tq
         9how==
X-Forwarded-Encrypted: i=1; AFNElJ/dCGwVHXVzNUAuYVU6T1GyCRw901zF15vCb04mo/jua6VHiANI1zr49lOI47z4NS0XcNufOuQE7g==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywg46OdDNf8t3ti2Aaj6uYoy+erIr+45epUbdVbwYrpN94ba1aS
	LLPfbx5aJToEvCOrP+I1AEjnc5kbCYqKUX23A5m+RP8lMDzpd7GDWvo=
X-Gm-Gg: Acq92OFin+bxLdHFN1je+zjwHjKgUYrZ9p8g8uOf1jxDL0JgJGyg0jWMpCUUvCi5dt5
	wGeiyiGHXb3ThOYgvRINnRvBFa+P646XDsekmdHY6HRTsbWKrIOIpdvNjNIFIbn97H84KPAEXBS
	r9dN5ZrmVWIhNYwfaGj5edkUIgHXJFt8DI9h9vPgZI67oahQHWQcVkQcZydvPwZ9MNnXO71c/QS
	r5p1BsyW3y3e5TlnhurkAqQc9re2po8KjCy8D1gTpUML2pZva+AOX+xaDHyXlZgndlk1tEYvSrL
	v0+Lery5hFhF1ltOsRmM3XfKDGPCIeuFx/El5PKP5Wy1UCnjKv5GYHPbDO9+xh7w/kjo4qj3uhE
	f6oOJomuFj1RN32BMaTesdScox0BOR3DotiG+8P9glj76MJY0uOsczUid+ymVZvqtLwM4yu09cB
	h4WkQ1EIcMSoLgkDYM7FyeusgVxr0shstPNOxg0nGHVwJHvMPBQLlDsfKRR06xZMiDHCV4jL0=
X-Received: by 2002:a5d:4a85:0:b0:45e:f45c:537a with SMTP id ffacd0b85a97d-45ef6bc15a8mr3622588f8f.5.1780223909623;
        Sun, 31 May 2026 03:38:29 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef34bd320sm16087934f8f.13.2026.05.31.03.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 03:38:29 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: align ALUA state strings with kernel scsi_sysfs
Date: Sun, 31 May 2026 12:38:27 +0200
Message-ID: <20260531103828.23549-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Update ALUA asymmetric access state descriptions in the prioritizer to
match the shorter names defined in the SCSI kernel subsystem:

   $ grep  "{ SCSI_ACCESS_STATE_"  linux/drivers/scsi/scsi_sysfs.c 
        { SCSI_ACCESS_STATE_OPTIMAL, "active/optimized" },
        { SCSI_ACCESS_STATE_ACTIVE, "active/non-optimized" },
        { SCSI_ACCESS_STATE_STANDBY, "standby" },
        { SCSI_ACCESS_STATE_UNAVAILABLE, "unavailable" },
        { SCSI_ACCESS_STATE_LBA, "lba-dependent" },
        { SCSI_ACCESS_STATE_OFFLINE, "offline" },
        { SCSI_ACCESS_STATE_TRANSITIONING, "transitioning" },

This unifies diagnostic strings across the stack and replaces the misleading
"ARRAY BUG: invalid TPGs state!" message with the standard SPC "reserved"
designation. These codes are explicitly reserved for future standard
definitions rather than being treated as malformed states.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/prioritizers/alua.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index ec68f370..e9a0683e 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -31,10 +31,10 @@ static const char * aas_string[] = {
 	[AAS_NON_OPTIMIZED]	= "active/non-optimized",
 	[AAS_STANDBY]		= "standby",
 	[AAS_UNAVAILABLE]	= "unavailable",
-	[AAS_LBA_DEPENDENT]	= "logical block dependent",
-	[AAS_RESERVED]		= "ARRAY BUG: invalid TPGs state!",
+	[AAS_LBA_DEPENDENT]	= "lba-dependent",
+	[AAS_RESERVED]		= "reserved",
 	[AAS_OFFLINE]		= "offline",
-	[AAS_TRANSITIONING]	= "transitioning between states",
+	[AAS_TRANSITIONING]	= "transitioning",
 };
 
 static const char *aas_print_string(int rc)
-- 
2.54.0


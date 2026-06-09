Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F23216DEB1
	for <dm-devel@lists.linux.dev>; Tue,  9 Jun 2026 00:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780964551; cv=none; b=sHPB7AyvhetODsFOFt+e8dr1Rpouj3dkftiChbsaPYSWGoBsmBZfXLI+N8YKEnLf1TOtIIe3mHgtnKCaYbLpXp+tfSvRBjyjo9r0b9b9eTvfwzyJJH2cATRybZDC+t6/VWJm8FK6R8SHu2rnx0cQOFk1/dJm8kUeTa6DlFd1XnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780964551; c=relaxed/simple;
	bh=QzlAAK9zqmjoIEqN+qrZd/zDkemNBwhyHcxQhtlWCPg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hg9BrZMcNm6HN/qjOUt1Qwhi9rwbvur0lhliQu6v7cFTFZsXyLdzCrJfktNlTOVwiPuQ3RXD3Akf4rUMLjGLZDXjwmwHS8I6k0DVZXfMdpRps0XnmMXFxmjNxfE/uCtybVL1LiTZ0aUf0de8uqNZW35sTjAGYI1Sxw1LVHfcKJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=Wy0Teq9h; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="Wy0Teq9h"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-517654b8e28so37525761cf.3
        for <dm-devel@lists.linux.dev>; Mon, 08 Jun 2026 17:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780964549; x=1781569349; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hc3yj1WTIspwM53QcxFZvLWS31Fa++slWtpkFaH+iPM=;
        b=Wy0Teq9hDTliYZ0uGEq1aGq+nBPiTEySHEv022C7GhIN/oMnATnPQXP3TFOPXMPnYa
         FUpHRUe69plqaT1lDhVsBPGhMA5wa0aJCY2r+D81KBfHJk7FPxvvhh+hWEP7zq/SUDaW
         j1AwfkJSVlfdFLtAjiLQql8R4DqHpsMV55PXsNjjJcrZvvJ5vzi6Mk+58tskcLwFApOT
         jfbHfD8nkp4Tks6/hsCOmeMW9bwW5Wwg9wBaFFEczx2jpgibWLgiF06421rnmqfZhaxY
         TCpY/Ps3EsAuNMWiP8z2b9fPhoWB5mbg9EabSdAqKVqPDgBcMBWlLGt7ywo5jTYO9AmF
         gijw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780964549; x=1781569349;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hc3yj1WTIspwM53QcxFZvLWS31Fa++slWtpkFaH+iPM=;
        b=n4+ZbjjTtoh+//wOPFJNkqbVbA+hgLeGSi4LPh7MdoqpNOPrtP3LwrnBE+bDlXeF8Q
         geUj5+RC4lcDudOtw0Mfnd8DhW0mScRZvNu72NWQUrueZzoJQGOZSwod7UeR7bu0tqJy
         T64Ib7pCTAb1CpTOLgDymTeXQ4eikl5sG02cTyJLp7ZtbyiMS99ixDV+MPoh/8eUO/YL
         hqf58CREIYu2XlzDycDc7vCmRIIXbaDyQEuy5oKpMVSigeYlhiN/57phTTXrUt4CK1WM
         5KOSbgo/hh4nU/ixXSP5+2QbDZbMQ2A18AtbdvAPymTmsChVZcRTmbNhwy7tDzFlSptd
         /2WA==
X-Forwarded-Encrypted: i=1; AFNElJ/ZpIlmEUSnDA2D8RHx754aqZEPQ32SQlAOlvyMYjS8M3zjj2i+PVk+R3Fwn6/VJeXq5YUjCUhcUg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzRc6i6GJGswefyRiIPG3DcNwkuLHPlE8exgd/pUGkSC4TgjXjx
	KASd62g9puDEok4MlV/1JrPdtjbcLnkaAwXr1d4O3i/pASVURscI6XCrAO0zTXh4xOM=
X-Gm-Gg: Acq92OGzsUSAqBdisjNszImg8zLR8W0XdQU73lE0AMvEhiAjfrcDqGGYvegiLMH5f1J
	2/cj7bfHW+yNahZZDHcVyIyNyfdoWQBH675pWQvEXihPihWM7BnWQdXjYkiUYV6DFXsoLlmor0Z
	Kq90ClMJFx6e4vqguAhK8FEzegRmH0vyIQ1bgNDxg1T1cSLB1oBpLgxAoKib8ZLBAOdqxFHQ6TJ
	9v89ynh2Ka+OfHJUGfDl6ow6R887A950wb0coYJenNPiFT/2Qabr/3oUC2941N1p3siMzlebEMW
	tF04gSdm2wg92bAAspExjkXOenyb4IsM6sCQFyxxGqcHUOU+rOHY/00sSrWDjdmaOI3PDSfrAql
	jNIwTniqcepRNJ4DuR3/4kKOGdTmqZqom7CqL07sqlOqJO4oqqVrdKR/iYG0tEL9LsxgMn7TjlK
	QprqZFXZJOP7r4XbOKsF2YKqVEh+BF+l1RjHd+Ng==
X-Received: by 2002:a05:622a:1e14:b0:516:e39a:8540 with SMTP id d75a77b69052e-517ca609a24mr6777491cf.48.1780964549562;
        Mon, 08 Jun 2026 17:22:29 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-8ceccdcc968sm193340976d6.22.2026.06.08.17.22.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 17:22:28 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: Alasdair Kergon <agk@redhat.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] dm crypt: reject odd-length hex keys
Date: Tue,  9 Jun 2026 00:20:21 +0000
Message-ID: <20260609002020.1235936.a71557e606cd.dm-crypt-odd-hex-key-truncation@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm-crypt accepts hexadecimal keys with an odd number of digits. The
parser converts pairs of hex digits into bytes, so the final nibble is
ignored rather than contributing to the configured key.

This makes two different table strings select the same key material and
hides configuration mistakes from userspace.

Reject odd-length hex keys before converting them to bytes.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
 drivers/md/dm-crypt.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 608b617fb817..a5ae34cc42bf 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2558,11 +2558,18 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 
 static int get_key_size(char **key_string)
 {
+	size_t key_len;
 	char *colon, dummy;
 	int ret;
 
-	if (*key_string[0] != ':')
-		return strlen(*key_string) >> 1;
+	if (*key_string[0] != ':') {
+		key_len = strlen(*key_string);
+
+		if (strcmp(*key_string, "-") && (key_len & 1))
+			return -EINVAL;
+
+		return key_len >> 1;
+	}
 
 	/* look for next ':' in key string */
 	colon = strpbrk(*key_string + 1, ":");
@@ -2588,7 +2595,12 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 
 static int get_key_size(char **key_string)
 {
-	return (*key_string[0] == ':') ? -EINVAL : (int)(strlen(*key_string) >> 1);
+	size_t key_len = strlen(*key_string);
+
+	if (*key_string[0] == ':' || (strcmp(*key_string, "-") && (key_len & 1)))
+		return -EINVAL;
+
+	return key_len >> 1;
 }
 
 #endif /* CONFIG_KEYS */
-- 
2.43.0


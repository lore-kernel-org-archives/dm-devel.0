Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EEBC156
	for <dm-devel@lists.linux.dev>; Mon, 12 Aug 2024 19:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723490024; cv=none; b=O1gp7ulEuxi4URLTTEznPjd+t8r2sycheFToW/yQFfDBEbDRLIwYHpMq6llQOg+UvSpnY3aKKBoXezxpxmgVlax0WRfikD2BW7KY02KwI9HRz/bhpMJzmAooJzzJ2du/F2NBMr5at5qxRgldVEwolGYE7x94QxbnEG8RWxfmleM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723490024; c=relaxed/simple;
	bh=uXutlcaNHk7eSVA2aFnCiyFf66uctLkjeJOsZtiHXk0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pvHwoSSzLTcsIX0/Uga3eKPjxuoWMwaAQcKlrnLoHVUZMUwjgbJelaCG74uuIq/k3zPHoFJuyT7ResurCf9LSZbfxPqDLo9Ql0DIg6WQ6oE2nPMb3quT+O0ZPMAs5jAnqwP2S9W/MH+uVxqPnUFJcURmg2KSR7mtL+ZK41EiklE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mST3zu2U; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mST3zu2U"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-369c609d0c7so3340433f8f.3
        for <dm-devel@lists.linux.dev>; Mon, 12 Aug 2024 12:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723490021; x=1724094821; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BBislmUkh7zm0mpkTc6hVg8PcphMtgEqYxchgcUMz/4=;
        b=mST3zu2UdZHfDW/vGPmH9MhqUIVUx0YvET824ZsnBiq6oibo/nUaw/Hxw8rUHqi43P
         /ry+dT8heDnT8P4oKJFFopkPWEoXzYD5xh36P3qhjm8ncD6aguzT/YSh8hf01WhGyw+4
         IrI3Tf6Ph0grCA6wO1GuqEJbL470SasGiQxWjI3jzAiulkoAsHajoUCeeBIsw4X9yfvM
         /P5ee7ONSqBwLz2XNouIYEGMCw1q/DWBfpYVRwMuSqy+VDXJ1J12t8p1IMVExAF8MbqN
         aSZX7249oGi5FqriNoVnMRwsYpBBCyce0v6yZQuPwEvbYb3tHYyVZjjaE5cBNhJTLFPS
         s0GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723490021; x=1724094821;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BBislmUkh7zm0mpkTc6hVg8PcphMtgEqYxchgcUMz/4=;
        b=ofxqDq0P5ltbM91hOaafX783pzV96/3OhavEHBfcpiuSWlJtoEvSW1jG0XhSY3Z/Y5
         fpzLrbqQad1OvHKBZUte7P5Dh4kG3FjfYzo8eyGt+64v5kRT+D4mxHnEJiZuSfLCNnq1
         OKW9nktNGxKxHKSTY6lx4trUVkj24Vs/a2xGWnnZLiofRp9otSAlAxcahgq0sFtkaoyS
         UX2rWG6OABe/kwjMvgA1VBDnG/Qckg7geRzeokhzUTkHJTYA+zAv+Bk+0dWs/1R02b03
         ObN8oGsYiAuIae3p7U9C8ih9rT13zBEsfqgpl5VEwGQE7T76DOibZm8pppbxPIqaAf92
         Z5kg==
X-Forwarded-Encrypted: i=1; AJvYcCXEJj929npR+Om4z5UT5ep520CsinOJb0xx8+RVfLjBJF+w8g6EJcrd8Bjvh2xpBJV1ObT57Cp1vRT6maeXSppXGDloINmfWlU=
X-Gm-Message-State: AOJu0YyE3H+w/CgJ9N3rjPDZyUMgTgBxd7VtqOs0Cl/aTCaZIzG1hKzj
	zNM7bAnBBoAaO95k8IXcdrrLAoa3QgZR/kpeMvngDRcWZzidhas=
X-Google-Smtp-Source: AGHT+IFodHofAsrQb+bHS3S5/UTOs3+Cnrwfz2huXaXv0xNXRnsL67kZ2jVS7E0TCcQhqbWIiMrpFQ==
X-Received: by 2002:a05:6000:10c5:b0:368:7868:2d76 with SMTP id ffacd0b85a97d-3716cd24e73mr1195666f8f.51.1723490020304;
        Mon, 12 Aug 2024 12:13:40 -0700 (PDT)
Received: from localhost (45.red-81-44-199.dynamicip.rima-tde.net. [81.44.199.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36e4e51eb1bsm8169830f8f.86.2024.08.12.12.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 12:13:39 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: add more info about the tur checker to the man page
Date: Mon, 12 Aug 2024 21:13:38 +0200
Message-ID: <20240812191338.284581-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Hardware dependent, and only for SCSI devices.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5.in | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index e0794bac..f70cdc2f 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -526,7 +526,8 @@ second, until \fIchecker_timeout\fR seconds have elapsed. Possible values are:
 deprecated, please use \fItur\fR or \fIdirectio\fR instead.
 .TP
 .I tur
-Issue a \fITEST UNIT READY\fR command to the device.
+(Hardware-dependent)
+Issue a \fITEST UNIT READY\fR command to a SCSI device.
 .TP
 .I emc_clariion
 (Hardware-dependent)
-- 
2.46.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795602370;
	b=yUu3ao72DYKTNUrKqCUS3UunDuRiA8pqwBRxjzSLzXdXMVuRd0Z58oH6Vtmu2Y9bJ4ZJ
	 7ezTn2sZJR1K5Dqb/lN8fJFEBeLqS5TnX29uSNQ+ObllKfTGFbFtgxC1JE6S558otMH1K
	 /8B/J8Mnl6gJ0icLqvKq+jMhY7uEOFSMseX574kkDDSJwMCxYsm4MYsIV1zdreJ/59IMu
	 HRuNqR7HPox4uhzfTKcex/x5XsNBlpCtONTpywXo49if72OyavNlTWc+Nd8O7icmFtjZb
	 xNyudbUflYNxPc/iryxXX8UwQ0yGNDV+5SjpNUG4VKiY1ILPUzg8tvT86xYXltOfmaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602370;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=TNYzQGWnHcBa1W4b6r5t3gYeyxrKxKePV9KekiaJTLY=;
	b=DkjBAcxo8qjGtKwLSzRNOAd1NssWDbSnEEDCb0zvnaKJ3pVY25EYQKLgYNoqH4lyUNvH
	 LUjAiGAKOq+1pcd0jB6M0nuVeq9AoBvosrv95Bd85BBLKRjxtVWv89pylreJab/2l0dWC
	 3L4aYxSILsj9YMIZWebfyu1CbdNYCeU1m3WPR5BTI0REK0FulkIuIzG7m/XkXeoqXenGG
	 Fpi/fFm2xDkzxZACLEvhznkzU0rqADK7Ov3vKa8xw9To08k1tbc0XsDspldHs0YrMOVKf
	 fZE1RT4jNQyl0eGQSBKiTys5aNjpk+dpS9cAxp8GIp7kGUkBbMLclYSmD7iN/Yr9+6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hcQtTEmy;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05420606A32E
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 10:26:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05420606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hcQtTEmy
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48ff6bd58b8so543585f8f.2
        for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 02:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795602367; x=1796207167; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TNYzQGWnHcBa1W4b6r5t3gYeyxrKxKePV9KekiaJTLY=;
        b=hcQtTEmyfOP4VQQz9sltK2+x1FkkRlx7XsUEPbh3xGTACO7pDhWCRltyiloPkCNYLw
         wJkktgELJ+aRKxAjLrvaZ0++KqwVZ5mUT4sNziNhjp2bPvzTi79Op0QWK18qAi++BBSU
         1Qrli6MA7+O4X+7I5givSPCo6RV87YwSeKp2k3yZLjUu2aIl9bRlci91C1GwlQb3zXY1
         wFReWvvF0+kXhe+8rSX6cW5FtANb0gvSDjLKm0Hb/SbV6d6HEe48Sl7kenXvnJLYbGEf
         uF6o5gOnFsJvXzEPX0NYWfo5f3T9eP8sTfxUw0hsGkvpnfBj2U8PMPn2JiYzmtalfMUt
         EubQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795602367; x=1796207167;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TNYzQGWnHcBa1W4b6r5t3gYeyxrKxKePV9KekiaJTLY=;
        b=KFd3Ab6A2ynL7k5goHpvtD010ppwdmeQWz4KO8u/tGXiYPMf9BrWeaqbSRoIHYgO3Q
         rSTmqLt6dshUovf2X/JpbBHwaKG57weAr1tF/pg8T9j4AnabObhfFZI+yJmorV0N9H0X
         aGPG3Y7uay9w44DbcydegwMjbNBbtqjin6SV58UBmKqPT+qTmTe4dUxQS9f00qob+A6f
         EBIhwqOxCQ5Ns8m9sDdzbLnf4XRYxMxo1Tk471XDzl9WOz1XB7/IbYBY3Zyof6h7O3oB
         q4jxbmoJX5vwz0utXvVM/aVF9Al0iMYeaMtSacSHN5sGBYfh82LZx3BwrM26i8J4nu6e
         TQfg==
X-Forwarded-Encrypted: i=1; AL+hErFNbZu3haqf10XdsurDK5WmZvChdHkpWxjeg4mQVPgeUxRkR/Q7k4o4ywaLuFGlZI/3hSaTYC6u9Q==@lists.linux.dev
X-Gm-Message-State: APuU4Z+/fS9IzuFo3t45VbkExXuOHTmqADYbNoaIKMsIgTY155jXixYQ
	5l990nTiTE6VyT/kJ0txFdZXgs3Qvp9BOiVD8Wx4CXR9cRsU+tRTn04=
X-Gm-Gg: AZFdTZdGrjWLnqMBWKJWp9oxYgNmt/0ulRN0vb0lInlmNdBGlzNP3c9pM7sHHsMCW+O
	2BUL+RHSe3xZ7FN6pYMpVkfuA+rigQR8ilZG/v8wdo4KEKJBE1XCMR8GU+CV6HF9UTHIG0hJoV3
	gbcoH4bgTpjNJrE/ihjEoio1nv3nGNP/AvYa+0Pab347TqhJHlwfyceROk86EHXAsfdCFEaRzXK
	4w+GmvbXiXm2aKHVkCRzatF9fdpEgTc/RX5EIIvJoBjuoIRK8fBvGiFbLOqghz79nkjzWGm31Qh
	TfU7DcwLwPBWkWOGEoe7bJvwv7m3mnavDcn57Oc+9v9v8jK6PhBI7u7b4xlNTldxbjlcP28/Sl8
	fII6SqUB7g9Ts+zk7wh2MhsDGx3P8oCbZNlPePQ65GYyAtpLGPApwUT8fSr7GbEdKsKeAVEOF1V
	w/GmFNy59sMiVavQaUVChsZF+nTzrUDVozEqDvFCo3ZaRgg/stRrIEGefIhN6PsXG+RuYAuHPy3
	qzp/JGv6uuTRrpWX/ui8b3zNoqiaokAiKE8hhZZU5q6f1AFTz3JDkGnNnTOb2+CSuKWpgP4fP6t
	QMrDmimBs7Jo+26MfrJr/RM8WNLp0HTuUh1qCu7vhJuzyye7Khr6nws5kymr+pzoCCveJ3uQ5fS
	jubHGGBu0ibQ=
X-Received: by 2002:a05:6000:2c10:b0:490:6e0f:a01d with SMTP id ffacd0b85a97d-4abaac57adamr33375904f8f.1.1795602367141;
        Wed, 25 Nov 2026 02:26:07 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab65cb42absm34867415f8f.1.2026.11.25.02.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 02:26:06 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 0/7] multipath-tools: hwtable updates/additions and version output in multipathc
Date: Wed, 25 Nov 2026 11:25:57 +0100
Message-ID: <20261125102605.82009-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.56.1
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

Xose Vazquez Perez (7):
  multipath-tools: hwtable: reformat EMC/Celerra entry
  multipath-tools: hwtable: clarify FlashSystem(RamSan) NVMe comment
  multipath-tools: hwtable: use exact FlashSystem (RamSan) NVMe product ID
  multipath-tools: hwtable: add StorONE/S1
  multipath-tools: multipathc: print version string on startup
  multipath-tools: hwtable: add Zadara VPSA
  multipath-tools: multipathd.8.in: restore the original layout

 libmultipath/hwtable.c     | 30 +++++++++++++++++++++++++++---
 multipathd/multipathc.c    |  3 +++
 multipathd/multipathd.8.in |  2 +-
 3 files changed, 31 insertions(+), 4 deletions(-)

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
-- 
2.56.1


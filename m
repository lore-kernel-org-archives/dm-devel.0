Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AA1421EED
	for <dm-devel@lists.linux.dev>; Fri, 29 May 2026 20:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780088167; cv=none; b=ORZ0aMeolYlco8XVa19zOz9HPWQsfe/nDpZNsmi4/EgXs10ULAB6BiO3vLlOcCgtj/hbrjRSwRo7nEUZAjx7v0RSlw3hGFc+ZHny7nF85qCcxHev7Xt65MH2ip89malIgyiV6OyqV9IS1Iu2iPcFB0FvnQTT5XW7jLEQZ5/XfSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780088167; c=relaxed/simple;
	bh=QUkTU9MAzHVjY/R52ylF2nX1IyF7xZP2bnvafUhKIKM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MDEkimBCUoOfxo/MWspARVzcn24b3kSoxOtsOgmwSAcu7v5ibZ2BtZTlxrTGSgygLVrk1U0jwJqBIeP0BmtS6Tz3wwymNsq1Dw2t/qz8N7VX07eQPOCwOhy6j+tcjZMtT0wR3gQGfHZfdCUthkoq+BefcNmb5uWhNkWwFnPMGOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KaJczVa0; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KaJczVa0"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-45ef37b56e6so126326f8f.1
        for <dm-devel@lists.linux.dev>; Fri, 29 May 2026 13:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780088164; x=1780692964; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W6SZ4oP1DlaBjPFDdYbBzO7LwjBZ+p9b7ExzMxZ0B/w=;
        b=KaJczVa0xMtdaSzdpT4tPIeIPI5YrnEad2BMZF3dC49f1/DV1ujjvXLZNITKZBqAez
         pFrSNjD51PM3iTNo2zf/uI6xFtawjGhu7zMXaRKGf7X+UhjMj255atlEvHOoZZSgCCh5
         VqEq7dwoPKXIQwdoUjHrZjW+M0UDK1gjUV0r+lSMpaOIx8jENYBuNRL/f+3B1nIu/udo
         jGuk80EIqPLE4W18QyUKReOiC8LlCs6mH9lwvlNgmZca88qOieyi002BjuTUehIhepyz
         JNVi9zi4F/Vx4cg7UsGnNS85PFNwBD96K/6KnmRIzxShydPZVjSNu3e+i+hwC1jyhqTI
         qjuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780088164; x=1780692964;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W6SZ4oP1DlaBjPFDdYbBzO7LwjBZ+p9b7ExzMxZ0B/w=;
        b=VMsnPbC9vXSuGwR9mYtDg3bacYdYvTIkVBT+MAO4z5v5AO/IDdSjAgqlxLn31cDg6L
         wJTNNKAqVvzJf20Hg3NqDYI2miQBZEvRBTmrY3XE6FrRONmInzPIRP7+9LLdYVzsbyH2
         /sZ0TK1Ji0I9HOPRhCgg2nxKFBAf94uo/e+1O5i6OK1Mrw+SEyuy/NdNWn/P2CV8qU8m
         GpsV2+Rym2E+JBr6ecutxM5kFAN2u6sEz0mdKhrPN30FjR30LWnkAwHcnUF2kARx6xh4
         x/MbrCtv0wNJzwFA7CTZwT7rtQYhSqtl6DwlilQBxLk4ARs+0Z/PJSLngbsblSDrKZb+
         WzGQ==
X-Forwarded-Encrypted: i=1; AFNElJ/DyuYCb/tR44DR+FU7n9SFMHzMIn/zLMxpy90ewM0pFtI5j8BQsEV9oaQjBmcCMN6GixWvLs/bCA==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywf5LWJZ5VM0CqvH5EqCL1qQiIR/J1mz4gfnpfiGrP/prjOwov+
	n5szGs19nIDnV0zOqR2TAyqvhwIwBtod/veOHaskNj24vdc2j7nJExQ=
X-Gm-Gg: Acq92OGFg9S8CPAZsL3ZkSsgaScG3rpcooK9O4Cw8C7boxriQop0J+uQE7UjRk4H6R5
	8/vBegLRPfTYgODqAt+hCXJqfVkF8uae0qPfgiQbTwoW13JA/Xncbpri3gEUPWGAg03WbkWRlkt
	ESN+/Ot2FolnDS8FLgniA+Blgj8YZpfHoX0y70zaJAd4HW9qvKIXOp9viqZgnN0ziFGg5pzZOXA
	2BIIS6FlHo7XYVoMc0W6fmRqBiLHEA9Iwo57B4LcCT6Leh9Qh0xw6eYaiHcHBzePeWKI4oveSez
	iDpmcltmrIBNkSzcUjJfi5wWTi6Y5qj6ZAooIYanKCAvHnDofoBngrAJtGd7pT+KK1a6Nw2QgkE
	1ISawLELREwyEAMP/8uHrCvkfetBKG+hTBfsEc0VrnuffqaFlM7d5HcpIFfIj3LyxILHgf87xp5
	2E0/frKuvMdyOqGJND+m2BNe+HNmW18TWKu/ox3TIUi8UlQ3uPVin3tQBhjKm7d56g7tSUM3Q=
X-Received: by 2002:a05:600c:3e18:b0:485:c456:5e4f with SMTP id 5b1f17b1804b1-490a28d24admr8850055e9.0.1780088163713;
        Fri, 29 May 2026 13:56:03 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909cab0e79sm126968085e9.13.2026.05.29.13.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 13:56:03 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Alexander Perlis <aperlis@math.lsu.edu>,
	Nikkos Svoboda <nsvoboda@math.lsu.edu>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Christoph Hellwig <hch@lst.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	SCSI-ML <linux-scsi@vger.kernel.org>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] scsi: devinfo: broaden Promise VTrak E310/E610 identification
Date: Fri, 29 May 2026 22:56:02 +0200
Message-ID: <20260529205602.177515-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

The Promise VTrak Ex10 series share the same hardware base and firmware.
Consequently all interface variants, whether fibre channel ("f") or
SAS ("s") in dual/single controller, exhibit the same SCSI behavior.

Instead of adding separate blacklist entries for every specific model
variant (such as E610f, E610s, E310f, E310s), consolidate and
broaden the match strings to "VTrak E310" and "VTrak E610".

Cc: Alexander Perlis <aperlis@math.lsu.edu>
Cc: Nikkos Svoboda <nsvoboda@math.lsu.edu>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: SCSI-ML <linux-scsi@vger.kernel.org>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
BTW: Be careful with the dual-controller models. They advertise ALUA
to the OS, but they have a non-standard implementation. This could
also happen with other Promise VTrak/Vess models, whether legacy or newer.

From its multipath-tools/libmultipath/prioritizers/alua_spc3.h:
[...]
#define AAS_OPTIMIZED                   0x0
#define AAS_STANDBY                     0x2

struct rtpg_tpg_dscr {
        unsigned char   b0;             /* x....... = pref(ered) port        */
                                        /* .xxx.... = reserved               */
                                        /* ....xxxx = asymetric access state */
[...]

static inline int
rtpg_tpg_dscr_get_aas(struct rtpg_tpg_dscr *d)
{
        return (d->b0 & 0x0f);
}

/* added for PROMISE VTRAK */
static inline int
rtpg_tpg_dscr_get_aas_for_promise(struct rtpg_tpg_dscr *d)
{
        return ((d->b0 & 0x80)? AAS_OPTIMIZED: AAS_STANDBY);
}
---
 drivers/scsi/scsi_devinfo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index c6defe1c3152..15ffbe93ac72 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -218,8 +218,8 @@ static struct {
 	{"PIONEER", "CD-ROM DRM-602X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"PIONEER", "CD-ROM DRM-604X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"PIONEER", "CD-ROM DRM-624X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-	{"Promise", "VTrak E310f", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
-	{"Promise", "VTrak E610f", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
+	{"Promise", "VTrak E310", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
+	{"Promise", "VTrak E610", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
 	{"Promise", "", NULL, BLIST_SPARSELUN},
 	{"QEMU", "QEMU CD-ROM", NULL, BLIST_SKIP_VPD_PAGES},
 	{"QNAP", "iSCSI Storage", NULL, BLIST_MAX_1024},
-- 
2.54.0


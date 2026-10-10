Received: from mail-ej2-f5.google.com (mail-ej2-f5.google.com [74.125.228.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27A13546CF
	for <dm-devel@lists.linux.dev>; Sat, 10 Oct 2026 16:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791648981; cv=none; b=R4OCtW0i7cuKACyr16x36suODUJVAwsbDpVXCH9z/rP9PPCss6gS38Dgc79kV+PJISZ5KUUWcN+5NoKlA5vDiF0JsW5DZ33UizerKqxJaNjyG0P8zdz4lW41zVodwXepZimB7hKnFD+cOdtwS3rPDjlVM87jAWKc0KzmziaGKvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791648981; c=relaxed/simple;
	bh=KutDEGCPlONJfWW9uuDS3X3faNGEyX+psz2/OPeNoAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/w0S9hlJeRTTInmd6vRAwzCby8FbnXznyV8nKNZtVm+vYpkpMGaAVOCif+FSmpCvEL+y6Tr8EB8pxMu9zHsovpwXZ7UH27nq3jimi4Dp/6Qa/nFTmk+LCyLC4nhDFJBk0YnsKCnOZkUnsqP/GFXSspGOxf/IS6nIT6XXlsS6Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d7dQRgQg; arc=none smtp.client-ip=74.125.228.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d7dQRgQg"
Received: by mail-ej2-f5.google.com with SMTP id a640c23a62f3a-c3305a41e91so27247266b.1
        for <dm-devel@lists.linux.dev>; Sat, 10 Oct 2026 09:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791648978; x=1792253778; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fjHNOUUglm75EsN4v1/xErxWOdU79LqCoAd2dMeTVTk=;
        b=d7dQRgQgtgupqlfLbPpvKZ8WnteHDTMgAomkxyCf3b5Hzn/xMpoagOK4bReB6l38fJ
         0sn8daYLHQPLf3oq0nS/Hx+HfzSs9HxVqAHE6ktT/trjZPkb/sjW4EjqHUGFT62Ji/uU
         4AOg27DopihS5vNZ7gdcbnb0cweg9s7yA1oZv9FJNz/+gi+nNUw6UiT4lR3QBGnC6Eek
         AUzwc880sRmXoEehtHN5XYAewKz5uKaVfaReTY2SQ05ZAtSoJso9eNye0smKJZ2Yz3zc
         P3FmWepA8o3+ouDGIFllKM+cMVKMbhyrMrfoLLe5Cdd69ptneyTLsxte3z4j3WOmoO8m
         83MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791648978; x=1792253778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fjHNOUUglm75EsN4v1/xErxWOdU79LqCoAd2dMeTVTk=;
        b=V0sdOtM42wTvkyptlrlGG05gnWxOaJK+IsBs6kqS1HtjCHEo3fsO5/fAi2NVr7ZXqm
         cvU4u//OTH0rncLnJkj2fh5Yw62w0QPqWmRhuTCrsiyCnwoXArGdh9+xfwke0AT9Gb+J
         f07da9KvjE76eBcguPwGVI8QR7dxkBSF3H7hbpqkH2I18oRKEDhvgoljVH5vy4OLcw0n
         AmeZ4SxIiLtVGii+zW2t18HfHn+RI/OS8RCyX6adoPXPR3AtbHjzpaB7tAVEWfazgbM6
         uJjZxVE9lk6bWXf0etb7fzyGhPRBkW7neDYMDFzZt93wwiObPU5OHjAwHkoGULFftcU5
         Eq4g==
X-Gm-Message-State: AFq9FYKOaaEkBn4DkP/oBycvQhFLPm3u77B9qtOlryenSg7l+LEyLjuS
	IcD9ObRedWxaZEwvsmofvzF88jJAJP/skoNfnY1v3uPOsxfpvRPx3zHDk4YTOHxYvS9ZLw==
X-Gm-Gg: AYBFou0+AEPwiwWoAuwKgT4kri2sQn5xUoTllwfrx8H0zUjymS40BrTx87gRfjapcY7
	Oo7YhY69vplc+Th8v8Bh3dU2VmAQFcDok9IjU+6Ee+QEGdLSg9TTl3qdKE+C7+g/pLs++Hb9gcX
	dYY75I9L9hvQwg56Hqb1kuRc+fZv22s7iBcavXieb3yYhHBBdn+9vmWQGxgYZUCT4U1ziUGVsHj
	/2LYih+mwfcXokd/K9QfpGpXDUZJFfvj+ABc0aWG2AML7+NqXeh2C0l3BAQWCAMHIEzW4PiJ9+7
	Tdq+xnWVA88SO85py2q+wup3iIFxBjsoeQJA4tX8cbKUtoG/UbLyQkd9HmFN1NON5zgaw9Jl9ZD
	+yOfbIA6oEYX4DAyiWWEEeblLbMNOOsfGzxrJ3UHT6WUDzLbXA9vIt4lrCmVBGKY7vCBKrhdlm2
	xIe+uXcBqAgK2GIZZVZ36Ls+JL+OGZeowCG0N4vXCf0FFdAawgBNqC9vtOLlBDHd5DbSG4zdgEQ
	aoCHt+4neSQGP+sDbuk0GmTNotu5j4uJCAJMh0SPXYHxXyGERsRl/dciQ==
X-Received: by 2002:a17:907:1c89:b0:c2e:2d8c:4585 with SMTP id a640c23a62f3a-c31a9fdb266mr555312866b.36.1791648978017;
        Sat, 10 Oct 2026 09:16:18 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9a74bd7sm261422066b.37.2026.10.10.09.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 09:16:17 -0700 (PDT)
From: illofspeed <illofspeed@gmail.com>
To: dm-devel@lists.linux.dev
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	hare@suse.de,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] dm zoned: keep polling for idle reclaim after a reclaim pass
Date: Sat, 10 Oct 2026 18:16:13 +0200
Message-ID: <20261010161613.396-4-illofspeed@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261010161613.396-1-illofspeed@gmail.com>
References: <20261010161613.396-1-illofspeed@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dmz_reclaim_work() re-arms its DMZ_IDLE_PERIOD poll only when
dmz_should_reclaim() returns false at the start of a pass. After a pass
it calls dmz_schedule_reclaim(), which queues the work only if reclaim
is needed right now. When a pass ends while the target is still busy and
has enough free zones, nothing is queued at all. Once the target goes
idle, nothing re-evaluates dmz_should_reclaim() until new I/O arrives or
user space sends a "reclaim" message, so the random or cache zones that
filled up under load stay full.

Seen on md RAID5 members on 27 TB host-managed drives: after heavy
writes the random zones stayed full for hours on idle targets; the
workaround was a timer sending "dmsetup message <dev> 0 reclaim". With
this patch the emptied and filled zones were reclaimed within minutes of
the targets going idle, without the timer.

After a pass, requeue the work immediately if reclaim is still needed,
otherwise re-arm the idle poll.

Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Assisted-by: LLM
Signed-off-by: illofspeed <illofspeed@gmail.com>
---
 drivers/md/dm-zoned-reclaim.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index 2bcc163d209..7feb2628bd0 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -557,7 +557,16 @@ static void dmz_reclaim_work(struct work_struct *work)
 		}
 	}
 
-	dmz_schedule_reclaim(zrc);
+	/*
+	 * Keep the worker alive: when a pass ends while the target is busy
+	 * with enough free zones, dmz_schedule_reclaim() queues nothing and
+	 * the idle poll is never re-armed, so zones filled under load are not
+	 * reclaimed once the target goes idle.
+	 */
+	if (dmz_should_reclaim(zrc, dmz_reclaim_percentage(zrc)))
+		mod_delayed_work(zrc->wq, &zrc->work, 0);
+	else
+		mod_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
 }
 
 /*
-- 
2.43.0


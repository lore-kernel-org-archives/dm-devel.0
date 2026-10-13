Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CC94F7CC1
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 12:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895190; cv=none; b=o3sowFWv5It+m8mRqpQIJfGNfjMxyHshA2wJVgoL2t4vTNLpXciNfMHSF1GiEXBSl/YbQxV11PtDfckkef9nI5lu9yFGpHc7Z/QjZufsruZ0pAICzSWUvHBU9kECHgSXhttYOCaAccwiKi3FLp8eu5pHASxAyDRUtAusoslt+Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895190; c=relaxed/simple;
	bh=q7IP0n0tFVgXui57e7ZoWvGl6mJaR5f8ZscXMkb5tZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlUoEBLW4ggsuvXxLaGEsSSQTK1b8Fw+uZXL2VDj7iEqJJ7vz69J3gC/cIa+1N779vzXy7rBOgbkMEMfzowMmxO4Swpe/z/wQnEYYlTUfVTEYUu1XJDl6FDhz8cDr+TS9ornN7267+yVn9h29NCwjzzH9qDZqQa3wi+T1w0/7Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mpbHspaL; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mpbHspaL"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a16aaf2067so34938975e9.0
        for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 05:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791895188; x=1792499988; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/ngQKRroXU/Uz8Mh7Lut0ld0a0rsmTuRWomcPoA8M0I=;
        b=mpbHspaL+CHmmEFt6ShNWrsOro/wifIoAoNO8Si3PjdPFbATnSDegUWwnlqHFceIbI
         2iB+zUhogpz/upc7L+q7Vfbq0m3aFyQsrFFhdy+Ytpp0vdrkGr3EU8UsHFFCaS9/DHf8
         HBa7bnMj8ox43Bv8h6MFps9hqjHtFcKreldFugLN+5Q7/ddVkntrZ3lCaT4m2z+Qz15g
         NC/5M0MOj5N3iR1qEKjxMVd+J0RLSCEZ/U62NqR4rU3dczX+qe6wngz23SOOJKIAm4ij
         E5DNTbNFETF9wrxAj5zSwiCuww//n7nWgrXDqUO4vhFXiW5JjwzX7NP9yzcOUQ8L0PyS
         B/3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791895188; x=1792499988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/ngQKRroXU/Uz8Mh7Lut0ld0a0rsmTuRWomcPoA8M0I=;
        b=ICA1wG0dZjpQORiIB8ERY7g8LUeYbdXRGYvXbLTwpdX/O2EliVWeIz7Ifdw8a+Qp7S
         Tims1Wbu/9/AAA9jMACXZxCVA4DEFzppJcy+VeMRGUw9QFs8tGM8wvVw3lFs2yeY77vr
         6pIlkztdM5x80q/W01omv8fHfEuqZrlP6UlSDIHaaMFciPp+NMvgS+QIvj3A27BW8YGg
         2Vb5BbMkADsxuD7IZU8Ei3fEmOjY1yXoNXnLZpKVSldHvNjqVsuiuimUE32K+GcfJfwY
         TYT+pyJxXL8HSIKI8B1YMQKLsq5kK6dzG5QC68y5Hu6omtcWzG/8KHjWdZFUwSye+9+S
         TJVQ==
X-Gm-Message-State: AFq9FYIIUb5QgU2IZW/1LNe/iTk7JW9totTBo4HrqvvhFNOe8rnFvjla
	WWupZJDjdpOcierWfQDj4RQNDg+rbcyWIzX6yJBLwfsfW0Q6M7RPvXN8Ie8WcClk
X-Gm-Gg: AYBFou3x7mjIANEs/L3x+Cdscv4lCQbm+fFGIruTNhJI6qD9K/S+2TZN4dfYP9qJdIG
	1miaCJT301K5oBRW+fYIL67WmTDemItRIJDnESQ3scrsSS6ZXOMxJJj9gzQYaLIAPx3RncNko7o
	05IdHBREcCJ88JqRp50HmRH+Ke6f1egYgmcHKitcEWlB0j0Xm1bsOZ0z7F/R3w11FuuD/vdVAhj
	PDd8TJcUk0rw/94kqW0LMUDx3tlfJP/m/F22iYq0emyzJ8cuqp1Kj0T0XR5mnv2MTITkSunbB3P
	4XoCrDWSADQPXuTaMk7H8D34NQfmgImtMdbdxyKFfW3Brcamj9znWf5SbOrsGVz4ONZExF13OZJ
	ZpgkXBF/chGQY23Gkh9qdbJSGCNG9vCVHPoiX/H53YTfOi4Asl95oUBc25vj9h1XGwqTt1VzK8n
	zNFH1D1CNL4OC2d9l1YCiUPHHqfGzwu940/5OMyNBuUcyoJrrqyaP2m3JQjKViYwm81HRzLiB66
	zm6cOBEwjIBWQKoUlsplf2d2+s7GWdMkjkuuvlvX/V5oUA=
X-Received: by 2002:a05:600c:3e87:b0:4a0:a34:6e7d with SMTP id 5b1f17b1804b1-4a18e4bacbfmr224923095e9.18.1791895187530;
        Tue, 13 Oct 2026 05:39:47 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0bc7299sm4179440f8f.53.2026.10.13.05.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 05:39:47 -0700 (PDT)
From: Kyrylo Biryuk <illofspeed@gmail.com>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	snitzer@kernel.org,
	agk@redhat.com,
	bmarzins@redhat.com,
	dlemoal@kernel.org,
	hare@suse.de,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/3] dm zoned: keep polling for idle reclaim after a reclaim pass
Date: Tue, 13 Oct 2026 14:39:40 +0200
Message-ID: <20261013123940.952-4-illofspeed@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013123940.952-1-illofspeed@gmail.com>
References: <20261013123940.952-1-illofspeed@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dmz_reclaim_work() re-arms its DMZ_IDLE_PERIOD poll only when
dmz_should_reclaim() returns false at the start of a pass (and, with the
first patch of this series, when a pass fails with -ENOSPC). After a pass
it calls dmz_schedule_reclaim(), which queues the work only if reclaim
is needed right now. When a pass ends while the target is still busy and
has enough free zones, nothing is queued at all. Once the target goes
idle, nothing re-evaluates dmz_should_reclaim() until another zone
allocation, a "reclaim" message or a resume schedules the work, so the
random or cache zones that filled up under load stay full.

Seen on md RAID5 members on 27 TB host-managed drives: after heavy
writes the random zones stayed full for hours on idle targets; the
workaround was a timer sending "dmsetup message <dev> 0 reclaim". With
this patch the emptied and filled zones were reclaimed within minutes of
the targets going idle, without the timer.

When reclaim is not needed right now, make dmz_schedule_reclaim() queue
the idle poll, so the work stays queued after every pass. It uses
queue_delayed_work(), which leaves already pending work alone, so the
other callers (zone allocation and the "reclaim" message) neither
postpone a pending poll nor delay a pending immediate reclaim.

Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Assisted-by: LLM
Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>
---
 drivers/md/dm-zoned-reclaim.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index 88d56d3c86d..f1f9adf6039 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -641,7 +641,8 @@ void dmz_reclaim_bio_acc(struct dmz_reclaim *zrc)
 }
 
 /*
- * Start reclaim if necessary.
+ * Start reclaim if necessary. Otherwise make sure that an idle poll stays
+ * queued, without delaying work that is already pending.
  */
 void dmz_schedule_reclaim(struct dmz_reclaim *zrc)
 {
@@ -649,4 +650,6 @@ void dmz_schedule_reclaim(struct dmz_reclaim *zrc)
 
 	if (dmz_should_reclaim(zrc, p_unmap))
 		mod_delayed_work(zrc->wq, &zrc->work, 0);
+	else
+		queue_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
 }
-- 
2.43.0


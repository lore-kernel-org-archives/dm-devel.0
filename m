Received: from mail-ej2-f11.google.com (mail-ej2-f11.google.com [74.125.228.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E192A43DECD
	for <dm-devel@lists.linux.dev>; Sun, 11 Oct 2026 17:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791741298; cv=none; b=bpE0YOV1H2VMK0NttC3Ym4/Q9KwlpMGrBlwsICVQz16a+OksrozfHsXjHJcE7iWw4XlY0w18uhhzCPiXTqIAIWx9KW00zfyCKk5kCG/hCsKl0iKoOTvsE+VNY24RB0JhnIJL3gTFxNTIEZb3E//63P3vCtp5/0zmssmTA9PX8ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791741298; c=relaxed/simple;
	bh=mh0naAZ5rGdtBm3SRObJJh3xiuOOeB+3Lk4WoYcj6y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ARRXI6TSmSuEP/5LqDsfr9n4MDFetqx+wptJPGou+Dk4Gr0z4694qfAewjR76QV6qOQUSqD/AgJEKT3wjXrj21/XmYZW1PAK8HO8lhYuq8kqqkXmge5iOsTCa1XoQC90m/18B6Oq9OlK7U27ZuAo0YoX2sE6qWkpDDqkQOxz59E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cOYwWtvv; arc=none smtp.client-ip=74.125.228.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cOYwWtvv"
Received: by mail-ej2-f11.google.com with SMTP id a640c23a62f3a-c2e25574351so114206666b.1
        for <dm-devel@lists.linux.dev>; Sun, 11 Oct 2026 10:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791741295; x=1792346095; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AXeUGkwkx/B0ZcB6bHet0Ei8c4WjWUt9Suh2yBdHG08=;
        b=cOYwWtvvbmqhDprgFSFJZPgBzwhEaGODdsa+fnd/ldgKmiy/D1cedIKXulnkrS5r6R
         22kxL+cn9aYSdIa7aFbQ3k8uiFR6rAkv8s2VxpTjROfJKe8hcK1rqGdiamPR4DaPqmfN
         fZXw1Voyr08WrlXZc7DnHvKusQHuQyeOfEs4mz3E3/KX9C9YDTk0Zyf3uvh2h291cXag
         wM0sZaTOMRdUI5jHqLwZWrhrDuu0WSj+phLW0loWVPeMvfV+SXCb3nwoIjjBS8Xr1LMm
         P80PbMCXByBA2bCozsSi0zI/6JBj/gzkG0vh1TjsMC1sfSGzI5MxeqwkmOc6rRVdgQca
         oWEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791741295; x=1792346095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AXeUGkwkx/B0ZcB6bHet0Ei8c4WjWUt9Suh2yBdHG08=;
        b=hj4CjCeL2WSMcyypjp1+DX0kRIicAaulje/eolxLQ1i2gZB6wjqsGsCberTxO7n+65
         HoIK+bH8/LXZ/UhVof8JgGAZRxXXyYMkLmXnJrRFrJLyqtkHuF0NSh1dKrCeCo1eFVf+
         awVeAwDi7hLXih4ewYYR51dZjredC6gFkEbFhGP38LyKdMThZtl7x/jTN3GxmxkIbJtn
         BOHLosWzTx+p7ugBo6zbWlEriR8CEQUaZs90t1Ny+pix5Y8IwJqJh+aEhxPEG/y+JvSP
         P/5ZtbYaqx24jxdBdQIkBhnlaOTbGFHamn4bzjCZFd7wzdynSrfDfFgeTa6Ltii6uZxR
         id+w==
X-Gm-Message-State: AFq9FYJFVOHPXiw9BJnZNgrxZUKRaHc433iLSF5qrs7ZwOHa8ECUFk9w
	tf8htHZl34ynLTyhJw6OcJUCldvfMssSkw/zv82U68NxeLwhfsIgpKOV3ExVXRtq6QAG8A==
X-Gm-Gg: AYBFou0cn8bW6r80d/2YZJ9UV8MgWxMcN7/5e1lgAqrFJmmQ4gFRNmw2gwud/R8jz5r
	wC8b/bi+9cC3pvw/GjBo18+pvsDK9uN8z0BZY0+2CBgEhEm8fhmblgwpA80m97Ds4kIKK5pvE0G
	NuCnF2eDvqE5EbDc20U9AZVvmRTpYpCEg4nQUby9P0AVRsmJHk63Is04mHwStAbyF7jn/8G+qaa
	CYcGIEsnc097DYCxq7jWUWviLgom+bfiHAtV5Vik0vpfxES3FgdFE6fck5HZIPOmy/La7wkTQTt
	K0jLb/tTswjzzB/PnKi2THrRSS5dGveOuu2jGhGxuqt8wCdS5Y1/7nCLzQhlFty9ybgQvqgURRw
	tR03rVkHDoaKF616NRh4asACEQukdalbA1wnKHoQ4sdIuiSArUQ4xae9M+QueFQktKYqJ1YavD8
	k7Pg+bCUeEr+YL/DARf4E7vs4vjDkAArC3ZDFBECpiPkhU0jVU1to11inXcfolvF76vgXtrETWv
	LQ2tYGsIxfEm8ev2fbFmSzdMsEJyVOcLgezQB9oAdvihME=
X-Received: by 2002:a17:906:7956:b0:c2b:898e:24fd with SMTP id a640c23a62f3a-c31aa0857f1mr838591166b.33.1791741294891;
        Sun, 11 Oct 2026 10:54:54 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9a9f776sm376806366b.48.2026.10.11.10.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 10:54:54 -0700 (PDT)
From: Kyrylo Biryuk <illofspeed@gmail.com>
To: dm-devel@lists.linux.dev
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	hare@suse.de,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] dm zoned: keep polling for idle reclaim after a reclaim pass
Date: Sun, 11 Oct 2026 19:54:50 +0200
Message-ID: <20261011175450.952-4-illofspeed@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261011175450.952-1-illofspeed@gmail.com>
References: <20261011175450.952-1-illofspeed@gmail.com>
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
Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>
---
 drivers/md/dm-zoned-reclaim.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index 88d56d3c86d..5084e10ea7e 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -556,7 +556,16 @@ static void dmz_reclaim_work(struct work_struct *work)
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


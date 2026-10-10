Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C341140E8CD
	for <dm-devel@lists.linux.dev>; Sat, 10 Oct 2026 10:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791629494; cv=none; b=ja5OwZ8Zkqb8LHQ6Jb7fT4cgaxilFPmAd9yZQ0nSAwV8xshVRpSh7JPkalw8nbiXA0CTKnxvwflZf8ivWD9ouSN2kjs5BOU686CJYSJvCPghR2DgwRClUTIMP5aDx1f0hUrDWWMueMnP9SQGoprCAEr7jSzNgkrOXBo4F0JVulo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791629494; c=relaxed/simple;
	bh=Gz4FI65CD3FE4kIFuCVPHP9zbFGBTeTZJWQ3zjzPm/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiTlojp0fDvMbRAxkydZ1/AyKP8LYOB0Hi8c/VzT6q4P3O5bs40rrIp+k8e0+pc8oURdTGpFkI8bZ13SL/NSTvxMYF+PogPBAl1deTmc543QYW1PFM063qfRnoCcxIUMSqcNhCRGO5OgPHheSyuo1I862WVa+PQ+07dZdZATWk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lgy7aiJw; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lgy7aiJw"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c2dcbcc546fso61126766b.3
        for <dm-devel@lists.linux.dev>; Sat, 10 Oct 2026 03:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791629488; x=1792234288; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/LHNp9A6zwMofA5wnyNlSQnfkRqOMomjAFoxyV+7B4A=;
        b=Lgy7aiJw59aehbZgqjXYXPMwC50M/eIfiuUjVLbI5DVOQozj+BBlQ7TnuX/5OCAIFn
         6e5an5N5jcRAWO40Oj4Nu0raCR7eFNH2Q0qXU5YQwR5X0eJwlueRM2ZxiaYu+QqUrlGJ
         uRsq3cjiWw+MOsxv0vOgzxDZJt5jM7P4U5YDCe9DYl/0YtWa2t1W2nL71WD+Knc2oBW8
         Walkmf5x5/ww6E48V0QihK6R94Mp38DonvHfiaHTeelIN+Gp0HsQHY5n7tI6VPy/5oay
         4tPXWtqRCrnbSR5SyRjPGYWqzO7HvoulDMRP7nl/6G8oiaymFHiTlYsxIdVF2EcMcbsj
         XWgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791629488; x=1792234288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/LHNp9A6zwMofA5wnyNlSQnfkRqOMomjAFoxyV+7B4A=;
        b=BzAtT/LR4ve0Cad+XtCnZFoOjU/67TJFEjkgmacTDXr6UB6UOPyUxvfISlCOLW2KkQ
         Fp9j89eLLhS0VGU/cRJI4SRgMsmjqfudl71B1HNSOcYJLi/NKKxmBYLdNVy18vhfh0nK
         KatNvGVSc3rg/NfB1XRn7nxT2FeX+YrEE8ZA8uTUNd8P4Y0WH2FHbLzX4jSN3fgVlVia
         xPGfhn5axQ/ysaWNQcA0Ni3B0leynM1v2ehn2IEUuZlGDMmUC7+ZJLbAhYUg1SwRlUM9
         ImmdVUU3cviauoNVXZbzH2H8W/q1AuPZlRzG52cZZdafjjvtWOPTTFsk11w4/WWHnsMX
         Eggg==
X-Gm-Message-State: AFq9FYJGhM93omQWZciG80xJdJwy2Iepu62owlAaxTvT4quNWUdS40Mf
	rG4BRcVAimyvBZn+YvbFeSDXaLlmtS4aqma+EtdvrS1rChLQK7f4RfCgwyhLqSNti4DKphQaWvc
	=
X-Gm-Gg: AYBFou0f3Cut26LMHdC54KBv4b6aZgNb2F+Nd1liRs04yQoQGrbe4LETZ+UCx23eT4X
	DE/9mmkvXwWoVo8E9SwWIly4Cr6vmonL1t13e1e0BZ8R0wc3vdno4uB8UrUhQqfCivghE9Ezwpi
	SGWSpc6UxoFv6s7m7R2B/Tavg6pjZoWxkttB5ucBTpk1ZcFAcCEi41TUHKqL05ZZg6zUlCxtpXB
	FW+MtjkElXmwt4BLIhi+EF8sjCuEJoKwESaeL3FrwDS4IFcu9oUL0Q3Sy311s0bV4xm6beFmHNF
	gLRcpqYJeWW0RoGiA1hXemGIuEebyQISRQUSq2vS2D1ceaCcWk4Hj2zlq6+RCRjY1o6qaQbX4hw
	yvlWRsVgwmnpzYUAhJmOMPvBJ4hRrl5ImJb9EhmMXfRw2K0TT5G53+c8+oWuLYWLiL6HExYWs/Z
	TpY6mw0zDWusEn1DvWGk2CJOkm7akNoG4pR4M/qMCNSqlTzIxqko3osYKuRBm51D4imZ5/mSGjr
	xi5wnqbVdW/4bFHLbDM1LcDVhLcZcK1c6mM8cJ6tdkjXsp8tAK4zXoDvDIuxwgLgGmh0WqLJhDa
	gKg=
X-Received: by 2002:a17:907:9707:b0:c2b:7672:8e29 with SMTP id a640c23a62f3a-c31a9fcf4aemr440278766b.16.1791629488280;
        Sat, 10 Oct 2026 03:51:28 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9766743sm229984566b.4.2026.10.10.03.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 03:51:27 -0700 (PDT)
From: illofspeed <volvo.mail@gmail.com>
To: dm-devel@lists.linux.dev
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	hare@suse.de,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] dm zoned: keep polling for idle reclaim after a reclaim pass
Date: Sat, 10 Oct 2026 12:51:22 +0200
Message-ID: <20261010105122.398-4-volvo.mail@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261010105122.398-1-volvo.mail@gmail.com>
References: <20261010105122.398-1-volvo.mail@gmail.com>
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
Signed-off-by: illofspeed <volvo.mail@gmail.com>
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


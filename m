Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBD14EE85F
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 14:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791903331; cv=none; b=KftyPb+o9hl8ayl5L4HbijTOI4Aq+86dPzlrzQAco8pyAeE0cL4P2ZYr/LdrJLeWrRDn3HhfsXe2dMpXxsC5D83bPkPh+P1EkvsIoJB4mFZLwWh663xwNVJuSMFwiAvlqFvTbNWF9nlzihpBhezxlGXq4TRC14SmfvDgITSlwZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791903331; c=relaxed/simple;
	bh=7wzxSB2qhmpiXV/o6gYxzAhM8kMclX7fnVPUbCiiuKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACXQmsiam7l7P5r0R7jkF+98kliDeBBKyNBV5jg/k0/c8cjaedYxrD92oAYVgo7AEvbPA0alWS3FDXsYyH0lT07GBneR8pRe5RFVOXpk+ac84HjZrhrqemIYzDrCgAp6ufvin6MiGWAoAU6dsrXyBEp2c78unM2JMBG9c+IO8Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pSkrMRVq; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pSkrMRVq"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6ac76a02368so2902534a12.2
        for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 07:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791903328; x=1792508128; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MRLm6A3T6Ct0MidSnOxtbUyQRmhGnsYliHxtNklqnL4=;
        b=pSkrMRVqgjCnFopbUhxnZ/F/0f8F2s+KeKum5jhIiVUz8dbKMyGRRHo5q/kfD/vPly
         CWsQOadkEYFFjbLrIRqhJG/eEGz08hDvPXKPUC1/6Z3Lzh6XqT95K57rPIc9DqE+i7Ma
         0ME4AYqzgfzWBP46+EaLkWrY6L7Fl7K0qT+JmfHMwGO7Kg5tRSZZOwuVh3m44jaxfGwn
         YnfO+PME6KYihMzOMsmFfyFW07yqkMrVWKQC//RnFaqROuSZxwK9MI+4UxiqpV8QFoFH
         E9amQO9xlZdv1aZvXrKL8r41hbAET9ZBsygjXmcTmArezq22DCPmrF/PjgVAE5n+E4gN
         C+hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791903328; x=1792508128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MRLm6A3T6Ct0MidSnOxtbUyQRmhGnsYliHxtNklqnL4=;
        b=nqNbNxampHO49jTWMf+CtoZEg7z3pHwbmKFfKDKYnPVFEMymspuvhSsHvt6ZoAa7lI
         RHeB1vsTGyk6KFj1/MsTsHVqO/+rLTgwJOc2vMGl/hqd/XzHrvlkdkivaKym79tYPet6
         Ok4sKN8DHZWXC5yL2ZbELXCrkThCGlND7ebZaV6DmerRwInHTz7gyM3ROSyJQudzruuk
         hLxqUYC7mxLiDraiFh3A80HY4ERfIkwB5paAc9j4UYTDQQn+sABCqcEBve9OxBtUBwBg
         yBPZQ0GO/lF1jV3WLD60u05W2PtU2RZIPHbsqbNV4AGbGQPVrvGx7VK/J44bmZsy111S
         Q6NA==
X-Gm-Message-State: AFq9FYLKm94mTX5g24kDYyId8yghPjD6QxNJOqk41Zpf9jvfXCSfDiot
	oNd0IVlPwrM5XAPb9SCbdkZF8s4Lnj5/7zYSoDy+oEvsb8ELvKdTtQhnvAoY0zoo
X-Gm-Gg: AYBFou1OMmT2Fo48JTvHNCRJeM+wL/nt3onWvljuP537E0L31Yat7X5x8ECMeoJQMij
	qmq7D+Fwj/ohPb/Y3K8uLmdTqRhBTEHXhAZME1rEz8Efz7onYkSrBykAN7nDKSMyhXNTIA6AT7s
	FZS+Gs1dwS/cOsqzqXQD8TUc+QUPUHPeqOBK5ZSDVU1mm4S6HDd5CGwSOk27nRXjr5M5wqRFAH9
	PVW/mZKCZzEu6NS1uLRnVBflui5gQbIZgasX+IZdErsR9JMW3vIXVgsJTtg05rlePXyIk+jxArc
	z1EPIvsAzAEvPMi2gZ35LBqcArRj/AA6d/4yJzQVD6UKguSZ8Gxb26z7JraccfOXgi7r/XxjS4r
	sg+P31vV4GQxA81G71xe1BKfMQxy/OzM2K6aZjH7+fHzJrhtifvzGvcNdHeXieBa9zEqbv6lR6D
	r/322WlpJZb34hh29UURM8509Q10SJ+mA6LVH9fImc+ZySg+vE/+YL+EW8czOFyo633RFJAHm2Q
	jTaOBpZV1u5BQTNHSIb66TST3wFKqh04K33OS9jHhsNVSOB
X-Received: by 2002:a05:6402:3251:b0:6b1:cea1:a023 with SMTP id 4fb4d7f45d1cf-6b1cea1a354mr3819615a12.19.1791903327741;
        Tue, 13 Oct 2026 07:55:27 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b179e03428sm6169161a12.37.2026.10.13.07.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 07:55:27 -0700 (PDT)
From: Kyrylo Biryuk <illofspeed@gmail.com>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	snitzer@kernel.org,
	agk@redhat.com,
	bmarzins@redhat.com,
	dlemoal@kernel.org,
	hare@suse.de,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 3/4] dm zoned: keep polling for idle reclaim after a reclaim pass
Date: Tue, 13 Oct 2026 16:55:21 +0200
Message-ID: <20261013145522.17499-4-illofspeed@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013145522.17499-1-illofspeed@gmail.com>
References: <20261013145522.17499-1-illofspeed@gmail.com>
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
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
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


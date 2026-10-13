Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650D24F054E
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 14:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791903331; cv=none; b=felHWh5hW6q2hV+PlIL0Vp1jbdvh3AjlRmCWyM8GpvC0iZZISfgV32hInd1kIwviR5RFNQtnLGIeJ0EQGo/8qBpWfHAeZrxfDjOLs2lN0ouJfrMN4LC8l0nkQj1b4SXvuax/saOhO2iMQQZr3Tk09KFs3VLz2mimyhr5OYBjRek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791903331; c=relaxed/simple;
	bh=iUcWbF6VqinwqarzVq3Arlchef8+Y24uEq8bk16kOrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLQyVs8X0IL1W7Xcw5YjhaRNPXy4ToyXEUvQSXJgbxS9U9e6CeyDdNIMn13ZGCAbk+VeK4oHYtgSXjYJk9ojRgjkJ73QNKcdAordMKK3Mr5C8+v2XnjB+P8JacpF+qP/BnAdHCrhDgzxEgkAkDj1TuA+J/KIO6Fui+BD9lRTF0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qX7ZSo/Y; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qX7ZSo/Y"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6afbc363efeso3679735a12.3
        for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 07:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791903329; x=1792508129; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n5kbj9NCQZ2sDr390DiL8elbJ9zikv1LhsX0xMjIXaM=;
        b=qX7ZSo/Y2r7dY2E12FQ3p5wuZvgK1Ky1wrMdukYH15H8N5Jy1rwg6/WAasqfstNNQI
         bX5yn6lC78FhNk79nD11ySziC4e2L9iRoe6YV0OPqSX8MnyEUa1GhvN+ZECutJ7euZOE
         mAoM8DFxgFj/lYg8/xHPNqa+EetPRJpPeWRupXsjzQWQ5VamwLNjaUMuvnoivzotjmPg
         V2Og3V2p7HrJ32aK0SqUD0RNPLeMxgqW9QocERtsv9UCnlRZFDYAip8+UalNxYrJ56ET
         B25GdrIJUvSDH4y3t2CJXZULN7WLrq/ddmCxOMGpaF3GMK9z60KcNNYq81OE83oegUkI
         l1GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791903329; x=1792508129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=n5kbj9NCQZ2sDr390DiL8elbJ9zikv1LhsX0xMjIXaM=;
        b=SSwnX2yzISUpNUeDzUZfX2uaV1AUL7S6Q9nzlJDxhCgInR+RjNTXzqxEfMnR4p6kBR
         bkdOJZMqkAlD6lzaG2efNLlz8LsN+sGka8eiUQcRo1eSQ917//qjSBej0zhB9aNAF1hm
         gHlbw1srFiqZloy3Hkdyi15lGCpb+ceE7WiBtP2YA6xiQTdHBwgylVMi7d5Yjrc4/GOu
         7MW+Mx58dkFVOpyhPaI6jRjimcMuFPjjLHl8sTmYqpxtoFyTcYcd1yCMfRdEV8PLJvOM
         veNrR9dg15GVskCt8MqzileJeuct+C1yQ11siBFAJNm27bw3EN5DL6BdR/KVtqTHGiJA
         +E0g==
X-Gm-Message-State: AFq9FYLBvt6THR1AQcYHE2kJllpCI5bSjCigBstze7RUYENUiLDrkBiO
	SRvCeTBUq4GoKdmv16lPTyxCVGAGNTJKRgz0n8JmRO4IcXHKepQgVHm30GpDOKhb
X-Gm-Gg: AYBFou0HFZGUwRJ1PjVtT6TZA0FUWA20w2jedpn8XvD/PEdHXl0SefUFL43ILpLcVGU
	2lxOxawVtjzl7eStfEj+8VDeHPz2ItRzuOIDUMuoPgAwYh0SyVoiz/3htooVAIcxI8/mC3YuyQU
	ktAZmhg0YOo97vaU47d4RAJZi9Gqqsxwp+X/OF32gv1EAjlt119ES588vt6+cI3Pu5SHC242qKv
	64eps49fABBu4GMNxRHziymVKtvLZBIibHJZwA6+2d3+u7mvnOCbFxUkZPi+giUeOFV6SXfQURb
	2XA4/njXq/DvAanyFu2DzlAOH851A8Ya0rSNKZhmkhsrZIWn5S3qyl6Ww9H/znebvg3gZSHKpn7
	x20DdrHBGbPdtqtyJseeG1dlLFUYqPMjxS5DU/bDxz801wEDW4WNuSunpnYR1KCS7+BSKAQVNVK
	vW4oZuT6HUFTlzW6kaF+IgaLQa84ZWBKVtPM5a5rhbGp66QDxpr6+tZvadinnUxeeWuVdz+05PC
	benjbw/6qbf6Nx1VGoomgt0ow2g0QlqtopfxrCKsZivk/w=
X-Received: by 2002:a05:6402:3553:b0:6b1:cea1:a011 with SMTP id 4fb4d7f45d1cf-6b1cea1a32amr3900125a12.0.1791903328563;
        Tue, 13 Oct 2026 07:55:28 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b179e03428sm6169161a12.37.2026.10.13.07.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 07:55:28 -0700 (PDT)
From: Kyrylo Biryuk <illofspeed@gmail.com>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	snitzer@kernel.org,
	agk@redhat.com,
	bmarzins@redhat.com,
	dlemoal@kernel.org,
	hare@suse.de,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 4/4] dm zoned: do not busy-loop idle reclaim when no zone needs reclaim
Date: Tue, 13 Oct 2026 16:55:22 +0200
Message-ID: <20261013145522.17499-5-illofspeed@gmail.com>
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

An idle target whose random (and cache) zones are all unmapped keeps its
reclaim work running without pause:

  - since commit 90a9b8693f1b ("dm zoned: reclaim random zones when
    idle"), dmz_should_reclaim() returns true when the target is idle and
    the total number of random (and cache) zones is non-zero, whether or
    not any of them holds data;
  - dmz_do_reclaim() then finds no candidate and returns -EBUSY;
  - dmz_reclaim_work() runs dmz_check_dev(), which checks every device
    for media events (a TEST UNIT READY on SCSI disks), and
    dmz_schedule_reclaim() requeues the work with no delay because
    dmz_should_reclaim() is still true.

Without the previous patch, a pass ending while the target is busy and
has enough free zones can leave reclaim unqueued, which ends the loop;
keeping the idle poll armed makes it recur whenever the target becomes
idle. On three 27 TB host-managed drives used
without cache devices (all random zones free) it kept about three CPUs
busy and sent about 155,000 TEST UNIT READY commands per second to each
drive while the target was idle.

Only reclaim on idle when a random or cache zone actually holds data (the
intent of the "p_unmap < 100" test that commit replaced), and
handle -EBUSY like -ENOSPC: nothing can progress and no I/O failed, so
poll again after the idle period instead of rescheduling at once, and
skip the device check. Use queue_delayed_work() for that poll so work an
allocation has already queued is not postponed.

Fixes: 90a9b8693f1b ("dm zoned: reclaim random zones when idle")
Assisted-by: LLM
Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>
---
 drivers/md/dm-zoned-reclaim.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index f1f9adf6039..0d62ade1466 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -470,9 +470,10 @@ static unsigned int dmz_reclaim_percentage(struct dmz_reclaim *zrc)
  */
 static bool dmz_should_reclaim(struct dmz_reclaim *zrc, unsigned int p_unmap)
 {
-	unsigned int nr_reclaim;
+	unsigned int nr_reclaim, nr_unmap;
 
 	nr_reclaim = dmz_nr_rnd_zones(zrc->metadata, zrc->dev_idx);
+	nr_unmap = dmz_nr_unmap_rnd_zones(zrc->metadata, zrc->dev_idx);
 
 	if (dmz_nr_cache_zones(zrc->metadata)) {
 		/*
@@ -483,10 +484,11 @@ static bool dmz_should_reclaim(struct dmz_reclaim *zrc, unsigned int p_unmap)
 		if (zrc->dev_idx == 0)
 			return false;
 		nr_reclaim += dmz_nr_cache_zones(zrc->metadata);
+		nr_unmap += dmz_nr_unmap_cache_zones(zrc->metadata);
 	}
 
-	/* Reclaim when idle */
-	if (dmz_target_idle(zrc) && nr_reclaim)
+	/* Reclaim when idle, but only if a random or cache zone holds data */
+	if (dmz_target_idle(zrc) && nr_reclaim > nr_unmap)
 		return true;
 
 	/* If there are still plenty of cache zones, do not reclaim */
@@ -543,17 +545,19 @@ static void dmz_reclaim_work(struct work_struct *work)
 		dmz_nr_rnd_zones(zmd, zrc->dev_idx));
 
 	ret = dmz_do_reclaim(zrc);
+	if (ret == -ENOSPC || ret == -EBUSY) {
+		/*
+		 * No zone to copy into (-ENOSPC) or no zone to reclaim
+		 * (-EBUSY): nothing can progress now and no I/O failed.
+		 * Rescheduling immediately would spin; poll instead, without
+		 * postponing work that an allocation has already queued.
+		 */
+		queue_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
+		return;
+	}
 	if (ret && ret != -EINTR) {
 		if (!dmz_check_dev(zmd))
 			return;
-		if (ret == -ENOSPC) {
-			/*
-			 * No zone to copy into: nothing can progress now.
-			 * Rescheduling immediately would spin; poll instead.
-			 */
-			mod_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
-			return;
-		}
 	}
 
 	dmz_schedule_reclaim(zrc);
-- 
2.43.0


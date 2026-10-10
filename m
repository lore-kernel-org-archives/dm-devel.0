Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB743438BB
	for <dm-devel@lists.linux.dev>; Sat, 10 Oct 2026 16:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791648979; cv=none; b=RDUrQPXCj7Gbo+cVyMLWdKd+vBih7EZ9mcLacGtP588DhV/yOS9guHoisV91qE4Fzbce2d0YLO2c9yTuWFSs/7U8sYpYfP5uNeWrGlbAYBHo/sR0K44dFDkytkFUP8ZpAmB4VzF0SJDK+//vjJ1tZR9zg+PlYwJpenz5OkinH70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791648979; c=relaxed/simple;
	bh=ufd8rhV80UCqkXKJ/U/urcXuErq0bBJ18B91X+bAywA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b64XuWXp8eFbTUeBrcn17e16asNbKl80AZcTOkA/A3CKUtm5HWZVNq4z3PuBSWfVT3ae7C6A/+3rh0J93fNAmsO0UN2oOAdg1ZU3if0Uk1XtgxIRT0sDTji0nEt//df6ESzPtFEfciS0cLpDzZoEeI3+UCGIwbFDCZtD+0tV3EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eq8JddNd; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eq8JddNd"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c2a4e013a44so103970966b.2
        for <dm-devel@lists.linux.dev>; Sat, 10 Oct 2026 09:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791648976; x=1792253776; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3XWf/RWrFZXj82yePfTV0/gqexEn/Us7le/SNtuaxG0=;
        b=Eq8JddNdK9Fxl4F1xFSyiBAEq+VMPUcskTG0xI/dxjoD4fNXSfF4mMWoebMtIABkta
         iLDsSJpI9sMFv6OmFr7a1PpbaZzfA5ezsMejOrF8kUuDWJtf0NrT5N5gB4VYNY6mjDkN
         24hfGE+wA2VC3ceyzW0soC9icQ3zb4t85fkV/p7vhbue3PzBs71fc+DLvtIcvST7hnRO
         A379q7cdjXhpTgOYSUnnrU32lxpTKjvRlvmrUNDVN1bUpSJaZP2HNT7zQNixs+6dnWrJ
         9NoUYbr/Yp0g5COfSXhK5dCO2yBiSOmxw81afYc2n5HCjMNge9YLTbHdUSBB5/u7rS/y
         u97w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791648976; x=1792253776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3XWf/RWrFZXj82yePfTV0/gqexEn/Us7le/SNtuaxG0=;
        b=lSG/9MNHWp5fi0Zq/8g87EwVyXjJ4zhMQ1uud9Z6/t7QIlCRbu1DTIxgbrQsoCU6ob
         omyfzejqpouOFqNZhrl11R4etCrEy/X0Tgsc20NVzSKQpEQbqhrngtpKqXfPYmMCV5P0
         oJUfIsteR1NZsGdMlX7fJaEryBvcoDaXgTMPKZ4xuK2okoKULjkgrzgS0qlcqf1h6UtN
         fykpCUrUmM9Uw663H/nRWzTD48RkGMD0A/RrdDBjImvSeeymJpYEhTnp3M8Auoo5xdzm
         rCf6ERfGoIZDh9C4HGF6uxfRtfJIwg0iBd1KXObO1wt/4eeQyB8s5f8gpXfEmJWR3Rc1
         /bYQ==
X-Gm-Message-State: AFq9FYKOFzQMUNel5fCjYEhvrvoomv+xMRFTT49UmsRumGBLfeluK49y
	W3/x32CPi6pk34F83hd6fO1bvCgVDhIONDbJiA0AO78sgQwNuk0p+HxvaNl4bRtjLuo=
X-Gm-Gg: AYBFou3esKRjkD8N4S+j83wJz0ILiLENNu4l+kCmY6wOh6PgDTKSvBSfvKDJk2gakbI
	tyBAh2dC8RAgTDlAhIc1RrrmDEgDtYkfQ8tgmwbAA8++LLO+qA2YEKim7VUkoKJ43EHAxpAifHe
	6vowL17BPvCy1cGWdDLg7cm0zRH0VDQsQo2tADSEBDKpvrS4oDVBJZdVV1a3BbngoKfk2PSLksu
	GNu6CzOsYRGKsOYqo3Jt2qm31HFzuUlcGEmaLg3p7banF1yiFl8FOv614yOQfyiO1yECYZoqON6
	YLb6whY/i3O0xwPMkQIWnUkwPnttgfLN7Xm5s0M4pEwtINzyqjW/MkMVtt/WFYaQ1C44wnAqN5e
	/zm09QxiThCwbicsjJVj3ILvkG8jinwsG5ypAYky7tlrZI24laLr/QGbve0KVDZJDxgLkSggy1Q
	HX/fhY3pE3gtWk23WET+Zn3fEkuACnbz4f2vImxZ249pYGSg7G3aYjDxfXLG+4nsHWrslYTeMNF
	jAut3C3JhLYZbwR3JPTO177nPxd9QfRQoeS7OHHKvGSsjYE
X-Received: by 2002:a17:907:8d8d:b0:c26:306f:289b with SMTP id a640c23a62f3a-c31a9b0b097mr464030466b.13.1791648976036;
        Sat, 10 Oct 2026 09:16:16 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9a74bd7sm261422066b.37.2026.10.10.09.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 09:16:15 -0700 (PDT)
From: illofspeed <illofspeed@gmail.com>
To: dm-devel@lists.linux.dev
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	hare@suse.de,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] dm zoned: back off when reclaim finds no destination zone
Date: Sat, 10 Oct 2026 18:16:11 +0200
Message-ID: <20261010161613.396-2-illofspeed@gmail.com>
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

When dmz_do_reclaim() fails with -ENOSPC because no free zone is
available to copy the data into, dmz_reclaim_work() still ends with
dmz_schedule_reclaim(). If the target is idle, dmz_should_reclaim()
keeps returning true, the work is queued again with no delay and the
worker spins on the same failing pass.

Re-arm the idle poll instead, so that reclaim is retried after
DMZ_IDLE_PERIOD. The next patch makes -ENOSPC the expected result when
an idle target has random zones but no free sequential zone.

Tested on a 7.2.6 kernel as an out-of-tree dm-zoned module, together
with the next two patches, on emulated host-managed drives (tcmu-runner
ZBC handler) and on three 27 TB host-managed drives used as md RAID5
members.

Assisted-by: LLM
Signed-off-by: illofspeed <illofspeed@gmail.com>
---
 drivers/md/dm-zoned-reclaim.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index c041413c729..315f0da99f3 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -540,6 +540,14 @@ static void dmz_reclaim_work(struct work_struct *work)
 	if (ret && ret != -EINTR) {
 		if (!dmz_check_dev(zmd))
 			return;
+		if (ret == -ENOSPC) {
+			/*
+			 * No zone to copy into: nothing can progress now.
+			 * Rescheduling immediately would spin; poll instead.
+			 */
+			mod_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
+			return;
+		}
 	}
 
 	dmz_schedule_reclaim(zrc);
-- 
2.43.0


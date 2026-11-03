Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793743484;
	b=aYJLcboiispTYzxRY1SRiRhyNM2ISbNKFeN6uF6CuFFWCAxiJcLZQ71YhrEFd+Z0sYu7
	 0yXLWRADb/eatoPLrbCJSRXXjoMeOxl1k+8KJSOLBP4blAwLj35cl5BgkaG42PFLgJtbK
	 rQrcA58VLHWMTtwbtXY5MBdsHLP04+wtm7ciPAgNYR0gQ95OBDgitZkAIbmoehwYdjRk5
	 +j4xOHxHSRALTunmpCnJzJOTA85efwzNLaOqFGN9pD4l6+NHUDC2iIxgdqmIn+1BgHIP4
	 ORHoUWe9sOxkA6YIum9bo4NuqFCV/jdNbhacINMelz4E5Tet+X/jEtZHTvR7nFDJi3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793743484;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=r4YfPovGw1xdQbc6iuyAAPONvKXoCo5XL7Z8YypY/D0=;
	b=BEc1wXSRG58eO1SyFYss1Vq4mkRUMmyVx1L3CLeXrNhGGX4ol0AklZcruGGFHFuqcFkJ
	 qUoBaFJkg8n4mqeuQHhXfMIaV5awh8EasX9GoFamtECogP0Ifyub5lMfjfXItFmTpM8d+
	 bJyKq/4VlNfdmdj7dxfbj2n/+0EGv2af+mt2sKKFMzeSu6myoFFYEbUVdeHeIYXV7fmpk
	 SnrCQRmkc2gAb6S/GB7d4A/q2Z6WMdi7ecPOJQ3fdBypZQUpt0ijOQCZbuePFuNE2do9r
	 ZXG789cBuv0Iu8kEn58+9ocD5XSxrAWfiNDR2L4kXBl588hVGXE5e9nDt3DOa9suQzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="hu9s3S/t";
	arc=none smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A5E606A32F
	for <dm-devel@lists.linux.dev>; Tue,  3 Nov 2026 22:04:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5A5E606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hu9s3S/t
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c45551fa84eso12675066b.3
        for <dm-devel@lists.linux.dev>; Tue, 03 Nov 2026 14:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793743482; x=1794348282; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r4YfPovGw1xdQbc6iuyAAPONvKXoCo5XL7Z8YypY/D0=;
        b=hu9s3S/t2YwejgFRS5r48HlhT51LA6N1M/rJkInTsL1V3NwKx/8tSEO7uQbzEdJPmx
         0KIrbr9l5MZJ9Ypk4UQHCxYwYw+dhviIyBMGiOA0/6htvjFRmWt17gPYpCvPLNVnGovS
         ElEFgv123B0BlFMovkNSIBd1umoeRaLMtN31UnlZ2aALBmDVeNcJl5jSszPDFp9Jspza
         aHAeascm0uxBg/LIshisIYY/FKdlydgllHbr6ZXBjKJ9SgeuIomZMkfbidL2dyreq1/B
         r0ZmYWcorkixdWYKUyI3aywg8X6xYfeMChM0LfVYzPPLcNqpSF0xR2H+Jd72tUs/NkBl
         /sKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793743482; x=1794348282;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=r4YfPovGw1xdQbc6iuyAAPONvKXoCo5XL7Z8YypY/D0=;
        b=dfPO9mj9xVEgeexjKjrGgUkdMAs3oscheHbIWt7fzpaUtjw86ftJYOZ0co8BLisoGb
         lXEpGsyf9NDVvqfw42kv0gZniEewN6yxBPG0Qad3WeSZvjnE+p1qdqLGHS9/jHd4ziDi
         luNGUXZEvwnVKlNokkjSP+pdbKhczLZbIfACeNX6M+4fob1K1SUc74BTUqbkjS1NIElo
         E+0xgOtWMNoZQx+DJV4WtntkSyHVmHHTMB1CX3uwNTBlm3P6mGJvdZVjY3bjWv7csN8o
         CtsgiSewponM51QklGsAvlSwXFf2FgSgCsQhtgO0jXUHRraKlgIf7IZuKeRfsK1OPF1y
         NNnQ==
X-Gm-Message-State: APuU4Z/TFse7usMwKUqh2RP920btk+x+Nfx7YZr2QHjxOq4ScjZ4nwHA
	p7LllAt/oqMTaNJ0PUp3Y/mfUt0Ou4ELm730sPSiEmUnTrsjQqDAl+OvalZ1+C2g7gA=
X-Gm-Gg: AYBFou3ZJLV47AjgzgHb1cgYaJXbyQEK90U6H9HgegpWcm7VyQH9NZC5cDLjqAsVcIp
	n9p4lDRi/2e1m00vf7bZXFex4+jJowROhbTdye071ZYeIPTGMb8ztd99ivRTWJlMhDIWlHppB/M
	/gBkta12hPMduvYUY4hkbAbVojejGgAini5dGYc75Qj7WeqLLe6XJQ+uRSt0W6DzMRKlevVEySl
	B18JWDgCtZQVTa/rAv7hIfzrxWjNSWXGbMhgW+Fp/HqVG1xogPXGlrMQ0MFBtcidthu1viFwvej
	Bjcl4ZhiD3qBuNcWOrTHXuz8+DdDISwo0m5X7AqJXny/gxJFR/Ngui4irD6WoeIgFFWdkxu1bTR
	TDredARCmVNsx61gSHPs9lk+JjzaDn6f4fTQECei1z16LVVSwzM5TBqdILKTiJ9rGqOmBPr34yF
	F6IYwJqldPQxbQ7lrZn9MyxBz1XwirMSRT1H85G0DE3Rq/qZZl5BWQy0YLNCDef6azV36pLS0HD
	UUyAi8eFA8KjU5DdK7kTYluPPJGpvpr5rlmFGFxJ3GtisrylzJ4gRgJhmjLcis2TytGBfidlJ79
	vmiChDW4SDw6wb3EP0c9HuURpZ7oVkkGN5tZ2/9A7d6MXvfGnKkm4P4bRg6pL0iXfPaQ2E0il7e
	oiZUj
X-Received: by 2002:a17:907:97c4:b0:c40:dead:7466 with SMTP id a640c23a62f3a-c4ca7a40202mr1202821466b.20.1793743481738;
        Tue, 03 Nov 2026 14:04:41 -0800 (PST)
Received: from localhost.localdomain (host-188-122-3-146.finemedia.com.pl. [188.122.3.146])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d0e424c34sm4574266b.13.2026.11.03.14.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 14:04:41 -0800 (PST)
From: Kyrylo Biryuk <illofspeed@gmail.com>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	snitzer@kernel.org,
	agk@redhat.com,
	bmarzins@redhat.com,
	dlemoal@kernel.org,
	hare@kernel.org,
	hare@suse.de,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 1/2] dm zoned: back off when reclaim cannot make progress
Date: Tue,  3 Nov 2026 23:04:37 +0100
Message-ID: <20261103220438.510609-2-illofspeed@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103220438.510609-1-illofspeed@gmail.com>
References: <20261103220438.510609-1-illofspeed@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a reclaim pass cannot make progress, dmz_reclaim_work() still ends
with dmz_schedule_reclaim(). If the target is idle, dmz_should_reclaim()
keeps returning true, the work is queued again with no delay and the
worker spins on the same failing pass. This patch handles two such
cases:

  - dmz_do_reclaim() fails with -ENOSPC because no free zone is
    available to copy the data into, for example on a target without
    cache zones that has no free sequential zone left. The next patch
    also makes this the expected result when an idle target with cache
    zones has random zones but no free sequential zone.
  - dmz_do_reclaim() finds no zone it can lock for reclaim and returns
    -EBUSY. Since commit 90a9b8693f1b ("dm zoned: reclaim random zones
    when idle"), dmz_should_reclaim() returns true on an idle target
    whenever the total number of random (and cache) zones is non-zero,
    whether or not any of them holds data. Each pass then also runs
    dmz_check_dev(), which checks every device for media events (a TEST
    UNIT READY on SCSI disks).

The -EBUSY loop lasts as long as the target stays idle; it ends when a
pass finishes while the target is busy and has enough free zones. On
three 27 TB host-managed SATA drives used as md RAID5 members (7.2.10
with the module built out of tree, all random zones free, target idle
for 300 seconds, kprobes attached, two other drives on the controller
being zero-filled), each member's SCSI device counted about 108,000
requests per second with the stock module and the system used about
915 s of CPU time, against about 46 s with this series. libata completes
TEST UNIT READY in software, so these counters do not measure commands
sent to the drives; the cost is CPU time.

When a pass fails with -ENOSPC or -EBUSY, retrying at once is unlikely
to make progress: re-arm the idle poll instead, so that reclaim is
retried after DMZ_IDLE_PERIOD unless a zone allocation or a "reclaim"
message queues it earlier. On a busy target, zone allocations can
restart reclaim immediately when free space is low enough to require
reclaim. Re-arming also keeps the poll running after a complete idle
drain. The poll can still stop after a pass that ends while reclaim is
not needed; that is unchanged.

Skip the device check for these two results: they normally mean that
there is no zone to copy into or no zone to reclaim, not that a device
failed, and the I/O paths check the devices themselves. Use
queue_delayed_work() so that work an allocation has already queued is
not postponed.

A pass that fails with an I/O error, for example on an unreadable block
of a device that stays online, is still retried at once while the
target is idle; this patch does not change that.

Tested on 7.4-rc1 with this patch and the next one, on three emulated
host-managed drives (scsi_debug, 1 GiB, 32 MiB zones) each under
dm-zoned as md RAID5 members, all random zones free and the target idle
for 300 seconds. With the stock module each member's SCSI device counted
about 70.2 million requests and the reclaim workers used 726 s of CPU.
With this series: 75 requests per member, 30 passes per worker (one per
DMZ_IDLE_PERIOD) and 0.08 s of CPU. Data written during the tests read
back with matching checksums, and no kernel warnings were logged.

Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Fixes: 90a9b8693f1b ("dm zoned: reclaim random zones when idle")
Cc: stable@vger.kernel.org
Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>
---
 drivers/md/dm-zoned-reclaim.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index c041413c729..077a8a50197 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -537,6 +537,16 @@ static void dmz_reclaim_work(struct work_struct *work)
 		dmz_nr_rnd_zones(zmd, zrc->dev_idx));
 
 	ret = dmz_do_reclaim(zrc);
+	if (ret == -ENOSPC || ret == -EBUSY) {
+		/*
+		 * No zone to copy into (-ENOSPC) or no zone to reclaim
+		 * (-EBUSY): retrying at once cannot make progress and would
+		 * spin. Poll again after the idle period instead, without
+		 * postponing work that an allocation has already queued.
+		 */
+		queue_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
+		return;
+	}
 	if (ret && ret != -EINTR) {
 		if (!dmz_check_dev(zmd))
 			return;
-- 
2.43.0


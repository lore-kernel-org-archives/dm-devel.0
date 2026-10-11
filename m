Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451F037FF6F
	for <dm-devel@lists.linux.dev>; Sun, 11 Oct 2026 17:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791741296; cv=none; b=Zehq3dXe81nJ8Jn9oszP3RslvgAdzzsAaGZq1R/qoCHyhHo053niyrDzUdsbnR3EDwCiSTpJVJA8MeCP20qDNInrFutBy6qME1Gpxl3xUYTYe1riX9hc5OM2hQ8eD9B2nvS9wMN/z2OvZFJqqLAbUk6RLIZb2OCE6CeXNkMEz5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791741296; c=relaxed/simple;
	bh=hnZPPxNjNP3M+NNFcM7Wule6SFZ3tVs/Key1ofFfNtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBvmXdjH1ZMEsR4/lO1KvGSApLeivnfSoMU5mTl/DLoRiPmFc7sZrs2SNg6SFJM4mn6UIX7lliIpp6V/PyftGi5Wh1LRdp8QEzBj5b2Crf1AEG9/gbdT50T6lMW9MiNRI05DMe6pQcExYN6rN7oxPuqZFxppiDI6QAIEhWR9uaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ABvJdw4N; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ABvJdw4N"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c2e5f8fe879so202186766b.3
        for <dm-devel@lists.linux.dev>; Sun, 11 Oct 2026 10:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791741293; x=1792346093; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kHXmKJc8K9MpQJ3EOpjUbD2g6SFTRQKUsqdSG2/4nEk=;
        b=ABvJdw4NvhMCwtKud9yMJ2Z3yxniYhFseTRQih5ol8ZrpwOUBm1H+eAZBQROZkiIeM
         tk36vIs/kLMYJf177BhgiO701BUSOtt1SFOu7xvRL75PB8fej++aPfHYPvYhG8QSimK7
         swe9CDMmkXVg+v2VGMQYS4xi+PxGcUKHT35frTHqAKMtmrcZj3jHqkztcudV01wqVROs
         NBa3vWHCTiChF/4vqi7wWKZ+XLUnbELK4ht6QTXDA7C6EUz9eW7wY8l9vSGvVEMZ7IL6
         AihVYmVaiYDgQJRhlt2xp4rn1G/kdfHygddxvf6qh4z78SE80pMXaxkzC1caQR9yEdFh
         IkMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791741293; x=1792346093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kHXmKJc8K9MpQJ3EOpjUbD2g6SFTRQKUsqdSG2/4nEk=;
        b=MhVO2qNlLdZZbOmHtgYdhKNx/P/k+fzyxcLBBmWeFC3hDQrPpOqymC1n2V+cun3j3m
         chfoZuigWPH4hVfbx4+4F/JAqByqaVdRLCY/URMF0ipxE9BKU9C23TtgCXGny/5O0ICo
         KKhXgwj4VvHINyulD+r6EJHnWzimm9YuxgowB7PNUNvirpfBgNnV5bIPaocC6XrMoMST
         ZjxjgQaa0gqPmfLKwPMnKwzYhEZjquaHiIr1c8R/iSkUyIpO69bd3RdGTc7tJ2XEqB7E
         hNUlbSVJZDDeYNhfNQQkQ2PPyU/LmeaP0yltzsQEZ+/sXZV4R2SEsC50SxNHKDoYS8Tc
         17NQ==
X-Gm-Message-State: AFq9FYK3qTBbIDyS9C0GSWhHO/L/fhyA5WvDhB3CHsCMfhiEztdml8S3
	LStYQ5k4wITBJ/TO7iAhXiCpH4uGNsUnltGLQTyLJUVetJglY8xYzoIVNK2Owhr9Bf0=
X-Gm-Gg: AYBFou2UWabEgTlN0oOooigifNVSYAlL67KZvuI1Hh7fdzO9uRazvrQamEvKsyrISc7
	ry2OXbDloHQvxXpdbpQx+Tp82TjT1diRlxYD1LpsESsoJmfM3HaL8vCSDUVUcUKMxhHS9QzttOP
	l1wuu4L/v/OnaXg71lpat0kVVbRlaJZkjAatzohFD3TYwhPPjmHbDLRSjP6JJuYiI14yBAlxTCG
	rZxEo40N4mk7bc+9jAX2EZLUfzs5Wx/Mt7AsRp8edCebCY/wdHDVrw0vgRXiaOTC7R9hITPqzse
	Jvl9ysTykBSlT0mxkC3TdVET7ZS3quPHW5wdZyAd1mRQ/alEJBaA3QrwwPvPd6UjRZHVLQ4Qbea
	etkGnBL4uFzSf/lsBQH+Et3fJAyFAityTa9x6RC9fJ5UvR7lfBoHMvoBO6hqZTY4GhN1PgROwCf
	mNlnlbhIvpUq9Lat9T0eb3HCKOxm1fgQxAcZQe9bqcXfPt9BDojnDLnsaa73aCHWtwOHTDVMU0H
	5nSdDX7i29zk6UV+pub1lWF/wPoQBPg95zd4A8qTE5DwIs=
X-Received: by 2002:a17:906:f5aa:b0:c26:19de:9ac5 with SMTP id a640c23a62f3a-c31aa0960bamr707128866b.29.1791741293351;
        Sun, 11 Oct 2026 10:54:53 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9a9f776sm376806366b.48.2026.10.11.10.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 10:54:53 -0700 (PDT)
From: Kyrylo Biryuk <illofspeed@gmail.com>
To: dm-devel@lists.linux.dev
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	hare@suse.de,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/3] dm zoned: back off when reclaim finds no destination zone
Date: Sun, 11 Oct 2026 19:54:48 +0200
Message-ID: <20261011175450.952-2-illofspeed@gmail.com>
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
Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>
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


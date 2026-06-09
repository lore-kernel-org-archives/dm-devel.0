Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AFC1E5B9A
	for <dm-devel@lists.linux.dev>; Tue,  9 Jun 2026 00:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780964420; cv=none; b=SaWNYRkhhs+ae3hRl40C8d/RA6Td7K09yPL5Vzpq6bRLvJ6tjzVlcbusHkl7Hi14PayaAf4WvdycrzwD9sQfBNI+RdxZnrWer8Bv7J5h5GwyuIJchvpPLGh61koRIYUrZTRMkSTxqt85PYSEIS7LWLN7ikjsNGK6eEe/GNK+vCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780964420; c=relaxed/simple;
	bh=7WhZGP2cICdnREgoVW8aYWP8Q7k1DhucyowaI2s8Uc0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dwTe4NrHe2kSFkWnuOTzhRrYeoKBIJWzhNlQVg1zwGRg1RYijPlfFaBybahMZ5bVtJJ8xpMqyGZYV7ayzAMGf1pT/i3NZ3QoyoEtahvY2kqhTkv3XfMPO/lssfekJFSXO8XoYbhdKyXH4QyqHnY6Sp3NIvT4RCjWF/gICwjX/wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=XIZt1kBC; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="XIZt1kBC"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-9157b949fc7so553295185a.3
        for <dm-devel@lists.linux.dev>; Mon, 08 Jun 2026 17:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780964418; x=1781569218; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1B6hcMi4JQYw0AWjeOjCt8Mmo0xxSZegQC/IiQDWwtw=;
        b=XIZt1kBCrLYFmdnL9d8wGTBcCxWt1RluDgI+AAeCfw2/UJ+CmGhGdUeix3o1HhQ1ez
         uEw9pqbb+hrdf5obj6Fdeu6ntRLtnjsprmd4BtB9T/NlBib5JaUI1CryKRiapjbozyQE
         WTuRB1gRNE4Fk2+30zJz+ZYdebjE/GSWciMnEjWtzRU556mBwb8QhRcH6moidmdfrhIW
         7XQJxRxWkkOZImA6x+Gs6+UfsiW22uwy94hJJCP1qxOP5trzWziO76KgTi2xjJf/ID3x
         NEh4cVIEKlWdAscyN/3ZPdJ5T+Z+w1F6vzplDEfaDLlO09Dyglt/IRoC5pC+ghvmlDuE
         ysqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780964418; x=1781569218;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1B6hcMi4JQYw0AWjeOjCt8Mmo0xxSZegQC/IiQDWwtw=;
        b=dJYJJWxsjrRT7q8cuyUXT+IFwQNwi9G4Df8NzRBjNBXtZJrjfd65G4KohcAvj8EvpV
         6RP6lFIJqSox7NvHsfBW/LRn7Tyd0O/nXCmHXNlN4d4V68U1ZJbPpkESG/UAmAXl42R5
         7x3EPZiLgyDpnYeFqfE1D+M8aBMboyY1DfBrqn0pVL/3G98fSmfEAMo7UvxfwE2juF5C
         Z8vUE3v2/LIDHegI1EdT1eHMNsgrCj72FFT3I2A/yffSZfRYJY/VSkMBj8kflRYApP2Z
         MLUYhQfUGQd/OUmxCj5eCxlVeiH4qfSH4T21Tf9rOhcV344sCb0MSmzeazyKkb9v14yp
         uzoA==
X-Forwarded-Encrypted: i=1; AFNElJ/xpe7vmBSwCrPhVUj8QW3T8a4UbbqGrkbuKaf9bMbznrW/saEd5Eg2CwLs+AFpLNuiE31/wcOOmQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzQGrBYoYP9EZBDGGnYPSMHKg4OPsWzI9FiqmuSaB2llvCqvaUc
	StaLMKuVBz+fS9XfepXDZ+KGr9mmfRY9DkiDDOCJQMST6KQsFmRhTCoFOeuQ1h+YjVfk+qQ7WqA
	z4fq57wA=
X-Gm-Gg: Acq92OGR9JgzvLEaGwsD2Cy58HH8WtdfRkHwJMCDvOhzLs9ha9GV3OgM5Jy4bjkR4R3
	9bi0Q6RVQo1STPHxNzL3KYR5JzeGiz6nG8BM9T0vbFAuO7rxADza2eXAwIg1I/6jHgxBteG6njy
	eJvQzMfjXQ0sCnWilJ/2DorCrW+Il5h8w9W1giFeP1sSZWeo2OXMaXvkYNNfWcd+dX2VsfBDR70
	sDiuMWm2KDPeS5auLevP04lR+9rF13Z2SCaVdzdCa/v8tHdSy6J6kLeJyX7dSWnM0t3u4sUrNQS
	c69A/YHfHp0thHxN9zGzhMriZyJVoTHG2HyNckE2XEy5Si10BrHT4345N+OGOzDv3O17c39mTk7
	qyHMwzR8QfxOy9DKiXDk6nB0ju7kO4bqsTJD4eV430MReVDQMe6NLGJzYShmvV0l8ki/p/2jkJu
	fUXi8KrRCRV4nyU/b/vp79UxX28PUN6dhnfNzypV3kLAIQWO2b
X-Received: by 2002:a05:620a:440c:b0:915:6a2b:6265 with SMTP id af79cd13be357-915e831634emr38220685a.44.1780964417944;
        Mon, 08 Jun 2026 17:20:17 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-9158a243f24sm1924360285a.20.2026.06.08.17.20.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 17:20:16 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: Alasdair Kergon <agk@redhat.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] dm clone: balance ios_in_flight on fail-mode I/O kills
Date: Tue,  9 Jun 2026 00:19:27 +0000
Message-ID: <20260609001927.1235749.07e5479ceb80.dm-clone-fail-mode-ios-in-flight-leak@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm-clone increments ios_in_flight before mapping a bio.  When the target
is in fail mode, map() returns DM_MAPIO_KILL and the device-mapper core
completes the bio without calling the target end_io hook.

That leaves ios_in_flight permanently elevated for each killed bio. The
target can then wait for in-flight I/O that will never complete.

Drop the ios_in_flight reference before returning DM_MAPIO_KILL from the
fail-mode path.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
 drivers/md/dm-clone-target.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index c0f9b93983d4..701e03dc2685 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -1316,11 +1316,11 @@ static int clone_map(struct dm_target *ti, struct bio *bio)
 	struct clone *clone = ti->private;
 	unsigned long region_nr;
 
-	atomic_inc(&clone->ios_in_flight);
-
 	if (unlikely(get_clone_mode(clone) == CM_FAIL))
 		return DM_MAPIO_KILL;
 
+	atomic_inc(&clone->ios_in_flight);
+
 	/*
 	 * REQ_PREFLUSH bios carry no data:
 	 *
-- 
2.43.0


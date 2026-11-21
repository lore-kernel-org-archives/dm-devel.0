Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795281602;
	b=C7CPkzyxbeJHRtufVyzA9Ya6mbMU1MtiojrnBYF5YZM6ZN7ZKaIaZR4Q0psTEogTA9KC
	 a80ZyVmmmWThi4dAgUkAWfg+2DHF7zN9aD/pB2TcogIKBjBOrxm+/xlZkx+//5eN+dFPz
	 5FwWX94sFiYuOlSEi4+OpNMp2moR5dsnwbh1v4apqQIJS6NdvHbqRLKbr2NtvPjd90j+A
	 kFH6obES2rSM13nH1MQXCvD410eKyqcyFF7YjMrkUANxNKk+7XRfhyCGKCcTgGJers6Da
	 uYKXwNdslnDJmGrEbAQpnVExKWW4Z2kRZPOG2gjcY/4fDbDIlnflAv61pspyTjd0UvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795281602;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GQ/fZ00gtlf3ekDUWIes4m6B3nQfLfxFUKrDphRqdp4=;
	b=Mov2NB7OiuWf3m1cUDSZZSmxiVhxpYcYApdqeox0UpK5gd54jYY8Zdq6c1Oiv2tNHvuR
	 oaKCo8BFXmJV8DUEqBed28Um8GDuGFLBvi3zXrrgq3t9CmRfDdFgvqmwGpEKCg8eIz2Ix
	 s7O8yW8wBeqrfr0bn1Ovl4C7ZP/Dmex31h7JBKkXXLMqpXEUynPsCBuWbtDMWIqFWAHlj
	 NqMF9uVrXFomGdDh3yYD7FjvcQdWUfYz03Hp15zGHr3mNhY5yTc7EGhFLHfUCIX+vK9qV
	 wfI5Yym/9T0cWzNf4gZSMpSmzk4J5DF33JRwqr5yml1+NAPm0et4lRK7jzvTuFjNKOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=01IWQG17;
	arc=none smtp.remote-ip=209.85.215.170
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAB6606A320
	for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 17:20:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFAB6606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=01IWQG17
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cde827b7b95so73915a12.0
        for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 09:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795281601; x=1795886401; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GQ/fZ00gtlf3ekDUWIes4m6B3nQfLfxFUKrDphRqdp4=;
        b=01IWQG17KWqSQyegluiu+rdCGN6maeTLIeyOCOfiAtyHqW3SEjRv7uoxMYfkuMPsoo
         tW6abuDD4wZf8RY1qKgeE3xk5dApD53KTRUW4kkprgpcoXKpfRWLqfq8Rd4TJhn8/uwW
         1uDg5BCi4d3C9ixMpb5uiBUPx8nZ1gI32MGl87sGTLKCTgsQRnaGCRiu798TjVAlEoeQ
         4WrXzlD1hkE4WOCFJ9TKWTdpK0ZlKLO01G/eJFzcxbZrF2bv/W6eiCiUnEOCk34xML1G
         lJYlAn5J4pSJJRTQYn0JYElHIxT5XLUv7EKp6fVUu1kR/YpMzTH6BTLHRPI5rI5pGA5v
         Jw7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795281601; x=1795886401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GQ/fZ00gtlf3ekDUWIes4m6B3nQfLfxFUKrDphRqdp4=;
        b=ZVeD94n8TawI+mASe8jxCTx24wCVh5QceKudigHlZBfau8weP4+F750jvC1czvvFPV
         ExmdeZfcLoB1ccjUOtzJHL/2EtzxYThs9CpiuF1A37pucV+loenih6aETLdtmyKsSqja
         +n/9LhPDdLO2/vhWmOkBOXHlJLOyREN5IVcRwIHO8/8MGXQYvkOCf6fJmp1GcqMT6t7s
         Vmec8kaKCf5jdwrP8iEH7qFodJesO6gZvWA2Mjd+5tPUFTJdMGI7wJAywB3Wu/vKBpkQ
         jXTmzR0R3v8HkvVU55N6P5raXNXu6Dsuh8mn76hSiKWSuKuSDbzIwuKm0QRDgl1QPatm
         ySAg==
X-Forwarded-Encrypted: i=1; AL+hErEDAyfFmlURUgawUCqmiuvZAqM5uG91nhIebqpNf9yMc8kz+8gtJYhHp2ls11E9uT/HLarPZpeujA==@lists.linux.dev
X-Gm-Message-State: APuU4Z/p9oQxGE0eunO2LDUNvMFC6AS+u8mcnXGoyLp3LCE2JbKfjAdX
	ScZynm9dkBXBvaSMR4nXRR475iJv4/+GOqofE23MZZ035zbzwLeMSZYC
X-Gm-Gg: AZFdTZeIpopk7HGs+RRUMPERgbLp/hL1VI+YPuHb24TlmqTWbDFlYz5nUf4hbzquIAL
	MKmMHXjK5fakq/6R6kW8G1gkvLylx47NPgu3eBjXWqzLZP6ginWD0hQYMFDFhOcuXYe2qsmJNtx
	2ulopAUXhHuZfUkPbeKArFEGeRltgCuLF+YUDNBiozeIbvBcdE01gBlnrdEgGfkM+Ka/v8LvixE
	kJ2sF6Ip/12GM6c4a8CZ+h8+VSubTVT1/vssLGMFq1PEau01FQcQYhem+gNonQk31VOJPIhl6Xr
	S5gQzJqENG54fsfMR+oL01ZoeHg3CZHQQiufKZkPxq3sSBqhWVaFON9pk9cTu4wjwBPjCJEIH2k
	ufUFBuRgM8fHQq0tKAITf5hAg2aJEpbGDvv+hF7KX50W8yjJ1hmk6VhEB6RedPWn/VpyMCyP6EC
	sMFf5cVozd4UBvzTl9mjN3HIEhl2+q0vORQQHotcGiZQdb8xVenYoITQVl0kdevsOJeHTAfV/CO
	CJ19Rmc4Yz3/ecWIn/wbaZa7cwwkrW8/alS+H7OfCQblW2dtpwgllaWBeQTxhAweOuiUjCq87vw
	cippybhFNuZLF2QAyzHUCtfhVzoKGq7opQvxhNMVy6ml2lnSlIvBv+rOZGKvIxor+rSWRSbBfUP
	2CFO+cXmaH87xtXSpLt/J7KXndtc58g==
X-Received: by 2002:a05:6372:a713:b0:3de:7bd5:fb47 with SMTP id adf61e73a8af0-4014d1590ccmr5761941637.39.1795281600864;
        Sat, 21 Nov 2026 09:20:00 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d028a54sm2585657a12.18.2026.11.21.09.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 09:20:00 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: agk@redhat.com,
	bmarzins@redhat.com,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	okozina@redhat.com,
	zkabelac@redhat.com,
	dm-devel@lists.linux.dev
Cc: yangyongpeng@xiaomi.com
Subject: [PATCH v5 1/5] dm: wait for in-flight messages before postsuspend on destroy
Date: Sun, 22 Nov 2026 01:19:31 +0800
Message-ID: <20261121171934.3847617-3-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261121171934.3847617-2-yangyongpeng.storage@gmail.com>
References: <20261121171934.3847617-2-yangyongpeng.storage@gmail.com>
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

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

__dm_suspend() ends with set_bit(DMF_SUSPENDED) followed by
synchronize_srcu() before its caller runs the ->postsuspend methods,
so a target message that passed dm_suspended() has finished by then.
__dm_destroy() lacks that final synchronize_srcu(): a target that
implements ->message and relies on dm_suspended() for serialization
has its handler race its own ->postsuspend when an active device is
removed.  With the verity messages added later in this series:

CPU0                                  CPU1
target_message()                      dev_remove()
  dm_get_live_table()                   __dm_destroy()
  verity_message()                        dm_table_presuspend_targets()
    dm_suspended() -> false                set_bit(DMF_SUSPENDED)
    dm_bufio_prefetch()                   dm_table_postsuspend_targets()
      __bufio_new()                         verity_postsuspend()
        /* b->hold_count == 1 */              dm_bufio_client_reset()
      dm_bufio_unlock(c)                       drop_buffers()
                                                 /* b is held: WARN_ON */
      submit_io(b, ...)
      dm_bufio_release(b)

No in-tree target is exposed today: every one with messages
serializes them against its own ->postsuspend with a private lock
(multipath's work_mutex).  But the hole is in the core, and any new
message-bearing target that trusts dm_suspended() falls into it.

Mirror the suspend path: set the flag, drop the SRCU read lock (the
table stays pinned by md->map, which cannot change under the suspend
lock on a device being destroyed), wait for the grace period, then run
postsuspend.

Fixes: 3f77316de0ec0 ("dm: separate device deletion from dm_put")
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Assisted-by: LLM
---
 drivers/md/dm.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 38eaae8ac9b4..921b8c85f10d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2736,6 +2736,7 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 {
 	struct dm_table *map;
 	int srcu_idx;
+	bool suspend_targets;
 
 	might_sleep();
 
@@ -2752,14 +2753,21 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 	 */
 	mutex_lock(&md->suspend_lock);
 	map = dm_get_live_table(md, &srcu_idx);
-	if (!dm_suspended_md(md)) {
+	suspend_targets = !dm_suspended_md(md);
+	if (suspend_targets) {
 		dm_table_presuspend_targets(map);
 		set_bit(DMF_SUSPENDED, &md->flags);
 		set_bit(DMF_POST_SUSPENDING, &md->flags);
-		dm_table_postsuspend_targets(map);
 	}
 	/* dm_put_live_table must be before fsleep, otherwise deadlock is possible */
 	dm_put_live_table(md, srcu_idx);
+
+	/* Wait for in-flight target messages, like __dm_suspend() does. */
+	if (suspend_targets)
+		synchronize_srcu(&md->io_barrier);
+
+	if (suspend_targets)
+		dm_table_postsuspend_targets(map);
 	mutex_unlock(&md->suspend_lock);
 
 	/*
-- 
2.43.0


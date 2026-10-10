Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7272245562A
	for <dm-devel@lists.linux.dev>; Sat, 10 Oct 2026 11:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791630361; cv=none; b=LdVYDTJ8aBVb9ikEN24po2pWew28MDg0EDb+/j11duZ2VmEs3aNem5GuSBX3jVzfLwfd7rdpioJ0Pd2N0XaoHjXXp22WZ1rXi9ftz1n3QQukC0ZemR4r1JjatHmkJd0aySTC5Jwa5CRCkOJ0UWtENCHVNKmFNpofcoGpssRXOGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791630361; c=relaxed/simple;
	bh=kKE5lJKCeKFHTlSjHAwWIc188HUJ5ydRp/vVk+I0o10=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Du7u7q9RDOcRUS4aHNX1gCW7uzSv3JEwPhfrNDImFWtqonbzwlPV+ydM3ElSnPpSJEX0/kQcXn5mJz58qlhFhC4EkipbSBAg5ZJ4KgXduyxcZZhX9OzsRVPnYOHkf86RPon7KCUMRFXVhRdjKTuwWcxWAFVqdeAQTFP5kl0eUKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C8SjteDn; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C8SjteDn"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c2e7496f947so90953566b.1
        for <dm-devel@lists.linux.dev>; Sat, 10 Oct 2026 04:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791630355; x=1792235155; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5TBTK9m5zIZxCsoaKbbvRm0dS+Yp7Izqn9/uHRg/9dc=;
        b=C8SjteDn2GK4JyUTw1G+AWkp1P3T1HHvyBuy8JTGXrQLhhxaW9i+YV5JIn1Vwy8x5b
         VavcWEpOoA7gMcm+hPZvVrMnBDS7zEX1PLjd3LJ6HcUVSQNkQILr7CMzwoKlLhwNaEpt
         Gp3AX8EFa+XrAIcYhuhvin2L/ye+hu6xgg5ZuHBGh5xhDZzYLvKqjo8XiYaQJCWslujB
         FqZ1nMV1xIvDD4J4YCfetwS2L7p8mP4jKCSbsVQ00dxoFNXxBXifoyYAkT5dlKVaMscJ
         yG3lXHcbylsJqrPV/p4Jnj3jESTpiFJsvkYHj8pFVovabxcbBYGaKu6RuKWonl+/jTe5
         6Kjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791630355; x=1792235155;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5TBTK9m5zIZxCsoaKbbvRm0dS+Yp7Izqn9/uHRg/9dc=;
        b=wnKCM/6hLe9w84na9/xlv14w8xr0Ryg914KH42Mgl41a8siwDVnOrBIACJsHE8z0nE
         GwbSZBZZ71qoWdVmSc8I0T7o/BWPa+GbT+B1Uj8Mw1ywcbj/sMXVjdsQ9iudIaRql1hz
         fMb3h6Ci/PQMxjrVLAeamtfsPU5wMojsdeT4NWYjb2MW2iOs2XItcmZJ9RNwr7Tvn4dq
         mp7j6MCKg6kCJuMSVoz2bscH+H2W3tBo2CGzt6IaNywMLjAr1FtOej0unrkwUpvDRn8o
         w2stGZ/t+9t66nIVoM2oqPx+ZUwNjfSbvWXLh/8NasL67713tXG48KvXkVdQQc9j0vOh
         Yhcw==
X-Gm-Message-State: AFq9FYIjku97nczHDT0rwnkW6K1SnuoAivEYvqIR2uReCh4ot09Ua+KG
	KNxhaQM7a3igc0Gi/wKaCbdND+u+7haMvAd81sf7Si0eaJqbLPgR5WMh56dgJpQJtgQemTjnZAs
	=
X-Gm-Gg: AYBFou3Gvco505M9g+QYD8R5rw0LnlPmNORQZcGBuYCX00jggNNMV3mMxHHU6kaiW5N
	IomLz4195wrfyJZ/bmCy+mJtxoLCkBprXCOsMDF3pJYdlSUknXMbgM+r79GYcylZIq94ppEyrj9
	CAEbWI5I5AOw3v9Ciy82bU2vKN4L/M0C//FC3g5L19T0T4bJw/TmU6YgMPbzpaB8VMF7yqx8r8U
	0kS/eKXPWWAT/yPbj1HSah8B8N/VJ5lhCd4UpNODSnQV2I9URS64NctoE5jwHIaeY/k6+EIyaYh
	2/0zSoD0mwZKapyg8XHA6VGS+tfxjtQULPMuu/GeOqew9xnsHTznB170VapddtsjThmuJZxFzmm
	kY5O+mpLf+2QL9MXEJP7Nt72zPif1HhzX5vjd3V+fzwtZsCE4dbyTNmM4x5SZUo8zbz+LPTxsMD
	vKuXTCGPWDZX0cwHpN8KyQ/NBicX4MBZcow52yOnQyZ0W2Seoltwon1BdaLaIgTu6R2ehOi/g1X
	VsLw4rnNgQrEPyFjmqZSTDTALUv50Gdt542zB+eaHuCDvOg3QX5Qo2cW4ohiAC/8A/7UObyw6vX
	neM=
X-Received: by 2002:a17:906:d54a:b0:c2e:8eb7:53df with SMTP id a640c23a62f3a-c31a9ff6379mr476976566b.44.1791630355312;
        Sat, 10 Oct 2026 04:05:55 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9a7cfd8sm231669366b.44.2026.10.10.04.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 04:05:54 -0700 (PDT)
From: illofspeed <volvo.mail@gmail.com>
To: dlemoal@kernel.org
Cc: dm-devel@lists.linux.dev,
	hare@suse.de
Subject: [PATCH dm-zoned-tools] dmz: check: do not use the write pointer of conventional zones
Date: Sat, 10 Oct 2026 13:05:53 +0200
Message-ID: <20261010110553.379-1-volvo.mail@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With more than one device, dmz_zone_is_cache() only matches the zones of
the regular (cache) device. A chunk mapped to a conventional zone of the
zoned device therefore reaches the write pointer test in
dmz_check_mapped_zone_bitmap(). The kernel reports the write pointer of a
conventional zone as -1, so wp_block becomes garbage and the bitmap loop
reads far past its two-block buffer: dmzadm --check segfaults
("Checking zone bitmaps..." is the last line), and --repair could clear
bits based on that memory before crashing.

Treat conventional and emulated (regular-device) zones as having no write
pointer: every block may be valid.

Found on a cache-device + 27 TB host-managed drive set after reclaim had
moved chunks into conventional zones (stock 2.2.2: exit 139; with the
patch: "No error detected", also on an emulated ZBC drive with the same
layout).

Reproducer (scsi_debug zbc=managed, no special hardware):
https://github.com/illofspeed/synology-host-managed-smr/blob/main/repro/1-dmzadm-check-two-devices.sh

Assisted-by: LLM
Signed-off-by: illofspeed <volvo.mail@gmail.com>
---

Notes:
    The addresses in README.md are out of date (wdc.com, dm-devel@redhat.com),
    hence this goes to dlemoal@kernel.org and dm-devel@lists.linux.dev.
    
    Related kernel series (dm-zoned idle reclaim):
    https://lore.kernel.org/dm-devel/20261010105122.398-1-volvo.mail@gmail.com/

 src/dmz_check.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/src/dmz_check.c b/src/dmz_check.c
index b13d025..943308b 100644
--- a/src/dmz_check.c
+++ b/src/dmz_check.c
@@ -509,9 +509,18 @@ static int dmz_check_mapped_zone_bitmap(struct dmz_dev *dev,
 	if (ret != 0)
 		return -1;
 
-	/* No valid block should be present after the write pointer */
+	/*
+	 * No valid block should be present after the write pointer.
+	 * Conventional zones have no write pointer (the kernel reports -1):
+	 * every block may be valid. With more than one device,
+	 * dmz_zone_is_cache() only matches the cache device's zones, so the
+	 * zoned device's conventional zones reach this point.
+	 */
 	bad_bits = 0;
-	wp_block = dmz_sect2blk(zone->wp - zone->start);
+	if (dmz_zone_conv(zone) || dmz_zone_unknown(zone))
+		wp_block = dev->zone_nr_blocks;
+	else
+		wp_block = dmz_sect2blk(zone->wp - zone->start);
 	for (b = 0; b < wp_block; b++) {
 		if (dmz_test_bit(dbuf, b))
 			dzone_weight++;
-- 
2.43.0


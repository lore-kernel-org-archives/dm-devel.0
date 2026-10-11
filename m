Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03762673AA
	for <dm-devel@lists.linux.dev>; Sun, 11 Oct 2026 18:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791741771; cv=none; b=DBP/eFZu1FYo9kmwq5BWXmTV8J/m1o7MPeyeWM8HYU7EGO9oXr0wN04jikVpK+66xMHhqQgUGDzvpBNT7IBZzwwXmlAtxuetaJ0fYlKn+NDDelX7xFGxhflcQgXuW6oEzAusXUgR0WegZpj2Bc7l/VRTqwpCq8eevLNXhaF6vVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791741771; c=relaxed/simple;
	bh=NCTQG5NYRe6CvsJnzbiFBIUSR0PK0k0ivERWSeh9S2o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=estveGDxIMdqYoZW3Cb30i94x/6BmYB0rp7F/CUJGQ6U0dKAW3zfMItITqMKqnzeXWdZ7wo7QOUf59N9F6GBXTQN0vZ8iKnkEZa08679bb1jlCFQCUFYHXtqnoqz+ZgLC9BL/JgPui0hha/lnE5zKMiEG+10/AIvKCO4T/p65mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j20S7IUI; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j20S7IUI"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48af4d4e61fso703518f8f.2
        for <dm-devel@lists.linux.dev>; Sun, 11 Oct 2026 11:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791741768; x=1792346568; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ew/EmDhQFxa3pLooXJmh8OkoTE6RmMtwxoNU3Ecf/MI=;
        b=j20S7IUIUPxlyiDiPR63myUcXxEl7FllKNASnf0aTSuR71sEBsKYAfYn4+CTspH0yA
         8S8XQipdsZ0EjnSOP5eCvrHdBHVj+0T0mLYygN5i6uU216BaCuAsTNDkPfLvzG+XBl8o
         Xbq/8v0PV0G1OFnCWt3Sf8KcQuJo/8pDJ7f6f6kF+rkUHHdGjr8mUT7tSM7Vxvuw0CXy
         RAwhBzuZsnZN1bulLV7fcIBeGSl6RZqWgrOBuJB2WMQ5zfHruPJ8w1Z5TcloPEVZpwN8
         pcc+2QDgggXSF1PHpMr/o8OJx4YBFQ3hVMErqzDhuUpCWzi/aS2K62ENBjtBJb4PPVm2
         fw/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791741768; x=1792346568;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ew/EmDhQFxa3pLooXJmh8OkoTE6RmMtwxoNU3Ecf/MI=;
        b=MNFtb2ahXcerD7YEFEhytVFDW8PuY04gr0AlqGOi+jkl6692P/30kcgFBn/wi5H2Nz
         wGq64qAaOdBi+IupWQFOQ+ysr+SHyE7WIQCHA0LSUJ524Mgv63kyBBOSXD24ZtNE6QEe
         1IQcn43zac23JhmHn9UCfhzX6ZzjC8+AH1utP2QwvH85ENsUs6p9MxGcBRz4b+zzuQTU
         P5ulZSfjMbN17wu+7ezWaj7E9FqTvkJ7BOEmXNA0fF7YRA/5x0g+IVGhVCN+mXotHXJw
         dE9RoNvj4wsOP9Pm8PwiXMPB9GStJItziwv6NoMfFVgOyeyWY+5QM7S3JZombHr0zvHs
         rNGg==
X-Gm-Message-State: AFq9FYIGCW704hIWwm+uqy6r0Hr3JSjxy9zcCcDzUJFpJoP3Rh+Wx4qn
	37YvVfKMSR+BCyUzIDktw4QOlCP5n7ueQgbHRgtjkpyEU2ADt/mDRebqr6VX1nex2Tw=
X-Gm-Gg: AYBFou1XYOjPO8n4+WdHBK+8f9H81FvJ7jOaUyZNijj27R9t7SNMtmnbTTAneMtI4MJ
	QhzWk4DFN7vq/jWG/P7LYR5QSyYSczzsBic/U5nA0DzKS0Q3DIOjG7fxbFQBO89Nq4IDFX6QuMh
	pihPhBJTZYPbWuJhDvFZLz51eVQ0ICdsXdkUunLjNiCmG9kp+FFKG2b4AXINRZenOa+qIEeqme9
	chlN0CbiHIf+zkQSd6G0sGeSD4XOFdJXLz+h54+2DvSPb/ntKGY3nTJvTv2qKhtrlLp/lUed+/O
	e8WFAgWL8BIBsobMqIASThuGRsExKVpPvH48GGRf9n1p+YggTZMg9pT5Ngr2ftpQZUDvaD81Hta
	p/2ivbVgebIIQUw0VBlGmSXryDdpCSgEvdFTbxkihIOZjBNXunXTOWCdDUYu5F9fizdZjWjsUBW
	Q/Z03JkxkaDGcah870OtcUVErlMYQuiE2Rhm6nNp+/zLGiYNdXl1s8DmyIx7D8aLzKowGxaKe0u
	fqgKaKSf0vNZRL6uut7cXOp7iCmYy6cxpRDHdTC4k3MRYk=
X-Received: by 2002:a05:600c:810a:b0:4a0:2391:6533 with SMTP id 5b1f17b1804b1-4a18e4a954bmr117375805e9.21.1791741767865;
        Sun, 11 Oct 2026 11:02:47 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bbbdd75sm178873495e9.1.2026.10.11.11.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 11:02:47 -0700 (PDT)
From: Kyrylo Biryuk <illofspeed@gmail.com>
To: dlemoal@kernel.org
Cc: dm-devel@lists.linux.dev,
	hare@suse.de
Subject: [PATCH dm-zoned-tools v3] dmz: check: do not use the write pointer of conventional zones
Date: Sun, 11 Oct 2026 20:02:46 +0200
Message-ID: <20261011180246.758-1-illofspeed@gmail.com>
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
Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>
---

Notes:
    v3: no code changes. From and Signed-off-by now carry my full name
    instead of the GitHub handle "illofspeed" used for v2 (same author).
    
    The addresses in README.md are out of date (wdc.com, dm-devel@redhat.com),
    hence this goes to dlemoal@kernel.org and dm-devel@lists.linux.dev.

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


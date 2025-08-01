Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1088041C72
	for <dm-devel@lists.linux.dev>; Fri,  1 Aug 2025 13:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754054433; cv=none; b=DPIN3kP4Utf7qlDK3OyQtOv1J+Z7pq+hFxd5qQ/ijKzxjqxsfNINKht8/yBG+kHLBHKms2lPnKQfXwZWrAfZFx6aRaGU2N80imgXX3MAWYe0VZbCux2VILCbUuGRh09nxTV44P1Plrh99Ui323Ig7wJ3KRFfgzx3vqx/e84Bx0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754054433; c=relaxed/simple;
	bh=XjuSyWfKixzEQ24rvBLTAh6nrg/7yMjllEowVFEFXFA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=GsSlSioo4NqIud4NAdDRuQTNpin3ArXLkAImDrxgviStm1SjM8U/gxPmsWsP8kpmG5YedDyuN8qDTJTkpc8QyEOPuxt9TWqMKI77jnHysLYOfBMkJmUfTzzepiuVvUWPTPwmOCk9mGvPiGJ7qhVc6+sehMPbrdFaXfQ2P+awNVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=myPOyFn9; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="myPOyFn9"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4589c1f55aeso2856475e9.1
        for <dm-devel@lists.linux.dev>; Fri, 01 Aug 2025 06:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754054430; x=1754659230; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uztxM7H2O0V+TFZUWGHabEFzemzhN1qUbtIy+mSjrDA=;
        b=myPOyFn9ROa4J5tvWXytejCgmNfa7XwxI8QqxLNwT5bOwgJ9c3+FrbJnbWH4sAMWq8
         Q6uW7gMnPiSFHf9Kh8OYfFUcsbG1F3R4BrYFQ3wPAIjBaGzKnMWEkfvLGma2nJl85ZKY
         xrwEEn1XOGyFuHF9z/M/I+JlMX00ALurICGG8A/sZiYbJ2hyww76HMxYFLt7QqYUuV6v
         1edMwzmFBoVj0B/9fItf0Ph9VlGoOmfMwnZOtjIC8ZKFeOAVONeYevHqLL19xRJa8/ID
         YvQPu99e4BYNLa7H0UDT/0s2rxWglTLVbbaHi5AKUv+lGZBN8ZkoX5xTYLw0BkKWTWrb
         V7qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754054430; x=1754659230;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uztxM7H2O0V+TFZUWGHabEFzemzhN1qUbtIy+mSjrDA=;
        b=pp9NcBfR0MW2hgx7uGf0zM0HrcsWhUXFOcaY1S0w1+aTTbJvq12PXF/GjXOAIi6ddb
         ZFCDm4AfEjC0DDnD20mHSw5+nLLzyhTr8JtpMh8epDughTrfwQlvEC1ymQopNxWpLKVR
         aKIxfCVy7t2F4gmKKmaBAKrTFW695EN8t/a12c/jL6UAWJ0KkE1QdylJWyOhlZlzsHGg
         v/4MgSLU3HmG4+3jGPZsKbYatrz5+F6zCnXfAubRKg3rlH3G02CwA57F8iOD/ww6YlLX
         xdEvNiefePYeFb+N5UpUEQce6VZVyCEE+P7yDSFSqxZZmHOnVM34/uaFJl3OgozMsO20
         ZYAg==
X-Gm-Message-State: AOJu0YybsOUz1h1F+5h66XChhsM+JGomi2QAfuAY4yCxvprR0GAo598g
	vPzwHC9SM1z1bqQFuJJoV233i9RcV6QjBO0wFTQbo3z/KH6GkULfcAqEw//UyZJQinE=
X-Gm-Gg: ASbGncsqOMBzYEGbTtRuciy+OQLMzy/SB6KeJ9ax5DiTnG2fuZJ5n7tUusMDf2zO+Ln
	+JqdHw6D2eHezJLhTS1R6L4CHcjG38vP8xiqcxgdVaMBpm4/ZFosNhyj5v8X25ogLIjn27l+9Ug
	j3W5W9FouMYT8DCRQIExQG4N8mn6CJRDZc7JdeEnVmv2zgiPK+u9Xrn66ISlWI5GkrlUHjbapvn
	eokbKK/XKU/1G8zjwUsKahmRJdBrwfKwEnw82gY6IcxRzRAxXKSCK4xjQvKXWnlgq/2wAtBMWBG
	j9Qb00Gvb3Y7CidwDlU208aUAEY45fNG1fmxeHpLnvxKKPc165JSdjERnYynMbV4p7UnfUE4sIG
	qERRhm1GJUIA0Tg/GIk+JqyU6tBacnI5ZVkaIBWsQm8URcV0Zyz1tN9Q4GdkTijDSrnGl/KG+LZ
	23KeWVfkPH
X-Google-Smtp-Source: AGHT+IHmHYArwt4OX8f+1dStz3v/Z2bvtN4EGoCRvRxKigzWESbMcBWPBLztCRwoDvRuYJqFAL9iPQ==
X-Received: by 2002:a05:600c:3e15:b0:442:fff5:5185 with SMTP id 5b1f17b1804b1-4589e8745e9mr28842175e9.6.1754054429861;
        Fri, 01 Aug 2025 06:20:29 -0700 (PDT)
Received: from pop-os.localdomain (208.77.11.37.dynamic.jazztel.es. [37.11.77.208])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c4530a8sm5906250f8f.38.2025.08.01.06.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 06:20:28 -0700 (PDT)
From: =?UTF-8?q?Miguel=20Garc=C3=ADa?= <miguelgarciaroman8@gmail.com>
To: dm-devel@lists.linux.dev
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Miguel=20Garc=C3=ADa?= <miguelgarciaroman8@gmail.com>
Subject: [PATCH] dm: sysfs: use sysfs_emit() in dm_attr_*_show()
Date: Fri,  1 Aug 2025 15:19:07 +0200
Message-Id: <20250801131907.371700-1-miguelgarciaroman8@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch replaces the existing sprintf/strcat/strlen patterns in the
four dm-sysfs show() callbacks with the sysfs_emit() API, as recommended by
Documentation/filesystems/sysfs.rst. The change has no functional impact.
The output format remains exactly the same—but it:

  - Eliminates manual buffer-length calculations and strcat calls  
  - Protects against potential PAGE_SIZE overruns  
  - Makes intent clearer and aligns with current kernel best practices  

Signed-off-by: Miguel García <miguelgarciaroman8@gmail.com>
---

Tested-on:
  • Built-in dm_mod and loop drivers in a custom vmlinuz via virtme-ng
  • BusyBox-based initramfs in QEMU (x86_64, 2 GB RAM, 2 vCPU)
  
Test procedure:
  1. In the guest shell:
       # mount -t tmpfs tmpfs /tmp
       # dd if=/dev/zero of=/tmp/backing.img bs=1M count=8
       # losetup /dev/loop0 /tmp/backing.img
       # sectors=$((8*1024*1024/512))
       # echo "0 $sectors linear /dev/loop0 0" | dmsetup create testdm --uuid test-uuid-123
  2. Verify each sysfs attribute still matches the original output:
       # cat /sys/block/dm-*/dm/name        →  testdm
       # cat /sys/block/dm-*/dm/uuid        →  test-uuid-123
       # cat /sys/block/dm-*/dm/suspended   →  0
       # cat /sys/block/dm-*/dm/use_blk_mq  →  1
  3. Remove and clean up:
       # dmsetup remove testdm
       # losetup -d /dev/loop0

Both before and after the patch the attribute contents and formatting are
identical, confirming no functional change.


 drivers/md/dm-sysfs.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
index bfaef27ca79f..fed9751970a0 100644
--- a/drivers/md/dm-sysfs.c
+++ b/drivers/md/dm-sysfs.c
@@ -68,35 +68,33 @@ static ssize_t dm_attr_store(struct kobject *kobj, struct attribute *attr,
 
 static ssize_t dm_attr_name_show(struct mapped_device *md, char *buf)
 {
-	if (dm_copy_name_and_uuid(md, buf, NULL))
+	char name[DM_NAME_LEN];
+
+	if (dm_copy_name_and_uuid(md, name, NULL))
 		return -EIO;
 
-	strcat(buf, "\n");
-	return strlen(buf);
+	return sysfs_emit(buf, "%s\n", name);
 }
 
 static ssize_t dm_attr_uuid_show(struct mapped_device *md, char *buf)
 {
-	if (dm_copy_name_and_uuid(md, NULL, buf))
+	char uuid[DM_UUID_LEN];
+
+	if (dm_copy_name_and_uuid(md, NULL, uuid))
 		return -EIO;
 
-	strcat(buf, "\n");
-	return strlen(buf);
+	return sysfs_emit(buf, "%s\n", uuid);
 }
 
 static ssize_t dm_attr_suspended_show(struct mapped_device *md, char *buf)
 {
-	sprintf(buf, "%d\n", dm_suspended_md(md));
-
-	return strlen(buf);
+	return sysfs_emit(buf, "%d\n", dm_suspended_md(md));
 }
 
 static ssize_t dm_attr_use_blk_mq_show(struct mapped_device *md, char *buf)
 {
 	/* Purely for userspace compatibility */
-	sprintf(buf, "%d\n", true);
-
-	return strlen(buf);
+	return sysfs_emit(buf, "%d\n", true);
 }
 
 static DM_ATTR_RO(name);
-- 
2.34.1


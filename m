Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0354E3C3C15
	for <dm-devel@lists.linux.dev>; Sat,  6 Jun 2026 20:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780777643; cv=none; b=DT8yI+P8EGyTgsNzgwi9eSIfSq0Oy7pxgfXctaD3qqSlK55PNntvVZH/FiU70RrJ1pg9jwq6+9vFns4OrLAirE6egpYoDqLnqjIDE1MfnWeOJfBPjrZjq8jZUiD++JYJeMI9KbvgUzcw2IquUpkG9PzMC6QpDBezvJl07JYhmUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780777643; c=relaxed/simple;
	bh=q3m42KwlgaB47GxqTsGaX9w9chaRbKm/7VJsjZmkbKc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZukLbdHCJvojHNvGHRJow83aAvxjawunoE623sn7esSiisXbd3rp8Jr8Ehw6lsiR0KGSqpc4RMDgxmnHgORXevQo3hL8amKNRM95lWrp2ehO0CzgAPuzB27cdEMUxkG1ytUid2+y9/kAPgrach/5KmC+8VssDxFJEGtRtyYI2lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=ejA22uLK; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="ejA22uLK"
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wVxbw-007NS1-6B; Sat, 06 Jun 2026 22:27:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:Cc:To:From; bh=eVS6/dpCoKYbQ7WYroUYuGcw4NkGvjE6hnkA0s1BCGk=; b=ejA22u
	LKCCJD3gLgQvkF6/mjvY+cyGmcodchCrdYIztOaePMB1mscmFEb7YG0QxAoFgx/DF0whelcIU+j1A
	LuCgAFh+ncSIgNm3T8LjCP2vilfYWlOGiD7DbAnS0hbX2JhHdDz4lc1H9elaTLzM9pDLmMC51p28r
	GlXlQUnW/ZtMQLflC7oX4Kjy/XA2h6ziwknmZVV9rIKwWIdY0Am4/hTrSxwTzB5o2qsh+s7gVXC2u
	sRh0MbFn7kvz9P2osV+VbAlvmAZCbp891FPchUaxpdrCDKsQz1id8h05yROyv2DQRcG7lIH/ieFrB
	39UKDQP+XsfiYhFBaOcEINV0+I+Q==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wVxbv-0000uE-QG; Sat, 06 Jun 2026 22:27:15 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wVxbd-006V18-OS;
	Sat, 06 Jun 2026 22:26:57 +0200
From: david.laight.linux@gmail.com
To: Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
	Arnd Bergmann <arnd@kernel.org>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Alasdair Kergon <agk@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH next] drivers/md/dm-zoned-metadata: User strscpy() to copy device name
Date: Sat,  6 Jun 2026 21:26:06 +0100
Message-Id: <20260606202633.5018-12-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
This is one of a group of patches that remove potentially unbounded
strcpy() calls.

They are mostly replaced by strscpy() or, when strlen() has just been
called, with memcpy() (usually including the '\0').

Calls with copy string literals into arrays are left unchanged.
They are safe and easily detected as such.

The changes were made by getting the compiler to detect the calls and
then fixing the code by hand.

Note that all the changes are only compile tested.

Some Makefiles were changed to allow files to contain strcpy().
As well as 'difficult to fix' files, this included 'show' functions
as they really need to use sysfs_emit() or seq_printf().

All the patches are being sent individually to avoid very long cc lists.
Apologies for the terse commit messages and likely unexpected tags.
(There are about 100 patches in total.)

 drivers/md/dm-zoned-metadata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index ec605acddd88..f4f81c79a080 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -2871,7 +2871,7 @@ int dmz_ctr_metadata(struct dmz_dev *dev, int num_dev,
 	if (!zmd)
 		return -ENOMEM;
 
-	strcpy(zmd->devname, devname);
+	strscpy(zmd->devname, devname);
 	zmd->dev = dev;
 	zmd->nr_devs = num_dev;
 	zmd->mblk_rbtree = RB_ROOT;
-- 
2.39.5


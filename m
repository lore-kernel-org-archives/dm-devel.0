Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275491862E
	for <dm-devel@lists.linux.dev>; Thu, 11 Apr 2024 20:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712866546; cv=none; b=L7+r3YvaONMMFgL0oRXemRJc/cllS/sMlT/Kt4yzpt3HQ1xQXSidO9DfWKoL6OwrNEEz1vdsTgIk0j1T8SwbOE4GX2BagE0kV36kpBA7Ng9b8aoqxZ2B2wNmhNzVUBFe0gL/62p4WrYj/tp8PVz8EQhNddT2vRzndARnPsEb3tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712866546; c=relaxed/simple;
	bh=NCmePHzNKfUHxeWZ/7p62pycueR+0yKWjQDJGF7HN2U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IqstU+t5MvTNHxhzzQBGWvzZSORWFatFJR1bWixHTERSQmq9RCI81CJct5WhlIqngMGCUfF7jquTnLnn3ehov0KLGK99lxlOb9ytBpKUUb2eP2hdXahBHGDAmeACA6amPkhFgqDNJqOBaYl9K2bjk3eoOjnB4NsCd/3Qjfy0pMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3c60adf3474so109563b6e.1
        for <dm-devel@lists.linux.dev>; Thu, 11 Apr 2024 13:15:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712866544; x=1713471344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sz075QmnPQTwVkv9vCOIw5mtXzBKUg3sK8QUXHUdUYU=;
        b=ip1f8hDIPXU73pFsOzoIoIv7wJpYlTaqS9w5c/uYqk3JjAjHKDJxWLiFkAmM5NUI0B
         Fcu6TyKrKE+GdUv5gLvsthG+Mm9fQ8Xb93cUOuMdCz646p2I+FKP0o3Q2nW3/CuasSwX
         TB0RdKkmTd1LryoypLI4wYIz66CxdEJykYs0UM3xRgIgC1BHciUNXLpV4pV9BBLku7WL
         w6JxzvdsHrmwnuZC0DdsBNf7V0IGjgZCcYkm0n+gDUxlpoEmtbDeKckh/Wnaxn1nJNk5
         RI6x0TFxqG60kuIBF+HPwCG1egMjw4QwynwMyAjR8vfWDy0D9MMrIDkQaj5LmZ1th0Wh
         iMkg==
X-Forwarded-Encrypted: i=1; AJvYcCXef+6yrE3rV49k3NFZSgRlgDUK0yYQoHimsPJuRgr6VtlcProL46YcO3WLeIZgCf4fimWqM2fctfFbFpuyGEfNTDI8EHjFBzI=
X-Gm-Message-State: AOJu0Yzbg5KQcj6sS28Tq7QxYIAPKka9HmC2Sm/BuOarFC9imHcvUNS6
	ksd7T0Xxc3S5YXDn/2LH/67FTDjTY3+6bMwQpf45XfWhzUCTWHpvrydoamN4Rg==
X-Google-Smtp-Source: AGHT+IHL6H9kovsai/jdp/4wUYtvJaa4EBLsSbF2gTIz+Lyj7LcB8K99xqE39taXcIN/P3p/doo3AQ==
X-Received: by 2002:a54:4083:0:b0:3c5:fa38:c651 with SMTP id i3-20020a544083000000b003c5fa38c651mr671839oii.18.1712866544300;
        Thu, 11 Apr 2024 13:15:44 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id jr13-20020a05622a800d00b00434c25cb61bsm1312751qtb.73.2024.04.11.13.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 13:15:42 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: hch@lst.de
Cc: axboe@kernel.dk,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	mpatocka@redhat.com,
	Abelardo Ricart III <aricart@memnix.com>,
	Brandon Smith <freedom@reardencode.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ming Lei <ming.lei@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH for-6.10 1/2] dm-crypt: stop constraining max_segment_size to PAGE_SIZE
Date: Thu, 11 Apr 2024 16:15:28 -0400
Message-Id: <20240411201529.44846-2-snitzer@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <ZfDeMn6V8WzRUws3@infradead.org>
References: <ZfDeMn6V8WzRUws3@infradead.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This change effectively reverts commit 586b286b110e ("dm crypt:
constrain crypt device's max_segment_size to PAGE_SIZE") and relies on
block core's late bio-splitting to ensure that dm-crypt's encryption
bios are split accordingly if they exceed the underlying device's
limits (e.g. max_segment_size).

Commit 586b286b110e was applied as a 4.3 fix for the benefit of
stable@ kernels 4.0+ just after block core's late bio-splitting was
introduced in 4.3 with commit 54efd50bfd873 ("block: make
generic_make_request handle arbitrarily sized bios"). Given block
core's late bio-splitting it is past time that dm-crypt make use of
it.

Also, given the recent need to revert meaningful progress that was
attempted during the 6.9 merge window (see commit bff4b74625fe Revert
"dm: use queue_limits_set") this change allows DM core to safely make
use of queue_limits_set() without risk of breaking dm-crypt on NVMe.
Though it should be noted this commit isn't a prereq for reinstating
DM core's use of queue_limits_set() because blk_validate_limits() was
made less strict with commit b561ea56a264 ("block: allow device to
have both virt_boundary_mask and max segment size").

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-crypt.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 5bfa35760167..f43a2c0b3d77 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1656,8 +1656,8 @@ static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone);
 
 /*
  * Generate a new unfragmented bio with the given size
- * This should never violate the device limitations (but only because
- * max_segment_size is being constrained to PAGE_SIZE).
+ * This should never violate the device limitations (but if it did then block
+ * core should split the bio as needed).
  *
  * This function may be called concurrently. If we allocate from the mempool
  * concurrently, there is a possibility of deadlock. For example, if we have
@@ -3717,14 +3717,6 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
 {
 	struct crypt_config *cc = ti->private;
 
-	/*
-	 * Unfortunate constraint that is required to avoid the potential
-	 * for exceeding underlying device's max_segments limits -- due to
-	 * crypt_alloc_buffer() possibly allocating pages for the encryption
-	 * bio that are not as physically contiguous as the original bio.
-	 */
-	limits->max_segment_size = PAGE_SIZE;
-
 	limits->logical_block_size =
 		max_t(unsigned int, limits->logical_block_size, cc->sector_size);
 	limits->physical_block_size =
-- 
2.40.0


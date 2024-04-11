Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE6617C6D
	for <dm-devel@lists.linux.dev>; Thu, 11 Apr 2024 20:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712866548; cv=none; b=itW8hbP0MgBoImetdRjPmcSyituCQ3T8cMuK9HVDE+FpN4YUPDc87zpbmkDmJLJN3W7W2C9x4BZgaFnxpeHpwIqbw1MnHiQWrDuEVD3z8E7ezUUH8i7aH7QUwe0FWeYrzYbGFe4KAklyP+vvGkvURpYKEPIn0Xwa5+GY8mvkRnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712866548; c=relaxed/simple;
	bh=DF0z31XI1+xb0ikzM2l5oMRUQ/TAK8DEHHzwXdyf6LY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CdKEFmsS3V5v8PkcZ2Wly8JTdzrAhPQlDPDbY7PxDL5y2JjEJByP6K/+KkBujl5JeWYI79CoDTc+uv8Q9Dhgc42pnCBKfW1ngytd/1Mpvpw/WwiYtL58c+uzXv2fmgtc8wyirodNP1BAkIcSNODhO9stEFWnildOHf6yI+W4V0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-78ec78c4fceso42272185a.0
        for <dm-devel@lists.linux.dev>; Thu, 11 Apr 2024 13:15:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712866546; x=1713471346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LpITuEe31p+a/qxo+70eR67S4eJD4GXO5prTh59KfsI=;
        b=PnM3Mtb4D+2p2YPfBwX2W0qGpjWQuHLtuoLSK978EsEc7Iyj2f3FSRvEMg8hfyeLfL
         BtuOXkVNvmCPk4iZr1lFXxmQDQhdxgaFHlXnfQk3+9mmBoa73V858sCi/JrgHIPfpWCc
         JQpfgnP3E3DpO7xL7Mo39h+dzsYNXUQ8L64XabpwlJDXl++eyUfp9bZzyNqJnibq0vDC
         ZvbhXLv1vs1XKORgVV86/HdhtrCIHbi1uhq4f4R7tx8TErpVGqiOsSuvbN6SLadykGTi
         5u5GY7aszTsX8WGurH6YD2BjMj/6uBhoNnfkJiBmgQtafFzgscClQLuHCHVEg2kDM9Eh
         EX+Q==
X-Forwarded-Encrypted: i=1; AJvYcCU2ApY8MzSKMb5Ax5zz5QrtUuOkoVhQzZcnD9b2pQ4NiJpV5t7S4M+Ol6E7wPcut4VFPC44dPJjedp2AeauUNH/xv6g+D141MY=
X-Gm-Message-State: AOJu0YyO82wCvetuFfOrnVajjLhnGGb4WchHAFb8KVmzT6Oxy7SoJQDH
	kBWT4qAPllSfRYH8tMv55K54147ryJQFqA4ehJ2BXHYYWsxthoBmHb42ynRN7g==
X-Google-Smtp-Source: AGHT+IFD6dL8mum13/FhxCLc737M/JKz4982DitzcuBRP2vPJobFwxJmSUBGIFfWCnAAGImVzkjbdg==
X-Received: by 2002:a05:620a:1a22:b0:78e:bd2f:1088 with SMTP id bk34-20020a05620a1a2200b0078ebd2f1088mr1327700qkb.4.1712866545769;
        Thu, 11 Apr 2024 13:15:45 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id d4-20020a37c404000000b0078d761e7b50sm1440968qki.106.2024.04.11.13.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 13:15:45 -0700 (PDT)
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
Subject: [PATCH for-6.10 2/2] dm: use queue_limits_set
Date: Thu, 11 Apr 2024 16:15:29 -0400
Message-Id: <20240411201529.44846-3-snitzer@kernel.org>
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

From: Christoph Hellwig <hch@lst.de>

Use queue_limits_set which validates the limits and takes care of
updating the readahead settings instead of directly assigning them to
the queue.  For that make sure all limits are actually updated before
the assignment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-table.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 41f1d731ae5a..88114719fe18 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1963,26 +1963,27 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	bool wc = false, fua = false;
 	int r;
 
-	/*
-	 * Copy table's limits to the DM device's request_queue
-	 */
-	q->limits = *limits;
-
 	if (dm_table_supports_nowait(t))
 		blk_queue_flag_set(QUEUE_FLAG_NOWAIT, q);
 	else
 		blk_queue_flag_clear(QUEUE_FLAG_NOWAIT, q);
 
 	if (!dm_table_supports_discards(t)) {
-		q->limits.max_discard_sectors = 0;
-		q->limits.max_hw_discard_sectors = 0;
-		q->limits.discard_granularity = 0;
-		q->limits.discard_alignment = 0;
-		q->limits.discard_misaligned = 0;
+		limits->max_hw_discard_sectors = 0;
+		limits->discard_granularity = 0;
+		limits->discard_alignment = 0;
+		limits->discard_misaligned = 0;
 	}
 
+	if (!dm_table_supports_write_zeroes(t))
+		limits->max_write_zeroes_sectors = 0;
+
 	if (!dm_table_supports_secure_erase(t))
-		q->limits.max_secure_erase_sectors = 0;
+		limits->max_secure_erase_sectors = 0;
+
+	r = queue_limits_set(q, limits);
+	if (r)
+		return r;
 
 	if (dm_table_supports_flush(t, (1UL << QUEUE_FLAG_WC))) {
 		wc = true;
@@ -2007,9 +2008,6 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	else
 		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
 
-	if (!dm_table_supports_write_zeroes(t))
-		q->limits.max_write_zeroes_sectors = 0;
-
 	dm_table_verify_integrity(t);
 
 	/*
@@ -2047,7 +2045,6 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	}
 
 	dm_update_crypto_profile(q, t);
-	disk_update_readahead(t->md->disk);
 
 	/*
 	 * Check for request-based device is left to
-- 
2.40.0


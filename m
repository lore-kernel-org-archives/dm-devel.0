Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9ED324B0C
	for <dm-devel@lists.linux.dev>; Wed,  5 Nov 2025 14:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762351614; cv=none; b=ka6NatzmI+yz2TOHlD2W9n89jaa8nL1qVbto743F3YkA/XJrSQ9rTASFwKxOo0qA7oHH4IM05uSheXsE+iGr4deEUgOFVvpqP0UsXjKX+AxItYKBnNftTeCJIa/wILP5y2hWIj4SJ8FDt2AYA2/aGqCB1lqLN+EjhEkPpRJ1Qgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762351614; c=relaxed/simple;
	bh=ozn9PYHQwNtUsQDR0l/eASn5HgtewKzU570OFp64LKI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=pRKnlZc8k1fVtHU8SjOhCJyrG25Cn2trtcPiH+IfiCoE9dzKlKsowIS2X7DCPQX369ELZwtOlwZ+2yAqUBV7xjAKdugPgC5RLMOmhxaHNFQQudFBi1xP1QJfUmRTWq+xzfzBjSgu4LSdjexQRlgEPblGFdm5GFF+EyVp5Q9lW6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--shubhankarm.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xkKyB30P; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--shubhankarm.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xkKyB30P"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7a675fbd6c7so5426238b3a.2
        for <dm-devel@lists.linux.dev>; Wed, 05 Nov 2025 06:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762351612; x=1762956412; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KC4zJ3U3fiL9QB80+aHnOXr/oYYa3/i7uuu7o8EzkMA=;
        b=xkKyB30Pd/s/CvyCvs7VZeoWKexKNVtoYUYN2VLmDBsHgPAgegD/lnXia6kve51GxQ
         7lXO1JPjdh8673nqsuL/eLCvBJAKrCNJflsIWrwo4k/nC/oY9rhTjj87A1h+FmsR/Bgd
         7d2xK6TtekanhuQ5EHPbCLceVpVp7EOLoG9eBPof0R7ltYSi9V/gRa5yHgORMYqN9J91
         FgAbCPzAShnp487X4d2zaxNrvIhZvOwDU0HREC2Jscdw4Ff+B419hFSWGJjZ4qLSY6Ft
         c3kYUmHvNqSINfQP6hlQCbS4T6gDE99kSoRFTBkOb0d4ibB2A3R3fNydQlsRgFKpKsd3
         26sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762351612; x=1762956412;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KC4zJ3U3fiL9QB80+aHnOXr/oYYa3/i7uuu7o8EzkMA=;
        b=U0oVg7AJmIqpZD/fL2dwS+ngR65I+EXsAvEk5LQLj1GhNKNuJdtRyJQVbBglnTtn5K
         bDAErqDA8GM3L5tWlrFPpG/C5UkAp9J964iT1JV1KOXjeQUPYryCYjaQ5kQ8bHdbQH78
         leuGKjTzFFFD2F70woQ8lrJ6Al7zxNQEr7KFQJGUtX/GLwkIz2h54M8w7V9xmavl5jn6
         wi+KOlo93QqTyBbJiVjsEbJkpqN43R0Y6x6g00T9u855P+69Ut98nV0b5Xcfc2W8erad
         8iT7G0fZAGgPJu2WS1CB5gD4beotbCPF1vdf/4pkS3s7cAE1A9NP5FDCLV80bmcoWRdy
         /Ftg==
X-Gm-Message-State: AOJu0YxbL9lr+Vlx9lIvEMSeseD0wf/S//PMWz8JH2LZUbeDcZCVQz+9
	Uyw2N443CQZ5PZGafVk99sUHi6VqcTFLPugsruQtD/UCpv2cXQRVtT8VR6ErbwTVV48gXy5VaoW
	6dEQzgTsdh4PLyru5elvAbgeq3w==
X-Google-Smtp-Source: AGHT+IElIGJaekv/GMBuxpe+HEsDxIU6AAtmOZaPK4vNutfdM59d6biGutlEYxH9Dv9jkKKkkacGxGXq0HN3kTV9Wg==
X-Received: from pfbhr5-n2.prod.google.com ([2002:a05:6a00:6b85:20b0:78a:fa44:ad73])
 (user=shubhankarm job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:8d04:b0:7ad:1082:fdef with SMTP id d2e1a72fcca58-7ae1f78a48amr2593461b3a.26.1762351611744;
 Wed, 05 Nov 2025 06:06:51 -0800 (PST)
Date: Wed,  5 Nov 2025 14:06:44 +0000
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.1006.ga50a493c49-goog
Message-ID: <20251105140645.2150719-1-shubhankarm@google.com>
Subject: [PATCH] dm verity fec: Expose corrected block count via status
From: Shubhankar Mishra <shubhankarm@google.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Jonathan Corbet <corbet@lwn.net>
Cc: dm-devel@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@google.com>, 
	Sami Tolvanen <samitolvanen@google.com>, kernel-team@android.com, 
	Shubhankar Mishra <shubhankarm@google.com>
Content-Type: text/plain; charset="UTF-8"

Enhance visibility into dm-verity Forward Error Correction (FEC)
activity. While FEC can correct on-disk corruptions, the number of
successful correction events is not readily exposed through a standard
interface.

This change integrates FEC statistics into the verity target's
.status handler for STATUSTYPE_INFO. The info output now
includes count of corrected block by FEC.

The counter is a per-device instance atomic64_t, maintained within
the struct dm_verity_fec, tracking blocks successfully repaired by FEC
on this specific device instance since it was created.

This approach aligns with the standard Device Mapper mechanism for
targets to report runtime information, as used by other targets like
dm-integrity.

This patch also updates Documentation/admin-guide/device-mapper/verity.rst
to reflect the new status information.

Tested:
  Induced single-bit errors on a block device protected by dm-verity
  with FEC on android phone. Confirmed 'dmctl status <device>' on Android
  reports an incrementing 'fec_corrected_blocks' count after the
  corrupted blocks were accessed.

Signed-off-by: Shubhankar Mishra <shubhankarm@google.com>
---
 Documentation/admin-guide/device-mapper/verity.rst | 6 ++++--
 drivers/md/dm-verity-fec.c                         | 4 +++-
 drivers/md/dm-verity-fec.h                         | 1 +
 drivers/md/dm-verity-target.c                      | 4 ++++
 4 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/verity.rst b/Documentation/admin-guide/device-mapper/verity.rst
index 8c3f1f967a3c..3ecab1cff9c6 100644
--- a/Documentation/admin-guide/device-mapper/verity.rst
+++ b/Documentation/admin-guide/device-mapper/verity.rst
@@ -236,8 +236,10 @@ is available at the cryptsetup project's wiki page
 
 Status
 ======
-V (for Valid) is returned if every check performed so far was valid.
-If any check failed, C (for Corruption) is returned.
+1. V (for Valid) is returned if every check performed so far was valid.
+   If any check failed, C (for Corruption) is returned.
+2. Number of corrected blocks by Forward Error Correction.
+   '-' if Forward Error Correction is not enabled.
 
 Example
 =======
diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 301a9c01bf86..d792eaed0792 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -177,9 +177,11 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 	if (r < 0 && neras)
 		DMERR_LIMIT("%s: FEC %llu: failed to correct: %d",
 			    v->data_dev->name, (unsigned long long)rsb, r);
-	else if (r > 0)
+	else if (r > 0) {
 		DMWARN_LIMIT("%s: FEC %llu: corrected %d errors",
 			     v->data_dev->name, (unsigned long long)rsb, r);
+		atomic64_inc(&v->fec->corrected);
+	}
 
 	return r;
 }
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index a6689cdc489d..dd55037377b6 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -48,6 +48,7 @@ struct dm_verity_fec {
 	mempool_t extra_pool;	/* mempool for extra buffers */
 	mempool_t output_pool;	/* mempool for output */
 	struct kmem_cache *cache;	/* cache for buffers */
+	atomic64_t corrected; /* corrected errors */
 };
 
 /* per-bio data */
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index bf0aee73b074..52a0e052a5e8 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -848,6 +848,10 @@ static void verity_status(struct dm_target *ti, status_type_t type,
 	switch (type) {
 	case STATUSTYPE_INFO:
 		DMEMIT("%c", v->hash_failed ? 'C' : 'V');
+		if (verity_fec_is_enabled(v))
+			DMEMIT(" %lld", atomic64_read(&v->fec->corrected));
+		else
+			DMEMIT(" -");
 		break;
 	case STATUSTYPE_TABLE:
 		DMEMIT("%u %s %s %u %u %llu %llu %s ",
-- 
2.51.2.1006.ga50a493c49-goog


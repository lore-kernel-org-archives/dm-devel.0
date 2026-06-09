Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323D4244665
	for <dm-devel@lists.linux.dev>; Tue,  9 Jun 2026 00:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780965040; cv=none; b=uw/XNmvoE5oHsUZXtX0bRYuIBQghqHIZ+Aby5uIQNGo6id2WhOOyxdnnyZYZu126O/8j2fGkKIi3QXbftNMuvSHc7wPRRtu5xNwQKGLy5V2oR4EuILxZTPqogOXATyltLuLoI5u1DBIReWr4wpr0MRESp8BbGsQhSGq0UoFtnQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780965040; c=relaxed/simple;
	bh=a7XK+rVjCF/L5mCXSZHln5yZazYlIWvsMTDYmMjL9UI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JXlK+M8JiD9UC8Jl7QnAmp1BE93nHnH2tY1N4eH0pP5BITXl3wd/m9JWSxBqazCfaRyWBqPz9ce3RKHVEr668SRM01LAzRtG1dwK9XPptec6Yxo0xJcOUALPm6wtjRmTJYaCQJAqri4IMgFvTBmPs9suTlNrkNq3/xUbqSc/Jbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=FtTbAJRj; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="FtTbAJRj"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8cceaacd07bso54525716d6.3
        for <dm-devel@lists.linux.dev>; Mon, 08 Jun 2026 17:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780965038; x=1781569838; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TNfsIvgwiWVAuEVycyVt1h+afi4itu9wMZ0WqXvaU/Y=;
        b=FtTbAJRjywKG8QJShGc82slizxmDmWWue3lJThp8TxBQSzjH57TnOPdTRmFm1ReuLR
         st9lIcYB83Lp4yBYfRFuM4cj1sbimWPYJ63wzvCnZi6bOQFfqerURxBc895lM9BEJ53d
         ZwnzVz1If9V2RX4An6m02q5W9Gdbh+pfXQMDEl08z+dO8iTvwIKLKzPitQJImiHQ2Hjg
         QRD+65DEQQ1aFlLyJ/ulD/clNT6Zg+lgbQx7LtgCvlrORrsW0JDxtl5tSklWU4UJ1WDA
         ilOTPPcIgdivfodaOHaWgYlGomORLIl9OiQs4XL3/5afERgwQlPsweG8MMFIE3cIieaK
         8uDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780965038; x=1781569838;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TNfsIvgwiWVAuEVycyVt1h+afi4itu9wMZ0WqXvaU/Y=;
        b=SlfJGAOCu/23RNiw64SvK7zt/1PoE3PJomBm/aPcV1iJKR6DCpucd5HGOGPPt9R5b7
         NItjidbNnH5vXU+soTsM01fs72bu/2uNMApvbS+pplwfB9GWbjHOHVSkyyg+2CcbTMEJ
         W68yif1gKcZVLNkGK9gSws+GcYJcP4iK8gO14x1M+jwqDNs8fzxdkSXbOKBar2Zn69qW
         3tLbrLLVDmf8+g2v2kIQeEcB24Y21JdV+5XkYSe0zKQqon25jzGpMM0gyKZ8uMao5sYE
         KqrSJ1jnCwzCNJqQaF1azpDIZZbabdtxQkvvACQQPAwzyu7UWzE7ViBvGIORug4V/VRT
         1UKw==
X-Forwarded-Encrypted: i=1; AFNElJ8lJrzwzZJjC3ETj7Xi4/01jl+5rxnwI6kWur0l5FuOcXKVq5LNdZ1mGQMTySzVs9+eVPTKRJbUOA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxdJSPnZbjNCeNo6uyt6+EqsKRTMb695EQsaGrMfORBC9RAH3NJ
	4F6sSRbpEr7yEFNy2vVWTZEprMvg8CqXkMKuvxvoHhADSrQts7yflgkNOuLaJnRwovI=
X-Gm-Gg: Acq92OFt9RaqUEFydmHR+BpcQEro5D0vkrb5Lb+cfLZBi/zf0GfADC9JpsUWVoAHTuY
	bNKAl4gdrVZhfne4bKoCj7U8DKcg75boVBnTDTz9zW4uLLjPOqatn3lQ7aWRmTJ5Mwd8dpwX68m
	ih7F9JXhjzW9Ip4D8iOmf0Ox7P3zGWSHX1gtVYeFACEPLydeNxGt9RbYTbJbWKMdh+GBWK1OE/6
	MyzNvMX5lpb7YFOpgbkV74Knv6IVd0M/kSPmDL8QuS9W9mX32dfK0N2qugHUs2555Rg2oMXhuca
	DCQ1fLFliOZP6KLizkrfMPY6DDNpWgGcx+QKrwcVVU43ARIUl0aQCo2sHa/Tr4a7AqllSqgjo0P
	mkP+S5yJ7suo4iSFV4755fXTFVnuaMTIqL4eCQO8TP/Hm0PDcCzj59aK0cfVxB9eyIlD7qlgHYS
	faKflDYpk/E6bkPxbqFpA+NLCaFlRILYEgnBZaTg==
X-Received: by 2002:a05:6214:1881:b0:8ce:bfe1:cc80 with SMTP id 6a1803df08f44-8cee5fbdeb0mr215976166d6.3.1780965037887;
        Mon, 08 Jun 2026 17:30:37 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-8cecd054d2asm183566406d6.23.2026.06.08.17.30.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 17:30:36 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: Alasdair Kergon <agk@redhat.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] dm log writes: do not log failed underlying writes
Date: Tue,  9 Jun 2026 00:29:57 +0000
Message-ID: <20260609002956.1236613.db812ce62559.dm-log-writes-failed-io-logged@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm-log-writes records write completions even when the underlying device
reports an I/O error.  The log can then contain data for writes that did
not actually reach the backing device.

That makes replay and diagnostics disagree with the state of the lower
device after an error.

Only record completed writes after the lower layer reports success.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
 drivers/md/dm-log-writes.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index c72e07c3f5a0..e5c4b9df5d9d 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -775,6 +775,13 @@ static int normal_end_io(struct dm_target *ti, struct bio *bio,
 		unsigned long flags;
 
 		spin_lock_irqsave(&lc->blocks_lock, flags);
+		if (*error) {
+			if (block->flags & LOG_FLUSH_FLAG)
+				list_splice_init(&block->list, &lc->unflushed_blocks);
+			spin_unlock_irqrestore(&lc->blocks_lock, flags);
+			free_pending_block(lc, block);
+			return DM_ENDIO_DONE;
+		}
 		if (block->flags & LOG_FLUSH_FLAG) {
 			list_splice_tail_init(&block->list, &lc->logging_blocks);
 			list_add_tail(&block->list, &lc->logging_blocks);
-- 
2.43.0


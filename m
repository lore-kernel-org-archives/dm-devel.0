Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBD237E310
	for <dm-devel@lists.linux.dev>; Wed,  3 Jun 2026 17:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780509117; cv=none; b=lruzlICbFMH78tW6bMi7cItp2g+RfvPV9EMhwdY7E2bBZa8EwVyPYa9bb6C1U3T1gw38lqznClPeWawHol8Q/5SWESahO7n1OV7W4Yi3liFE5NOuaew7G9pi2bpysaoyHwoyCeP/xK32B4CAjIrriLijhUyWOBBW9QZoQfLbXQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780509117; c=relaxed/simple;
	bh=H+YRN50ti4Grpn8ET1M09SLuCSzIJzfWGWGfUWMrwok=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uJLnin7Tg7nTWy0c2UPMNQC3FzTEZ9Td3Bda4AhmIw1olidewlfo4EYCRsV1anxL5GCkuJyO/ssrrC5NcyMUVTEEq67EB5uyBARPKJ/QtQShP+KmH9eTGQS9099Un+PQVJP0Nh0bMbKZnW7oTQm6JY4qyfXDzOPnM+ig0NHspA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=WuP+0E6w; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="WuP+0E6w"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-9155183b42cso126365185a.0
        for <dm-devel@lists.linux.dev>; Wed, 03 Jun 2026 10:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780509115; x=1781113915; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lGadk6YfHL21xxiQKKbv13C83ROX9RWh0yIQE3Hkep4=;
        b=WuP+0E6wwi/stPRUxJzp+Ud5nbo4qS3vx08SPcRfmFw/HxJZMB6MRe5VjzAqALaCw1
         nyawHPe6Bz34kL0jj4UzbCDJM6vJ+ThFfjS87oIS1k4UTJ88woNbs6u9DNk1rOH+2SDh
         XHkNqu56Bk6MIC8Q3pKbV5FJjC6cEvIi2mH1iVMZ5Iazw+7zwjiHW9JSh5mOiuoME7Xe
         P+Cg1AO753qTOq6EvcfYkhHqfIM6Gioq8rlOmtYFopfgQfR5lIUXXoMovUsGApofPYWK
         x/CBPfrikMjftqlWZhY7oNaR3Sy69R0JVk55FMhJLuejy/Xpoz3m1rdUTGRanmfAOZQT
         W/GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780509115; x=1781113915;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lGadk6YfHL21xxiQKKbv13C83ROX9RWh0yIQE3Hkep4=;
        b=DGPZseKdWx7A/CYOxo7EoksrXABTU0wfLRXQTm5M5ACaCo+i/QYv+zMkD48MBQviaG
         VDUox3JCKK2XEdmluU14YMDvfMogAmNjK77+rKtWnqLljhYrqSaDEF7+bGsLYBeWB60M
         cYrxoES2erbXX35sgRMGWDgE0VBAdUux3pKEHpLMktubaKcUkb8WbH6CdIWnieqxHVoE
         ZNED5YbGwx1TL8QsCYzOw9JFanZRy2usf0mL/xrHramAtpONEVHWHKBBQWItb8YqUsSS
         7evxRwGyL7Oug1c3m/ikp/baj9qDkqEtODsfpUaqC8847exsYFpH/KnzSQugpQJxfAYn
         9pzg==
X-Forwarded-Encrypted: i=1; AFNElJ9CryNGHTDa8gKclRkhhXv81cqfj4WsH5X68UPjfsv53uhjXHfRlsGEqpyB25N836cWIoz1/jF1+Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YwesG/i8CAgLuznTHg8v3gp4f4geqN0Dk/IuI0y/ZoZb3L01OWT
	ImBKaa73pzuR9QJ4z/1P5fWDapdO6cMW4BKnDDaIIXuYxHZolnmBkNY+6GW4cn/pcG8=
X-Gm-Gg: Acq92OFDSAtkJa+rZQTc29BAFVfv3xw+cwKhPTytLBQu5y8jOAvVMi3PB8XzMhjC98B
	nFcoYsCIb9QL10SpF2EDxxub6YUbdKvk1LfquIxeluG8yIE964OtRLuYezULZfMuchRzC7oojCN
	dAMRyD+qGnBYE1bnL7ZP1gbmICRWJ9vKc13ffBZqZBiqRlmldOLWUcekiCXtSEUiGjyT/ZKkyrQ
	19528vEc4kKibvdaWh/DFADKMeVfBVxbksS29/Tq24NBMcRLACY8cxl7dFPQfzdQMYBsBsCe+8b
	5xvfpaiOeLn5ZcNoVpusqJSY9PdpulTK9o3dzaUfjIwCmfSunj230Ht6RE6o0+IucU8zK5UeCLO
	T+0cF3PVi60HyXsOsaiQBawnJrVMXCKS58N8OwNuSgRR/in3UvUM4pC+NY4m+xBg782LMBTwNH3
	Ml65YoEDetehKQE+8NS7LKVSayqnIN6/rkIMDBDw==
X-Received: by 2002:a05:620a:a410:10b0:90f:786c:4a82 with SMTP id af79cd13be357-9159afd366dmr49606685a.39.1780509115338;
        Wed, 03 Jun 2026 10:51:55 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-9158a00b104sm323202285a.4.2026.06.03.10.51.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 10:51:54 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: Alasdair Kergon <agk@redhat.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] dm ebs: drop dirty bufio state when discarding blocks
Date: Wed,  3 Jun 2026 17:51:50 +0000
Message-ID: <20260603175151.25026-1-sam.moelius@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm-ebs can discard a block while a dirty dm-bufio buffer for the
same block is still cached.  If that buffer is later written back,
stale data can be written over the discarded state.

That resurrects data that userspace explicitly discarded and breaks
the expected discard semantics of the target.

Invalidate or clean the matching bufio state when processing discards
so that old dirty buffers cannot be written back after the discard.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
 drivers/md/dm-ebs-target.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
index 1e52bde48b91..9fece535a0b3 100644
--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -212,8 +212,12 @@ static void __ebs_process_bios(struct work_struct *ws)
 			write = true;
 			r = __ebs_rw_bio(ec, REQ_OP_WRITE, bio);
 		} else if (bio_op(bio) == REQ_OP_DISCARD) {
-			__ebs_forget_bio(ec, bio);
-			r = __ebs_discard_bio(ec, bio);
+			if (write)
+				r = dm_bufio_write_dirty_buffers(ec->bufio);
+			if (!r) {
+				__ebs_forget_bio(ec, bio);
+				r = __ebs_discard_bio(ec, bio);
+			}
 		}
 
 		if (r < 0)
-- 
2.43.0


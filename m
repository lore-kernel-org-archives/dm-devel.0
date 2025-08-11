Received: from mail-il1-f227.google.com (mail-il1-f227.google.com [209.85.166.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73CB26FA4B
	for <dm-devel@lists.linux.dev>; Mon, 11 Aug 2025 05:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754890836; cv=none; b=BRNdHtnz363+BUxWYXLXeHA245kI+JjnTlnbzR249dd7+I/0aKZBJsfgaOXN+Vee+W8H9hFkiW+nW+b7cIto18fJInCYp669s0FqbYwCm2HLqZeSWFlTB/D78vZWqTeYe+bYoSSw8UEBcjYGVBOjHmhy0r/+V7wBHXRArG8vPxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754890836; c=relaxed/simple;
	bh=X+DIeX+XsZPowEusZeMzAlLnoQlmyKNcBOTFUWpiNsE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ipAeOwGJXCywMS+f3nIGz8/x92R0JwCx2g4CWbAVN5YtAuscIxr+2RmysBF7awr/pLtVzpuQFcB0mlRx4xdr7LOzHhrfwVJ7BPS5GsbcnCOPJKh+/ZR/AR15LoV3wmqrvpgop4Hq06abD9FIDZkdhiJKrIpa9zJijniRM25mwGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=W0gedSst; arc=none smtp.client-ip=209.85.166.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="W0gedSst"
Received: by mail-il1-f227.google.com with SMTP id e9e14a558f8ab-3e53c490c22so4811365ab.0
        for <dm-devel@lists.linux.dev>; Sun, 10 Aug 2025 22:40:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754890834; x=1755495634;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fpH6x8rZ+rgBdQ7TOKJbwRYB5Ad7cxy49v5qCgwdE24=;
        b=dmyu56LMd0khndrfso25/YcbcDvaXmbjc0+KpGNlQvtpI83gGo0YpgroYvLgwfZwkx
         QYoxVSTsA2b6rWPFdFxG3j2JJphM1BuUKrGxpXKbvunZbcny39x8HzhODy7X483mK7I7
         0mrGoULsRuPwoGar0Sm84i50iCAtAuDV8+ANqxvkz4AgrpI8NdhPdUzOjDV17Uo3IsQG
         K+DHlV3lsFNO1NhPCayMAguSG247H9IAfUjOILqFhi/+IcPayzdPEWsRqu4lSk4qETVH
         qqWZqKdKc+tpEEr1r2hARq6JFRWgJwi/wZFVHf4V+/Uh4siKe6Qy9YKsn74WsJLlkMZQ
         WE/g==
X-Forwarded-Encrypted: i=1; AJvYcCXWgxiI7pq8/tx6ShrhMcCav39MIxVXUgR6+Azkofai+GMbJhDRzmQaPlo3p9rXeDwXm0janEk8pA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwhQ3eIk35dRIx1fFJBYyq85nDYeLj+xSVCsdrLhY3dW48iCfkY
	2zYo7Luty5l1Zc7aQJ/7H2VNAkuV8tjfEL9dY5c+hn8xklQWycxGrS41DxRxBWb7z+B++n5Ezae
	xxoYA3r7fkK+ugR38OwG+Esxtdt1DlfAmVEQeLrZ6S46zOcNVB3cfQ/KRgRgvVDcxmvn+ya+txE
	9CJ8InUKIpBQJQsbj/P/IMZOZTVczeP1k/16yxdjRc+0p3jqw0MsHA/rs4S1/pnmQgwF+NMRAea
	Dx20ZX6I6XFhTsFk4qM
X-Gm-Gg: ASbGncughDadA2AlOU0BXIqFiIFmodfVtWgQjxXyX+u21blbRecohx6LMMPpr1Y+ar3
	JuFnLsaUcjA2cjD5J2LBlUSa0igoVflV6/4tSSjQpg+T36wT7lG5TT9BbzOPUoyKiaa10nWtSfQ
	fQaICjzT9dgur0WrzR1lJle0ZO9XK71KYPYg79pk/YIkhzLsBTP3vyaBD724+crSFYtTuu8JYnW
	fliW6zSp078o1bhloWO2yz5nZzKIoKW0Pxtp1PJDJxv0W0h9Ctkjax9T6bdqwyHWsglm9ewsdDn
	gS7dpTBkbMWFCb21oulhuQgvgVY0C5usPKqLa2Op1pu9xOUT9Al/3GtxwlT4qffygT8V0peP3SW
	OO8UYVuTIuptopSKa6HnhVRQTMEy1yGtXrGzdKgSrPygN2HHgBLdQ4Lwu78uDc4hiDuFu+Nk0u3
	ID
X-Google-Smtp-Source: AGHT+IHKHMCpFrCZKpF1SwkWTIziFfzWYqbbOr5W7t2nzmyOk4i2usuT7haoasTCEXm9mtMmTRaLTIhc0bpF
X-Received: by 2002:a05:6e02:1aa4:b0:3e2:77d9:f8fc with SMTP id e9e14a558f8ab-3e533aff877mr190796575ab.10.1754890833927;
        Sun, 10 Aug 2025 22:40:33 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-0.dlp.protect.broadcom.com. [144.49.247.0])
        by smtp-relay.gmail.com with ESMTPS id e9e14a558f8ab-3e533cc0fb8sm5850155ab.30.2025.08.10.22.40.32
        for <dm-devel@lists.linux.dev>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 Aug 2025 22:40:33 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-7074bad04efso91412556d6.1
        for <dm-devel@lists.linux.dev>; Sun, 10 Aug 2025 22:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1754890832; x=1755495632; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fpH6x8rZ+rgBdQ7TOKJbwRYB5Ad7cxy49v5qCgwdE24=;
        b=W0gedSstviPOXCB0LraoiOFbnBZbz3eRVpTpnLpsatk5E6J27b5HrOWiRsRbDqSST2
         FTadIR5vxuQ9je+5jaYHycmXWjGSylTRAh4XkjY/vfhU0AmO8eqitsV5rAlSEZn/dAkX
         lgtn9/uvzX6uVdUL74hzYRcUFMgZv5oufvJRM=
X-Forwarded-Encrypted: i=1; AJvYcCUnKwff6Lzc71GRsV3QWCXS+RLWxlqY3y2S9KmCkCz1HqxuNjk6MvQiJMTz+0YSVKMWh6F7yjTCow==@lists.linux.dev
X-Received: by 2002:ad4:5d63:0:b0:6fa:abd2:f2bb with SMTP id 6a1803df08f44-7099b97d506mr154030646d6.8.1754890831934;
        Sun, 10 Aug 2025 22:40:31 -0700 (PDT)
X-Received: by 2002:ad4:5d63:0:b0:6fa:abd2:f2bb with SMTP id 6a1803df08f44-7099b97d506mr154030466d6.8.1754890831489;
        Sun, 10 Aug 2025 22:40:31 -0700 (PDT)
Received: from shivania.lvn.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077ce44849sm150544766d6.84.2025.08.10.22.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Aug 2025 22:40:31 -0700 (PDT)
From: Shivani Agarwal <shivani.agarwal@broadcom.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: bcm-kernel-feedback-list@broadcom.com,
	linux-kernel@vger.kernel.org,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	tapas.kundu@broadcom.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	dm-devel@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 2/2 v5.10] dm rq: don't queue request to blk-mq during DM suspend
Date: Sun, 10 Aug 2025 22:27:02 -0700
Message-Id: <20250811052702.145189-3-shivani.agarwal@broadcom.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250811052702.145189-1-shivani.agarwal@broadcom.com>
References: <20250811052702.145189-1-shivani.agarwal@broadcom.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: Ming Lei <ming.lei@redhat.com>

commit b4459b11e84092658fa195a2587aff3b9637f0e7 upstream.

DM uses blk-mq's quiesce/unquiesce to stop/start device mapper queue.

But blk-mq's unquiesce may come from outside events, such as elevator
switch, updating nr_requests or others, and request may come during
suspend, so simply ask for blk-mq to requeue it.

Fixes one kernel panic issue when running updating nr_requests and
dm-mpath suspend/resume stress test.

Cc: stable@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Shivani: Modified to apply on 5.10.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
---
 drivers/md/dm-rq.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 7762bde40963..a6ea77432e34 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -490,6 +490,14 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct mapped_device *md = tio->md;
 	struct dm_target *ti = md->immutable_target;
 
+	/*
+	 * blk-mq's unquiesce may come from outside events, such as
+	 * elevator switch, updating nr_requests or others, and request may
+	 * come during suspend, so simply ask for blk-mq to requeue it.
+	 */
+	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)))
+		return BLK_STS_RESOURCE;
+
 	if (unlikely(!ti)) {
 		int srcu_idx;
 		struct dm_table *map;
-- 
2.40.4


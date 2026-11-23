Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795466077;
	b=mQYSFi5NpZ9o08uY6U+Pzqpf7GhjFUy+x73V/Deg2KOSrMhDl+HcO7stFI7ItdcsqNB5
	 EXUFcGb6TuZMSIMTjqVfZlW8wRmv7aIj9RUOK5G54mcpM7tEoa7g6MnWog3qqgRLQdQaD
	 zPGM3OLZOpajlxTiS77KFzm66Q93uOI8f6r3TTsuNWMhzoz8Wq5Qj8FcK1pY3ifLwvu+M
	 4nCafs7tBbccDJeX/tFzgu38V3JJIxDjF3OG/NLGKC3WejgsbpasPE5yKGasOxjiaRta0
	 jBsPK8CKG5jp5/DOc/AqrrxNDDzmiFTSZ9MVGpgn1ZmfwvnIx1fdB06s+8JuF9E2yQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795466077;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=6D1L1HWYJhyUpOeTtQIUZeke2hr8L4TI6fulnbgEFlU=;
	b=xa/tvF7ZEsRVdYcpRbGV36H/4Ay1hxZzfj0W7bPZDVIqGhf8T5o47UYhaivLPIPf/VRF
	 NzFOrtUdLByFOBHsg/rZsMS3Owx5u/yWHBbB+zTzfUT7uN1asSgv+X6wufiW2G4j4s4CZ
	 WrUmuuRl4ga2xwyeB/zOBJW/WXNtxTmozytuhiG4sVpt58lwwDmQIyejPVaXuDahnA2JT
	 cSMy9e3N56RxNTknJMLZ3u4qaqp8sNRGEQIgaSlXB+j/LBt8C0yOuXrytkOE1waS+vd1c
	 vs7Neq78B19byrOFZqifbSCYGzCSv87wRSPznnbx0ONOFVPlHCXPH92aW+d6Tj48/bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=jakejoyner.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=74.125.82.179
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A66606A32D
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 20:34:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8A66606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jakejoyner.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-384d1928a45so279972eec.3
        for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 12:34:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795466076; x=1796070876;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6D1L1HWYJhyUpOeTtQIUZeke2hr8L4TI6fulnbgEFlU=;
        b=DtltnElFSbxcAJrgC4l1Mnw9Xw5zmDq35mIe6ErrLGQWRUcGFoKOaYz4BSYxy5+hh5
         hOk2GZOqXLA7C3HsOUWn/Q03EXdaTp+0QWiWBNNcCEWRFZehRlLTuWp/bcKWW3TxiKYh
         1T81zRPeemRp5S9UFlfK572pU5QpFEonO0Bkfz4klda4WkRpYObmS+W+8C61Az8XA/xO
         lrmfaKkfiqgKt9OALauEkEbfpOm0+CjPjLbZB+OgG/xiPxhhrBuJTzSdZpXGD7sxxiNr
         t3x2rpsHH6WMHVQ/XNfJK31rjG8qr0qDPOQcPNMoGBen0W/eshHU10d5+svDBnGdc8CH
         DANg==
X-Gm-Message-State: APuU4Z+G5kmKf+lgvuI/ANKd6xb8HFE8/LGDiUqOQzwqkGYLi2OZpfQB
	+8p651VJY1GrEi5jC1nBX7cZOWBR/znBCvMr9e8ElW71Rjt+TO0t0u8n
X-Gm-Gg: AZFdTZebEmWqHYjbGnseeVQ6W54AgcyoDoiewe3uHCJuNKr0B7zR1sgoUuRLQu7WP0M
	vGzoM0ovxYLnopoO94LiQs9ZsM7bJZ4tK5HGHTB3l52RUeKxGr+pU77J5ydoLjoCBPVHukP95l5
	TXSN6/b+Ay2dK9PA8UDvP2oOS+EyWqd816VYG+XBh13NloYsuMToFAVroWsSVKLC6WZxzT9GLMB
	fWmlyMAlSBrypO6gB/ZqCKasoA+QQwhcqjA7s/twdmJ1KAJ/9FoI9ODPNtp4rsfNMk+/x/Wg3Us
	nYe9EmctyXB+L/FFtZy4RiybfSz/4esp1BX5wS7VnRgt2+ofXspH/braFznu1bXDmZjlt6+zRWm
	I3CkZCNdEojx1m24VioJVFRCho2Pma/JY5/yXRKK63s19hFY29r9aXjoO6/qQAaq4NMRfOWpGMz
	BDdwCqiGNzyilnHw3x1M7CtKYPyEfXnt+EenocK8R1ltXUwEmnlQXOMCzrfSazJ8/3Wfl0Uahfl
	g59WR82c6voSVVrJWejyQOZTmw0sugbH3ZMDIkYQzImdbam1OsB/72ChrfLWGVz3lww2z/KgiUA
	gsAV9+4lw7ZVRQ1rG7FOL/1E8k0BPvqp/28BeCyIHLVxqbQNiAx6zmtB4g==
X-Received: by 2002:a05:7301:2624:b0:385:1a45:47b3 with SMTP id 5a478bee46e88-3856e24682amr20580204eec.1.1795466075720;
        Mon, 23 Nov 2026 12:34:35 -0800 (PST)
Received: from localhost ([47.156.153.166])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567ea2cc5sm36001274eec.29.2026.11.23.12.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 12:34:35 -0800 (PST)
From: Jake Joyner <jake@jakejoyner.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jake Joyner <jake@jakejoyner.com>,
	syzbot+3f8f5b65af8de862dcec@syzkaller.appspotmail.com
Subject: [PATCH] dm-verity: fix shift-out-of-bounds when computing hash level sizes
Date: Mon, 23 Nov 2026 12:34:13 -0800
Message-ID: <20261123203413.145298-1-jake@jakejoyner.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

verity_ctr() computes the number of hash blocks at each level of the
hash tree as

	s = (data_blocks + (1 << n) - 1) >> n

where n = (i + 1) * hash_per_block_bits, i.e. data_blocks / 2^n rounded
up.

The loop that counts the levels only stops once
hash_per_block_bits * levels is 64 or more, so n can be 64 or larger for
the top level. For example, with 1024-byte hash blocks and sha512,
hash_per_block_bits is 4, and a large enough number of data blocks gives
16 levels and n = 64. Shifting a 64-bit value by 64 or more is undefined
behaviour, and UBSAN reports:

  UBSAN: shift-out-of-bounds in drivers/md/dm-verity-target.c:1598:38
  shift exponent 64 is too large for 64-bit type 'long long unsigned int'

data_blocks is non-zero here (levels is 0 otherwise) and smaller than
2^64, so data_blocks / 2^n rounded up is 1 whenever n >= 64. Use that
value directly instead of shifting.

With this change the syzbot reproducer no longer triggers the report on
v7.4-rc4 in QEMU, and the table is still rejected with "Hash device is
too small".

Fixes: b1bf2de07271 ("dm verity: fix inability to use a few specific devices sizes")
Reported-by: syzbot+3f8f5b65af8de862dcec@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3f8f5b65af8de862dcec
Signed-off-by: Jake Joyner <jake@jakejoyner.com>
---
The code change is mine. An AI assistant (Claude) helped me reproduce
the syzbot report, reviewed the change and helped word this description.

 drivers/md/dm-verity-target.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 306ed1f6c118..78fe3c8f23b4 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1593,10 +1593,13 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	hash_position = v->hash_start;
 	for (i = v->levels - 1; i >= 0; i--) {
 		sector_t s;
+		unsigned int shift = (i + 1) * v->hash_per_block_bits;
 
 		v->hash_level_block[i] = hash_position;
-		s = (v->data_blocks + ((sector_t)1 << ((i + 1) * v->hash_per_block_bits)) - 1)
-					>> ((i + 1) * v->hash_per_block_bits);
+		if (shift >= 64)
+			s = 1;
+		else
+			s = (v->data_blocks + ((sector_t)1 << shift) - 1) >> shift;
 		if (hash_position + s < hash_position) {
 			ti->error = "Hash device offset overflow";
 			r = -E2BIG;
-- 
2.56.0


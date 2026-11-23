Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795467952;
	b=CedicaGj2GUN1+XTnOd6GrxXks8/jm1vb+IPD3Lri9ZhPd67JVUJP8EbIY/xcaOPDNDx
	 /w9m5EguFKyibni1hSJuHY9hQHoBth049tB0vQBRKPc3T9r127pbLuT4UX+t9L4b7fQT4
	 wqvSpMpCPCuh/TYuwP83M+pd1db1lRVDbqj+MpT7WDD/lADI05z4lgVsPLgzGBPP7384s
	 Y13g6GahQgVZmvB55Wl8SeN9g7iemWsVv7ybjm0mcCewNDlrZ+W2Pp831HKozClQgHnic
	 EbwB6UcHDJU9UL8rlbSVjVKm3brF6PNRVG1lMdJT7TlcWhVOrCFgVYROQeR2XOWd8WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795467952;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=UEawjYf4KP5VSikDXKhRYVtZcdIPXAkEsckpZehMyOQ=;
	b=phKyQ1JmDb4c1vnLU4B5UY+o9EHfVQCk6UWHfc/a9P9nQ//467QEAW8gwyNQZ29FLKvX
	 mAidSXPDm6IkzseaK5gMvAXxEiwEc9nqoJfMi7xwzt4fm3AFXmQalcr8dpfchLFIHyLTj
	 iIdAoUl8Q84uiUTBHnYkyd/WMv6BZW6JcEMlwDw0QD0GP4NxCuC1EWLhNHhisIdyxnNx8
	 idAOUJhL/zM8aV++d7Hl+3RjVGMLRklffSnMGllD90yZiLW0z3HBDZacUSyzBMiZWTF7p
	 WPeSWvYRx43aokiRMYp0uYaa5+ZjqEEZ0/ydmWo1dcEGtXuyJR8ny3Oi5XTKc+/gPaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=jakejoyner.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=74.125.82.173
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22659606A326
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 21:05:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22659606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jakejoyner.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-35159e0092aso243039eec.2
        for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 13:05:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795467950; x=1796072750;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UEawjYf4KP5VSikDXKhRYVtZcdIPXAkEsckpZehMyOQ=;
        b=oBi3WSNIN+K7gh+ARYqe1tzUm877eYRwTEQbxt+3qv4X2LY/U8Wgk9zz2q/KyexwIH
         0mwKryD6uEQ+VrQTiKaKJ27Bc9T+KfBmELqh6mAl0Kp9Pd6Rj6Lg69BrpiSWWGkoDQ9k
         8IV239HDHEocp8p7hgYp/4C/9PlyWor5qZGZRL1cAsGoUitgR/sd3QQjUD5Uz0Z5kVmB
         Yvy7g5z0UGhIucnrIAwDEpmq6tYyxtyjGZfeOfHiaccmAHHPPa/iTwgSUY2ho3JGZ8/a
         HDMF232W/FTo3cbOcTrTpLA9yoy9TiH/jpC8DCBxg0FlqvneB17gd/QjReWfH8n+eEIv
         cP4g==
X-Gm-Message-State: APuU4Z+ChR/QdAr/gF9VEX5gIrYuEUOC9h2Hh3iSvwRbNCS/Mxg97B9J
	YjUC1iJPKKuzakIStKDssuAMW/RCkx3qFkSKvhTSsoLk4aIrY9VI+GSS
X-Gm-Gg: AZFdTZdbsGgHG4YfQS8HzZ271bTWB+wcYINPiHjQaNiMoS9x8SMipKe7PL29OIxn+/l
	w56sdQEFY91lsN3DmGtV1ftWcFlNvc9dIXktfHUKorb6ZKyhc9MOJi793cfYOKjuFbBYcNfHZyf
	3T4Do2PQF5guIdRJPhOWGISd2a60YcyNFql8zdJBuHIcInoDml/9cYHw1vy5hyKwawJ+UikZVBs
	8MiXygAl9ipVO1qlCf9KOWEKjaEtjVq/DgTGnjTabu1h78sABo+BeK1oLMtNlHmGSqi1qn3Rqv3
	XcdaQDpbYrB/ooDuSNkKbI7Xr88kiF/9gXXMllz4rnkWs7Y/hO6awuTpGNrpFLq/c6O75iNMoNV
	J7rns/xNvZaXkpDYk9nahsCL6H/HN+WNaCKntYRz5GLbkp9UapK0t94HAcn3vAYA7RkIj04L80P
	FjhG1TrKMJSk6qXVu3wBRGJt7wfjFw3/EpHn45+BYExoC/V3etYxD4nj/UvP/SIAhq/5c/v+dCo
	2nICT+jOR/wc8JQeaTjd9toHAY6oVk72BCd31iVmHmqt8McszRYQxmwcaeiKnf1zrWFM4ZggeR4
	P1SQZJ/Er2QtqNpIUrVDHHZ9K/PPen56JFKNqU7pMjOfmpPEOPlmxjlaMQ==
X-Received: by 2002:a05:7301:6187:10b0:386:a8e0:ac22 with SMTP id 5a478bee46e88-386a8e0b29dmr9138288eec.0.1795467950091;
        Mon, 23 Nov 2026 13:05:50 -0800 (PST)
Received: from localhost ([47.156.153.166])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38566cd46c5sm46614607eec.11.2026.11.23.13.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 13:05:49 -0800 (PST)
From: Jake Joyner <jake@jakejoyner.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jake Joyner <jake@jakejoyner.com>,
	syzbot+3f8f5b65af8de862dcec@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH v2] dm-verity: fix shift-out-of-bounds and overflow in hash level sizes
Date: Mon, 23 Nov 2026 13:05:44 -0800
Message-ID: <20261123210544.196717-1-jake@jakejoyner.com>
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
up. This goes wrong in two ways.

First, the loop that counts the levels only stops once
hash_per_block_bits * levels is 64 or more, so n can be 64 or larger for
the top level. For example, with 1024-byte hash blocks and sha512,
hash_per_block_bits is 4, and a large enough number of data blocks gives
16 levels and n = 64. Shifting a 64-bit value by 64 or more is undefined
behaviour, and UBSAN reports:

  UBSAN: shift-out-of-bounds in drivers/md/dm-verity-target.c:1598:38
  shift exponent 64 is too large for 64-bit type 'long long unsigned int'

Second, the addition can overflow. With 512-byte data blocks any 64-bit
number of data blocks is accepted, and for data_blocks close to 2^64 the
sum wraps around, so s is far too small (0 for data_blocks = 2^64 - 1
and 1 <= n < 64). The hash area then appears to need almost no space,
and such a table is accepted on a small hash device.

data_blocks is non-zero here (levels is 0 otherwise), so compute the
rounded-up quotient as ((data_blocks - 1) >> n) + 1, which cannot
overflow, and use 1 directly when n >= 64, where the quotient is
always 1.

Tested on v7.4-rc4 in QEMU: the syzbot reproducer no longer triggers the
UBSAN report, a table with 2^64 - 1 data blocks of 512 bytes is now
rejected with "Hash device is too small", and a small valid table still
loads.

Fixes: b1bf2de07271 ("dm verity: fix inability to use a few specific devices sizes")
Reported-by: syzbot+3f8f5b65af8de862dcec@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3f8f5b65af8de862dcec
Cc: stable@vger.kernel.org
Signed-off-by: Jake Joyner <jake@jakejoyner.com>
---
Changes in v2:
- Compute s as ((data_blocks - 1) >> n) + 1 so the addition cannot
  overflow, as pointed out by the Sashiko review of v1.
- Describe and test the overflow case; add Cc: stable.
v1: https://lore.kernel.org/r/20261123203413.145298-1-jake@jakejoyner.com

The v1 review also noted that verity_prefetch_io() can underflow
hash_block_end - hash_block_start when v->hash_end is wrongly small.
That path is only reachable once verity_ctr() has accepted a table whose
level sizes do not match the hash device, which is exactly what the
shift and overflow above allowed; with the sizes computed correctly such
a table is rejected at construction, so the prefetch path is no longer
reached. I did not add a separate change for it.

The code change is mine. An AI assistant (Claude) helped me reproduce
the syzbot report, write a table-loading test, review the change and
word this description.

 drivers/md/dm-verity-target.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 306ed1f6c118..6b6b9116fc28 100644
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
+			s = ((v->data_blocks - 1) >> shift) + 1;
 		if (hash_position + s < hash_position) {
 			ti->error = "Hash device offset overflow";
 			r = -E2BIG;
-- 
2.56.0


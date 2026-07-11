Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E51723EA84
	for <dm-devel@lists.linux.dev>; Sat, 11 Jul 2026 14:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783779824; cv=none; b=W0RCNGO4HFYhM3jmIOgQ3Y1qL3YXis/jPpcXMFOZAprcgYPwo7fQso47HjC9h0WPaIFi43JFrybe7x34m6qyPuhLZ+Jvm91YrNytSOeU/u/lEYdM6mCjuKD5WRq7WzfhPtzrqs7kUU3LJsWJijL2K54/8a+qN6ZYLIYcZgrYAG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783779824; c=relaxed/simple;
	bh=qx7DtuNcw6rOQv9dA98LzpNw872X413+KqH9LTc4PEk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cR/abIif+uocCAHzklye44GyVeVkrenjPyAweFbb9vbHSAgxPfOg1Op8R4k0+h7l+4NV3FlgbmYqt7vmYWkS0CtCkxmoCLqOeCIGTiDRm0TguFOE6d6OewQQao1mus+zGtryRnGv7OFp4kr59gTlwujr61NcUhaeTLlVG6G2Ws4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from DESKTOP-L0HPE2S.localdomain (unknown [111.199.64.102])
	by APP-01 (Coremail) with SMTP id qwCowAAHn8fiUVJqyQGFBQ--.27760S2;
	Sat, 11 Jul 2026 22:23:30 +0800 (CST)
From: Haotian Zhang <vulab@iscas.ac.cn>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Haotian Zhang <vulab@iscas.ac.cn>
Subject: [PATCH] dm-switch: use WRITE_ONCE() in switch_region_table_write()
Date: Sat, 11 Jul 2026 22:21:55 +0800
Message-ID: <20260711142155.20727-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAAHn8fiUVJqyQGFBQ--.27760S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Xw17Jr1kKFy7KFW3Xry5urg_yoW8JF1Upa
	4rtryY9FWaqF13Z3WUGa1q9as5Cw47KFyUCr47Ga40va48Xry5JFW8Xa4aqFn8AFWxJ3W5
	XrWUtr1rGw4rJa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUBVbkUUU
	UU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAAFA2pSUF4CPAAAsC

switch_region_table_read() accesses the region table with READ_ONCE()
and is called from the lockless switch_map() IO path. However,
switch_region_table_write() stores to the same array with a plain
assignment. This results in an inconsistent access pattern for a
lockless shared variable and may trigger data race reports.

Use WRITE_ONCE() to pair with the existing READ_ONCE() in
switch_region_table_read().

Cc: stable@vger.kernel.org
Fixes: 99eb1908e643 ("dm switch: factor out switch_region_table_read")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
---
 drivers/md/dm-switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-switch.c b/drivers/md/dm-switch.c
index 5952f02de1e6..e5b507b4fa7b 100644
--- a/drivers/md/dm-switch.c
+++ b/drivers/md/dm-switch.c
@@ -184,7 +184,7 @@ static void switch_region_table_write(struct switch_ctx *sctx, unsigned long reg
 	pte = sctx->region_table[region_index];
 	pte &= ~((((region_table_slot_t)1 << sctx->region_table_entry_bits) - 1) << bit);
 	pte |= (region_table_slot_t)value << bit;
-	sctx->region_table[region_index] = pte;
+	WRITE_ONCE(sctx->region_table[region_index], pte);
 }
 
 /*
-- 
2.25.1


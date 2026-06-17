Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461E024E4A1
	for <dm-devel@lists.linux.dev>; Wed, 17 Jun 2026 06:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781676074; cv=none; b=Qe/FT4c5QK36m+/PMFZELINPHitKRvTI4Ucr2UjWoJK4n317l8NpyxEoONYF+ek4S1WS0FvX1ozMgzGGiN8N5SB0rZ3Wj42BlV/2yJCsWBYp7In5bHA0QpqIgGOGbhzoAQKAQDPLuTg++TQruCe6risqbgyiWqWBLxgn8Clg6AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781676074; c=relaxed/simple;
	bh=Fu9DCvBec9Lr9HaXX52mc9yojgEhYOND9Uhrmqya6nU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oLFi+pkpQ9RXxTM880wiYVCfsbMXO77WcA8ZmVqLXMjSENjuEP36oTIBnyEo4B2Y35Rb1kHSKY/jS9sZ5Bo2tfMf7nPX5GRp2kCMJ3msT2WzEagFd17gpoCUSi5pTTxvCY0OscUq15LRU6Ub0gKv25EtkLUBEW9e7iUQk9j1uQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=DlOaGYKn; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="DlOaGYKn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Oc
	9tQtSh49xkRZuNnPmJLWNdU/5YMne4bLjFzZnQjZQ=; b=DlOaGYKn/OwkzBhOvH
	YgV1AFR7usdqpY7IqB0amubjLubfmmJgs1xRg7NNUzeNgynwCvFcHtJVp44f+EtK
	4UJzM8rL8sB8belEOsQBsLabhM2zDc16/LUUQrhII8JJEq+eSkvVIXmRbD1nKcDk
	xCP2oc27kPDzcUU1Hrr6lF1og=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wDH8pUWODJqtz+rDw--.4521S4;
	Wed, 17 Jun 2026 14:00:57 +0800 (CST)
From: ghuicao@163.com
To: Mike Snitzer <snitzer@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Cao Guanghui <caoguanghui@kylinos.cn>
Subject: [PATCH 2/2] dm era: fix error code propagation in era_ctr()
Date: Wed, 17 Jun 2026 14:00:53 +0800
Message-Id: <20260617060053.71051-3-ghuicao@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260617060053.71051-1-ghuicao@163.com>
References: <20260617060053.71051-1-ghuicao@163.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDH8pUWODJqtz+rDw--.4521S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7KFW5KFW7KF1rCry8trW5KFg_yoW8WF1Dpa
	1DJ34kt3yrtrWjga1IqF97uF1Y93W2qay7urWI9w1Skr15GrWYvFy5JrZIg3WjkFy8C3WY
	qFWYyan8WFyDtaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jk0eQUUUUU=
X-CM-SenderInfo: 5jkxxuldr6il2tof0z/xtbC-Bk7zWoyOBm+WQAA3N

From: Cao Guanghui <caoguanghui@kylinos.cn>

era_ctr() replaces the actual error codes returned by dm_get_device()
and dm_set_target_max_io_len() with hardcoded -EINVAL, discarding
the real reason for the failure (e.g. -ENODEV, -ENOMEM).  This makes
it harder for users to diagnose problems and is inconsistent with
other dm targets (dm-thin, dm-verity, dm-flakey, dm-ebs) which
propagate the original error.

Fix all three sites to return 'r' instead of -EINVAL.

Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>
---
 drivers/md/dm-era-target.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index 08ce96e8cf4f..4eb1c4f90e1b 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1488,7 +1488,7 @@ static int era_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (r) {
 		ti->error = "Error opening metadata device";
 		era_destroy(era);
-		return -EINVAL;
+		return r;
 	}
 
 	r = dm_get_device(ti, argv[1], BLK_OPEN_READ | BLK_OPEN_WRITE,
@@ -1496,7 +1496,7 @@ static int era_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (r) {
 		ti->error = "Error opening data device";
 		era_destroy(era);
-		return -EINVAL;
+		return r;
 	}
 
 	r = sscanf(argv[2], "%u%c", &era->sectors_per_block, &dummy);
@@ -1510,7 +1510,7 @@ static int era_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (r) {
 		ti->error = "could not set max io len";
 		era_destroy(era);
-		return -EINVAL;
+		return r;
 	}
 
 	if (!valid_block_size(era->sectors_per_block)) {
-- 
2.25.1


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794474792;
	b=ER1WdB7qndgoBaCV5yMT5e2TiPKgm6oQaU7sV3vgHEEmBKBGFFSRGU5zUEVFzpggYVQt
	 ZEW1Piv/Y1zTfWMnnOmr+gTZzebVSmokMdR9hwtltt0LWuo1zA2aFBAVx26vW8VPWR7hS
	 prUYF7//4bzvsOgO2BGUNcdtZ7NNqaMqVHrQ4cWE99f8A2rVWUqe+I8TKRI0dRNdUOEHt
	 WjxzFbYa+VjUbWvihmp3QLrrC/0ilH9OnDuDF84/6nJcAloimc5yrPnc4y+4ODHTdyd5H
	 2sk3zrFIFSJ/vIGWGQ5MeI6JB7G6N1NX+tnUC2MT1GHn23VIP6ElqR1t84FEyQm+Yfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794474792;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=yUZruvBPIEocxGxY1L+qkR4KftDZLF9AyW7Z6G1x5Ds=;
	b=IaX/opqHqLRmIHM+hdxIkCDJxaBU0NxyxS+gabYLfuZMkVogAGHNl4xt5jFXomBpw4wa
	 jDZFA5n36Ef9V4ChLykjsxT4+JMjcSRHPh1qeCSb9OhXjpcTLbi9925UmsXiTyC4M2DQt
	 iM+H3W9ihno7+AcvG+/F5z5c3EE1qJXUNVuSfNLcTeJRtAehj/YMtuhWUtndRpYQwKQx8
	 Qx1b3zNjfx6w/DsVkZeZvlBYFcNaz2tu37lgLlhNi3ZrVJMmwy1z5oIhTm331eE8iWTDN
	 4j6RWJD6BqHsLbf+jsGPne2+Wjpwk/tAnuZkO8BykcAT7fsEgazxEqYIdf50X1eQlMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=dQtrinCY;
	arc=none smtp.remote-ip=220.197.31.3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D8D606A88C
	for <dm-devel@lists.linux.dev>; Thu, 12 Nov 2026 09:13:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55D8D606A88C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=dQtrinCY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=yU
	ZruvBPIEocxGxY1L+qkR4KftDZLF9AyW7Z6G1x5Ds=; b=dQtrinCYkvmeCW140l
	zZqX/7DlgdkLd+WD6qpjdKWTcLXkV7ReY05NWnMP2ynUhMsD9g1xMnY6z84TNaOX
	XRWcpU5cSPW2dXj9rYJHLI6nAc0YxnBtzRlsixX3VnKX4lkdbBfmUmKRkpypMWp8
	zLfFx4oAoJjnFp7aWsClvh0cI=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgCnbDvngvVqwloxFg--.38026S2;
	Thu, 12 Nov 2026 17:12:09 +0800 (CST)
From: "Li Youhong" <dayou5941@163.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com
Cc: yukuai@fygo.io,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Li Youhong <liyouhong@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] dm-raid: fix use-after-free in raid_dtr()
Date: Thu, 12 Nov 2026 17:12:05 +0800
Message-Id: <20261112091206.1656622-1-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
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
X-CM-TRANSID:PigvCgCnbDvngvVqwloxFg--.38026S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cw4rWFy3Ar1xZFykJry5urg_yoW8XF47pa
	15XrWakws8trWDXF1DKw4v93WYgw1rWrZYkrW7Ja4rAa4YyF1xua4xKr4Y9F4DXFZ5t3W7
	Zw43tw4DWryjyFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U6mh7UUUUU=
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC+gnyoWr1gulcEwAA3b

From: Li Youhong <liyouhong@kylinos.cn>

raid_dtr() currently flushes event_work only if work_pending() is true.
This is insufficient because once a worker has dequeued the work, the
PENDING bit is cleared while do_table_event() is still running. In that
window raid_set_free() can free the raid_set, leading to a
use-after-free when do_table_event() accesses rs->ti->table.

Flush event_work whenever it has been initialized, so raid_set is not
freed while the event handler is still running. The .func guard skips the
flush for mddev instances where INIT_WORK has not run yet.

Fixes: db29d79b34d9 ("dm-raid: delay flushing event_work() after reconfig_mutex is released")
Cc: stable@vger.kernel.org
Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
---
v2: 
- Fix incorrect Fixes tag; the work_pending() check in raid_dtr() was
  introduced by db29d79b34d9, not a17d1bca5aba.
- v1: https://lore.kernel.org/all/20261112075741.1449168-1-dayou5941@163.com/

 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index ac019a0f5a92..c1f546e8c65d 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3340,7 +3340,7 @@ static void raid_dtr(struct dm_target *ti)
 	rs->md.dm_gendisk = NULL;
 	mddev_unlock(&rs->md);
 
-	if (work_pending(&rs->md.event_work))
+	if (rs->md.event_work.func)
 		flush_work(&rs->md.event_work);
 	raid_set_free(rs);
 }
 
-- 
2.25.1


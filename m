Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795170665;
	b=R/9VBjIwsDzLFCyi1wS2SJ5xRz46rPoGFaedFvnWVHnnbk3b7bpzPkqiaRGgWJOAvNtM
	 bQaQ5ld6IpRlhWeuN2m8mZJ8aIxmAXetlNO0rZ2XBlg62MCy5pg8SsMdpezp0fuZj9Rl/
	 fK/z5lhn6BrjKBPXXoToUS0KSibamk3goWe07EcwEDfheq55mRRtAlUPI7C8VnllLpqw4
	 4UUlSHM5gqLH39b7B6sgjg0YDc+uaUaQrseSGKZAtOKKGvQShitLPrfIVt0dl5eMI6TnL
	 +P5L/D6BzxBL3K0lur+CASdKUKlTNQuhGVbOlVJc6ixQ9rERPK3IWXqgey6y9C+2UEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795170665;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4NvHKXhj5jAm3S6feuHHzXaGQeaH4gvsk2BBP8dDlfk=;
	b=wcKoMn5l0kxklHHvyvcnfLXJPgpz1kYxuz4A5IyZe8FwbVjO+9ciw9Ooaf9sx5fmWYYm
	 WQs9+9IBo8QXiFXQnfMj3c+LIFWARusrUxmgtZq6cDrdn2VjuVbwvBAWUxZgMo+Fkhk4v
	 IlG/7rAWZqblx9724faGHRJ8YnPl72fG/EUaIJWBesbVitz3Qs1t9BV2GtEnXl+QB1Uk/
	 hTES1ETnFBEjWfi/CNY3Mt2X6/4pf/j29lzVrAKrK056hXARilxxZDVejlCH0RzPpEbBC
	 WDhhakIV/kTu4+Ev6l7Leo2Woc9D1MkAGRPWvNR7xKXZkw4d9sQrgYd4wwWhBL2fRSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=pTABLHA3;
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B389606A320
	for <dm-devel@lists.linux.dev>; Fri, 20 Nov 2026 10:31:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B389606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=pTABLHA3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=pTABLHA3DMizer+6TGFcFFOQEYD5yCYbfcxUXLtwzuCNVcdNUFTEYQGts+wpGdzTho5wslE0KZbYB
	 rQNaRoULrAB+fBC0cm6hRfRy2up3jS2B+cmuLGAwIovc4axtbwgx2G1dlEl3Uk+7j12xPWCcT2BGY5
	 CdSW2LbAGvqa8wm0=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app05-12005 (RichMail) with SMTP id 2ee56b0021631fe-25e4b;
	Fri, 20 Nov 2026 18:31:00 +0800 (CST)
X-RM-TRANSID:2ee56b0021631fe-25e4b
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain (unknown[10.55.1.72])
	by rmsmtp-syy-appsvr06-12006 (RichMail) with SMTP id 2ee66b00216348e-223d5;
	Fri, 20 Nov 2026 18:31:00 +0800 (CST)
X-RM-TRANSID:2ee66b00216348e-223d5
From: tongzhiwei <tongzhiwei@cmss.chinamobile.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: tongzhiwei@cmss.chinamobile.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	syzbot+1288484b13bf6af3620d@syzkaller.appspotmail.com
Subject: [PATCH] block: fix divide by zero in queue_limit_discard_alignment()
Date: Fri, 20 Nov 2026 18:30:13 +0800
Message-ID: <20261120103040.610-1-tongzhiwei@cmss.chinamobile.com>
X-Mailer: git-send-email 2.45.0.windows.1
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


NOTE: this commit is worked completely by LLM

Commit e924da7d6622 ("block: Drop granularity check in
queue_limit_discard_alignment()") removed the check for a sub-sector
discard granularity on the assumption that lim->discard_granularity
is always at least SECTOR_SIZE.

That assumption does not hold for every queue: a backing device can
report a non-zero discard granularity smaller than 512 bytes.  When
blk_stack_limits() stacks such limits, only the non-zero granularity
is checked, and queue_limit_discard_alignment() shifts the value down
to zero and divides by it:

  Oops: divide error: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:queue_limit_discard_alignment block/blk-settings.c:645 [inline]
  RIP: 0010:blk_stack_limits+0x1105/0x2d00 block/blk-settings.c:916
  dm_calculate_queue_limits+0x70c/0x1510 drivers/md/dm-table.c:1823
  dm_setup_md_queue+0x199/0x4f0 drivers/md/dm.c:2618
  table_load+0x4fd/0x8a0 drivers/md/dm-ioctl.c:1661

Restore the check, which was originally added in commit 59771079c18c
("blk: avoid divide-by-zero with zero discard granularity") and had
survived the move of the helper into block/blk-settings.c: with a
sub-sector granularity there is no meaningful discard alignment to
compute.

Fixes: e924da7d6622 ("block: Drop granularity check in queue_limit_discard_alignment()")
Reported-by: syzbot+1288484b13bf6af3620d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1288484b13bf6af3620d
Signed-off-by: tongzhiwei <tongzhiwei@cmss.chinamobile.com>
---
 block/blk-settings.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -643,6 +643,10 @@
 	alignment = lim->discard_alignment >> SECTOR_SHIFT;
 	granularity = lim->discard_granularity >> SECTOR_SHIFT;
 
+	/* sub-sector granularity: no meaningful alignment, avoid div by 0 */
+	if (!granularity)
+		return 0;
+
 	/* Offset of the partition start in 'granularity' sectors */
 	offset = sector_div(sector, granularity);

-- 
2.43.0



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.135
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793009635;
	b=0k/8Zz9PaO59WcicGPvqookiF97xvKkPkSiPsJ8338nPVoR+vVnPLsr3sADALCu5bdoe
	 Y84mw477/PGWRxW4cAtH5hwnE4SDTPiSlC+k0xLbOz3wrCKSIbn3j4PDhPzsyXxPh2ngt
	 V4Is9mKPLpgy7eViXO2Wzglo13KSLW2SjX0EVkLkPjbPLy/S3JfELvxlJpIZ9sOgSzddf
	 zZssOnFJP8w/B2+pf2aV7pBjz2Q0yAHDpC0voBs8ksKAY+4F/f9hSlwJONKNjKPQ+xF95
	 PNphQpwK+k76GrF1KNQQT01l1n625TRrVOm8jx2T4xW2r7mncu+aiadHonUcLIvq4MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793009635;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=gUvhPvbaKNcm4IjsCyO+EpYXhBhQnGVfangkZ0Iy/gk=;
	b=ciE28RjIrQkEDibIAi6ppMJyn5s5ftSme4OmyIaGsLi5aotKniFvFlniJKKdUS2KTlpP
	 q0OyngAWqdVL3RDC/vIdc1+KgMNPMWjCThF3TUM/fVPWvGyfFkUWjjfyPEGinc6wJgIcG
	 cgEnB7oQNXubXiK6KBwidyuYRq1mqmsgaVwBMN457e4YvsE7lm2IkEHisvYfB4Q6Dw5Nw
	 MjjCuPj4Az9cD5hJ5S65xNjUMhUoqJvY20+uahPtoo3Q/arQrZiHfFK0G3xSRyBc6Es4G
	 Liw7/Dr5Syww0FlKiQeY3d/vWcKsCgBCbrmS72HRmAR04WVahRvPwhD/9Vd3Eiz9ajQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=YhVjGRx2;
	arc=none smtp.remote-ip=111.22.67.135
Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [111.22.67.135])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48B7C606A31B
	for <dm-devel@lists.linux.dev>; Mon, 26 Oct 2026 10:13:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48B7C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=YhVjGRx2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=YhVjGRx2bPgQrg+vpxNIR+1EqorTf6K1/A2R2m8iS9gExFmzk7sD8tInPeHph+gv079Nqr6ZEYrST
	 H6JXGwq58XyeLQNKvOulXiTkKopP9q4uBzbG3EWB2ZI/w9a2aiRzAbeMt+k/pNbOYtaGdCsH6vIklU
	 tZbt26dxOLWqNqas=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app07-12007 (RichMail) with SMTP id 2ee76adf27d34fd-4f2b9;
	Mon, 26 Oct 2026 18:13:45 +0800 (CST)
X-RM-TRANSID:2ee76adf27d34fd-4f2b9
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain (unknown[124.156.110.139])
	by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee56adf27d8ade-aec31;
	Mon, 26 Oct 2026 18:13:45 +0800 (CST)
X-RM-TRANSID:2ee56adf27d8ade-aec31
From: wuyuehong <wuyuehong@cmss.chinamobile.com>
To: dm-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatoka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org, syzbot+1288484b13bf6af3620d@syzkaller.appspotmail.com
Subject: [PATCH] dm snapshot: fix discard_granularity unit in snapshot_io_hints
Date: Mon, 26 Oct 2026 17:35:00 +0800
Message-ID: <20261026-dm-snap-discard-granularity@cmss.chinamobile.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

snapshot_io_hints() copies the snapshot store's chunk_size, which is
in 512-byte sectors, into queue_limits.discard_granularity, which, like
all other members of struct queue_limits, is in bytes.

For snapshots with a chunk size smaller than 512 sectors, e.g. the
16 KiB (32-sector) chunks created by the syzkaller reproducer, the
resulting granularity is smaller than a single sector.  When
dm_calculate_queue_limits() then stacks the target limits into the
table limits:

	blk_stack_limits(limits, &ti_limits, 0)

queue_limit_discard_alignment() truncates that granularity to zero
sectors and sector_div() divides by zero:

  Oops: divide error: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:queue_limit_discard_alignment block/blk-settings.c:645 [inline]
  RIP: 0010:blk_stack_limits+0x1105/0x2d00 block/blk-settings.c:916
  Call Trace:
   dm_calculate_queue_limits+0x70c/0x1510 drivers/md/dm-table.c:1823
   dm_setup_md_queue+0x199/0x4f0 drivers/md/dm.c:2618
   table_load+0x4fd/0x8a0 drivers/md/dm-ioctl.c:1661

The divide fault itself only became reachable when commit e924da7d6622
("block: Drop granularity check in queue_limit_discard_alignment()")
removed the check for a sub-sector granularity in v6.13.  Kernels
before that returned a zero discard alignment instead of faulting, but
they still advertised a granularity 512 times too small.

Use the same chunk_size << SECTOR_SHIFT conversion that
io_overlaps_chunk() already applies to turn chunk_size into bytes.

Fixes: 2e6023850e17 ("dm snapshot: add optional discard support features")
Reported-by: syzbot+1288484b13bf6af3620d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1288484b13bf6af3620d
Cc: stable@vger.kernel.org
Signed-off-by: wuyuehong <wuyuehong@cmss.chinamobile.com>
---
 drivers/md/dm-snap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 797c432594d8..31676ee05514 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -2414,7 +2414,7 @@ static void snapshot_io_hints(struct dm_target *ti, struct queue_limits *limits)
 			snap = snap_src;
 
 		/* All discards are split on chunk_size boundary */
-		limits->discard_granularity = snap->store->chunk_size;
+		limits->discard_granularity = snap->store->chunk_size << SECTOR_SHIFT;
 		limits->max_hw_discard_sectors = snap->store->chunk_size;
 
 		up_read(&_origins_lock);
-- 
2.43.0




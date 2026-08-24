Received: from va-2-20.ptr.blmpb.com (va-2-20.ptr.blmpb.com [209.127.231.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFED73EEAD0
	for <dm-devel@lists.linux.dev>; Mon, 24 Aug 2026 11:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787571311; cv=none; b=CUd2Np2uVPVgP+4W5ctBF9NMTgfAjePj3jWewnISp3Qluu8jtnbWwCdIpJFkGOe51OlRLQeuCsiMrJb59upaiTJPNrGv50zsDOzk65gugKgEi5893BqFENrnINoeqXpH4lMdZmAs7aqKoAL13Cy+W8m4h3Ry2EoiK3fswBxC0G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787571311; c=relaxed/simple;
	bh=PqIQTngKUfUKdQCjKiL53dzJiOLHjFCAYQnobsfec4E=;
	h=Cc:From:Date:Subject:Content-Type:To:Message-Id:Mime-Version; b=WeEEd/82esdh3PPY8W2RdlasvlLgRCc9e8rmtPku0AjkQQEgcwDTLpfgLYJrKVzbF1ULyn7Q4daPta+B73AurkO5QQmVliDpJMt03zzXryJgoDkA1SOTxRFaTrwgA16XMLg1HkvqeIgSb4c/M9RGO+i63eM6abTIRlu5OAlSGl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=EISRR3Ct; arc=none smtp.client-ip=209.127.231.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="EISRR3Ct"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1787571302;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Cp5tF+fw8F5h4aRI1osdPnsdi/xjU14GNiBl6NZ4EeE=;
 b=EISRR3CtAJj1YqA6+H0J2fRXOsAPz3yZW3684IVTINMuWCGA1dRpOQlEf0sg4xfkwGzXMl
 r5KSaTZ3F8KnfkafZIGr5ccYrIEAuwOMiwNkULnGjK2U131dMXedIcDdjKB5/bMb8e7hNj
 OT4gSsBDWkJzElUKrL2FD6lNA08qUlgQvgVTIqgP3QH4ieAh6ilGjfAcGPcZuvhs7BtEVW
 gfI/mxA7hia9f/1GgK7ToO7WqhFx6ChN7lpTj9G7zGr3usp9j+R1vBH1DkI4OAHjvqWpQJ
 Pk1gT8hoNUDpHlrkdbf874uqc1lfsGNmprs6yiGTCCuYutE0Fjk5EjFeiNqbdQ==
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
From: "Chen Cheng" <chencheng@fnnas.com>
Date: Mon, 24 Aug 2026 19:34:49 +0800
Subject: [PATCH] dm-integrity: require stable writes for internal hash modes
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a8c2c64+5e99af+lists.linux.dev+chencheng@fnnas.com>
To: "Alasdair Kergon" <agk@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>, 
	"Mikulas Patocka" <mpatocka@redhat.com>, 
	"Benjamin Marzinski" <bmarzins@redhat.com>, 
	"Milan Broz" <gmazyland@gmail.com>, <dm-devel@lists.linux.dev>, 
	<sunyangkai@fygo.io>
Message-Id: <20260824113449.3385446-1-chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0
X-Original-From: chencheng@fnnas.com
Received: from fedora ([183.34.169.70]) by smtp.feishu.cn with ESMTPS; Mon, 24 Aug 2026 19:35:00 +0800
Content-Transfer-Encoding: 7bit

From: Chen Cheng <chencheng@fnnas.com>

dm-integrity direct, bitmap and inline internal-hash modes compute
integrity tags from the pages carried by the write bio.  The lower data
write also uses those pages, so the tag and the data write depend on the
same memory contents staying unchanged while writeback is in flight.

Without stable writes, a buffered writer can modify a writeback folio
after dm-integrity has submitted the data bio and before the lower device
has consumed the data.  After a crash, this can leave data from the later
contents with a tag calculated from the earlier contents, causing
permanent checksum failures on read.

Set BLK_FEAT_STABLE_WRITES for internal-hash D, B and I modes so
filesystems wait for writeback folios to become stable before modifying
them again.  Journal mode is left unchanged because it copies data into
the journal before computing and persisting the tag.

Tested using dm-delay over a virtio-blk test disk, dm-integrity
internal_hash:crc32c and no-journal ext4.  The D and B reproducers both
failed with checksum errors before this change and completed with
READ_RC=0 and zero mismatches after it.

Fixes: 7eada909bfd7 ("dm: add integrity target")
Reported-by: Sun Yangkai <sunyangkai@fygo.io>
Link: https://github.com/chencheng-fnnas/reproducer/blob/main/dm-integrity-writeback-race.py
Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/dm-integrity.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 1f2593f113f6..49fb7561a30f 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4044,10 +4044,14 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
 
 	dm_stack_bs_limits(limits, ic->sectors_per_block << SECTOR_SHIFT);
 	limits->dma_alignment = limits->logical_block_size - 1;
 	limits->discard_granularity = ic->sectors_per_block << SECTOR_SHIFT;
 
+	if (ic->internal_hash &&
+	    (ic->mode == 'D' || ic->mode == 'B' || ic->mode == 'I'))
+		limits->features |= BLK_FEAT_STABLE_WRITES;
+
 	if (!ic->internal_hash) {
 		struct blk_integrity *bi = &limits->integrity;
 
 		memset(bi, 0, sizeof(*bi));
 		bi->metadata_size = ic->tag_size;
-- 
2.55.0

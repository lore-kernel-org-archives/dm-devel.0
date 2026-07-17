Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BF93B7757;
	Fri, 17 Jul 2026 11:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784287615; cv=none; b=YtAlPc1G9Xaj1HXETlI9d4JiNT0fqGtWx70Bv/ujN0jS97UxEbh1IK2HfnQ0kvwZFDB2pQzr3PpB9Mx1xGEmH6YxAhhKZTVhQXJDDkdl3lXRV/7RkLfCHOvnNTsuKfdwtQR7tj0HAVIL/Dt21xl8P/QNcIHaS7HYwJmU2bXzT9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784287615; c=relaxed/simple;
	bh=wn/LXRXxnqB9USYST8Je18QAoMrDlS2b4MfrfYj0tWE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=FzsiedaS31eOPo+FQ6tqbLU7B8N6DEg4+RKf4Tkr7hhXhqH9foNd8EWOAHh/n7qbh7PpfyU7/LZPMyhAdOXuIJ0Em7gFbsy40TbW71/W+tuAMT2mGtfZipNmbEb07PjfNq3EPKlgqpG4qs7K+7/X6F6x22gdpumkWVHBddfqydI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S/AEnPyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S/AEnPyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE4DFC2BCB9;
	Fri, 17 Jul 2026 11:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784287615;
	bh=wn/LXRXxnqB9USYST8Je18QAoMrDlS2b4MfrfYj0tWE=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=S/AEnPyZzWAhT5Q/VKSUlZIhbNWhdpEkX/MiME4wBInsnlXVP65D9ktjG7lV023eo
	 SwE25MXT52h02txI0gvuGwhPCL+zv0LEMtIjjpNdH2BoOl2zxAMYtlb53iwOGijtwj
	 dQyG6RG4SYtzuH1tHoXxDVrjfVYzL1WedJ42dkxO20CWpoXjE05uTHGzdei1wt0m26
	 3BlwNkwNsajEKKpapC280P6W2c2wjBDfEnhOxtl4yO44QieBzQFSdAiTx6/c2lcHQw
	 aaNRMfkn6cSQ72EnRZyx+8uBsE1mvVnUxAc4UizwZZwnIKgeif30gwrLTlhIj5vViV
	 5F+xlAzuWZSSQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD375C4451C;
	Fri, 17 Jul 2026 11:26:54 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Subject: [PATCH v2 00/11] dm-pcache: validate on-media metadata against a
 forged cache image
Date: Fri, 17 Jul 2026 06:26:53 -0500
Message-Id: <20260717-b4-disp-4c0a0039-v2-0-19227d6e313c@proton.me>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAH0RWmoC/x3MQQqAIBBA0avIrBuYLJO6SrQwnWo2JQoRhHdPW
 r7F/y9kTsIZJvVC4luyXGeFbhT4w507o4Rq0KQHsq3FtccgOWLvyRF1I5L32hgix9xCzWLiTZ5
 /OS+lfPItsc5iAAAA
To: Zheng Gu <cengku@gmail.com>, Dongsheng Yang <dongsheng.yang@linux.dev>
Cc: dm-devel@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784287613; l=6065;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=wn/LXRXxnqB9USYST8Je18QAoMrDlS2b4MfrfYj0tWE=;
 b=9GzzESSoJqHbVh5e2VyMWUEmbdmlC8i6AWO4GDtC27IiTLpcomf+tmcwWu+ZQF2gnXORC7yh/
 detjg8ZQ0k7DIbL76n/QR8CBIyAEmx7EJoAqaQHhuW1DWcoNm3/MLBu
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

dm-pcache reads its geometry, segment ids, kset headers, key records and
the persisted tail positions from the cache device. Each of those fields
is protected only by a crc32c with a fixed public seed, so whoever
supplies the cache device on a table load (CAP_SYS_ADMIN) controls them
all. Several are used as an array index, a copy length, a backing offset
or a loop bound with no validation, so a forged image turns a table load
into an out-of-bounds access, a BUG_ON or an unterminated loop.

This series validates each field before use and fails the table load with
-EIO instead.

   1  validate seg_id fields
   2  validate geometry fields from on-disk cache_info
   3  validate kset key_num and intra-segment bounds
   4  bound the persisted tail-position offset
   5  reject a kset that overruns its segment
   6  detect a cycle in the last-kset chain during replay
   7  bound the logical key offset from persistent memory
   8  clamp the tail kset read to the segment data region
   9  validate on-media seg_num against the cache device size
  10  validate the persisted dirty_tail chain at load
  11  only hand out initialized cache segments

Patch 9 closes the most serious case. seg_num is the geometry root every
other on-media segment id is bounded against, but it is itself never
checked against the device. Because cache_dev->mapping is the direct map
of the pmem, a forged seg_num larger than the device makes a new-cache
init memset() 12 KiB past the mapping, over ordinary kernel memory --
KASAN, at table load:

  BUG: KASAN: slab-use-after-free in cache_dev_zero_range+0x1d/0x80 [dm_pcache]
  Write of size 12288 ... by task dmsetup
   cache_dev_zero_range <- cache_seg_init <- pcache_cache_start
   <- dm_pcache_ctr <- dm_table_add_target <- table_load

Patch 10 closes a writeback-side livelock. The persisted dirty_tail is
decoded independently of the key_tail chain that cache_replay() walks and
bounds, and the writeback worker follows it on its own; a forged dirty_tail
whose last-kset chain does not terminate makes cache_writeback_fn() re-arm
with no delay forever. Patch 10 validates that chain at load with the same
hop cap cache_replay() uses and rejects the image with -EIO.

Patch 11 is defensive. get_cache_segment() scans the physical segment count
rather than the initialized cache_info->n_segs, so a forged n_segs smaller
than the device could hand cache_kset_close() a zeroed segment whose data
pointer is NULL. Bounding the allocator to initialized segments removes that
possibility; it does not reject a conforming image.

Tested on a KASAN build, one forged image per field. For patches 1-10 the
unpatched vector faults, corrupts, over-reads or loops at the table load
(patch 10: a forged dirty_tail cycle re-arms the writeback worker until the
hop cap fires), the patched build rejects the image with -EIO, and a valid
image still loads.

This is a large series and it touches most of the on-media parse path, so I'd
rather it be reviewed as a set than piecemeal; I'll hold the next respin until
there is feedback on the whole thing.

One caveat on the testing above: each patch was exercised at its boundary -- a
crafted image with the field forged just past its limit, on a KASAN build. That
is the crafted-image case these patches are about, not a normal-workload run.
Exercising ordinary cache operation over time would take more than I put in
here; a conforming image loads and the other vectors behave as before, but I
have not stress-tested normal use.

Two notes for review. Zheng Gu reviewed v1; v2 reshaped those patches -- patch
1 now bounds against cache_info->n_segs, not the device count, and the series
grew from three to eleven -- so I did not carry the v1 Reviewed-by tags and
would ask for a fresh look. There is also an in-flight cleanup series on this
driver (jianyungao89, "dm-pcache: minor cleanups") touching cache_seg_remain()
and cache_data_alloc(); it does not overlap these fixes, but you may want to
sequence the two.

v2:
 - Grew from 3 patches to 11. Mikulas Patocka's review of v1 showed the
   writeback worker re-armed on a rejected kset forever instead of
   stopping; auditing the same forged-image threat model surfaced the
   remaining fields, including the unbounded seg_num geometry root (patch 9,
   the out-of-bounds write above), the persisted dirty_tail chain the
   writeback worker follows independently of replay (patch 10) and the
   uninitialized-segment allocation reaching cache_kset_close() (patch 11).

v1: https://lore.kernel.org/all/20260619-b4-disp-997773a1-v1-0-14df8aedb323@proton.me/
---
Bryam Vargas (11):
      dm-pcache: validate seg_id fields from persistent memory
      dm-pcache: validate geometry fields from on-disk cache_info
      dm-pcache: validate kset key_num and intra-segment bounds
      dm-pcache: bound the persisted tail-position offset
      dm-pcache: reject a kset that overruns its segment
      dm-pcache: detect a cycle in the last-kset chain during replay
      dm-pcache: bound the logical key offset from persistent memory
      dm-pcache: clamp the tail kset read to the segment data region
      dm-pcache: validate on-media seg_num against the cache device size
      dm-pcache: validate the persisted dirty_tail chain at load
      dm-pcache: only hand out initialized cache segments

 drivers/md/dm-pcache/cache.c           |  29 +++++++++
 drivers/md/dm-pcache/cache.h           |  38 +++++++++++
 drivers/md/dm-pcache/cache_dev.c       |  22 ++++++-
 drivers/md/dm-pcache/cache_gc.c        |  31 +++++++--
 drivers/md/dm-pcache/cache_key.c       | 113 ++++++++++++++++++++++++++++++++-
 drivers/md/dm-pcache/cache_segment.c   |  12 +++-
 drivers/md/dm-pcache/cache_writeback.c |  38 ++++++++---
 7 files changed, 261 insertions(+), 22 deletions(-)
---
base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
change-id: 20260717-b4-disp-4c0a0039-0cc25500aee1

Best regards,
-- 
Bryam Vargas <hexlabsecurity@proton.me>


